object frmFacesExtractor: TfrmFacesExtractor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'NPC Faces Extractor'
  ClientHeight = 304
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 4
    Top = 272
    Width = 385
    Height = 2
  end
  object lHelp: TLabel
    Left = 4
    Top = 5
    Width = 385
    Height = 26
    AutoSize = False
    Caption = 
      'This tool was made to retrieve all NPC faces from Shenmue PAKF f' +
      'iles. This can help you to reconingize a NPC character in-game, ' +
      'and help the translation.'
    WordWrap = True
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 34
    Width = 385
    Height = 45
    Caption = ' Select the PAKF source directory : '
    TabOrder = 0
    object eDirectory: TEdit
      Left = 6
      Top = 16
      Width = 295
      Height = 21
      TabOrder = 0
    end
    object bBrowse: TButton
      Left = 304
      Top = 14
      Width = 75
      Height = 25
      Caption = '&Browse...'
      TabOrder = 1
      OnClick = bBrowseClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 134
    Width = 385
    Height = 136
    Caption = ' Result : '
    TabOrder = 1
    object lvFiles: TListView
      Left = 7
      Top = 14
      Width = 372
      Height = 95
      Columns = <
        item
          Caption = 'File'
          Width = 265
        end
        item
          Caption = 'Status'
          Width = 80
        end>
      ColumnClick = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
    object pBar: TProgressBar
      Left = 7
      Top = 115
      Width = 311
      Height = 17
      TabOrder = 1
    end
    object lProgBar: TPanel
      Left = 324
      Top = 114
      Width = 55
      Height = 18
      BevelOuter = bvLowered
      Caption = '100.00%'
      TabOrder = 2
    end
  end
  object bExtract: TButton
    Left = 208
    Top = 276
    Width = 90
    Height = 25
    Caption = '&Extract'
    TabOrder = 2
    OnClick = bExtractClick
  end
  object bCancel: TButton
    Left = 299
    Top = 276
    Width = 90
    Height = 25
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = bCancelClick
  end
  object GroupBox3: TGroupBox
    Left = 4
    Top = 79
    Width = 385
    Height = 53
    Caption = ' Game version: '
    TabOrder = 4
    object rbVersion1: TRadioButton
      Left = 133
      Top = 22
      Width = 113
      Height = 17
      Caption = 'Shenmue II'
      TabOrder = 0
      OnClick = rbVersion0Click
    end
    object rbVersion0: TRadioButton
      Left = 11
      Top = 14
      Width = 82
      Height = 31
      Caption = 'Shenmue      US Shenmue'
      Checked = True
      TabOrder = 1
      TabStop = True
      WordWrap = True
      OnClick = rbVersion0Click
    end
    object rbVersion2: TRadioButton
      Left = 258
      Top = 24
      Width = 113
      Height = 17
      Caption = 'What'#39's Shenmue'
      TabOrder = 2
      OnClick = rbVersion0Click
    end
  end
  object JvBrowseForFolderDialog: TJvBrowseForFolderDialog
    Title = 'Please select the input directory:'
    Left = 252
    Top = 44
  end
end
