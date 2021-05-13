object frmCreateNS: TfrmCreateNS
  Left = 230
  Top = 178
  BorderStyle = bsDialog
  Caption = 'Create Name Server'
  ClientHeight = 399
  ClientWidth = 609
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
  object LabelDNSServers: TLabel
    Left = 8
    Top = 8
    Width = 67
    Height = 13
    Caption = 'Name Servers'
  end
  object LabelHost: TLabel
    Left = 400
    Top = 24
    Width = 22
    Height = 13
    Caption = 'Host'
  end
  object LabelIP: TLabel
    Left = 400
    Top = 64
    Width = 10
    Height = 13
    Caption = 'IP'
  end
  object LabelOS: TLabel
    Left = 400
    Top = 104
    Width = 15
    Height = 13
    Hint = 'Operating System'
    Caption = 'OS'
  end
  object LabelUser: TLabel
    Left = 400
    Top = 144
    Width = 22
    Height = 13
    Caption = 'User'
  end
  object LabelPassword: TLabel
    Left = 400
    Top = 184
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object LabelID: TLabel
    Left = 400
    Top = 224
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object LabelStatus: TLabel
    Left = 400
    Top = 264
    Width = 30
    Height = 13
    Caption = 'Status'
  end
  object LabelStillAlive: TLabel
    Left = 400
    Top = 304
    Width = 41
    Height = 13
    Caption = 'Still alive'
  end
  object Bevel: TBevel
    Left = 0
    Top = 352
    Width = 609
    Height = 5
    Shape = bsTopLine
  end
  object ComboBoxOS: TComboBox
    Left = 400
    Top = 120
    Width = 177
    Height = 21
    Style = csDropDownList
    TabOrder = 3
  end
  object DBGridDNS: TDBGrid
    Left = 8
    Top = 24
    Width = 379
    Height = 316
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
        FieldName = 'host'
        Title.Caption = 'Host'
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
        Width = 40
        Visible = True
      end>
  end
  object EditHost: TEdit
    Left = 400
    Top = 40
    Width = 201
    Height = 21
    Color = clCream
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
  end
  object EditIP: TEdit
    Left = 400
    Top = 80
    Width = 113
    Height = 21
    Color = clCream
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
  object EditUser: TEdit
    Left = 400
    Top = 160
    Width = 145
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object EditPassword: TEdit
    Left = 400
    Top = 200
    Width = 145
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object EditID: TEdit
    Left = 400
    Top = 240
    Width = 81
    Height = 21
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
  end
  object EditStatus: TEdit
    Left = 400
    Top = 280
    Width = 81
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
  end
  object EditStillAlive: TEdit
    Left = 400
    Top = 320
    Width = 169
    Height = 21
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 8
  end
  object BitBtnCreate: TBitBtn
    Left = 8
    Top = 366
    Width = 75
    Height = 25
    Caption = '&Create'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 9
    OnClick = BitBtnCreateClick
  end
  object BitBtnCerrar: TBitBtn
    Left = 526
    Top = 366
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 10
    OnClick = BitBtnCerrarClick
  end
  object DataSource: TDataSource
    DataSet = MyTableNServers
    Left = 40
    Top = 80
  end
  object MyTableNServers: TMyTable
    TableName = 'nservers'
    Connection = frmMain.MyConnection
    Left = 40
    Top = 136
    object MyTableNServersID: TIntegerField
      FieldName = 'id'
    end
    object MyTableNServersHost: TStringField
      FieldName = 'host'
      Origin = 'nservers.host'
      Size = 30
    end
    object MyTableNServersIP: TStringField
      FieldName = 'ip'
      Origin = 'nservers.ip'
      Size = 15
    end
    object MyTableNServersOS: TIntegerField
      FieldName = 'os'
      Origin = 'nservers.os'
    end
    object MyTableNServersUsr: TStringField
      FieldName = 'usr'
      Origin = 'nservers.usr'
      Size = 16
    end
    object MyTableNServersPass: TStringField
      FieldName = 'pass'
      Origin = 'nservers.pass'
      Size = 16
    end
    object MyTableNServersStatus: TStringField
      FieldName = 'status'
      Origin = 'nservers.status'
      Size = 8
    end
    object MyTableNServerslping: TFloatField
      FieldName = 'lping'
      Origin = 'nservers.lping'
    end
  end
  object MyTableOS: TMyTable
    TableName = 'os'
    ReadOnly = True
    Connection = frmMain.MyConnection
    Left = 40
    Top = 200
  end
end
