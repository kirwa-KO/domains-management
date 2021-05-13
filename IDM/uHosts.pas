unit uHosts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, MemDS, DBAccess, MyAccess, StdCtrls, Buttons, Grids,
  DBGrids, ExtCtrls;

type
  TfrmHosts = class(TForm)
    DataSource: TDataSource;
    LabelHosts: TLabel;
    DBGrid: TDBGrid;
    LabelName: TLabel;
    EditName: TEdit;
    LabelIP: TLabel;
    EditIP: TEdit;
    LabelID: TLabel;
    EditID: TEdit;
    Bevel: TBevel;
    BitBtnNuevo: TBitBtn;
    BitBtnBorrar: TBitBtn;
    BitBtnModificar: TBitBtn;
    BitBtnCerrar: TBitBtn;
    MyTableNHosts: TMyTable;
    MyTableNHostsName: TStringField;
    MyTableNHostsIP: TStringField;
    MyTableNHostsID: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MyTableNHostsAfterScroll(DataSet: TDataSet);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure BitBtnModificarClick(Sender: TObject);
    procedure BitBtnNuevoClick(Sender: TObject);
    procedure BitBtnBorrarClick(Sender: TObject);
  private
    pbNuevo : Boolean;

    function Validar_Datos : Boolean;
    procedure Cargar_Valores;
    procedure Cambiar_Estado_Nuevo;
  public
    function Inicializar : Boolean;
  end;

var
  frmHosts: TfrmHosts;

implementation

uses
  uMain;

{$R *.dfm}

function TfrmHosts.Inicializar : Boolean;
var
  lbSalida : Boolean;
begin
  lbSalida := True;

  try
    MyTableNHosts.Open;
    MyTableNHosts.OrderFields := 'name';
    MyTableNHosts.First;
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

procedure TfrmHosts.Cambiar_Estado_Nuevo;
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

procedure TfrmHosts.Cargar_Valores;
begin
  EditName.Text := MyTableNHostsName.AsString;
  EditIP.Text   := MyTableNHostsIP.AsString;
  EditID.Text   := MyTableNHostsID.AsString;
end;

procedure TfrmHosts.FormCreate(Sender: TObject);
begin
  pbNuevo := False;

  EditName.MaxLength := MyTableNHostsName.Size;
  EditIP.MaxLength   := MyTableNHostsIP.Size;
  EditID.MaxLength   := MyTableNHostsID.Size;
end;

procedure TfrmHosts.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MyTableNHosts.Active = True) then
    MyTableNHosts.Close;
end;

procedure TfrmHosts.BitBtnCerrarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmHosts.MyTableNHostsAfterScroll(DataSet: TDataSet);
begin
  if (pbNuevo = True) then
    Cambiar_Estado_Nuevo ();

  Cargar_Valores ();
end;

function TfrmHosts.Validar_Datos : Boolean;
var
  lsName, lsIP : string;
begin
  // Name
  lsName := Trim (EditName.Text);
  if (lsName = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelName.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end;

  // IP
  lsIP := Trim (EditIP.Text);
  if (lsIP = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelIP.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end;

  if (frmMain.Validar_IP (lsIP) = False) then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error in the IP address', 'Error', MB_OK);
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

procedure TfrmHosts.BitBtnModificarClick(Sender: TObject);
begin
  if (Validar_Datos () = True) then begin
    if (MessageDlg ('The current register will be modified. Are you sure?', mtConfirmation, mbOKCancel, 0) = mrOK) then begin
      try
        MyTableNHosts.Edit;

        MyTableNHostsName.Value := AnsiString (Trim (EditName.Text));
        MyTableNHostsIP.Value   := AnsiString (Trim (EditIP.Text));

        MyTableNHosts.Post;

        //frmMain.MessageBoxBeep (Self.Handle, 'The register was modified successfully', 'Información', MB_OK);
      except
        on E: Exception do begin
          frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        end;
      end;
    end;
  end;
end;

procedure TfrmHosts.BitBtnNuevoClick(Sender: TObject);
begin
  if (pbNuevo = False) then begin
    try
      MyTableNHosts.Append;

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
        MyTableNHostsName.Value   := AnsiString (Trim (EditName.Text));
        MyTableNHostsIP.Value     := AnsiString (Trim (EditIP.Text));

        MyTableNHosts.Post;

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

procedure TfrmHosts.BitBtnBorrarClick(Sender: TObject);
begin
  if (pbNuevo = True) then begin
    // Se hizo un 'Append' (Opcion Cancel)
    try
      MyTableNHosts.Cancel;
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
        MyTableNHosts.Delete;
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

