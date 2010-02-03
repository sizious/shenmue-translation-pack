object Form1: TForm1
  Left = 406
  Top = 203
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'HUMANS Dissecter v#VERSION#'
  ClientHeight = 243
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 313
    Height = 81
    Caption = 'Input - HUMANS files (extracted)'
    TabOrder = 0
    object input_dir_edit: TEdit
      Left = 8
      Top = 24
      Width = 297
      Height = 21
      TabOrder = 0
    end
    object browse_input_bt: TButton
      Left = 232
      Top = 56
      Width = 75
      Height = 17
      Caption = 'Browse'
      TabOrder = 1
      OnClick = browse_input_btClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 92
    Width = 313
    Height = 81
    Caption = 'Output directory'
    TabOrder = 1
    object output_dir_edit: TEdit
      Left = 8
      Top = 24
      Width = 297
      Height = 21
      TabOrder = 0
    end
    object browse_output_bt: TButton
      Left = 232
      Top = 56
      Width = 75
      Height = 17
      Caption = 'Browse'
      TabOrder = 1
      OnClick = browse_output_btClick
    end
  end
  object dissect_bt: TButton
    Left = 232
    Top = 200
    Width = 89
    Height = 17
    Caption = 'Dissect !'
    TabOrder = 2
    OnClick = dissect_btClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 226
    Width = 329
    Height = 17
    Panels = <
      item
        Width = 50
      end>
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 200
    Width = 161
    Height = 17
    Smooth = True
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 176
    Top = 200
    Width = 49
    Height = 17
    BevelOuter = bvLowered
    Caption = '0%'
    TabOrder = 5
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 179
    Width = 145
    Height = 17
    Caption = 'Generate only resume file'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object XPManifest1: TXPManifest
    Left = 16
    Top = 58
  end
end
