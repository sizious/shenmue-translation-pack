object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = '< Title Generated >'
  ClientHeight = 496
  ClientWidth = 572
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object gbFilesList: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 148
    Height = 367
    Margins.Right = 0
    Align = alLeft
    Caption = ' Files list: '
    Padding.Left = 2
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    TabOrder = 0
    object lbFilesList: TListBox
      Left = 4
      Top = 17
      Width = 140
      Height = 319
      Align = alClient
      ItemHeight = 13
      PopupMenu = pmFilesList
      TabOrder = 0
      OnClick = lbFilesListClick
      OnContextPopup = lbFilesListContextPopup
      OnDblClick = lbFilesListDblClick
      OnKeyPress = lbFilesListKeyPress
    end
    object Panel2: TPanel
      Left = 4
      Top = 336
      Width = 140
      Height = 27
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
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
    Height = 367
    ActivePage = tsEditor
    Align = alClient
    TabOrder = 1
    object tsEditor: TTabSheet
      Caption = '&Editor'
      DesignSize = (
        407
        339)
      object Label4: TLabel
        Left = 146
        Top = 319
        Width = 91
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Second line length:'
      end
      object Label3: TLabel
        Left = 8
        Top = 320
        Width = 77
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'First line length:'
      end
      object Label2: TLabel
        Left = 8
        Top = 290
        Width = 65
        Height = 13
        Anchors = [akLeft, akRight, akBottom]
        AutoSize = False
        Caption = 'New text:'
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
        Top = 319
        Width = 75
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Subtitles count:'
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
      object Label18: TLabel
        Left = 8
        Top = 248
        Width = 65
        Height = 13
        Anchors = [akLeft, akRight, akBottom]
        AutoSize = False
        Caption = 'Old text:'
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
        Top = 316
        Width = 30
        Height = 21
        Anchors = [akLeft, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
        Text = '0'
      end
      object eFirstLineLength: TEdit
        Left = 104
        Top = 316
        Width = 30
        Height = 21
        Anchors = [akLeft, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
        Text = '0'
      end
      object mSubText: TMemo
        Left = 104
        Top = 276
        Width = 300
        Height = 37
        Anchors = [akLeft, akRight, akBottom]
        Lines.Strings = (
          'LINE1'
          'LINE2')
        MaxLength = 90
        TabOrder = 2
        OnChange = mSubTextChange
      end
      object eSubCount: TEdit
        Left = 368
        Top = 316
        Width = 36
        Height = 21
        Anchors = [akLeft, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
        Text = '100'
      end
      object eCharID: TEdit
        Left = 230
        Top = 77
        Width = 63
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 4
        Text = '03E'
      end
      object lvSubsSelect: TJvListView
        Left = 104
        Top = 104
        Width = 300
        Height = 129
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'CharID'
          end
          item
            Caption = 'Code'
          end
          item
            AutoSize = True
            Caption = 'Subtitle'
          end>
        ColumnClick = False
        ReadOnly = True
        RowSelect = True
        PopupMenu = pmSubsSelect
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
      end
      object mOldSubEd: TMemo
        Left = 104
        Top = 236
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
        OnChange = mSubTextChange
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
        Text = 'FEX'
      end
      object eGame: TEdit
        Left = 104
        Top = 3
        Width = 189
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 12
        Text = 'eGame'
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
      Caption = '&Multi-translation'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        407
        339)
      object Label10: TLabel
        Left = 3
        Top = 6
        Width = 397
        Height = 13
        Caption = 
          'This feature allow you to translate a subtitle string in all the' +
          ' files present in the list.'
        WordWrap = True
      end
      object Bevel1: TBevel
        Left = 3
        Top = 304
        Width = 400
        Height = 2
        Anchors = [akLeft, akRight, akBottom]
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 25
        Width = 401
        Height = 134
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Search this string : '
        TabOrder = 0
        DesignSize = (
          401
          134)
        object Label11: TLabel
          Left = 165
          Top = 109
          Width = 91
          Height = 13
          Caption = 'Second line length:'
        end
        object Label12: TLabel
          Left = 31
          Top = 109
          Width = 77
          Height = 13
          Caption = 'First line length:'
        end
        object Label13: TLabel
          Left = 10
          Top = 58
          Width = 26
          Height = 13
          Caption = 'Text:'
        end
        object lSubs: TLabel
          Left = 10
          Top = 18
          Width = 79
          Height = 13
          Caption = 'Current subtitle:'
        end
        object Label14: TLabel
          Left = 309
          Top = 109
          Width = 29
          Height = 13
          Caption = 'Code:'
        end
        object mOldSub: TMemo
          Left = 114
          Top = 39
          Width = 282
          Height = 64
          Anchors = [akLeft, akTop, akRight]
          MaxLength = 89
          TabOrder = 0
        end
        object eOldFirstLineLength: TEdit
          Left = 114
          Top = 106
          Width = 41
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
          Text = '0'
        end
        object eOldSecondLineLength: TEdit
          Left = 262
          Top = 106
          Width = 41
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
          Text = '0'
        end
        object cbSubs: TComboBox
          Left = 114
          Top = 15
          Width = 188
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 0
          TabOrder = 3
        end
        object eCode: TEdit
          Left = 344
          Top = 106
          Width = 51
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 4
        end
      end
      object GroupBox4: TGroupBox
        Left = 3
        Top = 162
        Width = 401
        Height = 139
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' Replace the string with : '
        TabOrder = 1
        DesignSize = (
          401
          139)
        object Label15: TLabel
          Left = 10
          Top = 36
          Width = 26
          Height = 13
          Caption = 'Text:'
        end
        object Label16: TLabel
          Left = 33
          Top = 116
          Width = 77
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'First line length:'
          ExplicitTop = 88
        end
        object Label17: TLabel
          Left = 167
          Top = 116
          Width = 91
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Second line length:'
          ExplicitTop = 88
        end
        object Memo1: TMemo
          Left = 114
          Top = 15
          Width = 281
          Height = 94
          Anchors = [akLeft, akTop, akRight, akBottom]
          MaxLength = 89
          TabOrder = 0
        end
        object Edit1: TEdit
          Left = 114
          Top = 113
          Width = 41
          Height = 21
          Anchors = [akLeft, akBottom]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
          Text = '0'
        end
        object Edit2: TEdit
          Left = 262
          Top = 113
          Width = 41
          Height = 21
          Anchors = [akLeft, akBottom]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
          Text = '0'
        end
      end
      object bMultiTranslate: TButton
        Left = 285
        Top = 311
        Width = 119
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Translate...'
        TabOrder = 2
        OnClick = bMultiTranslateClick
      end
      object bRetrieveSubs: TButton
        Left = 307
        Top = 38
        Width = 93
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Retrieve subs...'
        TabOrder = 3
        OnClick = bRetrieveSubsClick
      end
    end
  end
  object gbDebug: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 373
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
    Top = 477
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
  end
  object MainMenu1: TMainMenu
    Left = 80
    Top = 32
    object File1: TMenuItem
      Caption = '&File'
      object Scandirectory1: TMenuItem
        Caption = '&Open directory...'
        Hint = 'Open directory'
        ShortCut = 16463
        OnClick = Scandirectory1Click
      end
      object Opensinglefile1: TMenuItem
        Caption = 'O&pen single file...'
        ShortCut = 49231
        OnClick = Opensinglefile1Click
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
      object N11: TMenuItem
        Caption = '-'
      end
      object miFileProperties2: TMenuItem
        Caption = '&Properties...'
        ShortCut = 115
        OnClick = miFileProperties2Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Closesinglefile1: TMenuItem
        Caption = '&Close single file...'
        OnClick = Closesinglefile1Click
      end
      object Clearfileslist1: TMenuItem
        Caption = '&Clear files list...'
        OnClick = Clearfileslist1Click
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
      object N1: TMenuItem
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
        Caption = 'S&ubtitles preview...'
        Enabled = False
        ShortCut = 114
        OnClick = miSubsPreviewClick
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object charsModMenu1: TMenuItem
        Caption = '&Decode subtitles'
        Enabled = False
        ShortCut = 117
        OnClick = charsModMenu1Click
      end
    end
    object ools1: TMenuItem
      Caption = '&Tools'
      object Autosave1: TMenuItem
        Caption = '&Auto-save'
        Checked = True
        ShortCut = 118
        OnClick = Autosave1Click
      end
      object Makebackup1: TMenuItem
        Caption = '&Make backup if needed'
        ShortCut = 119
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
      object Findsubtitle1: TMenuItem
        Caption = '&Find subtitle...'
        Enabled = False
        ShortCut = 16454
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object Batchimportsubtitles1: TMenuItem
        Caption = 'Batch imp&ort subtitles...'
        ShortCut = 49225
        OnClick = Batchimportsubtitles1Click
      end
      object Batchexportsubtitles1: TMenuItem
        Caption = '&Batch export subtitles...'
        ShortCut = 49221
        OnClick = Batchexportsubtitles1Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object Multitranslation1: TMenuItem
        Caption = 'Multi-translation...'
        ShortCut = 113
        OnClick = Multitranslation1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object Website1: TMenuItem
        Caption = '&Project home...'
        ShortCut = 112
        OnClick = Website1Click
      end
      object N14: TMenuItem
        Caption = '-'
      end
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
  object pmSubsSelect: TPopupMenu
    Left = 382
    Top = 180
    object Copy1: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = Copy1Click
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object Savetofile1: TMenuItem
      Caption = 'S&ave list to file...'
      OnClick = Savetofile1Click
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object Importsubtitles2: TMenuItem
      Caption = '&Import subtitles...'
      ShortCut = 16457
      OnClick = Importsubtitles1Click
    end
    object Exportsubtitles2: TMenuItem
      Caption = '&Export subtitles...'
      ShortCut = 16453
      OnClick = Exportsubtitles1Click
    end
  end
  object sdSubsList: TSaveDialog
    DefaultExt = 'csv'
    Filter = 
      'CSV Files (*.csv)|*.csv|Text Files (*.txt)|*.txt|All Files (*.*)' +
      '|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save subtitles list to...'
    Left = 412
    Top = 180
  end
  object pmFilesList: TPopupMenu
    Left = 14
    Top = 100
    object miFileProperties: TMenuItem
      Caption = '&Properties...'
      Default = True
      RadioItem = True
      OnClick = miFilePropertiesClick
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object Locatefile1: TMenuItem
      Caption = 'Locate file...'
      OnClick = Locatefile1Click
    end
    object Opendirectory1: TMenuItem
      Caption = 'Open directory...'
      OnClick = Opendirectory1Click
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object Reload1: TMenuItem
      Caption = '&Refresh'
      OnClick = Reload1Click
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnHint = ApplicationEventsHint
    Left = 16
    Top = 66
  end
  object bfdExportSubs: TJvBrowseForFolderDialog
    Title = 'Select output directory to export all files subtitles:'
    Left = 46
    Top = 66
  end
end
