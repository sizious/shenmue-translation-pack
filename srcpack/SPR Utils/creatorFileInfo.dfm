object frmFileInfo: TfrmFileInfo
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = '< Dynamic title >'
  ClientHeight = 241
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblName: TLabel
    Left = 8
    Top = 19
    Width = 71
    Height = 13
    Caption = 'Texture name:'
  end
  object lblSize: TLabel
    Left = 8
    Top = 83
    Width = 23
    Height = 13
    Caption = 'Size:'
  end
  object lblOffset: TLabel
    Left = 8
    Top = 51
    Width = 35
    Height = 13
    Caption = 'Offset:'
  end
  object lblFormat: TLabel
    Left = 8
    Top = 115
    Width = 38
    Height = 13
    Caption = 'Format:'
  end
  object lblFormatCode: TLabel
    Left = 8
    Top = 147
    Width = 64
    Height = 13
    Caption = 'Format code:'
  end
  object lblResolution: TLabel
    Left = 8
    Top = 179
    Width = 54
    Height = 13
    Caption = 'Resolution:'
  end
  object editName: TEdit
    Left = 128
    Top = 16
    Width = 161
    Height = 21
    TabOrder = 0
  end
  object editOffset: TEdit
    Left = 128
    Top = 48
    Width = 161
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
  object editSize: TEdit
    Left = 128
    Top = 80
    Width = 161
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
  end
  object cbFormat: TComboBox
    Left = 128
    Top = 112
    Width = 161
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    OnChange = cbFormatChange
    Items.Strings = (
      'DXT1'
      'DXT3'
      'PVR')
  end
  object editFormatCode: TEdit
    Left = 128
    Top = 144
    Width = 161
    Height = 21
    Color = clWhite
    TabOrder = 4
  end
  object editResolution: TEdit
    Left = 128
    Top = 176
    Width = 161
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 5
  end
  object btSave: TButton
    Left = 216
    Top = 216
    Width = 73
    Height = 17
    Caption = 'Save'
    TabOrder = 6
    OnClick = btSaveClick
  end
  object btCancel: TButton
    Left = 136
    Top = 216
    Width = 73
    Height = 17
    Caption = 'Cancel'
    TabOrder = 7
    OnClick = btCancelClick
  end
end
