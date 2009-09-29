object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = '< Dynamic title >'
  ClientHeight = 439
  ClientWidth = 553
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
    553
    439)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 153
    Height = 403
    Anchors = [akLeft, akTop, akBottom]
    Caption = 'Files list'
    TabOrder = 0
    DesignSize = (
      153
      403)
    object lblMainCount: TLabel
      Left = 19
      Top = 373
      Width = 55
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Files count:'
      ExplicitTop = 371
    end
    object lbMainList: TListBox
      Left = 8
      Top = 16
      Width = 137
      Height = 347
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbMainListClick
    end
    object editMainCount: TEdit
      Left = 80
      Top = 370
      Width = 65
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
    Top = 422
    Width = 553
    Height = 17
    Panels = <
      item
        Width = 50
      end>
  end
  object GroupBox2: TGroupBox
    Left = 168
    Top = 8
    Width = 377
    Height = 403
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Informations'
    TabOrder = 2
    DesignSize = (
      377
      403)
    object lblHeader: TLabel
      Left = 11
      Top = 27
      Width = 39
      Height = 13
      Caption = 'Header:'
    end
    object lblDataSize: TLabel
      Left = 11
      Top = 91
      Width = 74
      Height = 13
      Caption = 'Total data size:'
    end
    object lblFilesCnt: TLabel
      Left = 11
      Top = 59
      Width = 80
      Height = 13
      Caption = 'Total files count:'
    end
    object lblFiles: TLabel
      Left = 11
      Top = 217
      Width = 25
      Height = 13
      Anchors = [akLeft]
      Caption = 'Files:'
      ExplicitTop = 216
    end
    object lblCurrentSize: TLabel
      Left = 11
      Top = 349
      Width = 79
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Current file size:'
      ExplicitTop = 347
    end
    object lblCurrentDate: TLabel
      Left = 11
      Top = 373
      Width = 83
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Current file date:'
      ExplicitTop = 371
    end
    object editHeader: TEdit
      Left = 136
      Top = 24
      Width = 233
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      Text = 'AFS'
    end
    object editFilesCnt: TEdit
      Left = 136
      Top = 56
      Width = 233
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = '0'
    end
    object editDataSize: TEdit
      Left = 136
      Top = 88
      Width = 233
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
      Text = '0 bytes'
    end
    object lbCurrentAfs: TListBox
      Left = 136
      Top = 120
      Width = 233
      Height = 219
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      MultiSelect = True
      PopupMenu = PopupMenu1
      TabOrder = 3
      OnClick = lbCurrentAfsClick
    end
    object editCurrentSize: TEdit
      Left = 136
      Top = 346
      Width = 233
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
      Text = '0 bytes'
    end
    object editCurrentDate: TEdit
      Left = 136
      Top = 370
      Width = 233
      Height = 21
      Anchors = [akLeft, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
      Text = '2008-08-08 @ 08:08:08'
    end
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 32
    object File1: TMenuItem
      Caption = 'File'
      object Opensinglefile1: TMenuItem
        Caption = 'Open files...'
        ShortCut = 16463
        OnClick = Opensinglefile1Click
      end
      object Openadirectory1: TMenuItem
        Caption = 'Open directory...'
        ShortCut = 49231
        OnClick = Openadirectory1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Closesinglefile1: TMenuItem
        Caption = 'Close selected file...'
        Enabled = False
        OnClick = Closesinglefile1Click
      end
      object Closeallfiles1: TMenuItem
        Caption = 'Close all files...'
        Enabled = False
        OnClick = Closeallfiles1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        ShortCut = 16472
        OnClick = Exit1Click
      end
    end
    object Operations1: TMenuItem
      Caption = 'Tools'
      object Searchfilestoselect1: TMenuItem
        Caption = 'Search files to select...'
        Enabled = False
        ShortCut = 16454
        OnClick = Searchfilestoselect1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Extractselectedfiles1: TMenuItem
        Caption = 'Extract selected files...'
        Enabled = False
        OnClick = Extractselectedfiles1Click
      end
      object Extractallfiles1: TMenuItem
        Caption = 'Extract all files...'
        Enabled = False
        OnClick = Extractallfiles1Click
      end
      object Massextraction1: TMenuItem
        Caption = 'Mass extraction...'
        Enabled = False
        OnClick = Massextraction1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object AFSCreator1: TMenuItem
        Caption = 'AFS Creator'
        OnClick = AFSCreator1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object SaveXMLlist1: TMenuItem
        Caption = 'Save XML files list at extraction'
        Checked = True
        OnClick = SaveXMLlist1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About...'
        OnClick = About1Click
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 24
    Top = 64
    object ppmExtractselectedfiles1: TMenuItem
      Caption = 'Extract selected files...'
      Enabled = False
      OnClick = ppmExtractselectedfiles1Click
    end
    object ppmExtractallfiles1: TMenuItem
      Caption = 'Extract all files...'
      Enabled = False
      OnClick = ppmExtractallfiles1Click
    end
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 56
    Top = 32
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 56
    Top = 64
  end
  object JvBrowseFolder1: TJvBrowseForFolderDialog
    Left = 88
    Top = 32
  end
end
