unit Main_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Forms,
  System.Classes, Vcl.Graphics, System.ImageList, Vcl.ImgList, Vcl.Controls,
  Vcl.Dialogs, System.Actions, Vcl.ActnList, System.Win.Registry, Winapi.ShellApi,

  Base_Frm, VersionInformation, VBProxyClass,

  cxContainer, cxEdit, cxClasses, cxStyles, dxLayoutLookAndFeels, dxSkinsCore,
  dxSkinsDefaultPainters, dxScreenTip, dxCustomHint, cxHint, cxImageList,
  cxGraphics, cxLookAndFeels, dxSkinsForm, dxSkinMoneyTwins, cxControls,
  cxLookAndFeelPainters, dxRibbonSkins, dxRibbonCustomizationForm, dxBar,
  dxStatusBar, dxRibbonStatusBar, dxRibbon, dxBarBuiltInMenu, cxPC, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, dxSkinOffice2019Colorful, dxSkinTheBezier;

type
  TmyDragObject = class(TcxDragControlObject)
  private
    FTab: TcxTabSheet;
  protected
    property Tab: TcxTabSheet read FTab write FTab;
  end;

  TMainFrm = class(TBaseFrm)
    sknController: TdxSkinController;
    repScreenTip: TdxScreenTipRepository;
    tipExitVBApps: TdxScreenTip;
    tipReports: TdxScreenTip;
    styHintController: TcxHintStyleController;
    verInfo: TVersionInformation;
    rbtSystem: TdxRibbonTab;
    ribMain: TdxRibbon;
    sbrMain: TdxRibbonStatusBar;
    barManager: TdxBarManager;
    barSystem: TdxBar;
    btnExit: TdxBarLargeButton;
    actExitApp: TAction;
    popBarForms: TdxBarPopupMenu;
    sbxMain: TScrollBox;
    pagApps: TcxPageControl;
    actTimesheetManager: TAction;
    btnTimesheet: TdxBarLargeButton;
    btnMasterTableManager: TdxBarLargeButton;
    btnUserManager: TdxBarLargeButton;
    actMasterTableManager: TAction;
    actUserManager: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DoExitApp(Sender: TObject);

    procedure LaunchApp(AppName, AppTitle, TabName: string; SizeToClient: Integer);
    procedure pagAppsChange(Sender: TObject);
    procedure DoLaunchApplication(Sender: TObject);
    procedure pagAppsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure pagAppsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure pagAppsStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FJobH: THandle;
//    FAppCount: Integer;
    FReady: Boolean;

    property JobH: THandle read FJobH write FJobH;
//    property AppCount: Integer read FAppCount write FAppCount;
    property Ready: Boolean read FReady write FReady;
  public
    { Public declarations }
  protected
    procedure WndProc(var MyMsg: TMessage); override;
    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
    procedure HandleIncomingMessage(DataStructure: PCopyDataStruct; Msg: TWMCopyData);

//    procedure HandleParam(const Param: string);
//    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.dfm}

uses
  VBShell_DM,
  RUtils,
  JobsApi,
  CommonValues,
  MsgDialog_Frm,
  CommonMethods,
  VBCommonValues,
  VBBase_DM, CommonFunction, USingleInst;

procedure TMainFrm.DoExitApp(Sender: TObject);
begin
  inherited;
  sknController.SkinName := '';

  if MsgDialogFrm <> nil then
    FreeAndNil(MsgDialogFrm);

  MainFrm.Close;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
var
  RegKey: TRegistry;
//  ValidUserCredentials: Boolean;
  JobLimit: TJobObjectExtendedLimitInformation;
  //I: Integer;
  ErrorMsg: string;
begin
  inherited;
  Application.HintPause := 0;
  Application.HintShortPause := 0;
  FAppTitle := Application.Title;
  VBShellDM.ShellResource := VBBaseDM.GetShellResource;
  dxBarMakeInactiveImagesDingy := False;
  FSwitchPrefix := ['/'];
  pagApps.ShowFrame := False;

  if MsgDialogFrm = nil then
    MsgDialogFrm := TMsgDialogFrm.Create(nil);

  if VBShellDM = nil then
    VBShellDM := TVBShellDM.Create(nil);

  VBShellDM.cdsSystemUser.Close;
