// No Usado

unit uWebBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw;

type
  TfrmWebBrowser = class(TForm)
    //WebBrowser: TWebBrowser;
  public
    function Inicializar (rsURL : string) : Boolean;
  end;

var
  frmWebBrowser: TfrmWebBrowser;

implementation

uses
  uMain;

{$R *.dfm}

function TfrmWebBrowser.Inicializar (rsURL : string) : Boolean;
begin
  Self.Caption := rsURL;

  try
    //frmWebBrowser.WebBrowser.Navigate (rsURL);
    Result := True;
  except
    on E: Exception do begin
      frmMain.MessageBoxBeep (Self.Handle, 'Address: ' + rsURL + ' - ' + E.Message, 'Error', MB_OK);
      Result := False;
    end;
  end;
end;

end.

