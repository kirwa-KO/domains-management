object frmWebHost: TfrmWebHost
  Left = 272
  Top = 220
  BorderStyle = bsDialog
  Caption = 'Web Host'
  ClientHeight = 244
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object LabelWebHost: TLabel
    Left = 8
    Top = 8
    Width = 48
    Height = 13
    Caption = 'Web Host'
  end
  object DBGrid: TDBGrid
    Left = 8
    Top = 24
    Width = 403
    Height = 169
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
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ip'
        Title.Caption = 'IP'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'id'
        Title.Caption = 'ID'
        Visible = True
      end>
  end
  object BitBtnCopiar: TBitBtn
    Left = 116
    Top = 208
    Width = 83
    Height = 25
    Caption = '&Copy'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = BitBtnCopiarClick
  end
  object BitBtnCancelar: TBitBtn
    Left = 220
    Top = 208
    Width = 83
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
    OnClick = BitBtnCancelarClick
  end
  object DataSource: TDataSource
    DataSet = MyTableNHosts
    Left = 80
    Top = 72
  end
  object MyTableNHosts: TMyTable
    TableName = 'nhosts'
    ReadOnly = True
    Connection = frmMain.MyConnection
    Left = 160
    Top = 72
  end
end
