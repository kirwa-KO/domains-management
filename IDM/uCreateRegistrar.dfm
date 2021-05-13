object frmCreateRegistrar: TfrmCreateRegistrar
  Left = 241
  Top = 181
  BorderStyle = bsDialog
  Caption = 'Create Registrar'
  ClientHeight = 409
  ClientWidth = 395
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelRegistrar: TLabel
    Left = 8
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Registrar'
  end
  object LabelName: TLabel
    Left = 8
    Top = 272
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object LabelID: TLabel
    Left = 304
    Top = 272
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object LabelURL: TLabel
    Left = 8
    Top = 312
    Width = 22
    Height = 13
    Caption = 'URL'
  end
  object Bevel: TBevel
    Left = -24
    Top = 360
    Width = 417
    Height = 9
    Shape = bsTopLine
  end
  object DBGrid: TDBGrid
    Left = 8
    Top = 24
    Width = 380
    Height = 238
    DataSource = DataSource
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'name'
        Title.Caption = 'Name'
        Width = 280
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'id'
        Title.Caption = 'ID'
        Visible = True
      end>
  end
  object EditName: TEdit
    Left = 8
    Top = 288
    Width = 281
    Height = 21
    Color = clCream
    ReadOnly = True
    TabOrder = 1
  end
  object EditID: TEdit
    Left = 304
    Top = 288
    Width = 81
    Height = 21
    Color = clInfoBk
    ReadOnly = True
    TabOrder = 2
  end
  object EditURL: TEdit
    Left = 8
    Top = 328
    Width = 377
    Height = 21
    TabOrder = 3
  end
  object BitBtnCreate: TBitBtn
    Left = 8
    Top = 374
    Width = 75
    Height = 25
    Caption = '&Create'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 4
    OnClick = BitBtnCreateClick
  end
  object BitBtnCerrar: TBitBtn
    Left = 310
    Top = 374
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 5
    OnClick = BitBtnCerrarClick
  end
  object DataSource: TDataSource
    DataSet = MyTableRegistrar
    Left = 40
    Top = 80
  end
  object MyTableRegistrar: TMyTable
    TableName = 'registrar'
    Connection = frmMain.MyConnection
    Left = 128
    Top = 80
    object MyTableRegistrarID: TIntegerField
      FieldName = 'id'
    end
    object MyTableRegistrarName: TStringField
      FieldName = 'name'
      Origin = 'registrar.name'
      Size = 40
    end
    object MyTableRegistrarURL: TStringField
      FieldName = 'url'
      Origin = 'registrar.url'
      Size = 80
    end
  end
end
