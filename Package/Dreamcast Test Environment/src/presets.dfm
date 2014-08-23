object frmPresets: TfrmPresets
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Presets Definition'
  ClientHeight = 240
  ClientWidth = 534
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bvlMain: TBevel
    Left = 4
    Top = 203
    Width = 525
    Height = 2
  end
  object gbxPresets: TGroupBox
    Left = 4
    Top = 2
    Width = 197
    Height = 191
    Caption = ' Presets: '
    TabOrder = 0
    object lbxPresets: TListBox
      Left = 8
      Top = 17
      Width = 181
      Height = 162
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbxPresetsClick
    end
  end
  object gbxDetails: TGroupBox
    Left = 207
    Top = 2
    Width = 322
    Height = 191
    Caption = ' Preset Details : '
    TabOrder = 1
    object lblName: TLabel
      Left = 8
      Top = 18
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object lblVolumeName: TLabel
      Left = 8
      Top = 60
      Width = 68
      Height = 13
      Caption = 'Volume Name:'
    end
    object lblOutputFileName: TLabel
      Left = 8
      Top = 143
      Width = 87
      Height = 13
      Caption = 'Output File Name:'
    end
    object lblSourceDirectory: TLabel
      Left = 8
      Top = 101
      Width = 84
      Height = 13
      Caption = 'Source Directory:'
    end
    object edtName: TEdit
      Left = 8
      Top = 33
      Width = 305
      Height = 21
      TabOrder = 0
      OnChange = edtNameChange
    end
    object edtVolumeName: TEdit
      Left = 9
      Top = 74
      Width = 304
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 32
      TabOrder = 1
      OnChange = edtVolumeNameChange
      OnKeyPress = edtVolumeNameKeyPress
    end
    object edtOutputFileName: TEdit
      Left = 8
      Top = 158
      Width = 275
      Height = 21
      TabOrder = 2
      OnChange = edtOutputFileNameChange
    end
    object edtSourceDirectory: TEdit
      Left = 8
      Top = 116
      Width = 275
      Height = 21
      TabOrder = 3
      OnChange = edtSourceDirectoryChange
    end
    object btnSourceDirectory: TButton
      Left = 289
      Top = 116
      Width = 25
      Height = 21
      Caption = '...'
      TabOrder = 4
      OnClick = btnSourceDirectoryClick
    end
    object btnOutputFileName: TButton
      Left = 289
      Top = 158
      Width = 25
      Height = 21
      Caption = '...'
      TabOrder = 5
      OnClick = btnOutputFileNameClick
    end
  end
  object btnAdd: TButton
    Left = 4
    Top = 211
    Width = 87
    Height = 25
    Caption = '&Add'
    TabOrder = 2
    OnClick = btnAddClick
  end
  object btnDel: TButton
    Left = 97
    Top = 211
    Width = 87
    Height = 25
    Caption = '&Delete...'
    TabOrder = 3
    OnClick = btnDelClick
  end
  object btnClose: TButton
    Left = 442
    Top = 211
    Width = 87
    Height = 25
    Caption = 'Cl&ose'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object svdOutputFileName: TJvSaveDialog
    DefaultExt = 'nrg'
    Filter = 'Nero Burning Rom Images (*.nrg)|*.nrg|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save the Output FileName to:'
    Height = 412
    Width = 563
    Left = 456
    Top = 152
  end
  object bfdSourceDirectory: TJvBrowseForFolderDialog
    Options = [odOnlyDirectory, odStatusAvailable, odNewDialogStyle]
    Title = 
      'Select the Source Directory that will be used for building the i' +
      'mage:'
    Left = 456
    Top = 112
  end
end
