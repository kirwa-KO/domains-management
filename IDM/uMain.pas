unit uMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, MemDS, DBAccess, MyAccess, ImgList, Menus, ComCtrls, ToolWin;

const
  kTituloPrograma  = 'IDM';  // Mar 2014
  kVersionPrograma = '2.3';

  //kMySQLServer   = '216.105.40.122';
  // kMySQLServer   = 'ns1.internam.com';
  // kMySQLDatabase = 'idm';
  // kMySQLUser     = 'admin';
  // kMySQLPass     = 'privado784512';

  kMySQLServer   = '127.0.0.1';
  kMySQLDatabase = 'idm';
  kMySQLUser     = 'root';
  kMySQLPass     = 'mysql';

  kWhoIsServer_1 = 'whois.internic.net';  // COM NET EDU

  kWhoIsServer_10 = 'whois.publicinterestregistry.net';  // ORG
  kWhoIsServer_11 = 'whois.registrypro.pro';             // PRO
  kWhoIsServer_12 = 'whois.nic.mx';                      // MX
  kWhoIsServer_13 = 'whois.afilias.net';                 // INFO
  kWhoIsServer_14 = 'whois.nic.us';                      // US
  kWhoIsServer_15 = 'whois.nic.biz';                     // BIZ
  kWhoIsServer_16 = 'whois.nic.co';                      // CO
  //kWhoIsServer_17 = 'whois.dotmobiregistry.net ';      // MOBI

  kWhoIsServer_100 = 'whois.networksolutions.com';
  kWhoIsServer_101 = 'whois.domainpeople.com';
  kWhoIsServer_102 = 'whois.tucows.com';
  kWhoIsServer_103 = 'whois.domaindiscover.com';
  kWhoIsServer_104 = 'Whois.bigrock.com';
  kWhoIsServer_105 = 'whois.names4ever.com';
  kWhoIsServer_106 = 'whois.godaddy.com';

  // Manual
  // qmsg.org = 03/24/2014
  // manoamano.mobi = 23-Apr-2014
  // manoamano.tel = 23-Apr-2014
  // ipadman.me = 08-May-2014
  // digitalnotary.asia = 08-May-2015


  // Llave del Registry
  kSoftwareIDM = '\Software\IDM';

  kDias : array [1..7] of string = (
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  );

  kMeses : array [1..12] of string = (
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  );

type
  TfrmMain = class(TForm)
    MainMenu: TMainMenu;
    mInicio: TMenuItem;
    mConfigurarServidor: TMenuItem;
    mSeparador1: TMenuItem;
    mConectarse: TMenuItem;
    mDesconectarse: TMenuItem;
    mSeparador2: TMenuItem;
    mSalir: TMenuItem;
    StatusBar: TStatusBar;
    ToolBar: TToolBar;
    ToolButtonConnect: TToolButton;
    ImageList: TImageList;
    ToolButtonDesconectarse: TToolButton;
    mDNS: TMenuItem;
    mDNSServers: TMenuItem;
    mDomainsMain: TMenuItem;
    mDomains: TMenuItem;
    mReports: TMenuItem;
    mDomainsExpiration: TMenuItem;
    mDomainsExpiredPreview: TMenuItem;
    mPersonsMain: TMenuItem;
    mPersons: TMenuItem;
    mHostsMain: TMenuItem;
    mHosts: TMenuItem;
    mRegistrarMain: TMenuItem;
    mRegistrar: TMenuItem;
    MyConnection: TMyConnection;
    MyQuery: TMyQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mConfigurarServidorClick(Sender: TObject);
    procedure mConectarseClick(Sender: TObject);
    procedure mDesconectarseClick(Sender: TObject);
    procedure mSalirClick(Sender: TObject);
    procedure mDNSServersClick(Sender: TObject);
    procedure mDomainsClick(Sender: TObject);
    procedure mDomainsExpirationClick(Sender: TObject);
    procedure mDomainsExpiredPreviewClick(Sender: TObject);
    procedure mPersonsClick(Sender: TObject);
    procedure mHostsClick(Sender: TObject);
    procedure mRegistrarClick(Sender: TObject);
  public
    psMySQLServer, psMySQLDatabase, psMySQLUser, psMySQLPass : string;

    function MessageBoxBeep (rHandle : HWND; rsBody, rsCaption : string; rBotones : Integer) : Integer;
    function Apostrofe_1_a_2 (rsCadena : string) : string;
    function Extraer_Cadena_Hasta_Signo (var fsCadena : string; rsSigno : string) : string;
    function Validar_IP (rsIP : string) : Boolean;
    function Formatear_Solo_Fecha (rdFecha : TDateTime; rbMesesCortos : Boolean) : string;
    function Leer_Registry (rsNombreKey, rsDefault : string) : string;

    procedure Grabar_Registry (rsNombreKey, rsValorAGrabar : string);
  private
    procedure Habilitar_Todo (rbHabilitar : Boolean);
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Registry, uDNS, uDomains, uExpirationDate, uRepExpired, uPersons, uHosts,
  uRegistrar, uReporteExpiracion, uConfigurar;

