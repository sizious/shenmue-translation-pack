object frmFileSelection: TfrmFileSelection
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '< Generated Title >'
  ClientHeight = 208
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 171
    Width = 378
    Height = 2
  end
  object Label1: TLabel
    Left = 8
    Top = 5
    Width = 323
    Height = 13
    Caption = 'To work with the in-game Notebook, you need to manage two files.'
  end
  object gbxFlagFileName: TGroupBox
    Left = 8
    Top = 24
    Width = 378
    Height = 45
    Caption = ' Memo Data File: '
    TabOrder = 0
    object edtDataFileName: TEdit
      Left = 8
      Top = 16
      Width = 277
      Height = 21
      TabOrder = 0
      Text = 'MEMODATA.BIN'
    end
    object btnDataFileName: TButton
      Left = 291
      Top = 14
      Width = 75
      Height = 25
      Caption = 'Browse...'
      TabOrder = 1
      OnClick = btnDataFileNameClick
    end
  end
  object gbxDataFileName: TGroupBox
    Left = 8
    Top = 75
    Width = 378
    Height = 90
    Caption = ' Memo Flag Code File: '
    TabOrder = 1
    object lblFlagFileName: TLabel
      Left = 8
      Top = 43
      Width = 358
      Height = 39
      AutoSize = False
      Caption = 
        'Are you working on the Xbox version? If yes, the Flag Code file ' +
        'isn'#39't available: it'#39's located inside the XBE executable. Please ' +
        'select the Xbox game executable (XBE) in that case.'
      WordWrap = True
    end
    object edtFlagFileName: TEdit
      Left = 8
      Top = 16
      Width = 277
      Height = 21
      TabOrder = 0
      Text = 'MEMOFLG.BIN'
    end
    object btnFlagFileName: TButton
      Left = 291
      Top = 14
      Width = 75
      Height = 25
      Caption = 'Browse...'
      TabOrder = 1
      OnClick = btnFlagFileNameClick
    end
  end
  object btnCancel: TButton
    Left = 301
    Top = 179
    Width = 85
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 214
    Top = 179
    Width = 85
    Height = 25
    Caption = '< Generated >'
    ModalResult = 1
    TabOrder = 3
  end
  object odData: TOpenDialog
    DefaultExt = 'BIN'
    FileName = 'MEMODATA.BIN'
    Filter = 
      'Notebook Data Files (MEMODATA.BIN)|MEMODATA.BIN|Generic Binary F' +
      'iles (*.BIN)|*.BIN|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 264
    Top = 32
  end
  object sdData: TSaveDialog
    DefaultExt = 'BIN'
    FileName = 'MEMODATA.BIN'
    Filter = 
      'Notebook Data Files (MEMODATA.BIN)|MEMODATA.BIN|Generic Binary F' +
      'iles (*.BIN)|*.BIN|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 232
    Top = 32
  end
  object odFlag: TOpenDialog
    DefaultExt = 'BIN'
    FileName = 'MEMOFLG.BIN'
    Filter = 
      'Notebook Flag Data Files (MEMOFLG.BIN)|MEMOFLG.BIN|Xbox Executab' +
      'le Files (*.XBE)|*.XBE|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 264
    Top = 84
  end
  object sdFlag: TSaveDialog
    DefaultExt = 'BIN'
    FileName = 'MEMOFLG.BIN'
    Filter = 
      'Notebook Flag Data Files (MEMOFLG.BIN)|MEMOFLG.BIN|Xbox Executab' +
      'le Files (*.XBE)|*.XBE|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 232
    Top = 84
  end
end
