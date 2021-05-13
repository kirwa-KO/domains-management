unit uReporteExpiracion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TfrmReporteExpiracion = class(TForm)
    PanelAbajo: TPanel;
    ListView: TListView;
    BitBtnClose: TBitBtn;
  public
    function Inicializar : Boolean;
  end;

var
  frmReporteExpiracion: TfrmReporteExpiracion;

implementation

uses
  uMain;

{$R *.dfm}

function TfrmReporteExpiracion.Inicializar : Boolean;
var
  lnI, liRecordCount : Integer;
  lsName : string;
  lbSalida : Boolean;
  ldExpire : Double;
  lListItem : TListItem;
begin
  lbSalida := True;

  try
    frmMain.MyQuery.SQL.Text :=
      'SELECT * ' +
      'FROM domains ' +
      'ORDER BY expire ';
    frmMain.MyQuery.Open;

    liRecordCount := frmMain.MyQuery.RecordCount;

    for lnI := 0 to liRecordCount-1 do begin
      lsName   := frmMain.MyQuery.FieldByName ('name').AsString;
      ldExpire := frmMain.MyQuery.FieldByName ('expire').AsFloat;

      lListItem := ListView.Items.Add;
      lListItem.Caption := lsName;
      lListItem.SubItems.Add (frmMain.Formatear_Solo_Fecha (ldExpire, True));

      if (ldExpire < Now ()) then
        lListItem.SubItems.Add ('YES')
      else
        lListItem.SubItems.Add ('NO');

      frmMain.MyQuery.Next;
    end;

    if (frmMain.MyQuery.Active = True) then
      frmMain.MyQuery.Close;
  except
    on E: Exception do begin
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
      lbSalida := False;
    end;
  end;

  Result := lbSalida;
end;

end.
