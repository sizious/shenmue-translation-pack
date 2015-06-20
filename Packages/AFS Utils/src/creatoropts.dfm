object frmCreatorOpts: TfrmCreatorOpts
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = 'AFS Creator Options'
  ClientHeight = 209
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 265
    Height = 81
    Caption = 'Block size'
    TabOrder = 0
    object lblBytes: TLabel
      Left = 224
      Top = 19
      Width = 27
      Height = 13
      Caption = 'bytes'
    end
    object Label1: TLabel
      Left = 16
      Top = 51
      Width = 65
      Height = 13
      Caption = 'Custom value'
    end
    object cbBlockSize: TComboBox
      Left = 16
      Top = 16
      Width = 202
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbBlockSizeChange
    end
    object editBlockCustom: TEdit
      Left = 87
      Top = 48
      Width = 164
      Height = 21
      Enabled = False
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 104
    Width = 265
    Height = 65
    Caption = 'Misc.'
    TabOrder = 1
    object cbPadding: TCheckBox
      Left = 8
      Top = 16
      Width = 209
      Height = 17
      Caption = '512 kilobytes padding before 1st file'
      TabOrder = 0
      OnClick = cbPaddingClick
    end
    object cbEndList: TCheckBox
      Left = 8
      Top = 40
      Width = 233
      Height = 17
      Caption = 'Write files list'
      TabOrder = 1
      OnClick = cbEndListClick
    end
  end
  object btConfirm: TButton
    Left = 184
    Top = 184
    Width = 89
    Height = 17
    Caption = 'Ok'
    TabOrder = 2
    OnClick = btConfirmClick
  end
end
