object Form1: TForm1
  Left = 361
  Top = 124
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'IDX Creator v2'
  ClientHeight = 202
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 313
    Height = 65
    Caption = 'Input - Modified AFS'
    TabOrder = 0
    object input_afs_txt: TEdit
      Left = 8
      Top = 16
      Width = 297
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object BrowseAfsBt: TButton
      Left = 248
      Top = 40
      Width = 57
      Height = 17
      Caption = 'Browse'
      TabOrder = 1
      OnClick = BrowseAfsBtClick
    end
  end
  object CreateIdxBt: TButton
    Left = 240
    Top = 160
    Width = 81
    Height = 17
    Caption = 'Create IDX'
    TabOrder = 1
    OnClick = CreateIdxBtClick
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 80
    Width = 313
    Height = 65
    Caption = 'Output - IDX file'
    TabOrder = 2
    object output_idx_txt: TEdit
      Left = 8
      Top = 16
      Width = 297
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object BrowseIdxBt: TButton
      Left = 248
      Top = 40
      Width = 57
      Height = 17
      Caption = 'Browse'
      TabOrder = 1
      OnClick = BrowseIdxBtClick
    end
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 160
    Width = 177
    Height = 17
    Min = 0
    Max = 100
    Smooth = True
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 192
    Top = 160
    Width = 41
    Height = 17
    BevelOuter = bvLowered
    Caption = '0%'
    TabOrder = 4
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 185
    Width = 329
    Height = 17
    Panels = <
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 16
    Top = 48
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 48
    Top = 48
  end
end
