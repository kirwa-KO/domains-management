object frmRegistrar: TfrmRegistrar
  Left = 242
  Top = 187
  BorderStyle = bsDialog
  Caption = 'Registrar'
  ClientHeight = 368
  ClientWidth = 658
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
  object LabelURL: TLabel
    Left = 288
    Top = 272
    Width = 22
    Height = 13
    Caption = 'URL'
  end
  object LabelID: TLabel
    Left = 568
    Top = 272
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object Bevel: TBevel
    Left = 0
    Top = 320
    Width = 657
    Height = 5
    Shape = bsTopLine
  end
  object DBGrid: TDBGrid
    Left = 8
    Top = 24
    Width = 642
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
        Width = 270
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'url'
        Title.Caption = 'URL'
        Width = 270
        Visible = True
      end>
  end
  object EditName: TEdit
    Left = 8
    Top = 288
    Width = 265
    Height = 21
    TabOrder = 1
  end
  object EditURL: TEdit
    Left = 288
    Top = 288
    Width = 265
    Height = 21
    TabOrder = 2
  end
  object EditID: TEdit
    Left = 568
    Top = 288
    Width = 81
    Height = 21
    Color = clInfoBk
    ReadOnly = True
    TabOrder = 3
  end
  object BitBtnNuevo: TBitBtn
    Left = 8
    Top = 334
    Width = 75
    Height = 25
    Caption = '&New'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 4
    OnClick = BitBtnNuevoClick
  end
  object BitBtnBorrar: TBitBtn
    Left = 96
    Top = 334
    Width = 75
    Height = 25
    Caption = '&Delete'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 5
    OnClick = BitBtnBorrarClick
  end
  object BitBtnModificar: TBitBtn
    Left = 184
    Top = 334
    Width = 75
    Height = 25
    Caption = '&Modify'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 6
    OnClick = BitBtnModificarClick
  end
  object BitBtnCerrar: TBitBtn
    Left = 574
    Top = 334
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 7
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
    AfterScroll = MyTableRegistrarAfterScroll
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