//  ProcessRegistry;
  // StringList to maintain current user rights.
  FSLRight := RUtils.CreateStringList(PIPE);
  // Create instance of job array. This array stores the handles when launching
  // task executables that are docked into the Shell.
  FJobH := CreateJobObject(
    nil,
    PChar(ExtractFileName(Application.ExeName)));
  if FJobH <> 0 then
  begin
    JobLimit.BasicLimitInformation.LimitFlags := JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE;
    SetInformationJobObject(
      FJobH,
      JobObjectExtendedLimitInformation,
      @JobLimit,
      SizeOf(TJobObjectExtendedLimitInformation));
  end
  else
    RaiseLastOSError;

  verInfo.FileName := Application.ExeName;
  if verInfo.HaveInfo then
  begin
    sbrMain.Panels[0].Text := 'VB Apps Ver: ' +
      RUtils.GetBuildInfo(Application.ExeName, rbLongFormat);
  end;

  Caption := FAppTitle;
  pagApps.HideTabs := True;
  pagApps.ShowHint := True;
  pagApps.ShowFrame := False;
  // Set the app counter to zero. This property maintains a count of all apps
  // that are launched/terminated. This sets the FApp array length.
//  FAppCount := 0;
//  ProcessApplicationRegistry;
  RegKey := TRegistry.Create(KEY_ALL_ACCESS or KEY_WRITE or KEY_WOW64_64KEY);
  RegKey.RootKey := HKEY_CURRENT_USER;
  try
{$IFDEF DEBUG}
    ErrorMsg := '';
    if not LocalDSServerIsRunning(LOCAL_VB_SHELL_DS_SERVER, ErrorMsg) then
    begin
      Beep;
//      sbrMain.Panels[1].Text := 'Not Connected to Datasnap server';

      Beep;
      DisplayMsg(
        Application.Title,
        Application.Title + ' - Datasnap Server Connection Error',
        'Could not establish a connection to the requested Datasnap server.' + CRLF + CRLF +
        ErrorMsg
        + CRLF + CRLF + 'Please ensure that the local ' + Application.Title + ' Datasnap '
        + CRLF + 'server is running and try again.',
        mtError,
        [mbOK]
        );
    end;
{$ENDIF}
    try
      RegKey.OpenKey(KEY_COMMON_RESOURCE_USER_PREFERENCES, True);
    except
    end;

    VBBaseDM.SetConnectionProperties;
    VBBaseDM.sqlConnection.Open;
    VBBaseDM.Client := TVBServerMethodsClient.Create(VBBaseDM.sqlConnection.DBXConnection);

    // Connect to predefined LEAVE port. See BASE_FRM for list of port no contants.
    sbrMain.Panels[1].Text := 'User: ' + VBBaseDM.FUserData.UserName;

    // Check for first time access to RC Shell. If first time access then get
    // user to login.
    RegKey.CloseKey;
    try
      RegKey.OpenKey(KEY_COMMON_RESOURCE_USER_DATA, True);
    except
    end;
    RegKey.CloseKey;
    ribMain.PopupMenuItems := [];
    ribMain.Update;
    {TODO: Will probably need this.}
//    GetUserRights(FUserData.EmployeeID);
//    WindowState := wsMaximized;
  finally
    if RegKey <> nil then
      RegKey.Free;
  end;
end;

procedure TMainFrm.FormResize(Sender: TObject);
var
  AppHandle: HWND;
  WRect: TRect;
begin
  inherited;
  // We need to resize the application window currently showing so that it
  // remains aligned to client to the parent tab. We do not need to redraw all
  // of the tabs as this will take time and is not comsmetically desirable. Each
  // individual app window is redrawn whenever the user chages tabs (See the
  // pagApps.OnChange event).
  if Assigned(pagApps.ActivePage) then
    try
      pagApps.ActivePage.Visible := False;
      AppHandle := pagApps.ActivePage.Tag;

      case (pagApps.ActivePage.Hint).ToInteger of
        0:
          begin
            GetWindowRect(
              AppHandle,
              WRect);
            MoveWindow(
              AppHandle,
              0,
              0,
              WRect.Width,
              WRect.Height,
              True);
          end;
        1:
          MoveWindow(AppHandle, 0, 0, pagApps.ActivePage.ClientWidth, pagApps.ActivePage.ClientHeight, True);
      end;
    finally
      pagApps.ActivePage.Visible := True;
      pagApps.ShowFrame := False;
    end;
end;

procedure TMainFrm.FormShow(Sender: TObject);
begin
  inherited;
