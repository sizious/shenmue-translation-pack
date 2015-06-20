object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = '< Titre dynamique >'
  ClientHeight = 432
  ClientWidth = 513
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
  DesignSize = (
    513
    432)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 153
    Height = 393
    Anchors = [akLeft, akTop, akBottom]
    Caption = 'Files list'
    TabOrder = 0
    DesignSize = (
      153
      393)
    object lblFilesCnt: TLabel
      Left = 8
      Top = 362
      Width = 55
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Files count:'
    end
    object sprListBox: TListBox
      Left = 8
      Top = 16
      Width = 137
      Height = 337
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      PopupMenu = PopupMenu1
      TabOrder = 0
      OnClick = sprListBoxClick
      OnContextPopup = sprListBoxContextPopup
    end
    object editListCnt: TEdit
      Left = 69
      Top = 359
      Width = 76
      Height = 21
      Anchors = [akLeft, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = '0'
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 415
    Width = 513
    Height = 17
    Panels = <
      item
        Width = 50
      end>
  end
  object GroupBox2: TGroupBox
    Left = 168
    Top = 8
    Width = 337
    Height = 393
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Informations'
    TabOrder = 2
    DesignSize = (
      337
      393)
    object lblHeader: TLabel
      Left = 16
      Top = 32
      Width = 39
      Height = 13
      Caption = 'Header:'
    end
    object lblGraphCnt: TLabel
      Left = 16
      Top = 64
      Width = 75
      Height = 13
      Caption = 'Graphics count:'
    end
    object lblDataSize: TLabel
      Left = 16
      Top = 96
      Width = 74
      Height = 13
      Caption = 'Total data size:'
    end
    object lblGraphList: TLabel
      Left = 16
      Top = 208
      Width = 45
      Height = 13
      Anchors = [akLeft]
      Caption = 'Graphics:'
    end
    object lblGraphInfos: TLabel
      Left = 16
      Top = 328
      Width = 105
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Current graphic infos:'
    end
    object lblGraphSize: TLabel
      Left = 16
      Top = 360
      Width = 100
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Current graphic size:'
    end
    object editGraphSize: TEdit
      Left = 136
      Top = 357
      Width = 185
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object editGraphInfos: TEdit
      Left = 136
      Top = 325
      Width = 185
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object editDataSize: TEdit
      Left = 136
      Top = 93
      Width = 185
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object editGraphCnt: TEdit
      Left = 136
      Top = 61
      Width = 185
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
    object editHeader: TEdit
      Left = 136
      Top = 29
      Width = 185
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object currSprList: TListBox
      Left = 136
      Top = 128
      Width = 185
      Height = 185
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      MultiSelect = True
      PopupMenu = PopupMenu2
      TabOrder = 5
      OnClick = currSprListClick
      OnContextPopup = currSprListContextPopup
    end
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 32
    object File1: TMenuItem
      Caption = 'File'
      object SPRCreator1: TMenuItem
        Caption = 'New...'
        ShortCut = 16462
        OnClick = SPRCreator1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Opendirectory1: TMenuItem
        Caption = 'Open directory...'
        ShortCut = 16463
        OnClick = Opendirectory1Click
      end
      object Openfiles1: TMenuItem
        Caption = 'Open files...'
        ShortCut = 49231
        OnClick = Openfiles1Click
      end
      object N1: TMenuItem
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
        Caption = 'Quit'
        ShortCut = 16465
        OnClick = Exit1Click
      end
    end
    object Tools1: TMenuItem
      Caption = 'Tools'
      object Extractselectedfiles1: TMenuItem
        Caption = 'Extract selected graphics...'
        ShortCut = 16453
        OnClick = Extractselectedfiles1Click
      end
      object Extractallfiles1: TMenuItem
        Caption = 'Extract all graphics...'
        ShortCut = 16449
        OnClick = Extractallfiles1Click
      end
      object Massextraction1: TMenuItem
        Caption = 'Mass extraction...'
        OnClick = Massextraction1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Savexmllist1: TMenuItem
        Caption = 'Save XML files list at extraction'
        Checked = True
        OnClick = Savexmllist1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About...'
        ShortCut = 123
        OnClick = About1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 56
    Top = 32
  end
  object JvBrowseFolder1: TJvBrowseForFolderDialog
    Left = 88
    Top = 32
  end
  object PopupMenu1: TPopupMenu
    Left = 24
    Top = 64
    object Closeselectedfile2: TMenuItem
      Caption = 'Close selected files...'
      OnClick = Closeselectedfile2Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 56
    Top = 64
    object Extractselectedfiles2: TMenuItem
      Caption = 'Extract selected graphics...'
      OnClick = Extractselectedfiles2Click
    end
    object Extractallfiles2: TMenuItem
      Caption = 'Extract all graphics...'
      OnClick = Extractallfiles2Click
    end
  end
end
