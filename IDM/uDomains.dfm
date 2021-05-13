object frmDominios: TfrmDominios
  Left = 229
  Top = 166
  ActiveControl = DBGridDomains
  BorderStyle = bsDialog
  Caption = 'Domains'
  ClientHeight = 396
  ClientWidth = 594
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
  object StatusBar: TStatusBar
    Left = 0
    Top = 377
    Width = 594
    Height = 19
    Panels = <>
  end
  object PanelAbajo: TPanel
    Left = 0
    Top = 339
    Width = 594
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object PanelAbajoIzquierda: TPanel
      Left = 0
      Top = 0
      Width = 377
      Height = 38
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object BitBtnModificar: TBitBtn
        Left = 184
        Top = 0
        Width = 75
        Height = 25
        Caption = '&Modify'
        DoubleBuffered = True
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentDoubleBuffered = False
        ParentFont = False
        TabOrder = 2
        OnClick = BitBtnModificarClick
      end
      object BitBtnBorrar: TBitBtn
        Left = 96
        Top = 0
        Width = 75
        Height = 25
        Caption = '&Delete'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 1
        OnClick = BitBtnBorrarClick
      end
      object BitBtnNuevo: TBitBtn
        Left = 8
        Top = 0
        Width = 75
        Height = 25
        Caption = '&New'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
        OnClick = BitBtnNuevoClick
      end
      object BitBtnAuto: TBitBtn
        Left = 273
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Auto'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 3
        OnClick = BitBtnAutoClick
      end
    end
    object PanelAbajoDerecha: TPanel
      Left = 376
      Top = 0
      Width = 218
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object BitBtnVerificarInfo: TBitBtn
        Left = 24
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Verify Info'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
        OnClick = BitBtnWhoIsClick
      end
      object BitBtnCerrar: TBitBtn
        Left = 132
        Top = 0
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Close'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 1
        OnClick = BitBtnCerrarClick
      end
    end
  end
  object PanelDerecha: TPanel
    Left = 221
    Top = 0
    Width = 373
    Height = 339
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object LabelDomainName: TLabel
      Left = 16
      Top = 8
      Width = 67
      Height = 13
      Caption = 'Domain Name'
    end
    object LabelNS1: TLabel
      Left = 16
      Top = 48
      Width = 24
      Height = 13
      Caption = 'NS 1'
    end
    object LabelNS2: TLabel
      Left = 184
      Top = 48
      Width = 24
      Height = 13
      Caption = 'NS 2'
    end
    object LabelNS3: TLabel
      Left = 16
      Top = 88
      Width = 24
      Height = 13
      Caption = 'NS 3'
    end
    object LabelNS4: TLabel
      Left = 184
      Top = 88
      Width = 24
      Height = 13
      Caption = 'NS 4'
    end
    object LabelMailServer1: TLabel
      Left = 16
      Top = 128
      Width = 62
      Height = 13
      Caption = 'Mail Server 1'
    end
    object LabelMailServer2: TLabel
      Left = 184
      Top = 128
      Width = 62
      Height = 13
      Caption = 'Mail Server 2'
    end
    object LabelWebHost: TLabel
      Left = 16
      Top = 168
      Width = 48
      Height = 13
      Caption = 'Web Host'
    end
    object LabelOwner: TLabel
      Left = 184
      Top = 168
      Width = 31
      Height = 13
      Caption = 'Owner'
    end
    object LabelAdmin: TLabel
      Left = 16
      Top = 208
      Width = 60
      Height = 13
      Caption = 'Administrator'
    end
    object LabelTecnico: TLabel
      Left = 184
      Top = 208
      Width = 53
      Height = 13
      Caption = 'Technician'
    end
    object LabelBill: TLabel
      Left = 16
      Top = 248
      Width = 13
      Height = 13
      Caption = 'Bill'
    end
    object LabelRegistrador: TLabel
      Left = 184
      Top = 248
      Width = 42
      Height = 13
      Caption = 'Registrar'
    end
    object LabelVendorPassword: TLabel
      Left = 16
      Top = 288
      Width = 83
      Height = 13
      Caption = 'Vendor Password'
    end
    object LabelExpira: TLabel
      Left = 184
      Top = 288
      Width = 29
      Height = 13
      Caption = 'Expire'
    end
    object EditName: TEdit
      Left = 16
      Top = 24
      Width = 201
      Height = 21
      TabOrder = 0
      OnChange = EditNameChange
    end
    object BitBtnWhoIs: TBitBtn
      Left = 216
      Top = 24
      Width = 49
      Height = 21
      Caption = 'WhoIs'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = BitBtnWhoIsClick
    end
    object EditNS1: TEdit
      Left = 16
      Top = 64
      Width = 81
      Height = 21
      TabOrder = 2
      OnChange = EditNameChange
    end
    object BitBtnNS1: TBitBtn
      Left = 96
      Top = 64
      Width = 21
      Height = 21
      Caption = '...'
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 3
      OnClick = BitBtnNS1Click
    end
    object EditNS2: TEdit
      Left = 184
      Top = 64
      Width = 81
      Height = 21
      TabOrder = 4
      OnChange = EditNameChange
    end
    object BitBtnNS2: TBitBtn
      Left = 264
      Top = 64
      Width = 21
      Height = 21
      Caption = '...'
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 5
      OnClick = BitBtnNS1Click
    end
    object EditNS3: TEdit
      Left = 16
      Top = 104
      Width = 81
      Height = 21
      TabOrder = 6
      OnChange = EditNameChange
    end
    object BitBtnNS3: TBitBtn
      Left = 96
      Top = 104
      Width = 21
      Height = 21
      Caption = '...'
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 7
      OnClick = BitBtnNS1Click
    end
    object EditNS4: TEdit
      Left = 184
      Top = 104
      Width = 81
      Height = 21
      TabOrder = 8
      OnChange = EditNameChange
    end
    object BitBtnNS4: TBitBtn
      Left = 264
      Top = 104
      Width = 21
      Height = 21
      Caption = '...'
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 9
      OnClick = BitBtnNS1Click
    end
    object EditMailServer1: TEdit
      Left = 16
      Top = 144
      Width = 81
      Height = 21
      TabOrder = 10
      OnChange = EditNameChange
    end
    object BitBtnMailServer1: TBitBtn
      Left = 96
      Top = 144
      Width = 21
      Height = 21
      Caption = '...'
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 11
      OnClick = BitBtnMailServer1Click
    end
    object EditMailServer2: TEdit
      Left = 184
      Top = 144
      Width = 81
      Height = 21
      TabOrder = 12
      OnChange = EditNameChange
    end
    object BitBtnMailServer2: TBitBtn
      Left = 264
      Top = 144
      Width = 21
      Height = 21
      Caption = '...'
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 13
      OnClick = BitBtnMailServer1Click
    end
    object EditWebHost: TEdit
      Left = 16
      Top = 184
      Width = 81
      Height = 21
      TabOrder = 14
      OnChange = EditNameChange
    end
    object BitBtnWebHost: TBitBtn
      Left = 96
      Top = 184
      Width = 21
      Height = 21
      Caption = '...'
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 15
      OnClick = BitBtnWebHostClick
    end
    object EditOwner: TEdit
      Left = 184
      Top = 184
      Width = 81
      Height = 21
      TabOrder = 16
      OnChange = EditNameChange
    end
    object BitBtnOwner: TBitBtn
      Left = 264
      Top = 184
      Width = 21
      Height = 21
      Caption = '...'
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 17
      OnClick = BitBtnOwnerClick
    end
    object EditAdmin: TEdit
      Left = 16
      Top = 224
      Width = 81
      Height = 21
      TabOrder = 18
      OnChange = EditNameChange
    end
    object BitBtnAdmin: TBitBtn
      Left = 96
      Top = 224
      Width = 21
      Height = 21
      Caption = '...'
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 19
      OnClick = BitBtnOwnerClick
    end
    object EditTecnico: TEdit
      Left = 184
      Top = 224
      Width = 81
      Height = 21
      TabOrder = 20
      OnChange = EditNameChange
    end
    object BitBtnTecnico: TBitBtn
      Left = 264
      Top = 224
      Width = 21
      Height = 21
      Caption = '...'
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 21
      OnClick = BitBtnOwnerClick
    end
    object EditBill: TEdit
      Left = 16
      Top = 264
      Width = 81
      Height = 21
      TabOrder = 22
      OnChange = EditNameChange
    end
    object BitBtnBill: TBitBtn
      Left = 96
      Top = 264
      Width = 21
      Height = 21
      Caption = '...'
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 23
      OnClick = BitBtnOwnerClick
    end
    object EditRegistrador: TEdit
      Left = 184
      Top = 264
      Width = 81
      Height = 21
      TabOrder = 24
      OnChange = EditNameChange
    end
    object BitBtnRegistrador: TBitBtn
      Left = 264
      Top = 264
      Width = 21
      Height = 21
      Caption = '...'
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 25
      OnClick = BitBtnRegistradorClick
    end
    object EditVendorPassword: TEdit
      Left = 16
      Top = 304
      Width = 97
      Height = 21
      TabOrder = 26
      OnChange = EditNameChange
    end
    object DateTimePickerExpira: TDateTimePicker
      Left = 183
      Top = 304
      Width = 186
      Height = 21
      Date = 37442.424153645800000000
      Time = 37442.424153645800000000
      TabOrder = 27
      OnChange = EditNameChange
    end
    object UpDown: TUpDown
      Left = 327
      Top = 288
      Width = 40
      Height = 16
      Orientation = udHorizontal
      Position = 50
      TabOrder = 28
      OnClick = UpDownClick
    end
  end
  object PanelIzquierda: TPanel
    Left = 0
    Top = 0
    Width = 221
    Height = 339
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object DBGridDomains: TDBGrid
      Left = 0
      Top = 9
      Width = 221
      Height = 290
      Align = alClient
      DataSource = DataSource
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 1
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
          Visible = True
        end>
    end
    object PanelIzquierdaAbajo: TPanel
      Left = 0
      Top = 299
      Width = 221
      Height = 40
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object LabelQuickSearch: TLabel
        Left = 8
        Top = 8
        Width = 65
        Height = 13
        Caption = 'Quick Search'
      end
      object EditQuickSearch: TEdit
        Left = 80
        Top = 4
        Width = 129
        Height = 21
        TabOrder = 0
        OnChange = EditQuickSearchChange
        OnKeyPress = EditQuickSearchKeyPress
      end
    end
    object PanelIzquierdaArriba: TPanel
      Left = 0
      Top = 0
      Width = 221
      Height = 9
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
    end
  end
  object DataSource: TDataSource
    DataSet = MyTableDomains
    Left = 40
    Top = 72
  end
  object IdWhois: TIdWhois
    Host = 'whois.internic.net'
    Left = 520
    Top = 16
  end
  object MyQueryDomains: TMyQuery
    Connection = frmMain.MyConnection
    ParamCheck = False
    Left = 40
    Top = 184
  end
  object MyTableDomains: TMyTable
    TableName = 'domains'
    Connection = frmMain.MyConnection
    AfterScroll = MyTableDomainsAfterScroll
    Left = 40
    Top = 128
    object MyTableDomainsName: TStringField
      FieldName = 'name'
      Origin = 'domains.name'
      Size = 30
    end
    object MyTableDomainsNS1: TStringField
      FieldName = 'ns1'
      Origin = 'domains.ns1'
      Size = 10
    end
    object MyTableDomainsNS2: TStringField
      FieldName = 'ns2'
      Origin = 'domains.ns2'
      Size = 10
    end
    object MyTableDomainsNS3: TStringField
      FieldName = 'ns3'
      Origin = 'domains.ns3'
      Size = 10
    end
    object MyTableDomainsNS4: TStringField
      FieldName = 'ns4'
      Origin = 'domains.ns4'
      Size = 10
    end
    object MyTableDomainsMX1: TStringField
      FieldName = 'mx1'
      Origin = 'domains.mx1'
      Size = 10
    end
    object MyTableDomainsMX2: TStringField
      FieldName = 'mx2'
      Origin = 'domains.mx2'
      Size = 10
    end
    object MyTableDomainsWWW: TStringField
      FieldName = 'www'
      Origin = 'domains.www'
      Size = 10
    end
    object MyTableDomainsOwner: TStringField
      FieldName = 'owner'
      Origin = 'domains.owner'
      Size = 10
    end
    object MyTableDomainsAdminp: TStringField
      FieldName = 'adminp'
      Origin = 'domains.adminp'
      Size = 10
    end
    object MyTableDomainsTechp: TStringField
      FieldName = 'techp'
      Origin = 'domains.techp'
      Size = 10
    end
    object MyTableDomainsBillp: TStringField
      FieldName = 'billp'
      Origin = 'domains.billp'
      Size = 10
    end
    object MyTableDomainsRegistrar: TStringField
      FieldName = 'registrar'
      Origin = 'domains.registrar'
      Size = 10
    end
    object MyTableDomainsVpwd: TStringField
      FieldName = 'vpwd'
      Origin = 'domains.vpwd'
      Size = 10
    end
    object MyTableDomainsExpire: TFloatField
      FieldName = 'expire'
      Origin = 'domains.expire'
    end
  end
end
