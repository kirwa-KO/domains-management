object frmPersons: TfrmPersons
  Left = 261
  Top = 207
  BorderStyle = bsDialog
  Caption = 'Persons'
  ClientHeight = 409
  ClientWidth = 584
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
  object LabelPersons: TLabel
    Left = 8
    Top = 8
    Width = 38
    Height = 13
    Caption = 'Persons'
  end
  object Bevel: TBevel
    Left = 0
    Top = 360
    Width = 585
    Height = 5
    Shape = bsTopLine
  end
  object LabelName: TLabel
    Left = 8
    Top = 272
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object LabelFirst: TLabel
    Left = 256
    Top = 272
    Width = 19
    Height = 13
    Caption = 'First'
  end
  object LabelLast: TLabel
    Left = 424
    Top = 272
    Width = 20
    Height = 13
    Caption = 'Last'
  end
  object LabelEMail: TLabel
    Left = 8
    Top = 312
    Width = 29
    Height = 13
    Caption = 'E-Mail'
  end
  object LabelPhone: TLabel
    Left = 256
    Top = 312
    Width = 31
    Height = 13
    Caption = 'Phone'
  end
  object LabelID: TLabel
    Left = 496
    Top = 312
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object DBGrid: TDBGrid
    Left = 8
    Top = 24
    Width = 569
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
        Width = 230
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'first'
        Title.Caption = 'First'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'last'
        Title.Caption = 'Last'
        Width = 150
        Visible = True
      end>
  end
  object BitBtnNuevo: TBitBtn
    Left = 8
    Top = 374
    Width = 75
    Height = 25
    Caption = '&New'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 7
    OnClick = BitBtnNuevoClick
  end
  object BitBtnBorrar: TBitBtn
    Left = 96
    Top = 374
    Width = 75
    Height = 25
    Caption = '&Delete'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 8
    OnClick = BitBtnBorrarClick
  end
  object BitBtnModificar: TBitBtn
    Left = 184
    Top = 374
    Width = 75
    Height = 25
    Caption = '&Modify'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 9
    OnClick = BitBtnModificarClick
  end
  object BitBtnCerrar: TBitBtn
    Left = 502
    Top = 374
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 10
    OnClick = BitBtnCerrarClick
  end
  object EditName: TEdit
    Left = 8
    Top = 288
    Width = 233
    Height = 21
    TabOrder = 1
  end
  object EditFirst: TEdit
    Left = 256
    Top = 288
    Width = 153
    Height = 21
    TabOrder = 2
  end
  object EditLast: TEdit
    Left = 424
    Top = 288
    Width = 153
    Height = 21
    TabOrder = 3
  end
  object EditEMail: TEdit
    Left = 8
    Top = 328
    Width = 233
    Height = 21
    TabOrder = 4
  end
  object EditPhone: TEdit
    Left = 256
    Top = 328
    Width = 225
    Height = 21
    TabOrder = 5
  end
  object EditID: TEdit
    Left = 496
    Top = 328
    Width = 81
    Height = 21
    Color = clInfoBk
    ReadOnly = True
    TabOrder = 6
  end
  object DataSource: TDataSource
    DataSet = MyTablePerson
    Left = 40
    Top = 80
  end
  object MyTablePerson: TMyTable
    TableName = 'person'
    Connection = frmMain.MyConnection
    AfterScroll = MyTablePersonAfterScroll
    Left = 128
    Top = 80
    object MyTablePersonID: TIntegerField
      FieldName = 'id'
    end
    object MyTablePersonName: TStringField
      FieldName = 'name'
      Size = 50
    end
    object MyTablePersonFirst: TStringField
      FieldName = 'first'
      Size = 30
    end
    object MyTablePersonLast: TStringField
      FieldName = 'last'
      Size = 30
    end
    object MyTablePersonEMail: TStringField
      FieldName = 'email'
      Size = 40
    end
    object MyTablePersonPhone: TStringField
      FieldName = 'phone'
      Size = 50
    end
  end
end