{$R *.DFM}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////// Publicos ////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

function TfrmMain.MessageBoxBeep (rHandle : HWND; rsBody, rsCaption : string; rBotones : Integer) : Integer;
begin
  if (rsCaption = 'Error') then
    rBotones := rBotones + MB_ICONERROR
  else if (rsCaption = 'Información') then
    rBotones := rBotones + MB_ICONINFORMATION
  else if (rsCaption = 'Confirmación') then begin
    rBotones := rBotones + MB_ICONQUESTION;
    Beep;
  end;

  Result := MessageBox (rHandle, PChar (rsBody), PChar (rsCaption), rBotones);
end;

function TfrmMain.Apostrofe_1_a_2 (rsCadena : string) : string;
begin
  rsCadena := StringReplace (rsCadena, '''', '''''', [rfReplaceAll]);
  rsCadena := StringReplace (rsCadena, '\', '\\', [rfReplaceAll]);
  Result := rsCadena;
end;

function TfrmMain.Extraer_Cadena_Hasta_Signo (var fsCadena : string; rsSigno : string) : string;
var
  liPos : Integer;
  lsTemp : string;
begin
  lsTemp := fsCadena;
  liPos := Pos (rsSigno, lsTemp);

  if (liPos = 0) then begin
    fsCadena := '';
    Result := lsTemp;
  end
  else begin
    fsCadena := Copy (lsTemp, liPos+1, Length (lsTemp)-liPos);
    Result := Copy (lsTemp, 1, liPos-1);
  end;
end;

function TfrmMain.Validar_IP (rsIP : string) : Boolean;
var
  lnI, liPuntos, liPunto1, liPunto2, liPunto3 : Integer;
begin
  rsIP := Trim (rsIP);

  // Verificar que halla puros numeros y puntos
  liPuntos := 0;
  for lnI := 1 to Length (rsIP) do begin
    if not ((rsIP [lnI] >= '0') and (rsIP [lnI] <= '9') or (rsIP [lnI] = '.')) then begin
      Result := False;
      Exit;
    end;

    if (rsIP [lnI] = '.') then
      Inc (liPuntos);
  end;

  // Tiene que haber 3 puntos
  if (liPuntos <> 3) then begin
    Result := False;
    Exit;
  end;

  liPunto1 := Pos ('.', rsIP);
  rsIP [liPunto1] := '*';

  liPunto2 := Pos ('.', rsIP);
  rsIP [liPunto2] := '*';

  liPunto3 := Pos ('.', rsIP);

  // Revisar que los puntos esten bien
  if (liPunto1 = 1) or (liPunto3 = Length (rsIP)) or ((liPunto2-liPunto1) <= 1) or ((liPunto3-liPunto2) <= 1) then begin
    Result := False;
    Exit;
  end;

  // Revisar que no halla valores de 4 o mas digitos
  if (liPunto1 >= 5) or (liPunto3 <= Length (rsIP)-4) or ((liPunto2-liPunto1) >= 5) or ((liPunto3-liPunto2) >= 5) then begin
    Result := False;
    Exit;
  end;

  Result := True;
end;

function TfrmMain.Formatear_Solo_Fecha (rdFecha : TDateTime; rbMesesCortos : Boolean) : string;
var
  lwYear, lwMes, lwDia : Word;
  lsSalida : string;
begin
  DecodeDate (rdFecha, lwYear, lwMes, lwDia);

  lsSalida := IntToStr (lwDia) + '/';

  if (rbMesesCortos = False) then
    lsSalida := lsSalida + kMeses [lwMes]
  else
    lsSalida := lsSalida + Copy (kMeses [lwMes], 1, 3);

  lsSalida := lsSalida + '/' + IntToStr (lwYear);

  Result := lsSalida;
end;

function TfrmMain.Leer_Registry (rsNombreKey, rsDefault : string) : string;
var
  lReg : TRegistry;
begin
  lReg := nil;

  try
    lReg := TRegistry.Create;
    lReg.RootKey := HKEY_CURRENT_USER;

    if (lReg.OpenKey (kSoftwareIDM, True) = True) then
      Result := lReg.ReadString (rsNombreKey)
    else
      Result := rsDefault;

    lReg.CloseKey;
  except
    Result := rsDefault;
  end;

  lReg.Free;
end;

procedure TfrmMain.Grabar_Registry (rsNombreKey, rsValorAGrabar : string);
var
  lReg : TRegistry;
begin
  lReg := nil;

  try
    lReg := TRegistry.Create;
    lReg.RootKey := HKEY_CURRENT_USER;

    if (lReg.OpenKey (kSoftwareIDM, True) = True) then
      lReg.WriteString (rsNombreKey, rsValorAGrabar);

    lReg.CloseKey;
  except
    // Nada
  end;

  lReg.Free;
end;

procedure TfrmMain.Habilitar_Todo (rbHabilitar : Boolean);
begin
  mConectarse.Enabled       := not rbHabilitar;
  ToolButtonConnect.Enabled := not rbHabilitar;

  mDesconectarse.Enabled          := rbHabilitar;
  ToolButtonDesconectarse.Enabled := rbHabilitar;

  mDomainsMain.Enabled   := rbHabilitar;
  mDNS.Enabled           := rbHabilitar;
  mPersonsMain.Enabled   := rbHabilitar;
  mHostsMain.Enabled     := rbHabilitar;
  mRegistrarMain.Enabled := rbHabilitar;
  mReports.Enabled       := rbHabilitar;
end;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Self.Caption := kTituloPrograma + ' ' + kVersionPrograma;
  Application.Title := kTituloPrograma + ' ' + kVersionPrograma;

  {// Obtener directorio donde esta el EXE
  psEXEPath := ExtractFilePath (Application.ExeName);
  if (psEXEPath [Length (psEXEPath)] <> '\') then
    psEXEPath := psEXEPath + '\'; }

  psMySQLServer   := Leer_Registry ('HostName', '');
  psMySQLDatabase := Leer_Registry ('Database', '');
  psMySQLUser     := Leer_Registry ('Login', '');
  psMySQLPass     := Leer_Registry ('Password', '');

  if (psMySQLServer = '') then
    psMySQLServer := kMySQLServer;
  if (psMySQLDatabase = '') then
    psMySQLDatabase := kMySQLDatabase;
  if (psMySQLUser = '') then
    psMySQLUser := kMySQLUser;
  if (psMySQLPass = '') then
    psMySQLPass := kMySQLPass;

  MyConnection.Connected := False;
  MyConnection.Server    := psMySQLServer;
  MyConnection.Database  := psMySQLDatabase;
  MyConnection.Username  := psMySQLUser;
  MyConnection.Password  := psMySQLPass;

  Habilitar_Todo (False);

  //mConectarseClick (nil);

  StatusBar.Panels [0].Text := 'Disconnected';

  mConfigurarServidorClick(nil);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MyConnection.Connected = True) then
    MyConnection.Disconnect;
end;

procedure TfrmMain.mSalirClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmMain.mConfigurarServidorClick(Sender: TObject);
begin
  try
    frmConfigurar := TfrmConfigurar.Create (nil);
    if (frmConfigurar.Inicializar (psMySQLServer, psMySQLDatabase, psMySQLUser, psMySQLPass) = True) then begin
      if (frmConfigurar.ShowModal = mrOk) then begin
        // Nada
      end;
    end;
  finally
    frmConfigurar.Release;
  end;
end;

procedure TfrmMain.mConectarseClick(Sender: TObject);
begin
  MyConnection.Connected := False;
  MyConnection.Server    := psMySQLServer;
  MyConnection.Database  := psMySQLDatabase;
  MyConnection.Username  := psMySQLUser;
  MyConnection.Password  := psMySQLPass;

  try
    MyConnection.Connect;
    StatusBar.Panels [0].Text := 'Connected';
    Habilitar_Todo (True);
  except
    on E: Exception do begin
      MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
      StatusBar.Panels [0].Text := 'Disconnected';
      mDesconectarseClick (nil)
    end;
  end;
end;

procedure TfrmMain.mDesconectarseClick(Sender: TObject);
begin
  if (MyConnection.Connected = True) then
    MyConnection.Disconnect;

  //if (MyConnection.Connected = False) then begin
    StatusBar.Panels [0].Text := 'Disconnected';

    //MyConnection.Server   := '';
    //MyConnection.Database := '';
    //MyConnection.Username := '';
    //MyConnection.Password := '';

    Habilitar_Todo (False);
  //end;
end;

procedure TfrmMain.mDNSServersClick(Sender: TObject);
begin
  try
    frmDNS := TfrmDNS.Create (nil);

    if (frmDNS.Inicializar = True) then begin
      if (frmDNS.ShowModal = mrOk) then begin
        // Nada
      end;
    end;
  finally
    frmDNS.Release;
  end;
end;

procedure TfrmMain.mDomainsClick(Sender: TObject);
begin
  try
    frmDominios := TfrmDominios.Create (nil);

    if (frmDominios.Inicializar = True) then begin
      if (frmDominios.ShowModal = mrOk) then begin
        // Nada
      end;
    end;
  finally
    frmDominios.Release;
  end;
end;

procedure TfrmMain.mDomainsExpirationClick(Sender: TObject);
begin
  try
    frmReporteExpiracion := TfrmReporteExpiracion.Create (nil);

    if (frmReporteExpiracion.Inicializar () = True) then begin
      if (frmReporteExpiracion.ShowModal = mrOk) then begin
        // Nada
      end;
    end;
  finally
    frmReporteExpiracion.Release;
  end;

  {try
    frmExpirationDate := TfrmExpirationDate.Create (nil);

    //if (frmExpirationDate.Inicializar = True) then begin
      if (frmExpirationDate.ShowModal = mrOk) then begin
        // Nada
      end;
    //end;
  finally
    frmExpirationDate.Release;
  end;}
end;

procedure TfrmMain.mDomainsExpiredPreviewClick(Sender: TObject);
begin
  (*try
    MyQuery.SQL.Clear;
    MyQuery.SQL.Add ('SELECT name, expire');
    MyQuery.SQL.Add ('FROM domains');
    MyQuery.SQL.Add ('WHERE expire <= ' + FloatToStr (Now ()));
    MyQuery.SQL.Add ('ORDER BY expire, name');
    MyQuery.Open;
  except
    on E: Exception do begin
      MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
      Exit;
    end;
  end;

  // Mostrar Reporte
  {try
    try
      frmRepExpirados := TfrmRepExpirados.Create (nil);
      frmRepExpirados.Inicializar ();

      frmMain.Hide;
      frmRepExpirados.QuickRep.Preview;
    except
      MessageBoxBeep (Self.Handle, 'Error, there are not enough resources', 'Error', MB_OK);
    end;
  finally
    frmRepExpirados.QuickRep.Free;
    frmRepExpirados.Release;
    frmMain.Show;
  end; }

  if (MyQuery.Active = True) then
    MyQuery.Close;*)
end;

procedure TfrmMain.mPersonsClick(Sender: TObject);
begin
  try
    frmPersons := TfrmPersons.Create (nil);

    if (frmPersons.Inicializar = True) then begin
      if (frmPersons.ShowModal = mrOk) then begin
        // Nada
      end;
    end;
  finally
    frmPersons.Release;
  end;
end;

procedure TfrmMain.mHostsClick(Sender: TObject);
begin
  try
    frmHosts := TfrmHosts.Create (nil);

    if (frmHosts.Inicializar = True) then begin
      if (frmHosts.ShowModal = mrOk) then begin
        // Nada
      end;
    end;
  finally
    frmHosts.Release;
  end;
end;

procedure TfrmMain.mRegistrarClick(Sender: TObject);
begin
  try
    frmRegistrar := TfrmRegistrar.Create (nil);

    if (frmRegistrar.Inicializar = True) then begin
      if (frmRegistrar.ShowModal = mrOk) then begin
        // Nada
      end;
    end;
  finally
    frmRegistrar.Release;
  end;
end;

end.

