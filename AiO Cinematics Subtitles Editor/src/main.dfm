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
      Top = 180
      Width = 61
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Subtitles list:'
    end
    object lblText: TLabel
      Left = 11
      Top = 380
      Width = 48
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'New text:'
    end
    object lblChId: TLabel
      Left = 11
      Top = 271
      Width = 66
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Character ID:'
    end
    object lblLineCnt: TLabel
      Left = 11
      Top = 441
      Width = 58
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Lines count:'
    end
    object Label1: TLabel
      Left = 11
      Top = 314
      Width = 43
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Old text:'
    end
    object editGame: TEdit
      Left = 96
      Top = 24
      Width = 273
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object editHeader: TEdit
      Left = 96
      Top = 56
      Width = 273
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object editSubCnt: TEdit
      Left = 96
      Top = 88
      Width = 273
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object editChId: TEdit
      Left = 96
      Top = 268
      Width = 273
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
    object memoLineCnt: TMemo
      Left = 96
      Top = 428
      Width = 273
      Height = 41
      Anchors = [akLeft, akRight, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object memoText: TMemo
      Left = 96
      Top = 362
      Width = 273
      Height = 60
      Anchors = [akLeft, akRight, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssHorizontal
      TabOrder = 5
      WordWrap = False
      OnChange = memoTextChange
    end
    object lvSub: TListView
      Left = 96
      Top = 115
      Width = 273
      Height = 147
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = '#'
          Width = 40
        end
        item
          Caption = 'CharID'
        end
        item
          AutoSize = True
          Caption = 'Text'
        end>
      ColumnClick = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 6
      ViewStyle = vsReport
      OnClick = lvSubClick
    end
    object mOldSub: TMemo
      Left = 96
      Top = 295
      Width = 273
      Height = 61
      Anchors = [akLeft, akRight, akBottom]
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssHorizontal
      TabOrder = 7
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
        Caption = '&Quit'
        ShortCut = 16465
        OnClick = Exit1Click
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      object miSubsPreview: TMenuItem
        Caption = '&Subtitles preview...'
        ShortCut = 114
        OnClick = miSubsPreviewClick
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
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object ProjectHome1: TMenuItem
        Caption = 'Project Home...'
        ShortCut = 112
        OnClick = ProjectHome1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Caption = 'About'
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
