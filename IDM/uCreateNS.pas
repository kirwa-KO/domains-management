unit uCreateNS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, MemDS, DBAccess, MyAccess, StdCtrls, Buttons, Grids,
  DBGrids, ExtCtrls;

type
  TfrmCreateNS = class(TForm)
    LabelDNSServers: TLabel;
    LabelHost: TLabel;
    LabelIP: TLabel;
    LabelOS: TLabel;
    LabelUser: TLabel;
    LabelPassword: TLabel;
    LabelID: TLabel;
    LabelStatus: TLabel;
    LabelStillAlive: TLabel;
    Bevel: TBevel;
    ComboBoxOS: TComboBox;
    DBGridDNS: TDBGrid;
    EditHost: TEdit;
    EditIP: TEdit;
    EditUser: TEdit;
    EditPassword: TEdit;
    EditID: TEdit;
    EditStatus: TEdit;
    EditStillAlive: TEdit;
    BitBtnCreate: TBitBtn;
    BitBtnCerrar: TBitBtn;
    DataSource: TDataSource;
    MyTableNServers: TMyTable;
    MyTableOS: TMyTable;
    MyTableNServersHost: TStringField;
    MyTableNServersIP: TStringField;
    MyTableNServersOS: TIntegerField;
    MyTableNServersUsr: TStringField;
    MyTableNServersPass: TStringField;
    MyTableNServersStatus: TStringField;
    MyTableNServerslping: TFloatField;
    MyTableNServersID: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure BitBtnCreateClick(Sender: TObject);
  private
    piCuantosOSHay : Integer;
    paOSIDs : array [0..49] of Integer;
    paOSNombres : array [0..49] of string;  // [50]

    function Validar_Datos : Boolean;
  public
    function Inicializar (riQuien : Integer) : Boolean;
  end;

var
  frmCreateNS: TfrmCreateNS;

implementation

uses
  uMain, uResultsWhoIs;

{$R *.dfm}

function TfrmCreateNS.Inicializar (riQuien : Integer) : Boolean;
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


  if (lbSalida = True) then begin
    if (riQuien = 1) then begin
      EditHost.Text := frmResultWhoIs.EditNS1.Text;
      EditIP.Text := frmResultWhoIs.EditNSIP1.Text;
    end
    else if (riQuien = 2) then begin
      EditHost.Text := frmResultWhoIs.EditNS2.Text;
      EditIP.Text := frmResultWhoIs.EditNSIP2.Text;
    end
    else if (riQuien = 3) then begin
      EditHost.Text := frmResultWhoIs.EditNS3.Text;
      EditIP.Text := frmResultWhoIs.EditNSIP3.Text;
    end
    else if (riQuien = 4) then begin
      EditHost.Text := frmResultWhoIs.EditNS4.Text;
      EditIP.Text := frmResultWhoIs.EditNSIP4.Text;
    end;
  end;

  Result := lbSalida;
end;

procedure TfrmCreateNS.FormCreate(Sender: TObject);
begin
  EditHost.MaxLength     := MyTableNServersHost.Size;
  EditIP.MaxLength       := MyTableNServersIP.Size;
  EditUser.MaxLength     := MyTableNServersUsr.Size;
  EditPassword.MaxLength := MyTableNServersPass.Size;
  EditStatus.MaxLength   := MyTableNServersStatus.Size;
end;

procedure TfrmCreateNS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MyTableNServers.Active = True) then
    MyTableNServers.Close;
end;

procedure TfrmCreateNS.BitBtnCerrarClick(Sender: TObject);
begin
  Self.Close;
end;

function TfrmCreateNS.Validar_Datos : Boolean;
begin
  // OS
  if (ComboBoxOS.ItemIndex < 0) then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelOS.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end;

  {// Handle
  lsHandle := Trim (EditHandle.Text);
  if (lsHandle = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelHandle.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end;}

  Result := True;
end;

procedure TfrmCreateNS.BitBtnCreateClick(Sender: TObject);
begin
  try
    if (Validar_Datos = True) then begin
      MyTableNServers.Append;

      MyTableNServersHost.Value   := AnsiString (Trim (EditHost.Text));
      MyTableNServersIP.Value     := AnsiString (Trim (EditIP.Text));
      MyTableNServersOS.Value     := paOSIDs [ComboBoxOS.ItemIndex];
      MyTableNServersUsr.Value    := AnsiString (Trim (EditUser.Text));
      MyTableNServersPass.Value   := AnsiString (Trim (EditPassword.Text));
      MyTableNServersStatus.Value := AnsiString (Trim (EditStatus.Text));
      MyTableNServerslping.Value  := 0;

      MyTableNServers.Post;

      frmMain.MessageBoxBeep (Self.Handle, 'The register was created successfully', 'Información', MB_OK);

      // Cerrar esta ventana
      Self.ModalResult := mrOK;
    end;
  except
    on E: Exception do begin
      MyTableNServers.Cancel;
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
    end;
  end;
end;

end.

