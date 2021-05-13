// No Usado

unit uExpirationDate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DB, MemDS, DBAccess, MyAccess, Buttons;

const
  kDiasExpiracion : array [0..8] of Integer = (
    7,      // 1 week
    14,     // 2 weeks
    21,     // 3 weeks
    30,     // 1 month (30 days)
    60,     // 2 months (60 days)
    90,     // 3 months (90 days)
    180,    // 6 months (180 days)
    365,    // 1 year
    36500   // All
  );

  kLeyendasExpiracion : array [0..8] of string = (
    '1 week',
    '2 weeks',
    '3 weeks',
    '1 month (30 days)',
    '2 months (60 days)',
    '3 months (90 days)',
    '6 months (180 days)',
    '1 year',
    'All'
  );

type
  TfrmExpirationDate = class(TForm)
    LabelShow: TLabel;
    ComboBoxTiempo: TComboBox;
    BitBtnRenovar: TBitBtn;
    BitBtnCerrar: TBitBtn;
    BitBtnPreview: TBitBtn;
    MyQuery: TMyQuery;
    MyQueryName: TStringField;
    MyQueryRegistrar: TStringField;
    MyQueryExpire: TFloatField;
    MyQueryFechaLimite: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure MyQueryCalcFields(DataSet: TDataSet);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure BitBtnPreviewClick(Sender: TObject);
  end;

var
  frmExpirationDate: TfrmExpirationDate;

implementation

uses
  uMain, uRepExpirationDate, uWindowExpirationDate;

{$R *.DFM}

procedure TfrmExpirationDate.FormCreate(Sender: TObject);
var
  lnI : Integer;
begin
  for lnI := 0 to High (kLeyendasExpiracion) do
    ComboBoxTiempo.Items.Add (kLeyendasExpiracion [lnI]);

  ComboBoxTiempo.ItemIndex := 0;
end;

procedure TfrmExpirationDate.BitBtnCerrarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmExpirationDate.MyQueryCalcFields(DataSet: TDataSet);
var
  liDia : Integer;
begin
  liDia := DayOfWeek (MyQueryExpire.Value);

  MyQueryFechaLimite.Value := AnsiString (DateToStr (MyQueryExpire.Value) + ', ' + kDias [liDia]);
end;

procedure TfrmExpirationDate.BitBtnPreviewClick(Sender: TObject);
var
  ldFechaInicio, ldFechaFin : Double;
begin
  if (ComboBoxTiempo.ItemIndex < 0) then
    Beep
  else begin
    ldFechaInicio := Trunc (Now ());
    ldFechaFin := Trunc (Now () + kDiasExpiracion [ComboBoxTiempo.ItemIndex]);

    try
      MyQuery.SQL.Clear;
      MyQuery.SQL.Add ('SELECT *');
      MyQuery.SQL.Add ('FROM domains');
      MyQuery.SQL.Add ('WHERE expire BETWEEN ' + FloatToStr (ldFechaInicio) + ' AND ' + FloatToStr (ldFechaFin));
      MyQuery.SQL.Add ('ORDER BY expire, name');
      MyQuery.Open;
    except
      on E: Exception do begin
        frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
        Exit;
      end;
    end;


    if (Sender = BitBtnPreview) then begin
      // Preview
      {try
        try
          frmRepExpirationDate := TfrmRepExpirationDate.Create (nil);
          frmRepExpirationDate.Inicializar (ComboBoxTiempo.ItemIndex);

          frmExpirationDate.Hide;
          frmRepExpirationDate.QuickRep.Preview;
        except
          frmMain.ErrorOInfo ('Error, there are not enough resources', 0);
        end;
      finally
        frmRepExpirationDate.QuickRep.Free;
        frmRepExpirationDate.Release;
        frmExpirationDate.Show;
      end; }
    end
    else begin
      if (MyQuery.RecordCount = 0) then
        frmMain.MessageBoxBeep (Self.Handle, 'There are not domains to renew', 'Información', MB_OK)
      else begin
        // Renew
        try
          frmWindowExpirationDate := TfrmWindowExpirationDate.Create (nil);

          //if (frmWindowExpirationDate.Inicializar = True) then begin
            if (frmWindowExpirationDate.ShowModal = mrOk) then begin
              // Nada
            end;
          //end;
        finally
          frmWindowExpirationDate.Release;
        end;
      end;
    end;


    if (MyQuery.Active = True) then
      MyQuery.Close;
  end;
end;

end.

