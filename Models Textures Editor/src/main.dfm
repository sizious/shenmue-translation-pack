object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 
    '< Generated Name > // MT Editor // (C)reated by [big_fury]SiZiOU' +
    'S'
  ClientHeight = 516
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mmMain
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    592
    516)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 2
    Top = 4
    Width = 149
    Height = 383
    Anchors = [akLeft, akTop, akBottom]
    Caption = ' Files list : '
    TabOrder = 0
    DesignSize = (
      149
      383)
    object Label9: TLabel
      Left = 6
      Top = 357
      Width = 58
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Files count :'
      ExplicitTop = 207
    end
    object lbFilesList: TListBox
      Left = 6
      Top = 16
      Width = 137
      Height = 335
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 13
      PopupMenu = pmFilesList
      TabOrder = 0
      OnClick = lbFilesListClick
    end
    object eFilesCount: TEdit
      Left = 70
      Top = 354
      Width = 73
      Height = 21
      Anchors = [akLeft, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = '100'
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 497
    Width = 592
    Height = 19
    Panels = <>
  end
  object pcMain: TPageControl
    Left = 154
    Top = 4
    Width = 438
    Height = 383
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Textures'
      DesignSize = (
        430
        355)
      object lvTexturesList: TListView
        Left = 3
        Top = 3
        Width = 333
        Height = 348
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Index'
          end
          item
            Caption = 'Offset'
          end
          item
            Caption = 'Size'
          end
          item
            Caption = 'Updated'
            Width = 80
          end>
        ColumnClick = False
        ReadOnly = True
        RowSelect = True
        PopupMenu = pmTextures
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = lvTexturesListClick
        OnContextPopup = lvTexturesListContextPopup
        OnKeyUp = lvTexturesListKeyUp
      end
      object bImport: TButton
        Left = 337
        Top = 17
        Width = 92
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '&Import...'
        Enabled = False
        TabOrder = 1
        OnClick = bImportClick
      end
      object bExport: TButton
        Left = 337
        Top = 44
        Width = 92
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '&Export...'
        Enabled = False
        TabOrder = 2
        OnClick = bExportClick
      end
      object bExportAll: TButton
        Left = 337
        Top = 71
        Width = 92
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '&Export all...'
        Enabled = False
        TabOrder = 3
        OnClick = bExportAllClick
      end
      object bUndo: TButton
        Left = 337
        Top = 99
        Width = 92
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '&Undo import...'
        Enabled = False
        TabOrder = 4
        OnClick = bUndoClick
      end
      object rgVersion: TRadioGroup
        Left = 338
        Top = 126
        Width = 91
        Height = 87
        Caption = ' Version : '
        Enabled = False
        Items.Strings = (
          '(Unknow)'
          'MT5/6'
          'MT7'
          'MT7-X')
        TabOrder = 5
      end
    end
    object Sections: TTabSheet
      Caption = 'Sections'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 428
      ExplicitHeight = 323
      DesignSize = (
        430
        355)
      object lvSectionsList: TListView
        Left = 3
        Top = 3
        Width = 425
        Height = 348
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Name'
          end
          item
            Caption = 'Offset'
          end
          item
            Caption = 'Size'
          end>
        ColumnClick = False
        ReadOnly = True
        RowSelect = True
        PopupMenu = pmSections
        TabOrder = 0
        ViewStyle = vsReport
        ExplicitWidth = 423
        ExplicitHeight = 316
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 2
    Top = 390
    Width = 586
    Height = 105
    Anchors = [akLeft, akRight, akBottom]
    Caption = ' Debug : '
    TabOrder = 3
    DesignSize = (
      586
      105)
    object mDebug: TMemo
      Left = 6
      Top = 16
      Width = 573
      Height = 83
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
  end
  object mmMain: TMainMenu
    Left = 20
    Top = 34
    object miFile: TMenuItem
      Caption = '&File'
      object Opendirectory1: TMenuItem
        Caption = '&Open directory...'
        ShortCut = 16463
        OnClick = Opendirectory1Click
      end
      object Open1: TMenuItem
        Caption = '&Open single file...'
        ShortCut = 49231
        OnClick = Open1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Save1: TMenuItem
        Caption = '&Save'
        ShortCut = 16467
        OnClick = Save1Click
      end
      object Saveas1: TMenuItem
        Caption = '&Save as...'
        ShortCut = 49235
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Quit1: TMenuItem
        Caption = '&Quit'
        ShortCut = 16465
        OnClick = Quit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object miUndo: TMenuItem
        Caption = '&Undo changes...'
        ShortCut = 16474
        OnClick = bUndoClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object miImport: TMenuItem
        Caption = '&Import texture...'
        ShortCut = 16457
        OnClick = bImportClick
      end
      object miExport: TMenuItem
        Caption = '&Export texture...'
        ShortCut = 16453
        OnClick = bExportClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object miExportAll: TMenuItem
        Caption = '&Export all...'
        ShortCut = 16449
        OnClick = bExportAllClick
      end
    end
    object miView: TMenuItem
      Caption = '&View'
      object exturespreview1: TMenuItem
        Caption = '&Textures preview...'
        ShortCut = 114
        OnClick = exturespreview1Click
      end
      object exturespreviewontop1: TMenuItem
        Caption = '&Preview on top'
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Savedebuglog1: TMenuItem
        Caption = '&Save debug log...'
      end
      object Cleardebuglog1: TMenuItem
        Caption = '&Clear debug log...'
      end
    end
    object miOptions: TMenuItem
      Caption = '&Options'
      object Autosave1: TMenuItem
        Caption = 'A&uto-save'
      end
      object Makebackup1: TMenuItem
        Caption = 'Make &backup'
      end
    end
    object About1: TMenuItem
      Caption = '&Help'
      object About2: TMenuItem
        Caption = 'A&bout...'
        ShortCut = 123
      end
    end
  end
  object odFileSelect: TOpenDialog
    DefaultExt = 'MT7'
    Filter = 
      'Shenmue Models Files (*.MT5;*.MT6;*.MT7)|*.MT5;*.MT6;*.MT7|Shenm' +
      'ue I Models Files (*.MT5;*.MT6)|*.MT5;*.MT6|Shenmue II Models Fi' +
      'les (*.MT7)|*.MT7|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select the Shenmue Textured Model file...'
    Left = 20
    Top = 64
  end
  object sdExportTex: TSaveDialog
    DefaultExt = 'pvr'
    Filter = 'PowerVR Textures Files (*.pvr)|*.pvr|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Export the selected texture to...'
    Left = 52
    Top = 64
  end
  object bfdExportAllTex: TJvBrowseForFolderDialog
    Title = 'Please select the output directory to store exported textures...'
    Left = 50
    Top = 34
  end
  object pmFilesList: TPopupMenu
    Left = 14
    Top = 158
    object Refresh1: TMenuItem
      Caption = '&Refresh'
      ShortCut = 116
      OnClick = Refresh1Click
    end
  end
  object pmTextures: TPopupMenu
    Left = 508
    Top = 296
    object miImport2: TMenuItem
      Caption = '&Import...'
      OnClick = bImportClick
    end
    object miExport2: TMenuItem
      Caption = '&Export...'
      OnClick = bExportClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object miExportAll2: TMenuItem
      Caption = '&Export all...'
      OnClick = bExportAllClick
    end
  end
  object pmSections: TPopupMenu
    Left = 542
    Top = 264
    object miDumpSection: TMenuItem
      Caption = '&Dump...'
      OnClick = miDumpSectionClick
    end
  end
  object sdDumpSection: TSaveDialog
    DefaultExt = '.bin'
    Filter = 'Generic Binary File (*.BIN)|*.bin|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Dump the selected section to...'
    Left = 540
    Top = 298
  end
  object odImportTexture: TOpenDialog
    DefaultExt = 'PVR'
    Filter = 'PowerVR Textures Files (*.pvr)|*.pvr|All Files (*.*)|*.*'
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select your texture file...'
    Left = 20
    Top = 198
  end
end
