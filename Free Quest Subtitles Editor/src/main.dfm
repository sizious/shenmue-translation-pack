object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = '< Title Generated > // Free Quest Editor'
  ClientHeight = 504
  ClientWidth = 572
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gbFilesList: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 29
    Width = 148
    Height = 349
    Margins.Right = 0
    Align = alLeft
    Caption = ' Files list: '
    Padding.Left = 2
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    TabOrder = 0
    ExplicitHeight = 341
    object lbFilesList: TListBox
      Left = 4
      Top = 17
      Width = 140
      Height = 301
      Align = alClient
      ItemHeight = 13
      PopupMenu = pmFilesList
      TabOrder = 0
      OnClick = lbFilesListClick
      OnContextPopup = lbFilesListContextPopup
      OnDblClick = lbFilesListDblClick
      OnKeyPress = lbFilesListKeyPress
      ExplicitHeight = 293
    end
    object Panel2: TPanel
      Left = 4
      Top = 318
      Width = 140
      Height = 27
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitTop = 310
      DesignSize = (
        140
        27)
      object Label9: TLabel
        Left = 5
        Top = 7
        Width = 58
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = 'Files count :'
      end
      object eFilesCount: TEdit
        Left = 68
        Top = 4
        Width = 72
        Height = 21
        Anchors = [akRight, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
        Text = '100'
      end
    end
  end
  object pcSubs: TPageControl
    AlignWithMargins = True
    Left = 154
    Top = 29
    Width = 415
    Height = 349
    ActivePage = tsEditor
    Align = alClient
    TabOrder = 1
    OnChange = pcSubsChange
    ExplicitHeight = 341
    object tsEditor: TTabSheet
      Caption = '&Editor'
      ExplicitHeight = 313
      DesignSize = (
        407
        321)
      object Label4: TLabel
        Left = 146
        Top = 301
        Width = 91
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Second line length:'
        ExplicitTop = 319
      end
      object Label3: TLabel
        Left = 8
        Top = 302
        Width = 77
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'First line length:'
        ExplicitTop = 320
      end
      object Label2: TLabel
        Left = 8
        Top = 272
        Width = 65
        Height = 13
        Anchors = [akLeft, akRight, akBottom]
        AutoSize = False
        Caption = 'New text:'
        ExplicitTop = 290
      end
      object Label1: TLabel
        Left = 8
        Top = 166
        Width = 86
        Height = 13
        Caption = 'Subtitles selector:'
      end
      object Label8: TLabel
        Left = 288
        Top = 301
        Width = 75
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Subtitles count:'
        ExplicitTop = 319
      end
      object Label6: TLabel
        Left = 173
        Top = 81
        Width = 51
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Char ID:'
      end
      object lOldText: TLabel
        Left = 8
        Top = 230
        Width = 86
        Height = 13
        Anchors = [akLeft, akRight, akBottom]
        AutoSize = False
        Caption = '<Generated>'
        ExplicitTop = 248
      end
      object lGender: TLabel
        Left = 8
        Top = 54
        Width = 39
        Height = 13
        Caption = 'Gender:'
      end
      object Label7: TLabel
        Left = 8
        Top = 80
        Width = 52
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Voice ID :'
      end
      object Label5: TLabel
        Left = 8
        Top = 6
        Width = 69
        Height = 13
        Caption = 'Game version:'
      end
      object eSecondLineLength: TEdit
        Left = 246
        Top = 298
        Width = 30
        Height = 21
        Anchors = [akLeft, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
        Text = '0'
        ExplicitTop = 290
      end
      object eFirstLineLength: TEdit
        Left = 104
        Top = 298
        Width = 30
        Height = 21
        Anchors = [akLeft, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
        Text = '0'
        ExplicitTop = 290
      end
      object mSubText: TMemo
        Left = 104
        Top = 258
        Width = 300
        Height = 37
        Anchors = [akLeft, akRight, akBottom]
        Lines.Strings = (
          'LINE1'
          'LINE2')
        MaxLength = 90
        TabOrder = 2
        OnChange = mSubTextChange
        ExplicitTop = 250
      end
      object eSubCount: TEdit
        Left = 368
        Top = 298
        Width = 36
        Height = 21
        Anchors = [akLeft, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
        Text = '100'
        ExplicitTop = 290
      end
      object eCharID: TEdit
        Left = 230
        Top = 77
        Width = 63
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 4
        Text = '<CharID>'
      end
      object lvSubsSelect: TJvListView
        Left = 104
        Top = 104
        Width = 300
        Height = 111
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'CharID'
          end
          item
            Caption = 'Code'
          end
          item
            Caption = 'Subtitle'
            Width = 196
          end>
        ColumnClick = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 5
        ViewStyle = vsReport
        OnClick = lvSubsSelectClick
        OnKeyUp = lvSubsSelectKeyUp
        ColumnsOrder = '0=50,1=50,2=196'
        Groups = <>
        ExtendedColumns = <
          item
          end
          item
          end
          item
          end>
        ExplicitHeight = 103
      end
      object mOldSubEd: TMemo
        Left = 104
        Top = 218
        Width = 300
        Height = 37
        Anchors = [akLeft, akRight, akBottom]
        Color = clBtnFace
        Lines.Strings = (
          'LINE1'
          'LINE2')
        MaxLength = 90
        ReadOnly = True
        TabOrder = 6
        ExplicitTop = 210
      end
      object rbMale: TRadioButton
        Left = 164
        Top = 52
        Width = 54
        Height = 17
        Caption = 'Male'
        Enabled = False
        TabOrder = 7
      end
      object rbFemale: TRadioButton
        Left = 224
        Top = 52
        Width = 54
        Height = 17
        Caption = 'Female'
        Enabled = False
        TabOrder = 8
      end
      object Panel1: TPanel
        Left = 304
        Top = 0
        Width = 100
        Height = 100
        Anchors = [akTop, akRight]
        BevelOuter = bvLowered
        BevelWidth = 2
        Caption = '(no face)'
        ParentBackground = False
        TabOrder = 9
        object iFace: TImage
          Left = 2
          Top = 2
          Width = 96
          Height = 96
        end
      end
      object Panel4: TPanel
        Left = 3
        Top = 29
        Width = 290
        Height = 19
        BevelOuter = bvNone
        TabOrder = 10
        object lCharType: TLabel
          Left = 5
          Top = 3
          Width = 52
          Height = 13
          Caption = 'Char type:'
        end
        object rbAdult: TRadioButton
          Left = 161
          Top = 1
          Width = 54
          Height = 17
          Caption = 'Adult'
          Enabled = False
          TabOrder = 0
        end
        object rbChild: TRadioButton
          Left = 221
          Top = 1
          Width = 54
          Height = 17
          Caption = 'Child'
          Enabled = False
          TabOrder = 1
        end
        object rbatUnknow: TRadioButton
          Left = 101
          Top = 1
          Width = 54
          Height = 17
          Caption = 'Unknow'
          Checked = True
          Enabled = False
          TabOrder = 2
          TabStop = True
        end
      end
      object eVoiceID: TEdit
        Left = 104
        Top = 78
        Width = 63
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 11
        Text = '<VoiceID>'
      end
      object eGame: TEdit
        Left = 104
        Top = 3
        Width = 189
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 12
        Text = '<Game Version String>'
      end
      object rbcgUnknow: TRadioButton
        Left = 104
        Top = 52
        Width = 54
        Height = 17
        Caption = 'Unknow'
        Checked = True
        Enabled = False
        TabOrder = 13
        TabStop = True
      end
    end
    object tsMultiTrad: TTabSheet
      Caption = '&Global'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        407
        321)
      object GroupBox2: TGroupBox
        Left = 3
        Top = 3
        Width = 401
        Height = 184
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' Global-Translation available strings : '
        TabOrder = 0
        ExplicitHeight = 176
        DesignSize = (
          401
          184)
        object bMTClear: TButton
          Left = 316
          Top = 156
          Width = 80
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Clear...'
          TabOrder = 0
          OnClick = bMTClearClick
          ExplicitTop = 148
        end
        object tvMultiSubs: TTreeView
          Left = 8
          Top = 16
          Width = 387
          Height = 139
          Anchors = [akLeft, akTop, akRight, akBottom]
          Images = ilMultiSubs
          Indent = 19
          PopupMenu = pmMultiSubs
          ReadOnly = True
          RightClickSelect = True
          TabOrder = 1
          OnClick = tvMultiSubsClick
          OnContextPopup = tvMultiSubsContextPopup
          OnKeyUp = tvMultiSubsKeyUp
        end
        object bMTExpandAll: TButton
          Left = 156
          Top = 156
          Width = 80
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Expand all'
          TabOrder = 2
          OnClick = bMTExpandAllClick
          ExplicitTop = 148
        end
        object bMTCollapseAll: TButton
          Left = 236
          Top = 156
          Width = 80
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Collapse all'
          TabOrder = 3
          OnClick = bMTCollapseAllClick
          ExplicitTop = 148
        end
      end
      object GroupBox4: TGroupBox
        Left = 3
        Top = 190
        Width = 401
        Height = 129
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Anchors = [akLeft, akRight, akBottom]
        Caption = ' Replace the string with : '
        TabOrder = 1
        ExplicitTop = 182
        DesignSize = (
          401
          129)
        object Label15: TLabel
          Left = 9
          Top = 40
          Width = 26
          Height = 13
          Caption = 'Text:'
        end
        object Label16: TLabel
          Left = 9
          Top = 102
          Width = 77
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'First line length:'
        end
        object Label17: TLabel
          Left = 148
          Top = 102
          Width = 91
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Second line length:'
          ExplicitTop = 130
        end
        object eMTFirstLineLength: TEdit
          Left = 95
          Top = 99
          Width = 41
          Height = 21
          Anchors = [akLeft, akBottom]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
          Text = '0'
        end
        object eMTSecondLineLength: TEdit
          Left = 243
          Top = 99
          Width = 41
          Height = 21
          Anchors = [akLeft, akBottom]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
          Text = '0'
        end
        object mMTOldSub: TMemo
          Left = 95
          Top = 16
          Width = 300
          Height = 37
          Anchors = [akLeft, akRight, akBottom]
          Color = clBtnFace
          Lines.Strings = (
            'LINE1'
            'LINE2')
          MaxLength = 90
          ReadOnly = True
          TabOrder = 2
        end
        object mMTNewSub: TMemo
          Left = 95
          Top = 56
          Width = 300
          Height = 37
          Anchors = [akLeft, akRight, akBottom]
          Lines.Strings = (
            'LINE1'
            'LINE2')
          MaxLength = 90
          TabOrder = 3
          OnChange = mMTNewSubChange
        end
        object bMultiTranslate: TButton
          Left = 304
          Top = 97
          Width = 92
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Translate'
          Enabled = False
          TabOrder = 4
          OnClick = bMultiTranslateClick
        end
      end
      object bMTRetrieveSubs: TButton
        Left = 78
        Top = 159
        Width = 80
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Retrieve...'
        TabOrder = 2
        OnClick = bMTRetrieveSubsClick
        ExplicitTop = 151
      end
    end
  end
  object gbDebug: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 381
    Width = 566
    Height = 101
    Margins.Top = 0
    Align = alBottom
    Caption = ' Debug : '
    Padding.Left = 2
    Padding.Top = 1
    Padding.Right = 2
    Padding.Bottom = 2
    TabOrder = 2
    ExplicitTop = 373
    object mDebug: TMemo
      Left = 4
      Top = 16
      Width = 558
      Height = 81
      Align = alClient
      Color = clBtnFace
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object sb: TStatusBar
    Left = 0
    Top = 485
    Width = 572
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
    ExplicitTop = 477
  end
  object tbMain: TJvToolBar
    Left = 0
    Top = 0
    Width = 572
    Height = 26
    DisabledImages = ilToolBarDisabled
    EdgeBorders = [ebTop]
    Images = ilToolBar
    List = True
    TabOrder = 4
    Transparent = True
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object tbOpen: TToolButton
      Left = 8
      Top = 0
      Hint = 'Open the IPAC file'
      Caption = 'Open'
      ImageIndex = 0
    end
    object tbReload: TToolButton
      Left = 31
      Top = 0
      ImageIndex = 2
    end
    object tbSave: TToolButton
      Left = 54
      Top = 0
      Caption = 'tbSave'
      ImageIndex = 1
    end
    object ToolButton4: TToolButton
      Left = 77
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object tbImportSubtitles: TToolButton
      Left = 85
      Top = 0
      Caption = 'tbImportSubtitles'
      ImageIndex = 13
    end
    object tbExportSubtitles: TToolButton
      Left = 108
      Top = 0
      Caption = 'tbExportSubtitles'
      ImageIndex = 12
    end
    object ToolButton9: TToolButton
      Left = 131
      Top = 0
      Width = 8
      Caption = 'ToolButton9'
      ImageIndex = 14
      Style = tbsSeparator
    end
    object tbDebugLog: TToolButton
      Left = 139
      Top = 0
      Caption = 'tbDebugLog'
      ImageIndex = 7
    end
    object tbPreview: TToolButton
      Left = 162
      Top = 0
      Caption = 'tbPreview'
      ImageIndex = 8
    end
    object tbOriginalTextField: TToolButton
      Left = 185
      Top = 0
      Caption = 'tbOriginalTextField'
      ImageIndex = 18
    end
    object tbCharset: TToolButton
      Left = 208
      Top = 0
      Caption = 'tbCharset'
      ImageIndex = 10
    end
    object ToolButton5: TToolButton
      Left = 231
      Top = 0
      Width = 8
      Caption = 'ToolButton5'
      ImageIndex = 12
      Style = tbsSeparator
    end
    object tbBatchImportSubtitles: TToolButton
      Left = 239
      Top = 0
      Caption = 'tbBatchImportSubtitles'
      ImageIndex = 14
    end
    object tbBatchExportSubtitles: TToolButton
      Left = 262
      Top = 0
      Caption = 'tbBatchExportSubtitles'
      ImageIndex = 15
    end
    object ToolButton6: TToolButton
      Left = 285
      Top = 0
      Width = 8
      Caption = 'ToolButton6'
      ImageIndex = 12
      Style = tbsSeparator
    end
    object tbAutoSave: TToolButton
      Left = 293
      Top = 0
      Caption = 'tbAutoSave'
      ImageIndex = 16
    end
    object tbMakeBackup: TToolButton
      Left = 316
      Top = 0
      Caption = 'tbMakeBackup'
      ImageIndex = 17
    end
    object ToolButton2: TToolButton
      Left = 339
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 10
      Style = tbsSeparator
    end
    object tbAbout: TToolButton
      Left = 347
      Top = 0
      Caption = 'tbAbout'
      ImageIndex = 11
    end
  end
  object MainMenu: TMainMenu
    Left = 80
    Top = 52
    object miFile: TMenuItem
      Caption = '&File'
      object miScanDirectory: TMenuItem
        Caption = '&Open directory...'
        Hint = 
          'Scan the selected directory content to find editable PAKS Shenmu' +
          'e files.'
        ShortCut = 16463
        OnClick = miScanDirectoryClick
      end
      object miOpenSingleFile: TMenuItem
        Caption = 'O&pen files...'
        Hint = 'Open selected file(s) in the editor.'
        ShortCut = 49231
        OnClick = miOpenSingleFileClick
      end
      object miReloadCurrentFile: TMenuItem
        Caption = '&Reload...'
        Enabled = False
        Hint = 'Reload the selected file from disk.'
        OnClick = miReloadCurrentFileClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object miSave: TMenuItem
        Caption = '&Save'
        Hint = 'Save the current file.'
        ShortCut = 16467
        OnClick = miSaveClick
      end
      object miSaveAs: TMenuItem
        Caption = 'S&ave as...'
        Hint = 'Save the current file as another file.'
        ShortCut = 49235
        OnClick = miSaveAsClick
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object miCloseFile: TMenuItem
        Caption = '&Close...'
        Hint = 'Close the current file.'
        OnClick = miCloseFileClick
      end
      object miClearFilesList: TMenuItem
        Caption = 'Close &all...'
        Hint = 'Close every files. Changes not saved will be lost.'
        OnClick = miClearFilesListClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object miImportSubs: TMenuItem
        Caption = '&Import subtitles...'
        Hint = 'Import subtitles from XML file.'
        ShortCut = 16457
        OnClick = miImportSubsClick
      end
      object miExportSubs: TMenuItem
        Caption = '&Export subtitles...'
        Hint = 'Export subtitle to a XML file.'
        ShortCut = 16453
        OnClick = miExportSubsClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miExportToCinematicScript: TMenuItem
        Caption = 'Export to Cinema&tic script...'
        Hint = 
          'Export to the SRF import script format for the Cinematics Subtit' +
          'les Editor.'
        ShortCut = 16468
        OnClick = miExportToCinematicScriptClick
      end
      object N20: TMenuItem
        Caption = '-'
      end
      object miFileProperties2: TMenuItem
        Caption = '&Properties...'
        Hint = 'Show the advanced file properties dialog.'
        ShortCut = 115
        OnClick = miFileProperties2Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miQuit: TMenuItem
        Caption = '&Quit'
        Hint = 'Exit the application.'
        ShortCut = 16465
        OnClick = miQuitClick
      end
    end
    object miView: TMenuItem
      Caption = '&View'
      object miSubsPreview: TMenuItem
        Caption = 'S&ubtitles preview...'
        Hint = 'Show the subtitle previewer.'
        ShortCut = 114
        OnClick = miSubsPreviewClick
      end
      object N19: TMenuItem
        Caption = '-'
      end
      object miClearDebugLog: TMenuItem
        Caption = '&Clear debug log...'
        Hint = 'Clear the debug history.'
        OnClick = miClearDebugLogClick
      end
      object miSaveDebugLog: TMenuItem
        Caption = '&Save debug log...'
        Hint = 'Save the debug history.'
        OnClick = miSaveDebugLogClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object miShowOriginalText: TMenuItem
        Caption = 'Original text in field'
        Hint = 
          'Show untouched original subtitles extracted from the game in the' +
          ' old text field.'
        ShortCut = 122
        OnClick = miShowOriginalTextClick
      end
      object miOriginalColumnList: TMenuItem
        Caption = 'Original column in list'
        Hint = 
          'Show an additional column with the original subtitle text in the' +
          ' view.'
        ShortCut = 16506
        OnClick = miOriginalColumnListClick
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object miEnableCharsMod: TMenuItem
        Caption = '&Decode subtitles'
        Enabled = False
        Hint = 'Translate the Shenmue charset to Windows charset and vice-versa.'
        ShortCut = 117
        OnClick = miEnableCharsModClick
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object miBrowseDirectory2: TMenuItem
        Caption = '&Browse directory...'
        Hint = 'Open the selected directory inside the Windows Explorer.'
        ShortCut = 16450
        OnClick = miBrowseDirectoryClick
      end
      object miReloadDir2: TMenuItem
        Caption = '&Refresh'
        Hint = 'Rescan the selected directory to find files.'
        ShortCut = 116
        OnClick = miReloadDirClick
      end
    end
    object miTools: TMenuItem
      Caption = '&Tools'
      object miMultiTranslate: TMenuItem
        Caption = 'M&ulti-translate'
        Hint = 'Enable or disable subtitle multi-translation inside the Editor.'
        ShortCut = 113
        OnClick = miMultiTranslateClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object miBatchImportSubs: TMenuItem
        Caption = 'Batch imp&ort...'
        Hint = 'Import subtitles in mass.'
        ShortCut = 49225
        OnClick = miBatchImportSubsClick
      end
      object miBatchExportSubs: TMenuItem
        Caption = '&Batch export...'
        Hint = 'Export subtitles in mass.'
        ShortCut = 49221
        OnClick = miBatchExportSubsClick
      end
      object N23: TMenuItem
        Caption = '-'
      end
      object miBatchSRF: TMenuItem
        Caption = 'Batch Cinematics script...'
        Hint = 'Export to Cinematics SRF scripts in mass.'
        ShortCut = 49236
        OnClick = miBatchSRFClick
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object miFacesExtractor: TMenuItem
        Caption = '&Faces extractor...'
        Hint = 'Extract NPC faces textures files from associated PAKF files.'
        ShortCut = 120
        OnClick = miFacesExtractorClick
      end
    end
    object miOptions: TMenuItem
      Caption = '&Options'
      object miAutoSave: TMenuItem
        Caption = '&Auto-save'
        Checked = True
        Hint = 'Auto-saving the current file.'
        ShortCut = 118
        OnClick = miAutoSaveClick
      end
      object miMakeBackup: TMenuItem
        Caption = '&Make backup'
        Hint = 'Auto-create a copy of the current file before saving it.'
        ShortCut = 119
        OnClick = miMakeBackupClick
      end
      object miReloadDirAtStartup: TMenuItem
        Caption = 'Reload folder at startup'
        Hint = 'Rescan the selected directory at startup.'
        OnClick = miReloadDirAtStartupClick
      end
    end
    object miHelp: TMenuItem
      Caption = '&Help'
      object miProjectHome: TMenuItem
        Caption = '&Project home...'
        Hint = 'Visit the project home web site.'
        ShortCut = 112
        OnClick = miProjectHomeClick
      end
      object miCheckForUpdate: TMenuItem
        Caption = '&Check for update...'
        Hint = 'Open the SourceForge page of the project.'
        OnClick = miCheckForUpdateClick
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object miAbout: TMenuItem
        Caption = '&About...'
        Hint = 'Display the about box dialog.'
        ShortCut = 123
        OnClick = miAboutClick
      end
    end
    object miDEBUG: TMenuItem
      Caption = 'DEBUG'
      object miDEBUG_InitTextDatabase: TMenuItem
        Caption = 'InitTextDatabase'
        OnClick = miDEBUG_InitTextDatabaseClick
      end
      object miDEBUG_TextDatabaseCorrector: TMenuItem
        Caption = 'Test TextDatabaseCorrector'
        OnClick = miDEBUG_TextDatabaseCorrectorClick
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object miDEBUG_DumpMultiTranslationTextData: TMenuItem
        Caption = 'Dump Multi-Translation Text Data'
        Enabled = False
        OnClick = miDEBUG_DumpMultiTranslationTextDataClick
      end
      object miDEBUG_DumpMultiTranslationCacheList: TMenuItem
        Caption = 'Dump Multi-Translation Cache List'
        Enabled = False
        OnClick = miDEBUG_DumpMultiTranslationCacheListClick
      end
      object N18: TMenuItem
        Caption = '-'
      end
      object miDEBUG_GenerateTestException: TMenuItem
        Caption = 'Generate Test Exception'
        OnClick = miDEBUG_GenerateTestExceptionClick
      end
      object miDEBUG_StrongTest: TMenuItem
        Caption = 'STRONG Import/Export Test'
        OnClick = miDEBUG_StrongTestClick
      end
      object N22: TMenuItem
        Caption = '-'
      end
      object miDEBUG_TestSRFDB: TMenuItem
        Caption = 'SRF Database Test'
        OnClick = miDEBUG_TestSRFDBClick
      end
    end
  end
  object odMain: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 16
    Top = 52
  end
  object sdMain: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 48
    Top = 52
  end
  object pmSubsSelect: TPopupMenu
    Left = 44
    Top = 300
    object miCopySub: TMenuItem
      Caption = '&Copy'
      Hint = 'Copy the selected subtitle in the clip board.'
      ShortCut = 16451
      OnClick = miCopySubClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object miSaveListToFile: TMenuItem
      Caption = 'S&ave list to file...'
      Hint = 'Save the current subtitles list to a file.'
      OnClick = miSaveListToFileClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object miImportSubs2: TMenuItem
      Caption = '&Import subtitles...'
      ShortCut = 16457
      OnClick = miImportSubsClick
    end
    object miExportSubs2: TMenuItem
      Caption = '&Export subtitles...'
      ShortCut = 16453
      OnClick = miExportSubsClick
    end
  end
  object sdSubsList: TSaveDialog
    DefaultExt = 'csv'
    Filter = 
      'CSV Files (*.csv)|*.csv|Text Files (*.txt)|*.txt|All Files (*.*)' +
      '|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save subtitles list to...'
    Left = 12
    Top = 300
  end
  object pmFilesList: TPopupMenu
    Left = 14
    Top = 120
    object miFileProperties: TMenuItem
      Caption = '&Properties...'
      Default = True
      RadioItem = True
      ShortCut = 115
      OnClick = miFilePropertiesClick
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object miLocateFile: TMenuItem
      Caption = '&Locate on disk...'
      Hint = 'Open the Windows Explorer and select the current file on it.'
      ShortCut = 16460
      OnClick = miLocateFileClick
    end
    object miReloadCurrentFile2: TMenuItem
      Caption = 'Re&load...'
      OnClick = miReloadCurrentFileClick
    end
    object miCloseFile2: TMenuItem
      Caption = 'Close...'
      OnClick = miCloseFileClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object miImportSubs3: TMenuItem
      Caption = '&Import subtitles...'
      ShortCut = 16457
      OnClick = miImportSubsClick
    end
    object miExportSubs3: TMenuItem
      Caption = '&Export subtitles...'
      ShortCut = 16453
      OnClick = miExportSubsClick
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object miExportToCinematicScript2: TMenuItem
      Caption = 'Export to Cinema&tic script...'
      Hint = '(generated)'
      ShortCut = 16468
      OnClick = miExportToCinematicScriptClick
    end
    object N21: TMenuItem
      Caption = '-'
    end
    object miClearFilesList2: TMenuItem
      Caption = '&Close all...'
      OnClick = miClearFilesListClick
    end
    object miExportFilesList: TMenuItem
      Caption = 'Ex&port files list...'
      Hint = 'Exports the current files list to a text file.'
      ShortCut = 49221
      OnClick = miExportFilesListClick
    end
    object miBrowseDirectory: TMenuItem
      Caption = '&Browse directory...'
      Hint = 'Open the selected directory inside the Windows Explorer.'
      ShortCut = 16450
      OnClick = miBrowseDirectoryClick
    end
    object miReloadDir: TMenuItem
      Caption = '&Refresh'
      ShortCut = 116
      OnClick = miReloadDirClick
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    OnHint = ApplicationEventsHint
    Left = 16
    Top = 86
  end
  object bfdExportSubs: TJvBrowseForFolderDialog
    Title = 'Select output directory to export all files subtitles:'
    Left = 46
    Top = 86
  end
  object ilMultiSubs: TImageList
    Left = 514
    Top = 140
    Bitmap = {
      494C010109000B00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000047BBD5000F8CA9000F8CA9000F8C
      A9000F8CA9000F8CA9000F8CA9000F8CA9000F8CA9000F8CA9000F8CA9000F8C
      A9000F8CA9000F8CA9000F8CA90047BBD5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000037B4D10025C9E90018C5F10015C2
      F00015C2F00015C2F00015C2F00015C2F00015C2F00015C2F00015C2F00015C2
      F00015C2F00015C2F00021C3E40037B4D1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000072CADF0018AECF0021CCF2001BC8
      F10015C2F00015C2F00015C2F000000000000000000018C5F1001BC8F1001BC8
      F1001BC8F10021CCF20017ACCD0072CADF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000037B4D10021C3E40028D3
      F40021CCF2001BC8F10021CCF200000000000000000021CCF20026D1F30028D3
      F40028D3F40021C3E40037B4D100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000082D0E20018AECF0034DB
      F40034DBF40034DBF40026D1F30028D3F40034DBF40034DBF40030D9F50034DB
      F40034DBF40018AECF0082D0E200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000037B4D1002BC6
      DF003FE6F8003EE4F7003EE4F7001C6871001C6871003EE4F7003EE4F7003EE4
      F7002BC6DF0037B4D10000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000017AC
      CD0047EAF6004BF0FA0049EEF900000000000000000045EAF90045EAF9003EE4
      F70017ACCD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000037B4
      D1002BC6DF004BF0FA004BF0FA00000000000000000049EEF90049EEF9002BC6
      DF0037B4D1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000017ACCD0048E8F30051F4FB0000000000000000004BF0FA0048E8F30017AC
      CD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000037B4D10026BFD9005BF6FB00000000000000000051F4FB002BC6DF0037B4
      D100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000017ACCD0048E8F30051F4FB0051F4FB0048E8F30018AECF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000037B4D10024BBD60051F4FB0051F4FB002BC6DF0037B4D1000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000017ACCD0048E8F30048E8F30017ACCD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000037B4D10024BBD6002BC6DF0037B4D100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000026AECE0026AECE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFDFF797979FF7979
      79FF797979FF797979FF797979FF797979FF797979FF797979FF797979FF7979
      79FF797979FF797979FF797979FFFDFDFDFF0000000000000000000000000000
      00000000000000000000000000006668692A7171711100000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFDFF868686FFF0F0
      F2FFF1F1F3FFF1F2F3FFF2F2F4FFF3F3F4FFF3F4F5FFF4F5F6FFF5F5F7FFF6F6
      F7FFF7F7F8FFF7F8F9FF868686FFFDFDFDFF0000000000000000000000000000
      000000000000000000003A94AC343083C2EA2B668C995DBFD501000000000000
      000000000000000000000000000000000000000000003E9745002E903900408A
      49004E905800538157006F7E7000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DFCE
      8400E9CF6500C0BBA90000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFDFF909090FFF1F1
      F3FFF1F2F3FFF2F2F4FFF3F3F5FFF3F4F5FFF4F5F6FFF5F5F7FFF6F6F7FFF7F7
      F8FFF7F8F9FFF8F9FAFF909090FFFDFDFDFF0000000000000000000000000000
      00000000000000000000368AA85E3999DAFF2D70999D4EC0DD01000000000000
      00000000000000000000000000000000000014A220001CC6340033DA560045E5
      6D003ED5610034CE560026BE3E002D8133000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F1D5
      6500F1D56500E5CA650000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFEFF9D9D9DFFF2F2
      F3FFF2F2F4FFF3F3F5FFF4F4F5FFF4F5F6FFF5F5F7FFF6F6F7FFF7F7F8FFF8F8
      F9FFF8F9FAFFF9FAFAFF9D9D9DFFFEFEFEFF0000000000000000000000000000
      00000000000000000000398EAA5E42A2DEFF2C70939F4EC0DD01000000000000
      00000000000000000000000000000000000039AC420022CB3C003BDA5E0051F6
      7A00207687001F7C760036E2520017B82C007492760000000000000000000000
      0000000000000000000000000000000000000000000000000000F2DF9200F1D5
      6500E9CF6500F1D56500C4BB9100000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFEFFACACACFFF2F2
      F4FFF3F3F5FFF4F4F5FFF4F5F6FFF5F6F7FFF6F6F8FFF7F7F8FFF8F8F9FFF8F9
      FAFFF9FAFAFFFAFBFBFFACACACFFFEFEFEFF0000000000000000000000000000
      000000000000000000003B8FAA5E45A3E1FF337899A151C1DD01000000000000
      000000000000000000000000000000000000000000001CC6340034DD590058D3
      5C0054459B00465E7D0029D33F0020A72F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFE26500E9CF
      6500E9CF6500F1D56500E5CA6500000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFEFFADADADFFF3F3
      F5FFF4F4F5FFF4F5F6FFF5F6F7FFF6F7F8FFF7F7F8FFF8F8F9FFF9F9FAFFF9FA
      FBFFFAFBFBFFFBFBFCFFADADADFFFEFEFEFF0000000000000000000000000000
      000000000000000000003A8FAA5E43A3E1FF327BA5BB5BC6E001000000000000
      0000000000000000000000000000000000000000000065B96C001EC538006BAA
      7C007084DD00768C9E0027B427005D945E000000000000000000000000000000
      00000000000000000000000000000000000000000000E5D37F00F1D56500DFCA
      750000000000FFE26500F1D56500CDBE7C000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFEFFB1B1B1FFF4F4
      F6FFF5F5F6FFF5F6F7FFF6F7F8FFF7F8F8FFF8F8F9FFF9F9FAFFF9FAFBFFFAFB
      FBFFFBFCFCFFFBFCFCFFB1B1B1FFFEFEFEFF0000000000000000000000000000
      000000000000000000004196AD5E4BA9E1FF347AA3BC65CBE202000000000000
      000000000000000000000000000000000000000000000000000080B291006EB8
      F60089D0FF007EC1F6004F7B6800000000000000000000000000000000000000
      000000000000000000000000000000000000FFEA9200FBDD6500EED56F000000
      00000000000000000000F1D56500F1D56500BDB89D0000000000000000000000
      00000000000000000000000000000000000000000000FEFEFEFFB3B3B3FFF5F5
      F6FFF5F6F7FFF6F7F8FFF7F8F9FFF8F9F9FFF9F9FAFFF9FAFBFFFAFBFBFFFBFC
      FCFFFBFCFDFFFCFDFDFFB3B3B3FFFEFEFEFF0000000000000000000000000000
      000000000000000000004195AD5E45A5DFFF31759BC171CFE305000000000000
      000000000000000000000000000000000000000000000000000082A9C40089C6
      FD00ADDBFF00BDE4FF00799AC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFE88D00F1D56500E5CA650000000000000000000000
      00000000000000000000000000000000000000000000FEFEFEFFB5B5B5FFF6F6
      F7FFF6F7F8FFF7F8F9FFF8F9F9FFF9F9FAFFFAFAFBFFFAFBFBFFFBFCFCFFFCFC
      FDFFFCFDFDFFFDFEFEFFB5B5B5FFFEFEFEFF0000000000000000000000000000
      000000000000C3EDF204478DA58963D5FDFF55C8F7FC5893A35F72D1E6020000
      00000000000000000000000000000000000000000000000000004F88BD005E94
      BD00B2E0FF00C5E6FF0084A8C80000000000000000001275E100627593000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFE67F00F1D56500DEC56600000000000000
      00000000000000000000000000000000000000000000FEFEFEFFB8B8B8FFF6F7
      F8FFF7F8F9FFF8F9F9FFF9F9FAFFFAFAFBFFFAFBFCFFFBFCFCFFFCFCFDFFFCFD
      FDFFFDFEFEFFFDFEFEFFB8B8B8FFFEFEFEFF0000000000000000000000000000
      0000A9EFF5027BA2B8A071DAFDFF65DFFFFF5AD3FFFF409CE1FB528C9F7281D8
      EB0100000000000000000000000000000000000000000000000033648C003364
      8C00467AA4005282A900547DA400000000005E7EAB00008CF5000E80DB003F66
      9600677687000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFE67F00F1D56500D5C26E000000
      00000000000000000000000000000000000000000000FEFEFEFFBABABAFFF7F8
      F9FFF8F9FAFFF9FAFAFFFAFAFBFFFAFBFCFFFBFCFCFFFCFDFDFFFCFDFDFFFCFD
      FDFFFDFEFEFFFDFEFEFFB8B8B8FFFEFEFEFF0000000000000000000000000000
      00008BC4CB4351B4F6FE5BCDFCFF64D6FEFF60D1FEFF5FD2FCFF3696D8F188CE
      D91A000000000000000000000000000000000000000000000000577E9B003C69
      91003F648D00496E920051749D003180C70000ABFF0000B3FE0000B3FE0000B3
      FE00019BF50037699C007D808500000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFE67F00F1D56500D5C2
      6E000000000000000000000000000000000000000000FEFEFEFFBCBCBCFFF8F9
      FAFFF9FAFAFFFAFAFBFFFAFBFCFFFBFCFCFFFCFDFDFFFCFDFDFFFDFEFEFFFDFE
      FEFFE5E5E6FFDFDFE0FFBABABAFFFEFEFEFF0000000000000000000000000000
      00007FB5C37E5B99CCE07BB1BCB586B1BAB583B1C0B574AEC3B53D99DEEF74AE
      B844000000000000000000000000000000000000000000000000000000006C92
      AE00496E9200718DA5004793CE000095F0000089E20000A7EF0000C4FE0000A7
      EF00019BF5000095F0003272AA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFE67F00F1D5
      6500D5C26E0000000000000000000000000000000000FEFEFEFFBDBDBDFFF9FA
      FAFFFAFBFBFFFBFBFCFFFBFCFCFFFCFDFDFFFCFDFDFFFDFEFEFFFDFEFEFFBABA
      BAFFB8B8B8FFB8B8B8FFBABABAFFFEFEFEFF0000000000000000000000000000
      000089C0CA6C6B8AA8BA62C4D9050000000000000000AAECF0094792D4E690C4
      CE2E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000030ABEF000065CA000037B1000090DC0000DCFE000065
      CA00003CB400007FDB001E90D200000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFEA
      9200F1D56500DEC56600C0BBA9000000000000000000FEFEFEFFBFBFBFFFFAFB
      FBFFFBFBFCFFFBFCFCFFFCFDFDFFFCFDFDFFFDFEFEFFFDFEFEFFFDFEFEFFC5C5
      C5FFF6F6F6FFBBBBBBFFF5F5F5FF000000000000000000000000000000000000
      0000EBEEEF1695C4E0E9417F94796FB1C1149FDEE218638FAD9C5B95BBBEADF1
      F504000000000000000000000000000000000000000000000000000000000000
      000000000000000000004AB0E800009FE5000090DC0000C6EF0000ECFF000090
      DC000074CF00009FE5003895CD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FDDF6A00F1D56500C7BD9C0000000000FEFEFEFFC0C0C0FFFBFB
      FCFFFBFCFCFFFCFDFDFFFCFDFDFFFDFEFEFFFDFEFEFFFBFCFCFFFDFEFEFFCACA
      CAFFBABABAFFF5F6F5FF00000000000000000000000000000000000000000000
      0000000000007BCAD7379AC8DAD47FB5D9F06AA7DBF26DA5C3B2B1E5E9170000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000018BEEF0000F2FF0000FFFF0000FFFF0000FF
      FF0000DCFE003B9BD30000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F4E29C000000000000000000FEFEFEFFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFFBFBFBFF0000000000000000000000000000000000000000000000000000
      0000000000000000000087DCF00177C7D91B79CBDD1300000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000077C8E90042B6E00041B3DE0041B3
      DE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007EC8DA004CB2CC0064B0C400000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D0D0
      D000C7C7C700D0D0D00000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000048C1
      3C0019CC08007897750000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004C3B
      C0002008CC007874960000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008ED7E7005FC4DA005DC0
      D6005DBED60060BFD60044AFCA004BA6C10056B8D4005DC0D6005DBED6005DBE
      D60072C7DB00000000000000000000000000000000000000000000000000C7C7
      C700C7C7C700C7C7C70000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000015E4
      000015E4000015CD000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001B00
      E4001B00E4001600CD0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006DCDE10080D4E40076CD
      E0006FC9DD0067C4DA0044AFCA0043A6C3004EB8D7004EC1DE004EC1DE004EC1
      DE0051C2DE0072C7DB0000000000000000000000000000000000DADADA00C7C7
      C700C7C7C700C7C7C700D0D0D000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000063E4560015E4
      000013D6000015E9000053984E00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006755E4001B00
      E4001A00D6001C00E900584D9700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070D1E40089DAE80080D4
      E40076CDE0006FC9DD0044AFCA0045A8C4004EB8D7004EC1DE004EC1DE004EC1
      DE00D3A549005DBED60000000000000000000000000000000000C7C7C700C7C7
      C700C7C7C700C7C7C700C7C7C700000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001AFA050013D6
      000013D6000015E4000015CD0000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000002405FA001A00
      D6001A00D6001B00E4001600CD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070D1E40092E1EC0089DA
      E80080D4E40076CDE00045B0CA0049A9C40052BAD80051C2DE004EC1DE004EC1
      DE00DDB95D005FC4DA00000000000000000000000000D0D0D000C7C7C700C7C7
      C70000000000D0D0D000C7C7C700C7C7C7000000000000000000000000000000
      0000000000000000000000000000000000000000000041CC350015E9000030BF
      21000000000021F30D0015E4000034A12B000000000000000000000000000000
      000000000000000000000000000000000000000000004934CC001C00E9003320
      BE00000000002A0DF3001B00E4003B2AA0000000000000000000000000000000
      000000000000000000000000000000000000000000007AD7EA009BE7F00092E1
      EC0089DAE80080D4E40045B0CA0049A9C4005CBFDA005BC7E10056C5E00051C2
      DE00ECECEC0067C4DA000000000000000000DADADA00C7C7C700D0D0D0000000
      00000000000000000000C7C7C700C7C7C700D0D0D00000000000000000000000
      00000000000000000000000000000000000065FB560017F600002AD819000000
      0000000000000000000015E4000015E400006591610000000000000000000000
      0000000000000000000000000000000000006A55FB001D00F6003018D8000000
      000000000000000000001B00E4001B00E4006660900000000000000000000000
      000000000000000000000000000000000000000000007AD7EA00A5ECF5009BE7
      F00092E1EC0089DAE8004EB7D00054AFC8005CBFDA0066CDE40066CDE4005BC7
      E100ECECEC005FC4DA0000000000000000000000000000000000000000000000
      00000000000000000000DADADA00C7C7C700C7C7C70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005BFF4B0015E4000015CD000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000604AFF001B00E4001600CD0000000000000000000000
      0000000000000000000000000000000000000000000084E0F000AAF1F700A5EC
      F5009BE7F00092E1EC004EB7D0005BB2C90067C4DA0073D3E8006DCDE10066CD
      E400ECECEC0067C4DA0000000000000000000000000000000000000000000000
      0000000000000000000000000000DADADA00C7C7C700C7C7C700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000046FF310015E4000019B90A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000004730FF001B00E400200AB800000000000000
      0000000000000000000000000000000000000000000084E0F000B0F5F900AAF1
      F700A5ECF500C6F1F60056B8D4005BB2C90069C6DE0082D9EC0073D3E80073D3
      E8006DD0E60067C4DA0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0D0D000C7C7C700C7C7C7000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000037FF250015E9000022AD16000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004124FF001C00E9002A15AC000000
      0000000000000000000000000000000000000000000088E1F200B4F6FA00B0F5
      F900AAF1F700E8FAFC0056B8D40068B9CD0076CDE00088E1F20089DEEE0082D9
      EC006DCDE100A6DDEB0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0D0D000C7C7C700C7C7
      C700000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003FFD2A0015E9000022AD
      1600000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004229FD001C00E9002A15
      AC00000000000000000000000000000000000000000088E1F200B4F6FA00B4F6
      FA00B0F5F900F4FDFE005DC0D60068B9CD0076CDE000A5ECF50097E5F20097E5
      F2006DCDE1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DADADA00C7C7
      C700C7C7C7000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000046FF310015E9
      000020B012000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004730FF001C00
      E9002512AF00000000000000000000000000000000008DE6F400B4F6FA00B4F6
      FA00B4F6FA00FEFFFF005FC4DA0074BED0007DCFE300ACEEF600A5ECF5009BE7
      F0006DCDE1000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DADA
      DA00C7C7C700C7C7C700D0D0D000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000066FE
      570015E9000013C101007F9A7D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006A55
      FB001C00E9001701C000807C990000000000000000008DE6F400B4F6FA00B4F6
      FA00B4F6FA00FEFFFF0064C8DD0078C0D10080D4E400B0F5F900B0F5F900AFED
      F80076CDE0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0D0D000C7C7C700D0D0D0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002BEF160015E40000649D5F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002E15EF001B00E400665E9C00000000008DE6F400B4F6FA00B4F6
      FA00FEFFFF00FEFFFF006DCDE10078C0D100B0F5F900C2FAFD00BCF5FA00B0F5
      F90076CDE0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DADADA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000074EA6800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007767EA0000000000000000008DE6F400B4F6FA00E8FA
      FC0099EAF40084E0F0007EC8DA00BBF7FB00C2FAFD00C2FAFD00C2FAFD00B0F5
      F90086D5E8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AFEDF8008DE6F40088E1
      F20088E1F20088E1F20088DDF10082D9EC0082D9EC0082D9EC007DD5EA0086D5
      E80000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FFFF0000000000000000000000000000
      0000000000000000000000000000000080010000000000008001000000000000
      C003000000000000E007000000000000E007000000000000F00F000000000000
      F00F000000000000F81F000000000000F81F000000000000FC3F000000000000
      FC3F000000000000FE7F0000000000008000FE7FFFFFFFFF8000FC3F81FFE3FF
      8000FC3F00FFE3FF8000FC3F007FC1FF8000FC3F80FFC1FF8000FC3F80FF88FF
      8000FC3FC1FF1C7F8000FC3FC1FFFC7F8000F81FC19FFE3F8000F00FC107FF1F
      8000F00FC001FF8F8000F00FE001FFC78000F18FFC01FFE18001F00FFC01FFF8
      8003F81FFE03FFFD8007FC7FFF0FFFFFFFFFFFFFFFFFF1FFE3FFE3FFE3FF8007
      E3FFE3FFE3FF8003C1FFC1FFC1FF8003C1FFC1FFC1FF800388FF88FF88FF8003
      1C7F1C7F1C7F8003FC7FFC7FFC7F8003FE3FFE3FFE3F8003FF1FFF1FFF1F8003
      FF8FFF8FFF8F8007FFC7FFC7FFC78007FFE1FFE1FFE18007FFF8FFF8FFF88007
      FFFDFFFDFFFD8007FFFFFFFFFFFF800F00000000000000000000000000000000
      000000000000}
  end
  object pmMultiSubs: TPopupMenu
    Left = 514
    Top = 170
    object miGoTo: TMenuItem
      Caption = 'Go to'
      Enabled = False
      OnClick = miGoToClick
    end
  end
  object ilToolBar: TImageList
    Left = 460
    Top = 8
    Bitmap = {
      494C010113001500080010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      000000000000000000000000000000000000F0CFD150BF675FFFAF574FFF9F4F
      4FFF9F4F4FFF9F4F4FFF8F474FFF8F473FFF8F473FFF7F3F3FFF7F373FFF7F37
      3FFF6F373FFF6F372FFF00000000000000000000000000000000000000000000
      000000000000000000009878B1D95756AFFF5756AFFF604FAFFF574F9FFF4747
      8FFF4F3F8FFF453F7FFF37396FFF37396FFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0676FFFF08F8FFFE07F7FFFAF47
      1FFF3F2F1FFFBFB7AFFFBFB7AFFFD0BFBFFFD0C8BFFF4F4F4FFF9F3F2FFF9F3F
      2FFF9F372FFF6F373FFF00000000000000000000000000000000000000000000
      000000000000000000006766BFFF8F7FD0FF6A4FBFFF483F4FFF7F7F7FFFD9D0
      E0FFB7AFAEFF403F4FFF503F9FFF453F7FFF0000000000000000000000000000
      00000000000000000000C7C7C7503F473FFF626262D04F473FFF2F2F2FFF969A
      9680D2E5D230107F10FF3A8E2DE0B4D4B4500000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D06F6FFFFF979FFFF0877FFFE07F
      7FFF6F574FFF3F3F2FFF8F776FFFF0E0E0FFF0E8E0FF8F7F6FFF9F3F2FFF9F3F
      3FFF9F3F2FFF7F373FFF00000000000000000000000000000000000000000000
      00000000000000000000776FBFFF978FE0FF8F7FD0FF523F5FFF605F6FFFAF9F
      ADFFD0BFCEFF584F5EFF503F9FFF453F7FFF0000000000000000F6F5F310F6F5
      F3107F674FFFE9E3E030C7CAC7505F575FFFC7CAC750CED0CE402F2F2FFFB4D6
      B450005F00FF69AE69A0AAD1A560108710FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0776FFFFF9F9FFFF08F8FFFF087
      7FFF6F574FFF000000FF3F3F2FFFF0D8D0FFF0E0D0FF7F775FFFAF473FFFAF47
      3FFF9F3F3FFF7F3F3FFF00000000000000000000000000000000E6C5C260B360
      68F0AF575FFFAF574FFF7777BFFF9797E0FF978FE0FF523F5FFF523F5FFF523F
      5FFF523F5FFF523F5FFF604FAFFF47478FFF00000000EEE9E620866859F07F5F
      4FFF7F5F4FFF7F674FFF00000000D6D4D6409A959AA06F6F6FD03F373FFFB4D6
      B450107F10FF96C6967000000000F0F5F0100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0777FFFFFA7AFFFFF9F9FFFF08F
      8FFF6F574FFF6F574FFF6F574FFF939997FF434E5AFF75625FFFBF574FFFAF4F
      4FFFAF473FFF7F3F3FFF00000000000000000000000000000000BF676FFFD087
      7FFFBF5F4FFF4F473FFF877FD0FFA79FF0FF9797E0FF978FE0FF8F7FD0FF7777
      CFFF776FBFFF705FBFFF684FAFFF574F9FFF000000007F573FFFB6A09290EEE9
      E62086604AF0EEEAE820F3F3F310B6B6B660E6E7E620929292902F2F2FFFD2E6
      D2301F8F1FFF8EBE8780AAD1A5602F9F1FFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E07F7FFFFFAFAFFFFFAFAFFFFF9F
      9FFFF08F8FFFF0877FFFE07F7FFFA395A3FF10B7F0FF1F7FAFFFA45A5FFFBF57
      4FFFAF4F4FFF8F473FFF00000000000000000000000000000000BF6F6FFFE08F
      8FFFD0877FFF5F4F3FFF8787D0FFA7A7F0FF806FCFFF6A5FCFFF624FBFFF5A3F
      AFFF4D1EAFFF532FAFFF705FBFFF574F9FFF000000007F573FFFF6F4F2100000
      0000000000000000000000000000AAAAAA70565656E04A4A4AF0626862C0F1F1
      F110C3DEC3401F8F1FFF108710FFB4D6B4500000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E0878FFFFFB7BFFFFFB7AFFFD05F
      5FFFBF5F4FFFBF574FFFBF4F3FFF937267FF9FF0FFFF8FE8FFFF1F779FFFA45A
      5FFFBF574FFF8F473FFF00000000000000000000000000000000BF777FFFE097
      9FFFE08F8FFF5F4F3FFF958FD0FFB5AFF0FF7A6EE0FFFFFFFFFFF9F0FFFFE9E0
      F0FFD9D0E0FF5A3FAFFF776FBFFF604FAFFF00000000CEBFB660000000000000
      000000000000000000000000000000000000D6D6D640C7C7C750F3F3F3100000
      000000000000F0F6F010F0F6F010000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E08F8FFFFFBFBFFFD0675FFFFFFF
      FFFFFFFFFFFFFFF8F0FFF0F0F0FFF0E8E0FFA2BCC4FFE0FFFFFF7FE8FFFF1F6F
      8FFFA75C5FFF8F474FFF00000000000000000000000000000000D07F7FFFF09F
      9FFFE0979FFFE08F8FFF9797E0FFB7B7FFFF927FEFFFFFFFFFFFFFFFFFFFF9F0
      FFFFE9E0F0FF624FBFFF655F9FFF5756AFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E0979FFFFFBFBFFFD06F6FFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFF8F0FFF0F0F0FFE8E3DDFF9BBBD0FFE0FFFFFF5FE0
      FFFF1F678FFF874F57FF00000000000000000000000000000000D0878FFFF0A7
      AFFFD0776FFFD05F5FFFA59FE0FFC5BFFFFF9A8FFEFFFFFFFFFFFFFFFFFFFFFF
      FFFFF9F0FFFF6A5FCFFF453F7FFF5756AFFFC7C5C7503F3F3FFF6E686EC0555B
      55D02F372FFFDADCDA30C2C2C250C2C5C250D7D6D730CAC8CA40F1F1F1100000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F09F9FFFFFBFBFFFE0776FFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF7C95A1FF77899BFF606B77FF7A8281FFD0FF
      FFFF4FD8FFFF2F4F6FFFDADFE330000000000000000000000000D08F8FFFF0AF
      AFFFE06F6FFFFFFFFFFFAD9FE0FFA59FE0FF9797E0FF958FD0FF8787D0FF877F
      D0FF7777BFFF776FBFFF6766BFFF705FBFFFC7C7C7504F574FFFBCBCBC60B6B9
      B6602F372FFFF2F2F210B6B9B660D7D6D73000000000CAC8CA40BDBBBD500000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0A79FFFFFBFBFFFE07F7FFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF97D2E6FFBFF8FFFFD0FFFFFFBFFFFFFFAFF8
      FFFF7FE8FFFF6FE0FFFF2F475FFFDADFE3300000000000000000E0979FFFFFB7
      BFFFF0877FFFFFFFFFFFFFFFFFFFFFF8F0FFF0E8E0FFBF574FFF9F5F5FFFAF57
      5FFF0000000000000000000000000000000000000000D2D4D240909590A06F6F
      6FD03F373FFFF1F1F110B6B9B660D7D6D73000000000D7D6D730BDBBBD500000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0AFAFFFFFBFBFFFF0878FFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFD7EEF5FF9FD8E0FFE0FFFFFFBFFFFFFF3FD0
      FFFF508298FF97554FFF00000000000000000000000000000000E09F9FFFFFBF
      BFFFFF8F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F0FFD05F5FFF7F3F3FFFAF57
      5FFF00000000000000000000000000000000F3F3F310BCB9BC60E8E8E8209B9B
      9B903F3F3FFFF1F2F110B6B9B660D7D6D730F1F1F110BDBBBD50BDBBBD500000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0AFAFFFFFBFBFFFFF8F8FFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA4D2E6FFBFF8FFFFD0FFFFFFAFF8
      FFFF1FC8FFFF4F777FFFE8E8E820000000000000000000000000E0A79FFFE09F
      9FFFE0979FFFD08F8FFFD0878FFFD07F7FFFBF777FFFBF6F6FFFBF676FFFBF67
      5FFF0000000000000000000000000000000000000000B1B1B170646464E05951
      59F06E6E6EC0F1F1F110B6B9B660C2C5C250DADCDA30CAC8CA40F1F1F1100000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0B7AFFFF0B7AFFFF0AFAFFFF0AF
      AFFFF0A7AFFFF09F9FFFE0979FFFE08F8FFFCC9DA3FF94CCDBFFE0FFFFFFBFFF
      FFFF7FE8FFFF1FC8FFFF596877F0E8E8E8200000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6D4D640C7C7
      C750F3F3F310F1F1F110B6B9B660D7D6D7300000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AAD5E7C0C2F0F0F0D0FF
      FFFFBFFFFFFF5FE0FFFF4ABBE1F0595959F00000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F1F2F110B6B9B660D7D6D7300000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E2F1F740A3D8E5D08FD0
      E0FF8FD0E0FF7FC8E0FF7FAFD0FF6F97AFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DAD9DA30BCB9BC60E4E4E4200000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AF9F8FFF5F472FFF5F472FFF5F472FFF5F472FFF5F472FFF5F47
      2FFF5F472FFF5F472FFF5F472FFF5F472FFF0000000000000000000000000000
      000000000000AF9F8FFF5F472FFF5F472FFF5F472FFF5F472FFF5F472FFF5F47
      2FFF5F472FFF5F472FFF5F472FFF5F472FFF0000000000000000000000000000
      00000000000000000000D0AF9FFFAF5F5FFFAF574FFFAF575FFF9F4F4FFF9F47
      4FFF8F473FFF7F3F3FFF6F372FFF6F373FFF0000000000000000000000000000
      00000000000000000000E6C5C260B36068F0AF575FFFAF574FFF9F4F4FFF8F47
      4FFF8F473FFF7F3F3FFF6F373FFF6F373FFF0000000000000000000000000000
      000000000000AF9F8FFFFFFFFFFFAF9F8FFFAF9F8FFFAF9F8FFFAF9F8FFFAF9F
      8FFFAF9F8FFFAF9F8FFFAF9F8FFF5F472FFF0000000000000000000000000000
      000000000000AF9F8FFFFFFFFFFFAF9F8FFFAF9F8FFFAF9F8FFFAF9F8FFFAF9F
      8FFFAF9F8FFFAF9F8FFFAF9F8FFF5F472FFF0000000000000000000000000000
      00000000000000000000BF676FFFD0877FFFBF5F4FFF4F473FFF7F7F6FFFE0D0
      D0FFBFB7AFFF4F3F3FFF9F3F3FFF7F3F3FFFAF9F8FFF5F472FFF5F472FFF5F47
      2FFF5F472FFF5F472FFFBF676FFFD0877FFFBF5F4FFF4F473FFF7F7F7FFFE0D8
      D0FFAFB7AFFF4F3F3FFF9F473FFF7F3F3FFF0000000000000000000000000000
      000000000000AF9F8FFFFFFFFFFFFFFFFFFFFFF8FFFFF0F0F0FFF0E8E0FFF0E0
      D0FFE0D0D0FFE0C8BFFFAF9F8FFF5F472FFF0000000000000000000000000000
      000000000000AF9F8FFFFFFFFFFFFFFFFFFFFFF8FFFFF0F0F0FFF0E8E0FFF0E0
      D0FFE0D0D0FFE0C8BFFFAF9F8FFF5F472FFFAF9F8FFF5F472FFF5F472FFF5F47
      2FFF5F472FFF5F472FFFBF6F6FFFE08F8FFFD0877FFF5F4F3FFF6F675FFFAFAF
      9FFFD0D0BFFF5F574FFF9F473FFF7F3F3FFFAF9F8FFFFFFFFFFFAF9F8FFFAF9F
      8FFFAF9F8FFFAF9F8FFFBF6F6FFFE08F8FFFD0877FFF5F4F3FFF6F5F5FFFAFAF
      9FFFD0D0BFFF5F574FFF9F473FFF7F3F3FFF0000000000000000000000000000
      000000000000AF9F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F0FFF0F0F0FFF0E0
      D0FF7F674FFFE0D0D0FFAF9F8FFF5F472FFF0000000000000000000000000000
      000000000000AF9F8FFFFFFFFFFFFFD08FFFFFD08FFFFFD08FFFFFE0AFFFFFE0
      AFFF7F674FFFE0D0D0FFAF9F8FFF5F472FFFAF9F8FFFFFFFFFFFF0F0F0FFF0F0
      F0FFF0F0F0FFFFF8F0FFD0777FFFE0978FFFE08F8FFF5F4F3FFF5F4F3FFF5F4F
      3FFF5F573FFF5F4F3FFFAF4F4FFF8F473FFFAF9F8FFFFFFFFFFFFFFFFFFFFFF8
      FFFFF0F0F0FFF0E8E0FFBF777FFFE0979FFFE08F8FFF5F4F3FFF5F4F3FFF5F4F
      3FFF5F4F3FFF5F4F3FFFAF574FFF8F474FFF0000000000000000000000000000
      000000000000AF9F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F5F
      4FFF7F5F4FFF7F675FFFAF9F8FFF5F472FFF0000000000000000000000000000
      000000000000AF9F8FFFFFFFFFFFFFD09FFFFFD09FFFFFD09FFFFFD8AFFF7F5F
      4FFF7F5F4FFF7F675FFFAF9F8FFF5F472FFFAF9F8FFFFFFFFFFFFFD08FFFFFD0
      8FFFFFD08FFFFFE0AFFFD07F7FFFF09F9FFFE0979FFFE08F8FFFD0877FFFD077
      7FFFBF6F6FFFBF675FFFAF5F5FFF9F474FFFAF9F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF8F0FFF0F0F0FFD07F7FFFF09F9FFFE0979FFFE08F8FFFD0877FFFD077
      7FFFBF6F6FFFBF675FFFAF5F4FFF9F4F4FFFE6C5C260B36068F0AF575FFFAF57
      4FFF9F4F4FFF8F474FFF8F473FFF7F3F3FFF6F373FFF6F373FFFFFFFFFFFF0E8
      E0FF7F674FFFE0D8D0FFAF9F8FFF5F472FFFE6C5C260B36068F0AF575FFFAF57
      4FFF9F4F4FFF8F474FFF8F473FFF7F3F3FFF6F373FFF6F373FFFFFD8AFFFFFD8
      AFFF7F674FFFE0D8D0FFAF9F8FFF5F472FFFAF9F8FFFFFFFFFFFFFD09FFFFFD0
      9FFFFFD09FFFFFD8AFFFD0878FFFF0A7AFFFD0776FFFD05F5FFFBF574FFFAF4F
      2FFFAF3F1FFFAF472FFFBF675FFF9F4F4FFFAF9F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFF0F0FFD0878FFFF0A7AFFFD0776FFFD05F5FFFBF574FFFAF4F
      3FFFAF3F1FFFAF472FFFBF675FFF9F4F4FFFBF676FFFD0877FFFBF5F4FFF4F47
      3FFF7F7F7FFFE0D8D0FFAFB7AFFF4F3F3FFF9F473FFF7F3F3FFFFFFFFFFFE0E0
      D0FF8F775FFFF0E0E0FFAF9F8FFF5F472FFFBF676FFFD0877FFFBF5F4FFF4F47
      3FFF7F7F7FFFE0D8D0FFAFB7AFFF4F3F3FFF9F473FFF7F3F3FFFFFD8AFFFFFD8
      AFFF8F775FFFF0E0E0FFAF9F8FFF5F472FFFAF9F8FFFFFFFFFFFFFD09FFFFFD8
      AFFFFFD8AFFFFFD8AFFFD08F8FFFF0AFAFFFD06F6FFFFFFFFFFFFFF8F0FFF0E0
      E0FFE0D8D0FFAF4F2FFFBF6F6FFFAF574FFFBFA78FFFFFFFFFFFFFF8FFFFF0E0
      E0FF8F6F5FFFE0D8D0FFD08F8FFFF0AFAFFFE06F6FFFFFFFFFFFFFF8F0FFF0E8
      E0FFE0D8D0FFAF4F3FFFBF6F6FFFAF574FFFBF6F6FFFE08F8FFFD0877FFF5F4F
      3FFF6F5F5FFFAFAF9FFFD0D0BFFF5F574FFF9F473FFF7F3F3FFFFFFFFFFF7F67
      4FFFD0B7AFFFF0E8E0FFAF9F8FFF5F472FFFBF6F6FFFE08F8FFFD0877FFF5F4F
      3FFF6F5F5FFFAFAF9FFFD0D0BFFF5F574FFF9F473FFF7F3F3FFFFFD8AFFF7F67
      4FFFFFD8AFFFF0E8E0FFAF9F8FFF5F472FFFBFA78FFFFFFFFFFFFFD8AFFFFFD8
      AFFF8F6F5FFFFFD8AFFFE0979FFFFFB7BFFFF0877FFFFFFFFFFFFFFFFFFFFFF8
      F0FFF0E0E0FFBF574FFFAF5F5FFFAF575FFFBFA79FFFFFF8FFFFBFA78FFF7F67
      4FFF7F5F4FFF7F675FFFE0979FFFFFB7BFFFF0877FFFFFFFFFFFFFFFFFFFFFF8
      F0FFF0E8E0FFBF574FFF9F5F5FFFAF575FFFBF777FFFE0979FFFE08F8FFF5F4F
      3FFF5F4F3FFF5F4F3FFF5F4F3FFF5F4F3FFFAF574FFF8F474FFFFFFFFFFFFFFF
      FFFFFFF8F0FFF0F0F0FFAF9F8FFF5F472FFFBF777FFFE0979FFFE08F8FFF5F4F
      3FFF5F4F3FFF5F4F3FFF5F4F3FFF5F4F3FFFAF574FFF8F474FFFFFD8AFFFFFD8
      AFFFFFD8AFFFF0F0F0FFAF9F8FFF5F472FFFBFA79FFFFFFFFFFFBFA78FFF7F67
      4FFF7F5F4FFF7F675FFFE09F9FFFFFBFBFFFF08F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF8F0FFD05F5FFF7F3F3FFFAF574FFFBFAF9FFFFFF8FFFF7F674FFFF0F0
      F0FF8F6F5FFFFFF8F0FFE09F9FFFFFBFBFFFFF8F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF8F0FFD05F5FFF7F3F3FFFAF575FFFD07F7FFFF09F9FFFE0979FFFE08F
      8FFFD0877FFFD0777FFFBF6F6FFFBF675FFFAF5F4FFF9F4F4FFFFFFFFFFFFFFF
      FFFFFFFFFFFFAF9F8FFFAF9F8FFF5F472FFFD07F7FFFF09F9FFFE0979FFFE08F
      8FFFD0877FFFD0777FFFBF6F6FFFBF675FFFAF5F4FFF9F4F4FFFFFD8AFFFFFD8
      AFFFFFD89FFFAF9F8FFFAF9F8FFF5F472FFFBFAF9FFFFFFFFFFF7F674FFFFFD8
      AFFF8F6F5FFFFFD8AFFFE09F9FFFD09F9FFFE0979FFFD08F8FFFD0878FFFD07F
      7FFFBF777FFFBF776FFFBF676FFFBF675FFFD0AF9FFFFFFFFFFF7F5F4FFFFFF8
      FFFFFFFFFFFFFFFFFFFFE0A79FFFE09F9FFFE0979FFFD08F8FFFD0878FFFD07F
      7FFFBF777FFFBF6F6FFFBF676FFFBF675FFFD0878FFFF0A7AFFFD0776FFFD05F
      5FFFBF574FFFAF4F3FFFAF3F1FFFAF472FFFBF675FFF9F4F4FFFFFFFFFFFFFFF
      FFFFAF9F8FFF5F472FFF5F472FFF5F472FFFD0878FFFF0A7AFFFD0776FFFD05F
      5FFFBF574FFFAF4F3FFFAF3F1FFFAF472FFFBF675FFF9F4F4FFFFFD8AFFFFFD8
      AFFFAF9F8FFF5F472FFF5F472FFF5F472FFFD0AF9FFFFFFFFFFF7F5F4FFFFFD8
      AFFFFFD8AFFFFFD8AFFFFFD8AFFFFFD8AFFFFFD8AFFFF0E0E0FF6F5F4FFF0000
      000000000000000000000000000000000000D0B79FFFFFFFFFFF7F5F3FFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAF9F8FFFAF9F8FFF5F472FFF0000
      000000000000000000000000000000000000D08F8FFFF0AFAFFFE06F6FFFFFFF
      FFFFFFF8F0FFF0E8E0FFE0D8D0FFAF4F3FFFBF6F6FFFAF574FFFFFFFFFFFFFFF
      FFFFBFA78FFFD0C8BFFF5F472FFFE4D1C890D08F8FFFF0AFAFFFE06F6FFFFFFF
      FFFFFFF8F0FFF0E8E0FFE0D8D0FFAF4F3FFFBF6F6FFFAF574FFFFFE0BFFFFFE0
      BFFFBFA78FFFD0C8BFFF5F472FFFE4D1C890D0B79FFFFFFFFFFF7F5F3FFFFFD8
      AFFFFFD8AFFFFFD8AFFFFFD8AFFFFFD8AFFFFFD89FFFD0C8BFFF5F472FFF0000
      000000000000000000000000000000000000D0B7AFFFFFFFFFFFAF9F8FFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFAF9F8FFF5F472FFF5F472FFF5F472FFF0000
      000000000000000000000000000000000000E0979FFFFFB7BFFFF0877FFFFFFF
      FFFFFFFFFFFFFFF8F0FFF0E8E0FFBF574FFF9F5F5FFFAF575FFFFFFFFFFFFFFF
      FFFFBFA79FFF5F472FFFE4D1C89000000000E0979FFFFFB7BFFFF0877FFFFFFF
      FFFFFFFFFFFFFFF8F0FFF0E8E0FFBF574FFF9F5F5FFFAF575FFFFFFFFFFFFFFF
      FFFFBFA79FFF5F472FFFE4D1C89000000000D0B7AFFFFFFFFFFFAF9F8FFFFFD8
      AFFFFFD8AFFFFFD8AFFFFFE0AFFFAF9F8FFF5F472FFF5F472FFF5F472FFF0000
      000000000000000000000000000000000000D0BFAFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFA78FFFD0C8BFFF5F472FFFE4D1C8900000
      000000000000000000000000000000000000E09F9FFFFFBFBFFFFF8F8FFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFF8F0FFD05F5FFF7F3F3FFFAF575FFFD0BFAFFFD0B7
      AFFFD0AF9FFFE4D1C8900000000000000000E09F9FFFFFBFBFFFFF8F8FFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFF8F0FFD05F5FFF7F3F3FFFAF575FFFD0BFAFFFD0B7
      AFFFD0AF9FFFE4D1C8900000000000000000D0BFAFFFFFFFFFFFFFE0BFFFFFE0
      BFFFFFE0BFFFFFE0BFFFFFE0BFFFBFA78FFFD0C8BFFF5F472FFFE4D1C8900000
      000000000000000000000000000000000000E0BFAFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFA79FFF5F472FFFE4D1C890000000000000
      000000000000000000000000000000000000E0A79FFFE09F9FFFE0979FFFD08F
      8FFFD0878FFFD07F7FFFBF777FFFBF6F6FFFBF676FFFBF675FFF000000000000
      000000000000000000000000000000000000E0A79FFFE09F9FFFE0979FFFD08F
      8FFFD0878FFFD07F7FFFBF777FFFBF6F6FFFBF676FFFBF675FFF000000000000
      000000000000000000000000000000000000E0BFAFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFA79FFF5F472FFFE4D1C890000000000000
      000000000000000000000000000000000000E0BFAFFFE0BFAFFFE0BFAFFFE0BF
      AFFFE0BFAFFFD0BFAFFFD0B7AFFFD0AF9FFFE4D1C89000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E0BFAFFFE0BFAFFFE0BFAFFFE0BF
      AFFFE0BFAFFFD0BFAFFFD0B7AFFFD0AF9FFFE4D1C89000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDC7
      D1501F2F3FFFB8C0C75000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FDFCFA10FDFCFA10FCFCFA10000000000000
      000000000000000000000000000000000000AF9F8FFF5F472FFF5F472FFF5F47
      2FFF5F472FFF5F472FFF5F472FFF5F472FFF5F472FFF5F472FFF4F473FFF2F4F
      5FFF3F77BFFF2F475FFFBDC7CC50000000000000000000000000000000000000
      00000000000000000000C7C7C7503F473FFF626262D04F473FFF2F2F2FFF969A
      9680D2E5D230107F10FF3A8E2DE0B4D4B4500000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E9E2D730BEAA8E80AA7A4BC08E5D3AE09E7456C0A6805AB0AE9E8780DDD9
      D230FCFBFA10000000000000000000000000AF9F8FFFFFFFFFFFAF9F8FFFAF9F
      8FFFAF9F8FFFAF9F8FFFAF9F8FFFAF9F8FFFAF9F8FFF8F877FFF2F4F6FFF2F7F
      D0FF3F97E0FF4FAFF0FF4F676FFF000000000000000000000000F6F5F310F6F5
      F3107F674FFFE9E3E030C7CAC7505F575FFFC7CAC750CED0CE402F2F2FFFB4D6
      B450005F00FF69AE69A0AAD1A560108710FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FDF8F310D4BC
      A370C28E68F0E0C8AFFFF0F0F0FFFFFFFFFFFFFFFFFFF0F0F0FFE0C8BFFFB698
      7AC0B6B0A560FCFBFA100000000000000000AF9F8FFFFFFFFFFFFFFFFFFFFFF8
      FFFFF0F0F0FFD0D8D0FF8F978FFF6F675FFF5F675FFF4F575FFF3F6F8FFF3F9F
      E0FF5FC8FFFF6F8F9FFFD1D9DB500000000000000000EEE9E620866859F07F5F
      4FFF7F5F4FFF7F674FFF00000000D6D4D6409A959AA06F6F6FD03F373FFFB4D6
      B450107F10FF96C6967000000000F0F5F0109C9C9C701F171FFF101710FF1017
      10FF0000000000000000484148D0101710FF1F1F1FFF2D2D2DE06F736F902D2D
      2DE096969670484148D02D2D2DE07F7F7F800000000000000000DBBFA370E0A7
      7FFFFFF0E0FFE0B79FFFD07F4FFFBF571FFFBF571FFFD07F4FFFE0B79FFFF0E8
      E0FFB39577F0BCB0A5600000000000000000AF9F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFE0E0E0FF8F8F8FFFAFA79FFFD0BFAFFFD0AF9FFF7F776FFF4F574FFF5F8F
      AFFF6F97AFFFB6C2C6800000000000000000000000007F573FFFB6A09290EEE9
      E62086604AF0EEEAE820F3F3F310B6B6B660E6E7E620929292902F2F2FFFD2E6
      D2301F8F1FFF8EBE8780AAD1A5602F9F1FFF00000000B8B8B8501F1F1FFF9C99
      9C70F0F0F01000000000D4D4D4301F1F1FFF1F171FFF726D72A01E241EF07878
      78902D2D2DE02D2D2DE08F8F8F700000000000000000EFE5D730D29D77F0FFF0
      E0FFE0A78FFFBF4F10FFBF4F10FFE0A78FFFFFFFFFFFAF4710FFAF4710FFD09F
      7FFFF0F0E0FFB0896FD0DDD9D23000000000AF9F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFAFAFAFFFBFB7AFFFFFF0E0FFFFE8E0FFF0D8BFFFF0D0AFFF7F776FFFA4A0
      A490B6C2C680000000000000000000000000000000007F573FFFF6F4F2100000
      0000000000000000000000000000AAAAAA70565656E04A4A4AF0626862C0F1F1
      F110C3DEC3401F8F1FFF108710FFB4D6B4500000000000000000646464B03A3A
      3AE0B8B6B85000000000000000001F1F1FFF1F171FFFC6C4C6401E241EF0A5A7
      A560E1E1E1202D2D2DE0696969A00000000000000000D6BA9E80F0D8BFFFF0C8
      AFFFE0571FFFD05710FFD04F10FFE07F4FFFE0A77FFFBF4F10FFAF4710FFAF47
      10FFE0B79FFFE0C8BFFFA69E8780FCFCFC10BFA78FFFFFFFFFFFFFFFFFFFFFFF
      FFFF9F978FFFF0E8E0FFFFF8F0FFFFF0F0FFFFE8E0FFF0D8D0FFD0AF9FFF646B
      64E00000000000000000000000000000000000000000CEBFB660000000000000
      000000000000000000000000000000000000D6D6D640C7C7C750F3F3F3100000
      000000000000F0F6F010F0F6F010000000000000000000000000F0F0F0105656
      56C02C242CF0101710FF101710FF101710FF101710FFD4D4D430969696701E1E
      1EF0E1E1E120C3C3C3403C3C3CD0C6C6C64000000000D58E56E0FFF8F0FFF097
      6FFFF05F1FFFE0571FFFE0571FFFF0A78FFFFFFFFFFFD04F10FFBF4F10FFAF4F
      10FFBF774FFFF0F0F0FF9E6E56C000000000BFA79FFFFFFFFFFFFFFFFFFFFFFF
      FFFF9F9F8FFFF0E8E0FFFFFFFFFFFFF8F0FFFFF0F0FFFFE8E0FFE0BFAFFF7272
      72E0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D4D4
      D4302C2C2CF09C9C9C70E2E1E2201E241EF0101710FFF0F0F010000000008787
      87803C3C3CD0D2D3D2303C413CD06F736F9000000000D2864AF0FFFFFFFFFF77
      3FFFFF672FFFF0671FFFF05F1FFFF0874FFFFFFFFFFFF0BFAFFFBF571FFFAF4F
      10FFAF571FFFFFFFFFFF8E5D3AE0FDFCFA10BFAF9FFFFFFFFFFFFFFFFFFFFFFF
      FFFFBFC8BFFFBFBFBFFFFFFFFFFFFFFFFFFFFFF8F0FFFFF0E0FFAF9F8FFFAEAE
      AE8000000000000000000000000000000000C7C5C7503F3F3FFF6E686EC0555B
      55D02F372FFFDADCDA30C2C2C250C2C5C250D7D6D730CAC8CA40F1F1F1100000
      0000000000000000000000000000000000000000000000000000000000000000
      00009C9C9C702C332CF09C9C9C703A333AE0101710FF00000000000000000000
      0000D2D2D2305A5A5AB0B4B1B4503F3F3FC000000000D28E59F0FFFFFFFFFF7F
      4FFFFF6F2FFFFF672FFFFF672FFFFF671FFFF08F5FFFFFF8F0FFF0D8BFFFBF4F
      1FFFBF571FFFFFFFFFFF8E5D3AE0FDFCFC10D0AF9FFFFFFFFFFFFFFFFFFFFFFF
      FFFFF0F8FFFFBFB7AFFFBFBFBFFFF0E8E0FFF0E8E0FFAFAF9FFF6F6F5FFFF6F5
      F41000000000000000000000000000000000C7C7C7504F574FFFBCBCBC60B6B9
      B6602F372FFFF2F2F210B6B9B660D7D6D73000000000CAC8CA40BDBBBD500000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000727772A0484E48D03A3A3AE0101710FF00000000000000000000
      00000000000000000000000000000000000000000000DB9E7AC0FFF8F0FFFFA7
      7FFFFF6F3FFFFF874FFFFFAF8FFFFF6F2FFFF0671FFFF08F6FFFFFFFFFFFF07F
      4FFFD0875FFFFFF0F0FFA68B64B0FDFCFC10D0B79FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF0F8FFFFBFC8BFFF9F9F8FFF8F8F7FFF8F8F8FFF5F4F3FFF0000
      00000000000000000000000000000000000000000000D2D4D240909590A06F6F
      6FD03F373FFFF1F1F110B6B9B660D7D6D73000000000D7D6D730BDBBBD500000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000484E48D01F1F1FFF101710FF00000000000000000000
      00000000000000000000000000000000000000000000E2C6AA70F0D8BFFFFFD0
      BFFFFF773FFFFF976FFFFFFFFFFFFFC8AFFFFF8F5FFFFFC8AFFFFFF8F0FFF077
      3FFFF0C8AFFFE0C8AFFFCDB89C7000000000D0B7AFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFAF9F8FFF5F472FFF5F472FFF5F472FFF0000
      000000000000000000000000000000000000F3F3F310BCB9BC60E8E8E8209B9B
      9B903F3F3FFFF1F2F110B6B9B660D7D6D730F1F1F110BDBBBD50BDBBBD500000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D4D6D430484848D01F171FFF00000000000000000000
      00000000000000000000000000000000000000000000F2E8DA30E1A477F0FFF8
      F0FFFFBF9FFFFF773FFFFFB79FFFFFF8F0FFFFFFFFFFFFF0E0FFFF976FFFF0B7
      9FFFFFF0E0FFC69564E0ECE2D43000000000D0BFAFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFA78FFFD0C8BFFF5F472FFFE4D1C8900000
      00000000000000000000000000000000000000000000B1B1B170646464E05951
      59F06E6E6EC0F1F1F110B6B9B660C2C5C250DADCDA30CAC8CA40F1F1F1100000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B8B8B850484848D000000000000000000000
      0000000000000000000000000000000000000000000000000000E6D1B660E1BB
      A4F0FFF8F0FFFFD0BFFFFFA77FFFFF874FFFFF874FFFFFA77FFFF0D0BFFFFFF0
      E0FFD2AC86F0DAC5B0600000000000000000E0BFAFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFA79FFF5F472FFFE4D1C890000000000000
      0000000000000000000000000000000000000000000000000000D6D4D640C7C7
      C750F3F3F310F1F1F110B6B9B660D7D6D7300000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E6D1
      B660E1A477F0F0D8BFFFFFF8F0FFFFFFFFFFFFFFFFFFFFF8F0FFF0D8BFFFC69C
      72E0E0D1BD50000000000000000000000000E0BFAFFFE0BFAFFFE0BFAFFFE0BF
      AFFFE0BFAFFFD0BFAFFFD0B7AFFFD0AF9FFFE4D1C89000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F1F2F110B6B9B660D7D6D7300000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F2E8DA30E2C6AA70E7B692C0D5A380E0D29D68F0D8AA89D0DBC3AA70F4ED
      E620000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DAD9DA30BCB9BC60E4E4E4200000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AF9F8FFF5F472FFF5F472FFF5F472FFF5F472FFF5F472FFF5F47
      2FFF5F472FFF5F472FFF5F472FFF5F472FFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D0AF9FFFAF5F5FFFAF574FFFAF575FFF9F4F4FFF9F47
      4FFF8F473FFF7F3F3FFF6F372FFF6F373FFF0000000000000000000000000000
      000000000000BFA78FFF5F472FFF5F472FFF5F472FFF5F472FFF5F472FFF5F47
      2FFF6F4F3FFF5F472FFF00000000000000000000000000000000000000000000
      000000000000AF9F8FFFFFFFFFFFAF9F8FFFAF9F8FFFAF9F8FFFAF9F8FFFAF9F
      8FFFAF9F8FFFAF9F8FFFAF9F8FFF5F472FFF0000000000000000000000000000
      00000000000000000000E6C5C260B36068F0AF575FFFAF574FFF9F4F4FFF8F47
      4FFF8F473FFF7F3F3FFF6F373FFF6F373FFF0000000000000000000000000000
      00000000000000000000BF676FFFD0877FFFBF5F4FFF4F473FFF7F7F6FFFE0D0
      D0FFBFB7AFFF4F3F3FFF9F3F3FFF7F3F3FFFAF9F8FFF5F472FFF5F4F3FFF7F67
      4FFFAFA79FFFBFA78FFFFFF8FFFFE0D8D0FFE0D0D0FFE0D0BFFFD0C8BFFFD0C8
      BFFFE0C8BFFF5F4F3FFF00000000000000000000000000000000000000000000
      000000000000AF9F8FFFFFFFFFFFFFFFFFFFFFF8FFFFF0F0F0FFF0E8E0FFF0E0
      D0FFE0D0D0FFE0C8BFFFAF9F8FFF5F472FFFAF9F8FFF5F472FFF5F472FFF5F47
      2FFF5F472FFF5F472FFFBF676FFFD0877FFFBF5F4FFF4F473FFF7F7F7FFFE0D8
      D0FFAFB7AFFF4F3F3FFF9F473FFF7F3F3FFFAF9F8FFF5F472FFF5F472FFF5F47
      2FFF5F472FFF5F472FFFBF6F6FFFE08F8FFFD0877FFF5F4F3FFF6F675FFFAFAF
      9FFFD0D0BFFF5F574FFF9F473FFF7F3F3FFFAF9F8FFFFFF8FFFFD0D8D0FFE0D8
      D0FFF0E8E0FFBFA78FFFFFF8FFFFD0B79FFFD0AF9FFFD0AF9FFFD0A78FFFBFA7
      8FFFE0C8BFFF5F4F3FFF00000000000000000000000000000000000000000000
      000000000000AF9F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F0FFF0F0F0FFF0E0
      D0FF7F674FFFE0D0D0FFAF9F8FFF5F472FFFAF9F8FFFFFFFFFFFAF9F8FFFAF9F
      8FFFAF9F8FFFAF9F8FFFBF6F6FFFE08F8FFFD0877FFF5F4F3FFF6F5F5FFFAFAF
      9FFFD0D0BFFF5F574FFF9F473FFF7F3F3FFFAF9F8FFFFFFFFFFFF0F0F0FFF0F0
      F0FFF0F0F0FFFFF8F0FFD0777FFFE0978FFFE08F8FFF5F4F3FFF5F4F3FFF5F4F
      3FFF5F573FFF5F4F3FFFAF4F4FFF8F473FFFAF9F8FFFFFFFFFFFFFF8FFFFFFF8
      F0FFFFF8F0FFBFA79FFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8F0FFFFF0
      E0FFD0C8BFFF6F4F3FFF00000000000000000000000000000000000000000000
      000000000000AF9F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F5F
      4FFF7F5F4FFF7F675FFFAF9F8FFF5F472FFFAF9F8FFFFFFFFFFFFFFFFFFFFFF8
      FFFFF0F0F0FFF0E8E0FFBF777FFFE0979FFFE08F8FFF5F4F3FFF5F4F3FFF5F4F
      3FFF5F4F3FFF5F4F3FFFAF574FFF8F474FFFAF9F8FFFFFFFFFFFFFD08FFFFFD0
      8FFFFFD08FFFFFE0AFFFD07F7FFFF09F9FFFE0979FFFE08F8FFFD0877FFFD077
      7FFFBF6F6FFFBF675FFFAF5F5FFF9F474FFFAF9F8FFFFFFFFFFFBF9F8FFFBFAF
      9FFFE0D0D0FFBFA79FFFFFF8FFFFD0BFAFFFD0BFAFFFD0BFAFFFD0B7AFFFD0B7
      AFFFE0C8BFFF6F4F3FFF0000000000000000E6C5C260B36068F0AF575FFFAF57
      4FFF9F4F4FFF8F474FFF8F473FFF7F3F3FFF6F373FFF6F373FFFFFFFFFFFF0E8
      E0FF7F674FFFE0D8D0FFAF9F8FFF5F472FFFAF9F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF8F0FFF0F0F0FFD07F7FFFF09F9FFFE0979FFFE08F8FFFD0877FFFD077
      7FFFBF6F6FFFBF675FFFAF5F4FFF9F4F4FFFAF9F8FFFFFFFFFFFFFD09FFFFFD0
      9FFFFFD09FFFFFD8AFFFD0878FFFF0A7AFFFD0776FFFD05F5FFFBF574FFFAF4F
      2FFFAF3F1FFFAF472FFFBF675FFF9F4F4FFFAF9F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF8FFFFBFAF9FFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8
      F0FFE0D0D0FF6F573FFF0000000000000000BF676FFFD0877FFFBF5F4FFF4F47
      3FFF7F7F7FFFE0D8D0FFAFB7AFFF4F3F3FFF9F473FFF7F3F3FFFFFFFFFFFE0E0
      D0FF8F775FFFF0E0E0FFAF9F8FFF5F472FFFAF9F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFF0F0FFD0878FFFF0A7AFFFD0776FFFD05F5FFFBF574FFFAF4F
      3FFFAF3F1FFFAF472FFFBF675FFF9F4F4FFFAF9F8FFFFFFFFFFFFFD09FFFFFD8
      AFFFFFD8AFFFFFD8AFFFD08F8FFFF0AFAFFFD06F6FFFFFFFFFFFFFF8F0FFF0E0
      E0FFE0D8D0FFAF4F2FFFBF6F6FFFAF574FFFBFA78FFFFFFFFFFFBFA79FFFD0AF
      9FFFE0D8D0FFBFAF9FFFFFF8FFFFD0BFAFFFD0BFAFFFD0BFAFFFD0BFAFFFD0BF
      AFFFE0D8D0FF6F573FFF0000000000000000BF6F6FFFE08F8FFFD0877FFF5F4F
      3FFF6F5F5FFFAFAF9FFFD0D0BFFF5F574FFF9F473FFF7F3F3FFFFFFFFFFF7F67
      4FFFD0B7AFFFF0E8E0FFAF9F8FFF5F472FFFBFA78FFFFFFFFFFFFFF8FFFFF0E0
      E0FF8F6F5FFFE0D8D0FFD08F8FFFF0AFAFFFE06F6FFFFFFFFFFFFFF8F0FFF0E8
      E0FFE0D8D0FFAF4F3FFFBF6F6FFFAF574FFFBFA78FFFFFFFFFFFFFD8AFFFFFD8
      AFFF8F6F5FFFFFD8AFFFE0979FFFFFB7BFFFF0877FFFFFFFFFFFFFFFFFFFFFF8
      F0FFF0E0E0FFBF574FFFAF5F5FFFAF575FFFBFA79FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFBFAF9FFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8
      FFFFFFF8FFFF6F573FFF0000000000000000BF777FFFE0979FFFE08F8FFF5F4F
      3FFF5F4F3FFF5F4F3FFF5F4F3FFF5F4F3FFFAF574FFF8F474FFFFFFFFFFFFFFF
      FFFFFFF8F0FFF0F0F0FFAF9F8FFF5F472FFFBFA79FFFFFF8FFFFBFA78FFF7F67
      4FFF7F5F4FFF7F675FFFE0979FFFFFB7BFFFF0877FFFFFFFFFFFFFFFFFFFFFF8
      F0FFF0E8E0FFBF574FFF9F5F5FFFAF575FFFBFA79FFFFFFFFFFFBFA78FFF7F67
      4FFF7F5F4FFF7F675FFFE09F9FFFFFBFBFFFF08F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF8F0FFD05F5FFF7F3F3FFFAF574FFFBFAF9FFFFFFFFFFFD0AF9FFFD0B7
      AFFFE0D8D0FFBFAF9FFFBFAF9FFFBFAF9FFFBFAF9FFFBFAF9FFFBFAF9FFFBFA7
      9FFFBFA79FFFBFA79FFF0000000000000000D07F7FFFF09F9FFFE0979FFFE08F
      8FFFD0877FFFD0777FFFBF6F6FFFBF675FFFAF5F4FFF9F4F4FFFFFFFFFFFFFFF
      FFFFFFFFFFFFAF9F8FFFAF9F8FFF5F472FFFBFAF9FFFFFF8FFFF7F674FFFF0F0
      F0FF8F6F5FFFFFF8F0FFE09F9FFFFFBFBFFFFF8F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF8F0FFD05F5FFF7F3F3FFFAF575FFFBFAF9FFFFFFFFFFF7F674FFFFFD8
      AFFF8F6F5FFFFFD8AFFFE09F9FFFD09F9FFFE0979FFFD08F8FFFD0878FFFD07F
      7FFFBF777FFFBF776FFFBF676FFFBF675FFFD0AF9FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF8F8F8FFFFFFFFFFF8F8F8FFFFFFFFFFF7F7F7FFFFFFFFFFF7F7F
      7FFFFFFFFFFF5F575FFF0000000000000000D0878FFFF0A7AFFFD0776FFFD05F
      5FFFBF574FFFAF4F3FFFAF3F1FFFAF472FFFBF675FFF9F4F4FFFFFFFFFFFFFFF
      FFFFAF9F8FFF5F472FFF5F472FFF5F472FFFD0AF9FFFFFFFFFFF7F5F4FFFFFF8
      FFFFFFFFFFFFFFFFFFFFE0A79FFFE09F9FFFE0979FFFD08F8FFFD0878FFFD07F
      7FFFBF777FFFBF6F6FFFBF676FFFBF675FFFD0AF9FFFFFFFFFFF7F5F4FFFFFD8
      AFFFFFD8AFFFFFD8AFFFFFD8AFFFFFD8AFFFFFD8AFFFF0E0E0FF6F5F4FFF0000
      000000000000000000000000000000000000D0B79FFFFFFFFFFFD0B7AFFFD0B7
      AFFFE0C8BFFFE0D8D0FF1F271FFFBFBFBFFF1F271FFF9F8F7FFF1F271FFF9F8F
      7FFF1F271FFFAF978FFF0000000000000000D08F8FFFF0AFAFFFE06F6FFFFFFF
      FFFFFFF8F0FFF0E8E0FFE0D8D0FFAF4F3FFFBF6F6FFFAF574FFFFFFFFFFFFFFF
      FFFFBFA78FFFD0C8BFFF5F472FFFE4D1C890D0B79FFFFFFFFFFF7F5F3FFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAF9F8FFFAF9F8FFF5F472FFF0000
      000000000000000000000000000000000000D0B79FFFFFFFFFFF7F5F3FFFFFD8
      AFFFFFD8AFFFFFD8AFFFFFD8AFFFFFD8AFFFFFD89FFFD0C8BFFF5F472FFF0000
      000000000000000000000000000000000000D0B7AFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFD0C8BFFFAF9F8FFFAFA79FFFAFA79FFF0000
      000000000000000000000000000000000000E0979FFFFFB7BFFFF0877FFFFFFF
      FFFFFFFFFFFFFFF8F0FFF0E8E0FFBF574FFF9F5F5FFFAF575FFFFFFFFFFFFFFF
      FFFFBFA79FFF5F472FFFE4D1C89000000000D0B7AFFFFFFFFFFFAF9F8FFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFAF9F8FFF5F472FFF5F472FFF5F472FFF0000
      000000000000000000000000000000000000D0B7AFFFFFFFFFFFAF9F8FFFFFD8
      AFFFFFD8AFFFFFD8AFFFFFE0AFFFAF9F8FFF5F472FFF5F472FFF5F472FFF0000
      000000000000000000000000000000000000D0BFAFFFFFFFFFFFD0BFAFFFD0BF
      AFFFD0BFAFFFD0BFAFFFFFFFFFFFBFAF9FFFE0D0BFFF7F674FFFE4D6C8900000
      000000000000000000000000000000000000E09F9FFFFFBFBFFFFF8F8FFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFF8F0FFD05F5FFF7F3F3FFFAF575FFFD0BFAFFFD0B7
      AFFFD0AF9FFFE4D1C8900000000000000000D0BFAFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFA78FFFD0C8BFFF5F472FFFE4D1C8900000
      000000000000000000000000000000000000D0BFAFFFFFFFFFFFFFE0BFFFFFE0
      BFFFFFE0BFFFFFE0BFFFFFE0BFFFBFA78FFFD0C8BFFF5F472FFFE4D1C8900000
      000000000000000000000000000000000000E0BFAFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFAF9FFF5F4F3FFFE4D6C890000000000000
      000000000000000000000000000000000000E0A79FFFE09F9FFFE0979FFFD08F
      8FFFD0878FFFD07F7FFFBF777FFFBF6F6FFFBF676FFFBF675FFF000000000000
      000000000000000000000000000000000000E0BFAFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFA79FFF5F472FFFE4D1C890000000000000
      000000000000000000000000000000000000E0BFAFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFA79FFF5F472FFFE4D1C890000000000000
      000000000000000000000000000000000000E0BFAFFFE0BFAFFFE0BFAFFFE0BF
      AFFFE0BFAFFFD0BFAFFFD0B7AFFFD0AF9FFFE4D1C89000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E0BFAFFFE0BFAFFFE0BFAFFFE0BF
      AFFFE0BFAFFFD0BFAFFFD0B7AFFFD0AF9FFFE4D1C89000000000000000000000
      000000000000000000000000000000000000E0BFAFFFE0BFAFFFE0BFAFFFE0BF
      AFFFE0BFAFFFD0BFAFFFD0B7AFFFD0AF9FFFE4D1C89000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F4F4F40BDCDCDC23D0D0
      D02FD0D0D02FD0D0D02FD0D0D02FD0D0D02FD0D0D02FD0D0D02FD0D0D02FD0D0
      D02FD0D0D02FDCDCDC23F4F4F40B0000000000000000F0CFD150BF675FFFAF57
      4FFF9F4F4FFF9F4F4FFF9F4F4FFF8F474FFF8F473FFF8F473FFF7F3F3FFF7F37
      3FFF7F373FFF6F373FFF6F372FFF000000000000000000000000A37875FFA378
      75FFA37875FFA37875FFA37875FFA37875FFA37875FFA37875FFA37875FFA378
      75FFA37875FFA37875FF90615EFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F4F4F40BC4C4C43B888888777070
      708F7070708F7070708F7070708F7070708F7070708F7070708F7070708F7070
      708F7070708F88888877C4C4C43BF4F4F40B00000000D0676FFFF08F8FFFE07F
      7FFFAF471FFF3F2F1FFFBFB7AFFFBFB7AFFFD0BFBFFFD0C8BFFF4F4F4FFF9F3F
      2FFF9F3F2FFF9F372FFF6F373FFF000000000000000000000000A67C76FFF2E2
      D3FFF2E2D3FFFFE8D1FFEFDFBBFFFFE3C5FFFFDEBDFFFFDDBAFFFFD8B2FFFFD6
      AEFFFFD2A5FFFFD2A3FF936460FF000000000000000000000000000000000000
      000000000000000000000000000000000000F9D4C260E7BA9E80F9F4F1100000
      000000000000000000000000000000000000DCDCDC230C72A5FF0C72A5FF0C72
      A5FF0C72A5FF0C72A5FF0C72A5FF0C72A5FF0C72A5FF0C72A5FF0C72A5FF0C72
      A5FF0C72A5FF6464649B88888877DCDCDC2300000000D06F6FFFFF979FFFF087
      7FFFE07F7FFF6F574FFF3F3F2FFF8F776FFFF0E0E0FFF0E8E0FF8F7F6FFF9F3F
      2FFF9F3F3FFF9F3F2FFF7F373FFF000000000000000000000000AB8078FFF3E7
      DAFFF3E7DAFF019901FFAFD8A0FF71C570FF41AA30FF81BB5EFFEFD4A6FFFFD6
      AEFFFFD2A3FFFFD2A3FF966763FF000000000000000000000000000000000000
      000000000000000000000000000000000000F7DCD240F0874FFFD06F3FFFE0CA
      BD5000000000000000000000000000000000189AC6FF1B9CC7FF9CFFFFFF6BD7
      FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7
      FFFF2899BFFF0C72A5FF7070708FD0D0D02F00000000D0776FFFFF9F9FFFF08F
      8FFFF0877FFF6F574FFF000000FF3F3F2FFFF0D8D0FFF0E0D0FF7F775FFFAF47
      3FFFAF473FFF9F3F3FFF7F3F3FFF000000000000000000000000B0837AFFF4E9
      DDFFF4E9DDFF019901FF019901FF019901FF019901FF019901FF41AA2FFFFFD8
      B2FFFFD4A9FFFFD4A9FF9A6A65FF000000000000000000000000000000000000
      000000000000000000000000000000000000FDF0EA20EDC8B660F07F4FFFD277
      59F000000000000000000000000000000000189AC6FF199AC6FF79E4F0FF9CFF
      FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BDF
      FFFF42B2DEFF197A9DFF6464649BB8B8B84700000000D0777FFFFFA7AFFFFF9F
      9FFFF08F8FFF6F574FFF6F574FFF6F574FFF6F574FFF6F5F4FFF7F675FFFBF57
      4FFFAF4F4FFFAF473FFF7F3F3FFF000000000000000000000000B6897DFFF5ED
      E4FFF5EDE4FF019901FF019901FF119E0EFFCFD6A3FFFFE4C8FF21A21AFFFFD8
      B2FFFFD7B0FFFFD7B0FF9E6D67FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CA8362D0F087
      4FFFDEBAA680000000000000000000000000189AC6FF25A2CFFF3FB8D7FF9CFF
      FFFF84EBFFFF84EBFFFF84EBFFFF84EBFFFF84EBFFFF84EBFFFF84EBFFFF84E7
      FFFF42BAEFFF189AC6FF6464649B8888887700000000E07F7FFFFFAFAFFFFFAF
      AFFFFF9F9FFFF08F8FFFF0877FFFE07F7FFFE0777FFFD06F6FFFD0676FFFBF5F
      5FFFBF574FFFAF4F4FFF8F473FFF000000000000000000000000BC8E7FFFF7EF
      E8FFF7EFE8FF019901FF019901FF019901FF019901FFFFE4C8FFEFDEBAFFFFD8
      B2FFFFD7B0FFFFD9B4FFA27069FF000000000000000000000000000000000000
      00000000000000000000FEFAF910000000000000000000000000E2D0C640E077
      3FFFE0875FFF000000000000000000000000189AC6FF42B3E2FF20A0C9FFA5FF
      FFFF94F7FFFF94F7FFFF94F7FFFF94F7FFFF94F7FFFF94F7FFFF94F7FFFF94F7
      FFFF52BEE7FF5BBCCEFF0C72A5FF7070708F00000000E0878FFFFFB7BFFFFFB7
      AFFFD05F5FFFBF5F4FFFBF574FFFBF4F3FFFAF4F2FFFAF472FFF9F3F1FFF9F37
      10FFBF5F5FFFBF574FFF8F473FFF000000000000000000000000C39581FFF8F3
      EFFFF8F3EFFFF8F3EFFFFFF4E8FFFFF4E8FFFFF4E8FFEFE3C4FFEFE3C4FFFFE4
      C8FFFFDEBDFFFFDDBBFFA5746BFF000000000000000000000000D06F3FFFD06F
      3FFFBF673FFFAF5F2FFFAF572FFF8F4F2FFF0000000000000000F4EAE420BF67
      3FFFE07F4FFFE7C2AE800000000000000000189AC6FF6FD5FDFF189AC6FF89F0
      F7FF9CFFFFFF9CFFFFFF9CFFFFFF9CFFFFFF9CFFFFFF9CFFFFFF9CFFFFFF9CFF
      FFFF5AC7FFFF96F9FBFF187A9BFF7070708F00000000E08F8FFFFFBFBFFFD067
      5FFFFFFFFFFFFFFFFFFFFFF8F0FFF0F0F0FFF0E8E0FFF0D8D0FFE0D0BFFFE0C8
      BFFF9F3710FFBF5F5FFF8F474FFF000000000000000000000000CA9B84FFF9F5
      F2FFFBFBFBFFFFF4E8FFFFF4E8FFFFF4E8FF019901FF019901FF019901FFFFE8
      D1FFFFE3C5FFFFE1C2FFA8776DFF000000000000000000000000D0774FFFE06F
      2FFFF07F4FFFF0976FFFE08F5FFFFBE6DE40000000000000000000000000BF67
      3FFFE17F4AF0E7B092C00000000000000000189AC6FF84D7FFFF189AC6FF6BBF
      DAFFFFFFFFFFFFFFFFFFF7FBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF84E7FFFFFFFFFFFF187DA1FF8888887700000000E0979FFFFFBFBFFFD06F
      6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F0FFF0F0F0FFF0E8E0FFF0D8D0FFE0D0
      BFFF9F3F1FFFD0675FFF9F4F4FFF000000000000000000000000D2A187FFF9F9
      F9FFFBFBFBFF119F10FFAFD8A0FFFFF4E8FFAFD8A0FF019901FF019901FFFFE8
      D1FFFFE4C8FFFFE3C6FFAC7A6FFF000000000000000000000000D07F4FFFE07F
      4FFFF08F5FFFF09F6FFFB1806FB0EAD6CA40000000000000000000000000BF67
      3FFFD2774AF0E5AA89D00000000000000000189AC6FF84EBFFFF4FC1E2FF189A
      C6FF189AC6FF189AC6FF189AC6FF189AC6FF189AC6FF189AC6FF189AC6FF189A
      C6FF189AC6FF189AC6FF1889B1FFC4C4C43B00000000F09F9FFFFFBFBFFFE077
      6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F0FFF0F0F0FFF0E8E0FFF0D8
      D0FFAF472FFFD06F6FFF9F4F4FFF000000000000000000000000D9A88AFFFBFB
      FBFFFFFFFFFF71C570FF019901FF019901FF019901FF019901FF019901FFFFE8
      D1FFFFE8D1FFFFE6CEFFAE7C72FF000000000000000000000000D0875FFFE08F
      5FFFF0976FFFF08E59F0AF5F3FFFAF5F3FFFDBB8A37000000000F4EEE820A460
      3BF0D27F4AF0E5A389D00000000000000000189AC6FF9CF3FFFF8CF3FFFF8CF3
      FFFF8CF3FFFF8CF3FFFF8CF3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF189AC6FF197A9DFFC4C4C43BF4F4F40B00000000F0A79FFFFFBFBFFFE07F
      7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F0FFF0F0F0FFF0E8
      E0FFAF4F2FFFE0777FFF9F4F4FFF000000000000000000000000DFAE8CFFFCFC
      FCFFFFFFFFFFFFFFFFFF71C570FF019901FF019901FFAFD8A0FF019901FFFFE8
      D1FFFFC8C2FFFFB0B0FFB07E73FF0000000000000000FDF9F710BF7F5FFFD5A3
      80E0E4BBA490D08F6FFFD07F4FFFBF6F3FFFBF673FFFC28662C0B88056E09F5F
      3FFFE07F4FFFD5AA8EE00000000000000000189AC6FFFFFFFFFF9CFFFFFF9CFF
      FFFF9CFFFFFF9CFFFFFFFFFFFFFF189AC6FF189AC6FF189AC6FF189AC6FF189A
      C6FF189AC6FFDCDCDC23F4F4F40B0000000000000000F0AFAFFFFFBFBFFFF087
      8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F0FFF0F0
      F0FFBF4F3FFF5F2F2FFFAF574FFF000000000000000000000000E5B38FFFFDFD
      FDFFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFEFFFFFAF6FFFFF9F3FFFFF5EAFFF4DE
      CEFFB28074FFB28074FFB28074FF000000000000000000000000BF875FFFF3E6
      DE4000000000DBA486C0D0875FFFD28659F0BF673FFFAF673FFFB3683BF0E17F
      4AF0E1A486F0D5A38EE000000000000000000000000021A2CEFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF189AC6FFC4C4C43BF4F4F40B00000000000000000000
      00000000000000000000000000000000000000000000F0AFAFFFFFBFBFFFFF8F
      8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8
      F0FFBF574FFFAF575FFFAF575FFF000000000000000000000000EAB891FFFEFE
      FEFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFAF6FFFFF9F3FFF5E1
      D2FFB28074FFEDA755FFD3A390FF000000000000000000000000000000000000
      00000000000000000000F3BC9EC0E0977FFFE19D77F0E19577F0E39C80E0E1A4
      86F0E1AC95F0FDF5F2200000000000000000000000000000000021A2CEFF21A2
      CEFF21A2CEFF21A2CEFFDCDCDC23F4F4F40B0000000000000000000000000000
      00000000000000000000000000000000000000000000F0B7AFFFF0B7AFFFF0AF
      AFFFF0AFAFFFF0A7AFFFF09F9FFFE0979FFFE08F8FFFE08F8FFFE0878FFFE07F
      7FFFD0777FFFD0776FFFD06F6FFF000000000000000000000000EFBC92FFFFFF
      FFFFFFFFFFFFFCFCFCFFFAFAFAFFF7F7F7FFF5F5F5FFF2F1F1FFF0EDEAFFE9DA
      D0FFB28074FFDAAA93FF00000000000000000000000000000000000000000000
      0000000000000000000000000000F9E3D460F3C2AAC0F1BFAAE0F3CEB6C0F6DA
      C890FDF6F4200000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F2BF94FFDCA9
      87FFDCA987FFDCA987FFDCA987FFDCA987FFDCA987FFDCA987FFDCA987FFDCA9
      87FFB28074FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF000003FC00FFFF00000003FC00FC000000
      0003FC00C00000000003C000820200000003C000800000000003C0009E000000
      0003C000BF1900000003C000FFFF00000003C000001F00000001C000009F0000
      0000C00F809F00000003C00F001F00000001C00F801F00000000FFFFC0FF0000
      FF80FFFFF8FF0000FF80FFFFF8FF0000FFFFF800F800FC00FC00F800F800FC00
      0000F800F80000000000F800F80000000000F800F80000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000001F001F00000000001F001F00010001001F001F00030003001F
      003F003F003F003F007FFFFFFFFF007FFFE3FFFFFFFFFE3F0001FC00FFFFF007
      0001C000FFFFC003000182020C00C003000380008401800100079E00C6018000
      000FBF19C0008001000FFFFFE0208000000F001FF0708000000F009FF87F8000
      001F809FFC7F8001001F001FFC7F8001001F801FFE7FC003003FC0FFFFFFE007
      007FF8FFFFFFF00FFFFFF8FFFFFFFFFFF800FFFFFC00F803F800FC00FC000003
      F800000000000003F800000000000003F8000000000000030000000000000003
      0000000000000003000000000000000300000000000000030000000000000003
      00000000001F00030000001F001F001F0001001F001F001F0003001F001F003F
      003F003F003F007FFFFF007F007FFFFFFFFFFFFFFFFFFFFF80018001C001FFFF
      00008001C001FF1F00008001C001FF0F00008001C001FF0F00008001C001FFC7
      00008001C001FDC700008001C001C0C300008001C001C0E300008001C001C0E3
      00008001C001C04300008001C001800300018001C001C803807F8001C001FC03
      C0FF8001C003FE07FFFFFFFFC007FFFF00000000000000000000000000000000
      000000000000}
  end
  object ilToolBarDisabled: TImageList
    Left = 494
    Top = 8
    Bitmap = {
      494C010110001200080010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B9B9B9FF525252FF525252FF525252FF525252FF525252FF5252
      52FF525252FF525252FF525252FF525252FF0000000000000000000000000000
      0000000000009F9F9FFF474747FF474747FF474747FF474747FF474747FF4747
      47FF474747FF474747FF474747FF474747FF0000000000000000000000000000
      00000000000000000000D5D5D5FF9D9D9DFF949494FF989898FF8A8A8AFF8585
      85FF777777FF6E6E6EFF5B5B5BFF606060FF0000000000000000000000000000
      00000000000000000000DBDBDB609A9A9AF0949494FF8F8F8FFF868686FF7979
      79FF747474FF6B6B6BFF5E5E5EFF5E5E5EFF0000000000000000000000000000
      000000000000B9B9B9FFFFFFFFFFB9B9B9FFB9B9B9FFB9B9B9FFB9B9B9FFB9B9
      B9FFB9B9B9FFB9B9B9FFB9B9B9FF525252FF0000000000000000000000000000
      0000000000009F9F9FFFFFFFFFFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F
      9FFF9F9F9FFF9F9F9FFF9F9F9FFF474747FF0000000000000000000000000000
      00000000000000000000ABABABFFC3C3C3FF9D9D9DFF525252FF8A8A8AFFF8F8
      F8FFD5D5D5FF525252FF818181FF6E6E6EFFB4B4B4FF505050FF505050FF5050
      50FF505050FF505050FFA6A6A6FFBDBDBDFF999999FF505050FF8F8F8FFFF4F4
      F4FFCACACAFF505050FF7D7D7DFF6B6B6BFF0000000000000000000000000000
      000000000000B9B9B9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8
      F8FFF8F8F8FFEEEEEEFFB9B9B9FF525252FF0000000000000000000000000000
      0000000000009F9F9FFFFFFFFFFFFFFFFFFFFBFBFBFFF0F0F0FFE8E8E8FFE0E0
      E0FFD8D8D8FFCFCFCFFF9F9F9FFF474747FFB9B9B9FF525252FF525252FF5252
      52FF525252FF525252FFAFAFAFFFD2D2D2FFC3C3C3FF5B5B5BFF777777FFC2C2
      C2FFE8E8E8FF656565FF818181FF6E6E6EFFB4B4B4FFFFFFFFFFB4B4B4FFB4B4
      B4FFB4B4B4FFB4B4B4FFABABABFFCFCFCFFFBDBDBDFF595959FF747474FFBDBD
      BDFFE1E1E1FF626262FF7D7D7DFF6B6B6BFF0000000000000000000000000000
      000000000000B9B9B9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8
      F8FF787878FFF8F8F8FFB9B9B9FF525252FF0000000000000000000000000000
      0000000000009F9F9FFFFFFFFFFFC7C7C7FFC7C7C7FFC7C7C7FFD7D7D7FFD7D7
      D7FF676767FFD8D8D8FF9F9F9FFF474747FFB9B9B9FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFBEBEBEFFD2D2D2FFD2D2D2FF5B5B5BFF5B5B5BFF5B5B
      5BFF5B5B5BFF5B5B5BFF949494FF777777FFB4B4B4FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFAFAFAFFFD3D3D3FFCFCFCFFF595959FF595959FF5959
      59FF595959FF595959FF8F8F8FFF797979FF0000000000000000000000000000
      000000000000B9B9B9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7878
      78FF787878FF818181FFB9B9B9FF525252FF0000000000000000000000000000
      0000000000009F9F9FFFFFFFFFFFCFCFCFFFCFCFCFFFCFCFCFFFD7D7D7FF6767
      67FF676767FF6F6F6FFF9F9F9FFF474747FFB9B9B9FFFFFFFFFFD2D2D2FFD2D2
      D2FFD2D2D2FFE5E5E5FFC3C3C3FFDCDCDCFFD7D7D7FFD2D2D2FFC3C3C3FFBEBE
      BEFFAFAFAFFFA6A6A6FF9D9D9DFF858585FFB4B4B4FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFBDBDBDFFE1E1E1FFD3D3D3FFCFCFCFFFBDBDBDFFB8B8
      B8FFABABABFFA2A2A2FF8F8F8FFF868686FFDDDDDD609E9E9EF0989898FF9494
      94FF8A8A8AFF7C7C7CFF777777FF6E6E6EFF606060FF606060FFFFFFFFFFFFFF
      FFFF787878FFF8F8F8FFB9B9B9FF525252FFD4D4D4608A8A8AF0838383FF7F7F
      7FFF777777FF6B6B6BFF676767FF5F5F5FFF535353FF535353FFD7D7D7FFD7D7
      D7FF676767FFD8D8D8FF9F9F9FFF474747FFB9B9B9FFFFFFFFFFDCDCDCFFDCDC
      DCFFDCDCDCFFE5E5E5FFC7C7C7FFE0E0E0FFB9B9B9FFB0B0B0FF9D9D9DFF8181
      81FF787878FF818181FFA6A6A6FF8A8A8AFFB4B4B4FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFC1C1C1FFE6E6E6FFB4B4B4FFABABABFF999999FF8686
      86FF747474FF7D7D7DFFA2A2A2FF868686FFABABABFFC3C3C3FF9D9D9DFF5252
      52FF949494FFF8F8F8FFD0D0D0FF525252FF818181FF6E6E6EFFFFFFFFFFF8F8
      F8FF8A8A8AFFFFFFFFFFB9B9B9FF525252FF939393FFA7A7A7FF878787FF4747
      47FF7F7F7FFFD8D8D8FFB3B3B3FF474747FF6F6F6FFF5F5F5FFFD7D7D7FFD7D7
      D7FF777777FFE8E8E8FF9F9F9FFF474747FFB9B9B9FFFFFFFFFFDCDCDCFFE5E5
      E5FFE5E5E5FFE5E5E5FFCCCCCCFFE5E5E5FFB9B9B9FFFFFFFFFFFFFFFFFFFFFF
      FFFFF8F8F8FF818181FFAFAFAFFF949494FFBDBDBDFFFFFFFFFFFFFFFFFFFFFF
      FFFF868686FFF4F4F4FFC6C6C6FFEAEAEAFFBDBDBDFFFFFFFFFFFFFFFFFFFFFF
      FFFFF4F4F4FF868686FFABABABFF8F8F8FFFAFAFAFFFD2D2D2FFC3C3C3FF5B5B
      5BFF777777FFC2C2C2FFE8E8E8FF656565FF818181FF6E6E6EFFFFFFFFFF7878
      78FFDFDFDFFFFFFFFFFFB9B9B9FF525252FF979797FFB7B7B7FFA7A7A7FF4F4F
      4FFF676767FFA7A7A7FFC7C7C7FF575757FF6F6F6FFF5F5F5FFFD7D7D7FF6767
      67FFD7D7D7FFE8E8E8FF9F9F9FFF474747FFC2C2C2FFFFFFFFFFE5E5E5FFE5E5
      E5FF8A8A8AFFE5E5E5FFD7D7D7FFEAEAEAFFC9C9C9FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF9D9D9DFF9D9D9DFF989898FFC6C6C6FFFFFFFFFFBDBDBDFF7474
      74FF747474FF7D7D7DFFD3D3D3FFF8F8F8FFCFCFCFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF999999FF8F8F8FFF949494FFB3B3B3FFD7D7D7FFD2D2D2FF5B5B
      5BFF5B5B5BFF5B5B5BFF5B5B5BFF5B5B5BFF949494FF7C7C7CFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFB9B9B9FF525252FF9B9B9BFFBBBBBBFFB7B7B7FF4F4F
      4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF7F7F7FFF6B6B6BFFD7D7D7FFD7D7
      D7FFD7D7D7FFF0F0F0FF9F9F9FFF474747FFCBCBCBFFFFFFFFFFC2C2C2FF7878
      78FF787878FF818181FFDCDCDCFFEEEEEEFFD2D2D2FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB0B0B0FF6E6E6EFF949494FFC6C6C6FFFFFFFFFF747474FFFFFF
      FFFF868686FFFFFFFFFFD8D8D8FFFCFCFCFFE1E1E1FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFABABABFF6B6B6BFF949494FFC3C3C3FFDCDCDCFFD7D7D7FFD2D2
      D2FFC3C3C3FFBEBEBEFFAFAFAFFFA6A6A6FF949494FF8A8A8AFFFFFFFFFFFFFF
      FFFFFFFFFFFFB9B9B9FFB9B9B9FF525252FFA7A7A7FFC7C7C7FFBBBBBBFFB7B7
      B7FFA7A7A7FFA3A3A3FF979797FF8F8F8FFF7F7F7FFF777777FFD7D7D7FFD7D7
      D7FFCFCFCFFF9F9F9FFF9F9F9FFF474747FFCBCBCBFFFFFFFFFF787878FFE5E5
      E5FF8A8A8AFFE5E5E5FFDCDCDCFFD5D5D5FFD7D7D7FFCCCCCCFFC7C7C7FFC3C3
      C3FFB3B3B3FFAFAFAFFFABABABFFA6A6A6FFCFCFCFFFFFFFFFFF747474FFFFFF
      FFFFFFFFFFFFFFFFFFFFD8D8D8FFD8D8D8FFD3D3D3FFC6C6C6FFC1C1C1FFBDBD
      BDFFAFAFAFFFABABABFFA6A6A6FFA2A2A2FFC7C7C7FFE0E0E0FFB9B9B9FFB0B0
      B0FF9D9D9DFF8A8A8AFF787878FF818181FFA6A6A6FF8A8A8AFFFFFFFFFFFFFF
      FFFFB9B9B9FF525252FF525252FF525252FFABABABFFCBCBCBFF9F9F9FFF9797
      97FF878787FF777777FF676767FF6F6F6FFF8F8F8FFF777777FFD7D7D7FFD7D7
      D7FF9F9F9FFF474747FF474747FF474747FFD5D5D5FFFFFFFFFF787878FFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFFFFFFFFF6E6E6EFF0000
      000000000000000000000000000000000000CFCFCFFFFFFFFFFF6B6B6BFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB4B4B4FFB4B4B4FF505050FF0000
      000000000000000000000000000000000000CCCCCCFFE5E5E5FFC0C0C0FFFFFF
      FFFFFFFFFFFFFFFFFFFFF8F8F8FF8A8A8AFFAFAFAFFF949494FFFFFFFFFFFFFF
      FFFFC2C2C2FFE8E8E8FF525252FFE7E7E790AFAFAFFFCFCFCFFFA7A7A7FFFFFF
      FFFFF7F7F7FFE8E8E8FFD8D8D8FF777777FF979797FF7F7F7FFFDFDFDFFFDFDF
      DFFFA7A7A7FFC7C7C7FF474747FFD6D6D690D5D5D5FFFFFFFFFF6E6E6EFFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFDCDCDCFFE8E8E8FF525252FF0000
      000000000000000000000000000000000000D8D8D8FFFFFFFFFFB4B4B4FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB4B4B4FF505050FF505050FF505050FF0000
      000000000000000000000000000000000000D7D7D7FFEAEAEAFFC9C9C9FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF9D9D9DFF939393FF989898FFFFFFFFFFFFFF
      FFFFCBCBCBFF525252FFE7E7E79000000000BBBBBBFFDBDBDBFFB7B7B7FFFFFF
      FFFFFFFFFFFFF7F7F7FFE8E8E8FF878787FF7F7F7FFF838383FFFFFFFFFFFFFF
      FFFFAFAFAFFF474747FFD6D6D69000000000DFDFDFFFFFFFFFFFB9B9B9FFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFB9B9B9FF525252FF525252FF525252FF0000
      000000000000000000000000000000000000D8D8D8FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBDBDBDFFE1E1E1FF505050FFE3E3E3900000
      000000000000000000000000000000000000DCDCDCFFEEEEEEFFD2D2D2FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB0B0B0FF6E6E6EFF989898FFDFDFDFFFDFDF
      DFFFD5D5D5FFE7E7E7900000000000000000BFBFBFFFDFDFDFFFC7C7C7FFFFFF
      FFFFFFFFFFFFFFFFFFFFF7F7F7FF979797FF5F5F5FFF838383FFBFBFBFFFBFBF
      BFFFB7B7B7FFD6D6D6900000000000000000DFDFDFFFFFFFFFFFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFC2C2C2FFE8E8E8FF525252FFE7E7E7900000
      000000000000000000000000000000000000E1E1E1FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6FF505050FFE3E3E390000000000000
      000000000000000000000000000000000000DCDCDCFFDCDCDCFFD7D7D7FFCCCC
      CCFFC7C7C7FFC3C3C3FFB3B3B3FFAFAFAFFFABABABFFA6A6A6FF000000000000
      000000000000000000000000000000000000BFBFBFFFBFBFBFFFBBBBBBFFAFAF
      AFFFABABABFFA7A7A7FF9B9B9BFF979797FF939393FF8F8F8FFF000000000000
      000000000000000000000000000000000000E5E5E5FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCBCBCBFF525252FFE7E7E790000000000000
      000000000000000000000000000000000000E1E1E1FFE1E1E1FFE1E1E1FFE1E1
      E1FFE1E1E1FFD8D8D8FFD8D8D8FFCFCFCFFFE3E3E39000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFE5E5E5FFDFDFDFFFDFDFDFFFD5D5D5FFE7E7E79000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDC7
      D1501F2F3FFFB8C0C75000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FDFCFA10FDFCFA10FCFCFA10000000000000
      000000000000000000000000000000000000AF9F8FFF5F472FFF5F472FFF5F47
      2FFF5F472FFF5F472FFF5F472FFF5F472FFF5F472FFF5F472FFF4F473FFF2F4F
      5FFF3F77BFFF2F475FFFBDC7CC50000000000000000000000000000000000000
      00000000000000000000C7C7C7503F473FFF626262D04F473FFF2F2F2FFF969A
      9680D2E5D230107F10FF3A8E2DE0B4D4B4500000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E9E2D730BEAA8E80AA7A4BC08E5D3AE09E7456C0A6805AB0AE9E8780DDD9
      D230FCFBFA10000000000000000000000000AF9F8FFFFFFFFFFFAF9F8FFFAF9F
      8FFFAF9F8FFFAF9F8FFFAF9F8FFFAF9F8FFFAF9F8FFF8F877FFF2F4F6FFF2F7F
      D0FF3F97E0FF4FAFF0FF4F676FFF000000000000000000000000F6F5F310F6F5
      F3107F674FFFE9E3E030C7CAC7505F575FFFC7CAC750CED0CE402F2F2FFFB4D6
      B450005F00FF69AE69A0AAD1A560108710FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FDF8F310D4BC
      A370C28E68F0E0C8AFFFF0F0F0FFFFFFFFFFFFFFFFFFF0F0F0FFE0C8BFFFB698
      7AC0B6B0A560FCFBFA100000000000000000AF9F8FFFFFFFFFFFFFFFFFFFFFF8
      FFFFF0F0F0FFD0D8D0FF8F978FFF6F675FFF5F675FFF4F575FFF3F6F8FFF3F9F
      E0FF5FC8FFFF6F8F9FFFD1D9DB500000000000000000EEE9E620866859F07F5F
      4FFF7F5F4FFF7F674FFF00000000D6D4D6409A959AA06F6F6FD03F373FFFB4D6
      B450107F10FF96C6967000000000F0F5F010C6C6C6707F7F7FFF7F7F7FFF7F7F
      7FFF0000000000000000969696D07F7F7FFF7F7F7FFF8E8E8EE0B6B6B6908E8E
      8EE0C6C6C670969696D08E8E8EE0BEBEBE800000000000000000DBBFA370E0A7
      7FFFFFF0E0FFE0B79FFFD07F4FFFBF571FFFBF571FFFD07F4FFFE0B79FFFF0E8
      E0FFB39577F0BCB0A5600000000000000000AF9F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFE0E0E0FF8F8F8FFFAFA79FFFD0BFAFFFD0AF9FFF7F776FFF4F574FFF5F8F
      AFFF6F97AFFFB6C2C6800000000000000000000000007F573FFFB6A09290EEE9
      E62086604AF0EEEAE820F3F3F310B6B6B660E6E7E620929292902F2F2FFFD2E6
      D2301F8F1FFF8EBE8780AAD1A5602F9F1FFF00000000D6D6D6507F7F7FFFC6C6
      C670F6F6F61000000000E6E6E6307F7F7FFF7F7F7FFFAEAEAEA0868686F0B6B6
      B6908E8E8EE08E8E8EE0C6C6C6700000000000000000EFE5D730D29D77F0FFF0
      E0FFE0A78FFFBF4F10FFBF4F10FFE0A78FFFFFFFFFFFAF4710FFAF4710FFD09F
      7FFFF0F0E0FFB0896FD0DDD9D23000000000AF9F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFAFAFAFFFBFB7AFFFFFF0E0FFFFE8E0FFF0D8BFFFF0D0AFFF7F776FFFA4A0
      A490B6C2C680000000000000000000000000000000007F573FFFF6F4F2100000
      0000000000000000000000000000AAAAAA70565656E04A4A4AF0626862C0F1F1
      F110C3DEC3401F8F1FFF108710FFB4D6B4500000000000000000A6A6A6B08E8E
      8EE0D6D6D65000000000000000007F7F7FFF7F7F7FFFDEDEDE40868686F0CECE
      CE60EEEEEE208E8E8EE0AEAEAEA00000000000000000D6BA9E80F0D8BFFFF0C8
      AFFFE0571FFFD05710FFD04F10FFE07F4FFFE0A77FFFBF4F10FFAF4710FFAF47
      10FFE0B79FFFE0C8BFFFA69E8780FCFCFC10BFA78FFFFFFFFFFFFFFFFFFFFFFF
      FFFF9F978FFFF0E8E0FFFFF8F0FFFFF0F0FFFFE8E0FFF0D8D0FFD0AF9FFF646B
      64E00000000000000000000000000000000000000000CEBFB660000000000000
      000000000000000000000000000000000000D6D6D640C7C7C750F3F3F3100000
      000000000000F0F6F010F0F6F010000000000000000000000000F6F6F6109E9E
      9EC0868686F07F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFFE6E6E630C6C6C6708686
      86F0EEEEEE20DEDEDE40969696D0DEDEDE4000000000D58E56E0FFF8F0FFF097
      6FFFF05F1FFFE0571FFFE0571FFFF0A78FFFFFFFFFFFD04F10FFBF4F10FFAF4F
      10FFBF774FFFF0F0F0FF9E6E56C000000000BFA79FFFFFFFFFFFFFFFFFFFFFFF
      FFFF9F9F8FFFF0E8E0FFFFFFFFFFFFF8F0FFFFF0F0FFFFE8E0FFE0BFAFFF7272
      72E0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E6E6
      E630868686F0C6C6C670EEEEEE20868686F07F7F7FFFF6F6F61000000000BEBE
      BE80969696D0E6E6E630969696D0B6B6B69000000000D2864AF0FFFFFFFFFF77
      3FFFFF672FFFF0671FFFF05F1FFFF0874FFFFFFFFFFFF0BFAFFFBF571FFFAF4F
      10FFAF571FFFFFFFFFFF8E5D3AE0FDFCFA10BFAF9FFFFFFFFFFFFFFFFFFFFFFF
      FFFFBFC8BFFFBFBFBFFFFFFFFFFFFFFFFFFFFFF8F0FFFFF0E0FFAF9F8FFFAEAE
      AE8000000000000000000000000000000000C7C5C7503F3F3FFF6E686EC0555B
      55D02F372FFFDADCDA30C2C2C250C2C5C250D7D6D730CAC8CA40F1F1F1100000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C670868686F0C6C6C6708E8E8EE07F7F7FFF00000000000000000000
      0000E6E6E630A6A6A6B0D6D6D6509E9E9EC000000000D28E59F0FFFFFFFFFF7F
      4FFFFF6F2FFFFF672FFFFF672FFFFF671FFFF08F5FFFFFF8F0FFF0D8BFFFBF4F
      1FFFBF571FFFFFFFFFFF8E5D3AE0FDFCFC10D0AF9FFFFFFFFFFFFFFFFFFFFFFF
      FFFFF0F8FFFFBFB7AFFFBFBFBFFFF0E8E0FFF0E8E0FFAFAF9FFF6F6F5FFFF6F5
      F41000000000000000000000000000000000C7C7C7504F574FFFBCBCBC60B6B9
      B6602F372FFFF2F2F210B6B9B660D7D6D73000000000CAC8CA40BDBBBD500000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AEAEAEA0969696D08E8E8EE07F7F7FFF00000000000000000000
      00000000000000000000000000000000000000000000DB9E7AC0FFF8F0FFFFA7
      7FFFFF6F3FFFFF874FFFFFAF8FFFFF6F2FFFF0671FFFF08F6FFFFFFFFFFFF07F
      4FFFD0875FFFFFF0F0FFA68B64B0FDFCFC10D0B79FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF0F8FFFFBFC8BFFF9F9F8FFF8F8F7FFF8F8F8FFF5F4F3FFF0000
      00000000000000000000000000000000000000000000D2D4D240909590A06F6F
      6FD03F373FFFF1F1F110B6B9B660D7D6D73000000000D7D6D730BDBBBD500000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000969696D07F7F7FFF7F7F7FFF00000000000000000000
      00000000000000000000000000000000000000000000E2C6AA70F0D8BFFFFFD0
      BFFFFF773FFFFF976FFFFFFFFFFFFFC8AFFFFF8F5FFFFFC8AFFFFFF8F0FFF077
      3FFFF0C8AFFFE0C8AFFFCDB89C7000000000D0B7AFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFAF9F8FFF5F472FFF5F472FFF5F472FFF0000
      000000000000000000000000000000000000F3F3F310BCB9BC60E8E8E8209B9B
      9B903F3F3FFFF1F2F110B6B9B660D7D6D730F1F1F110BDBBBD50BDBBBD500000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E6E6E630969696D07F7F7FFF00000000000000000000
      00000000000000000000000000000000000000000000F2E8DA30E1A477F0FFF8
      F0FFFFBF9FFFFF773FFFFFB79FFFFFF8F0FFFFFFFFFFFFF0E0FFFF976FFFF0B7
      9FFFFFF0E0FFC69564E0ECE2D43000000000D0BFAFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFA78FFFD0C8BFFF5F472FFFE4D1C8900000
      00000000000000000000000000000000000000000000B1B1B170646464E05951
      59F06E6E6EC0F1F1F110B6B9B660C2C5C250DADCDA30CAC8CA40F1F1F1100000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D6D6D650969696D000000000000000000000
      0000000000000000000000000000000000000000000000000000E6D1B660E1BB
      A4F0FFF8F0FFFFD0BFFFFFA77FFFFF874FFFFF874FFFFFA77FFFF0D0BFFFFFF0
      E0FFD2AC86F0DAC5B0600000000000000000E0BFAFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFA79FFF5F472FFFE4D1C890000000000000
      0000000000000000000000000000000000000000000000000000D6D4D640C7C7
      C750F3F3F310F1F1F110B6B9B660D7D6D7300000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E6D1
      B660E1A477F0F0D8BFFFFFF8F0FFFFFFFFFFFFFFFFFFFFF8F0FFF0D8BFFFC69C
      72E0E0D1BD50000000000000000000000000E0BFAFFFE0BFAFFFE0BFAFFFE0BF
      AFFFE0BFAFFFD0BFAFFFD0B7AFFFD0AF9FFFE4D1C89000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F1F2F110B6B9B660D7D6D7300000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F2E8DA30E2C6AA70E7B692C0D5A380E0D29D68F0D8AA89D0DBC3AA70F4ED
      E620000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DAD9DA30BCB9BC60E4E4E4200000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B9B9B9FF525252FF525252FF525252FF525252FF525252FF5252
      52FF525252FF525252FF525252FF525252FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D5D5D5FF9D9D9DFF949494FF989898FF8A8A8AFF8585
      85FF777777FF6E6E6EFF5B5B5BFF606060FF0000000000000000000000000000
      000000000000BFA78FFF5F472FFF5F472FFF5F472FFF5F472FFF5F472FFF5F47
      2FFF6F4F3FFF5F472FFF00000000000000000000000000000000000000000000
      000000000000B9B9B9FFFFFFFFFFB9B9B9FFB9B9B9FFB9B9B9FFB9B9B9FFB9B9
      B9FFB9B9B9FFB9B9B9FFB9B9B9FF525252FF0000000000000000000000000000
      00000000000000000000DBDBDB609A9A9AF0949494FF8F8F8FFF868686FF7979
      79FF747474FF6B6B6BFF5E5E5EFF5E5E5EFF0000000000000000000000000000
      00000000000000000000ABABABFFC3C3C3FF9D9D9DFF525252FF8A8A8AFFF8F8
      F8FFD5D5D5FF525252FF818181FF6E6E6EFFAF9F8FFF5F472FFF5F4F3FFF7F67
      4FFFAFA79FFFBFA78FFFFFF8FFFFE0D8D0FFE0D0D0FFE0D0BFFFD0C8BFFFD0C8
      BFFFE0C8BFFF5F4F3FFF00000000000000000000000000000000000000000000
      000000000000B9B9B9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8
      F8FFF8F8F8FFEEEEEEFFB9B9B9FF525252FFB4B4B4FF505050FF505050FF5050
      50FF505050FF505050FFA6A6A6FFBDBDBDFF999999FF505050FF8F8F8FFFF4F4
      F4FFCACACAFF505050FF7D7D7DFF6B6B6BFFB9B9B9FF525252FF525252FF5252
      52FF525252FF525252FFAFAFAFFFD2D2D2FFC3C3C3FF5B5B5BFF777777FFC2C2
      C2FFE8E8E8FF656565FF818181FF6E6E6EFFAF9F8FFFFFF8FFFFD0D8D0FFE0D8
      D0FFF0E8E0FFBFA78FFFFFF8FFFFD0B79FFFD0AF9FFFD0AF9FFFD0A78FFFBFA7
      8FFFE0C8BFFF5F4F3FFF00000000000000000000000000000000000000000000
      000000000000B9B9B9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8
      F8FF787878FFF8F8F8FFB9B9B9FF525252FFB4B4B4FFFFFFFFFFB4B4B4FFB4B4
      B4FFB4B4B4FFB4B4B4FFABABABFFCFCFCFFFBDBDBDFF595959FF747474FFBDBD
      BDFFE1E1E1FF626262FF7D7D7DFF6B6B6BFFB9B9B9FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFBEBEBEFFD2D2D2FFD2D2D2FF5B5B5BFF5B5B5BFF5B5B
      5BFF5B5B5BFF5B5B5BFF949494FF777777FFAF9F8FFFFFFFFFFFFFF8FFFFFFF8
      F0FFFFF8F0FFBFA79FFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8F0FFFFF0
      E0FFD0C8BFFF6F4F3FFF00000000000000000000000000000000000000000000
      000000000000B9B9B9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7878
      78FF787878FF818181FFB9B9B9FF525252FFB4B4B4FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFAFAFAFFFD3D3D3FFCFCFCFFF595959FF595959FF5959
      59FF595959FF595959FF8F8F8FFF797979FFB9B9B9FFFFFFFFFFD2D2D2FFD2D2
      D2FFD2D2D2FFE5E5E5FFC3C3C3FFDCDCDCFFD7D7D7FFD2D2D2FFC3C3C3FFBEBE
      BEFFAFAFAFFFA6A6A6FF9D9D9DFF858585FFAF9F8FFFFFFFFFFFBF9F8FFFBFAF
      9FFFE0D0D0FFBFA79FFFFFF8FFFFD0BFAFFFD0BFAFFFD0BFAFFFD0B7AFFFD0B7
      AFFFE0C8BFFF6F4F3FFF0000000000000000DDDDDD609E9E9EF0989898FF9494
      94FF8A8A8AFF7C7C7CFF777777FF6E6E6EFF606060FF606060FFFFFFFFFFFFFF
      FFFF787878FFF8F8F8FFB9B9B9FF525252FFB4B4B4FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFBDBDBDFFE1E1E1FFD3D3D3FFCFCFCFFFBDBDBDFFB8B8
      B8FFABABABFFA2A2A2FF8F8F8FFF868686FFB9B9B9FFFFFFFFFFDCDCDCFFDCDC
      DCFFDCDCDCFFE5E5E5FFC7C7C7FFE0E0E0FFB9B9B9FFB0B0B0FF9D9D9DFF8181
      81FF787878FF818181FFA6A6A6FF8A8A8AFFAF9F8FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF8FFFFBFAF9FFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8
      F0FFE0D0D0FF6F573FFF0000000000000000ABABABFFC3C3C3FF9D9D9DFF5252
      52FF949494FFF8F8F8FFD0D0D0FF525252FF818181FF6E6E6EFFFFFFFFFFF8F8
      F8FF8A8A8AFFFFFFFFFFB9B9B9FF525252FFB4B4B4FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFC1C1C1FFE6E6E6FFB4B4B4FFABABABFF999999FF8686
      86FF747474FF7D7D7DFFA2A2A2FF868686FFB9B9B9FFFFFFFFFFDCDCDCFFE5E5
      E5FFE5E5E5FFE5E5E5FFCCCCCCFFE5E5E5FFB9B9B9FFFFFFFFFFFFFFFFFFFFFF
      FFFFF8F8F8FF818181FFAFAFAFFF949494FFBFA78FFFFFFFFFFFBFA79FFFD0AF
      9FFFE0D8D0FFBFAF9FFFFFF8FFFFD0BFAFFFD0BFAFFFD0BFAFFFD0BFAFFFD0BF
      AFFFE0D8D0FF6F573FFF0000000000000000AFAFAFFFD2D2D2FFC3C3C3FF5B5B
      5BFF777777FFC2C2C2FFE8E8E8FF656565FF818181FF6E6E6EFFFFFFFFFF7878
      78FFDFDFDFFFFFFFFFFFB9B9B9FF525252FFBDBDBDFFFFFFFFFFFFFFFFFFFFFF
      FFFF868686FFF4F4F4FFC6C6C6FFEAEAEAFFBDBDBDFFFFFFFFFFFFFFFFFFFFFF
      FFFFF4F4F4FF868686FFABABABFF8F8F8FFFC2C2C2FFFFFFFFFFE5E5E5FFE5E5
      E5FF8A8A8AFFE5E5E5FFD7D7D7FFEAEAEAFFC9C9C9FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF9D9D9DFF9D9D9DFF989898FFBFA79FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFBFAF9FFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8FFFFFFF8
      FFFFFFF8FFFF6F573FFF0000000000000000B3B3B3FFD7D7D7FFD2D2D2FF5B5B
      5BFF5B5B5BFF5B5B5BFF5B5B5BFF5B5B5BFF949494FF7C7C7CFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFB9B9B9FF525252FFC6C6C6FFFFFFFFFFBDBDBDFF7474
      74FF747474FF7D7D7DFFD3D3D3FFF8F8F8FFCFCFCFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF999999FF8F8F8FFF949494FFCBCBCBFFFFFFFFFFC2C2C2FF7878
      78FF787878FF818181FFDCDCDCFFEEEEEEFFD2D2D2FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB0B0B0FF6E6E6EFF949494FFBFAF9FFFFFFFFFFFD0AF9FFFD0B7
      AFFFE0D8D0FFBFAF9FFFBFAF9FFFBFAF9FFFBFAF9FFFBFAF9FFFBFAF9FFFBFA7
      9FFFBFA79FFFBFA79FFF0000000000000000C3C3C3FFDCDCDCFFD7D7D7FFD2D2
      D2FFC3C3C3FFBEBEBEFFAFAFAFFFA6A6A6FF949494FF8A8A8AFFFFFFFFFFFFFF
      FFFFFFFFFFFFB9B9B9FFB9B9B9FF525252FFC6C6C6FFFFFFFFFF747474FFFFFF
      FFFF868686FFFFFFFFFFD8D8D8FFFCFCFCFFE1E1E1FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFABABABFF6B6B6BFF949494FFCBCBCBFFFFFFFFFF787878FFE5E5
      E5FF8A8A8AFFE5E5E5FFDCDCDCFFD5D5D5FFD7D7D7FFCCCCCCFFC7C7C7FFC3C3
      C3FFB3B3B3FFAFAFAFFFABABABFFA6A6A6FFD0AF9FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF8F8F8FFFFFFFFFFF8F8F8FFFFFFFFFFF7F7F7FFFFFFFFFFF7F7F
      7FFFFFFFFFFF5F575FFF0000000000000000C7C7C7FFE0E0E0FFB9B9B9FFB0B0
      B0FF9D9D9DFF8A8A8AFF787878FF818181FFA6A6A6FF8A8A8AFFFFFFFFFFFFFF
      FFFFB9B9B9FF525252FF525252FF525252FFCFCFCFFFFFFFFFFF747474FFFFFF
      FFFFFFFFFFFFFFFFFFFFD8D8D8FFD8D8D8FFD3D3D3FFC6C6C6FFC1C1C1FFBDBD
      BDFFAFAFAFFFABABABFFA6A6A6FFA2A2A2FFD5D5D5FFFFFFFFFF787878FFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFFFFFFFFF6E6E6EFF0000
      000000000000000000000000000000000000D0B79FFFFFFFFFFFD0B7AFFFD0B7
      AFFFE0C8BFFFE0D8D0FF1F271FFFBFBFBFFF1F271FFF9F8F7FFF1F271FFF9F8F
      7FFF1F271FFFAF978FFF0000000000000000CCCCCCFFE5E5E5FFC0C0C0FFFFFF
      FFFFFFFFFFFFFFFFFFFFF8F8F8FF8A8A8AFFAFAFAFFF949494FFFFFFFFFFFFFF
      FFFFC2C2C2FFE8E8E8FF525252FFE7E7E790CFCFCFFFFFFFFFFF6B6B6BFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB4B4B4FFB4B4B4FF505050FF0000
      000000000000000000000000000000000000D5D5D5FFFFFFFFFF6E6E6EFFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFDCDCDCFFE8E8E8FF525252FF0000
      000000000000000000000000000000000000D0B7AFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFD0C8BFFFAF9F8FFFAFA79FFFAFA79FFF0000
      000000000000000000000000000000000000D7D7D7FFEAEAEAFFC9C9C9FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF9D9D9DFF939393FF989898FFFFFFFFFFFFFF
      FFFFCBCBCBFF525252FFE7E7E79000000000D8D8D8FFFFFFFFFFB4B4B4FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB4B4B4FF505050FF505050FF505050FF0000
      000000000000000000000000000000000000DFDFDFFFFFFFFFFFB9B9B9FFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFB9B9B9FF525252FF525252FF525252FF0000
      000000000000000000000000000000000000D0BFAFFFFFFFFFFFD0BFAFFFD0BF
      AFFFD0BFAFFFD0BFAFFFFFFFFFFFBFAF9FFFE0D0BFFF7F674FFFE4D6C8900000
      000000000000000000000000000000000000DCDCDCFFEEEEEEFFD2D2D2FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB0B0B0FF6E6E6EFF989898FFDFDFDFFFDFDF
      DFFFD5D5D5FFE7E7E7900000000000000000D8D8D8FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBDBDBDFFE1E1E1FF505050FFE3E3E3900000
      000000000000000000000000000000000000DFDFDFFFFFFFFFFFEEEEEEFFEEEE
      EEFFEEEEEEFFEEEEEEFFEEEEEEFFC2C2C2FFE8E8E8FF525252FFE7E7E7900000
      000000000000000000000000000000000000E0BFAFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFAF9FFF5F4F3FFFE4D6C890000000000000
      000000000000000000000000000000000000DCDCDCFFDCDCDCFFD7D7D7FFCCCC
      CCFFC7C7C7FFC3C3C3FFB3B3B3FFAFAFAFFFABABABFFA6A6A6FF000000000000
      000000000000000000000000000000000000E1E1E1FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6FF505050FFE3E3E390000000000000
      000000000000000000000000000000000000E5E5E5FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCBCBCBFF525252FFE7E7E790000000000000
      000000000000000000000000000000000000E0BFAFFFE0BFAFFFE0BFAFFFE0BF
      AFFFE0BFAFFFD0BFAFFFD0B7AFFFD0AF9FFFE4D1C89000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E1E1E1FFE1E1E1FFE1E1E1FFE1E1
      E1FFE1E1E1FFD8D8D8FFD8D8D8FFCFCFCFFFE3E3E39000000000000000000000
      000000000000000000000000000000000000E5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFE5E5E5FFDFDFDFFFDFDFDFFFD5D5D5FFE7E7E79000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F4F4F40BDCDCDC23D0D0
      D02FD0D0D02FD0D0D02FD0D0D02FD0D0D02FD0D0D02FD0D0D02FD0D0D02FD0D0
      D02FD0D0D02FDCDCDC23F4F4F40B0000000000000000E7E7E750A6A6A6FF9494
      94FF8A8A8AFF8A8A8AFF8A8A8AFF7C7C7CFF777777FF777777FF6E6E6EFF6A6A
      6AFF6A6A6AFF606060FF5B5B5BFF000000000000000000000000A3A3A3FFA3A3
      A3FFA3A3A3FFA3A3A3FFA3A3A3FFA3A3A3FFA3A3A3FFA3A3A3FFA3A3A3FFA3A3
      A3FFA3A3A3FFA3A3A3FF8A8A8AFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F4F4F40BC4C4C43B888888777070
      708F7070708F7070708F7070708F7070708F7070708F7070708F7070708F7070
      708F7070708F88888877C4C4C43BF4F4F40B00000000B4B4B4FFD2D2D2FFC9C9
      C9FF787878FF363636FFD5D5D5FFD5D5D5FFE8E8E8FFE8E8E8FF5C5C5CFF7777
      77FF777777FF777777FF606060FF000000000000000000000000A4A4A4FFFAFA
      FAFFFAFAFAFFF9F9F9FFECECECFFF2F2F2FFEDEDEDFFECECECFFE7E7E7FFE4E4
      E4FFDFDFDFFFDEDEDEFF8D8D8DFF000000000000000000000000000000000000
      000000000000000000000000000000000000E3E3E360CDCDCD80F7F7F7100000
      000000000000000000000000000000000000DCDCDC230C72A5FF0C72A5FF0C72
      A5FF0C72A5FF0C72A5FF0C72A5FF0C72A5FF0C72A5FF0C72A5FF0C72A5FF0C72
      A5FF0C72A5FF6464649B88888877DCDCDC2300000000B9B9B9FFD7D7D7FFC9C9
      C9FFC9C9C9FF6E6E6EFF3F3F3FFF939393FFFFFFFFFFFFFFFFFF939393FF7777
      77FF818181FF777777FF6A6A6AFF000000000000000000000000A9A9A9FFFEFE
      FEFFFEFEFEFF595959FFDBDBDBFFB3B3B3FF7F7F7FFFA3A3A3FFE0E0E0FFE4E4
      E4FFDEDEDEFFDEDEDEFF919191FF000000000000000000000000000000000000
      000000000000000000000000000000000000EAEAEA40ADADADFF9D9D9DFFD4D4
      D45000000000000000000000000000000000189AC6FF1B9CC7FF9CFFFFFF6BD7
      FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7
      FFFF2899BFFF0C72A5FF7070708FD0D0D02F00000000B9B9B9FFDCDCDCFFD2D2
      D2FFC9C9C9FF6E6E6EFF000000FF3F3F3FFFF8F8F8FFF8F8F8FF818181FF8A8A
      8AFF8A8A8AFF818181FF6E6E6EFF000000000000000000000000ADADADFFFFFF
      FFFFFFFFFFFF595959FF595959FF595959FF595959FF595959FF7E7E7EFFE7E7
      E7FFE2E2E2FFE2E2E2FF939393FF000000000000000000000000000000000000
      000000000000000000000000000000000000F5F5F520DADADA60ADADADFFACAC
      ACF000000000000000000000000000000000189AC6FF199AC6FF79E4F0FF9CFF
      FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BDF
      FFFF42B2DEFF197A9DFF6464649BB8B8B84700000000BEBEBEFFE0E0E0FFDCDC
      DCFFD2D2D2FF6E6E6EFF6E6E6EFF6E6E6EFF6E6E6EFF6E6E6EFF818181FF9D9D
      9DFF949494FF8A8A8AFF6E6E6EFF000000000000000000000000B2B2B2FFFFFF
      FFFFFFFFFFFF595959FF595959FF646464FFDBDBDBFFF3F3F3FF6D6D6DFFE7E7
      E7FFE6E6E6FFE6E6E6FF989898FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A6A6A6D0ADAD
      ADFFCDCDCD80000000000000000000000000189AC6FF25A2CFFF3FB8D7FF9CFF
      FFFF84EBFFFF84EBFFFF84EBFFFF84EBFFFF84EBFFFF84EBFFFF84EBFFFF84E7
      FFFF42BAEFFF189AC6FF6464649B8888887700000000C9C9C9FFE5E5E5FFE5E5
      E5FFDCDCDCFFD2D2D2FFC9C9C9FFC9C9C9FFC4C4C4FFB9B9B9FFB4B4B4FFA6A6
      A6FF9D9D9DFF949494FF777777FF000000000000000000000000B7B7B7FFFFFF
      FFFFFFFFFFFF595959FF595959FF595959FF595959FFF3F3F3FFECECECFFE7E7
      E7FFE6E6E6FFE8E8E8FF9B9B9BFF000000000000000000000000000000000000
      00000000000000000000FDFDFD10000000000000000000000000D8D8D840A3A3
      A3FFB6B6B6FF000000000000000000000000189AC6FF42B3E2FF20A0C9FFA5FF
      FFFF94F7FFFF94F7FFFF94F7FFFF94F7FFFF94F7FFFF94F7FFFF94F7FFFF94F7
      FFFF52BEE7FF5BBCCEFF0C72A5FF7070708F00000000CECECEFFEAEAEAFFE5E5
      E5FFB0B0B0FF9D9D9DFF9D9D9DFF939393FF818181FF818181FF6E6E6EFF6565
      65FFA6A6A6FF9D9D9DFF777777FF000000000000000000000000BCBCBCFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F1F1FFF1F1F1FFF3F3
      F3FFEDEDEDFFECECECFF9E9E9EFF0000000000000000000000009D9D9DFF9D9D
      9DFF939393FF818181FF818181FF6E6E6EFF0000000000000000EFEFEF209393
      93FFADADADFFD7D7D7800000000000000000189AC6FF6FD5FDFF189AC6FF89F0
      F7FF9CFFFFFF9CFFFFFF9CFFFFFF9CFFFFFF9CFFFFFF9CFFFFFF9CFFFFFF9CFF
      FFFF5AC7FFFF96F9FBFF187A9BFF7070708F00000000D2D2D2FFEEEEEEFFB0B0
      B0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F8FFEEEEEEFFEEEE
      EEFF656565FFA6A6A6FF7C7C7CFF000000000000000000000000C2C2C2FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF595959FF595959FF595959FFF9F9
      F9FFF2F2F2FFF0F0F0FFA1A1A1FF000000000000000000000000A7A7A7FF9A9A
      9AFFADADADFFC0C0C0FFB6B6B6FFF1F1F1400000000000000000000000009393
      93FFA8A8A8F0CFCFCFC00000000000000000189AC6FF84D7FFFF189AC6FF6BBF
      DAFFFFFFFFFFFFFFFFFFF7FBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF84E7FFFFFFFFFFFF187DA1FF8888887700000000D7D7D7FFEEEEEEFFB9B9
      B9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F8FFEEEE
      EEFF6E6E6EFFB0B0B0FF8A8A8AFF000000000000000000000000C9C9C9FFFFFF
      FFFFFFFFFFFF656565FFDBDBDBFFFFFFFFFFDBDBDBFF595959FF595959FFF9F9
      F9FFF3F3F3FFF3F3F3FFA4A4A4FF000000000000000000000000A7A7A7FFADAD
      ADFFB6B6B6FFC0C0C0FF9A9A9AB0DFDFDF400000000000000000000000009393
      93FFA2A2A2F0CBCBCBD00000000000000000189AC6FF84EBFFFF4FC1E2FF189A
      C6FF189AC6FF189AC6FF189AC6FF189AC6FF189AC6FF189AC6FF189AC6FF189A
      C6FF189AC6FF189AC6FF1889B1FFC4C4C43B00000000DCDCDCFFEEEEEEFFC0C0
      C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8
      F8FF818181FFB9B9B9FF8A8A8AFF000000000000000000000000CFCFCFFFFFFF
      FFFFFFFFFFFFB3B3B3FF595959FF595959FF595959FF595959FF595959FFF9F9
      F9FFF9F9F9FFF7F7F7FFA8A8A8FF000000000000000000000000B0B0B0FFB6B6
      B6FFC0C0C0FFB1B1B1F08A8A8AFF8A8A8AFFC7C7C77000000000F1F1F1207F7F
      7FF0A2A2A2F0CBCBCBD00000000000000000189AC6FF9CF3FFFF8CF3FFFF8CF3
      FFFF8CF3FFFF8CF3FFFF8CF3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF189AC6FF197A9DFFC4C4C43BF4F4F40B00000000DCDCDCFFEEEEEEFFC9C9
      C9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF818181FFC4C4C4FF8A8A8AFF000000000000000000000000D1D1D1FFFFFF
      FFFFFFFFFFFFFFFFFFFFB3B3B3FF595959FF595959FFDBDBDBFF595959FFF9F9
      F9FFF0F0F0FFE6E6E6FFA9A9A9FF0000000000000000FCFCFC10A6A6A6FFC1C1
      C1E0D2D2D290B9B9B9FFA7A7A7FF939393FF939393FFA0A0A0C0989898E08181
      81FFADADADFFCACACAE00000000000000000189AC6FFFFFFFFFF9CFFFFFF9CFF
      FFFF9CFFFFFF9CFFFFFFFFFFFFFF189AC6FF189AC6FF189AC6FF189AC6FF189A
      C6FF189AC6FFDCDCDC23F4F4F40B0000000000000000E5E5E5FFEEEEEEFFCECE
      CEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF939393FF525252FF949494FF000000000000000000000000D2D2D2FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7
      F7FFABABABFFABABABFFABABABFF000000000000000000000000A6A6A6FFEFEF
      EF4000000000C3C3C3C0B0B0B0FFACACACF0939393FF8A8A8AFF888888F0A8A8
      A8F0CCCCCCF0CACACAE000000000000000000000000021A2CEFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF189AC6FFC4C4C43BF4F4F40B00000000000000000000
      00000000000000000000000000000000000000000000E5E5E5FFEEEEEEFFD2D2
      D2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF9D9D9DFF989898FF989898FF000000000000000000000000D3D3D3FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFA
      FAFFABABABFFB1B1B1FFCFCFCFFF000000000000000000000000000000000000
      00000000000000000000D6D6D6C0C9C9C9FFC3C3C3F0C3C3C3F0C7C7C7E0CCCC
      CCF0D4D4D4F0FAFAFA200000000000000000000000000000000021A2CEFF21A2
      CEFF21A2CEFF21A2CEFFDCDCDC23F4F4F40B0000000000000000000000000000
      00000000000000000000000000000000000000000000E5E5E5FFE5E5E5FFE5E5
      E5FFE5E5E5FFE0E0E0FFDCDCDCFFD7D7D7FFD2D2D2FFD2D2D2FFCECECEFFC9C9
      C9FFBEBEBEFFB9B9B9FFB9B9B9FF000000000000000000000000D4D4D4FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8
      F8FFABABABFFD4D4D4FF00000000000000000000000000000000000000000000
      0000000000000000000000000000EEEEEE60DDDDDDC0E0E0E0E0E4E4E4C0EBEB
      EB90FBFBFB200000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D5D5D5FFCECE
      CEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECE
      CEFFABABABFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFF800F800FC00FC00F800F800FC00
      0000F800F80000000000F800F80000000000F800F80000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000001F001F00000000001F001F00010001001F001F00030003001F
      003F003F003F003F007FFFFFFFFF007FFFE3FFFFFFFFFE3F0001FC00FFFFF007
      0001C000FFFFC003000182020C00C003000380008401800100079E00C6018000
      000FBF19C0008001000FFFFFE0208000000F001FF0708000000F009FF87F8000
      001F809FFC7F8001001F001FFC7F8001001F801FFE7FC003003FC0FFFFFFE007
      007FF8FFFFFFF00FFFFFF8FFFFFFFFFFF800FFFFFC00F803F800FC00FC000003
      F800000000000003F800000000000003F8000000000000030000000000000003
      0000000000000003000000000000000300000000000000030000000000000003
      00000000001F00030000001F001F001F0001001F001F001F0003001F001F003F
      003F003F003F007FFFFF007F007FFFFFFFFFFFFFFFFFFFFF80018001C001FFFF
      00008001C001FF1F00008001C001FF0F00008001C001FF0F00008001C001FFC7
      00008001C001FDC700008001C001C0C300008001C001C0E300008001C001C0E3
      00008001C001C04300008001C001800300018001C001C803807F8001C001FC03
      C0FF8001C003FE07FFFFFFFFC007FFFF00000000000000000000000000000000
      000000000000}
  end
end
