unit uRegistrador;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, MemDS, DBAccess, MyAccess, StdCtrls, Buttons, Grids, DBGrids;

type
  TfrmRegistrador = class(TForm)
    LabelRegistrador: TLabel;
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    BitBtnCopiar: TBitBtn;
    BitBtnCancelar: TBitBtn;
    MyTableRegistrador: TMyTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtnCopiarClick(Sender: TObject);
    procedure BitBtnCancelarClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
  public
    psSalida : string;

    function Inicializar (rsCampo : string) : Boolean;
  end;

var
  frmRegistrador: TfrmRegistrador;

implementation

uses
  uMain;

{$R *.DFM}

function TfrmRegistrador.Inicializar (rsCampo : string) : Boolean;
var
  lbTodoBien : Boolean;
begin
  lbTodoBien := True;

  try
    MyTableRegistrador.Open;
    MyTableRegistrador.OrderFields := 'name';

    if (Trim (rsCampo) = '') or (MyTableRegistrador.Locate ('id', rsCampo, []) = False) then
      MyTableRegistrador.First;
  except
    on E: Exception do begin
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
      lbTodoBien := False;
    end;
  end;

  Result := lbTodoBien;
end;

procedure TfrmRegistrador.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MyTableRegistrador.Active = True) then
    MyTableRegistrador.Close;
end;

procedure TfrmRegistrador.DBGridDblClick(Sender: TObject);
begin
  BitBtnCopiarClick (nil);
end;

procedure TfrmRegistrador.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then 
    BitBtnCopiarClick (nil);
end;

procedure TfrmRegistrador.BitBtnCopiarClick(Sender: TObject);
begin
  psSalida := MyTableRegistrador.FieldByName ('id').AsString;

  Self.ModalResult := mrOk;
end;

procedure TfrmRegistrador.BitBtnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

end.

