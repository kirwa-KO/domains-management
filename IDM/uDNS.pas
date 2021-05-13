unit uDNS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, MemDS, DBAccess, MyAccess, StdCtrls, Buttons, Grids, DBGrids,
  ExtCtrls;

type
  TfrmDNS = class(TForm)
    DataSource: TDataSource;
    DBGridDNS: TDBGrid;
    LabelDNSServers: TLabel;
    LabelHost: TLabel;
    EditHost: TEdit;
    LabelIP: TLabel;
    EditIP: TEdit;
    LabelOS: TLabel;
    LabelUser: TLabel;
    EditUser: TEdit;
    LabelPassword: TLabel;
    EditPassword: TEdit;
    LabelID: TLabel;
    EditID: TEdit;
    LabelStatus: TLabel;
    EditStatus: TEdit;
    LabelStillAlive: TLabel;
    EditStillAlive: TEdit;
    ComboBoxOS: TComboBox;
    BitBtnModificar: TBitBtn;
    BitBtnNuevo: TBitBtn;
    BitBtnBorrar: TBitBtn;
    BitBtnCerrar: TBitBtn;
    Bevel: TBevel;
    MyTableNServers: TMyTable;
    MyTableNServersID: TIntegerField;
    MyTableNServersHost: TStringField;
    MyTableNServersIP: TStringField;
    MyTableNServersOS: TIntegerField;
    MyTableNServersUsr: TStringField;
    MyTableNServersPass: TStringField;
    MyTableNServersStatus: TStringField;
    MyTableNServerslping: TFloatField;
    MyTableOS: TMyTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MyTableNServersAfterScroll(DataSet: TDataSet);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure BitBtnModificarClick(Sender: TObject);
    procedure BitBtnNuevoClick(Sender: TObject);
    procedure BitBtnBorrarClick(Sender: TObject);
  public
    function Inicializar : Boolean;
  private
    piCuantosOSHay : Integer;
    paOSIDs : array [0..49] of Integer;
    paOSNombres : array [0..49] of string;  // [50]

    pbNuevo : Boolean;

    function Validar_Datos : Boolean;
    procedure Cargar_Valores;
    procedure Cambiar_Estado_Nuevo;
  end;

var
  frmDNS: TfrmDNS;

implementation

uses
  uMain;

{$R *.DFM}

function TfrmDNS.Inicializar : Boolean;
var
  liCont : Integer;
  lbSalida : Boolean;
begin
  lbSalida := True;

  try
    MyTableNServers.Open;
    MyTableNServers.OrderFields := 'host';
    MyTableNServers.First;
  except
    on E: Exception do begin
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
      lbSalida := False;
    end;
  end;


  if (lbSalida = True) then begin
    // Cargar el ComboBox con los Sistemas Operativos (OS) existentes en la Base de Datos
    try
      MyTableOS.Open;

      liCont := 0;
      ComboBoxOS.Items.Clear;
      while (MyTableOS.EOF = False) do begin
        paOSIDs [liCont] := MyTableOS.FieldByName ('ID').AsInteger;
        paOSNombres [liCont] := MyTableOS.FieldByName ('OS').AsString;

        ComboBoxOS.Items.Add (paOSNombres [liCont]);
        Inc (liCont);

        MyTableOS.Next;
      end;
      piCuantosOSHay := liCont;

      ComboBoxOS.ItemIndex := 0;
    except
      on E: Exception do begin
        frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        lbSalida := False;
      end;
    end;

    if (MyTableOS.Active = True) then
      MyTableOS.Close;
  end;


  if (lbSalida = True) then
    Cargar_Valores ();

  Result := lbSalida;
end;

procedure TfrmDNS.Cambiar_Estado_Nuevo;
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

procedure TfrmDNS.Cargar_Valores;
var
  lnI, liOS : Integer;
  lbExiste : Boolean;
begin
  EditHost.Text := MyTableNServersHost.AsString;
  EditIP.Text   := MyTableNServersIP.AsString;

  lbExiste := False;
  liOS := MyTableNServersOS.Value;
  for lnI := 0 to piCuantosOSHay-1 do begin
    if (liOS = paOSIDs [lnI]) then begin
      ComboBoxOS.ItemIndex := lnI;
      lbExiste := True;
      Break;
    end;
  end;

  if (lbExiste = False) then
    ComboBoxOS.ItemIndex := -1;

  EditUser.Text     := MyTableNServersUsr.AsString;
  EditPassword.Text := MyTableNServersPass.AsString;
  EditID.Text       := MyTableNServersID.AsString;
  EditStatus.Text   := MyTableNServersStatus.AsString;

  if (MyTableNServerslping.Value = 0) then
    EditStillAlive.Text := ''
  else
    EditStillAlive.Text := DateTimeToStr (MyTableNServerslping.Value);
