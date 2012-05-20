object DirectoryScannerQueryWindow: TDirectoryScannerQueryWindow
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '< Generated Title >'
  ClientHeight = 114
  ClientWidth = 371
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
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bvDelimiter: TBevel
    Left = 8
    Top = 79
    Width = 359
    Height = 2
  end
  object lInfo: TLabel
    Left = 8
    Top = 8
    Width = 79
    Height = 13
    Caption = '< Hint text ... >'
  end
  object gbDirectory: TGroupBox
    Left = 8
    Top = 28
    Width = 359
    Height = 45
    Caption = ' Directory: '
    TabOrder = 0
    object bBrowse: TButton
      Left = 278
      Top = 14
      Width = 75
      Height = 25
      Caption = 'Browse...'
      TabOrder = 0
      OnClick = bBrowseClick
    end
    object cbDirectory: TComboBox
      Left = 7
      Top = 16
      Width = 267
      Height = 21
      ItemHeight = 0
      TabOrder = 1
    end
  end
  object bOK: TButton
    Left = 216
    Top = 85
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 292
    Top = 85
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object bfd: TJvBrowseForFolderDialog
    Title = 'Please select the target directory:'
    Left = 8
    Top = 84
  end
end
