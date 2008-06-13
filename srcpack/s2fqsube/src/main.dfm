object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '< Titre g'#233'n'#233'r'#233' >'
  ClientHeight = 476
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object sb: TStatusBar
    Left = 0
    Top = 457
    Width = 577
    Height = 19
    Panels = <
      item
        Text = 'Status:'
        Width = 50
      end
      item
        Text = 'Modified'
        Width = 50
      end
      item
        Text = 'Ready'
        Width = 50
      end>
  end
  object GroupBox2: TGroupBox
    Left = 160
    Top = 6
    Width = 409
    Height = 343
    Caption = ' Editor: '
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 166
      Width = 86
      Height = 13
      Caption = 'Subtitles selector:'
    end
    object Label2: TLabel
      Left = 8
      Top = 250
      Width = 26
      Height = 13
      Caption = 'Text:'
    end
    object Label3: TLabel
      Left = 8
      Top = 293
      Width = 77
      Height = 13
      Caption = 'First line length:'
    end
    object Label4: TLabel
      Left = 8
      Top = 320
      Width = 91
      Height = 13
      Caption = 'Second line length:'
    end
    object Label5: TLabel
      Left = 8
      Top = 21
      Width = 72
      Height = 13
      Caption = 'Game version :'
    end
    object Label6: TLabel
      Left = 8
      Top = 48
      Width = 41
      Height = 13
      Caption = 'Char ID:'
    end
    object Label7: TLabel
      Left = 8
      Top = 74
      Width = 43
      Height = 13
      Caption = 'Voice ID:'
    end
    object Label8: TLabel
      Left = 8
      Top = 100
      Width = 75
      Height = 13
      Caption = 'Subtitles count:'
    end
    object lbSubSelect: TListBox
      Left = 170
      Top = 125
      Width = 233
      Height = 97
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbSubSelectClick
    end
    object mSubText: TMemo
      Left = 170
      Top = 228
      Width = 233
      Height = 56
      MaxLength = 90
      TabOrder = 1
      OnChange = mSubTextChange
    end
    object eGameVersion: TEdit
      Left = 170
      Top = 18
      Width = 233
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
      Text = 'Dreamcast'
    end
    object eCharID: TEdit
      Left = 170
      Top = 45
      Width = 233
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
      Text = '03E'
    end
    object eVoiceID: TEdit
      Left = 170
      Top = 71
      Width = 233
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
      Text = 'FEX50'
    end
    object eFirstLineLength: TEdit
      Left = 170
      Top = 290
      Width = 233
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
      Text = '0'
    end
    object eSecondLineLength: TEdit
      Left = 170
      Top = 317
      Width = 233
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 6
      Text = '0'
    end
    object eSubCount: TEdit
      Left = 170
      Top = 98
      Width = 233
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 7
      Text = '100'
    end
  end
  object GroupBox3: TGroupBox
    Left = 6
    Top = 355
    Width = 564
    Height = 90
    Caption = ' Debug : '
    TabOrder = 3
    object mDebug: TMemo
      Left = 6
      Top = 15
      Width = 553
      Height = 70
      Color = clBtnFace
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object GroupBox1: TGroupBox
    Left = 6
    Top = 6
    Width = 148
    Height = 343
    Caption = ' Files list: '
    TabOrder = 0
    object Label9: TLabel
      Left = 6
      Top = 320
      Width = 58
      Height = 13
      Caption = 'Files count :'
    end
    object lbFilesList: TListBox
      Left = 6
      Top = 18
      Width = 136
      Height = 293
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbFilesListClick
    end
    object eFilesCount: TEdit
      Left = 70
      Top = 317
      Width = 72
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = '100'
    end
  end
  object MainMenu1: TMainMenu
    Left = 84
    Top = 28
    object File1: TMenuItem
      Caption = '&File'
      object Scandirectory1: TMenuItem
        Caption = '&Open directory...'
        ShortCut = 16463
        OnClick = Scandirectory1Click
      end
      object Opensinglefile1: TMenuItem
        Caption = 'O&pen single file...'
        ShortCut = 49231
        OnClick = Opensinglefile1Click
      end
      object Closesinglefile1: TMenuItem
        Caption = '&Close single file...'
        OnClick = Closesinglefile1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Save1: TMenuItem
        Caption = '&Save'
        ShortCut = 16467
        OnClick = Save1Click
      end
      object Saveas1: TMenuItem
        Caption = 'S&ave as...'
        ShortCut = 49235
        OnClick = Saveas1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Importsubtitles1: TMenuItem
        Caption = '&Import subtitles...'
        ShortCut = 16457
        OnClick = Importsubtitles1Click
      end
      object Exportsubtitles1: TMenuItem
        Caption = '&Export subtitles...'
        ShortCut = 16453
        OnClick = Exportsubtitles1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Clearfileslist1: TMenuItem
        Caption = '&Clear files list...'
        OnClick = Clearfileslist1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        ShortCut = 16472
        OnClick = Exit1Click
      end
    end
    object ools1: TMenuItem
      Caption = '&Tools'
      object Autosave1: TMenuItem
        Caption = '&Auto-save'
        Checked = True
        OnClick = Autosave1Click
      end
      object Makebackup1: TMenuItem
        Caption = '&Make backup if needed'
        OnClick = Makebackup1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Cleardebuglog1: TMenuItem
        Caption = '&Clear debug log...'
        OnClick = Cleardebuglog1Click
      end
      object Savedebuglog1: TMenuItem
        Caption = '&Save debug log...'
        OnClick = Savedebuglog1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object charsModMenu1: TMenuItem
        Caption = 'Enable characters modification'
        Enabled = False
        OnClick = charsModMenu1Click
      end
      object Multitranslation1: TMenuItem
        Caption = 'Multi-translation...'
        ShortCut = 113
        OnClick = Multitranslation1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About...'
        ShortCut = 123
        OnClick = About1Click
      end
    end
  end
  object odMain: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 16
    Top = 32
  end
  object sdMain: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 48
    Top = 32
  end
end
