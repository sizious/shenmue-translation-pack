object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '%Dynamic Caption%'
  ClientHeight = 260
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 4
    Top = 223
    Width = 417
    Height = 2
  end
  object btnMake: TButton
    Left = 219
    Top = 231
    Width = 98
    Height = 25
    Caption = 'Make'
    TabOrder = 0
    OnClick = btnMakeClick
  end
  object btnQuit: TButton
    Left = 323
    Top = 231
    Width = 98
    Height = 25
    Caption = 'Quit'
    TabOrder = 1
    OnClick = btnQuitClick
  end
  object GroupBox1: TGroupBox
    Left = 307
    Top = 2
    Width = 114
    Height = 57
    Caption = ' Options: '
    TabOrder = 2
    object CheckBox1: TCheckBox
      Left = 10
      Top = 14
      Width = 97
      Height = 17
      Caption = 'Auto-mount'
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 10
      Top = 33
      Width = 79
      Height = 17
      Caption = 'Run nullDC'
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 2
    Width = 293
    Height = 146
    Caption = ' Presets: '
    TabOrder = 3
    object Label2: TLabel
      Left = 8
      Top = 15
      Width = 252
      Height = 13
      Caption = 'Select the preset to use, then click the Make button.'
    end
    object ListBox1: TListBox
      Left = 8
      Top = 34
      Width = 277
      Height = 103
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 307
    Top = 65
    Width = 114
    Height = 83
    Caption = ' Configuration: '
    TabOrder = 4
    object Button2: TButton
      Left = 8
      Top = 17
      Width = 97
      Height = 25
      Caption = 'Presets...'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 9
      Top = 48
      Width = 96
      Height = 25
      Caption = 'Settings...'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 154
    Width = 413
    Height = 63
    Caption = ' Progression: '
    TabOrder = 5
    object lblProgress: TLabel
      Left = 8
      Top = 17
      Width = 30
      Height = 13
      Caption = 'Idle...'
    end
    object ProgressBar1: TProgressBar
      Left = 8
      Top = 36
      Width = 396
      Height = 19
      TabOrder = 0
    end
  end
end
