unit uRegistrar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, MemDS, DBAccess, MyAccess, StdCtrls, Buttons, Grids,
  DBGrids, ExtCtrls;

type
  TfrmRegistrar = class(TForm)
    DataSource: TDataSource;
    LabelRegistrar: TLabel;
    DBGrid: TDBGrid;
    LabelName: TLabel;
    EditName: TEdit;
    LabelURL: TLabel;
    EditURL: TEdit;
    LabelID: TLabel;
    EditID: TEdit;
    Bevel: TBevel;
    BitBtnNuevo: TBitBtn;
    BitBtnBorrar: TBitBtn;
    BitBtnModificar: TBitBtn;
    BitBtnCerrar: TBitBtn;
    MyTableRegistrar: TMyTable;
    MyTableRegistrarName: TStringField;
    MyTableRegistrarURL: TStringField;
    MyTableRegistrarID: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure BitBtnModificarClick(Sender: TObject);
    procedure BitBtnNuevoClick(Sender: TObject);
    procedure BitBtnBorrarClick(Sender: TObject);
    procedure MyTableRegistrarAfterScroll(DataSet: TDataSet);
  private
    pbNuevo : Boolean;

    function Validar_Datos : Boolean;
    procedure Cargar_Valores;
    procedure Cambiar_Estado_Nuevo;
  public
    function Inicializar : Boolean;
  end;

var
  frmRegistrar: TfrmRegistrar;

implementation

uses
  uMain;

{$R *.dfm}

function TfrmRegistrar.Inicializar : Boolean;
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
    Cargar_Valores ();

  Result := lbSalida;
end;

procedure TfrmRegistrar.Cambiar_Estado_Nuevo;
begin
  if (pbNuevo = True) then begin
    pbNuevo := False;
    BitBtnNuevo.Caption := '&New';
    BitBtnBorrar.Caption := '&Delete';
    BitBtnModificar.Enabled := True;
  end
  else begin
    pbNuevo := True;
    BitBtnNuevo.Caption := '&Save';
    BitBtnBorrar.Caption := '&Cancel';
    BitBtnModificar.Enabled := False;
  end;
end;

procedure TfrmRegistrar.Cargar_Valores;
begin
  EditName.Text := MyTableRegistrarName.AsString;
  EditURL.Text  := MyTableRegistrarURL.AsString;
  EditID.Text   := MyTableRegistrarID.AsString;
end;

procedure TfrmRegistrar.FormCreate(Sender: TObject);
begin
  pbNuevo := False;
  Cargar_Valores ();
end;

procedure TfrmRegistrar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MyTableRegistrar.Active = True) then
    MyTableRegistrar.Close;
end;

procedure TfrmRegistrar.BitBtnCerrarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmRegistrar.MyTableRegistrarAfterScroll(DataSet: TDataSet);
begin
  if (pbNuevo = True) then
    Cambiar_Estado_Nuevo ();

  Cargar_Valores ();
end;

function TfrmRegistrar.Validar_Datos : Boolean;
var
  lsName, lsURL : string;
begin
  // Name
  lsName := Trim (EditName.Text);
  if (lsName = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelName.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end;

  // URL
  lsURL := Trim (EditURL.Text);
  if (lsURL = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelURL.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end;

  {// Handle
  lsHandle := Trim (EditHandle.Text);
  if (lsHandle = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelHandle.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end; }

  Result := True;
end;

procedure TfrmRegistrar.BitBtnModificarClick(Sender: TObject);
begin
  if (Validar_Datos = True) then begin
    if (MessageDlg ('The current register will be modified. Are you sure?', mtConfirmation, mbOKCancel, 0) = mrOK) then begin
      try
        MyTableRegistrar.Edit;

        MyTableRegistrarName.Value := AnsiString (Trim (EditName.Text));
        MyTableRegistrarURL.Value  := AnsiString (Trim (EditURL.Text));

        MyTableRegistrar.Post;

        //frmMain.MessageBoxBeep (Self.Handle, 'The register was modified successfully', 'Información', MB_OK);
      except
        on E: Exception do begin
          frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        end;
      end;
    end;
  end;
end;

procedure TfrmRegistrar.BitBtnNuevoClick(Sender: TObject);
begin
  if (pbNuevo = False) then begin
    try
      MyTableRegistrar.Append;

      Cambiar_Estado_Nuevo ();
    except
      on E: Exception do begin
        frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        pbNuevo := False;
      end;
    end;
  end
  else begin
    // Grabar el registro nuevo
    if (Validar_Datos = True) then begin
      try
        MyTableRegistrarName.Value := AnsiString (Trim (EditName.Text));
        MyTableRegistrarURL.Value  := AnsiString (Trim (EditURL.Text));

        MyTableRegistrar.Post;

        Cambiar_Estado_Nuevo ();
        Cargar_Valores ();

        frmMain.MessageBoxBeep (Self.Handle, 'The register was appended successfully', 'Información', MB_OK);
      except
        on E: Exception do begin
          frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        end;
      end;
    end;
  end;
end;

procedure TfrmRegistrar.BitBtnBorrarClick(Sender: TObject);
begin
  if (pbNuevo = True) then begin
    // Se hizo un 'Append' (Opcion Cancel)
    try
      MyTableRegistrar.Cancel;
      if (pbNuevo = True) then
        Cambiar_Estado_Nuevo ();
    except
      Beep;
    end;
  end
  else begin
    Beep;
    if (MessageDlg ('A register will be deleted. Are you sure?', mtConfirmation, mbOKCancel, 0) = mrOK) then begin
      try
        MyTableRegistrar.Delete;
        //frmMain.MessageBoxBeep (Self.Handle, 'The register was deleted', 'Información', MB_OK);
      except
        on E: Exception do begin
          frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        end;
      end;
    end;
  end;
end;

end.

