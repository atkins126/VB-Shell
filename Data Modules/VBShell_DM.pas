unit VBShell_DM;

interface

uses
  System.SysUtils, System.Classes,

  VBBase_DM, IPPeerClient,

  Data.DBXDataSnap, Data.DBXCommon,

  Data.DB, Data.SqlExpr, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TVBShellDM = class(TVBBaseDM)
    cdsSystemUser: TFDMemTable;
    cdsSystemUserID: TIntegerField;
    cdsSystemUserFIRST_NAME: TStringField;
    cdsSystemUserLAST_NAME: TStringField;
    cdsSystemUserLOGIN_NAME: TStringField;
    cdsSystemUserEMAIL_ADDRESS: TStringField;
    cdsSystemUserPASSWORD: TStringField;
    cdsSystemUserACCOUNT_ENABLED: TIntegerField;
    dtsSystemUser: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VBShellDM: TVBShellDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.

