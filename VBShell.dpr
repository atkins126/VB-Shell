program VBShell;

uses
  Vcl.Forms,
  Vcl.Dialogs,
  System.Classes,
  Winapi.Windows,
  System.IOUtils,
  System.SysUtils,
  Vcl.Controls,
  System.Types,
  System.DateUtils,
  System.Win.Registry,
  Vcl.Graphics,
  Winapi.ShellApi,
  System.Variants,
  ShlObj,
  System.UITypes,
  Progress_Frm in '..\..\..\..\..\Lib\Progress_Frm.pas' {ProgressFrm},
  RUtils in '..\..\..\..\..\Lib\RUtils.pas',
  Main_Frm in 'General\Main_Frm.pas' {MainFrm},
  VBBase_DM in '..\..\Lib\VBBase_DM.pas' {VBBaseDM: TDataModule},
  CommonMethods in '..\..\..\..\Lib\CommonMethods.pas',
  VBProxyClass in '..\Lib\VBProxyClass.pas',
  VBShell_DM in 'Data Modules\VBShell_DM.pas' {VBShellDM: TDataModule},
  MsgDialog_Frm in '..\..\..\..\Lib\MsgDialog_Frm.pas' {msgDialogFrm},
  VBCommonValues in '..\..\Lib\VBCommonValues.pas',
  Base_DM in '..\..\..\..\Lib\Base_DM.pas' {BaseDM: TDataModule},
  Base_Frm in '..\..\..\..\Lib\Base_Frm.pas' {BaseFrm},
  BaseLayout_Frm in '..\..\..\..\Lib\BaseLayout_Frm.pas' {BaseLayoutFrm},
  CommonValues in '..\..\..\..\Lib\CommonValues.pas',
  JobsApi in '..\..\..\..\Lib\JobsApi.pas',
  CommonFunction in '..\..\..\..\Lib\CommonFunction.pas',
  Login_Frm in 'General\Login_Frm.pas' {LoginFrm},
  ED in '..\..\..\..\Lib\ED.pas',
  USingleInst in '..\..\..\..\Lib\USingleInst.pas',
  UMySingleInst in 'General\UMySingleInst.pas';

{$R *.res}

var
  {LaunchDrive, }AppFileName, AppFolder, TempFolder: string;
  FoundNewVersion, ReleaseVersion: Boolean;
  ErrorMsg: string;
  AppHandle: HWND;
//  InstanceClass: TComponentClass;
//  FormReference: TForm;

const
  APP_NAME = 'VBShell.exe';
  APP_TITLE = 'VB Shell';

procedure CheckForUpdates;
var
  Buffer: PByte;
  ReturnStream: TStream;
  MemStream: TMemoryStream;
  BufferSize, BytesRead, CycleCounter, TotalBytesRead: Integer;
  StreamSize: Int64;
  Progress: Extended;
  Request, Response, NewFileTimeStampString, DownloadCaption: string;
  SL: TStringList;
  CurrentAppFileTimestamp: TDateTime;
  TargetFileHandle: Integer;
  aYear, aMonth, aDay, aHour, aMin, aSec, aMSec: Word;
  TheDate: Double;
  RegKey: TRegistry;
//  StartInfo: TStartupInfo;
//  ProcInfo: TProcessInformation;
//  Success: Boolean;
begin
  try
    Application.Title := 'VB Shell';
{$IFDEF DEBUG}
    ErrorMsg := '';
    if not LocalDSServerIsRunning(LOCAL_VB_SHELL_DS_SERVER, ErrorMsg) then
    begin
      Beep;
      DisplayMsg(
        Application.Title,
        'Datasnap Server Connection Error',
        'Could not establish a connection to the requested Datasnap server.' + CRLF + CRLF +
        ErrorMsg
        + CRLF + CRLF + 'Please ensure that the local ' + Application.Title + ' Datasnap '
        + CRLF + 'server is running and try again.',
        mtError,
        [mbOK]
        );
    end;
{$ENDIF}

    ReleaseVersion := True;
{$IFDEF DEBUG}
    ReleaseVersion := False;
{$ENDIF}

    if VBBaseDM = nil then
      VBBaseDM := TVBBaseDM.Create(nil);

    VBBaseDM.SetConnectionProperties;
    VBBaseDM.sqlConnection.Open;
    VBBaseDM.Client := TVBServerMethodsClient.Create(VBBaseDM.sqlConnection.DBXConnection);

    SL := RUtils.CreateStringList(PIPE);
    RegKey := TRegistry.Create(KEY_ALL_ACCESS);
    RegKey.RootKey := HKEY_CURRENT_USER;
    Response := '';
    Screen.Cursor := crHourglass;

    try
      BufferSize := 4096;
      MemStream := TMemoryStream.Create;
      GetMem(Buffer, BufferSize);

      FoundNewVersion := False;
      RegKey.OpenKey(KEY_COMMON, True);

