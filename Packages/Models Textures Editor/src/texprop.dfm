object frmTexProp: TfrmTexProp
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Texture properties'
  ClientHeight = 230
  ClientWidth = 248
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lvTexturesProperties: TListView
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 242
    Height = 224
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 100
      end
      item
        AutoSize = True
        Caption = 'Value'
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
end
