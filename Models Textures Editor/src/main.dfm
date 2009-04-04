object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'frmMain'
  ClientHeight = 348
  ClientWidth = 544
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 4
    Top = 4
    Width = 149
    Height = 323
    Caption = ' Files list : '
    TabOrder = 0
    DesignSize = (
      149
      323)
    object Label9: TLabel
      Left = 6
      Top = 298
      Width = 58
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Files count :'
    end
    object lbFilesList: TListBox
      Left = 6
      Top = 16
      Width = 137
      Height = 273
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbFilesListClick
    end
    object eFilesCount: TEdit
      Left = 70
      Top = 295
      Width = 73
      Height = 21
      Anchors = [akLeft, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = '100'
    end
  end
  object GroupBox2: TGroupBox
    Left = 156
    Top = 4
    Width = 385
    Height = 173
    Caption = ' Textures : '
    TabOrder = 1
    object lvTexturesList: TListView
      Left = 6
      Top = 16
      Width = 280
      Height = 150
      Columns = <
        item
          Caption = 'Index'
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
      TabOrder = 0
      ViewStyle = vsReport
    end
    object bExport: TButton
      Left = 292
      Top = 51
      Width = 90
      Height = 25
      Caption = 'Export...'
      TabOrder = 1
      OnClick = bExportClick
    end
    object Button1: TButton
      Left = 292
      Top = 82
      Width = 90
      Height = 25
      Caption = 'Export all...'
      TabOrder = 2
      OnClick = bExportClick
    end
    object Button2: TButton
      Left = 292
      Top = 19
      Width = 90
      Height = 25
      Caption = 'Import...'
      TabOrder = 3
      OnClick = bExportClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 329
    Width = 544
    Height = 19
    Panels = <>
  end
  object GroupBox3: TGroupBox
    Left = 156
    Top = 180
    Width = 385
    Height = 147
    Caption = ' Informations : '
    TabOrder = 3
    object lvSectionsList: TListView
      Left = 6
      Top = 16
      Width = 373
      Height = 123
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
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object mmMain: TMainMenu
    Left = 20
    Top = 34
    object File1: TMenuItem
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
      end
    end
    object ools1: TMenuItem
      Caption = '&Tools'
      object Autosave1: TMenuItem
        Caption = 'A&uto-save'
      end
      object Makebackup1: TMenuItem
        Caption = 'Make &backup'
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object exturespreview1: TMenuItem
        Caption = 'Textures preview...'
        ShortCut = 114
      end
    end
    object About1: TMenuItem
      Caption = '&About'
      object About2: TMenuItem
        Caption = 'A&bout...'
        ShortCut = 123
      end
    end
  end
  object odFileSelect: TOpenDialog
    DefaultExt = 'MT7'
    Filter = 'MT7 (*.MT7)|*.MT7|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select the file...'
    Left = 20
    Top = 64
  end
end
