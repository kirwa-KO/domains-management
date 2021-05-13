// No Usado

unit uWindowExpirationDate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellAPI, DB, MemDS, DBAccess, MyAccess, StdCtrls, Buttons,
  Grids, DBGrids;

type
  TfrmWindowExpirationDate = class(TForm)
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    LabelDominios: TLabel;
    BitBtnRenovar: TBitBtn;
    BitBtnCerrar: TBitBtn;
    MyQuery: TMyQuery;
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure BitBtnRenovarClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
  end;

var
  frmWindowExpirationDate: TfrmWindowExpirationDate;

implementation

uses
  uMain, uExpirationDate;

{$R *.dfm}

procedure TfrmWindowExpirationDate.BitBtnCerrarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmWindowExpirationDate.DBGridDblClick(Sender: TObject);
begin
  BitBtnRenovarClick (nil);
end;

procedure TfrmWindowExpirationDate.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    BitBtnRenovarClick (nil);
end;

procedure TfrmWindowExpirationDate.BitBtnRenovarClick(Sender: TObject);
var
  liSalida : Integer;
  lsURL, lsHandleRegistrar : string;
begin
  lsHandleRegistrar := frmExpirationDate.MyQueryRegistrar.AsString;

  try
    MyQuery.SQL.Clear;
    MyQuery.SQL.Add ('SELECT *');
    MyQuery.SQL.Add ('FROM registrar');
    MyQuery.SQL.Add ('WHERE handle = ''' + frmMain.Apostrofe_1_a_2 (lsHandleRegistrar) + '''');
    MyQuery.Open;

    if (MyQuery.RecordCount = 1) then begin
      lsURL := MyQuery.FieldByName ('url').AsString;

      liSalida := ShellExecute (Self.Handle, 'open', PChar (lsURL), nil, nil, SW_SHOWMAXIMIZED);

      if (liSalida <= 32) then
        Application.MessageBox('Couldn''t execute the application', PChar ('Error ' + IntToStr (liSalida)), MB_ICONEXCLAMATION);

      {try
        frmWebBrowser := TfrmWebBrowser.Create (nil);

        if (frmWebBrowser.Inicializar (ZMySqlQuery.FieldByName ('url').AsString) = True) then begin
          if (frmWebBrowser.ShowModal = mrOk) then begin
            // Nada
          end;
        end;
      finally
        frmWebBrowser.Release;
      end; }
    end
    else
      frmMain.MessageBoxBeep (Self.Handle, 'Error, the registrar doesn''t exist for that domain', 'Error', MB_OK);
  except
    on E: Exception do begin
      frmMain.MessageBoxBeep (Self.Handle, E.Message, 'Error', MB_OK);
    end;
  end;

  if (MyQuery.Active = True) then
    MyQuery.Close;
end;

end.

