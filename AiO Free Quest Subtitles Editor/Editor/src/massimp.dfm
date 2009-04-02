object frmMassImport: TfrmMassImport
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Batch subtitles import'
  ClientHeight = 258
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 6
    Top = 227
    Width = 359
    Height = 2
  end
  object Bevel2: TBevel
    Left = 6
    Top = 81
    Width = 359
    Height = 2
  end
  object GroupBox1: TGroupBox
    Left = 6
    Top = 8
    Width = 359
    Height = 72
    Caption = ' Select the directory : '
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 15
      Width = 329
      Height = 26
      Caption = 
        'XML subtitles files must be the same name as PAKS files but with' +
        ' the .xml extension.'
      WordWrap = True
    end
    object eDirectory: TEdit
      Left = 7
      Top = 46
      Width = 267
      Height = 21
      TabOrder = 0
    end
    object btnBrowse: TButton
      Left = 278
      Top = 44
      Width = 75
      Height = 25
      Caption = 'Browse...'
      TabOrder = 1
      OnClick = btnBrowseClick
    end
  end
  object btnImport: TButton
    Left = 214
    Top = 230
    Width = 75
    Height = 25
    Caption = '&Import'
    Default = True
    TabOrder = 1
    OnClick = btnImportClick
  end
  object btnCancel: TButton
    Left = 290
    Top = 230
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object GroupBox2: TGroupBox
    Left = 6
    Top = 86
    Width = 359
    Height = 138
    Caption = ' Result : '
    TabOrder = 3
    object lvFiles: TListView
      Left = 7
      Top = 16
      Width = 346
      Height = 94
      Columns = <
        item
          Caption = 'File'
          Width = 240
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
      Top = 116
      Width = 284
      Height = 17
      TabOrder = 1
    end
  end
  object lProgBar: TPanel
    Left = 300
    Top = 200
    Width = 59
    Height = 21
    BevelOuter = bvLowered
    Caption = '100,00%'
    TabOrder = 4
  end
  object JvBrowseForFolderDialog: TJvBrowseForFolderDialog
    Title = 'Please select the input directory:'
    Left = 260
    Top = 68
  end
end