{$IFDEF DEBUG}
      AppFolder := RegKey.ReadString('App Folder');
{$ELSE}
      AppFolder := ExtractFilePath(Application.ExeName);
{$ENDIF}

      RegKey.CloseKey;
//      RegKey.OpenKey(KEY_RESOURCE, True);
      TempFolder := AppFolder + 'Temp\';
      TDirectory.CreateDirectory(TempFolder);
      AppFileName := AppFolder + APP_NAME;
      // Get the current timestamp of the executable
      if TFile.Exists(AppFileName) then
        FileAge(AppFileName, CurrentAppFileTimestamp);

      Request :=
        'FILE_NAME=' + APP_NAME + DelimChar +
        'TARGET_FILE_TIMESTAMP=' + FormatDateTime('yyyy-MM-dd hh:mm:ss',
        CurrentAppFileTimestamp); // DateTimeToStr(CurrentAppFileTimestamp);

      SL.DelimitedText := VBBaseDM.Client.GetFileVersion(Request, Response);
      FoundNewVersion := SL.Values['RESPONSE'] = 'FOUND_NEW_VERSION';
      // Only do this if new version is found
      if FoundNewVersion then
      begin
        Screen.Cursor := crHourglass;
        if ProgressFrm = nil then
          ProgressFrm := TProgressFrm.Create(nil);
        ProgressFrm.lblDownloadName.Caption := 'Downloading: VB Applications...';

        ProgressFrm.Color := clGradientInactiveCaption;
//        ProgressFrm.layMain.LayoutLookAndFeel :=  nil;
        ProgressFrm.layMain.ParentBackground := True;
//        ProgressFrm.prgDownload.Properties.BeginColor :=  clGreen;
        ProgressFrm.prgDownload.Properties.BeginColor := clSkyBlue;
        ProgressFrm.Update;
        ProgressFrm.Show;
        ProgressFrm.Update;
        FoundNewVersion := False;
        // Remove any existing files in the temp folcer
        if FileExists(TempFolder + APP_NAME) then
          TFile.Delete(TempFolder + APP_NAME);

// Do the actual download ------------------------------------------------------

        try
          StreamSize := 0;
          // Download the new file.
          //
          // StreamSize variable returns the size of the file being downloaded.
          // The server will return a size of 0 if the file cannot be found or if
          // something else goes wrong.
          ReturnStream := VBBaseDM.Client.DownloadFile(Request, Response, StreamSize);
          ReturnStream.Position := 0;
          TotalBytesRead := 0;
          CycleCounter := 0;

          if StreamSize > 0 then
          begin
            repeat
              BytesRead := ReturnStream.Read(Pointer(Buffer)^, BufferSize);
              if BytesRead > 0 then
              begin
                TotalBytesRead := TotalBytesRead + BytesRead;
                MemStream.WriteBuffer(Pointer(Buffer)^, BytesRead);

                if CycleCounter = 100 then
                begin
                  Progress := StrToFloat(TotalBytesRead.ToString) / StrToFloat(StreamSize.ToString) * 100;
                  DownloadCaption := 'CAPTION=';
//                  SendMessage(ProgressFrm.Handle, WM_DOWNLOAD_CAPTION, Integer('PROGRESS=' + FloatToStr(Progress)),  PChar(@DownloadCaption));
//                  SendMessage(ProgressFrm.Handle, WM_DOWNLOAD_CAPTION, Integer('PROGRESS=' + FloatToStr(Progress) + '|CAPTION='), 0);
                  SendMessage(ProgressFrm.Handle, WM_DOWNLOAD_CAPTION, DWORD(PChar('PROGRESS=' + FloatToStr(Progress) + '|CAPTION=')), 0);
                  CycleCounter := 0;
                  Application.ProcessMessages;
                end;
                Inc(CycleCounter)
              end;
            until
              BytesRead < BufferSize;
          end;
          DownloadCaption := '|CAPTION=Restarting VB Applications...';
