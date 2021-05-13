unit uPersonas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, MemDS, DBAccess, MyAccess, StdCtrls, Buttons, Grids, DBGrids;

type
  TfrmPersonas = class(TForm)
    DataSource: TDataSource;
    LabelPersons: TLabel;
    DBGrid: TDBGrid;
    BitBtnCopiar: TBitBtn;
    BitBtnCancelar: TBitBtn;
    MyTablePerson: TMyTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtnCopiarClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtnCancelarClick(Sender: TObject);
  public
    psSalida : string;

    function Inicializar (rsCampo : string) : Boolean;
  end;

var
  frmPersonas: TfrmPersonas;

implementation

uses
  uMain;

{$R *.dfm}

function TfrmPersonas.Inicializar (rsCampo : string) : Boolean;
var
  lbSalida : Boolean;
begin
  lbSalida := True;

  try
    MyTablePerson.Open;
    MyTablePerson.OrderFields := 'first';

    if (Trim (rsCampo) = '') or (MyTablePerson.Locate ('id', rsCampo, []) = False) then
      MyTablePerson.First;
  except
    on E: Exception do begin
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
      lbSalida := False;
    end;
  end;

  Result := lbSalida;
end;

procedure TfrmPersonas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MyTablePerson.Active = True) then
    MyTablePerson.Close;
end;

procedure TfrmPersonas.DBGridDblClick(Sender: TObject);
begin
  BitBtnCopiarClick (nil);
end;

procedure TfrmPersonas.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then 
    BitBtnCopiarClick (nil);
end;

procedure TfrmPersonas.BitBtnCopiarClick(Sender: TObject);
begin
  psSalida := MyTablePerson.FieldByName ('id').AsString;

  Self.ModalResult := mrOk;
end;

procedure TfrmPersonas.BitBtnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

end.

