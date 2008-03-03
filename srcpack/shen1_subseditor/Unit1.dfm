object Form1: TForm1
  Left = 329
  Top = 249
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Shenmue I Subtitles Editor v1.1'
  ClientHeight = 433
  ClientWidth = 569
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 416
    Width = 569
    Height = 17
    Panels = <
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object subslist_grpbox: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 401
    Caption = 'Subtitles list'
    TabOrder = 1
    object ListBox1: TListBox
      Left = 8
      Top = 16
      Width = 169
      Height = 377
      ItemHeight = 13
      TabOrder = 0
      OnClick = ListBox1Click
    end
  end
  object values_grpbox: TGroupBox
    Left = 200
    Top = 8
    Width = 361
    Height = 401
    Caption = 'Values'
    TabOrder = 2
    object char_lbl: TLabel
      Left = 16
      Top = 32
      Width = 49
      Height = 13
      Caption = 'Character:'
    end
    object text_lbl: TLabel
      Left = 16
      Top = 120
      Width = 24
      Height = 13
      Caption = 'Text:'
    end
    object debug_lbl: TLabel
      Left = 16
      Top = 280
      Width = 35
      Height = 13
      Caption = 'Debug:'
    end
    object char_edit: TEdit
      Left = 88
      Top = 24
      Width = 265
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object nomod_checkbx: TCheckBox
      Left = 88
      Top = 368
      Width = 265
      Height = 17
      Caption = 'Copy this subtitle without modification'
      TabOrder = 1
    end
    object text_memo: TMemo
      Left = 88
      Top = 56
      Width = 265
      Height = 145
      TabOrder = 2
      OnChange = text_memoChange
    end
    object debug_memo: TMemo
      Left = 88
      Top = 208
      Width = 265
      Height = 145
      TabOrder = 3
    end
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 32
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open...'
        OnClick = Open1Click
      end
      object Saveas1: TMenuItem
        Caption = 'Save as...'
        OnClick = Saveas1Click
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object ools1: TMenuItem
      Caption = 'Tools'
      object Exportmenu1: TMenuItem
        Caption = 'Export subtitles to text file'
        OnClick = Exportmenu1Click
      end
      object Importmenu1: TMenuItem
        Caption = 'Import subtitles from text file'
        OnClick = Importmenu1Click
      end
      object CharsModmenu1: TMenuItem
        Caption = 'Enable characters modification'
        OnClick = CharsModmenu1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 56
    Top = 32
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 88
    Top = 32
  end
end
