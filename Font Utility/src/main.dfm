object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '< Dynamic Title > // Font Utility'
  ClientHeight = 318
  ClientWidth = 364
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
  object bvl: TBevel
    Left = 4
    Top = 259
    Width = 353
    Height = 2
  end
  object gbFiles: TGroupBox
    Left = 4
    Top = 51
    Width = 353
    Height = 98
    Caption = ' Files input : '
    TabOrder = 0
    object Label3: TLabel
      Left = 6
      Top = 18
      Width = 33
      Height = 13
      Caption = 'Input :'
    end
    object Label4: TLabel
      Left = 6
      Top = 56
      Width = 44
      Height = 13
      Caption = 'Output : '
    end
    object eInput: TEdit
      Left = 6
      Top = 33
      Width = 304
      Height = 21
      TabOrder = 0
      Text = '(File)'
    end
    object eOutput: TEdit
      Left = 6
      Top = 70
      Width = 304
      Height = 21
      TabOrder = 1
      Text = '(File)'
    end
    object bInput: TButton
      Left = 316
      Top = 30
      Width = 34
      Height = 25
      Caption = '...'
      TabOrder = 2
    end
    object bOutput: TButton
      Left = 316
      Top = 68
      Width = 34
      Height = 25
      Caption = '...'
      TabOrder = 3
    end
  end
  object rgAction: TRadioGroup
    Left = 4
    Top = 8
    Width = 353
    Height = 37
    Caption = ' Operation : '
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Decode'
      'Encode')
    TabOrder = 1
  end
  object gbBytes: TGroupBox
    Left = 4
    Top = 155
    Width = 353
    Height = 46
    Caption = ' Bytes per line in the encoded file : '
    TabOrder = 2
    object lBytes: TLabel
      Left = 311
      Top = 20
      Width = 27
      Height = 13
      Caption = 'Bytes'
      Enabled = False
    end
    object rbBytesAuto: TRadioButton
      Left = 6
      Top = 18
      Width = 90
      Height = 17
      Caption = 'Autodetect'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbBytesAutoClick
    end
    object rbBytesTwo: TRadioButton
      Left = 102
      Top = 18
      Width = 44
      Height = 17
      Caption = '2'
      TabOrder = 1
      OnClick = rbBytesAutoClick
    end
    object rbBytesCustom: TRadioButton
      Left = 207
      Top = 18
      Width = 58
      Height = 17
      Caption = 'Custom'
      TabOrder = 2
      OnClick = rbBytesCustomClick
    end
    object rbBytesThree: TRadioButton
      Left = 152
      Top = 18
      Width = 49
      Height = 17
      Caption = '3'
      TabOrder = 3
      OnClick = rbBytesAutoClick
    end
    object eBytesCustom: TEdit
      Left = 269
      Top = 16
      Width = 36
      Height = 21
      Enabled = False
      TabOrder = 4
      Text = '(Nb)'
    end
  end
  object bExecute: TButton
    Left = 4
    Top = 266
    Width = 121
    Height = 25
    Caption = '&Execute'
    TabOrder = 3
  end
  object gbChars: TGroupBox
    Left = 4
    Top = 207
    Width = 353
    Height = 46
    Caption = ' Characters per line in the decoded file : '
    TabOrder = 4
    object lCharsCustom: TLabel
      Left = 259
      Top = 20
      Width = 91
      Height = 13
      Caption = 'Characters per line'
      Enabled = False
    end
    object rbCharsAuto: TRadioButton
      Left = 6
      Top = 18
      Width = 113
      Height = 17
      Caption = 'Autodetect'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbCharsCustom: TRadioButton
      Left = 152
      Top = 18
      Width = 62
      Height = 17
      Caption = 'Custom'
      TabOrder = 1
    end
    object eCharsCustom: TEdit
      Left = 217
      Top = 16
      Width = 38
      Height = 21
      Enabled = False
      TabOrder = 2
      Text = '(Nb)'
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 299
    Width = 364
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitLeft = 196
    ExplicitTop = 328
    ExplicitWidth = 0
  end
  object bQuit: TButton
    Left = 236
    Top = 266
    Width = 121
    Height = 25
    Caption = '&Quit'
    TabOrder = 6
    OnClick = bQuitClick
  end
end
