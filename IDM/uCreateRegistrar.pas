unit uCreateRegistrar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, MemDS, DBAccess, MyAccess, StdCtrls, Buttons, Grids,
  DBGrids, ExtCtrls;

type
  TfrmCreateRegistrar = class(TForm)
    DataSource: TDataSource;
    LabelRegistrar: TLabel;
    DBGrid: TDBGrid;
    LabelName: TLabel;
    EditName: TEdit;
    LabelID: TLabel;
    EditID: TEdit;
    LabelURL: TLabel;
    EditURL: TEdit;
    Bevel: TBevel;
    BitBtnCreate: TBitBtn;
    BitBtnCerrar: TBitBtn;
    MyTableRegistrar: TMyTable;
    MyTableRegistrarName: TStringField;
    MyTableRegistrarURL: TStringField;
    MyTableRegistrarID: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure BitBtnCreateClick(Sender: TObject);
  private
    function Validar_Datos : Boolean;
  public
    function Inicializar : Boolean;
  end;

var
  frmCreateRegistrar: TfrmCreateRegistrar;

implementation

uses
  uMain, uResultsWhoIs;

{$R *.dfm}

function TfrmCreateRegistrar.Inicializar : Boolean;
var
  lbSalida : Boolean;
begin
  lbSalida := True;

  try
    MyTableRegistrar.Open;
    MyTableRegistrar.OrderFields := 'name';
    MyTableRegistrar.First;
  except
    on E: Exception do begin
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
      lbSalida := False;
    end;
  end;

  if (lbSalida = True) then
    EditName.Text := frmResultWhoIs.EditRegistrador.Text;

  Result := lbSalida;
end;

procedure TfrmCreateRegistrar.FormCreate(Sender: TObject);
begin
  EditName.MaxLength := MyTableRegistrarName.Size;
  EditURL.MaxLength  := MyTableRegistrarURL.Size;
end;

procedure TfrmCreateRegistrar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MyTableRegistrar.Active = True) then
    MyTableRegistrar.Close;
end;

procedure TfrmCreateRegistrar.BitBtnCerrarClick(Sender: TObject);
begin
  Self.Close;
end;

function TfrmCreateRegistrar.Validar_Datos : Boolean;
begin
  {// Handle
  lsHandle := Trim (EditHandle.Text);
  if (lsHandle = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelHandle.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end;}

  Result := True;
end;

procedure TfrmCreateRegistrar.BitBtnCreateClick(Sender: TObject);
begin
  try
    if (Validar_Datos = True) then begin
      MyTableRegistrar.Append;

      MyTableRegistrarName.Value := AnsiString (Trim (EditName.Text));
      MyTableRegistrarURL.Value  := AnsiString (Trim (EditURL.Text));

      MyTableRegistrar.Post;

      frmMain.MessageBoxBeep (Self.Handle, 'The register was created successfully', 'Información', MB_OK);

      // Cerrar esta ventana
      Self.ModalResult := mrOK;
    end;
  except
    on E: Exception do begin
      MyTableRegistrar.Cancel;
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
    end;
  end;
end;

end.

