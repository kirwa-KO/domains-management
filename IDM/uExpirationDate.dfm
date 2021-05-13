object frmExpirationDate: TfrmExpirationDate
  Left = 275
  Top = 226
  BorderStyle = bsDialog
  Caption = 'Expiration Date'
  ClientHeight = 84
  ClientWidth = 339
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelShow: TLabel
    Left = 8
    Top = 12
    Width = 152
    Height = 13
    Caption = 'Show domains that will expire in:'
  end
  object ComboBoxTiempo: TComboBox
    Left = 168
    Top = 8
    Width = 161
    Height = 21
    Style = csDropDownList
    DropDownCount = 10
    TabOrder = 0
  end
  object BitBtnRenovar: TBitBtn
    Left = 44
    Top = 48
    Width = 75
    Height = 25
    Caption = '&Renew'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = BitBtnPreviewClick
  end
  object BitBtnCerrar: TBitBtn
    Left = 220
    Top = 48
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
    OnClick = BitBtnCerrarClick
  end
  object BitBtnPreview: TBitBtn
    Left = 132
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Preview'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
    OnClick = BitBtnPreviewClick
  end
  object MyQuery: TMyQuery
    Connection = frmMain.MyConnection
    ParamCheck = False
    SQL.Strings = (
      'SELECT *'
      'FROM Domains'
      'ORDER BY Expire, Name')
    OnCalcFields = MyQueryCalcFields
    Left = 8
    Top = 40
    object MyQueryName: TStringField
      FieldName = 'name'
      Size = 30
    end
    object MyQueryRegistrar: TStringField
      FieldName = 'registrar'
      Size = 10
    end
    object MyQueryExpire: TFloatField
      FieldName = 'expire'
    end
    object MyQueryFechaLimite: TStringField
      FieldKind = fkCalculated
      FieldName = 'FechaLimite'
      Size = 25
      Calculated = True
    end
  end
end
