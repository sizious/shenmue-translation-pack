object frmCreator: TfrmCreator
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSizeToolWin
  Caption = 'AFS Creator'
  ClientHeight = 381
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu2
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    307
    381)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 291
    Height = 342
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Files list'
    TabOrder = 0
    ExplicitWidth = 329
    ExplicitHeight = 289
    DesignSize = (
      291
      342)
    object lblFileCnt: TLabel
      Left = 149
      Top = 312
      Width = 55
      Height = 13
      Anchors = [akRight, akBottom]
      Caption = 'Files count:'
      ExplicitLeft = 187
      ExplicitTop = 259
    end
    object lbCreationList: TListBox
      Left = 8
      Top = 16
      Width = 275
      Height = 286
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      MultiSelect = True
      PopupMenu = PopupMenu2
      TabOrder = 0
      ExplicitWidth = 313
      ExplicitHeight = 233
    end
    object editFileCnt: TEdit
      Left = 210
      Top = 309
      Width = 73
      Height = 21
      Anchors = [akRight, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = '0'
      ExplicitLeft = 248
      ExplicitTop = 256
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 364
    Width = 307
    Height = 17
    Panels = <
      item
        Width = 50
      end>
    ExplicitTop = 310
    ExplicitWidth = 345
  end
  object MainMenu2: TMainMenu
    Left = 24
    Top = 32
    object File1: TMenuItem
      Caption = 'File'
      object Addfiles1: TMenuItem
        Caption = 'Add files...'
        ShortCut = 16463
        OnClick = Addfiles1Click
      end
      object Adddirectory1: TMenuItem
        Caption = 'Add directory...'
        ShortCut = 49231
        OnClick = Adddirectory1Click
      end
      object ImportXMLlist1: TMenuItem
        Caption = 'Import XML list...'
        OnClick = ImportXMLlist1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object SaveAfs1: TMenuItem
        Caption = 'Save Afs...'
        ShortCut = 16467
        OnClick = SaveAfs1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = 'Close'
        ShortCut = 16472
        OnClick = Close1Click
      end
    end
    object ools1: TMenuItem
      Caption = 'Tools'
      object Deletefiles1: TMenuItem
        Caption = 'Delete selected files...'
        OnClick = Deletefiles1Click
      end
      object Deleteallfiles1: TMenuItem
        Caption = 'Delete all files...'
        OnClick = Deleteallfiles1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Options1: TMenuItem
        Caption = 'Options'
        OnClick = Options1Click
      end
    end
  end
  object OpenDialog2: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 56
    Top = 32
  end
  object SaveDialog2: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 56
    Top = 64
  end
  object PopupMenu2: TPopupMenu
    Left = 24
    Top = 64
    object Addfiles2: TMenuItem
      Caption = 'Add files...'
      OnClick = Addfiles2Click
    end
    object Adddirectory2: TMenuItem
      Caption = 'Add directory...'
      OnClick = Adddirectory2Click
    end
    object Deleteselectedfiles1: TMenuItem
      Caption = 'Delete selected files...'
      OnClick = Deleteselectedfiles1Click
    end
  end
  object JvBrowseFolder2: TJvBrowseForFolderDialog
    Options = [odStatusAvailable, odNewDialogStyle, odNoNewButtonFolder]
    Left = 24
    Top = 96
  end
end
