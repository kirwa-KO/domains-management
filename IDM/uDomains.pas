unit uDomains;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, MyAccess, MemDS, DBAccess, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdWhois, Grids, DBGrids, ComCtrls,
  StdCtrls, Buttons, ExtCtrls;

{const
  k01_01_1990 = 32874.424153646; }

type
  TfrmDominios = class(TForm)
    DataSource: TDataSource;
    IdWhois: TIdWhois;
    StatusBar: TStatusBar;
    PanelAbajo: TPanel;
    PanelAbajoIzquierda: TPanel;
    PanelAbajoDerecha: TPanel;
    BitBtnModificar: TBitBtn;
    BitBtnBorrar: TBitBtn;
    BitBtnNuevo: TBitBtn;
    BitBtnVerificarInfo: TBitBtn;
    BitBtnCerrar: TBitBtn;
    PanelDerecha: TPanel;
    LabelDomainName: TLabel;
    EditName: TEdit;
    BitBtnWhoIs: TBitBtn;
    LabelNS1: TLabel;
    EditNS1: TEdit;
    BitBtnNS1: TBitBtn;
    LabelNS2: TLabel;
    EditNS2: TEdit;
    BitBtnNS2: TBitBtn;
    LabelNS3: TLabel;
    EditNS3: TEdit;
    BitBtnNS3: TBitBtn;
    LabelNS4: TLabel;
    EditNS4: TEdit;
    BitBtnNS4: TBitBtn;
    LabelMailServer1: TLabel;
    EditMailServer1: TEdit;
    BitBtnMailServer1: TBitBtn;
    LabelMailServer2: TLabel;
    EditMailServer2: TEdit;
    BitBtnMailServer2: TBitBtn;
    LabelWebHost: TLabel;
    EditWebHost: TEdit;
    BitBtnWebHost: TBitBtn;
    LabelOwner: TLabel;
    EditOwner: TEdit;
    BitBtnOwner: TBitBtn;
    LabelAdmin: TLabel;
    EditAdmin: TEdit;
    BitBtnAdmin: TBitBtn;
    LabelTecnico: TLabel;
    EditTecnico: TEdit;
    BitBtnTecnico: TBitBtn;
    LabelBill: TLabel;
    EditBill: TEdit;
    BitBtnBill: TBitBtn;
    LabelRegistrador: TLabel;
    EditRegistrador: TEdit;
    BitBtnRegistrador: TBitBtn;
    LabelVendorPassword: TLabel;
    EditVendorPassword: TEdit;
    LabelExpira: TLabel;
    DateTimePickerExpira: TDateTimePicker;
    UpDown: TUpDown;
    PanelIzquierda: TPanel;
    DBGridDomains: TDBGrid;
    PanelIzquierdaAbajo: TPanel;
    LabelQuickSearch: TLabel;
    EditQuickSearch: TEdit;
    PanelIzquierdaArriba: TPanel;
    MyQueryDomains: TMyQuery;
    MyTableDomains: TMyTable;
    MyTableDomainsName: TStringField;
    MyTableDomainsNS1: TStringField;
    MyTableDomainsNS2: TStringField;
    MyTableDomainsNS3: TStringField;
    MyTableDomainsNS4: TStringField;
    MyTableDomainsMX1: TStringField;
    MyTableDomainsMX2: TStringField;
    MyTableDomainsWWW: TStringField;
    MyTableDomainsOwner: TStringField;
    MyTableDomainsAdminp: TStringField;
    MyTableDomainsTechp: TStringField;
    MyTableDomainsBillp: TStringField;
    MyTableDomainsRegistrar: TStringField;
    MyTableDomainsVpwd: TStringField;
    MyTableDomainsExpire: TFloatField;
    BitBtnAuto: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MyTableDomainsAfterScroll(DataSet: TDataSet);
    procedure EditQuickSearchChange(Sender: TObject);
    procedure EditQuickSearchKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtnNS1Click(Sender: TObject);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure BitBtnModificarClick(Sender: TObject);
    procedure BitBtnNuevoClick(Sender: TObject);
    procedure BitBtnBorrarClick(Sender: TObject);
    procedure BitBtnWhoIsClick(Sender: TObject);
    procedure BitBtnRegistradorClick(Sender: TObject);
    procedure BitBtnWebHostClick(Sender: TObject);
    procedure BitBtnMailServer1Click(Sender: TObject);
    procedure BitBtnOwnerClick(Sender: TObject);
    procedure EditNameChange(Sender: TObject);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure BitBtnAutoClick(Sender: TObject);
  public
    psRegistrar : string;
    psAdminLast, psAdminFirst, psAdminID, psAdminEMail, psAdminName, psAdminPhone : string;
    psTecnicoLast, psTecnicoFirst, psTecnicoID, psTecnicoEMail, psTecnicoName, psTecnicoPhone : string;
    psLast, psFirst, psID, psEMail, psName, psPhone : string;
    pdExpire : Double;
    paNS : array [0..3] of string;
    paNSIP : array [0..3] of string;

    function Inicializar : Boolean;
  private
    pbNuevo, pbAuto, pbErrorNoMatch : Boolean;

    function Validar_Datos : Boolean;
    function Obtener_Cadena_hasta_Caracter (riPos : Integer; rsCadena : string; riByte : Integer) : string;
    function Convertir_a_Fecha_Double (rsFecha : string) : Double;
    function Convertir_a_Fecha_Double_2 (rsFecha : string) : Double;
    function Convertir_a_Fecha_Double_3 (rsFecha : string) : Double;
    procedure Cargar_Valores;
    procedure Cambiar_Estado_Nuevo;
    procedure Cargar_Resultados (rbVerificarInfo : Boolean);
  end;

var
  frmDominios: TfrmDominios;

implementation

{$R *.DFM}

uses
  uMain, uNameServer, uRegistrador, uWebHost, uPersonas, uResultsWhoIs;

function TfrmDominios.Inicializar : Boolean;
var
  lbSalida : Boolean;
begin
  lbSalida := True;

  try
    MyTableDomains.Open;
    MyTableDomains.OrderFields := 'name';
    MyTableDomains.First;
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

function TfrmDominios.Convertir_a_Fecha_Double (rsFecha : string) : Double;
var
  lnI, liMes : Integer;
  lsDia, lsMes, lsYear : string;
  ldSalida : Double;
begin
  // 29-Mar-2005.
  // 02-Feb-2012.
  rsFecha := Trim (rsFecha);

  lsDia := Copy (rsFecha, 1, 2);
  lsMes := Copy (rsFecha, 4, 3);
  lsYear := Copy (rsFecha, 8, 4);

  liMes := 0;
  for lnI := 1 to 12 do begin
    if (UpperCase (Copy (kMeses [lnI], 1, 3)) = UpperCase (lsMes)) then begin
      liMes := lnI;
      Break;
    end;
  end;

  if (liMes = 0) then
    ldSalida := 0
  else begin
    try
      ldSalida := EncodeDate (StrToInt (lsYear), liMes, StrToInt (lsDia));
    except
      ldSalida := 0;
    end;
  end;

  Result := ldSalida;
end;

function TfrmDominios.Convertir_a_Fecha_Double_2 (rsFecha : string) : Double;
var
  lsDia, lsMes, lsYear : string;
  ldSalida : Double;
begin
  // 2013-03-22
  rsFecha := Trim (rsFecha);

  lsYear := Copy (rsFecha, 1, 4);
  lsMes := Copy (rsFecha, 6, 2);
  lsDia := Copy (rsFecha, 9, 2);

  try
    ldSalida := EncodeDate (StrToInt (lsYear), StrToInt (lsMes), StrToInt (lsDia));
  except
    ldSalida := 0;
  end;

  Result := ldSalida;
end;

function TfrmDominios.Convertir_a_Fecha_Double_3 (rsFecha : string) : Double;
var
  lnI, liMes : Integer;
  lsDia, lsMes, lsYear : string;
  ldSalida : Double;
begin
  // Sun Mar 16 23:59:59 GMT 2014
  rsFecha := Trim (rsFecha);

  lsYear := Copy (rsFecha, Length (rsFecha)-3, 4);
  lsMes := Copy (rsFecha, 5, 3);
  lsDia := Copy (rsFecha, 9, 2);

  liMes := 0;
  for lnI := 1 to 12 do begin
    if (UpperCase (Copy (kMeses [lnI], 1, 3)) = UpperCase (lsMes)) then begin
      liMes := lnI;
      Break;
    end;
  end;

  try
    ldSalida := EncodeDate (StrToInt (lsYear), liMes, StrToInt (lsDia));
  except
    ldSalida := 0;
  end;

  Result := ldSalida;
end;

function TfrmDominios.Obtener_Cadena_hasta_Caracter (riPos : Integer; rsCadena : string; riByte : Integer) : string;
var
  lsTemp : string;
begin
  lsTemp := '';

  while (riPos <= Length (rsCadena)) and (Ord (rsCadena [riPos]) <> riByte) do begin
    lsTemp := lsTemp + rsCadena [riPos];
    Inc (riPos);
  end;

  Result := lsTemp;
end;

procedure TfrmDominios.Cambiar_Estado_Nuevo;
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

procedure TfrmDominios.Cargar_Valores;
begin
  EditName.Text := MyTableDomainsName.AsString;

  EditNS1.Text := MyTableDomainsNS1.AsString;
  EditNS2.Text := MyTableDomainsNS2.AsString;
  EditNS3.Text := MyTableDomainsNS3.AsString;
  EditNS4.Text := MyTableDomainsNS4.AsString;

  EditMailServer1.Text := MyTableDomainsMX1.AsString;
  EditMailServer2.Text := MyTableDomainsMX2.AsString;

  EditWebHost.Text := MyTableDomainsWWW.AsString;

  EditOwner.Text := MyTableDomainsOwner.AsString;
  EditAdmin.Text := MyTableDomainsAdminp.AsString;
  EditTecnico.Text := MyTableDomainsTechp.AsString;
  EditBill.Text := MyTableDomainsBillp.AsString;

  EditRegistrador.Text := MyTableDomainsRegistrar.AsString;

  EditVendorPassword.Text := MyTableDomainsVpwd.AsString;

  {if (MyTableDomainsExpire.Value = 0) then
    DateTimePickerExpira.Date := k01_01_1990
  else }
    DateTimePickerExpira.Date := MyTableDomainsExpire.Value;
end;

procedure TfrmDominios.FormCreate(Sender: TObject);
begin
  //340+38+19 + 27   // 397+27 (424)
  //592 + 8   // 600

  // Ajustar la forma es caso de 'Large Fonts'
  if (PanelIzquierda.Height < 340) then
    Self.Height := Self.Height + (EditVendorPassword.Top + EditVendorPassword.Height + 15+10) - PanelIzquierda.Height;

  if (PanelIzquierda.Width < 219) then
    Self.Width := Self.Width + (219 - PanelIzquierda.Width);


  pbNuevo := False;

  UpDown.Min := 0;            
  UpDown.Max := 30000;
  UpDown.Position := 15000;

  // Inicializar
  EditQuickSearch.MaxLength := MyTableDomainsName.Size;

  EditName.MaxLength := MyTableDomainsName.Size;
  EditNS1.MaxLength := MyTableDomainsNS1.Size;
  EditNS2.MaxLength := MyTableDomainsNS1.Size;
  EditNS3.MaxLength := MyTableDomainsNS1.Size;
  EditNS4.MaxLength := MyTableDomainsNS1.Size;
  EditMailServer1.MaxLength := MyTableDomainsMX1.Size;
  EditMailServer2.MaxLength := MyTableDomainsMX1.Size;
  EditWebHost.MaxLength := MyTableDomainsWWW.Size;
  EditOwner.MaxLength := MyTableDomainsOwner.Size;
  EditAdmin.MaxLength := MyTableDomainsAdminp.Size;
  EditTecnico.MaxLength := MyTableDomainsTechp.Size;
  EditBill.MaxLength := MyTableDomainsBillp.Size;
  EditRegistrador.MaxLength := MyTableDomainsRegistrar.Size;
  EditVendorPassword.MaxLength := MyTableDomainsVpwd.Size;
  DateTimePickerExpira.Date := Now ();
end;

procedure TfrmDominios.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MyTableDomains.Active = True) then
    MyTableDomains.Close;
end;

procedure TfrmDominios.EditQuickSearchChange(Sender: TObject);
begin
  try
    MyQueryDomains.SQL.Clear;
    MyQueryDomains.SQL.Add ('SELECT name');
    MyQueryDomains.SQL.Add ('FROM domains');
    MyQueryDomains.SQL.Add ('WHERE name LIKE ''' + EditQuickSearch.Text + '%''');
    MyQueryDomains.Open;

    if (MyQueryDomains.RecordCount > 0) then begin
      MyTableDomains.Locate ('name', MyQueryDomains.FieldByName ('name').AsString, []);
    end;
  except
    on E: Exception do begin
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
    end;
  end;
end;

procedure TfrmDominios.EditQuickSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then begin
    Key := #0;
    DBGridDomains.SetFocus;
  end;
end;

procedure TfrmDominios.MyTableDomainsAfterScroll(DataSet: TDataSet);
begin
  if (pbNuevo = True) then
    Cambiar_Estado_Nuevo ();

  Cargar_Valores ();

  BitBtnModificar.Enabled := False;
end;

procedure TfrmDominios.BitBtnNS1Click(Sender: TObject);
var
  lsCadena : string;
begin
  try
    frmElegirDNS := TfrmElegirDNS.Create (nil);

    if (Sender = BitBtnNS1) then
      lsCadena := EditNS1.Text
    else if (Sender = BitBtnNS2) then
      lsCadena := EditNS2.Text
    else if (Sender = BitBtnNS3) then
      lsCadena := EditNS3.Text
    else if (Sender = BitBtnNS4) then
      lsCadena := EditNS4.Text;

    if (frmElegirDNS.Inicializar (lsCadena)= True) then begin
      if (frmElegirDNS.ShowModal = mrOk) then begin
        if (Sender = BitBtnNS1) then
          EditNS1.Text := frmElegirDNS.psSalida
        else if (Sender = BitBtnNS2) then
          EditNS2.Text := frmElegirDNS.psSalida
        else if (Sender = BitBtnNS3) then
          EditNS3.Text := frmElegirDNS.psSalida
        else if (Sender = BitBtnNS4) then
          EditNS4.Text := frmElegirDNS.psSalida;
      end;
    end;
  finally
    frmElegirDNS.Release;
  end;
end;

procedure TfrmDominios.BitBtnCerrarClick(Sender: TObject);
begin
  Self.Close;
end;

function TfrmDominios.Validar_Datos : Boolean;
var
  lsName : string;
