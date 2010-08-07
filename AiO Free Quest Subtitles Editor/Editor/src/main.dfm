object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = '< Title Generated > // Free Quest Editor'
  ClientHeight = 536
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
    Top = 3
    Width = 148
    Height = 407
    Margins.Right = 0
    Align = alLeft
    Caption = ' Files list: '
    Padding.Left = 2
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    TabOrder = 0
    ExplicitHeight = 367
    object lbFilesList: TListBox
      Left = 4
      Top = 17
      Width = 140
      Height = 359
      Align = alClient
      ItemHeight = 13
      PopupMenu = pmFilesList
      TabOrder = 0
      OnClick = lbFilesListClick
      OnContextPopup = lbFilesListContextPopup
      OnDblClick = lbFilesListDblClick
      OnKeyPress = lbFilesListKeyPress
      ExplicitHeight = 319
    end
    object Panel2: TPanel
      Left = 4
      Top = 376
      Width = 140
      Height = 27
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitTop = 336
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
    Top = 3
    Width = 415
    Height = 407
    ActivePage = tsEditor
    Align = alClient
    TabOrder = 1
    OnChange = pcSubsChange
    ExplicitHeight = 367
    object tsEditor: TTabSheet
      Caption = '&Editor'
      ExplicitHeight = 339
      DesignSize = (
        407
        379)
      object Label4: TLabel
        Left = 146
        Top = 359
        Width = 91
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Second line length:'
        ExplicitTop = 319
      end
      object Label3: TLabel
        Left = 8
        Top = 360
        Width = 77
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'First line length:'
        ExplicitTop = 320
      end
      object Label2: TLabel
        Left = 8
        Top = 330
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
        Top = 359
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
        Top = 288
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
        Top = 356
        Width = 30
        Height = 21
        Anchors = [akLeft, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
        Text = '0'
        ExplicitTop = 316
      end
      object eFirstLineLength: TEdit
        Left = 104
        Top = 356
        Width = 30
        Height = 21
        Anchors = [akLeft, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
        Text = '0'
        ExplicitTop = 316
      end
      object mSubText: TMemo
        Left = 104
        Top = 316
        Width = 300
        Height = 37
        Anchors = [akLeft, akRight, akBottom]
        Lines.Strings = (
          'LINE1'
          'LINE2')
        MaxLength = 90
        TabOrder = 2
        OnChange = mSubTextChange
        ExplicitTop = 276
      end
      object eSubCount: TEdit
        Left = 368
        Top = 356
        Width = 36
        Height = 21
        Anchors = [akLeft, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
        Text = '100'
        ExplicitTop = 316
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
        Height = 169
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
        ExplicitHeight = 129
      end
      object mOldSubEd: TMemo
        Left = 104
        Top = 276
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
        ExplicitTop = 236
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
      ExplicitHeight = 359
      DesignSize = (
        407
        379)
      object GroupBox2: TGroupBox
        Left = 3
        Top = 3
        Width = 401
        Height = 242
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' Global-Translation available strings : '
        TabOrder = 0
        ExplicitHeight = 222
        DesignSize = (
          401
          242)
        object bMTClear: TButton
          Left = 316
          Top = 214
          Width = 80
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Clear...'
          TabOrder = 0
          OnClick = bMTClearClick
          ExplicitTop = 174
        end
        object tvMultiSubs: TTreeView
          Left = 8
          Top = 16
          Width = 387
          Height = 197
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
          ExplicitHeight = 177
        end
        object bMTExpandAll: TButton
          Left = 156
          Top = 214
          Width = 80
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Expand all'
          TabOrder = 2
          OnClick = bMTExpandAllClick
          ExplicitTop = 174
        end
        object bMTCollapseAll: TButton
          Left = 236
          Top = 214
          Width = 80
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Collapse all'
          TabOrder = 3
          OnClick = bMTCollapseAllClick
          ExplicitTop = 174
        end
      end
      object GroupBox4: TGroupBox
        Left = 3
        Top = 248
        Width = 401
        Height = 129
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Anchors = [akLeft, akRight, akBottom]
        Caption = ' Replace the string with : '
        TabOrder = 1
        ExplicitTop = 228
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
        Top = 217
        Width = 80
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Retrieve...'
        TabOrder = 2
        OnClick = bMTRetrieveSubsClick
        ExplicitTop = 177
      end
    end
  end
  object gbDebug: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 413
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
    Top = 517
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
  object MainMenu: TMainMenu
    Left = 80
    Top = 32
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
    Top = 32
  end
  object sdMain: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 48
    Top = 32
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
    Top = 100
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
    Top = 66
  end
  object bfdExportSubs: TJvBrowseForFolderDialog
    Title = 'Select output directory to export all files subtitles:'
    Left = 46
    Top = 66
  end
  object ilMultiSubs: TImageList
    Left = 514
    Top = 140
    Bitmap = {
      494C010109000C00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
end
