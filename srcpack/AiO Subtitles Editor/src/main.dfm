object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = '< Dynamic title >'
  ClientHeight = 509
  ClientWidth = 561
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    561
    509)
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 492
    Width = 561
    Height = 17
    Panels = <
      item
        Alignment = taCenter
        Text = 'Status:'
        Width = 50
      end
      item
        Alignment = taCenter
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 161
    Height = 476
    Anchors = [akLeft, akTop, akBottom]
    Caption = 'Files list'
    TabOrder = 1
    DesignSize = (
      161
      476)
    object lblFileCnt: TLabel
      Left = 35
      Top = 446
      Width = 55
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Files count:'
      ExplicitTop = 432
    end
    object lbMain: TListBox
      Left = 8
      Top = 16
      Width = 145
      Height = 420
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 13
      PopupMenu = PopupMenu1
      TabOrder = 0
      OnClick = lbMainClick
    end
    object editFileCnt: TEdit
      Left = 96
      Top = 443
      Width = 57
      Height = 21
      Anchors = [akLeft, akBottom]
      Color = clBtnFace
      TabOrder = 1
      Text = '0'
    end
  end
  object GroupBox2: TGroupBox
    Left = 176
    Top = 8
    Width = 377
    Height = 476
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Informations'
    TabOrder = 2
    DesignSize = (
      377
      476)
    object lblGame: TLabel
      Left = 11
      Top = 27
      Width = 31
      Height = 13
      Caption = 'Game:'
    end
    object lblHeader: TLabel
      Left = 11
      Top = 59
      Width = 39
      Height = 13
      Caption = 'Header:'
    end
    object lblSubCnt: TLabel
      Left = 11
      Top = 91
      Width = 75
      Height = 13
      Caption = 'Subtitles count:'
    end
    object lblSubList: TLabel
      Left = 11
      Top = 152
      Width = 61
      Height = 13
      Caption = 'Subtitles list:'
    end
    object lblText: TLabel
      Left = 11
      Top = 324
      Width = 26
      Height = 13
      Anchors = [akLeft]
      Caption = 'Text:'
      ExplicitTop = 261
    end
    object lblChId: TLabel
      Left = 11
      Top = 211
      Width = 66
      Height = 13
      Caption = 'Character ID:'
    end
    object lblLineCnt: TLabel
      Left = 11
      Top = 433
      Width = 58
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Lines count:'
      ExplicitTop = 342
    end
    object editGame: TEdit
      Left = 144
      Top = 24
      Width = 225
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object editHeader: TEdit
      Left = 144
      Top = 56
      Width = 225
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object editSubCnt: TEdit
      Left = 144
      Top = 88
      Width = 225
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object lbSub: TListBox
      Left = 144
      Top = 120
      Width = 225
      Height = 81
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 3
      OnClick = lbSubClick
    end
    object editChId: TEdit
      Left = 144
      Top = 208
      Width = 225
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object memoLineCnt: TMemo
      Left = 144
      Top = 408
      Width = 225
      Height = 52
      Anchors = [akLeft, akRight, akBottom]
      Color = clBtnFace
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 5
    end
    object memoText: TMemo
      Left = 144
      Top = 240
      Width = 225
      Height = 161
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssHorizontal
      TabOrder = 6
      WordWrap = False
      OnChange = memoTextChange
    end
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 32
    object File1: TMenuItem
      Caption = 'File'
      object Openfiles1: TMenuItem
        Caption = 'Open files...'
        ShortCut = 16463
        OnClick = Openfiles1Click
      end
      object Opendirectory1: TMenuItem
        Caption = 'Open directory...'
        OnClick = Opendirectory1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Save1: TMenuItem
        Caption = 'Save...'
        ShortCut = 16467
        OnClick = Save1Click
      end
      object Saveto1: TMenuItem
        Caption = 'Save as...'
        OnClick = Saveto1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Closeselectedfile1: TMenuItem
        Caption = 'Close selected file...'
        OnClick = Closeselectedfile1Click
      end
      object Closeallfiles1: TMenuItem
        Caption = 'Close all files...'
        OnClick = Closeallfiles1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Tools1: TMenuItem
      Caption = 'Tools'
      object Exportsubtitles1: TMenuItem
        Caption = 'Export subtitles'
        object Selectedfile1: TMenuItem
          Caption = 'Selected file...'
          OnClick = Selectedfile1Click
        end
        object Massexportation1: TMenuItem
          Caption = 'Mass exportation...'
          OnClick = Massexportation1Click
        end
      end
      object Importsubtitles1: TMenuItem
        Caption = 'Import subtitles...'
        OnClick = Importsubtitles1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Enablecharactersmodification1: TMenuItem
        Caption = 'Characters modification'
        object ShenmueI1: TMenuItem
          Caption = 'Shenmue I'
          OnClick = ShenmueI1Click
        end
        object ShenmueII1: TMenuItem
          Caption = 'Shenmue II'
          OnClick = ShenmueII1Click
        end
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 56
    Top = 32
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 88
    Top = 32
  end
  object JvBrowseFolder1: TJvBrowseForFolderDialog
    Options = [odStatusAvailable, odNewDialogStyle, odNoNewButtonFolder]
    Left = 24
    Top = 64
  end
  object PopupMenu1: TPopupMenu
    Left = 56
    Top = 64
    object Closeselectedfile2: TMenuItem
      Caption = 'Close selected file...'
      OnClick = Closeselectedfile2Click
    end
  end
end
