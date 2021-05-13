unit uCreatePerson;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, MemDS, DBAccess, MyAccess, StdCtrls, Buttons, Grids,
  DBGrids, ExtCtrls;

type
  TfrmCreatePerson = class(TForm)
    DataSource: TDataSource;
    LabelPersons: TLabel;
    DBGrid: TDBGrid;
    LabelName: TLabel;
    EditName: TEdit;
    LabelFirst: TLabel;
    EditFirst: TEdit;
    LabelLast: TLabel;
    EditLast: TEdit;
    LabelEMail: TLabel;
    EditEMail: TEdit;
    LabelPhone: TLabel;
    EditPhone: TEdit;
    LabelID: TLabel;
    EditID: TEdit;
    Bevel: TBevel;
    BitBtnCreate: TBitBtn;
    BitBtnCerrar: TBitBtn;
    MyTablePerson: TMyTable;
    MyTablePersonName: TStringField;
    MyTablePersonFirst: TStringField;
    MyTablePersonLast: TStringField;
    MyTablePersonEMail: TStringField;
    MyTablePersonPhone: TStringField;
    MyTablePersonID: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure BitBtnCreateClick(Sender: TObject);
  public
    pbCrear : Boolean;

    function Inicializar (riQuien : Integer; rbCrear : Boolean) : Boolean;
  end;

var
  frmCreatePerson: TfrmCreatePerson;

implementation

uses
  uMain, uResultsWhoIs;

{$R *.dfm}

function TfrmCreatePerson.Inicializar (riQuien : Integer; rbCrear : Boolean) : Boolean;
var
  lbSalida : Boolean;
begin
  // riQuien
  // 1 = Administrador
  // 2 = Tecnico

  if (riQuien = 1) then
    Self.Caption := 'Administrator'
  else if (riQuien = 2) then
    Self.Caption := 'Technician';

  pbCrear := rbCrear;

  if (rbCrear = True) then
    BitBtnCreate.Caption := 'Create'
  else
    BitBtnCreate.Caption := 'Update';

  lbSalida := True;

  try
    MyTablePerson.Open;
    MyTablePerson.OrderFields := 'first';
    MyTablePerson.First;
  except
    on E: Exception do begin
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
      lbSalida := False;
    end;
  end;

  if (lbSalida = True) then begin
    if (riQuien = 1) then begin
      EditName.Text   := frmResultWhoIs.EditAdminName.Text;
      EditFirst.Text  := frmResultWhoIs.EditAdminFirst.Text;
      EditLast.Text   := frmResultWhoIs.EditAdminLast.Text;
      EditEMail.Text  := frmResultWhoIs.EditAdminEMail.Text;
      EditPhone.Text  := frmResultWhoIs.EditAdminPhone.Text;
      EditID.Text     := frmResultWhoIs.EditAdminID.Text;
    end
    else if (riQuien = 2) then begin
      EditName.Text   := frmResultWhoIs.EditTecnicoName.Text;
      EditFirst.Text  := frmResultWhoIs.EditTecnicoFirst.Text;
      EditLast.Text   := frmResultWhoIs.EditTecnicoLast.Text;
      EditEMail.Text  := frmResultWhoIs.EditTecnicoEMail.Text;
      EditPhone.Text  := frmResultWhoIs.EditTecnicoPhone.Text;
      EditID.Text     := frmResultWhoIs.EditTecnicoID.Text;
    end;
  end;

  if (pbCrear = False) then begin
    // Update
    if (MyTablePerson.Locate ('id', EditID.Text, [loCaseInsensitive]) = False) then
      MyTablePerson.First;
  end;

  Result := lbSalida;
end;

procedure TfrmCreatePerson.FormCreate(Sender: TObject);
begin
  EditName.MaxLength   := MyTablePersonName.Size;
  EditFirst.MaxLength  := MyTablePersonFirst.Size;
  EditLast.MaxLength   := MyTablePersonLast.Size;
  EditEMail.MaxLength  := MyTablePersonEMail.Size;
  EditPhone.MaxLength  := MyTablePersonPhone.Size;
end;

procedure TfrmCreatePerson.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MyTablePerson.Active = True) then
    MyTablePerson.Close;
end;

procedure TfrmCreatePerson.BitBtnCerrarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmCreatePerson.BitBtnCreateClick(Sender: TObject);
begin
  try
    if (pbCrear = True) then begin
      MyTablePerson.Append;

      MyTablePersonName.Value  := AnsiString (Trim (EditName.Text));
      MyTablePersonFirst.Value := AnsiString (Trim (EditFirst.Text));
      MyTablePersonLast.Value  := AnsiString (Trim (EditLast.Text));
      MyTablePersonEMail.Value := AnsiString (Trim (EditEMail.Text));
      MyTablePersonPhone.Value := AnsiString (Trim (EditPhone.Text));

      MyTablePerson.Post;

      frmMain.MessageBoxBeep (Self.Handle, 'The register was created successfully', 'Información', MB_OK);
    end
    else begin
      if (MyTablePerson.Locate ('id', EditID.Text, [loCaseInsensitive]) = True) then begin
        MyTablePerson.Edit;

        MyTablePersonName.Value   := AnsiString (Trim (EditName.Text));
        MyTablePersonFirst.Value  := AnsiString (Trim (EditFirst.Text));
        MyTablePersonLast.Value   := AnsiString (Trim (EditLast.Text));
        MyTablePersonEMail.Value  := AnsiString (Trim (EditEMail.Text));
        MyTablePersonPhone.Value  := AnsiString (Trim (EditPhone.Text));

        MyTablePerson.Post;

        frmMain.MessageBoxBeep (Self.Handle, 'The register was updated successfully', 'Información', MB_OK);
      end
      else
        frmMain.MessageBoxBeep (Self.Handle, 'Error, record not found', 'Error', MB_OK);
    end;

    // Cerrar esta ventana
    Self.ModalResult := mrOK;
  except
    MyTablePerson.Cancel;

    if (pbCrear = True) then
      frmMain.MessageBoxBeep (Self.Handle, 'Error when trying to create a register', 'Error', MB_OK)
    else
      frmMain.MessageBoxBeep (Self.Handle, 'Error when trying to update a register', 'Error', MB_OK);
  end;
end;

end.