//          SendMessage(ProgressFrm.Handle, WM_DOWNLOAD_CAPTION, Integer('PROGRESS=' + FloatToStr(100) + PChar(@DownloadCaption)), 0);
//          SendMessage(ProgressFrm.Handle, WM_DOWNLOAD_CAPTION, Integer('PROGRESS=' + FloatToStr(Progress) + '|CAPTION="Restarting VB Applications..."'), 0);
          SendMessage(ProgressFrm.Handle, WM_DOWNLOAD_CAPTION, DWORD(PChar('PROGRESS=100' + '|CAPTION=Restarting_VB_Applications...')), 0);
          Application.ProcessMessages;

// Download complete -----------------------------------------------------------
          // Save the File
          MemStream.SaveToFile(TempFolder + APP_NAME);
        finally
          MemStream.Free;
        end;
        // When streaming, the timestamp of the new file will be set to the current
        // date & time. This is NOT what we want. We now have the reset the newly
        // create file's timestamp to match that of the source file.

        // The server returns the timestamp of the source file so we can use this
        // to set the correct timestamp.
        // Get the string representation of the source file timestamp
        if Length(Trim(NewFileTimeStampString)) = 0 then
          NewFileTimeStampString := FormatDateTime('yyyy-MM-dd hh:mm:ss', Now);

        NewFileTimeStampString := SL.Values['FILE_TIMESTAMP']; // FormatDateTime('yyyy-MM-dd hh:mm:ss', CurrentAppFileTimestamp); //SL.Values['FILE_TIMESTAMP'];
        // Convert this to a TDateTime value
        CurrentAppFileTimestamp := VarToDateTime(NewFileTimeStampString);
        // Get the handle of the file.
        TargetFileHandle := FileOpen(TempFolder + APP_NAME, fmOpenReadWrite);
        // Decode timestamp and resolve to its constituent parts.
        DecodeDateTime(CurrentAppFileTimestamp, aYear, aMonth, aDay, aHour, aMin, aSec, aMSec);
        TheDate := EncodeDate(aYear, aMonth, aDay);

        if (aSec = 59) and (aMin = 59) then
          Inc(aHour)
        else if aSec mod 2 <> 0 then
          Inc(aSec);

        if aSec = 59 then
          aSec := 0;

        if aMin = 59 then
          aMin := 0;

        // If handle was successfully generated then reset the timestamp
        if TargetFileHandle > 0 then
        begin
          FileSetDate(TargetFileHandle, DateTimeToFileDate(TheDate + (aHour / 24) + (aMin / (24 * 60)) + (aSec / 24 / 60 / 60)));
        end;
        // Close the file
        FileClose(TargetFileHandle);

        // Rename the file that is currently running.
        if FileExists(AppFileName + '.bak') then
          TFile.Delete(AppFileName + '.bak');

        Renamefile(AppFileName, AppFileName + '.bak');

        // Copy the newly downloaded app to its actual location.
        TFile.Copy(TempFolder + APP_NAME, AppFileName);
        while not TFile.Exists(AppFileName) do
          Application.ProcessMessages;

        ProgressFrm.Close;
        FreeAndNil(ProgressFrm);
        ShellExecute(0, 'open', PChar(AppFileName), PChar(''), nil, SW_SHOWNORMAL);
        // Note:
        // For some reason I need to use Halt here to re-launch RC Shell successfully
        // The Application.Terminate does not always re-launch RC shell.
        {TODO: Must investigate this issue and get it to work properly}
        Halt;
//        Application.Terminate;
      end;
    finally
      SL.Free;
      RegKey.Free;
      Screen.Cursor := crDefault;
    end;
  finally

  end;
end;

begin
{$IFDEF RELEASE}
  CheckForUpdates;
{$ENDIF}

//  CreateMutex(nil, False, '{C895DC7C-AC30-4DF1-883B-F7A1B6CB274D}');
  CreateMutex(nil, True, '{C895DC7C-AC30-4DF1-883B-F7A1B6CB274D}');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    Beep;
    MessageDlg('An instance of ' + APP_TITLE + ' is already running.', mtWarning, [mbOK], 0);
    AppHandle := FindWindow(nil, APP_TITLE);

    if IsWindow(AppHandle) then
    begin
      // Restore target app if minimized.
      SendMessage(AppHandle, WM_RESTORE_APP, 0, 0);
      // Set focus to the app.
      SetForegroundWindow(AppHandle);
    end;

    Exit;
  end;

  Application.Title := APP_TITLE;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  LoginFrm := TLoginFrm.Create(Application);
//    InstanceClass := TMainFrm;
//    FormReference := MainFrm;
  LoginFrm.Update;
  LoginFrm.ShowModal;
  Application.Run;

end.

