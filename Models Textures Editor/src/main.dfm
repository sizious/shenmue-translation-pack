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
      OnContextPopup = lbFilesListContextPopup
      OnDblClick = miPropertiesClick
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
  object pcMain: TPageControl
    Left = 154
    Top = 4
    Width = 438
    Height = 383
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
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
            Width = 85
          end
          item
            Caption = 'Size'
            Width = 85
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
        Top = 98
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
        Anchors = [akTop, akRight]
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
      DesignSize = (
        430
        355)
      object lvSectionsList: TListView
        Left = 3
        Top = 3
        Width = 333
        Height = 348
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Name'
            Width = 100
          end
          item
            Caption = 'Offset'
            Width = 100
          end
          item
            Caption = 'Size'
            Width = 100
          end>
        ColumnClick = False
        ReadOnly = True
        RowSelect = True
        PopupMenu = pmSections
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = lvSectionsListClick
        OnContextPopup = lvSectionsListContextPopup
      end
      object bDumpSection: TButton
        Left = 337
        Top = 17
        Width = 92
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '&Dump...'
        Enabled = False
        TabOrder = 1
        OnClick = miDumpSectionClick
      end
      object bDumpAll: TButton
        Left = 337
        Top = 44
        Width = 92
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'D&ump all...'
        Enabled = False
        TabOrder = 2
        OnClick = bDumpAllClick
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
    TabOrder = 2
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
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 497
    Width = 592
    Height = 19
    Panels = <
      item
        Text = 'Status:'
        Width = 50
      end
      item
        Text = 'Modified'
        Width = 70
      end
      item
        Text = 'Ready'
        Width = 50
      end>
  end
  object mmMain: TMainMenu
    Left = 20
    Top = 34
    object miFile: TMenuItem
      Caption = '&File'
      object miOpenDirectory: TMenuItem
        Caption = 'Open &directory...'
        ShortCut = 16463
        OnClick = miOpenDirectoryClick
      end
      object miOpenFiles: TMenuItem
        Caption = 'O&pen files...'
        ShortCut = 49231
        OnClick = miOpenFilesClick
      end
      object miReload: TMenuItem
        Caption = '&Reload...'
        OnClick = miReloadClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miSave: TMenuItem
        Caption = '&Save'
        ShortCut = 16467
        OnClick = miSaveClick
      end
      object miSaveAs: TMenuItem
        Caption = 'S&ave as...'
        ShortCut = 49235
        OnClick = miSaveAsClick
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object miClose: TMenuItem
        Caption = 'C&lose'
        OnClick = miCloseClick
      end
      object miCloseAll: TMenuItem
        Caption = '&Close all...'
        OnClick = miCloseAllClick
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object miProperties: TMenuItem
        Caption = '&Properties...'
        ShortCut = 115
        OnClick = miPropertiesClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miQuit: TMenuItem
        Caption = '&Quit'
        ShortCut = 16465
        OnClick = miQuitClick
      end
    end
    object miEdit: TMenuItem
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
      object miTexturesPreview: TMenuItem
        Caption = '&Textures preview...'
        ShortCut = 114
        OnClick = miTexturesPreviewClick
      end
      object miTexturesProperties: TMenuItem
        Caption = 'Textures properties...'
        ShortCut = 117
        OnClick = miTexturesPropertiesClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object miClearDebug: TMenuItem
        Caption = '&Clear debug log...'
        OnClick = miClearDebugClick
      end
      object miSaveDebug: TMenuItem
        Caption = '&Save debug log...'
        OnClick = miSaveDebugClick
      end
    end
    object miOptions: TMenuItem
      Caption = '&Options'
      object miAutoSave: TMenuItem
        Caption = 'A&uto-save'
        ShortCut = 118
        OnClick = miAutoSaveClick
      end
      object miMakeBackup: TMenuItem
        Caption = 'Make &backup'
        ShortCut = 119
        OnClick = miMakeBackupClick
      end
    end
    object miHelp: TMenuItem
      Caption = '&Help'
      object miProjectHome: TMenuItem
        Caption = '&Project home...'
        ShortCut = 112
        OnClick = miProjectHomeClick
      end
      object miCheckForUpdate: TMenuItem
        Caption = '&Check for update...'
        OnClick = miCheckForUpdateClick
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object miAbout: TMenuItem
        Caption = 'A&bout...'
        ShortCut = 123
        OnClick = miAboutClick
      end
    end
  end
  object odFileSelect: TOpenDialog
    DefaultExt = 'MT7'
    Filter = 
      'Shenmue Models Files (*.MT5;*.MT6;*.MT7)|*.MT5;*.MT6;*.MT7|Shenm' +
      'ue I Models Files (*.MT5;*.MT6)|*.MT5;*.MT6|Shenmue II Models Fi' +
      'les (*.MT7)|*.MT7|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select the Shenmue Textured Model file...'
    Left = 20
    Top = 64
  end
  object sdExportTex: TSaveDialog
    DefaultExt = 'PVR'
    Filter = 'PowerVR Textures Files (*.pvr)|*.pvr|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Export the selected texture to...'
    Left = 52
    Top = 64
  end
  object bfdExportAllTex: TJvBrowseForFolderDialog
    Title = 'Please select the output directory to store exported textures...'
    Left = 52
    Top = 34
  end
  object pmFilesList: TPopupMenu
    Left = 22
    Top = 160
    object miProperties2: TMenuItem
      Caption = '&Properties...'
      Default = True
      ShortCut = 115
      OnClick = miPropertiesClick
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object miLocateOnDisk: TMenuItem
      Caption = '&Locate on disk...'
      ShortCut = 16460
      OnClick = miLocateOnDiskClick
    end
    object miReload2: TMenuItem
      Caption = 'Re&load...'
      OnClick = miReloadClick
    end
    object miClose2: TMenuItem
      Caption = 'Close...'
      OnClick = miCloseClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object miCloseAll2: TMenuItem
      Caption = '&Close all...'
      OnClick = miCloseAllClick
    end
    object miExportFilesList: TMenuItem
      Caption = 'Ex&port files list...'
      ShortCut = 49221
      OnClick = miExportFilesListClick
    end
    object miBrowseDirectory: TMenuItem
      Caption = '&Browse directory...'
      ShortCut = 16450
      OnClick = miBrowseDirectoryClick
    end
    object miRefresh: TMenuItem
      Caption = '&Refresh'
      ShortCut = 116
      OnClick = miRefreshClick
    end
  end
  object pmTextures: TPopupMenu
    Left = 508
    Top = 296
    object miTexturesPreview2: TMenuItem
      Caption = 'Preview...'
      ShortCut = 114
      OnClick = miTexturesPreviewClick
    end
    object miTexturesProperties2: TMenuItem
      Caption = 'Properties...'
      ShortCut = 117
      OnClick = miTexturesPropertiesClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object miUndo2: TMenuItem
      Caption = '&Undo...'
      ShortCut = 16474
      OnClick = bUndoClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object miImport2: TMenuItem
      Caption = '&Import...'
      ShortCut = 16457
      OnClick = bImportClick
    end
    object miExport2: TMenuItem
      Caption = '&Export...'
      ShortCut = 16453
      OnClick = bExportClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object miExportAll2: TMenuItem
      Caption = '&Export all...'
      ShortCut = 16449
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
    object N11: TMenuItem
      Caption = '-'
    end
    object miDumpAll2: TMenuItem
      Caption = 'D&ump all...'
      OnClick = bDumpAllClick
    end
  end
  object sdDumpSection: TSaveDialog
    DefaultExt = 'BIN'
    Filter = 'Generic Binary File (*.BIN)|*.BIN|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Select the output file where to dump the section...'
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
  object sdExportList: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Export the files list to...'
    Left = 20
    Top = 94
  end
  object sdSaveAs: TSaveDialog
    DefaultExt = '(generated)'
    Filter = '(generated)'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save the current editor state to the file...'
    Left = 52
    Top = 94
  end
  object sdSaveDebug: TSaveDialog
    DefaultExt = 'log'
    Filter = 
      'Debug Log Files (*.log)|*.log|Text Files (*.txt)|*.txt|All Files' +
      ' (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save debug log as...'
    Left = 20
    Top = 230
  end
  object bfdDumpSections: TJvBrowseForFolderDialog
    Title = 
      'Please select the output directory to store the dumped sections.' +
      '..'
    Left = 52
    Top = 230
  end
end
