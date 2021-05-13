// No Usado

unit uRepExpirationDate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {Qrctrls, QuickRpt,} ExtCtrls;

type
  TfrmRepExpirationDate = class(TForm)
  public
    procedure Inicializar (riComboBox : Integer);
  end;

var
  frmRepExpirationDate: TfrmRepExpirationDate;

implementation

{$R *.DFM}

uses
  uExpirationDate;

procedure TfrmRepExpirationDate.Inicializar (riComboBox : Integer);
begin
  {QRLabelTituloFecha.Caption := DateToStr (Now ());

  QRLabelTitulo.Caption := 'Domains Expiration: ' + kLeyendasExpiracion [riComboBox];

  if (frmExpirationDate.MyQuery.RecordCount = 0) then begin
    QRDBTextName.Enabled := False;
    QRDBTextFechaLimite.Enabled := False;
    QRLabelNoResultado.Enabled := True;
    QRLabelNoResultado.Left := 8;
    QRLabelNoResultado.Caption := '0 Results';
  end; }
end;

end.

