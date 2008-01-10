object Form1: TForm1
  Left = 298
  Top = 206
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Shenmue II Subtitles Editor v4.1'
  ClientHeight = 434
  ClientWidth = 601
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 193
    Height = 401
    Caption = 'Subtitles list'
    TabOrder = 0
    object ListBox1: TListBox
      Left = 8
      Top = 16
      Width = 177
      Height = 377
      ItemHeight = 13
      TabOrder = 0
      OnClick = ListBox1Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 416
    Width = 601
    Height = 18
    Panels = <
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object GroupBox2: TGroupBox
    Left = 208
    Top = 8
    Width = 385
    Height = 401
    Caption = 'Values'
    TabOrder = 2
    object chid_len_lbl: TLabel
      Left = 8
      Top = 64
      Width = 99
      Height = 13
      Caption = 'Character ID Length:'
    end
    object header_lbl: TLabel
      Left = 8
      Top = 32
      Width = 38
      Height = 13
      Caption = 'Header:'
    end
    object chid_lbl: TLabel
      Left = 8
      Top = 96
      Width = 63
      Height = 13
      Caption = 'Character ID:'
    end
    object sub_lbl: TLabel
      Left = 8
      Top = 168
      Width = 24
      Height = 13
      Caption = 'Text:'
    end
    object debug_lbl: TLabel
      Left = 8
      Top = 296
      Width = 35
      Height = 13
      Caption = 'Debug:'
    end
    object header_edit: TEdit
      Left = 120
      Top = 24
      Width = 257
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object chid_len_edit: TEdit
      Left = 120
      Top = 56
      Width = 257
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
    object chid_edit: TEdit
      Left = 120
      Top = 88
      Width = 257
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object sub_memo: TMemo
      Left = 120
      Top = 120
      Width = 257
      Height = 113
      TabOrder = 3
      OnChange = sub_memoChange
    end
    object debug_memo: TMemo
      Left = 120
      Top = 248
      Width = 257
      Height = 113
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object copy_no_mod: TCheckBox
      Left = 120
      Top = 368
      Width = 201
      Height = 17
      Caption = 'Copy this subtitle without modification'
      TabOrder = 5
    end
  end
  object MainMenu1: TMainMenu
    Left = 88
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
    object Tools1: TMenuItem
      Caption = 'Tools'
      object Exportsubstotxt1: TMenuItem
        Caption = 'Export subtitles to text file'
        OnClick = Exportsubstotxt1Click
      end
      object Importsubsfromtxt1: TMenuItem
        Caption = 'Import subtitles from text file'
        OnClick = Importsubsfromtxt1Click
      end
      object Enablecharsmod1: TMenuItem
        Caption = 'Enable characters modification'
        OnClick = Enablecharsmod1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 24
    Top = 32
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 56
    Top = 32
  end
end