begin
  // name
  lsName := Trim (EditName.Text);
  if (lsName = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelDomainName.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end;


  Result := True;
end;

procedure TfrmDominios.BitBtnModificarClick(Sender: TObject);
begin
  if (Validar_Datos () = True) then begin
    if (pbAuto = True) or (MessageDlg ('The current register will be modified. Are you sure?', mtConfirmation, mbOKCancel, 0) = mrOK) then begin
      try
        MyTableDomains.Edit;

        MyTableDomainsName.Value := AnsiString (Trim (EditName.Text));

        MyTableDomainsNS1.Value := AnsiString (Trim (EditNS1.Text));
        MyTableDomainsNS2.Value := AnsiString (Trim (EditNS2.Text));
        MyTableDomainsNS3.Value := AnsiString (Trim (EditNS3.Text));
        MyTableDomainsNS4.Value := AnsiString (Trim (EditNS4.Text));

        MyTableDomainsMX1.Value := AnsiString (Trim (EditMailServer1.Text));
        MyTableDomainsMX2.Value := AnsiString (Trim (EditMailServer2.Text));

        MyTableDomainsWWW.Value := AnsiString (Trim (EditWebHost.Text));

        MyTableDomainsOwner.Value  := AnsiString (Trim (EditOwner.Text));
        MyTableDomainsAdminp.Value := AnsiString (Trim (EditAdmin.Text));
        MyTableDomainsTechp.Value  := AnsiString (Trim (EditTecnico.Text));
        MyTableDomainsBillp.Value  := AnsiString (Trim (EditBill.Text));

        MyTableDomainsRegistrar.Value := AnsiString (Trim (EditRegistrador.Text));

        MyTableDomainsVpwd.Value := AnsiString (Trim (EditVendorPassword.Text));

        MyTableDomainsExpire.Value := Trunc (DateTimePickerExpira.Date);

        MyTableDomains.Post;

        //frmMain.MessageBoxBeep (Self.Handle, 'The register was modified successfully', 'Información', MB_OK);
      except
        on E: Exception do begin
          frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        end;
      end;
    end;
  end;
end;

procedure TfrmDominios.BitBtnNuevoClick(Sender: TObject);
var
  lwYear, lwMonth, lwDay : Word;
begin
  if (pbNuevo = False) then begin
    try
      MyTableDomains.Append;

      DecodeDate (Now (), lwYear, lwMonth, lwDay);
      DateTimePickerExpira.Date := EncodeDate (lwYear+1, lwMonth, lwDay);

      Cambiar_Estado_Nuevo ();
      Cargar_Valores ();

      EditName.SetFocus;
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
        MyTableDomainsName.Value := AnsiString (Trim (EditName.Text));

        MyTableDomainsNS1.Value := AnsiString (Trim (EditNS1.Text));
        MyTableDomainsNS2.Value := AnsiString (Trim (EditNS2.Text));
        MyTableDomainsNS3.Value := AnsiString (Trim (EditNS3.Text));
        MyTableDomainsNS4.Value := AnsiString (Trim (EditNS4.Text));

        MyTableDomainsMX1.Value := AnsiString (Trim (EditMailServer1.Text));
        MyTableDomainsMX2.Value := AnsiString (Trim (EditMailServer2.Text));

        MyTableDomainsWWW.Value := AnsiString (Trim (EditWebHost.Text));

        MyTableDomainsOwner.Value  := AnsiString (Trim (EditOwner.Text));
        MyTableDomainsAdminp.Value := AnsiString (Trim (EditAdmin.Text));
        MyTableDomainsTechp.Value  := AnsiString (Trim (EditTecnico.Text));
        MyTableDomainsBillp.Value  := AnsiString (Trim (EditBill.Text));

        MyTableDomainsRegistrar.Value := AnsiString (Trim (EditRegistrador.Text));

        MyTableDomainsVpwd.Value := AnsiString (Trim (EditVendorPassword.Text));

        MyTableDomainsExpire.Value := Trunc (DateTimePickerExpira.Date);

        MyTableDomains.Post;

        Cambiar_Estado_Nuevo ();

        frmMain.MessageBoxBeep (Self.Handle, 'The register was appended successfully', 'Información', MB_OK);
      except
        on E: Exception do begin
          frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        end;
      end;
    end;
  end;
end;

procedure TfrmDominios.BitBtnBorrarClick(Sender: TObject);
begin
  if (pbNuevo = True) then begin
    // Se hizo un 'Append' (Opcion Cancel)
    try
      MyTableDomains.Cancel;
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
        MyTableDomains.Delete;
        //frmMain.MessageBoxBeep (Self.Handle, 'The register was deleted', 'Información', MB_OK);
      except
        on E: Exception do begin
          frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        end;
      end;
    end;
  end;
end;

procedure TfrmDominios.BitBtnRegistradorClick(Sender: TObject);
begin
  try
    frmRegistrador := TfrmRegistrador.Create (nil);

    if (frmRegistrador.Inicializar (EditRegistrador.Text) = True) then begin
      if (frmRegistrador.ShowModal = mrOk) then
        EditRegistrador.Text := frmRegistrador.psSalida;
    end;
  finally
    frmRegistrador.Release;
  end;
end;

procedure TfrmDominios.BitBtnWebHostClick(Sender: TObject);
begin
  try
    frmWebHost := TfrmWebHost.Create (nil);

    if (frmWebHost.Inicializar (EditWebHost.Text, 'Web Host') = True) then begin
      if (frmWebHost.ShowModal = mrOk) then
        EditWebHost.Text := frmWebHost.psSalida;
    end;
  finally
    frmWebHost.Release;
  end;
end;

procedure TfrmDominios.BitBtnMailServer1Click(Sender: TObject);
var
  lsCadena : string;
begin
  try
    frmWebHost := TfrmWebHost.Create (nil);

    if (Sender = BitBtnMailServer1) then
      lsCadena := EditMailServer1.Text
    else
      lsCadena := EditMailServer2.Text;

    if (frmWebHost.Inicializar (lsCadena, 'Mail Server') = True) then begin
      if (frmWebHost.ShowModal = mrOk) then begin
        if (Sender = BitBtnMailServer1) then
          EditMailServer1.Text := frmWebHost.psSalida
        else
          EditMailServer2.Text := frmWebHost.psSalida;
      end;
    end;
  finally
    frmWebHost.Release;
  end;
end;

procedure TfrmDominios.BitBtnOwnerClick(Sender: TObject);
var
  lsCadena : string;
begin
  try
    frmPersonas := TfrmPersonas.Create (nil);

    if (Sender = BitBtnOwner) then
      lsCadena := EditOwner.Text
    else if (Sender = BitBtnAdmin) then
      lsCadena := EditAdmin.Text
    else if (Sender = BitBtnTecnico) then
      lsCadena := EditTecnico.Text
    else  // Bill
      lsCadena := EditBill.Text;

    if (frmPersonas.Inicializar (lsCadena) = True) then begin
      if (frmPersonas.ShowModal = mrOk) then begin
        if (Sender = BitBtnOwner) then
          EditOwner.Text := frmPersonas.psSalida
        else if (Sender = BitBtnAdmin) then
          EditAdmin.Text := frmPersonas.psSalida
        else if (Sender = BitBtnTecnico) then
          EditTecnico.Text := frmPersonas.psSalida
        else  // Bill
          EditBill.Text := frmPersonas.psSalida;
      end;
    end;
  finally
    frmPersonas.Release;
  end;
end;

procedure TfrmDominios.Cargar_Resultados (rbVerificarInfo : Boolean);
var
  lbEntrar : Boolean;
begin
  // Cargar la forma de resultados
  if (pbAuto = True) then begin
    DateTimePickerExpira.Date := pdExpire;
  end
  else begin
    try
      frmResultWhoIs := TfrmResultWhoIs.Create (nil);
      frmResultWhoIs.Caption := 'Results - WhoIs - ' + Trim (EditName.Text);

      lbEntrar := True;

      if (frmResultWhoIs.Inicializar () = True) then begin
        if (rbVerificarInfo = True) then begin
          lbEntrar := False;

          if (frmResultWhoIs.BitBtnAdminCreateUpdate.Visible = True) or
             (frmResultWhoIs.BitBtnTecnicoCreateUpdate.Visible = True) or
             (frmResultWhoIs.BitBtnNS1Create.Enabled = True) or
             (frmResultWhoIs.BitBtnNS2Create.Enabled = True) or
             (frmResultWhoIs.BitBtnNS3Create.Enabled = True) or
             (frmResultWhoIs.BitBtnNS4Create.Enabled = True) or
             (frmResultWhoIs.BitBtnRegistradorCreate.Visible = True) or
             (pdExpire <> Trunc (DateTimePickerExpira.Date)) then
          begin
            if (MessageDlg ('The info doesn''t match' + #13 + #10 +
                            'Do you want to open a window with the differences?', mtConfirmation, mbOKCancel, 0) = mrOK)
            then
              lbEntrar := True;
          end
          else
            frmMain.MessageBoxBeep (Self.Handle, 'The info is correct', 'Información', MB_OK);
        end;


        if (lbEntrar = True) then begin
          if (frmResultWhoIs.ShowModal = mrOk) then begin
            EditNS1.Text := frmResultWhoIs.paIDNS [0];
            EditNS2.Text := frmResultWhoIs.paIDNS [1];
            EditNS3.Text := frmResultWhoIs.paIDNS [2];
            EditNS4.Text := frmResultWhoIs.paIDNS [3];

            EditAdmin.Text := frmResultWhoIs.EditAdminID.Text;
            EditTecnico.Text := frmResultWhoIs.EditTecnicoID.Text;

            EditRegistrador.Text := frmResultWhoIs.psIDRegistrar;

            DateTimePickerExpira.Date := pdExpire;
            {if (pdExpire = 0) then
              DateTimePickerExpira.Date := k01_01_1990; }
          end;
        end;
      end;
    finally
      frmResultWhoIs.Release;
    end;
  end;
end;

procedure TfrmDominios.BitBtnAutoClick(Sender: TObject);
var
  lnI, liTotalORG : Integer;
  lsDomainName : string;
begin
  pbAuto := True;
  liTotalORG := 0;

  BitBtnAuto.Enabled := False;

  MyTableDomains.First;

  while (MyTableDomains.Eof = False) do begin
    pbErrorNoMatch := False;

    // WHOIS LIMIT EXCEEDED - SEE WWW.PIR.ORG/WHOIS FOR DETAILS
    // All traffic will be logged, and rate-limit validation logic will be
    // applied to limit access by any given IP address to a maximum of four queries per minute
    lsDomainName := Trim (EditName.Text);
    if (Pos ('.ORG', UpperCase (lsDomainName)) > 0) then begin
      Inc (liTotalORG);
      if (liTotalORG = 4-2) then begin
        for lnI := 1 to 60 do begin
          Sleep (1000);
          Application.ProcessMessages;
        end;
        liTotalORG := 0;
      end;
    end;

    BitBtnWhoIsClick (nil);
    Application.ProcessMessages;

    if (pdExpire > 0) and (pbErrorNoMatch = False) then begin
      BitBtnModificarClick (nil);
      Application.ProcessMessages;
    end;

    MyTableDomains.Next;
  end;

  Self.Close;

  pbAuto := False;
end;

procedure TfrmDominios.BitBtnWhoIsClick(Sender: TObject);
var
  lnI, lnJ, liPos, liPos2, liPosLineaActual, liWhoIs, liIndice : Integer;
  lbVerificarInfo, lbEntrar : Boolean;
  lsTemp, lsLinea, lsDomainName, lsResultado1, lsResultado2, lsWhoisServer : string;
begin
  if (Sender = BitBtnVerificarInfo) then
    lbVerificarInfo := True
  else
    lbVerificarInfo := False;

  lsDomainName := Trim (EditName.Text);

  if (lsDomainName = '') then
    frmMain.MessageBoxBeep (Self.Handle, 'Error, the domain name is empty', 'Error', MB_OK)
  else begin
    // Hacer el WhoIs
    Screen.Cursor := crHourGlass;

    psLast  := '';
    psFirst := '';
    psID    := '';
    psEMail := '';
    psName  := '';
    psPhone := '';

    psAdminLast  := '';
    psAdminFirst := '';
    psAdminID    := '';
    psAdminEMail := '';
    psAdminName  := '';
    psAdminPhone := '';

    psTecnicoLast  := '';
    psTecnicoFirst := '';
    psTecnicoID    := '';
    psTecnicoEMail := '';
    psTecnicoName  := '';
    psTecnicoPhone := '';

    psRegistrar := '';
    pdExpire := 0;

    for lnJ := 0 to 3 do begin
      paNS [lnJ] := '';
      paNSIP [lnJ] := '';
    end;


    try
      if (Pos ('COM.MX', UpperCase (lsDomainName)) > 0) then
        liWhoIs := 4
      else if (Pos ('.COM', UpperCase (lsDomainName)) > 0) or
              (Pos ('.NET', UpperCase (lsDomainName)) > 0) or
              (Pos ('.EDU', UpperCase (lsDomainName)) > 0) then
      begin
        liWhoIs := 1;
      end
      else if (Pos ('.ORG', UpperCase (lsDomainName)) > 0) then
        liWhoIs := 2
      else if (Pos ('.PRO', UpperCase (lsDomainName)) > 0) then
        liWhoIs := 3
      else if (Pos ('.MX', UpperCase (lsDomainName)) > 0) then
        liWhoIs := 4
      else if (Pos ('.INFO', UpperCase (lsDomainName)) > 0) then
        liWhoIs := 5
      else if (Pos ('.US', UpperCase (lsDomainName)) > 0) then
        liWhoIs := 6
      else if (Pos ('.BIZ', UpperCase (lsDomainName)) > 0) then
        liWhoIs := 7
      else if (Pos ('.CO', UpperCase (lsDomainName)) > 0) then
        liWhoIs := 8
      else
        liWhoIs := 1;  // Default


      if (liWhoIs = 1) then begin
        // COM, NET, EDU
        // Whois Server Version 2.0
        //  Domain Name: CALIFORMULA.COM
        //  Registrar: NETWORK SOLUTIONS, LLC.
        //  Whois Server: whois.networksolutions.com
        //  Referral URL: http://www.networksolutions.com/en_US/
        //  Name Server: NS1.INTERNAM.COM
        //  Name Server: RELL.MUBOT.COM
        //  Status: clientTransferProhibited
        //  Updated Date: 30-apr-2012
        //  Creation Date: 26-may-1995
        //  Expiration Date: 25-may-2013
        try
          IdWhois.Host := kWhoIsServer_1;
          lsResultado1 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado1);
        except
          on E: Exception do begin
            lsResultado1 := 'No match for';
            Screen.Cursor := crDefault;
            frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_1 + #13 + #10 + E.Message, 'Error', MB_OK);
          end;
        end;

        // Un 'Enter' (cambio de linea) es un '0Ah'
        liPos := Pos ('No match for', lsResultado1);

        if (liPos > 0) then begin
          // No match for "KGKHJGKJ.com".
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos, lsResultado1, $0A);

          pbErrorNoMatch := True;
          if (pbAuto = False) then
            frmMain.MessageBoxBeep (Self.Handle, lsTemp, 'Error', MB_OK);
        end
        else begin
          // Se hizo exitosamente el WhoIs

          // Registrar: NETWORK SOLUTIONS, LLC.
          psRegistrar := '';
          liPos := Pos ('Registrar: ', lsResultado1);
          if (liPos > 0) then begin
            psRegistrar := Obtener_Cadena_hasta_Caracter (liPos+11, lsResultado1, $0A);
            psRegistrar := Trim (psRegistrar);
          end;

          // Whois Server: whois.networksolutions.com
          lsWhoisServer := '';
          liPos := Pos ('Whois Server: ', lsResultado1);
          if (liPos > 0) then begin
            lsWhoisServer := Obtener_Cadena_hasta_Caracter (liPos+14, lsResultado1, $0A);
            lsWhoisServer := Trim (lsWhoisServer);
          end;

          // Expiration Date: 25-may-2013
          pdExpire := 0;
          liPos := Pos ('Expiration Date: ', lsResultado1);
          if (liPos > 0) then begin
            lsTemp := Obtener_Cadena_hasta_Caracter (liPos+17, lsResultado1, $0A);
            pdExpire := Convertir_a_Fecha_Double (lsTemp);
          end;

          if (lsWhoisServer = kWhoIsServer_101) then begin
            // whois.domainpeople.com

            // =-=-=-=
            //
            //
            // Domain name: aerbot.com
            //
            // Registrant Contact:
            //    Alejandro Diaz
            //    Alejandro Diaz ()
            //
            //    Fax:
            //    1690 Frontage Road
            //    Chula Vista, CA 91910
            //    US
            //
            // Administrative Contact:
            //    -
            //    Alejandro Diaz (info@exporadio.com)
            //    +1.6195759090
            //    Fax:
            //    1690 Frontage Road
            //    Chula Vista, CA 91910
            //    US
            //
            // Technical Contact:
            //    Alejandro Diaz
            //    Alejandro Diaz (adiaz@aviasoft.com)
            //    +1.6195759090
            //    Fax:
            //    1690 Frontage Road
            //    Chula Vista, CA 91910
            //    US
            //
            // Status: Locked
            //
            // Name Servers:
            //    ns1.internam.com
            //    rell.mubot.com
            //
            // Creation date: 19 Feb 2012 02:28:00
            // Expiration date: 18 Feb 2013 18:28:00

            try
              IdWhois.Host := kWhoIsServer_101;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
          except
            on E: Exception do begin
              lsResultado1 := 'No match for';
              Screen.Cursor := crDefault;
              frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_101 + #13 + #10 + E.Message, 'Error', MB_OK);
            end;
          end;


            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                  Inc (liPos);
                Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                  Inc (liPos);
                Inc (liPos);
                Inc (liPos);

                liPosLineaActual := liPos;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                // Posibles valores:
                //    Alejandro Diaz (info@exporadio.com)
                //    Alejandro Diaz (adiaz@aviasoft.com)

                if (Pos ('(', lslinea) > 0) then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord ('('));

                  // Name, Last
                  lsTemp := Trim (lsTemp);
                  if (lsTemp = 'CALIFORMULA RADIO GROUP') then begin
                    psName := lsTemp;
                    psLast := '';
                    psFirst := '';
                  end
                  else if (lsTemp = 'WhoisProtector bitkap.com') or
                     (lsTemp = 'WhoisProtector bitvek.com') then
                  begin
                    psLast := '';
                    psFirst := lsTemp;
                  end
                  else begin
                    psFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
                    psLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
                  end;

                  // Email
                  liPos2 := Pos ('(', lslinea);
                  Delete (lsLinea, 1, liPos2);
                  lsLinea := Trim (lsLinea);
                  Delete (lsLinea, Length (lsLinea), 1);
                  psEMail := Trim (lsLinea);


                  // Email
                  //    Alejandro Diaz (info@exporadio.com)

                  // Brincar hasta el final de la linea
                  liPos := liPosLineaActual;
                  while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                    Inc (liPos);
                  Inc (liPos);


                  // Phone
                  //    +1.6195759090

                  //lnJ := 0;
                  while (True) do begin
                    psPhone := Obtener_Cadena_hasta_Caracter (liPos, lsResultado2, $0D);
                    psPhone := Trim (psPhone);

                    {if (psPhone <> '') then begin
                      if not ((psPhone [1] >= '0') and (psPhone [1] <= '9') or (psPhone [1] = '(') or (psPhone [1] = '+')) then begin
                        // Brincar otra linea
                        while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                          Inc (liPosLineaActual);
                        Inc (liPosLineaActual);
                      end;
                    end;

                    Inc (lnJ);
                    if (lnJ = 8) then}
                      Break;
                  end;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            // NSx
            // Domain servers in listed order:
            // DNS1.CALIFORMULA.COM         207.67.132.3
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Name Servers:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 13;

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end
          else if (lsWhoisServer = kWhoIsServer_102) then begin
            // whois.tucows.com

            // Registrant:
            //  Califormula Media Group, LLC
            //  1690 Frontage Road
            //  Chula Vista, CA 91911
            //  US
            //
            //  Domain name: ALEJANDRO-DIAZ.COM
            //
            //
            //  Administrative Contact:
            //     Diaz, Alejandro  adiaz@exporadio.com
            //     1690 Frontage Road
            //     Chula Vista, CA 91911
            //     US
            //     +1.6196283436
            //  Technical Contact:
            //     Diaz, Alejandro  adiaz@exporadio.com
            //     1690 Frontage Road
            //     Chula Vista, CA 91911
            //     US
            //     +1.6196283436
            //
            //
            //  Registration Service Provider:
            //     myDiscountDomains.com, support@myDiscountDomains.com
            //     http://www.mydiscountdomains.com
            //     support@myDiscountDomains.com may be contacted for Discount name
            //     registration and technical domain name support. Lowest pricing for
            //     domain names for Tucows OpenSRS.
            //
            //
            //  Registrar of Record: TUCOWS, INC.
            //  Record last updated on 05-May-2012.
            //  Record expires on 05-Jun-2013.
            //  Record created on 05-Jun-2007.
            //
            //  Registrar Domain Name Help Center:
            //     http://tucowsdomains.com
            //
            //  Domain servers in listed order:
            //     RELL.MUBOT.COM
            //     RG.INTERSIM.ORG
            //
            //
            //  Domain status: clientTransferProhibited
            //                 clientUpdateProhibited

            try
              IdWhois.Host := kWhoIsServer_102;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
            except
              on E: Exception do begin
                lsResultado1 := 'No match for';
                Screen.Cursor := crDefault;
                frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_102 + #13 + #10 + E.Message, 'Error', MB_OK);
              end;
            end;


            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar hasta el final de la linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);

                liPosLineaActual := liPos + 1;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                // Posibles valores:
                // Contact Privacy Inc. Customer 0118753510,   internam.com@contactprivacy.com
                // Diaz, Alejandro  adiaz@exporadio.com

                if (Pos ('@', lslinea) > 0) then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord ('@'));

                  liIndice := -1;
                  for lnJ := Length (lsTemp)-1 downto 1 do begin
                    if (lsTemp [lnJ] = ' ') then begin
                      liIndice := lnJ;
                      Break;
                    end;
                  end;

                  if (liIndice <> -1) then begin
                    lsTemp := Trim (Copy (lsTemp, 1, liIndice));
                    Delete (lsLinea, 1, Length (lsTemp));
                  end;

                  // Name, Last
                  lsTemp := Trim (lsTemp);
                  if (lsTemp = 'Network Solutions, LLC.') then begin
                    psLast := '';
                    psFirst := lsTemp;
                  end
                  else begin
                    liPos := Pos (',', lsTemp);
                    if (liPos > 0) and (liPos <> Length (lsTemp)) then begin
                      psLast := Trim (Copy (lsTemp, 1, liPos-1));
                      psFirst := Trim (Copy (lsTemp, liPos+1, 99));
                    end
                    else begin
                      psLast := '';
                      psFirst := lsTemp;
                    end;
                  end;

                  // Email
                  //Delete (lsLinea, 1, Length (lsTemp)+1);
                  psEMail := Trim (lsLinea);


                  // Name
                  // Califormula Radio Group
                  // 1690 FRONTAGE RD
                  // P.O. Box 430

                  // Brincar hasta el final de la linea
                  liPos := liPosLineaActual;
                  while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                    Inc (liPos);

                  liPosLineaActual := liPos + 1;
                  psName := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                  psName := Trim (psName);
                  // Si empieza con un numero, se asume que es una direccion
                  // Si empieza con P.O, se asume que es una direccion
                  if (Length (psName) >= 1) and (psName [1] >= '0') and (psName [1] <= '9') then
                    psName := ''
                  else if (Length (psName) >= 3) and (psName [1] = 'P') and (psName [2] = '.') and (psName [3] = 'O') then
                    psName := '';

                  // Brincar 2 lineas
                  for lnJ := 1 to 2 do begin
                    while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                      Inc (liPosLineaActual);
                    Inc (liPosLineaActual);
                  end;


                  // Phone
                  // 619.575-9090 (FAX) 619 427 2999

                  lnJ := 0;
                  while (True) do begin
                    psPhone := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                    psPhone := Trim (psPhone);

                    if (psPhone <> '') then begin
                      if not ((psPhone [1] >= '0') and (psPhone [1] <= '9') or (psPhone [1] = '(') or (psPhone [1] = '+')) then begin
                        // Brincar otra linea
                        while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                          Inc (liPosLineaActual);
                        Inc (liPosLineaActual);
                      end;
                    end;

                    Inc (lnJ);
                    if (lnJ = 8) then
                      Break;
                  end;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            // NSx
            // Domain servers in listed order:
            // DNS1.CALIFORMULA.COM         207.67.132.3
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Domain servers in listed order:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 31;

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end
          else if (lsWhoisServer = kWhoIsServer_103) then begin
            // whois.domaindiscover.com

            // This WHOIS database is provided for information purposes only. We do
            // not guarantee the accuracy of this data. The following uses of this
            // system are expressly prohibited: (1) use of this system for unlawful
            // purposes; (2) use of this system to collect information used in the
            // mass transmission of unsolicited commercial messages in any medium;
            // (3) use of high volume, automated, electronic processes against this
            // database. By submitting this query, you agree to abide by this
            // policy.
            //
            // Registrant:
            //    Vladimir Vukicevic
            //    108 Bryant St. #8
            //    Mountain View, CA 94041
            //    US
            //
            //    Domain Name: BITOPS.COM
            //
            //    Administrative Contact, Technical Contact, Zone Contact:
            //       Vladimir Vukicevic
            //       108 Bryant St. #8
            //       Mountain View, CA 94041
            //       US
            //       650-965-1519
            //       vladimir@pobox.com
            //
            //    Domain created on 17-Nov-2008
            //    Domain expires on 17-Nov-2013
            //    Last updated on 02-Nov-2011
            //
            //    Domain servers in listed order:
            //
            //       NS1.OFF.NET
            //       NS2.OFF.NET

            try
              IdWhois.Host := kWhoIsServer_103;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
            except
              on E: Exception do begin
                lsResultado1 := 'No match for';
                Screen.Cursor := crDefault;
                frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_103 + #13 + #10 + E.Message, 'Error', MB_OK);
              end;
            end;


            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                liPosLineaActual := liPos;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                // Posibles valores:
                //       Vladimir Vukicevic
                psFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsLinea, ' ');
                psLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsLinea, ' ');

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                // Phone
                //       650-965-1519
                liPosLineaActual := liPos;

                lnJ := 0;
                while (True) do begin
                  psPhone := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                  psPhone := Trim (psPhone);

                  if (psPhone <> '') then begin
                    if not ((psPhone [1] >= '0') and (psPhone [1] <= '9') or (psPhone [1] = '(') or (psPhone [1] = '+')) then begin
                      // Brincar otra linea
                      while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                        Inc (liPosLineaActual);
                      Inc (liPosLineaActual);
                    end;
                  end;

                  Inc (lnJ);
                  if (lnJ = 8) then
                    Break;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            // NSx
            // Domain servers in listed order:
            // DNS1.CALIFORMULA.COM         207.67.132.3
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Domain servers in listed order:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 31;

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end
          else if (lsWhoisServer = kWhoIsServer_104) then begin
            // Whois.bigrock.com

            // Domain Name: JUNUX.COM
            //
            //  Registrant:
            //      None
            //     Alejandro Diaz        (adiaz@aviasoft.com)
            //     1690 Frontage Road
            //     Chula Vista
            //     null,91911
            //     US
            //     Tel. +1.6195759090
            //     Fax. +00.0000000
            //
            //  Creation Date: 18-Jun-2005
            //  Expiration Date: 18-Jun-2013
            //
            //  Domain servers in listed order:
            //      rell.mubot.com
            //     rg.intersim.org
            //
            //
            //  Administrative Contact:
            //      None
            //     Alejandro Diaz        (adiaz@aviasoft.com)
            //     1690 Frontage Road
            //     Chula Vista
            //     null,91911
            //     US
            //     Tel. +1.6195759090
            //     Fax. +00.0000000
            //
            //  Technical Contact:
            //      None
            //     Alejandro Diaz        (adiaz@aviasoft.com)
            //     1690 Frontage Road
            //     Chula Vista
            //     null,91911
            //     US
            //     Tel. +1.6195759090
            //     Fax. +00.0000000
            //
            //  Billing Contact:
            //      None
            //     Alejandro Diaz        (adiaz@aviasoft.com)
            //     1690 Frontage Road
            //     Chula Vista
            //     null,91911
            //     US
            //     Tel. +1.6195759090
            //     Fax. +00.0000000
            //
            //  Status:ACTIVE

            try
              IdWhois.Host := kWhoIsServer_104;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
            except
              on E: Exception do begin
                lsResultado1 := 'No match for';
                Screen.Cursor := crDefault;
                frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_104 + #13 + #10 + E.Message, 'Error', MB_OK);
              end;
            end;


            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                liPosLineaActual := liPos;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                // Posibles valores:
                //     Alejandro Diaz        (adiaz@aviasoft.com)

                if (Pos ('(', lslinea) > 0) then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord ('('));

                  // Name, Last
                  lsTemp := Trim (lsTemp);
                  if (lsTemp = 'CALIFORMULA RADIO GROUP') then begin
                    psName := lsTemp;
                    psLast := '';
                    psFirst := '';
                  end
                  else if (lsTemp = 'WhoisProtector bitkap.com') or
                     (lsTemp = 'WhoisProtector bitvek.com') then
                  begin
                    psLast := '';
                    psFirst := lsTemp;
                  end
                  else begin
                    psFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
                    psLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
                  end;

                  // Email
                  //     Alejandro Diaz        (adiaz@aviasoft.com)
                  liPos2 := Pos ('(', lslinea);
                  Delete (lsLinea, 1, liPos2);
                  lsLinea := Trim (lsLinea);
                  Delete (lsLinea, Length (lsLinea), 1);
                  psEMail := Trim (lsLinea);

                  // Brincar hasta el final de la linea
                  liPos := liPosLineaActual;
                  while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                    Inc (liPos);
                  Inc (liPos);

                  // Brincar hasta el final de la linea
                  while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                    Inc (liPos);
                  Inc (liPos);

                  // Phone
                  //     Tel. +1.6195759090

                  lnJ := 0;
                  liPosLineaActual := liPos;
                  while (True) do begin
                    psPhone := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                    psPhone := Trim (psPhone);

                    if (psPhone <> '') then begin
                      if not ((psPhone [1] >= '0') and (psPhone [1] <= '9') or (psPhone [1] = '(') or (psPhone [1] = 'T')) then begin
                        // Brincar otra linea
                        while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                          Inc (liPosLineaActual);
                        Inc (liPosLineaActual);
                      end;
                    end;

                    Inc (lnJ);
                    if (lnJ = 8) then
                      Break;
                  end;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            //  Domain servers in listed order:
            //      rell.mubot.com
            //     rg.intersim.org
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Domain servers in listed order:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 31;

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end
          else if (lsWhoisServer = kWhoIsServer_105) then begin
            // whois.names4ever.com

            //    Registration Service Provider:
            //       Hostopia.com Inc, d/b/a Aplus.net
            //       +1.8772758763
            //       dns@cs.aplus.net
            //
            //
            //    Registrant:
            //       Califormula Inc.
            //       Marta Diaz
            //       1690 Frontage Road
            //       Chula Vista, CA 91911
            //       US
            //       Phone: +1.61957590904
            //       Email: marba@califormula.com
            //
            //
            //    Domain Name: marbatita.com
            //
            //    Administrative Contact:
            //       Califormula Inc.
            //       Marta Diaz
            //       1690 Frontage Road
            //       Chula Vista, CA 91911
            //       US
            //       Phone: +1.61957590904
            //       Email: marba@califormula.com
            //
            //
            //    Technical  Contact:
            //       Califormula Inc.
            //       Marta Diaz
            //       1690 Frontage Road
            //       Chula Vista, CA 91911
            //       US
            //       Phone: +1.61957590904
            //       Email: marba@califormula.com
            //
            //
            //    Registrar of Record:
            //       Hostopia.com Inc. d/b/a Aplus.net, www.aplus.net
            //       Record last updated on 2011-10-09
            //       Record expires on 2013-06-18
            //       Record created on 2003-06-18
            //
            //    Domain servers in listed order:
            //       rg.intersim.org
            //       rell.mubot.com

            try
              IdWhois.Host := kWhoIsServer_105;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
            except
              on E: Exception do begin
                lsResultado1 := 'No match for';
                Screen.Cursor := crDefault;
                frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_105 + #13 + #10 + E.Message, 'Error', MB_OK);
              end;
            end;


            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical  Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                //    Administrative Contact:
                //       Califormula Inc.
                //       Marta Diaz
                //       1690 Frontage Road
                //       Chula Vista, CA 91911
                //       US
                //       Phone: +1.61957590904
                //       Email: marba@califormula.com
                liPosLineaActual := liPos;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);
                psName := lsLinea;

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                liPosLineaActual := liPos;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                psFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsLinea, ' ');
                psLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsLinea, ' ');

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                //       Phone: +1.61957590904
                //       Email: marba@califormula.com
                liPosLineaActual := liPos;

                lnJ := 0;
                while (True) do begin
                  psPhone := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                  psPhone := Trim (psPhone);

                  if (psPhone <> '') then begin
                    if (Pos ('Phone: ', psPhone) > 0) then begin
                      psPhone := StringReplace (psPhone, 'Phone: ', '', [rfReplaceAll, rfIgnoreCase]);
                      Break;
                    end
                    else begin
                      // Brincar otra linea
                      while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                        Inc (liPosLineaActual);
                      Inc (liPosLineaActual);
                    end;
                  end;

                  Inc (lnJ);
                  if (lnJ = 8) then
                    Break;
                end;

                //       Phone: +1.61957590904
                //       Email: marba@califormula.com
                liPosLineaActual := liPos;

                lnJ := 0;
                while (True) do begin
                  psEMail := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                  psEMail := Trim (psEMail);

                  if (psEMail <> '') then begin
                    if (Pos ('Email: ', psEMail) > 0) then begin
                      psEMail := StringReplace (psEMail, 'Email: ', '', [rfReplaceAll, rfIgnoreCase]);
                      Break;
                    end
                    else begin
                      // Brincar otra linea
                      while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                        Inc (liPosLineaActual);
                      Inc (liPosLineaActual);
                    end;
                  end;

                  Inc (lnJ);
                  if (lnJ = 8) then
                    Break;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            //  Domain servers in listed order:
            //      rell.mubot.com
            //     rg.intersim.org
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Domain servers in listed order:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 31;

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end
          else if (lsWhoisServer = kWhoIsServer_106) then begin
            // whois.godaddy.com

            // Registrant:
            //    Domains By Proxy, LLC
            //    DomainsByProxy.com
            //    14747 N Northsight Blvd Suite 111, PMB 309
            //    Scottsdale, Arizona 85260
            //    United States
            //
            //    Registered through: GoDaddy.com, LLC (http://www.godaddy.com)
            //    Domain Name: MICNOW.COM
            //       Created on: 03-May-10
            //       Expires on: 03-May-13
            //       Last Updated on: 14-Mar-12
            //
            //    Administrative Contact:
            //       Private, Registration  MICNOW.COM@domainsbyproxy.com
            //       Domains By Proxy, LLC
            //       DomainsByProxy.com
            //       14747 N Northsight Blvd Suite 111, PMB 309
            //       Scottsdale, Arizona 85260
            //       United States
            //       (480) 624-2599      Fax -- (480) 624-2598
            //
            //    Technical Contact:
            //       Private, Registration  MICNOW.COM@domainsbyproxy.com
            //       Domains By Proxy, LLC
            //       DomainsByProxy.com
            //       14747 N Northsight Blvd Suite 111, PMB 309
            //       Scottsdale, Arizona 85260
            //       United States
            //       (480) 624-2599      Fax -- (480) 624-2598
            //
            //    Domain servers in listed order:
            //       NS1.INTERNAM.COM
            //       RELL.MUBOT.COM

            try
              IdWhois.Host := kWhoIsServer_106;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
            except
              on E: Exception do begin
                lsResultado1 := 'No match for';
                Screen.Cursor := crDefault;
                frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_106 + #13 + #10 + E.Message, 'Error', MB_OK);
              end;
            end;


            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                //    Administrative Contact:
                //       Private, Registration  MICNOW.COM@domainsbyproxy.com
                //       Domains By Proxy, LLC
                //       DomainsByProxy.com
                //       14747 N Northsight Blvd Suite 111, PMB 309
                //       Scottsdale, Arizona 85260
                //       United States
                //       (480) 624-2599      Fax -- (480) 624-2598
                lsLinea := Obtener_Cadena_hasta_Caracter (liPos, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Pos ('@', lslinea) > 0) then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord ('@'));

                  liIndice := -1;
                  for lnJ := Length (lsTemp)-1 downto 1 do begin
                    if (lsTemp [lnJ] = ' ') then begin
                      liIndice := lnJ;
                      Break;
                    end;
                  end;

                  if (liIndice <> -1) then begin
                    //lsTemp := Trim (Copy (lsTemp, 1, liIndice));
                    Delete (lsLinea, 1, liIndice);
                  end;

                  {// Name, Last
                  lsTemp := Trim (lsTemp);
                  if (lsTemp = 'Network Solutions, LLC.') then begin
                    psLast := '';
                    psFirst := lsTemp;
                  end
                  else begin
                    liPos := Pos (',', lsTemp);
                    if (liPos > 0) and (liPos <> Length (lsTemp)) then begin
                      psLast := Trim (Copy (lsTemp, 1, liPos-1));
                      psFirst := Trim (Copy (lsTemp, liPos+1, 99));
                    end
                    else begin
                      psLast := '';
                      psFirst := lsTemp;
                    end;
                  end;}

                  // Email
                  psEMail := Trim (lsLinea);
                end;

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                liPosLineaActual := liPos;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);
                psName := lsLinea;

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                //       (480) 624-2599      Fax -- (480) 624-2598
                lnJ := 0;
                liPosLineaActual := liPos;
                while (True) do begin
                  psPhone := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                  psPhone := Trim (psPhone);

                  if (psPhone <> '') then begin
                    if not ((psPhone [1] >= '0') and (psPhone [1] <= '9') or (psPhone [1] = '(')) then begin
                      // Brincar otra linea
                      while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                        Inc (liPosLineaActual);
                      Inc (liPosLineaActual);
                    end;
                  end;

                  Inc (lnJ);
                  if (lnJ = 8) then
                    Break;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            //  Domain servers in listed order:
            //      rell.mubot.com
            //     rg.intersim.org
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Domain servers in listed order:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 31;

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end
          else begin
            //whois.networksolutions.com

            // [WhoIs Server Host 2]
            // Registrant:
            // AviaSoft
            //    1690 Frontage Road
            //    Chula Vista, CA 91911
            //    US
            //
            //    Domain Name: AVIASOFT.COM
            //
            //    ------------------------------------------------------------------------
            //    Promote your business to millions of viewers for only $1 a month
            //    Learn how you can get an Enhanced Business Listing here for your domain name.
            //    Learn more at http://www.NetworkSolutions.com/
            //    ------------------------------------------------------------------------
            //
            //    Administrative Contact:
            //       Diaz, Alejandro   calradio@gmail.com
            //       1690 FRONTAGE RD
            //       CHULA VISTA, CA 91911-3936
            //       US
            //       619-575-9090
            //
            //    Technical Contact:
            //       AviaSoft    calradio@gmail.com
            //       1690 Frontage Road
            //       Chula Vista, CA 91911
            //       US
            //       999 999 9999 fax: 999 999 9999
            //
            //
            //    Record expires on 23-Mar-2016.
            //    Record created on 22-Mar-1996.
            //    Database last updated on 29-Jun-2012 11:21:00 EDT.
            //
            //    Domain servers in listed order:
            //
            //    NS1.INTERNAM.COM
            //    RELL.MUBOT.COM               207.67.140.19

            try
              IdWhois.Host := kWhoIsServer_100;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
            except
              on E: Exception do begin
                lsResultado1 := 'No match for';
                Screen.Cursor := crDefault;
                frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_100 + #13 + #10 + E.Message, 'Error', MB_OK);
              end;
            end;


            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar hasta el final de la linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);

                liPosLineaActual := liPos + 1;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                // Posibles valores:
                // Diaz, Alejandro             [#9#9] calradio@gmail.com
                // AviaSoft                    [#9#9] calradio@gmail.com
                // Barton, Roger Johnson       [#9#9] z903@HOTMAIL.COM
                // Network Solutions, LLC.     [#9#9] customerservice@networksolutions.com
                // Pending Renewal or Deletion [#9#9] pendingrenewalordeletion@networksolutions.com

                if (Pos (Chr ($09), lslinea) > 0) then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, $09);
                  Delete (lsLinea, 1, Length (lsTemp)+1);

                  // Name, Last
                  lsTemp := Trim (lsTemp);
                  if (lsTemp = 'Network Solutions, LLC.') then begin
                    psLast := '';
                    psFirst := lsTemp;
                  end
                  else begin
                    liPos := Pos (',', lsTemp);
                    if (liPos > 0) and (liPos <> Length (lsTemp)) then begin
                      psLast := Trim (Copy (lsTemp, 1, liPos-1));
                      psFirst := Trim (Copy (lsTemp, liPos+1, 99));
                    end
                    else begin
                      psLast := '';
                      psFirst := lsTemp;
                    end;
                  end;

                  // Email
                  //Delete (lsLinea, 1, Length (lsTemp)+1);
                  psEMail := Trim (lsLinea);


                  // Name
                  // Califormula Radio Group
                  // 1690 FRONTAGE RD
                  // P.O. Box 430

                  // Brincar hasta el final de la linea
                  liPos := liPosLineaActual;
                  while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                    Inc (liPos);

                  liPosLineaActual := liPos + 1;
                  psName := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                  psName := Trim (psName);
                  // Si empieza con un numero, se asume que es una direccion
                  // Si empieza con P.O, se asume que es una direccion
                  if (Length (psName) >= 1) and (psName [1] >= '0') and (psName [1] <= '9') then
                    psName := ''
                  else if (Length (psName) >= 3) and (psName [1] = 'P') and (psName [2] = '.') and (psName [3] = 'O') then
                    psName := '';

                  // Brincar 2 lineas
                  for lnJ := 1 to 2 do begin
                    while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                      Inc (liPosLineaActual);
                    Inc (liPosLineaActual);
                  end;


                  // Phone
                  // 619.575-9090 (FAX) 619 427 2999

                  lnJ := 0;
                  while (True) do begin
                    psPhone := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                    psPhone := Trim (psPhone);

                    if (psPhone <> '') then begin
                      if not ((psPhone [1] >= '0') and (psPhone [1] <= '9') or (psPhone [1] = '(') or (psPhone [1] = '+')) then begin
                        // Brincar otra linea
                        while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                          Inc (liPosLineaActual);
                        Inc (liPosLineaActual);
                      end;
                    end;

                    Inc (lnJ);
                    if (lnJ = 8) then
                      Break;
                  end;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            // NSx
            // Domain servers in listed order:
            // DNS1.CALIFORMULA.COM         207.67.132.3
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Domain servers in listed order:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 31 + 1;  // 1 = 0Ah

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end;



          // Cargar la forma de resultados
          Cargar_Resultados (lbVerificarInfo);


          {lsTemp := 'Registrar = ' + psRegistrar + #13 + #13 +
                    'Admin Last = ' + psAdminLast + #13 +
                    'Admin First = ' + psAdminFirst + #13 +
                    'Admin Handle = ' + psAdminHandle + #13 +
                    'Admin EMail = ' + psAdminEMail + #13 +
                    'Admin Name = ' + psAdminName + #13 +
                    'Admin Phone = ' + psAdminPhone + #13 + #13 +
                    'Tecnico Last = ' + psTecnicoLast + #13 +
                    'Tecnico First = ' + psTecnicoFirst + #13 +
                    'Tecnico Handle = ' + psTecnicoHandle + #13 +
                    'Tecnico EMail = ' + psTecnicoEMail + #13 +
                    'Tecnico Name = ' + psTecnicoName + #13 +
                    'Tecnico Phone = ' + psTecnicoPhone + #13 + #13 +
                    'Bill Last = ' + psLast + #13 +
                    'Bill First = ' + psFirst + #13 +
                    'Bill Handle = ' + psHandle + #13 +
                    'Bill EMail = ' + psEMail + #13 +
                    'Bill Name = ' + psName + #13 +
                    'Bill Phone = ' + psPhone + #13 + #13 +
                    'Expire = ' + DateToStr (pdExpire) + #13 + #13 +
                    'NS1 = ' + paNS [0] + #13 +
                    'NSIP1 = ' + paNSIP [0] + #13 +
                    'NS2 = ' + paNS [1] + #13 +
                    'NSIP2 = ' + paNSIP [1] + #13 +
                    'NS3 = ' + paNS [2] + #13 +
                    'NSIP3 = ' + paNSIP [2] + #13 +
                    'NS4 = ' + paNS [3] + #13 +
                    'NSIP4 = ' + paNSIP [3] + #13;
          MessageDlg (lsTemp, mtInformation, [mbOk], 0); }
        end;
      end
      else if (liWhoIs = 2) then begin
        // ORG

        // Domain ID:D165073831-LROR
        // Domain Name:ARTICULO27.ORG
        // Created On:22-Mar-2012 14:26:03 UTC
        // Last Updated On:22-May-2012 03:50:12 UTC
        // Expiration Date:22-Mar-2014 14:26:03 UTC
        // Sponsoring Registrar:DomainPeople, Inc. (R30-LROR)
        // Status:CLIENT TRANSFER PROHIBITED
        // Registrant ID:acf3abb9c4aeb81d
        // Registrant Name:Alejandro  Diaz
        // Registrant Organization:Alejandro Diaz
        // Registrant Street1:1690 Frontage Road
        // Registrant Street2:
        // Registrant Street3:
        // Registrant City:Chula Vista
        // Registrant State/Province:CA
        // Registrant Postal Code:91911
        // Registrant Country:US
        // Registrant Phone:+1.6195759090
        // Registrant Phone Ext.:
        // Registrant FAX:
        // Registrant FAX Ext.:
        // Registrant Email:admin@internam.com
        // Admin ID:acf3abb9c4aeb81d
        // Admin Name:Alejandro  Diaz
        // Admin Organization:Alejandro Diaz
        // Admin Street1:1690 Frontage Road
        // Admin Street2:
        // Admin Street3:
        // Admin City:Chula Vista
        // Admin State/Province:CA
        // Admin Postal Code:91911
        // Admin Country:US
        // Admin Phone:+1.6195759090
        // Admin Phone Ext.:
        // Admin FAX:
        // Admin FAX Ext.:
        // Admin Email:admin@internam.com
        // Tech ID:acf3abb9c4aeb81d
        // Tech Name:Alejandro  Diaz
        // Tech Organization:Alejandro Diaz
        // Tech Street1:1690 Frontage Road
        // Tech Street2:
        // Tech Street3:
        // Tech City:Chula Vista
        // Tech State/Province:CA
        // Tech Postal Code:91911
        // Tech Country:US
        // Tech Phone:+1.6195759090
        // Tech Phone Ext.:
        // Tech FAX:
        // Tech FAX Ext.:
        // Tech Email:admin@internam.com
        // Name Server:RELL.MUBOT.COM
        // Name Server:NS1.INTERNAM.COM
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // DNSSEC:Unsigned

        try
          IdWhois.Host := kWhoIsServer_10;
          lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
        except
          on E: Exception do begin
            lsResultado1 := 'No match for';
            Screen.Cursor := crDefault;
            frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_10 + #13 + #10 + E.Message, 'Error', MB_OK);
          end;
        end;


        // Admin Name:Alejandro  Diaz
        liPos := Pos ('Admin Name:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+11, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        psAdminFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
        //psAdminLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
        psAdminLast  := Trim (lsTemp);
        if (LowerCase (psAdminFirst) = 'contact') then begin
          psAdminFirst := '';
          psAdminLast  := '';
        end;

        // Admin Organization:-
        liPos := Pos ('Admin Organization:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+19, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        if (Length (lsTemp) > 3) then
          psAdminName := lsTemp;

        // Admin Phone:+1.6195759090
        liPos := Pos ('Admin Phone:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+12, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        psAdminPhone := lsTemp;

        // Admin Email:info@exporadio.com
        liPos := Pos ('Admin Email:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+12, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        psAdminEMail := lsTemp;


        // Tech Name:Alejandro  Diaz
        liPos := Pos ('Tech Name:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+10, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        psTecnicoFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
        //psTecnicoLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
        psTecnicoLast  := Trim (lsTemp);
        if (LowerCase (psTecnicoFirst) = 'contact') then begin
          psTecnicoFirst := '';
          psTecnicoLast  := '';
        end;

        // Tech Organization:Alejandro Diaz
        liPos := Pos ('Tech Organization:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        if (Length (lsTemp) > 3) then
          psTecnicoName := lsTemp;

        // Tech Phone:+1.6195759090
        liPos := Pos ('Tech Phone:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+11, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        psTecnicoPhone := lsTemp;

        // Tech Email:adiaz@aviasoft.com
        liPos := Pos ('Tech Email:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+11, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        psTecnicoEMail := lsTemp;


        // Expiration Date:18-Feb-2014 00:00:00 UTC
        pdExpire := 0;
        liPos := Pos ('Expiration Date:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+16, lsResultado2, $0A);
          pdExpire := Convertir_a_Fecha_Double (lsTemp);
        end;

        // Sponsoring Registrar:DomainPeople, Inc. (R2340-PRO)
        liPos := Pos ('Sponsoring Registrar:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+21, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
          lsTemp := Obtener_Cadena_hasta_Caracter (1, lsTemp, Ord ('('));
          psRegistrar := Trim (lsTemp);
        end;


        // Name Server:RELL.MUBOT.COM
        // Name Server:NS1.INTERNAM.COM
        // Name Server:
        // Name Server:
        for lnJ := 0 to 3 do begin
          paNS [lnJ] := '';
          paNSIP [lnJ] := '';
        end;

        for lnJ := 0 to 3 do begin
          liPos := Pos ('Name Server:', lsResultado2);
          if (liPos > 0) then begin
            lsTemp := Obtener_Cadena_hasta_Caracter (liPos+12, lsResultado2, $0A);
            lsTemp := Trim (lsTemp);
            if (lsTemp <> '') then begin
              paNS [lnJ] := lsTemp;
              paNSIP [lnJ] := '0.0.0.0';
            end;
            lsResultado2 := StringReplace (lsResultado2, 'Name Server', 'Name-Server', [rfIgnoreCase]);
          end
          else begin
            liPos := Pos ('Name Server:', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+12, lsResultado2, $0A);
              lsTemp := Trim (lsTemp);
              if (lsTemp <> '') then begin
                paNS [lnJ] := lsTemp;
                paNSIP [lnJ] := '0.0.0.0';
              end;
              lsResultado2 := StringReplace (lsResultado2, 'Name Server', 'Name-Server', [rfIgnoreCase]);
            end
            else begin
              Break;
            end;
          end;
        end;



        // Cargar la forma de resultados
        Cargar_Resultados (lbVerificarInfo);
      end
      else if (liWhoIs = 3) then begin
        // PRO

        // Domain ID:D135730-PRO
        // Domain Name:AIRBOT.PRO
        // Created On:18-Feb-2012 20:28:45 UTC
        // Expiration Date:18-Feb-2014 00:00:00 UTC
        // Sponsoring Registrar:DomainPeople, Inc. (R2340-PRO)
        // Status:CLIENT TRANSFER PROHIBITED
        // Registrant ID:35afbf53c6063d18
        // Registrant Name:Alejandro  Diaz
        // Registrant Organization:Alejandro Diaz
        // Registrant Street1:1690 Frontage Road
        // Registrant Street2:
        // Registrant Street3:
        // Registrant City:Chula Vista
        // Registrant State/Province:CA
        // Registrant Postal Code:91910
        // Registrant Country:US
        // Registrant Phone:+1.6195759090
        // Registrant Phone Ext.:
        // Registrant FAX:
        // Registrant FAX Ext.:
        // Registrant Email:adiaz@aviasoft.com
        // Admin ID:a88febeedab9e42e
        // Admin Name:Alejandro  Diaz
        // Admin Organization:-
        // Admin Street1:1690 Frontage Road
        // Admin Street2:
        // Admin Street3:
        // Admin City:Chula Vista
        // Admin State/Province:CA
        // Admin Postal Code:91910
        // Admin Country:US
        // Admin Phone:+1.6195759090
        // Admin Phone Ext.:
        // Admin FAX:
        // Admin FAX Ext.:
        // Admin Email:info@exporadio.com
        // Billing ID:35afbf53c6063d18
        // Billing Name:Alejandro  Diaz
        // Billing Organization:Alejandro Diaz
        // Billing Street1:1690 Frontage Road
        // Billing Street2:
        // Billing Street3:
        // Billing City:Chula Vista
        // Billing State/Province:CA
        // Billing Postal Code:91910
        // Billing Country:US
        // Billing Phone:+1.6195759090
        // Billing Phone Ext.:
        // Billing FAX:
        // Billing FAX Ext.:
        // Billing Email:adiaz@aviasoft.com
        // Tech ID:dbcca611a1af4b6a
        // Tech Name:Alejandro  Diaz
        // Tech Organization:Alejandro Diaz
        // Tech Street1:1690 Frontage Road
        // Tech Street2:
        // Tech Street3:
        // Tech City:Chula Vista
        // Tech State/Province:CA
        // Tech Postal Code:91910
        // Tech Country:US
        // Tech Phone:+1.6195759090
        // Tech Phone Ext.:
        // Tech FAX:
        // Tech FAX Ext.:
        // Tech Email:adiaz@aviasoft.com
        // Right to Use:
        // Name Server:RELL.MUBOT.COM
        // Name Server:NS1.INTERNAM.COM
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:

        try
          IdWhois.Host := kWhoIsServer_11;
          lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
        except
          on E: Exception do begin
            lsResultado1 := 'No match for';
            Screen.Cursor := crDefault;
            frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_11 + #13 + #10 + E.Message, 'Error', MB_OK);
          end;
        end;


        // Admin Name:Alejandro  Diaz
        liPos := Pos ('Admin Name:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+11, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        psAdminFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
        //psAdminLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
        psAdminLast  := Trim (lsTemp);

        // Admin Organization:-
        liPos := Pos ('Admin Organization:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+19, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        if (Length (lsTemp) > 3) then
          psAdminName := lsTemp;

        // Admin Phone:+1.6195759090
        liPos := Pos ('Admin Phone:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+12, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        psAdminPhone := lsTemp;

        // Admin Email:info@exporadio.com
        liPos := Pos ('Admin Email:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+12, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        psAdminEMail := lsTemp;


        // Tech Name:Alejandro  Diaz
        liPos := Pos ('Tech Name:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+10, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        psTecnicoFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
        //psTecnicoLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
        psTecnicoLast  := Trim (lsTemp);

        // Tech Organization:Alejandro Diaz
        liPos := Pos ('Tech Organization:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        if (Length (lsTemp) > 3) then
          psTecnicoName := lsTemp;

        // Tech Phone:+1.6195759090
        liPos := Pos ('Tech Phone:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+11, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        psTecnicoPhone := lsTemp;

        // Tech Email:adiaz@aviasoft.com
        liPos := Pos ('Tech Email:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+11, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
        end;
        psTecnicoEMail := lsTemp;


        // Expiration Date:18-Feb-2014 00:00:00 UTC
        pdExpire := 0;
        liPos := Pos ('Expiration Date:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+16, lsResultado2, $0A);
          pdExpire := Convertir_a_Fecha_Double (lsTemp);
        end;

        // Sponsoring Registrar:DomainPeople, Inc. (R2340-PRO)
        liPos := Pos ('Sponsoring Registrar:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+21, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
          lsTemp := Obtener_Cadena_hasta_Caracter (1, lsTemp, Ord ('('));
          psRegistrar := Trim (lsTemp);
        end;


        // Name Server:RELL.MUBOT.COM
        // Name Server:NS1.INTERNAM.COM
        // Name Server:
        // Name Server:
        for lnJ := 0 to 3 do begin
          paNS [lnJ] := '';
          paNSIP [lnJ] := '';
        end;

        for lnJ := 0 to 3 do begin
          liPos := Pos ('Name Server:', lsResultado2);
          if (liPos > 0) then begin
            lsTemp := Obtener_Cadena_hasta_Caracter (liPos+12, lsResultado2, $0A);
            lsTemp := Trim (lsTemp);
            if (lsTemp <> '') then begin
              paNS [lnJ] := lsTemp;
              paNSIP [lnJ] := '0.0.0.0';
            end;
            lsResultado2 := StringReplace (lsResultado2, 'Name Server', 'Name-Server', [rfIgnoreCase]);
          end
          else begin
            liPos := Pos ('Name Server:', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+12, lsResultado2, $0A);
              lsTemp := Trim (lsTemp);
              if (lsTemp <> '') then begin
                paNS [lnJ] := lsTemp;
                paNSIP [lnJ] := '0.0.0.0';
              end;
              lsResultado2 := StringReplace (lsResultado2, 'Name Server', 'Name-Server', [rfIgnoreCase]);
            end
            else begin
              Break;
            end;
          end;
        end;



        // Cargar la forma de resultados
        Cargar_Resultados (lbVerificarInfo);
      end
      else if (liWhoIs = 4) then begin
        // MX

        // Domain Name:       islandbay.mx
        //
        // Created On:        2012-03-22
        // Expiration Date:   2013-03-22
        // Last Updated On:   2012-05-15
        // Registrar:         Akky (Una division de NIC Mexico)
        // URL:               http://www.akky.mx
        // Whois TCP URI:     whois.akky.mx
        // Whois Web URL:     http://www.akky.mx/jsf/whois/whois.jsf
        //
        // Registrant:
        //    Name:           ExpoRadio, S.A. de C.V.
        //    City:           Tecate
        //    State:          Baja California
        //    Country:        Mexico
        //
        // Administrative Contact:
        //    Name:           Alejandro Diaz Barba
        //    City:           Chula Vista
        //    State:          California
        //    Country:        United States
        //
        // Technical Contact:
        //    Name:           Alejandro Diaz Barba
        //    City:           Chula Vista
        //    State:          California
        //    Country:        United States
        //
        // Billing Contact:
        //    Name:           Alejandro Diaz Barba
        //    City:           Chula Vista
        //    State:          California
        //    Country:        United States
        //
        // Name Servers:
        //

        try
          IdWhois.Host := kWhoIsServer_12;
          lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
        except
          on E: Exception do begin
            lsResultado1 := 'No match for';
            Screen.Cursor := crDefault;
            frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_12 + #13 + #10 + E.Message, 'Error', MB_OK);
          end;
        end;


        // Expiration Date:   2013-03-22
        pdExpire := 0;
        liPos := Pos ('Expiration Date:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+16, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
          pdExpire := Convertir_a_Fecha_Double_2 (lsTemp);
        end;

        // Registrar:         Akky (Una division de NIC Mexico)
        liPos := Pos ('Registrar:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+10, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
          lsTemp := Obtener_Cadena_hasta_Caracter (1, lsTemp, Ord ('('));
          psRegistrar := Trim (lsTemp);
        end;

        // Administrative Contact:
        lsResultado2 := StringReplace (lsResultado2, 'Name:', 'Na-me:', [rfIgnoreCase]);
        lsResultado2 := StringReplace (lsResultado2, 'Name:', 'Na-me:', [rfIgnoreCase]);

        liPos := Pos ('Name:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+5, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
          psAdminFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
          psAdminLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
          if (psAdminLast = '') then
            psAdminLast := Trim (lsTemp);
        end;

        // Technical Contact:
        lsResultado2 := StringReplace (lsResultado2, 'Name:', 'Na-me:', [rfIgnoreCase]);

        liPos := Pos ('Name:', lsResultado2);
        if (liPos > 0) then begin
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos+5, lsResultado2, $0A);
          lsTemp := Trim (lsTemp);
          psTecnicoFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
          psTecnicoLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
          if (psTecnicoLast = '') then
            psTecnicoLast := Trim (lsTemp);
        end;



        // Cargar la forma de resultados
        Cargar_Resultados (lbVerificarInfo);
      end
      else if (liWhoIs = 5) then begin
        // INFO
        // Domain ID:D49852832-LRMS
        // Domain Name:BITVALUE.INFO
        // Created On:07-May-2013 14:38:56 UTC
        // Last Updated On:07-May-2013 14:38:57 UTC
        // Expiration Date:07-May-2014 14:38:56 UTC
        // Sponsoring Registrar:DomainPeople, Inc. (R128-LRMS)
        // Status:CLIENT TRANSFER PROHIBITED
        // Status:TRANSFER PROHIBITED
        // Registrant ID:2a347b6781b8b908
        // Registrant Name:Alejandro Diaz
        // Registrant Organization:
        // Registrant Street1:1690 Frontage Rd
        // Registrant Street2:
        // Registrant Street3:
        // Registrant City:Chula Vista
        // Registrant State/Province:ca
        // Registrant Postal Code:91911
        // Registrant Country:US
        // Registrant Phone:+1.6195759090
        // Registrant Phone Ext.:
        // Registrant FAX:
        // Registrant FAX Ext.:
        // Registrant Email:adiaz@exporadio.com
        // Admin ID:3935557c6fea37cc
        // Admin Name:Alejandro Diaz
        // Admin Organization:
        // Admin Street1:1690 Frontage Road
        // Admin Street2:
        // Admin Street3:
        // Admin City:Chula Vista
        // Admin State/Province:CA
        // Admin Postal Code:91910
        // Admin Country:US
        // Admin Phone:+1.6195759090
        // Admin Phone Ext.:
        // Admin FAX:
        // Admin FAX Ext.:
        // Admin Email:calradio@gmail.com
        // Billing ID:2a347b6781b8b908
        // Billing Name:Alejandro Diaz
        // Billing Organization:
        // Billing Street1:1690 Frontage Rd
        // Billing Street2:
        // Billing Street3:
        // Billing City:Chula Vista
        // Billing State/Province:ca
        // Billing Postal Code:91911
        // Billing Country:US
        // Billing Phone:+1.6195759090
        // Billing Phone Ext.:
        // Billing FAX:
        // Billing FAX Ext.:
        // Billing Email:adiaz@exporadio.com
        // Tech ID:3935557c6fea37cc
        // Tech Name:Alejandro Diaz
        // Tech Organization:
        // Tech Street1:1690 Frontage Road
        // Tech Street2:
        // Tech Street3:
        // Tech City:Chula Vista
        // Tech State/Province:CA
        // Tech Postal Code:91910
        // Tech Country:US
        // Tech Phone:+1.6195759090
        // Tech Phone Ext.:
        // Tech FAX:
        // Tech FAX Ext.:
        // Tech Email:calradio@gmail.com
        // Name Server:A.DNS.HOSTWAY.NET
        // Name Server:B.DNS.HOSTWAY.NET
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:
        // Name Server:

        try
          IdWhois.Host := kWhoIsServer_13;
          lsResultado1 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado1);
        except
          on E: Exception do begin
            lsResultado1 := 'No match for';
            Screen.Cursor := crDefault;
            frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_13 + #13 + #10 + E.Message, 'Error', MB_OK);
          end;
        end;

        // Un 'Enter' (cambio de linea) es un '0Ah'
        liPos := Pos ('No match for', lsResultado1);

        if (liPos > 0) then begin
          // No match for "KGKHJGKJ.com".
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos, lsResultado1, $0A);

          pbErrorNoMatch := True;
          if (pbAuto = False) then
            frmMain.MessageBoxBeep (Self.Handle, lsTemp, 'Error', MB_OK);
        end
        else begin
          // Se hizo exitosamente el WhoIs

          // Sponsoring Registrar:DomainPeople, Inc. (R128-LRMS)
          // Sponsoring Registrar:GoDaddy.com LLC (R171-LRMS)
          // Sponsoring Registrar:Tucows Inc. (R139-LRMS)
          psRegistrar := '';
          liPos := Pos ('Registrar:', lsResultado1);
          if (liPos > 0) then begin
            psRegistrar := Obtener_Cadena_hasta_Caracter (liPos+10, lsResultado1, $0A);
            psRegistrar := Trim (psRegistrar);
          end;

          {// Whois Server: whois.networksolutions.com
          lsWhoisServer := '';
          liPos := Pos ('Whois Server: ', lsResultado1);
          if (liPos > 0) then begin
            lsWhoisServer := Obtener_Cadena_hasta_Caracter (liPos+14, lsResultado1, $0A);
            lsWhoisServer := Trim (lsWhoisServer);
          end;}

          // Expiration Date:07-May-2014 14:38:56 UTC
          pdExpire := 0;
          liPos := Pos ('Expiration Date:', lsResultado1);
          if (liPos > 0) then begin
            lsTemp := Obtener_Cadena_hasta_Caracter (liPos+16, lsResultado1, $0A);
            pdExpire := Convertir_a_Fecha_Double (lsTemp);
          end;

          if (Pos (UpperCase ('DomainPeople'), UpperCase (psRegistrar)) > 0) then begin
            try
              IdWhois.Host := kWhoIsServer_101;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
            except
              on E: Exception do begin
                lsResultado1 := 'No match for';
                Screen.Cursor := crDefault;
                frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_101 + #13 + #10 + E.Message, 'Error', MB_OK);
              end;
            end;

            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                  Inc (liPos);
                Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                  Inc (liPos);
                Inc (liPos);
                Inc (liPos);

                liPosLineaActual := liPos;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                // Posibles valores:
                //    Alejandro Diaz (info@exporadio.com)
                //    Alejandro Diaz (adiaz@aviasoft.com)

                if (Pos ('(', lslinea) > 0) then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord ('('));

                  // Name, Last
                  lsTemp := Trim (lsTemp);
                  if (lsTemp = 'CALIFORMULA RADIO GROUP') then begin
                    psName := lsTemp;
                    psLast := '';
                    psFirst := '';
                  end
                  else if (lsTemp = 'WhoisProtector bitkap.com') or
                     (lsTemp = 'WhoisProtector bitvek.com') then
                  begin
                    psLast := '';
                    psFirst := lsTemp;
                  end
                  else begin
                    psFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
                    psLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
                  end;

                  // Email
                  liPos2 := Pos ('(', lslinea);
                  Delete (lsLinea, 1, liPos2);
                  lsLinea := Trim (lsLinea);
                  Delete (lsLinea, Length (lsLinea), 1);
                  psEMail := Trim (lsLinea);


                  // Email
                  //    Alejandro Diaz (info@exporadio.com)

                  // Brincar hasta el final de la linea
                  liPos := liPosLineaActual;
                  while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                    Inc (liPos);
                  Inc (liPos);


                  // Phone
                  //    +1.6195759090

                  //lnJ := 0;
                  while (True) do begin
                    psPhone := Obtener_Cadena_hasta_Caracter (liPos, lsResultado2, $0D);
                    psPhone := Trim (psPhone);

                    {if (psPhone <> '') then begin
                      if not ((psPhone [1] >= '0') and (psPhone [1] <= '9') or (psPhone [1] = '(') or (psPhone [1] = '+')) then begin
                        // Brincar otra linea
                        while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                          Inc (liPosLineaActual);
                        Inc (liPosLineaActual);
                      end;
                    end;

                    Inc (lnJ);
                    if (lnJ = 8) then}
                      Break;
                  end;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            // NSx
            // Domain servers in listed order:
            // DNS1.CALIFORMULA.COM         207.67.132.3
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Name Servers:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 13;

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end
          else if (Pos (UpperCase ('GoDaddy'), UpperCase (psRegistrar)) > 0) then begin
            try
              IdWhois.Host := kWhoIsServer_106;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
            except
              on E: Exception do begin
                lsResultado1 := 'No match for';
                Screen.Cursor := crDefault;
                frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_106 + #13 + #10 + E.Message, 'Error', MB_OK);
              end;
            end;

            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                //    Administrative Contact:
                //       Private, Registration  MICNOW.COM@domainsbyproxy.com
                //       Domains By Proxy, LLC
                //       DomainsByProxy.com
                //       14747 N Northsight Blvd Suite 111, PMB 309
                //       Scottsdale, Arizona 85260
                //       United States
                //       (480) 624-2599      Fax -- (480) 624-2598
                lsLinea := Obtener_Cadena_hasta_Caracter (liPos, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Pos ('@', lslinea) > 0) then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord ('@'));

                  liIndice := -1;
                  for lnJ := Length (lsTemp)-1 downto 1 do begin
                    if (lsTemp [lnJ] = ' ') then begin
                      liIndice := lnJ;
                      Break;
                    end;
                  end;

                  if (liIndice <> -1) then begin
                    //lsTemp := Trim (Copy (lsTemp, 1, liIndice));
                    Delete (lsLinea, 1, liIndice);
                  end;

                  {// Name, Last
                  lsTemp := Trim (lsTemp);
                  if (lsTemp = 'Network Solutions, LLC.') then begin
                    psLast := '';
                    psFirst := lsTemp;
                  end
                  else begin
                    liPos := Pos (',', lsTemp);
                    if (liPos > 0) and (liPos <> Length (lsTemp)) then begin
                      psLast := Trim (Copy (lsTemp, 1, liPos-1));
                      psFirst := Trim (Copy (lsTemp, liPos+1, 99));
                    end
                    else begin
                      psLast := '';
                      psFirst := lsTemp;
                    end;
                  end;}

                  // Email
                  psEMail := Trim (lsLinea);
                end;

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                liPosLineaActual := liPos;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);
                psName := lsLinea;

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                //       (480) 624-2599      Fax -- (480) 624-2598
                lnJ := 0;
                liPosLineaActual := liPos;
                while (True) do begin
                  psPhone := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                  psPhone := Trim (psPhone);

                  if (psPhone <> '') then begin
                    if not ((psPhone [1] >= '0') and (psPhone [1] <= '9') or (psPhone [1] = '(')) then begin
                      // Brincar otra linea
                      while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                        Inc (liPosLineaActual);
                      Inc (liPosLineaActual);
                    end;
                  end;

                  Inc (lnJ);
                  if (lnJ = 8) then
                    Break;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            //  Domain servers in listed order:
            //      rell.mubot.com
            //     rg.intersim.org
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Domain servers in listed order:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 31;

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end
          else if (Pos (UpperCase ('Tucows'), UpperCase (psRegistrar)) > 0) then begin
            try
              IdWhois.Host := kWhoIsServer_102;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
            except
              on E: Exception do begin
                lsResultado1 := 'No match for';
                Screen.Cursor := crDefault;
                frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_102 + #13 + #10 + E.Message, 'Error', MB_OK);
              end;
            end;

            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar hasta el final de la linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);

                liPosLineaActual := liPos + 1;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                // Posibles valores:
                // Contact Privacy Inc. Customer 0118753510,   internam.com@contactprivacy.com
                // Diaz, Alejandro  adiaz@exporadio.com

                if (Pos ('@', lslinea) > 0) then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord ('@'));

                  liIndice := -1;
                  for lnJ := Length (lsTemp)-1 downto 1 do begin
                    if (lsTemp [lnJ] = ' ') then begin
                      liIndice := lnJ;
                      Break;
                    end;
                  end;

                  if (liIndice <> -1) then begin
                    lsTemp := Trim (Copy (lsTemp, 1, liIndice));
                    Delete (lsLinea, 1, Length (lsTemp));
                  end;

                  // Name, Last
                  lsTemp := Trim (lsTemp);
                  if (lsTemp = 'Network Solutions, LLC.') then begin
                    psLast := '';
                    psFirst := lsTemp;
                  end
                  else begin
                    liPos := Pos (',', lsTemp);
                    if (liPos > 0) and (liPos <> Length (lsTemp)) then begin
                      psLast := Trim (Copy (lsTemp, 1, liPos-1));
                      psFirst := Trim (Copy (lsTemp, liPos+1, 99));
                    end
                    else begin
                      psLast := '';
                      psFirst := lsTemp;
                    end;
                  end;

                  // Email
                  //Delete (lsLinea, 1, Length (lsTemp)+1);
                  psEMail := Trim (lsLinea);


                  // Name
                  // Califormula Radio Group
                  // 1690 FRONTAGE RD
                  // P.O. Box 430

                  // Brincar hasta el final de la linea
                  liPos := liPosLineaActual;
                  while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                    Inc (liPos);

                  liPosLineaActual := liPos + 1;
                  psName := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                  psName := Trim (psName);
                  // Si empieza con un numero, se asume que es una direccion
                  // Si empieza con P.O, se asume que es una direccion
                  if (Length (psName) >= 1) and (psName [1] >= '0') and (psName [1] <= '9') then
                    psName := ''
                  else if (Length (psName) >= 3) and (psName [1] = 'P') and (psName [2] = '.') and (psName [3] = 'O') then
                    psName := '';

                  // Brincar 2 lineas
                  for lnJ := 1 to 2 do begin
                    while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                      Inc (liPosLineaActual);
                    Inc (liPosLineaActual);
                  end;


                  // Phone
                  // 619.575-9090 (FAX) 619 427 2999

                  lnJ := 0;
                  while (True) do begin
                    psPhone := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                    psPhone := Trim (psPhone);

                    if (psPhone <> '') then begin
                      if not ((psPhone [1] >= '0') and (psPhone [1] <= '9') or (psPhone [1] = '(') or (psPhone [1] = '+')) then begin
                        // Brincar otra linea
                        while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                          Inc (liPosLineaActual);
                        Inc (liPosLineaActual);
                      end;
                    end;

                    Inc (lnJ);
                    if (lnJ = 8) then
                      Break;
                  end;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            // NSx
            // Domain servers in listed order:
            // DNS1.CALIFORMULA.COM         207.67.132.3
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Domain servers in listed order:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 31;

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end;




          // Cargar la forma de resultados
          Cargar_Resultados (lbVerificarInfo);
        end;
      end
      else if (liWhoIs = 6) then begin
        // US
        // Domain Name:                                 EXERBOTS.US
        // Domain ID:                                   D35651564-US
        // Sponsoring Registrar:                        DOMAIN PEOPLE
        // Sponsoring Registrar IANA ID:                65
        // Registrar URL (registration services):       www.domainpeople.com
        // Domain Status:                               clientTransferProhibited
        // Registrant ID:                               D75DE2ABFAB3B119
        // Registrant Name:                             Alejandro  Diaz
        // Registrant Organization:                     Alejandro Diaz
        // Registrant Address1:                         1690 Frontage Road
        // Registrant City:                             Chula Vista
        // Registrant State/Province:                   CA
        // Registrant Postal Code:                      91911
        // Registrant Country:                          United States
        // Registrant Country Code:                     US
        // Registrant Phone Number:                     +1.6195759090
        // Registrant Email:                            admin@internam.com
        // Registrant Application Purpose:              P1
        // Registrant Nexus Category:                   C11
        // Administrative Contact ID:                   D75DE2ABFAB3B119
        // Administrative Contact Name:                 Alejandro  Diaz
        // Administrative Contact Organization:         Alejandro Diaz
        // Administrative Contact Address1:             1690 Frontage Road
        // Administrative Contact City:                 Chula Vista
        // Administrative Contact State/Province:       CA
        // Administrative Contact Postal Code:          91911
        // Administrative Contact Country:              United States
        // Administrative Contact Country Code:         US
        // Administrative Contact Phone Number:         +1.6195759090
        // Administrative Contact Email:                admin@internam.com
        // Administrative Application Purpose:          P1
        // Administrative Nexus Category:               C11
        // Billing Contact ID:                          D75DE2ABFAB3B119
        // Billing Contact Name:                        Alejandro  Diaz
        // Billing Contact Organization:                Alejandro Diaz
        // Billing Contact Address1:                    1690 Frontage Road
        // Billing Contact City:                        Chula Vista
        // Billing Contact State/Province:              CA
        // Billing Contact Postal Code:                 91911
        // Billing Contact Country:                     United States
        // Billing Contact Country Code:                US
        // Billing Contact Phone Number:                +1.6195759090
        // Billing Contact Email:                       admin@internam.com
        // Billing Application Purpose:                 P1
        // Billing Nexus Category:                      C11
        // Technical Contact ID:                        D75DE2ABFAB3B119
        // Technical Contact Name:                      Alejandro  Diaz
        // Technical Contact Organization:              Alejandro Diaz
        // Technical Contact Address1:                  1690 Frontage Road
        // Technical Contact City:                      Chula Vista
        // Technical Contact State/Province:            CA
        // Technical Contact Postal Code:               91911
        // Technical Contact Country:                   United States
        // Technical Contact Country Code:              US
        // Technical Contact Phone Number:              +1.6195759090
        // Technical Contact Email:                     admin@internam.com
        // Technical Application Purpose:               P1
        // Technical Nexus Category:                    C11
        // Name Server:                                 RELL.MUBOT.COM
        // Name Server:                                 NS1.INTERNAM.COM
        // Created by Registrar:                        DOMAIN PEOPLE
        // Last Updated by Registrar:                   DOMAIN PEOPLE
        // Domain Registration Date:                    Sat Mar 17 15:03:22 GMT 2012
        // Domain Expiration Date:                      Sun Mar 16 23:59:59 GMT 2014
        // Domain Last Updated Date:                    Fri Mar 23 00:27:10 GMT 2012

        try
          IdWhois.Host := kWhoIsServer_14;
          lsResultado1 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado1);
        except
          on E: Exception do begin
            lsResultado1 := 'No match for';
            Screen.Cursor := crDefault;
            frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_14 + #13 + #10 + E.Message, 'Error', MB_OK);
          end;
        end;

        // Un 'Enter' (cambio de linea) es un '0Ah'
        liPos := Pos ('No match for', lsResultado1);

        if (liPos > 0) then begin
          // No match for "KGKHJGKJ.com".
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos, lsResultado1, $0A);

          pbErrorNoMatch := True;
          if (pbAuto = False) then
            frmMain.MessageBoxBeep (Self.Handle, lsTemp, 'Error', MB_OK);
        end
        else begin
          // Se hizo exitosamente el WhoIs

          // Registrar URL (registration services):       www.domainpeople.com
          // Registrar URL (registration services):       whois.godaddy.com
          psRegistrar := '';
          liPos := Pos ('Registrar URL (registration services):', lsResultado1);
          if (liPos > 0) then begin
            psRegistrar := Obtener_Cadena_hasta_Caracter (liPos+38, lsResultado1, $0A);
            psRegistrar := Trim (psRegistrar);
          end;

          {// Whois Server: whois.networksolutions.com
          lsWhoisServer := '';
          liPos := Pos ('Whois Server: ', lsResultado1);
          if (liPos > 0) then begin
            lsWhoisServer := Obtener_Cadena_hasta_Caracter (liPos+14, lsResultado1, $0A);
            lsWhoisServer := Trim (lsWhoisServer);
          end;}

          // Domain Expiration Date:                      Sun Mar 16 23:59:59 GMT 2014
          pdExpire := 0;
          liPos := Pos ('Domain Expiration Date:', lsResultado1);
          if (liPos > 0) then begin
            lsTemp := Obtener_Cadena_hasta_Caracter (liPos+23, lsResultado1, $0A);
            pdExpire := Convertir_a_Fecha_Double_3 (lsTemp);
          end;

          if (Pos (UpperCase ('www.domainpeople.com'), UpperCase (psRegistrar)) > 0) then begin
            try
              IdWhois.Host := kWhoIsServer_101;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
            except
              on E: Exception do begin
                lsResultado1 := 'No match for';
                Screen.Cursor := crDefault;
                frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_101 + #13 + #10 + E.Message, 'Error', MB_OK);
              end;
            end;

            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                  Inc (liPos);
                Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                  Inc (liPos);
                Inc (liPos);
                Inc (liPos);

                liPosLineaActual := liPos;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                // Posibles valores:
                //    Alejandro Diaz (info@exporadio.com)
                //    Alejandro Diaz (adiaz@aviasoft.com)

                if (Pos ('(', lslinea) > 0) then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord ('('));

                  // Name, Last
                  lsTemp := Trim (lsTemp);
                  if (lsTemp = 'CALIFORMULA RADIO GROUP') then begin
                    psName := lsTemp;
                    psLast := '';
                    psFirst := '';
                  end
                  else if (lsTemp = 'WhoisProtector bitkap.com') or
                     (lsTemp = 'WhoisProtector bitvek.com') then
                  begin
                    psLast := '';
                    psFirst := lsTemp;
                  end
                  else begin
                    psFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
                    psLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
                  end;

                  // Email
                  liPos2 := Pos ('(', lslinea);
                  Delete (lsLinea, 1, liPos2);
                  lsLinea := Trim (lsLinea);
                  Delete (lsLinea, Length (lsLinea), 1);
                  psEMail := Trim (lsLinea);


                  // Email
                  //    Alejandro Diaz (info@exporadio.com)

                  // Brincar hasta el final de la linea
                  liPos := liPosLineaActual;
                  while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                    Inc (liPos);
                  Inc (liPos);


                  // Phone
                  //    +1.6195759090

                  //lnJ := 0;
                  while (True) do begin
                    psPhone := Obtener_Cadena_hasta_Caracter (liPos, lsResultado2, $0D);
                    psPhone := Trim (psPhone);

                    {if (psPhone <> '') then begin
                      if not ((psPhone [1] >= '0') and (psPhone [1] <= '9') or (psPhone [1] = '(') or (psPhone [1] = '+')) then begin
                        // Brincar otra linea
                        while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                          Inc (liPosLineaActual);
                        Inc (liPosLineaActual);
                      end;
                    end;

                    Inc (lnJ);
                    if (lnJ = 8) then}
                      Break;
                  end;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            // NSx
            // Domain servers in listed order:
            // DNS1.CALIFORMULA.COM         207.67.132.3
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Name Servers:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 13;

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end
          else if (Pos (UpperCase ('whois.godaddy.com'), UpperCase (psRegistrar)) > 0) then begin
            try
              IdWhois.Host := kWhoIsServer_106;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
            except
              on E: Exception do begin
                lsResultado1 := 'No match for';
                Screen.Cursor := crDefault;
                frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_106 + #13 + #10 + E.Message, 'Error', MB_OK);
              end;
            end;

            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                //    Administrative Contact:
                //       Private, Registration  MICNOW.COM@domainsbyproxy.com
                //       Domains By Proxy, LLC
                //       DomainsByProxy.com
                //       14747 N Northsight Blvd Suite 111, PMB 309
                //       Scottsdale, Arizona 85260
                //       United States
                //       (480) 624-2599      Fax -- (480) 624-2598
                lsLinea := Obtener_Cadena_hasta_Caracter (liPos, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Pos ('@', lslinea) > 0) then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord ('@'));

                  liIndice := -1;
                  for lnJ := Length (lsTemp)-1 downto 1 do begin
                    if (lsTemp [lnJ] = ' ') then begin
                      liIndice := lnJ;
                      Break;
                    end;
                  end;

                  if (liIndice <> -1) then begin
                    //lsTemp := Trim (Copy (lsTemp, 1, liIndice));
                    Delete (lsLinea, 1, liIndice);
                  end;

                  {// Name, Last
                  lsTemp := Trim (lsTemp);
                  if (lsTemp = 'Network Solutions, LLC.') then begin
                    psLast := '';
                    psFirst := lsTemp;
                  end
                  else begin
                    liPos := Pos (',', lsTemp);
                    if (liPos > 0) and (liPos <> Length (lsTemp)) then begin
                      psLast := Trim (Copy (lsTemp, 1, liPos-1));
                      psFirst := Trim (Copy (lsTemp, liPos+1, 99));
                    end
                    else begin
                      psLast := '';
                      psFirst := lsTemp;
                    end;
                  end;}

                  // Email
                  psEMail := Trim (lsLinea);
                end;

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                liPosLineaActual := liPos;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);
                psName := lsLinea;

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0A)) do
                  Inc (liPos);
                Inc (liPos);

                //       (480) 624-2599      Fax -- (480) 624-2598
                lnJ := 0;
                liPosLineaActual := liPos;
                while (True) do begin
                  psPhone := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                  psPhone := Trim (psPhone);

                  if (psPhone <> '') then begin
                    if not ((psPhone [1] >= '0') and (psPhone [1] <= '9') or (psPhone [1] = '(')) then begin
                      // Brincar otra linea
                      while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                        Inc (liPosLineaActual);
                      Inc (liPosLineaActual);
                    end;
                  end;

                  Inc (lnJ);
                  if (lnJ = 8) then
                    Break;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            //  Domain servers in listed order:
            //      rell.mubot.com
            //     rg.intersim.org
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Domain servers in listed order:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 31;

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end;



          // Cargar la forma de resultados
          Cargar_Resultados (lbVerificarInfo);
        end;
      end
      else if (liWhoIs = 7) then begin
        // BIZ
        // Domain Name:                                 AIRBOT.BIZ
        // Domain ID:                                   D48906209-BIZ
        // Sponsoring Registrar:                        DOMAIN PEOPLE
        // Sponsoring Registrar IANA ID:                65
        // Registrar URL (registration services):       whois.biz
        // Domain Status:                               clientTransferProhibited
        // Registrant ID:                               0DA9B9191C0FBE7A
        // Registrant Name:                             Alejandro  Diaz
        // Registrant Organization:                     Alejandro Diaz
        // Registrant Address1:                         1690 Frontage Road
        // Registrant City:                             Chula Vista
        // Registrant State/Province:                   CA
        // Registrant Postal Code:                      91910
        // Registrant Country:                          United States
        // Registrant Country Code:                     US
        // Registrant Phone Number:                     +1.6195759090
        // Registrant Email:                            adiaz@aviasoft.com
        // Administrative Contact ID:                   5AB929245324D554
        // Administrative Contact Name:                 Alejandro  Diaz
        // Administrative Contact Organization:         -
        // Administrative Contact Address1:             1690 Frontage Road
        // Administrative Contact City:                 Chula Vista
        // Administrative Contact State/Province:       CA
        // Administrative Contact Postal Code:          91910
        // Administrative Contact Country:              United States
        // Administrative Contact Country Code:         US
        // Administrative Contact Phone Number:         +1.6195759090
        // Administrative Contact Email:                info@exporadio.com
        // Billing Contact ID:                          0DA9B9191C0FBE7A
        // Billing Contact Name:                        Alejandro  Diaz
        // Billing Contact Organization:                Alejandro Diaz
        // Billing Contact Address1:                    1690 Frontage Road
        // Billing Contact City:                        Chula Vista
        // Billing Contact State/Province:              CA
        // Billing Contact Postal Code:                 91910
        // Billing Contact Country:                     United States
        // Billing Contact Country Code:                US
        // Billing Contact Phone Number:                +1.6195759090
        // Billing Contact Email:                       adiaz@aviasoft.com
        // Technical Contact ID:                        0DA9B9191C0FBE7A
        // Technical Contact Name:                      Alejandro  Diaz
        // Technical Contact Organization:              Alejandro Diaz
        // Technical Contact Address1:                  1690 Frontage Road
        // Technical Contact City:                      Chula Vista
        // Technical Contact State/Province:            CA
        // Technical Contact Postal Code:               91910
        // Technical Contact Country:                   United States
        // Technical Contact Country Code:              US
        // Technical Contact Phone Number:              +1.6195759090
        // Technical Contact Email:                     adiaz@aviasoft.com
        // Name Server:                                 RELL.MUBOT.COM
        // Name Server:                                 NS1.INTERNAM.COM
        // Created by Registrar:                        DOMAIN PEOPLE
        // Last Updated by Registrar:                   DOMAIN PEOPLE
        // Domain Registration Date:                    Sun Feb 19 02:28:54 GMT 2012
        // Domain Expiration Date:                      Tue Feb 18 23:59:59 GMT 2014
        // Domain Last Updated Date:                    Wed Mar 14 01:11:20 GMT 2012

        try
          IdWhois.Host := kWhoIsServer_15;
          lsResultado1 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado1);
        except
          on E: Exception do begin
            lsResultado1 := 'No match for';
            Screen.Cursor := crDefault;
            frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_15 + #13 + #10 + E.Message, 'Error', MB_OK);
          end;
        end;

        // Un 'Enter' (cambio de linea) es un '0Ah'
        liPos := Pos ('No match for', lsResultado1);

        if (liPos > 0) then begin
          // No match for "KGKHJGKJ.com".
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos, lsResultado1, $0A);

          pbErrorNoMatch := True;
          if (pbAuto = False) then
            frmMain.MessageBoxBeep (Self.Handle, lsTemp, 'Error', MB_OK);
        end
        else begin
          // Se hizo exitosamente el WhoIs

          // Sponsoring Registrar:                        DOMAIN PEOPLE
          // Registrar URL (registration services):       whois.biz
          psRegistrar := '';
          liPos := Pos ('Registrar URL (registration services):', lsResultado1);
          if (liPos > 0) then begin
            psRegistrar := Obtener_Cadena_hasta_Caracter (liPos+38, lsResultado1, $0A);
            psRegistrar := Trim (psRegistrar);
          end;

          {// Whois Server: whois.networksolutions.com
          lsWhoisServer := '';
          liPos := Pos ('Whois Server: ', lsResultado1);
          if (liPos > 0) then begin
            lsWhoisServer := Obtener_Cadena_hasta_Caracter (liPos+14, lsResultado1, $0A);
            lsWhoisServer := Trim (lsWhoisServer);
          end;}

          // Domain Expiration Date:                      Sun Mar 16 23:59:59 GMT 2014
          pdExpire := 0;
          liPos := Pos ('Domain Expiration Date:', lsResultado1);
          if (liPos > 0) then begin
            lsTemp := Obtener_Cadena_hasta_Caracter (liPos+23, lsResultado1, $0A);
            pdExpire := Convertir_a_Fecha_Double_3 (lsTemp);
          end;

          if (Pos (UpperCase ('whois.biz'), UpperCase (psRegistrar)) > 0) then begin
            try
              IdWhois.Host := kWhoIsServer_101;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
            except
              on E: Exception do begin
                lsResultado1 := 'No match for';
                Screen.Cursor := crDefault;
                frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_101 + #13 + #10 + E.Message, 'Error', MB_OK);
              end;
            end;

            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                  Inc (liPos);
                Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                  Inc (liPos);
                Inc (liPos);
                Inc (liPos);

                liPosLineaActual := liPos;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                // Posibles valores:
                //    Alejandro Diaz (info@exporadio.com)
                //    Alejandro Diaz (adiaz@aviasoft.com)

                if (Pos ('(', lslinea) > 0) then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord ('('));

                  // Name, Last
                  lsTemp := Trim (lsTemp);
                  if (lsTemp = 'CALIFORMULA RADIO GROUP') then begin
                    psName := lsTemp;
                    psLast := '';
                    psFirst := '';
                  end
                  else if (lsTemp = 'WhoisProtector bitkap.com') or
                     (lsTemp = 'WhoisProtector bitvek.com') then
                  begin
                    psLast := '';
                    psFirst := lsTemp;
                  end
                  else begin
                    psFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
                    psLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
                  end;

                  // Email
                  liPos2 := Pos ('(', lslinea);
                  Delete (lsLinea, 1, liPos2);
                  lsLinea := Trim (lsLinea);
                  Delete (lsLinea, Length (lsLinea), 1);
                  psEMail := Trim (lsLinea);


                  // Email
                  //    Alejandro Diaz (info@exporadio.com)

                  // Brincar hasta el final de la linea
                  liPos := liPosLineaActual;
                  while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                    Inc (liPos);
                  Inc (liPos);


                  // Phone
                  //    +1.6195759090

                  //lnJ := 0;
                  while (True) do begin
                    psPhone := Obtener_Cadena_hasta_Caracter (liPos, lsResultado2, $0D);
                    psPhone := Trim (psPhone);

                    {if (psPhone <> '') then begin
                      if not ((psPhone [1] >= '0') and (psPhone [1] <= '9') or (psPhone [1] = '(') or (psPhone [1] = '+')) then begin
                        // Brincar otra linea
                        while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                          Inc (liPosLineaActual);
                        Inc (liPosLineaActual);
                      end;
                    end;

                    Inc (lnJ);
                    if (lnJ = 8) then}
                      Break;
                  end;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            // NSx
            // Domain servers in listed order:
            // DNS1.CALIFORMULA.COM         207.67.132.3
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Name Servers:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 13;

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end;



          // Cargar la forma de resultados
          Cargar_Resultados (lbVerificarInfo);
        end;
      end
      else if (liWhoIs = 8) then begin
        // CO
        // Domain Name:                                 MASMONEDAS.CO
        // Domain ID:                                   D46186052-CO
        // Sponsoring Registrar:                        ENOM, INC.
        // Sponsoring Registrar IANA ID:                48
        // Registrar URL (registration services):       www.enom.com
        // Domain Status:                               clientTransferProhibited
        // Registrant ID:                               7D9934F3538B5BF1
        // Registrant Name:                             Alejandro Diaz
        // Registrant Organization:                     Alejandro Diaz
        // Registrant Address1:                         1690 Frontage Road
        // Registrant City:                             Chula Vista
        // Registrant State/Province:                   CA
        // Registrant Postal Code:                      91910
        // Registrant Country:                          United States
        // Registrant Country Code:                     US
        // Registrant Phone Number:                     +1.6195759090
        // Registrant Email:                            adiaz@aviasoft.com
        // Administrative Contact ID:                   515FE08628197487
        // Administrative Contact Name:                 Alejandro Diaz
        // Administrative Contact Organization:         -
        // Administrative Contact Address1:             1690 Frontage Road
        // Administrative Contact City:                 Chula Vista
        // Administrative Contact State/Province:       CA
        // Administrative Contact Postal Code:          91910
        // Administrative Contact Country:              United States
        // Administrative Contact Country Code:         US
        // Administrative Contact Phone Number:         +1.6195759090
        // Administrative Contact Email:                info@exporadio.com
        // Billing Contact ID:                          7D9934F3538B5BF1
        // Billing Contact Name:                        Alejandro Diaz
        // Billing Contact Organization:                Alejandro Diaz
        // Billing Contact Address1:                    1690 Frontage Road
        // Billing Contact City:                        Chula Vista
        // Billing Contact State/Province:              CA
        // Billing Contact Postal Code:                 91910
        // Billing Contact Country:                     United States
        // Billing Contact Country Code:                US
        // Billing Contact Phone Number:                +1.6195759090
        // Billing Contact Email:                       adiaz@aviasoft.com
        // Technical Contact ID:                        7D9934F3538B5BF1
        // Technical Contact Name:                      Alejandro Diaz
        // Technical Contact Organization:              Alejandro Diaz
        // Technical Contact Address1:                  1690 Frontage Road
        // Technical Contact City:                      Chula Vista
        // Technical Contact State/Province:            CA
        // Technical Contact Postal Code:               91910
        // Technical Contact Country:                   United States
        // Technical Contact Country Code:              US
        // Technical Contact Phone Number:              +1.6195759090
        // Technical Contact Email:                     adiaz@aviasoft.com
        // Name Server:                                 A.DNS.HOSTWAY.NET
        // Name Server:                                 B.DNS.HOSTWAY.NET
        // Created by Registrar:                        ENOM, INC.
        // Last Updated by Registrar:                   ENOM, INC.
        // Domain Registration Date:                    Fri Jul 19 02:10:48 GMT 2013
        // Domain Expiration Date:                      Fri Jul 18 23:59:59 GMT 2014
        // Domain Last Updated Date:                    Fri Jul 19 02:10:49 GMT 2013

        try
          IdWhois.Host := kWhoIsServer_16;
          lsResultado1 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado1);
        except
          on E: Exception do begin
            lsResultado1 := 'No match for';
            Screen.Cursor := crDefault;
            frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_15 + #13 + #10 + E.Message, 'Error', MB_OK);
          end;
        end;

        // Un 'Enter' (cambio de linea) es un '0Ah'
        liPos := Pos ('No match for', lsResultado1);

        if (liPos > 0) then begin
          // No match for "KGKHJGKJ.com".
          lsTemp := Obtener_Cadena_hasta_Caracter (liPos, lsResultado1, $0A);

          pbErrorNoMatch := True;
          if (pbAuto = False) then
            frmMain.MessageBoxBeep (Self.Handle, lsTemp, 'Error', MB_OK);
        end
        else begin
          // Se hizo exitosamente el WhoIs

          // Sponsoring Registrar:                        DOMAIN PEOPLE
          // Registrar URL (registration services):       whois.biz
          psRegistrar := '';
          liPos := Pos ('Registrar URL (registration services):', lsResultado1);
          if (liPos > 0) then begin
            psRegistrar := Obtener_Cadena_hasta_Caracter (liPos+38, lsResultado1, $0A);
            psRegistrar := Trim (psRegistrar);
          end;

          {// Whois Server: whois.networksolutions.com
          lsWhoisServer := '';
          liPos := Pos ('Whois Server: ', lsResultado1);
          if (liPos > 0) then begin
            lsWhoisServer := Obtener_Cadena_hasta_Caracter (liPos+14, lsResultado1, $0A);
            lsWhoisServer := Trim (lsWhoisServer);
          end;}

          // Domain Expiration Date:                      Sun Mar 16 23:59:59 GMT 2014
          pdExpire := 0;
          liPos := Pos ('Domain Expiration Date:', lsResultado1);
          if (liPos > 0) then begin
            lsTemp := Obtener_Cadena_hasta_Caracter (liPos+23, lsResultado1, $0A);
            pdExpire := Convertir_a_Fecha_Double_3 (lsTemp);
          end;

          if (Pos (UpperCase ('www.enom.com'), UpperCase (psRegistrar)) > 0) then begin
            try
              IdWhois.Host := kWhoIsServer_101;
              lsResultado2 := IdWhois.WhoIs (lsDomainName);
//showmessage (lsResultado2);
            except
              on E: Exception do begin
                lsResultado1 := 'No match for';
                Screen.Cursor := crDefault;
                frmMain.MessageBoxBeep (Self.Handle, kWhoIsServer_101 + #13 + #10 + E.Message, 'Error', MB_OK);
              end;
            end;

            // Segundo resultado del WhoIs
            for lnI := 1 to 3 do begin
              psLast := '';
              psFirst := '';
              psID := '';
              psEMail := '';
              psName := '';
              psPhone := '';

              if (lnI = 1) then begin
                // Administrative Contact
                liPos := Pos ('Administrative Contact', lsResultado2);
              end
              else if (lnI = 2) then begin
                // Technical Contact
                liPos := Pos ('Technical Contact', lsResultado2);
              end
              else begin
                // Billing Contact
                liPos := Pos ('Billing Contact', lsResultado2);
              end;

              if (liPos > 0) then begin
                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                  Inc (liPos);
                Inc (liPos);
                Inc (liPos);

                // Brincar 1 Linea
                while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                  Inc (liPos);
                Inc (liPos);
                Inc (liPos);

                liPosLineaActual := liPos;
                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                // Posibles valores:
                //    Alejandro Diaz (info@exporadio.com)
                //    Alejandro Diaz (adiaz@aviasoft.com)

                if (Pos ('(', lslinea) > 0) then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord ('('));

                  // Name, Last
                  lsTemp := Trim (lsTemp);
                  if (lsTemp = 'CALIFORMULA RADIO GROUP') then begin
                    psName := lsTemp;
                    psLast := '';
                    psFirst := '';
                  end
                  else if (lsTemp = 'WhoisProtector bitkap.com') or
                     (lsTemp = 'WhoisProtector bitvek.com') then
                  begin
                    psLast := '';
                    psFirst := lsTemp;
                  end
                  else begin
                    psFirst := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
                    psLast  := frmMain.Extraer_Cadena_Hasta_Signo (lsTemp, ' ');
                  end;

                  // Email
                  liPos2 := Pos ('(', lslinea);
                  Delete (lsLinea, 1, liPos2);
                  lsLinea := Trim (lsLinea);
                  Delete (lsLinea, Length (lsLinea), 1);
                  psEMail := Trim (lsLinea);


                  // Email
                  //    Alejandro Diaz (info@exporadio.com)

                  // Brincar hasta el final de la linea
                  liPos := liPosLineaActual;
                  while (liPos <= Length (lsResultado2)) and (lsResultado2 [liPos] <> Chr ($0D)) do
                    Inc (liPos);
                  Inc (liPos);


                  // Phone
                  //    +1.6195759090

                  //lnJ := 0;
                  while (True) do begin
                    psPhone := Obtener_Cadena_hasta_Caracter (liPos, lsResultado2, $0D);
                    psPhone := Trim (psPhone);

                    {if (psPhone <> '') then begin
                      if not ((psPhone [1] >= '0') and (psPhone [1] <= '9') or (psPhone [1] = '(') or (psPhone [1] = '+')) then begin
                        // Brincar otra linea
                        while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                          Inc (liPosLineaActual);
                        Inc (liPosLineaActual);
                      end;
                    end;

                    Inc (lnJ);
                    if (lnJ = 8) then}
                      Break;
                  end;
                end;
              end;


              // Administrative Contact y Technical Contact
              if (lnI = 1) then begin
                // Administrative Contact
                psAdminLast   := psLast;
                psAdminFirst  := psFirst;
                psAdminID     := psID;
                psAdminEMail  := psEMail;
                psAdminName   := psName;
                psAdminPhone  := psPhone;
              end
              else if (lnI = 2) then begin
                // Technical Contact
                psTecnicoLast   := psLast;
                psTecnicoFirst  := psFirst;
                psTecnicoID     := psID;
                psTecnicoEMail  := psEMail;
                psTecnicoName   := psName;
                psTecnicoPhone  := psPhone;
              end
              else begin
                // Billing Contact
                // Se usaran: lsLast, lsFirst, lsHandle, lsEMail, lsName, lsPhone
              end;
            end;


            (*// Expire
            // Record expires on 27-May-2003.
            pdExpire := 0;
            liPos := Pos ('Record expires on ', lsResultado2);
            if (liPos > 0) then begin
              lsTemp := Obtener_Cadena_hasta_Caracter (liPos+18, lsResultado2, $0A);
              pdExpire := Convertir_a_Fecha_Double (lsTemp);
            end;*)


            // NSx
            // Domain servers in listed order:
            // DNS1.CALIFORMULA.COM         207.67.132.3
            for lnJ := 0 to 3 do begin
              paNS [lnJ] := '';
              paNSIP [lnJ] := '';
            end;

            liPos := Pos ('Name Servers:', lsResultado2);
            if (liPos > 0) then begin
              liPosLineaActual := liPos + 13;

              for lnJ := 0 to 3 do begin
                // Brincar una linea
                while (liPosLineaActual <= Length (lsResultado2)) and (lsResultado2 [liPosLineaActual] <> Chr ($0A)) do
                  Inc (liPosLineaActual);
                Inc (liPosLineaActual);

                lsLinea := Obtener_Cadena_hasta_Caracter (liPosLineaActual, lsResultado2, $0A);
                lsLinea := Trim (lsLinea);

                if (Length (lsLinea) > 0) and (UpCase (lsLinea [1]) >= 'A') and (UpCase (lsLinea [1]) <= 'Z') then begin
                  lsTemp := Obtener_Cadena_hasta_Caracter (1, lsLinea, Ord (' '));
                  paNS [lnJ] := Trim (lsTemp);

                  lsTemp := Obtener_Cadena_hasta_Caracter (Length (lsTemp) + 1, lsLinea, $0A);
                  paNSIP [lnJ] := Trim (lsTemp);

                  {if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end; }

                  if (frmMain.Validar_IP (paNSIP [lnJ]) = False) then
                    paNSIP [lnJ] := '0.0.0.0';

                  if (paNS [lnJ] = '') or (paNSIP [lnJ] = '') then begin
                    paNS [lnJ] := '';
                    paNSIP [lnJ] := '';
                  end;
                end
                else
                  Break;
              end;
            end;
          end;



          // Cargar la forma de resultados
          Cargar_Resultados (lbVerificarInfo);
        end;
      end;

      // No need to connect - WhoIs function does this for us
      if (IdWhois.Connected = True) then
        IdWhois.Disconnect;
    except
      on E: Exception do begin
        Screen.Cursor := crDefault;
        frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        Exit;
      end;
    end;

    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmDominios.EditNameChange(Sender: TObject);
begin
  if (pbNuevo = False) then
    BitBtnModificar.Enabled := True;
end;

procedure TfrmDominios.UpDownClick(Sender: TObject; Button: TUDBtnType);
var
  lwYear, lwMonth, lwDay : Word;
begin
  DecodeDate (DateTimePickerExpira.Date, lwYear, lwMonth, lwDay);

  if (Button = btNext) then
    DateTimePickerExpira.Date := EncodeDate (lwYear+1, lwMonth, lwDay)
  else
    DateTimePickerExpira.Date := EncodeDate (lwYear-1, lwMonth, lwDay);
end;

end.

