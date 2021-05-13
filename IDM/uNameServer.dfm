object frmElegirDNS: TfrmElegirDNS
  Left = 233
  Top = 177
  BorderStyle = bsDialog
  Caption = 'Name Server'
  ClientHeight = 225
  ClientWidth = 409
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
  object LabelNameServer: TLabel
    Left = 8
    Top = 8
    Width = 62
    Height = 13
    Caption = 'Name Server'
  end
  object DBGrid: TDBGrid
    Left = 8
    Top = 24
    Width = 393
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
        FieldName = 'host'
        Title.Caption = 'Host'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ip'
        Title.Caption = 'IP'
        Width = 90
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
    Left = 121
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
    Left = 212
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
    DataSet = MyTableNServers
    Left = 112
    Top = 72
  end
  object MyTableNServers: TMyTable
    TableName = 'nservers'
    ReadOnly = True
    Connection = frmMain.MyConnection
    Left = 200
    Top = 72
    object MyTableNServersid: TIntegerField
      FieldName = 'id'
    end
    object MyTableNServershost: TStringField
      FieldName = 'host'
      Size = 255
    end
    object MyTableNServersip: TStringField
      FieldName = 'ip'
      Size = 255
    end
    object MyTableNServersos: TIntegerField
      FieldName = 'os'
    end
    object MyTableNServersusr: TStringField
      FieldName = 'usr'
      Size = 255
    end
    object MyTableNServerspass: TStringField
      FieldName = 'pass'
      Size = 255
    end
    object MyTableNServersstatus: TStringField
      FieldName = 'status'
      Size = 255
    end
    object MyTableNServerslping: TFloatField
      FieldName = 'lping'
    end
  end
end
