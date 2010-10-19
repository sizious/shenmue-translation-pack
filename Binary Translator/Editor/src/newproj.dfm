object frmNewProject: TfrmNewProject
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'New Project'
  ClientHeight = 188
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 4
    Width = 342
    Height = 26
    Caption = 
      'Please select the Game version in the list below and the locatio' +
      'n where the new translation script will be created.'
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 7
    Top = 156
    Width = 354
    Height = 2
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 87
    Width = 354
    Height = 63
    Caption = ' New script location : '
    TabOrder = 0
    object bBrowse: TButton
      Left = 315
      Top = 14
      Width = 30
      Height = 25
      Caption = '...'
      TabOrder = 0
      OnClick = bBrowseClick
    end
    object eNewFileName: TEdit
      Left = 8
      Top = 16
      Width = 301
      Height = 21
      TabOrder = 1
    end
    object cbCreateDTD: TCheckBox
      Left = 8
      Top = 43
      Width = 334
      Height = 14
      Caption = 'Generate Document Type Definition (DTD) with the XML Script'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 7
    Top = 36
    Width = 354
    Height = 48
    Caption = ' Game version : '
    TabOrder = 1
    object cbGameVersionSelect: TComboBox
      Left = 8
      Top = 17
      Width = 337
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object bOK: TButton
    Left = 172
    Top = 160
    Width = 93
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 268
    Top = 160
    Width = 93
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object sdNewScript: TSaveDialog
    DefaultExt = 'xml'
    Filter = 'XML Files (*.XML)|*.xml|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save the new project to...'
    Left = 284
    Top = 88
  end
end
