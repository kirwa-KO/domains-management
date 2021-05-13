object frmReporteExpiracion: TfrmReporteExpiracion
  Left = 0
  Top = 0
  Caption = 'Report'
  ClientHeight = 358
  ClientWidth = 541
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PanelAbajo: TPanel
    Left = 0
    Top = 317
    Width = 541
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 208
    ExplicitTop = 128
    ExplicitWidth = 185
    object BitBtnClose: TBitBtn
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Close'
      DoubleBuffered = True
      ModalResult = 2
      ParentDoubleBuffered = False
      TabOrder = 0
    end
  end
  object ListView: TListView
    Left = 0
    Top = 0
    Width = 541
    Height = 317
    Align = alClient
    Columns = <
      item
        Caption = 'Domain Name'
        Width = 200
      end
      item
        Caption = 'Expiration Date'
        Width = 120
      end
      item
        Alignment = taCenter
        Caption = 'Expired'
      end>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    ExplicitTop = -6
  end
end
