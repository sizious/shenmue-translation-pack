object frmCreator: TfrmCreator
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'SPR Creator'
  ClientHeight = 395
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    305
    395)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 289
    Height = 357
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Files list'
    TabOrder = 0
    DesignSize = (
      289
      357)
    object Label1: TLabel
      Left = 155
      Top = 331
      Width = 55
      Height = 13
      Anchors = [akRight, akBottom]
      Caption = 'Files count:'
    end
    object lbMain: TListBox
      Left = 8
      Top = 16
      Width = 273
      Height = 305
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      MultiSelect = True
      PopupMenu = PopupMenu1
      TabOrder = 0
    end
    object editCnt: TEdit
      Left = 216
      Top = 328
      Width = 65
      Height = 21
      Anchors = [akRight, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = '0'
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 378
    Width = 305
    Height = 17
    Panels = <
      item
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 32
    object File1: TMenuItem
      Caption = 'File'
      object Addfiles1: TMenuItem
        Caption = 'Add files...'
        OnClick = Addfiles1Click
      end
      object Adddirectory1: TMenuItem
        Caption = 'Add directory...'
        OnClick = Adddirectory1Click
      end
      object ImportXMLlist1: TMenuItem
        Caption = 'Import XML list...'
        OnClick = ImportXMLlist1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object SaveSpr1: TMenuItem
        Caption = 'Save Spr...'
        OnClick = SaveSpr1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
    end
    object Tools1: TMenuItem
      Caption = 'Tools'
      object Deleteselectedfiles1: TMenuItem
        Caption = 'Delete selected files...'
        OnClick = Deleteselectedfiles1Click
      end
      object Deleteallfiles1: TMenuItem
        Caption = 'Delete all files...'
        OnClick = Deleteallfiles1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Rewritegbix1: TMenuItem
        Caption = 'Rewrite PVR global index at creation'
        Checked = True
        OnClick = Rewritegbix1Click
      end
      object GZipfileatcreation1: TMenuItem
        Caption = 'GZip output file at creation'
        OnClick = GZipfileatcreation1Click
      end
    end
  end
  object OpenDialog2: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 24
    Top = 64
  end
  object SaveDialog2: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 56
    Top = 64
  end
  object PopupMenu1: TPopupMenu
    Left = 56
    Top = 32
    object Addfiles2: TMenuItem
      Caption = 'Add files...'
      OnClick = Addfiles2Click
    end
    object Adddirectory2: TMenuItem
      Caption = 'Add directory...'
      OnClick = Adddirectory2Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Deleteselectedfiles2: TMenuItem
      Caption = 'Delete selected files...'
      OnClick = Deleteselectedfiles2Click
    end
    object Fileinformations1: TMenuItem
      Caption = 'Modify file infos...'
      OnClick = Fileinformations1Click
    end
  end
  object JvBrowseFolder2: TJvBrowseForFolderDialog
    Options = [odStatusAvailable, odNewDialogStyle, odNoNewButtonFolder]
    Left = 24
    Top = 96
  end
  object XMLDoc1: TXMLDocument
    NodeIndentStr = #9
    Options = [doNodeAutoCreate, doAttrNull]
    Left = 56
    Top = 96
    DOMVendorDesc = 'MSXML'
  end
end
