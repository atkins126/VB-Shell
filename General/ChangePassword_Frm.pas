unit ChangePassword_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Forms,
  System.Classes, Vcl.Graphics, System.Actions, Vcl.ActnList, Vcl.Controls,
  Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, System.ImageList, Vcl.ImgList,

  BaseLayout_Frm, CommonValues,

  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, cxContainer, cxEdit, cxTextEdit, cxImageList,
  dxLayoutLookAndFeels, cxClasses, cxStyles, dxLayoutContainer, dxLayoutControl,
  cxButtons, dxLayoutcxEditAdapters, dxLayoutControlAdapters;

type
  TChangePasswordFrm = class(TBaseLayoutFrm)
    edtNewPassword: TcxTextEdit;
    edtConfirmPassword: TcxTextEdit;
    edtCurrentPassword: TcxTextEdit;
    grpNewPassword: TdxLayoutGroup;
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
    procedure FormCreate(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtCurrentPasswordPropertiesChange(Sender: TObject);
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

uses ED;

procedure TChangePasswordFrm.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Change user password';
  Self.Width := 300;
  Self.Height := 200;
  btnContinue.Enabled := False;
  grpNewPassword.Enabled := False;
end;

procedure TChangePasswordFrm.btnContinueClick(Sender: TObject);
begin
  inherited;
  grpNewPassword.Enabled := True;
  edtNewPassword.SetFocus;
end;

procedure TChangePasswordFrm.btnOKClick(Sender: TObject);
begin
  inherited;
  if SameText(Trim(edtNewPassword.Text), Trim(edtConfirmPassword.Text)) then
  begin
    edtNewPassword.Clear;
    edtConfirmPassword.Clear;
    edtNewPassword.SetFocus;

    raise EValidateException.Create('Your new password is the same as or too similar to you curent pasword.' + CRLF +
      'Please enter a different password.');
  end;
end;

procedure TChangePasswordFrm.edtCurrentPasswordPropertiesChange(Sender: TObject);
begin
  inherited;
  btnContinue.Enabled := SameStr(Trim(edtCurrentPassword.Text), FCurrentPassword);
end;

end.

