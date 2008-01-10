object blocksize_form: Tblocksize_form
  Left = 679
  Top = 184
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = 'Block size'
  ClientHeight = 97
  ClientWidth = 217
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 30
    Height = 13
    Caption = 'Block:'
  end
  object Label2: TLabel
    Left = 32
    Top = 48
    Width = 38
    Height = 13
    Caption = 'Custom:'
  end
  object set_block_bt: TButton
    Left = 144
    Top = 72
    Width = 65
    Height = 17
    Caption = 'Set'
    TabOrder = 0
    OnClick = set_block_btClick
  end
  object block_dropdown: TComboBox
    Left = 48
    Top = 8
    Width = 161
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = block_dropdownChange
  end
  object custom_block_edit: TEdit
    Left = 80
    Top = 40
    Width = 129
    Height = 21
    TabOrder = 2
  end
end
