object Form1: TForm1
  Left = 579
  Top = 149
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'AFS Utils v1.1'
  ClientHeight = 395
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 337
    Height = 209
    TabOrder = 0
    object ListBox1: TListBox
      Left = 8
      Top = 24
      Width = 321
      Height = 153
      ItemHeight = 13
      TabOrder = 0
    end
    object SaveAfsBt: TButton
      Left = 272
      Top = 184
      Width = 57
      Height = 17
      Caption = 'Save'
      TabOrder = 1
      OnClick = SaveAfsBtClick
    end
    object AddFileBt: TButton
      Left = 8
      Top = 184
      Width = 41
      Height = 17
      Hint = 'Add an individual file to the current list'
      Caption = 'Add'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = AddFileBtClick
    end
    object DeleteFileBt: TButton
      Left = 56
      Top = 184
      Width = 41
      Height = 17
      Hint = 'Delete a file from the current files list'
      Caption = 'Delete'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = DeleteFileBtClick
    end
    object LoadListBt: TButton
      Left = 104
      Top = 184
      Width = 49
      Height = 17
      Hint = 'Load a files list from a text file'
      Caption = 'Load list'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = LoadListBtClick
    end
    object ClearListBt: TButton
      Left = 160
      Top = 184
      Width = 49
      Height = 17
      Hint = 'Clear the current files list'
      Caption = 'Clear list'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = ClearListBtClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 376
    Width = 353
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object new_afs_radio: TRadioButton
    Left = 16
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Create new AFS'
    TabOrder = 2
    OnClick = new_afs_radioClick
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 224
    Width = 337
    Height = 145
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 27
      Height = 13
      Caption = 'Input:'
    end
    object Label2: TLabel
      Left = 8
      Top = 72
      Width = 78
      Height = 13
      Caption = 'Output directory:'
    end
    object input_extract_txt: TEdit
      Left = 8
      Top = 40
      Width = 257
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object BrowseAfsBt: TButton
      Left = 272
      Top = 40
      Width = 57
      Height = 17
      Caption = 'Browse'
      TabOrder = 1
      OnClick = BrowseAfsBtClick
    end
    object output_directory_txt: TEdit
      Left = 8
      Top = 88
      Width = 257
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object BrowseDirBt: TButton
      Left = 272
      Top = 88
      Width = 57
      Height = 17
      Caption = 'Browse'
      TabOrder = 3
      OnClick = BrowseDirBtClick
    end
    object StartExtractBt: TButton
      Left = 8
      Top = 120
      Width = 89
      Height = 17
      Caption = 'Go!'
      TabOrder = 4
      OnClick = StartExtractBtClick
    end
    object create_list_check: TCheckBox
      Left = 120
      Top = 120
      Width = 137
      Height = 17
      Hint = 
        'The list will be created in the output directory as (afs filenam' +
        'e)_list.txt'
      Caption = 'Create files list for this afs'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
  end
  object extract_afs_radio: TRadioButton
    Left = 16
    Top = 224
    Width = 97
    Height = 17
    Caption = 'Extract AFS file'
    TabOrder = 4
    OnClick = extract_afs_radioClick
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 24
    Top = 40
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 56
    Top = 40
  end
  object MainMenu1: TMainMenu
    Left = 184
    Top = 16
    object File1: TMenuItem
      Caption = 'File'
      object Quit1: TMenuItem
        Caption = 'Exit'
        OnClick = Quit1Click
      end
    end
    object ools1: TMenuItem
      Caption = 'Tools'
      object Blocksize1: TMenuItem
        Caption = 'Block size'
        OnClick = Blocksize1Click
      end
      object Writefileslist1: TMenuItem
        Caption = 'Write files list at creation'
        OnClick = Writefileslist1Click
      end
    end
  end
end
