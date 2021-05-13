object frmConfigurar: TfrmConfigurar
  Left = 242
  Top = 197
  ActiveControl = EditNombreDelServidor
  BorderStyle = bsDialog
  Caption = 'Config Server'
  ClientHeight = 112
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelNombreDelServidor: TLabel
    Left = 8
    Top = 12
    Width = 62
    Height = 13
    Caption = 'Server Name'
  end
  object LabelDatabase: TLabel
    Left = 8
    Top = 36
    Width = 46
    Height = 13
    Caption = 'Database'
  end
  object LabelLogin: TLabel
    Left = 8
    Top = 60
    Width = 26
    Height = 13
    Caption = 'Login'
  end
  object Label1: TLabel
    Left = 8
    Top = 84
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object EditNombreDelServidor: TEdit
    Left = 120
    Top = 8
    Width = 193
    Height = 21
    TabOrder = 0
  end
  object EditDatabase: TEdit
    Left = 120
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object EditLogin: TEdit
    Left = 120
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object EditPassword: TEdit
    Left = 120
    Top = 80
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object BitBtnConfigurar: TBitBtn
    Left = 344
    Top = 8
    Width = 75
    Height = 25
    Caption = '&Config'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 4
    OnClick = BitBtnConfigurarClick
  end
  object BitBtnSalir: TBitBtn
    Left = 344
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Exit'
    DoubleBuffered = True
    ModalResult = 2
    ParentDoubleBuffered = False
    TabOrder = 5
  end
end
