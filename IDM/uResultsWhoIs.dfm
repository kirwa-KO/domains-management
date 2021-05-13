object frmResultWhoIs: TfrmResultWhoIs
  Left = 218
  Top = 152
  ActiveControl = BitBtnClose
  BorderStyle = bsDialog
  Caption = 'Results - WhoIs'
  ClientHeight = 553
  ClientWidth = 675
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBoxAdmin: TGroupBox
    Left = 8
    Top = 8
    Width = 659
    Height = 145
    Caption = 'Administrator'
    TabOrder = 0
    object LabelAdminFirst: TLabel
      Left = 104
      Top = 20
      Width = 19
      Height = 13
      Caption = 'First'
    end
    object LabelAdminLast: TLabel
      Left = 248
      Top = 20
      Width = 20
      Height = 13
      Caption = 'Last'
    end
    object LabelAdminEMail: TLabel
      Left = 392
      Top = 20
      Width = 26
      Height = 13
      Caption = 'EMail'
    end
    object LabelAdminName: TLabel
      Left = 8
      Top = 64
      Width = 28
      Height = 13
      Caption = 'Name'
    end
    object LabelAdminPhone: TLabel
      Left = 392
      Top = 64
      Width = 31
      Height = 13
      Caption = 'Phone'
    end
    object LabelAdminID: TLabel
      Left = 8
      Top = 20
      Width = 11
      Height = 13
      Caption = 'ID'
    end
    object LabelAdminEstado: TLabel
      Left = 8
      Top = 114
      Width = 160
      Height = 16
      Alignment = taCenter
      Caption = 'This register already exists'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object EditAdminFirst: TEdit
      Left = 104
      Top = 36
      Width = 129
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 1
    end
    object EditAdminLast: TEdit
      Left = 248
      Top = 36
      Width = 129
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 2
    end
    object EditAdminEMail: TEdit
      Left = 392
      Top = 36
      Width = 257
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 3
    end
    object EditAdminName: TEdit
      Left = 8
      Top = 80
      Width = 369
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 4
    end
    object EditAdminPhone: TEdit
      Left = 392
      Top = 80
      Width = 257
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 5
    end
    object BitBtnAdminCreateUpdate: TBitBtn
      Left = 188
      Top = 110
      Width = 75
      Height = 25
      Caption = 'Create'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 6
      Visible = False
      OnClick = BitBtnAdminCreateUpdateClick
    end
    object EditAdminID: TEdit
      Left = 8
      Top = 36
      Width = 81
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 0
    end
  end
  object GroupBoxTecnico: TGroupBox
    Left = 8
    Top = 168
    Width = 659
    Height = 145
    Caption = 'Technician'
    TabOrder = 1
    object LabelTecnicoFirst: TLabel
      Left = 104
      Top = 20
      Width = 19
      Height = 13
      Caption = 'First'
    end
    object LabelTecnicoLast: TLabel
      Left = 248
      Top = 20
      Width = 20
      Height = 13
      Caption = 'Last'
    end
    object LabelTecnicoEMail: TLabel
      Left = 392
      Top = 20
      Width = 26
      Height = 13
      Caption = 'EMail'
    end
    object LabelTecnicoName: TLabel
      Left = 8
      Top = 64
      Width = 28
      Height = 13
      Caption = 'Name'
    end
    object LabelTecnicoPhone: TLabel
      Left = 392
      Top = 64
      Width = 31
      Height = 13
      Caption = 'Phone'
    end
    object LabelTecnicoID: TLabel
      Left = 8
      Top = 20
      Width = 11
      Height = 13
      Caption = 'ID'
    end
    object LabelTecnicoEstado: TLabel
      Left = 8
      Top = 114
      Width = 160
      Height = 16
      Alignment = taCenter
      Caption = 'This register already exists'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object EditTecnicoFirst: TEdit
      Left = 104
      Top = 36
      Width = 129
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 1
    end
    object EditTecnicoLast: TEdit
      Left = 248
      Top = 36
      Width = 129
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 2
    end
    object EditTecnicoEMail: TEdit
      Left = 392
      Top = 36
      Width = 257
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 3
    end
    object EditTecnicoName: TEdit
      Left = 8
      Top = 80
      Width = 369
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 4
    end
    object EditTecnicoPhone: TEdit
      Left = 392
      Top = 80
      Width = 257
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 5
    end
    object BitBtnTecnicoCreateUpdate: TBitBtn
      Left = 188
      Top = 110
      Width = 75
      Height = 25
      Caption = 'Create'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 6
      Visible = False
      OnClick = BitBtnAdminCreateUpdateClick
    end
    object EditTecnicoID: TEdit
      Left = 8
      Top = 36
      Width = 81
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 0
    end
  end
  object GroupBoxRegistrador: TGroupBox
    Left = 8
    Top = 464
    Width = 330
    Height = 81
    Caption = 'Registrar'
    TabOrder = 3
    object LabelRegistradorEstado: TLabel
      Left = 8
      Top = 52
      Width = 149
      Height = 16
      Alignment = taCenter
      Caption = 'The register doesn'#39't exist'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object EditRegistrador: TEdit
      Left = 8
      Top = 20
      Width = 313
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 0
    end
    object BitBtnRegistradorCreate: TBitBtn
      Left = 173
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Create'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      Visible = False
      OnClick = BitBtnRegistradorCreateClick
    end
  end
  object GroupBoxExpire: TGroupBox
    Left = 360
    Top = 464
    Width = 170
    Height = 81
    Caption = 'Expire'
    TabOrder = 4
    object LabelExpireEstado: TLabel
      Left = 8
      Top = 52
      Width = 137
      Height = 16
      Alignment = taCenter
      Caption = 'It will expire in 999 days'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object EditExpire: TEdit
      Left = 8
      Top = 24
      Width = 153
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 0
    end
  end
  object GroupBoxNS: TGroupBox
    Left = 8
    Top = 328
    Width = 657
    Height = 121
    Caption = 'Name Servers'
    TabOrder = 2
    object LabelNS1: TLabel
      Left = 8
      Top = 20
      Width = 21
      Height = 13
      Caption = 'NS1'
    end
    object LabelNS2: TLabel
      Left = 168
      Top = 20
      Width = 21
      Height = 13
      Caption = 'NS2'
    end
    object LabelNS3: TLabel
      Left = 328
      Top = 20
      Width = 21
      Height = 13
      Caption = 'NS3'
    end
    object LabelNS4: TLabel
      Left = 488
      Top = 20
      Width = 21
      Height = 13
      Caption = 'NS4'
    end
    object EditNS1: TEdit
      Left = 8
      Top = 36
      Width = 145
      Height = 21
      Color = clCream
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
    end
    object EditNSIP1: TEdit
      Left = 8
      Top = 60
      Width = 145
      Height = 21
      Color = clCream
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
    end
    object EditNS2: TEdit
      Left = 168
      Top = 36
      Width = 145
      Height = 21
      Color = clCream
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 2
    end
    object EditNSIP2: TEdit
      Left = 168
      Top = 60
      Width = 145
      Height = 21
      Color = clCream
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 3
    end
    object EditNS3: TEdit
      Left = 328
      Top = 36
      Width = 145
      Height = 21
      Color = clCream
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 4
    end
    object EditNSIP3: TEdit
      Left = 328
      Top = 60
      Width = 145
      Height = 21
      Color = clCream
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 5
    end
    object EditNS4: TEdit
      Left = 488
      Top = 36
      Width = 145
      Height = 21
      Color = clCream
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 6
    end
    object EditNSIP4: TEdit
      Left = 488
      Top = 60
      Width = 145
      Height = 21
      Color = clCream
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 7
    end
    object BitBtnNS1Create: TBitBtn
      Left = 24
      Top = 88
      Width = 113
      Height = 25
      Caption = 'Doesn'#39't exist. Create'
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 8
      OnClick = BitBtnNS1CreateClick
    end
    object BitBtnNS2Create: TBitBtn
      Left = 184
      Top = 88
      Width = 113
      Height = 25
      Caption = 'Doesn'#39't exist. Create'
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 9
      OnClick = BitBtnNS1CreateClick
    end
    object BitBtnNS3Create: TBitBtn
      Left = 344
      Top = 88
      Width = 113
      Height = 25
      Caption = 'Doesn'#39't exist. Create'
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 10
      OnClick = BitBtnNS1CreateClick
    end
    object BitBtnNS4Create: TBitBtn
      Left = 504
      Top = 88
      Width = 113
      Height = 25
      Caption = 'Doesn'#39't exist. Create'
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 11
      OnClick = BitBtnNS1CreateClick
    end
  end
  object BitBtnCopy: TBitBtn
    Left = 560
    Top = 488
    Width = 91
    Height = 25
    Caption = '&Copy this Info'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 5
    OnClick = BitBtnCopyClick
  end
  object BitBtnClose: TBitBtn
    Left = 560
    Top = 520
    Width = 91
    Height = 25
    Cancel = True
    Caption = 'Close'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 6
    OnClick = BitBtnCloseClick
  end
  object MyQuery: TMyQuery
    Connection = frmMain.MyConnection
    Left = 344
    Top = 136
  end
end
