object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = '< Generated Title > // VMU Screen Editor'
  ClientHeight = 386
  ClientWidth = 542
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mmMain
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lvIwadContent: TJvListView
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 381
    Height = 361
    Align = alClient
    Columns = <
      item
        Caption = '#'
        Width = 20
      end
      item
        Caption = 'Name'
        Width = 70
      end
      item
        Caption = 'Offset'
        Width = 60
      end
      item
        Caption = 'Size'
        Width = 60
      end
      item
        Caption = 'Height'
      end
      item
        Caption = 'Width'
      end
      item
        Caption = 'Updated'
        Width = 55
      end>
    ColumnClick = False
    GridLines = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = pmIwadContent
    TabOrder = 0
    ViewStyle = vsReport
    ColumnsOrder = '6=20,0=70,1=60,2=60,3=50,4=50,5=55'
    HeaderImagePosition = hipRight
    Groups = <>
    ExtendedColumns = <
      item
        HeaderImagePosition = hipRight
        UseParentHeaderImagePosition = False
      end
      item
        HeaderImagePosition = hipRight
        UseParentHeaderImagePosition = False
      end
      item
        HeaderImagePosition = hipRight
        UseParentHeaderImagePosition = False
      end
      item
        HeaderImagePosition = hipRight
        UseParentHeaderImagePosition = False
      end
      item
        HeaderImagePosition = hipRight
        UseParentHeaderImagePosition = False
      end
      item
        HeaderImagePosition = hipRight
        UseParentHeaderImagePosition = False
      end
      item
        HeaderImagePosition = hipRight
      end>
  end
  object pnlRightCommands: TPanel
    Left = 387
    Top = 0
    Width = 155
    Height = 367
    Margins.Left = 0
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object pnlScreenPreview: TPanel
      Left = 3
      Top = 3
      Width = 148
      Height = 100
      BevelOuter = bvLowered
      BevelWidth = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object imgScreenPreview: TImage
        Left = 2
        Top = 2
        Width = 144
        Height = 96
        Align = alClient
        Center = True
        Proportional = True
        Stretch = True
        ExplicitLeft = 12
        ExplicitTop = 6
      end
    end
    object btnImport: TButton
      Left = 3
      Top = 109
      Width = 72
      Height = 25
      Caption = '&Import...'
      TabOrder = 1
      OnClick = btnImportClick
    end
    object btnExport: TButton
      Left = 3
      Top = 135
      Width = 72
      Height = 25
      Caption = '&Export...'
      TabOrder = 2
    end
    object btnExportAll: TButton
      Left = 77
      Top = 135
      Width = 72
      Height = 25
      Caption = '&Export all...'
      TabOrder = 3
    end
    object btnUndo: TButton
      Left = 77
      Top = 109
      Width = 72
      Height = 25
      Caption = '&Undo...'
      TabOrder = 4
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 367
    Width = 542
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
    Left = 12
    Top = 94
    object miFile: TMenuItem
      Caption = '&File'
      object miOpen: TMenuItem
        Caption = 'miOpen'
        ShortCut = 16463
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miSave: TMenuItem
        Caption = 'miSave'
        ShortCut = 16467
      end
      object miSaveAs: TMenuItem
        Caption = 'miSaveAs'
        ShortCut = 49235
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miClose: TMenuItem
        Caption = 'miClose'
      end
      object N3: TMenuItem
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
        Caption = 'miUndo'
        ShortCut = 16474
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object miImport: TMenuItem
        Caption = 'miImport'
        ShortCut = 16457
      end
      object miExport: TMenuItem
        Caption = 'miExport'
        ShortCut = 16453
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object miExportAll: TMenuItem
        Caption = 'miExportAll'
        ShortCut = 16449
      end
    end
    object miHelp: TMenuItem
      Caption = 'miHelp'
      object miProjectHome: TMenuItem
        Caption = 'miProjectHome'
        ShortCut = 112
      end
      object miCheckForUpdate: TMenuItem
        Caption = 'miCheckForUpdate'
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object miAbout: TMenuItem
        Caption = 'miAbout'
        ShortCut = 123
      end
    end
  end
  object odOpen: TOpenDialog
    DefaultExt = 'IWD'
    Filter = 'LCD Package Files (*.IWD)|*.IWD|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select the file to open...'
    Left = 8
    Top = 150
  end
  object pmIwadContent: TPopupMenu
    Left = 10
    Top = 186
    object miUndo2: TMenuItem
      Caption = 'miUndo2'
      ShortCut = 16474
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object miImport2: TMenuItem
      Caption = 'miImport2'
      ShortCut = 16457
    end
    object miExport2: TMenuItem
      Caption = 'miExport2'
      ShortCut = 16453
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object miExportAll2: TMenuItem
      Caption = 'miExportAll2'
      ShortCut = 16449
    end
  end
end
