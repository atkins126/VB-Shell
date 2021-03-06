unit Login_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Forms,
  System.Classes, Vcl.Graphics, System.ImageList, Vcl.ImgList, Vcl.ExtCtrls,
  Vcl.Controls, Vcl.Dialogs, System.Actions, Vcl.ActnList, Vcl.Menus, Data.DB,
  Vcl.StdCtrls, System.Win.Registry,

  BaseLayout_Frm, VBProxyClass, VersionInformation,

  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, cxImageList, dxLayoutLookAndFeels, cxContainer, cxEdit,
  cxClasses, cxStyles, dxLayoutContainer, dxLayoutControl, dxLayoutcxEditAdapters,
  dxSkinsForm, dxGDIPlusClasses, cxImage, cxGroupBox, cxRadioGroup, cxLabel,
  dxLayoutControlAdapters, cxTextEdit, cxButtons, dxStatusBar, dxScreenTip,
  dxCustomHint, cxHint, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, dxSkinMoneyTwins;

type
  TLoginFrm = class(TBaseLayoutFrm)
    grpLogo: TdxLayoutGroup;
    grpLogin: TdxLayoutGroup;
    grpLogoText: TdxLayoutGroup;
    sknController: TdxSkinController;
    lblTitle: TcxLabel;
    lblSubTitle: TcxLabel;
    styTitle: TcxEditStyleController;
    stySubtitle: TcxEditStyleController;
    litTitle: TdxLayoutItem;
    litSubtitle: TdxLayoutItem;
    litUnderline: TdxLayoutItem;
    pnlUnderline: TcxGroupBox;
    litLogo: TdxLayoutImageItem;
    litUserName: TdxLayoutItem;
    litPassword: TdxLayoutItem;
    litLogin: TdxLayoutItem;
    litCancel: TdxLayoutItem;
    grpUserInfo: TdxLayoutGroup;
    grpButtons: TdxLayoutGroup;
    edtUserName: TcxTextEdit;
    edtPassword: TcxTextEdit;
    spc1: TdxLayoutEmptySpaceItem;
    btnLogin: TcxButton;
    btnCancel: TcxButton;
    spc2: TdxLayoutEmptySpaceItem;
    sbrMain: TdxStatusBar;
    verInfo: TVersionInformation;
    actLogin: TAction;
    actCancelLogin: TAction;
    repScreenTip: TdxScreenTipRepository;
    tipLogin: TdxScreenTip;
    tipCancelLogin: TdxScreenTip;
    styHintController: TcxHintStyleController;
    lucSystemUser: TcxLookupComboBox;
    sep1: TdxLayoutSeparatorItem;
    procedure UpdateApplicationSkin(SkinResourceFileName {, SkinName}: string);

    procedure FormCreate(Sender: TObject);
    procedure edtUserNameEnter(Sender: TObject);
    procedure edtUserNameExit(Sender: TObject);
    procedure edtUserNamePropertiesChange(Sender: TObject);
    procedure DoLogin(Sender: TObject);
    procedure DoCancelLogin(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FLoginAttempt: Integer;

    property LoginAttempt: Integer read FLoginAttempt write FLoginAttempt;

    function LoginToDB(UserName, Password: string): Boolean;
  public
    { Public declarations }
  end;

var
  LoginFrm: TLoginFrm;

implementation

{$R *.dfm}

uses
  VBShell_DM,
  VBBase_DM,
  VBCommonValues,
  RUtils,
  CommonMethods,
  CommonFunctions,
  Main_Frm,
  ED, CommonValues, USingleInst;

procedure TLoginFrm.FormCreate(Sender: TObject);
var
  RegKey: TRegistry;
  SkinResourceFileName: string;
{$IFDEF DEBUG}
  ErrorMsg: string;
{$ENDIF}
  //  RootFolder, RootDataFolder, OldRootFolder: string;
  //  I: Integer;
begin
  Height := 225;
  Width := 505;
  layMain.Align := alClient;
  layMain.LayoutLookAndFeel := lafCustomSkin;
  pnlUnderline.Style.BorderColor := clNone;
  pnlUnderline.Style.BorderStyle := ebsNone;
  litLogo.Image.Transparent := True;
  FLoginAttempt := 0;
  FAppTitle := Application.Title;
  RegKey := TRegistry.Create(KEY_ALL_ACCESS or KEY_WRITE or KEY_WOW64_64KEY);
  RegKey.RootKey := HKEY_CURRENT_USER;
  RegKey.OpenKey(KEY_USER_DATA, True);

  try
{$IFDEF DEBUG}
    ErrorMsg := '';
    if not LocalDSServerIsRunning(LOCAL_VB_SHELL_DS_SERVER, ErrorMsg) then
    begin
      Beep;
      //      sbrMain.Panels[1].Text := 'Not Connected to Datasnap server';

      Beep;
      DisplayMsg(
        FAppTitle,
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

    if VBBaseDM = nil then
      VBBaseDM := TVBBaseDM.Create(nil);

    if VBShellDM = nil then
      VBShellDM := TVBShellDM.Create(nil);

    VBBaseDM.SetConnectionProperties;
    VBBaseDM.sqlConnection.Open;
    VBBaseDM.Client := TVBServerMethodsClient.Create(VBBaseDM.sqlConnection.DBXConnection);

    VBShellDM.ShellResource := VBBaseDM.GetShellResource;
    SkinResourceFileName := {VBShellDM.ShellResource.RootFolder + }RESOURCE_FOLDER + SKIN_RESOURCE_FILE;
    //    SkinName := VBShellDM.ShellResource.SkinName;
    //
    //    if Length(Trim(SkinName)) = 0 then
    //      SkinName := DEFAULT_SKIN_NAME;

    UpdateApplicationSkin(SkinResourceFileName {, SkinName});

    //    sbrMain.Panels[0].Text := 'VB Apps Ver: ' +
    //      RUtils.GetBuildInfo(Application.ExeName, rbLongFormat) + ' - ' +
    //      verInfo.StringFileInfo['LegalTrademarks'];

    sbrMain.Panels[0].Text := 'VB Shell Ver: ' +
      RUtils.GetBuildInfo(Application.ExeName, rbLongFormat);

    btnLogin.Default := True;
    lucSystemUser.Properties.ListSource := VBShellDM.dtsSystemUser;
    VBShellDM.cdsSystemUser.Close;

    VBBaseDM.GetData(33, VBShellDM.cdsDBInfo, VBShellDM.cdsDBInfo.Name, ONE_SPACE,
      'C:\Data\Xml\DB Info.xml', VBShellDM.cdsDBInfo.UpdateOptions.Generatorname,
      VBShellDM.cdsDBInfo.UpdateOptions.UpdateTableName);

    //    WhereClause := ' WHERE U.LOGIN_NAME = ' +
    //
    //    VBBaseDM.GetData(24, VBShellDM.cdsSystemUser, VBShellDM.cdsSystemUser.Name, ONE_SPACE,
    //      'C:\Data\Xml\System User.xml', VBShellDM.cdsSystemUser.UpdateOptions.Generatorname,
    //      VBShellDM.cdsSystemUser.UpdateOptions.UpdateTableName);

    //ORDER BY
    // U.FIRST_NAME,
    // U.LAST_NAME

    //    if RegKey.ValueExists('Login Name') then
    //    begin
    //      if Length(Trim(RegKey.ReadString('Login Name'))) > 0 then
    //      begin
    //        UserName := Trim(RegKey.ReadString('Login Name'));
    //        VBShellDM.cdsSystemUser.Locate('LOGIN_NAME', UserName, [loCaseInsensitive]);
    //        lucSystemUser.Text := UserName;
    //      end;
    //    end;

    if RegKey.ValueExists('Login Name') then
    begin
      if Length(Trim(RegKey.ReadString('Login Name'))) > 0 then
        edtUserName.Text := Trim(RegKey.ReadString('Login Name'))
      else
        edtUserNamePropertiesChange(nil);
    end
    else
    begin
      edtUserName.Clear;
      edtPassword.Clear;
    end;
    RegKey.CloseKey;
  finally
    RegKey.Free;
  end;
end;

procedure TLoginFrm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    actCancelLogin.Execute;
end;

procedure TLoginFrm.FormShow(Sender: TObject);
begin
  //  if Showing then
  //  begin
  //    edtUserName.SetFocus;
  //  end;

  if Showing then
  begin
    if Length(Trim(edtUserName.Text)) = 0 then
    begin
      edtUserName.SetFocus;
      edtUserName.Style.Color := clWindow;
      edtPassword.Style.Color := RootLookAndFeel.SkinPainter.DefaultContentColor;
    end
    else
    begin
      edtPassword.SetFocus;
      edtUserName.Style.Color := RootLookAndFeel.SkinPainter.DefaultContentColor;
      edtPassword.Style.Color := clWindow;
    end;
  end;
end;

function TLoginFrm.LoginToDB(UserName, Password: string): Boolean;
var
  ED: TED;
  PW, WhereClause: string;
begin
  Result := False;
  WhereClause :=
    ' WHERE UPPER(U.LOGIN_NAME) = ' + AnsiQuotedStr(AnsiUpperCase(Trim(edtUserName.Text)), '''');

  VBBaseDM.GetData(24, VBShellDM.cdsSystemUser, VBShellDM.cdsSystemUser.Name, WhereClause,
    'C:\Data\Xml\System User.xml', VBShellDM.cdsSystemUser.UpdateOptions.Generatorname,
    VBShellDM.cdsSystemUser.UpdateOptions.UpdateTableName);

  if VBShellDM.cdsSystemUser.IsEmpty then
    raise ELoginCredentialError.Create('Invalid user name and/or password.');

  //  if VBShellDM.cdsDBInfo.FieldByName('DB_VERSION').Asinteger > 12 then
  //  begin
  ED := TED.Create(EKEY1, EKEY2);
  try
    PW := ED.DCString(VBShellDM.cdsSystemUser.FieldByName('PASSWORD').AsString);
    //    PW := ED.DCString(VBBaseDM.UserData.PW);
  finally
    ED.Free;
  end;

  Result := SameText(UserName, VBShellDM.cdsSystemUser.FieldByName('LOGIN_NAME').AsString)
    and SameStr(Password, PW);
  //  end;
end;

procedure TLoginFrm.DoCancelLogin(Sender: TObject);
begin
  Application.Terminate
end;

procedure TLoginFrm.DoLogin(Sender: TObject);
var
  RegKey: TRegistry;
begin
  //  VBBaseDM.UserData.UserID := VBShellDM.cdsSystemUser.FieldByName('ID').AsInteger;
  //  VBBaseDM.UserData.UserName := VBShellDM.cdsSystemUser.FieldByName('LOGIN_NAME').AsString;
  //  VBBaseDM.UserData.FirstName := VBShellDM.cdsSystemUser.FieldByName('FIRST_NAME').AsString;
  //  VBBaseDM.UserData.LastName := VBShellDM.cdsSystemUser.FieldByName('LAST_NAME').AsString;
  //  VBBaseDM.UserData.EmailAddress := VBShellDM.cdsSystemUser.FieldByName('EMAIL_ADDRESS').AsString;
  //  VBBaseDM.UserData.AccountEnabled := RUtils.IntegerToBoolean(VBShellDM.cdsSystemUser.FieldByName('ACCOUNT_ENABLED').AsInteger);
  //  VBBaseDM.UserData.PW := VBShellDM.cdsSystemUser.FieldByName('PASSWORD').AsString;

  Inc(FLoginAttempt);
  if not LoginToDB(edtUserName.Text, edtPassword.Text) then
  begin
    Beep;
    if LoginAttempt = 1 then
    begin
      DisplayMsg(
        FAppTitle,
        'Invalid Login Validation Attempt: ' + FLoginAttempt.ToString,
        'Invalid username and/or password. Please note that passwords are case sensitive. ' +
        'Please ensure that your caps lock key is in the correct state and try again.',
        mtWarning,
        [mbOK]
        );
      Exit;
    end

    else if FLoginAttempt = 2 then
    begin
      edtPassword.Clear;
      try
        edtPassword.SetFocus;
      except
      end;
      DisplayMsg(
        FAppTitle,
        'Invalid Login Validation Attempt: ' + FLoginAttempt.ToString,
        'Invalid username and/or password. ' +
        'You have made two unsuccessfull attempts at logging in. ' +
        'Please ensure that your caps lock key is in the correct state and try again.',
        mtWarning,
        [mbOK]
        );
      Exit;
    end

    else if FLoginAttempt >= 3 then
    begin
      edtPassword.Clear;
      try
        edtPassword.SetFocus;
      except
      end;
      DisplayMsg(
        FAppTitle,
        'Invalid Login Validation Attempt: ' + FLoginAttempt.ToString,
        'This is your third unsuccessfull attempt at logging in. ' +
        'VB Shell cannot log you in and will now terminate.',
        mtWarning,
        [mbOK]
        );
      LoginFrm.Close;
      Application.Terminate;
      Exit;
    end;
    edtPassword.Clear;
    try
      edtPassword.SetFocus;
    except
    end;
  end;

  RegKey := TRegistry.Create(KEY_ALL_ACCESS or KEY_WRITE or KEY_WOW64_64KEY);
  try
    VBBaseDM.UserData.UserID := VBShellDM.cdsSystemUser.FieldByName('ID').AsInteger;
    VBBaseDM.UserData.UserName := VBShellDM.cdsSystemUser.FieldByName('LOGIN_NAME').AsString;
    VBBaseDM.UserData.FirstName := VBShellDM.cdsSystemUser.FieldByName('FIRST_NAME').AsString;
    VBBaseDM.UserData.LastName := VBShellDM.cdsSystemUser.FieldByName('LAST_NAME').AsString;
    VBBaseDM.UserData.EmailAddress := VBShellDM.cdsSystemUser.FieldByName('EMAIL_ADDRESS').AsString;
    VBBaseDM.UserData.AccountEnabled := RUtils.IntegerToBoolean(VBShellDM.cdsSystemUser.FieldByName('ACCOUNT_ENABLED').AsInteger);
    VBBaseDM.UserData.PW := VBShellDM.cdsSystemUser.FieldByName('PASSWORD').AsString;

    RegKey.RootKey := HKEY_CURRENT_USER;
    RegKey.OpenKey(KEY_USER_DATA, True);
    RegKey.WriteInteger('User ID', VBBaseDM.UserData.UserID);
    RegKey.WriteString('Login Name', edtUserName.Text);
    RegKey.WriteString('First Name', VBBaseDM.UserData.FirstName);
    RegKey.WriteString('Last Name', VBBaseDM.UserData.LastName);
    RegKey.WriteString('Email Address', VBBaseDM.UserData.EmailAddress);
    RegKey.WriteBool('Account Enabled', VBBaseDM.UserData.AccountEnabled);
    RegKey.CloseKey;

    if MainFrm = nil then
    begin
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      LoginFrm.Hide;
      Application.CreateForm(TMainFrm, MainFrm);
      VBShellDM.cdsSystemUser.Close;
    end;
    LoginFrm.Close;
    Application.ShowMainForm := True;
  finally
    RegKey.Free;
  end;
end;

procedure TLoginFrm.edtUserNameEnter(Sender: TObject);
begin
  TcxTextEdit(Sender).Style.Color := clWhite;
end;

procedure TLoginFrm.edtUserNameExit(Sender: TObject);
begin
  TcxTextEdit(Sender).Style.Color :=
    cxLookAndFeels.RootLookAndFeel.SkinPainter.DefaultContentColor;
end;

procedure TLoginFrm.edtUserNamePropertiesChange(Sender: TObject);
begin
  actLogin.Enabled :=
    (Length(Trim(edtUserName.Text)) > 0) and
    (Length(Trim(edtPassword.Text)) > 0)
end;

procedure TLoginFrm.UpdateApplicationSkin(SkinResourceFileName {, SkinName}: string);
var
  SkinName: string;
begin
  SkinName := VBBaseDM.GetSkinFromRegistry;
  sknController.BeginUpdate;
  try
    sknController.NativeStyle := False;
    sknController.UseSkins := True;
    if dxSkinsUserSkinLoadFromFile(SkinResourceFileName, SkinName) then
    begin
      sknController.SkinName := 'UserSkin';
      RootLookAndFeel.SkinName := 'UserSkin';
      lafCustomSkin.LookAndFeel.SkinName := 'UserSkin';
    end
    else
    begin
      sknController.SkinName := DEFAULT_SKIN_NAME;
      RootLookAndFeel.SkinName := DEFAULT_SKIN_NAME;
      lafCustomSkin.LookAndFeel.SkinName := DEFAULT_SKIN_NAME;
    end;
  finally
    sknController.Refresh;
    sknController.EndUpdate;
  end;
end;

end.

