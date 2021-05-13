unit uNameServer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, MemDS, DBAccess, MyAccess, StdCtrls, Buttons, Grids, DBGrids;

type
  TfrmElegirDNS = class(TForm)
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    LabelNameServer: TLabel;
    BitBtnCopiar: TBitBtn;
    BitBtnCancelar: TBitBtn;
    MyTableNServers: TMyTable;
    MyTableNServersid: TIntegerField;
    MyTableNServershost: TStringField;
    MyTableNServersip: TStringField;
    MyTableNServersos: TIntegerField;
    MyTableNServersusr: TStringField;
    MyTableNServerspass: TStringField;
    MyTableNServersstatus: TStringField;
    MyTableNServerslping: TFloatField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtnCancelarClick(Sender: TObject);
    procedure BitBtnCopiarClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
  public
    psSalida : string;

    function Inicializar (rsCampo : string) : Boolean;
  end;

var
  frmElegirDNS: TfrmElegirDNS;

implementation

uses
  uMain;

{$R *.DFM}

function TfrmElegirDNS.Inicializar (rsCampo : string) : Boolean;
var
  lbSalida : Boolean;
begin
  lbSalida := True;

  try
    MyTableNServers.Open;
    MyTableNServers.OrderFields := 'host';

    if (Trim (rsCampo) = '') or (MyTableNServers.Locate ('id', rsCampo, []) = False) then
      MyTableNServers.First;
  except
    on E: Exception do begin
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
      lbSalida := False;
    end;
  end;

  Result := lbSalida;
end;

procedure TfrmElegirDNS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MyTableNServers.Active = True) then
    MyTableNServers.Close;
end;

procedure TfrmElegirDNS.DBGridDblClick(Sender: TObject);
begin
  BitBtnCopiarClick (nil);
end;

procedure TfrmElegirDNS.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    BitBtnCopiarClick (nil);
end;

procedure TfrmElegirDNS.BitBtnCopiarClick(Sender: TObject);
begin
  psSalida := MyTableNServers.FieldByName ('id').AsString;

  Self.ModalResult := mrOk;
end;

procedure TfrmElegirDNS.BitBtnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

end.

