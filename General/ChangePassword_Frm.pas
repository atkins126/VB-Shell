unit ChangePassword_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Forms,
  System.Classes, Vcl.Graphics, System.Actions, Vcl.ActnList, Vcl.Controls,
  Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, System.ImageList, Vcl.ImgList,

  BaseLayout_Frm, CommonValues, VBCommonValues,

  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, cxContainer, cxEdit, cxTextEdit, cxImageList,
  dxLayoutLookAndFeels, cxClasses, cxStyles, dxLayoutContainer, dxLayoutControl,
  cxButtons, dxLayoutcxEditAdapters, dxLayoutControlAdapters;

type
  TChangePasswordFrm = class(TBaseLayoutFrm)
    edtNewPassword: TcxTextEdit;
    edtConfirmPassword: TcxTextEdit;
    edtCurrentPassword: TcxTextEdit;
    grpPassword: TdxLayoutGroup;
    litCurrentPassword: TdxLayoutItem;
    litNewPassword: TdxLayoutItem;
    litConfirmPassword: TdxLayoutItem;
    litOK: TdxLayoutItem;
    litCancel: TdxLayoutItem;
    grpButtons: TdxLayoutGroup;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    sep1: TdxLayoutSeparatorItem;
    litContinue: TdxLayoutItem;
    btnContinue: TcxButton;
    grpConfirmPassword: TdxLayoutGroup;
    litConfirmMatch: TdxLayoutImageItem;
    litConfirmNoMatch: TdxLayoutImageItem;
    grpNewPassword: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtCurrentPasswordPropertiesChange(Sender: TObject);
    procedure edtConfirmPasswordPropertiesChange(Sender: TObject);
  private
    FCurrentPassword: string;
    { Private declarations }
  public
    { Public declarations }
    property CurrentPassword: string read FCurrentPassword write FCurrentPassword;
  end;

var
  ChangePasswordFrm: TChangePasswordFrm;

implementation

{$R *.dfm}

uses
  ED,
  VBShell_DM, VBBase_DM, RUtils, CommonFunctions;

procedure TChangePasswordFrm.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Change user password';
  Self.Width := 320;
  Self.Height := 200;
  grpNewPassword.Visible := False;
  btnContinue.Default := True;
  btnOK.Default := False;
  btnOK.Enabled := False;
  grpNewPassword.Visible := False;
  grpConfirmPassword.Visible := False;
  litConfirmMatch.Visible := False;
  litConfirmNoMatch.Visible := False;
end;

procedure TChangePasswordFrm.btnContinueClick(Sender: TObject);
begin
  inherited;
  if not SameStr(Trim(edtCurrentPassword.Text), FCurrentPassword) then
  begin
    edtCurrentPassword.Clear;
    edtCurrentPassword.SetFocus;
    raise EValidateException.Create('Invalid password.');
  end;

  edtCurrentPassword.Enabled := False;
  grpNewPassword.Visible := True;
  grpConfirmPassword.Visible := True;
  edtNewPassword.SetFocus;
  btnContinue.Default := False;
  btnOK.Enabled := True;
  btnOK.Default := True;
  btnContinue.Enabled := False;
end;

procedure TChangePasswordFrm.btnOKClick(Sender: TObject);
var
  ED: TED;
  NewPW, SQL: string;
  Response: TStringList;
begin
  inherited;
  if SameText(Trim(edtNewPassword.Text), Trim(edtCurrentPassword.Text)) then
  begin
    edtNewPassword.Clear;
    edtConfirmPassword.Clear;
    edtNewPassword.SetFocus;

    raise EValidateException.Create('Your new password is the same as or too similar to you curent pasword.' + CRLF +
      'Please enter a different password.');
  end;

  if not SameStr(Trim(edtNewPassword.Text), Trim(edtConfirmPassword.Text)) then
  begin
    edtNewPassword.Clear;
    edtConfirmPassword.Clear;
    edtNewPassword.SetFocus;

    raise EValidateException.Create('Your new password does not match the confirmation pasword.');
  end;

  edtCurrentPassword.Clear;
  Response := RUtils.CreateStringList(PIPE, DOUBLE_QUOTE);
  ED := TED.Create(EKEY1, EKEY2);
  try
    NewPW := ED.ECString(edtNewPassword.Text);

    SQL := 'UPDATE SYSTEM_USER SET "PASSWORD" = ' + AnsiQuotedStr(AnsiUpperCase(NewPW), '''') +
      ' WHERE ID = ' + VBBaseDM.UserData.UserID.ToString;

    Response.DelimitedText := VBBaseDM.ExecuteSQLCommand(SQL);
    if Response.Values['RESPONSE'] = 'ERROR' then
      raise EServerError.Create('An error occured in datbaase updates with error: ' +
        Response.Values['ERROR_MESSAGE']);

    VBBaseDM.UserData.PW := NewPW;
    Beep;
    DisplayMsg(
      Application.Title,
      'Password Change',
      'Your new password has been successfully updated',
      mtInformation,
      [mbOK]
      );

    Self.ModalResult := mrOK;
  finally
    ED.Free;
    Response.Free;
  end;

end;

procedure TChangePasswordFrm.edtConfirmPasswordPropertiesChange(
  Sender: TObject);
begin
  inherited;
  litConfirmMatch.Visible := SameStr(Trim(edtNewPassword.Text), Trim(edtConfirmPassword.Text));
  litConfirmNoMatch.Visible := not litConfirmMatch.Visible;
end;

procedure TChangePasswordFrm.edtCurrentPasswordPropertiesChange(Sender: TObject);
begin
  inherited;
//  btnContinue.Visible := SameStr(Trim(edtCurrentPassword.Text), FCurrentPassword);
end;

end.

