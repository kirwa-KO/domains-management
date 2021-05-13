unit uResultsWhoIs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, MemDS, DBAccess, MyAccess, StdCtrls, Buttons;

type
  TfrmResultWhoIs = class(TForm)
    GroupBoxAdmin: TGroupBox;
    LabelAdminID: TLabel;
    EditAdminID: TEdit;
    LabelAdminFirst: TLabel;
    LabelAdminLast: TLabel;
    EditAdminLast: TEdit;
    LabelAdminEMail: TLabel;
    EditAdminEMail: TEdit;
    LabelAdminName: TLabel;
    EditAdminName: TEdit;
    LabelAdminPhone: TLabel;
    EditAdminPhone: TEdit;
    LabelAdminEstado: TLabel;
    BitBtnAdminCreateUpdate: TBitBtn;
    EditAdminFirst: TEdit;
    GroupBoxTecnico: TGroupBox;
    LabelTecnicoFirst: TLabel;
    LabelTecnicoLast: TLabel;
    LabelTecnicoEMail: TLabel;
    LabelTecnicoName: TLabel;
    LabelTecnicoPhone: TLabel;
    LabelTecnicoID: TLabel;
    LabelTecnicoEstado: TLabel;
    EditTecnicoFirst: TEdit;
    EditTecnicoLast: TEdit;
    EditTecnicoEMail: TEdit;
    EditTecnicoName: TEdit;
    EditTecnicoPhone: TEdit;
    BitBtnTecnicoCreateUpdate: TBitBtn;
    EditTecnicoID: TEdit;
    GroupBoxRegistrador: TGroupBox;
    EditRegistrador: TEdit;
    BitBtnRegistradorCreate: TBitBtn;
    LabelRegistradorEstado: TLabel;
    GroupBoxExpire: TGroupBox;
    EditExpire: TEdit;
    LabelExpireEstado: TLabel;
    GroupBoxNS: TGroupBox;
    LabelNS1: TLabel;
    EditNS1: TEdit;
    EditNSIP1: TEdit;
    LabelNS2: TLabel;
    EditNS2: TEdit;
    EditNSIP2: TEdit;
    LabelNS3: TLabel;
    EditNS3: TEdit;
    EditNSIP3: TEdit;
    LabelNS4: TLabel;
    EditNS4: TEdit;
    EditNSIP4: TEdit;
    BitBtnNS1Create: TBitBtn;
    BitBtnNS2Create: TBitBtn;
    BitBtnNS3Create: TBitBtn;
    BitBtnNS4Create: TBitBtn;
    BitBtnCopy: TBitBtn;
    BitBtnClose: TBitBtn;
    MyQuery: TMyQuery;
    procedure BitBtnCloseClick(Sender: TObject);
    procedure BitBtnCopyClick(Sender: TObject);
    procedure BitBtnAdminCreateUpdateClick(Sender: TObject);
    procedure BitBtnNS1CreateClick(Sender: TObject);
    procedure BitBtnRegistradorCreateClick(Sender: TObject);
  private
    function Query_Person (rsName, rsFirst, rsLast, rsEmail : string) : Integer;

    procedure Poner_Caption (raLabel : TLabel; rsCaption : string; riColor : Integer);
    procedure Query_NS_Servers (raBitBtn : TBitBtn; riIndiceNS : Integer);
  public
    psIDRegistrar : string;
    paIDNS : array [0..3] of string;

    function Inicializar : Boolean;
  end;

var
  frmResultWhoIs: TfrmResultWhoIs;

implementation

uses
  uMain, uDomains, uCreatePerson, uCreateNS, uCreateRegistrar;

{$R *.dfm}

function TfrmResultWhoIs.Inicializar : Boolean;
var
  lnI, liTemp, liDias : Integer;
