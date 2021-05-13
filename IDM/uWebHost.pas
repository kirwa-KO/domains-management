unit uWebHost;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, MemDS, DBAccess, MyAccess, StdCtrls, Buttons, Grids, DBGrids;

type
  TfrmWebHost = class(TForm)
    DataSource: TDataSource;
    LabelWebHost: TLabel;
    DBGrid: TDBGrid;
    BitBtnCopiar: TBitBtn;
    BitBtnCancelar: TBitBtn;
    MyTableNHosts: TMyTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtnCopiarClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtnCancelarClick(Sender: TObject);
  public
    psSalida : string;

    function Inicializar (rsCampo, rsTitulo : string) : Boolean;
  end;

var
  frmWebHost: TfrmWebHost;

implementation

uses
  uMain;

{$R *.dfm}

function TfrmWebHost.Inicializar (rsCampo, rsTitulo : string) : Boolean;
var
  lbTodoBien : Boolean;
begin
  lbTodoBien := True;

  Self.Caption := rsTitulo;
  LabelWebHost.Caption := rsTitulo;

  try
    MyTableNHosts.Open;
    MyTableNHosts.OrderFields := 'name';

    if (Trim (rsCampo) = '') or (MyTableNHosts.Locate ('id', rsCampo, []) = False) then
      MyTableNHosts.First;
  except
    on E: Exception do begin
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
      lbTodoBien := False;
    end;
  end;

  Result := lbTodoBien;
end;

procedure TfrmWebHost.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MyTableNHosts.Active = True) then
    MyTableNHosts.Close;
end;

procedure TfrmWebHost.DBGridDblClick(Sender: TObject);
begin
  BitBtnCopiarClick (nil);
end;

procedure TfrmWebHost.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then 
    BitBtnCopiarClick (nil);
end;

procedure TfrmWebHost.BitBtnCopiarClick(Sender: TObject);
begin
  psSalida := MyTableNHosts.FieldByName ('id').AsString;

  Self.ModalResult := mrOk;
end;

procedure TfrmWebHost.BitBtnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

end.

