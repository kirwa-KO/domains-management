object frmHosts: TfrmHosts
  Left = 233
  Top = 201
  BorderStyle = bsDialog
  Caption = 'Hosts'
  ClientHeight = 330
  ClientWidth = 600
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
  object LabelHosts: TLabel
    Left = 8
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Hosts'
  end
  object LabelName: TLabel
    Left = 400
    Top = 24
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object LabelIP: TLabel
    Left = 400
    Top = 72
    Width = 10
    Height = 13
    Caption = 'IP'
  end
  object LabelID: TLabel
    Left = 400
    Top = 120
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object Bevel: TBevel
    Left = 0
    Top = 280
    Width = 601
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
        Width = 195
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
        Width = 45
        Visible = True
      end>
  end
  object EditName: TEdit
    Left = 400
    Top = 40
    Width = 193
    Height = 21
    TabOrder = 1
  end
  object EditIP: TEdit
    Left = 400
    Top = 88
    Width = 113
    Height = 21
    TabOrder = 2
  end
  object EditID: TEdit
    Left = 400
    Top = 136
    Width = 81
    Height = 21
    Color = clInfoBk
    ReadOnly = True
    TabOrder = 3
  end
  object BitBtnNuevo: TBitBtn
    Left = 8
    Top = 294
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
    Top = 294
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
    Top = 294
    Width = 75
    Height = 25
    Caption = '&Modify'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 6
    OnClick = BitBtnModificarClick
  end
  object BitBtnCerrar: TBitBtn
    Left = 518
    Top = 294
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
    DataSet = MyTableNHosts
    Left = 40
    Top = 80
  end
  object MyTableNHosts: TMyTable
    TableName = 'nhosts'
    Connection = frmMain.MyConnection
    AfterScroll = MyTableNHostsAfterScroll
    Left = 120
    Top = 80
    object MyTableNHostsID: TIntegerField
      FieldName = 'id'
    end
    object MyTableNHostsName: TStringField
      FieldName = 'name'
      Size = 30
    end
    object MyTableNHostsIP: TStringField
      FieldName = 'ip'
      Size = 15
    end
  end
end