//  styContent.Color := cxLookAndFeels.RootLookAndFeel.SkinPainter.DefaultContentColor;
//  styContent.TextColor := cxLookAndFeels.RootLookAndFeel.SkinPainter.DefaultSelectionColor;
//  styEven.Color := cxLookAndFeels.RootLookAndFeel.SkinPainter.DefaultContentEvenColor;
//  styEven.TextColor := cxLookAndFeels.RootLookAndFeel.SkinPainter.DefaultSelectionColor;
//  styOdd.Color := cxLookAndFeels.RootLookAndFeel.SkinPainter.DefaultContentOddColor;
//  styOdd.TextColor := cxLookAndFeels.RootLookAndFeel.SkinPainter.DefaultSelectionColor;
//  styInactive.Color := cxLookAndFeels.RootLookAndFeel.SkinPainter.DefaultHeaderBackgroundColor;
//  styInactive.TextColor := cxLookAndFeels.RootLookAndFeel.SkinPainter.DefaultSelectionTextColor;
//  styGroup.Color := cxLookAndFeels.RootLookAndFeel.SkinPainter.DefaultGroupColor;
//  styGroup.TextColor := cxLookAndFeels.RootLookAndFeel.SkinPainter.DefaultGroupTextColor;
//  styEditControllerReadOnly.Style.TextColor := cxLookAndFeels.RootLookAndFeel.SkinPainter.DefaultSelectionColor;
//  scrMain.Color := cxLookAndFeels.RootLookAndFeel.SkinPainter.DefaultContentColor;

//  ribMain.ShowTabGroups := True;
  WindowState := wsMaximized;
end;

procedure TMainFrm.DoLaunchApplication(Sender: TObject);
var
  AppFriendlyName, AppExeName, AppCodeName, TabName: string;