end;

procedure TfrmDNS.FormCreate(Sender: TObject);
begin
  pbNuevo := False;

  EditHost.MaxLength     := MyTableNServersHost.Size;
  EditIP.MaxLength       := MyTableNServersIP.Size;
  EditUser.MaxLength     := MyTableNServersUsr.Size;
  EditPassword.MaxLength := MyTableNServersPass.Size;
  EditID.MaxLength       := MyTableNServersID.Size;
  EditStatus.MaxLength   := MyTableNServersStatus.Size;
end;

procedure TfrmDNS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MyTableNServers.Active = True) then
    MyTableNServers.Close;
end;

procedure TfrmDNS.BitBtnCerrarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmDNS.MyTableNServersAfterScroll(DataSet: TDataSet);
begin
  if (pbNuevo = True) then
    Cambiar_Estado_Nuevo ();

  Cargar_Valores ();
end;

function TfrmDNS.Validar_Datos : Boolean;
var
  lsHost, lsIP, lsUser, lsPassword, lsStatus : string;
begin
  // Host
  lsHost := Trim (EditHost.Text);
  if (lsHost = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelHost.Caption, 'Error', MB_OK);
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


  // OS
  if (ComboBoxOS.ItemIndex < 0) then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelOS.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end;


  // User
  lsUser := Trim (EditUser.Text);
  if (lsUser = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelUser.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end;


  // Password
  lsPassword := Trim (EditPassword.Text);
  if (lsPassword = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelPassword.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end;


  {// ID
  lsHandle := Trim (EditID.Text);
  if (lsHandle = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelID.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end; }


  // Status
  lsStatus := Trim (EditStatus.Text);
  if (lsStatus = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelStatus.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end;


  Result := True;
end;

procedure TfrmDNS.BitBtnModificarClick(Sender: TObject);
begin
  if (Validar_Datos = True) then begin
    if (MessageDlg ('The current register will be modified. Are you sure?', mtConfirmation, mbOKCancel, 0) = mrOK) then begin
      try
        MyTableNServers.Edit;

        MyTableNServersHost.Value   := AnsiString (Trim (EditHost.Text));
        MyTableNServersIP.Value     := AnsiString (Trim (EditIP.Text));
        MyTableNServersOS.Value     := paOSIDs [ComboBoxOS.ItemIndex];
        MyTableNServersUsr.Value    := AnsiString (Trim (EditUser.Text));
        MyTableNServersPass.Value   := AnsiString (Trim (EditPassword.Text));
        MyTableNServersStatus.Value := AnsiString (Trim (EditStatus.Text));
        //MyTableNServerslping.Value := 0;

        MyTableNServers.Post;

        //frmMain.MessageBoxBeep (Self.Handle, 'The register was modified successfully', 'Información', MB_OK);
      except
        on E: Exception do begin
          frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        end;
      end;
    end;
  end;
end;

procedure TfrmDNS.BitBtnNuevoClick(Sender: TObject);
begin
  if (pbNuevo = False) then begin
    try
      MyTableNServers.Append;

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
    if (Validar_Datos () = True) then begin
      try
        MyTableNServersHost.Value   := AnsiString (Trim (EditHost.Text));
        MyTableNServersIP.Value     := AnsiString (Trim (EditIP.Text));
        MyTableNServersOS.Value     := paOSIDs [ComboBoxOS.ItemIndex];
        MyTableNServersUsr.Value    := AnsiString (Trim (EditUser.Text));
        MyTableNServersPass.Value   := AnsiString (Trim (EditPassword.Text));
        MyTableNServersStatus.Value := AnsiString (Trim (EditStatus.Text));
        MyTableNServerslping.Value  := 0;

        MyTableNServers.Post;

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

procedure TfrmDNS.BitBtnBorrarClick(Sender: TObject);
begin
  if (pbNuevo = True) then begin
    // Se hizo un 'Append' (Opcion Cancel)
    try
      MyTableNServers.Cancel;
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
        MyTableNServers.Delete;
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

