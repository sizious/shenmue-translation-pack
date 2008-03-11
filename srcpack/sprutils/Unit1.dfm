object Form1: TForm1
  Left = 496
  Top = 196
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'SPR Utils v1.0.1'
  ClientHeight = 456
  ClientWidth = 353
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 337
    Height = 257
    TabOrder = 0
    object ListBox1: TListBox
      Left = 8
      Top = 24
      Width = 321
      Height = 201
      ItemHeight = 13
      TabOrder = 0
    end
    object SaveSprBt: TButton
      Left = 240
      Top = 232
      Width = 41
      Height = 17
      Caption = 'Save'
      TabOrder = 1
      OnClick = SaveSprBtClick
    end
    object GzipCheckBx: TCheckBox
      Left = 288
      Top = 232
      Width = 41
      Height = 17
      Hint = 'If you want to compress the output file to gz.'
      Caption = 'Gzip'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object LoadListBt: TButton
      Left = 8
      Top = 232
      Width = 57
      Height = 17
      Caption = 'Load list'
      TabOrder = 3
      OnClick = LoadListBtClick
    end
    object DeleteItemBt: TButton
      Left = 136
      Top = 232
      Width = 65
      Height = 17
      Caption = 'Delete Item'
      TabOrder = 4
    end
    object CreationRadioBt: TRadioButton
      Left = 8
      Top = 0
      Width = 57
      Height = 17
      Caption = 'Creation'
      TabOrder = 5
      OnClick = CreationRadioBtClick
    end
    object ClearListBt: TButton
      Left = 72
      Top = 232
      Width = 57
      Height = 17
      Caption = 'Clear list'
      TabOrder = 6
      OnClick = ClearListBtClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 272
    Width = 337
    Height = 161
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 27
      Height = 13
      Caption = 'Input:'
    end
    object Label2: TLabel
      Left = 8
      Top = 72
      Width = 78
      Height = 13
      Caption = 'Output directory:'
    end
    object SprInputEdit: TEdit
      Left = 8
      Top = 40
      Width = 257
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object SprBrowseBt: TButton
      Left = 272
      Top = 40
      Width = 57
      Height = 17
      Caption = 'Browse'
      TabOrder = 1
      OnClick = SprBrowseBtClick
    end
    object OutputDirEdit: TEdit
      Left = 8
      Top = 88
      Width = 257
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object DirBrowseBt: TButton
      Left = 272
      Top = 88
      Width = 57
      Height = 17
      Caption = 'Browse'
      TabOrder = 3
      OnClick = DirBrowseBtClick
    end
    object StartExtractBt: TButton
      Left = 8
      Top = 128
      Width = 97
      Height = 17
      Caption = 'Go!'
      TabOrder = 4
      OnClick = StartExtractBtClick
    end
    object ExtractionRadioBt: TRadioButton
      Left = 8
      Top = 0
      Width = 73
      Height = 17
      Caption = 'Extraction'
      TabOrder = 5
      OnClick = ExtractionRadioBtClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 440
    Width = 353
    Height = 16
    Panels = <
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 24
    Top = 40
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 56
    Top = 40
  end
end
