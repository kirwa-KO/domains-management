object frmRegistrador: TfrmRegistrador
  Left = 246
  Top = 197
  BorderStyle = bsDialog
  Caption = 'Registrar'
  ClientHeight = 244
  ClientWidth = 656
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
  object LabelRegistrador: TLabel
    Left = 8
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Registrar'
  end
  object DBGrid: TDBGrid
    Left = 8
    Top = 24
    Width = 641
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
        Width = 270
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'url'
        Title.Caption = 'URL'
        Width = 270
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
    Left = 234
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
    Left = 338
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
    DataSet = MyTableRegistrador
    Left = 136
    Top = 72
  end
  object MyTableRegistrador: TMyTable
    TableName = 'registrar'
    ReadOnly = True
    Connection = frmMain.MyConnection
    Left = 224
    Top = 72
  end
end
