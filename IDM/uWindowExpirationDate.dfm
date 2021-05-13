object frmWindowExpirationDate: TfrmWindowExpirationDate
  Left = 223
  Top = 153
  BorderStyle = bsDialog
  Caption = 'Expiration Date'
  ClientHeight = 254
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object LabelDominios: TLabel
    Left = 8
    Top = 8
    Width = 41
    Height = 13
    Caption = 'Domains'
  end
  object DBGrid: TDBGrid
    Left = 8
    Top = 24
    Width = 440
    Height = 183
    DataSource = DataSource
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = DBGridDblClick
    OnKeyPress = DBGridKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'name'
        Title.Caption = 'Name'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'registrar'
        Title.Caption = 'Registrar'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FechaLimite'
        Title.Caption = 'Expiration Date'
        Visible = True
      end>
  end
  object BitBtnRenovar: TBitBtn
    Left = 143
    Top = 220
    Width = 75
    Height = 25
    Caption = 'Renew'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = BitBtnRenovarClick
  end
  object BitBtnCerrar: TBitBtn
    Left = 239
    Top = 220
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
    OnClick = BitBtnCerrarClick
  end
  object DataSource: TDataSource
    DataSet = frmExpirationDate.MyQuery
    Left = 96
    Top = 80
  end
  object MyQuery: TMyQuery
    Connection = frmMain.MyConnection
    ParamCheck = False
    Left = 96
    Top = 128
  end
end
