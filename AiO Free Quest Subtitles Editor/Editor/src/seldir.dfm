object frmSelectDir: TfrmSelectDir
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Directory scanner'
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
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 79
    Width = 359
    Height = 2
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 329
    Height = 13
    Caption = 
      'Please select the target directory to retrieve Free Quest charac' +
      'ters.'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 28
    Width = 359
    Height = 45
    Caption = ' Directory: '
    TabOrder = 0
    object eDirectory: TEdit
      Left = 7
      Top = 16
      Width = 267
      Height = 21
      TabOrder = 0
    end
    object Button1: TButton
      Left = 278
      Top = 14
      Width = 75
      Height = 25
      Caption = 'Browse...'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object Button2: TButton
    Left = 216
    Top = 85
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 292
    Top = 85
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object JvBrowseForFolderDialog: TJvBrowseForFolderDialog
    Title = 'Please select the target directory:'
    Left = 8
    Top = 84
  end
end
