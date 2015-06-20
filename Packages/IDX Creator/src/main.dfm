object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '< Dynamic title >'
  ClientHeight = 290
  ClientWidth = 393
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 59
    Width = 377
    Height = 85
    Caption = '    '
    TabOrder = 0
    object lblOldIdx: TLabel
      Left = 8
      Top = 27
      Width = 60
      Height = 13
      Caption = 'Original IDX:'
    end
    object lblOldAfs: TLabel
      Left = 8
      Top = 57
      Width = 62
      Height = 13
      Caption = 'Original AFS:'
    end
    object editOldIdx: TEdit
      Left = 80
      Top = 24
      Width = 217
      Height = 21
      TabOrder = 0
    end
    object editOldAfs: TEdit
      Left = 80
      Top = 56
      Width = 217
      Height = 21
      TabOrder = 1
    end
    object btBrowseOldIdx: TButton
      Left = 303
      Top = 26
      Width = 65
      Height = 17
      Caption = 'Browse'
      TabOrder = 2
      OnClick = btBrowseOldIdxClick
    end
    object btBrowseOldAfs: TButton
      Left = 303
      Top = 58
      Width = 65
      Height = 17
      Caption = 'Browse'
      TabOrder = 3
      OnClick = btBrowseOldAfsClick
    end
  end
  object templateChkBox: TCheckBox
    Left = 20
    Top = 56
    Width = 121
    Height = 17
    Caption = 'Create with template'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = templateChkBoxClick
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 152
    Width = 377
    Height = 83
    Caption = ' Needed files: '
    TabOrder = 2
    object lblModAfs: TLabel
      Left = 8
      Top = 22
      Width = 66
      Height = 13
      Caption = 'Modified AFS:'
    end
    object lblNewIdx: TLabel
      Left = 8
      Top = 54
      Width = 45
      Height = 13
      Caption = 'New IDX:'
    end
    object editModAfs: TEdit
      Left = 80
      Top = 18
      Width = 217
      Height = 21
      TabOrder = 0
    end
    object editNewIdx: TEdit
      Left = 80
      Top = 50
      Width = 217
      Height = 21
      TabOrder = 1
    end
    object btBrowseModAfs: TButton
      Left = 303
      Top = 20
      Width = 65
      Height = 17
      Caption = 'Browse'
      TabOrder = 2
      OnClick = btBrowseModAfsClick
    end
    object btSaveNewIdx: TButton
      Left = 303
      Top = 52
      Width = 65
      Height = 17
      Caption = 'Save to'
      TabOrder = 3
      OnClick = btSaveNewIdxClick
    end
  end
  object btGo: TButton
    Left = 304
    Top = 248
    Width = 73
    Height = 17
    Caption = 'Go !'
    TabOrder = 3
    OnClick = btGoClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 273
    Width = 393
    Height = 17
    Panels = <
      item
        Width = 50
      end>
  end
  object cbConfig: TCheckBox
    Left = 8
    Top = 248
    Width = 137
    Height = 17
    Caption = 'Auto-save config at exit'
    TabOrder = 5
  end
  object rgGame: TRadioGroup
    Left = 8
    Top = 8
    Width = 377
    Height = 44
    Caption = 'Select the game to generate the proper IDX format : '
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Shenmue I'
      'Shenmue II')
    TabOrder = 6
    OnClick = rgGameClick
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 229
    Top = 247
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 260
    Top = 248
  end
  object appEvents: TApplicationEvents
    OnException = appEventsException
    Left = 198
    Top = 246
  end
end
