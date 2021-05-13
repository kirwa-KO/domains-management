// No Usado

unit uRepExpired;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls{, QuickRpt, Qrctrls};

type
  TfrmRepExpirados = class(TForm)
  public
    procedure Inicializar;
  end;

var
  frmRepExpirados: TfrmRepExpirados;

implementation

uses
  uMain;

{$R *.DFM}

procedure TfrmRepExpirados.Inicializar;
begin
  {QRLabelTituloFecha.Caption := DateToStr (Now ());

  if (frmMain.MyQuery.RecordCount = 0) then begin
    QRDBTextName.Enabled := False;
    QRDBTextFechaLimite.Enabled := False;
    QRLabelNoResultado.Enabled := True;
    QRLabelNoResultado.Left := 8;
    QRLabelNoResultado.Caption := '0 Results';
  end; }
end;

end.

