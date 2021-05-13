program IDM;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uDNS in 'uDNS.pas' {frmDNS},
  uDomains in 'uDomains.pas' {frmDominios},
  uNameServer in 'uNameServer.pas' {frmElegirDNS},
  uExpirationDate in 'uExpirationDate.pas' {frmExpirationDate},
  uRepExpirationDate in 'uRepExpirationDate.pas' {frmRepExpirationDate},
  uRepExpired in 'uRepExpired.pas' {frmRepExpirados},
  uRegistrador in 'uRegistrador.pas' {frmRegistrador},
  uWebHost in 'uWebHost.pas' {frmWebHost},
  uPersonas in 'uPersonas.pas' {frmPersonas},
  uPersons in 'uPersons.pas' {frmPersons},
  uCreatePerson in 'uCreatePerson.pas' {frmCreatePerson},
  uCreateNS in 'uCreateNS.pas' {frmCreateNS},
  uCreateRegistrar in 'uCreateRegistrar.pas' {frmCreateRegistrar},
  uWindowExpirationDate in 'uWindowExpirationDate.pas' {frmWindowExpirationDate},
  uHosts in 'uHosts.pas' {frmHosts},
  uRegistrar in 'uRegistrar.pas' {frmRegistrar},
  uConfigurar in 'uConfigurar.pas' {frmConfigurar},
  uWebBrowser in 'uWebBrowser.pas' {frmWebBrowser},
  uResultsWhoIs in 'uResultsWhoIs.pas' {frmResultWhoIs},
  uReporteExpiracion in 'uReporteExpiracion.pas' {frmReporteExpiracion};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
