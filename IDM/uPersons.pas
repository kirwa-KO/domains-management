unit uPersons;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, MemDS, DBAccess, MyAccess, StdCtrls, Buttons, Grids,
  DBGrids, ExtCtrls;

type
  TfrmPersons = class(TForm)
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
    BitBtnNuevo: TBitBtn;
    BitBtnBorrar: TBitBtn;
    BitBtnModificar: TBitBtn;
    BitBtnCerrar: TBitBtn;
    MyTablePerson: TMyTable;
    MyTablePersonID: TIntegerField;
    MyTablePersonName: TStringField;
    MyTablePersonFirst: TStringField;
    MyTablePersonLast: TStringField;
    MyTablePersonEMail: TStringField;
    MyTablePersonPhone: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure BitBtnModificarClick(Sender: TObject);
    procedure BitBtnNuevoClick(Sender: TObject);
    procedure BitBtnBorrarClick(Sender: TObject);
    procedure MyTablePersonAfterScroll(DataSet: TDataSet);
  private
    pbNuevo : Boolean;

    function Validar_Datos : Boolean;
    procedure Cargar_Valores;
    procedure Cambiar_Estado_Nuevo;
  public
    function Inicializar : Boolean;
  end;

var
  frmPersons: TfrmPersons;

implementation

uses
  uMain;

{$R *.dfm}

function TfrmPersons.Inicializar : Boolean;
var
  lbSalida : Boolean;
begin
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

  if (lbSalida = True) then
    Cargar_Valores ();

  Result := lbSalida;
end;

procedure TfrmPersons.Cambiar_Estado_Nuevo;
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

procedure TfrmPersons.Cargar_Valores;
begin
  EditID.Text     := MyTablePersonID.AsString;
  EditName.Text   := MyTablePersonName.AsString;
  EditFirst.Text  := MyTablePersonFirst.AsString;
  EditLast.Text   := MyTablePersonLast.AsString;
  EditEMail.Text  := MyTablePersonEMail.AsString;
  EditPhone.Text  := MyTablePersonPhone.AsString;
end;

procedure TfrmPersons.FormCreate(Sender: TObject);
begin
  pbNuevo := False;

  EditName.MaxLength   := MyTablePersonName.Size;
  EditFirst.MaxLength  := MyTablePersonFirst.Size;
  EditLast.MaxLength   := MyTablePersonLast.Size;
  EditEMail.MaxLength  := MyTablePersonEMail.Size;
  EditPhone.MaxLength  := MyTablePersonPhone.Size;
end;

procedure TfrmPersons.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MyTablePerson.Active = True) then
    MyTablePerson.Close;
end;

procedure TfrmPersons.BitBtnCerrarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmPersons.MyTablePersonAfterScroll(DataSet: TDataSet);
begin
  if (pbNuevo = True) then
    Cambiar_Estado_Nuevo ();

  Cargar_Valores ();
end;

function TfrmPersons.Validar_Datos : Boolean;
//var
//  lsHandle : string;
begin
  {// Handle
  lsHandle := Trim (EditHandle.Text);
  if (lsHandle = '') then begin
    frmMain.MessageBoxBeep (Self.Handle, 'Error, empty field: ' + LabelHandle.Caption, 'Error', MB_OK);
    Result := False;
    Exit;
  end; }

  Result := True;
end;

procedure TfrmPersons.BitBtnModificarClick(Sender: TObject);
begin
  if (Validar_Datos () = True) then begin
    if (MessageDlg ('The current register will be modified. Are you sure?', mtConfirmation, mbOKCancel, 0) = mrOK) then begin
      try
        MyTablePerson.Edit;

        MyTablePersonName.Value   := AnsiString (Trim (EditName.Text));
        MyTablePersonFirst.Value  := AnsiString (Trim (EditFirst.Text));
        MyTablePersonLast.Value   := AnsiString (Trim (EditLast.Text));
        MyTablePersonEMail.Value  := AnsiString (Trim (EditEMail.Text));
        MyTablePersonPhone.Value  := AnsiString (Trim (EditPhone.Text));

        MyTablePerson.Post;

        //frmMain.MessageBoxBeep (Self.Handle, 'The register was modified successfully', 'Información', MB_OK);
      except
        on E: Exception do begin
          frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        end;
      end;
    end;
  end;
end;

procedure TfrmPersons.BitBtnNuevoClick(Sender: TObject);
begin
  if (pbNuevo = False) then begin
    try
      MyTablePerson.Append;

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
    if (Validar_Datos = True) then begin
      try
        MyTablePersonName.Value   := AnsiString (Trim (EditName.Text));
        MyTablePersonFirst.Value  := AnsiString (Trim (EditFirst.Text));
        MyTablePersonLast.Value   := AnsiString (Trim (EditLast.Text));
        MyTablePersonEMail.Value  := AnsiString (Trim (EditEMail.Text));
        MyTablePersonPhone.Value  := AnsiString (Trim (EditPhone.Text));

        MyTablePerson.Post;

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

procedure TfrmPersons.BitBtnBorrarClick(Sender: TObject);
begin
  if (pbNuevo = True) then begin
    // Se hizo un 'Append' (Opcion Cancel)
    try
      MyTablePerson.Cancel;
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
        MyTablePerson.Delete;
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