begin
  inherited;
  AppFriendlyName := TAction(Sender).Caption;
  AppCodeName := StringReplace(AppFriendlyName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  AppExeName := AppCodeName + '.exe';
  TabName := 'tab' + AppCodeName;
  LaunchApp(AppExeName, AppFriendlyName, TabName, 1);

//AppName, AppTitle, TabName: string; SizeToClient: Integer);
//  LaunchApp('MasterTableManager.exe', 'Master Table Manager', 'tabMasterTableManager', 1);
end;

procedure TMainFrm.LaunchApp(AppName, AppTitle, TabName: string; SizeToClient: Integer);
var
  Wnd: THandle;
  AppH: HWND;
  aTabSheet: TcxTabSheet;
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  Success: Boolean;
  FirstTickCount: LongInt;
  Args, LaunchErrorMsg: string;
  WRect: TRect;
//  ShellInfo: TShellExecuteInfo;
begin

//  uses ShellApi, ...;
//
//  function RunAsAdmin(const Handle: Hwnd; const Path, Params: string): Boolean;
//  var
//    sei: TShellExecuteInfoA;
//  begin
//    FillChar(sei, SizeOf(sei), 0);
//    sei.cbSize := SizeOf(sei);
//    sei.Wnd := Handle;
//    sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
//    sei.lpVerb := 'runas';
//    sei.lpFile := PAnsiChar(Path);
//    sei.lpParameters := PAnsiChar(Params);
//    sei.nShow := SW_SHOWNORMAL;
//    Result := ShellExecuteExA(@sei);
//  end;
//
//  procedure TFormMain.RunAddOrRemoveApplication;
//  begin
//    // Example that uses elevated rundll to open the Control Panel to Programs and features
//    RunAsAdmin(FormMain.Handle, 'rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl', '');
//  end;

  try
    Screen.Cursor := crHourglass;
    FReady := False;
    // Hide the Task Tree dock panel.
    Success := True;
    pagApps.OnChange := nil;
    aTabSheet := TcxTabSheet.Create(pagApps);
    aTabSheet.PageControl := pagApps;
    aTabSheet.Caption := AppTitle;
    aTabSheet.Name := TabName;
    aTabSheet.TabHint := AppTitle;
    aTabSheet.ShowHint := False;
    aTabSheet.Hint := SizeToClient.ToString;
    aTabSheet.Visible := False;
    aTabSheet.TabVisible := False;
    // Initialise StartInfo for creating the process.
    FillChar(
      StartInfo,
      SizeOf(TStartupInfo),
      #0);

    FillChar(
      ProcInfo,
      SizeOf(TProcessInformation),
      #0);

    StartInfo.cb := SizeOf(TStartupInfo);
    StartInfo.dwFlags := STARTF_USESHOWWINDOW;
    StartInfo.lpDesktop := PChar('winsta0\Default');
    StartInfo.wShowWindow := SW_HIDE;
    GetStartupInfo(StartInfo);
    Args := ' /VB_SHELL';

//    ZeroMemory(@ShellInfo, SizeOf(ShellInfo));
//    ShellInfo.cbSize := SizeOf(TShellExecuteInfo);
//    ShellInfo.Wnd := 0;
//    ShellInfo.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
//    ShellInfo.lpVerb := PChar('runas');
//    ShellInfo.lpFile := PChar(FRCApplicationFolder + AppName); // PAnsiChar;
//
//    if Args <> '' then
//      ShellInfo.lpParameters := PChar(Args); // PAnsiChar;
//
//    ShellInfo.nShow := SW_SHOWNORMAL; //Integer;
//    Success := ShellExecuteEx(@ShellInfo);

    // Now launch the application
    Success := CreateProcess(
      PWideChar(APPLICATION_FOLDER + AppName),
      PWideChar(APPLICATION_FOLDER + AppName + Args),
//      PWideChar(FRCApplicationFolder + AppName),
//      PWideChar(FRCApplicationFolder + AppName + Args),
      nil,
      nil,
      False,
      CREATE_NEW_PROCESS_GROUP + NORMAL_PRIORITY_CLASS + CREATE_BREAKAWAY_FROM_JOB + STARTF_FORCEONFEEDBACK,
      nil,
      nil,
      StartInfo,
      ProcInfo);

    if not Success then
    begin
      Screen.Cursor := crDefault;
      if Assigned(aTabSheet) then
        aTabSheet.Free;

      LaunchErrorMsg := 'An error occurred in launching ' + APPLICATION_FOLDER + AppName;
      raise ELaunchException.Create(LaunchErrorMsg);
//      Beep;
//      DisplayMsg(
//        Application.Title,
//        'Launch Failure',
//        'An error occurred in launching ' + APPLICATION_FOLDER + AppName,
//        mtError,
//        [mbOK]);
//      ribMain.ShowTabGroups := pagApps.PageCount = 0;
//      Exit;
    end;

    // Display/Hide ribbon depending on if any apps are open or not.
    ribMain.ShowTabGroups := pagApps.PageCount = 0;
    FirstTickCount := GetTickCount;
    // Wait until application signals that it is fully initialised.
    while not (FReady) do
      Application.ProcessMessages;

    // If process was created successfully
    if Success then
    begin
      Wnd := ProcInfo.hProcess;
      SendMessage(
        Wnd,
        WM_SYSCOMMAND,
        SC_MINIMIZE,
        0);

      if Wnd <> INVALID_HANDLE_VALUE then
        AssignProcessToJobObject(
          FJobH,
          Wnd)
      else
        Success := False;

      FirstTickCount := GetTickCount;

      repeat
        AppH := FindWindow(nil, PWideChar(AppTitle));
      until (AppH <> 0) or ((Integer(GetTickCount) - FirstTickCount) >= 2000);

      if (AppH = 0) then
      begin
        TerminateProcess(
          ProcInfo.hProcess,
          0);

        CloseHandle(ProcInfo.hProcess);
        PostMessage(
          Wnd,
          WM_Close,
          0,
          0);

        if Assigned(aTabSheet) then
          aTabSheet.Free;

        ribMain.ShowTabGroups := pagApps.PageCount = 0;
        Beep;
        DisplayMsg(
          Application.Title,
          'Docking Error',
          'Unable to dock application into RC Shell.',
          mtError,
          [mbOK]);
        Exit;
      end
      else
      begin
        pagApps.HideTabs := False;
        aTabSheet.Visible := True;
        aTabSheet.TabVisible := True;

        if pagApps.PageCount = 0 then
          aTabSheet.Tag := 0
        else
          aTabSheet.Tag := AppH;
        Winapi.Windows.SetParent(
          AppH,
          aTabSheet.Handle);

        case SizeToClient of
          0:
            begin
              GetWindowRect(
                AppH,
                WRect);
              ShowWindow(
                AppH,
                SW_NORMAL);
              MoveWindow(
                AppH,
                0,
                0,
                WRect.Width,
                WRect.Height,
                True);
            end;
          1:
            ShowWindow(AppH, SW_MAXIMIZE);
        end;
        pagApps.ActivePage := aTabSheet;
      end;
    end
    else
    begin
      ribMain.ShowTabGroups := pagApps.PageCount = 0;
      Beep;
      DisplayMsg(
        Application.Title,
        Application.Title + ' - Launch Failure',
        'An error occurred in attempting to launch ' + TabName {AppTitle},
        mtError,
        [mbOK]);
    end;
  finally
    pagApps.OnChange := pagAppsChange;
    Self.Resize;
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainFrm.pagAppsChange(Sender: TObject);
var
  AppHandle: HWND;
  WRect: TRect;
begin
  inherited;
  // We need to resize the application window for this tab so that it remains
  // aligned to client to the parent tab.
  if Assigned(pagApps.ActivePage) then
    try
      pagApps.ActivePage.Visible := False;
      AppHandle := pagApps.ActivePage.Tag;

      case (pagApps.ActivePage.Hint).ToInteger of
        0:
          begin
            GetWindowRect(
              AppHandle,
              WRect);
            MoveWindow(
              AppHandle,
              0,
              0,
              WRect.Width,
              WRect.Height,
              True);
          end;
        1:
          MoveWindow(AppHandle, 0, 0, pagApps.ActivePage.ClientWidth, pagApps.ActivePage.ClientHeight, True);
      end;
    finally
      pagApps.ActivePage.Visible := True;
    end;
end;

procedure TMainFrm.pagAppsDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  Index: Integer;
begin
  inherited;
  with TcxPageControl(Sender) do
  begin
    index := IndexOfTabAt(X, Y);
    Pages[index].PageIndex := TmyDragObject(Source).Tab.PageIndex;
    TmyDragObject(Source).Tab.PageIndex := index;
  end;
end;

procedure TMainFrm.pagAppsDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  Index: Integer;
begin
  inherited;
  with TcxPageControl(Sender) do
  begin
    index := IndexOfTabAt(X, Y);
    Accept := (index > -1) and (Pages[index] <> TmyDragObject(Source).Tab);
  end;
end;

procedure TMainFrm.pagAppsStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  inherited;
  DragObject := TmyDragObject.Create(TcxPageControl(Sender));
  TmyDragObject(DragObject).Tab := TcxPageControl(Sender).ActivePage;
end;

procedure TMainFrm.WndProc(var MyMsg: TMessage);
begin
  inherited;
  case MyMsg.Msg of
    WM_RESTORE_APP:
      ShowWindow(MainFrm.Handle, SW_RESTORE);

    WM_APP_READY:
      begin

      end;

    WM_APP_CLOSED:
      begin

      end;
  end;
end;

procedure TMainFrm.WMCopyData(var Msg: TWMCopyData);
begin
  HandleIncomingMessage(Msg.CopyDataStruct, Msg);
end;

procedure TMainFrm.HandleIncomingMessage(DataStructure: PCopyDataStruct; Msg: TWMCopyData);
var
  S: string;
  AppH: HWND;
  I: Integer;
  FirstTickCount: LongInt;
begin
{-------------------------------------------------------------------------------
  Notes to developer:

  1. NB!! Docking of a client app should only be done once the client app is
     FULLY initialised.

  2. The client app sends an 'App Ready' message to the host app indicating that
     is is fully launched. The host app waits for this message and only then
     docks the client app onto the newly created tab.

  3. When a client app is closed, it sends a 'Close App' message to the host app
     telling the host that it has closed. This is the only way that the host
     knows when to free the tab on which the client was docked.

-------------------------------------------------------------------------------}

  // Get the message sent from the client app.
  S := PChar(DataStructure.lpData);
  // When launching the client app, the client app sends a message to RC Shell
  // indicating that is is fully launched and can then be docked.
  if AnsiCompareText(S, 'App Ready') = 0 then
    FReady := True
  // When closing the client app, the client app sends a message to RC shell
  // indicating that is is closed. This is necessary to tell RC Shell that the
  // tab in which the client app is docked can now be freed.
  else if CompareText(S, 'Close App') = 0 then
  begin
    // Find the tab in which the client app is docked. The handle to the client
    // app is stored in the tab's Tag property (See the LaunchApp method).
    for I := 0 to pagApps.PageCount - 1 do
      // Msg.From contains the handle of the client app.
      if pagApps.Pages[I].Tag = Integer(Msg.From) then
      begin
        FirstTickCount := GetTickCount;
        repeat
          // Keep polling until the client app has been destroyed.
          AppH := Findwindow(nil, PWideChar(pagApps.Pages[I].TabHint))
        until (AppH = 0) or ((GetTickCount - FirstTickCount) >= 10000);
        // Once the client app can no longer be found, destroy the container tab.
        if Assigned(pagApps.Pages[I]) then
          pagApps.Pages[I].Free;
        Break;
      end;
    // Display/Hide ribbon depending on if any apps are open or not.
    ribMain.ShowTabGroups := pagApps.PageCount = 0;
  end;
end;

end.

