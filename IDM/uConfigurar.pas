unit uConfigurar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmConfigurar = class(TForm)      
    LabelNombreDelServidor: TLabel;
    EditNombreDelServidor: TEdit;         
    LabelDatabase: TLabel;
    EditDatabase: TEdit;
    LabelLogin: TLabel;
    EditLogin: TEdit;
    Label1: TLabel;
    EditPassword: TEdit;
    BitBtnConfigurar: TBitBtn;
    BitBtnSalir: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtnConfigurarClick(Sender: TObject);
  public
    function Inicializar (rsNombreDelServidor, rsDatabase, rsLogin, rsPassword : string) : Boolean;
  end;

var
  frmConfigurar: TfrmConfigurar;

implementation

uses
  Registry, uMain;

{$R *.DFM}

function TfrmConfigurar.Inicializar (rsNombreDelServidor, rsDatabase, rsLogin, rsPassword : string) : Boolean;
begin
  EditNombreDelServidor.Text := rsNombreDelServidor;
  EditDatabase.Text := rsDatabase;
  EditLogin.Text := rsLogin;
  EditPassword.Text := rsPassword;

  Result := True;
end;

procedure TfrmConfigurar.FormCreate(Sender: TObject);
begin
  EditNombreDelServidor.MaxLength := 100;
  EditDatabase.MaxLength := 30;
  EditLogin.MaxLength := 30;
  EditPassword.MaxLength := 30;
end;

procedure TfrmConfigurar.BitBtnConfigurarClick(Sender: TObject);
var
  lsServidor, lsDatabase, lsLogin, lsPassword : string;
begin
  lsServidor := Trim (EditNombreDelServidor.Text);
  lsDatabase := Trim (EditDatabase.Text);
  lsLogin := Trim (EditLogin.Text);
  lsPassword := Trim (EditPassword.Text);

  if (Length (lsServidor) = 0) or (Length (lsDatabase) = 0) or (Length (lsLogin) = 0) then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, please fill all fields', 'Error', MB_OK);
  end
  else begin
    frmMain.Grabar_Registry ('HostName', lsServidor);
    frmMain.Grabar_Registry ('Database', lsDatabase);
    frmMain.Grabar_Registry ('Login', lsLogin);
    frmMain.Grabar_Registry ('Password', lsPassword);

    //frmMain.psMySQLServer   := lsServidor;
    //frmMain.psMySQLDatabase := lsDatabase;
    //frmMain.psMySQLUser     := lsLogin;
    //frmMain.psMySQLPass     := lsPassword;

    Self.ModalResult := mrOK;
  end;
end;

end.

