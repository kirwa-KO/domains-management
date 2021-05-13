object frmPersonas: TfrmPersonas
  Left = 266
  Top = 203
  BorderStyle = bsDialog
  Caption = 'Persons'
  ClientHeight = 225
  ClientWidth = 577
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
  object LabelPersons: TLabel
    Left = 8
    Top = 8
    Width = 38
    Height = 13
    Caption = 'Persons'
  end
  object DBGrid: TDBGrid
    Left = 8
    Top = 24
    Width = 562
    Height = 161
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
        FieldName = 'first'
        Title.Caption = 'First'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'last'
        Title.Caption = 'Last'
        Width = 130
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
    Left = 205
    Top = 192
    Width = 75
    Height = 25
    Caption = '&Copy'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = BitBtnCopiarClick
  end
  object BitBtnCancelar: TBitBtn
    Left = 296
    Top = 192
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
    OnClick = BitBtnCancelarClick
  end
  object DataSource: TDataSource
    DataSet = MyTablePerson
    Left = 112
    Top = 72
  end
  object MyTablePerson: TMyTable
    TableName = 'person'
    ReadOnly = True
    Connection = frmMain.MyConnection
    Left = 208
    Top = 72
  end
end