begin
  // Administrador
  try
    liTemp := Query_Person (frmDominios.psAdminName, frmDominios.psAdminFirst, frmDominios.psAdminLast, frmDominios.psAdminEMail);
    if (liTemp <> -1) then
      EditAdminID.Text := IntToStr (liTemp)
    else
      EditAdminID.Text := frmDominios.psAdminID;  // Se ocupa ???

    EditAdminFirst.Text := frmDominios.psAdminFirst;
    EditAdminLast.Text  := frmDominios.psAdminLast;
    EditAdminEMail.Text := frmDominios.psAdminEMail;
    EditAdminName.Text  := frmDominios.psAdminName;
    EditAdminPhone.Text := frmDominios.psAdminPhone;

    if (MyQuery.RecordCount = 0) then begin
      Poner_Caption (LabelAdminEstado, 'The register doesn''t exist', clRed);
      BitBtnAdminCreateUpdate.Caption := 'Create';
      BitBtnAdminCreateUpdate.Left := LabelAdminEstado.Left + LabelAdminEstado.Width + 16;
      BitBtnAdminCreateUpdate.Visible := True;
    end
    else begin
      if (UpperCase (MyQuery.FieldByName ('last').AsString) <> UpperCase (frmDominios.psAdminLast)) or
         (UpperCase (MyQuery.FieldByName ('first').AsString) <> UpperCase (frmDominios.psAdminFirst)) or
         (UpperCase (MyQuery.FieldByName ('email').AsString) <> UpperCase (frmDominios.psAdminEMail)) or
         (UpperCase (MyQuery.FieldByName ('name').AsString) <> UpperCase (frmDominios.psAdminName)) or
         (UpperCase (MyQuery.FieldByName ('phone').AsString) <> UpperCase (frmDominios.psAdminPhone)) then
      begin
        Poner_Caption (LabelAdminEstado, 'The register exists but the values don''t match', clRed);
        BitBtnAdminCreateUpdate.Caption := 'Update';
        BitBtnAdminCreateUpdate.Left := LabelAdminEstado.Left + LabelAdminEstado.Width + 16;
        BitBtnAdminCreateUpdate.Visible := True;
      end
      else begin
        Poner_Caption (LabelAdminEstado, 'This register already exists', clBlue);
        BitBtnAdminCreateUpdate.Visible := False;
      end;
    end;
  except
    on E: Exception do begin
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
      Result := False;
      Exit;
    end;
  end;

  if (MyQuery.Active = True) then
    MyQuery.Close;



  // Tecnico
  try
    liTemp := Query_Person (frmDominios.psTecnicoName, frmDominios.psTecnicoFirst, frmDominios.psTecnicoLast, frmDominios.psTecnicoEMail);
    if (liTemp <> -1) then
      EditTecnicoID.Text := IntToStr (liTemp)
    else
      EditTecnicoID.Text := frmDominios.psTecnicoID;  // Se ocupa ???

    EditTecnicoFirst.Text := frmDominios.psTecnicoFirst;
    EditTecnicoLast.Text  := frmDominios.psTecnicoLast;
    EditTecnicoEMail.Text := frmDominios.psTecnicoEMail;
    EditTecnicoName.Text  := frmDominios.psTecnicoName;
    EditTecnicoPhone.Text := frmDominios.psTecnicoPhone;

    if (MyQuery.RecordCount = 0) then begin
      Poner_Caption (LabelTecnicoEstado, 'The register doesn''t exist', clRed);
      BitBtnTecnicoCreateUpdate.Caption := 'Create';
      BitBtnTecnicoCreateUpdate.Left := LabelTecnicoEstado.Left + LabelTecnicoEstado.Width + 16;
      BitBtnTecnicoCreateUpdate.Visible := True;
    end
    else begin
      if (UpperCase (MyQuery.FieldByName ('last').AsString) <> UpperCase (frmDominios.psTecnicoLast)) or
         (UpperCase (MyQuery.FieldByName ('first').AsString) <> UpperCase (frmDominios.psTecnicoFirst)) or
         (UpperCase (MyQuery.FieldByName ('email').AsString) <> UpperCase (frmDominios.psTecnicoEMail)) or
         (UpperCase (MyQuery.FieldByName ('name').AsString) <> UpperCase (frmDominios.psTecnicoName)) or
         (UpperCase (MyQuery.FieldByName ('phone').AsString) <> UpperCase (frmDominios.psTecnicoPhone)) then
      begin
        Poner_Caption (LabelTecnicoEstado, 'The register exists but the values don''t match', clRed);
        BitBtnTecnicoCreateUpdate.Caption := 'Update';
        BitBtnTecnicoCreateUpdate.Left := LabelTecnicoEstado.Left + LabelTecnicoEstado.Width + 16;
        BitBtnTecnicoCreateUpdate.Visible := True;
      end
      else begin
        Poner_Caption (LabelTecnicoEstado, 'This register already exists', clBlue);
        BitBtnTecnicoCreateUpdate.Visible := False;
      end;
    end;
  except
    on E: Exception do begin
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
      Result := False;
      Exit;
    end;
  end;

  if (MyQuery.Active = True) then
    MyQuery.Close;


  // NS Servers
  for lnI := 0 to 3 do
    paIDNS [lnI] := '';

  // NS 1
  EditNS1.Text := frmDominios.paNS [0];
  EditNSIP1.Text := frmDominios.paNSIP [0];
  BitBtnNS1Create.Enabled := (frmDominios.paNS [0] <> '');

  if (Length (frmDominios.paNS [0]) > 0) then begin
    try
      Query_NS_Servers (BitBtnNS1Create, 0);
    except
      on E: Exception do begin
        frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        Result := False;
        Exit;
      end;
    end;

    if (MyQuery.Active = True) then
      MyQuery.Close;
  end;

  // NS 2
  EditNS2.Text := frmDominios.paNS [1];
  EditNSIP2.Text := frmDominios.paNSIP [1];
  BitBtnNS2Create.Enabled := (frmDominios.paNS [1] <> '');

  if (Length (frmDominios.paNS [1]) > 0) then begin
    try
      Query_NS_Servers (BitBtnNS2Create, 1);
    except
      on E: Exception do begin
        frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        Result := False;
        Exit;
      end;
    end;

    if (MyQuery.Active = True) then
      MyQuery.Close;
  end;

  // NS 3
  EditNS3.Text := frmDominios.paNS [2];
  EditNSIP3.Text := frmDominios.paNSIP [2];
  BitBtnNS3Create.Enabled := (frmDominios.paNS [2] <> '');

  if (Length (frmDominios.paNS [2]) > 0) then begin
    try
      Query_NS_Servers (BitBtnNS3Create, 2);
    except
      on E: Exception do begin
        frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        Result := False;
        Exit;
      end;
    end;

    if (MyQuery.Active = True) then
      MyQuery.Close;
  end;

  // NS 4
  EditNS4.Text := frmDominios.paNS [3];
  EditNSIP4.Text := frmDominios.paNSIP [3];
  BitBtnNS4Create.Enabled := (frmDominios.paNS [3] <> '');

  if (Length (frmDominios.paNS [3]) > 0) then begin
    try
      Query_NS_Servers (BitBtnNS4Create, 3);
    except
      on E: Exception do begin
        frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        Result := False;
        Exit;
      end;
    end;

    if (MyQuery.Active = True) then
      MyQuery.Close;
  end;


  // Registrar
  if (frmDominios.psRegistrar = '') then begin
    psIDRegistrar := '';
    LabelRegistradorEstado.Visible := False;
    BitBtnRegistradorCreate.Visible := False;
  end
  else begin
    try
      MyQuery.SQL.Clear;
      MyQuery.SQL.Add ('SELECT *');
      MyQuery.SQL.Add ('FROM registrar');
      MyQuery.SQL.Add ('WHERE name = ''' + frmMain.Apostrofe_1_a_2 (frmDominios.psRegistrar) + '''');
      MyQuery.Open;

      EditRegistrador.Text := frmDominios.psRegistrar;

      if (MyQuery.RecordCount = 0) then begin
        psIDRegistrar := '';
        Poner_Caption (LabelRegistradorEstado, 'The register doesn''t exist', clRed);
        BitBtnRegistradorCreate.Caption := 'Create';
        BitBtnRegistradorCreate.Left := LabelRegistradorEstado.Left + LabelRegistradorEstado.Width + 16;
        BitBtnRegistradorCreate.Visible := True;
      end
      else begin
        psIDRegistrar := MyQuery.FieldByName ('id').AsString;
        Poner_Caption (LabelRegistradorEstado, 'This register already exists', clBlue);
        BitBtnRegistradorCreate.Visible := False;
      end;
    except
      on E: Exception do begin
        frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        Result := False;
        Exit;
      end;
    end;

    if (MyQuery.Active = True) then
      MyQuery.Close;
  end;


  // Expire
  if (frmDominios.pdExpire <> Trunc (frmDominios.DateTimePickerExpira.Date)) then
    EditExpire.Font.Color := clBlue
  else
    EditExpire.Font.Color := clBlack;

  if (frmDominios.pdExpire <> 0) then begin
    try
      //EditExpire.Text := DateToStr (frmDominios.pdExpire);
      EditExpire.Text := frmMain.Formatear_Solo_Fecha (frmDominios.pdExpire, True);

      liDias := Trunc (frmDominios.pdExpire - Date ());

      if (liDias > 0) then
        Poner_Caption (LabelExpireEstado, 'expire in ' + IntToStr (liDias) + ' days', clBlue)
      else
        Poner_Caption (LabelExpireEstado, 'expired ' + IntToStr (Abs (liDias)) + ' days ago', clRed);
    except
      // Nada
    end;
  end
  else
    Poner_Caption (LabelExpireEstado, 'Unknown', clRed);


  Result := True;
end;

function TfrmResultWhoIs.Query_Person (rsName, rsFirst, rsLast, rsEmail : string) : Integer;
begin
  // La llamada a este procedure tiene que estar dentro de un try
  MyQuery.SQL.Text :=
    'SELECT * ' +
    'FROM person ' +
    'WHERE name = ''' + frmMain.Apostrofe_1_a_2 (rsName) + ''' ' +
    'AND first = ''' + frmMain.Apostrofe_1_a_2 (rsFirst) + ''' ' +
    'AND last = ''' + frmMain.Apostrofe_1_a_2 (rsLast) + ''' ' +
    'AND email = ''' + frmMain.Apostrofe_1_a_2 (rsEmail) + ''' ';
  MyQuery.Open;

  if (MyQuery.RecordCount > 0) then
    Result := MyQuery.FieldByName ('id').AsInteger
  else
    Result := -1;
end;

{procedure TfrmResultWhoIs.Query_Person (rsID : string);
begin
  // La llamada a este procedure tiene que estar dentro de un try
  if (rsID = '') then
    rsID := '-1';

  MyQuery.SQL.Text :=
    'SELECT * ' +
    'FROM person ' +
    'WHERE id = ' + rsID;
  MyQuery.Open;
end;}

procedure TfrmResultWhoIs.Query_NS_Servers (raBitBtn : TBitBtn; riIndiceNS : Integer);
begin
  // La llamada a este procedure tiene que estar dentro de un try
  MyQuery.SQL.Clear;
  MyQuery.SQL.Add ('SELECT *');
  MyQuery.SQL.Add ('FROM nservers');
  MyQuery.SQL.Add ('WHERE host = ''' + frmMain.Apostrofe_1_a_2 (frmDominios.paNS [riIndiceNS]) + '''');
  MyQuery.SQL.Add ('AND ip = ''' + frmMain.Apostrofe_1_a_2 (frmDominios.paNSIP [riIndiceNS]) + '''');
  MyQuery.Open;

  if (MyQuery.RecordCount = 0) then
    raBitBtn.Enabled := True
  else begin
    raBitBtn.Enabled := False;
    paIDNS [riIndiceNS] := MyQuery.FieldByName ('id').AsString;
  end;
end;

procedure TfrmResultWhoIs.Poner_Caption (raLabel : TLabel; rsCaption : string; riColor : Integer);
begin
  raLabel.Font.Color := riColor;
  raLabel.Caption := rsCaption;
end;

procedure TfrmResultWhoIs.BitBtnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmResultWhoIs.BitBtnCopyClick(Sender: TObject);
begin
  {if (BitBtnAdminCreateUpdate.Visible = True) or
     (BitBtnTecnicoCreateUpdate.Visible = True) or
     (BitBtnNS1Create.Enabled = True) or
     (BitBtnNS2Create.Enabled = True) or
     (BitBtnNS3Create.Enabled = True) or
     (BitBtnNS4Create.Enabled = True) or
     (BitBtnRegistradorCreate.Visible = True) then
  begin
    if (MessageDlg ('You have not updated/created some register' + #13 + #10 +
                    'Do you want to copy this info?', mtConfirmation, mbOKCancel, 0) = mrOK)
    then
      Self.ModalResult := mrOK;
  end
  else}
    Self.ModalResult := mrOK;
end;

procedure TfrmResultWhoIs.BitBtnAdminCreateUpdateClick(Sender: TObject);
var
  liQuien : Integer;
  lbCrear : Boolean;
begin
  try
    frmCreatePerson := TfrmCreatePerson.Create (nil);

    if (Sender = BitBtnAdminCreateUpdate) then
      liQuien := 1
    else
      liQuien := 2;

    if (Pos ('Create', TBitBtn (Sender).Caption) > 0) then
      lbCrear := True
    else
      lbCrear := False;

    if (frmCreatePerson.Inicializar (liQuien, lbCrear) = True) then begin
      if (frmCreatePerson.ShowModal = mrOk) then begin
        Inicializar ();
      end;
    end;
  finally
    frmCreatePerson.Release;
  end;
end;

procedure TfrmResultWhoIs.BitBtnNS1CreateClick(Sender: TObject);
var
  liQuien : Integer;
begin
  try
    frmCreateNS := TfrmCreateNS.Create (nil);

    if (Sender = BitBtnNS1Create) then
      liQuien := 1
    else if (Sender = BitBtnNS2Create) then
      liQuien := 2
    else if (Sender = BitBtnNS3Create) then
      liQuien := 3
    else
      liQuien := 4;

    if (frmCreateNS.Inicializar (liQuien) = True) then begin
      if (frmCreateNS.ShowModal = mrOk) then begin
        Inicializar ();
      end;
    end;
  finally
    frmCreateNS.Release;
  end;
end;

procedure TfrmResultWhoIs.BitBtnRegistradorCreateClick(Sender: TObject);
begin
  try
    frmCreateRegistrar := TfrmCreateRegistrar.Create (nil);

    if (frmCreateRegistrar.Inicializar = True) then begin
      if (frmCreateRegistrar.ShowModal = mrOk) then begin
        Inicializar ();
      end;
    end;
  finally
    frmCreateRegistrar.Release;
  end;
end;

end.

