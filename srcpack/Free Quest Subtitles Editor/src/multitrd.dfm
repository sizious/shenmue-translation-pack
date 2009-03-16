object frmMultiTranslation: TfrmMultiTranslation
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Multi-translation'
  ClientHeight = 362
  ClientWidth = 364
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
  object Bevel1: TBevel
    Left = 5
    Top = 327
    Width = 355
    Height = 2
  end
  object Label7: TLabel
    Left = 5
    Top = 6
    Width = 350
    Height = 26
    Caption = 
      'This feature allow you to translate a subtitle string in all the' +
      ' files present in the list automatically.'
    WordWrap = True
  end
  object GroupBox2: TGroupBox
    Left = 5
    Top = 195
    Width = 355
    Height = 126
    Caption = ' Replace the string with : '
    TabOrder = 1
    object Label4: TLabel
      Left = 9
      Top = 103
      Width = 91
      Height = 13
      Caption = 'Second line length:'
    end
    object Label5: TLabel
      Left = 9
      Top = 80
      Width = 77
      Height = 13
      Caption = 'First line length:'
    end
    object Label6: TLabel
      Left = 9
      Top = 34
      Width = 26
      Height = 13
      Caption = 'Text:'
    end
    object mNewSub: TMemo
      Left = 116
      Top = 19
      Width = 233
      Height = 56
      MaxLength = 89
      TabOrder = 0
      OnChange = mNewSubChange
    end
    object eNewFirstLineLength: TEdit
      Left = 116
      Top = 77
      Width = 233
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = '0'
    end
    object eNewSecondLineLength: TEdit
      Left = 116
      Top = 100
      Width = 233
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
      Text = '0'
    end
  end
  object Button2: TButton
    Left = 209
    Top = 333
    Width = 75
    Height = 25
    Caption = '&Translate'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 285
    Top = 333
    Width = 75
    Height = 25
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 38
    Width = 355
    Height = 153
    Caption = ' Search this string : '
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 127
      Width = 91
      Height = 13
      Caption = 'Second line length:'
    end
    object Label2: TLabel
      Left = 9
      Top = 104
      Width = 77
      Height = 13
      Caption = 'First line length:'
    end
    object Label3: TLabel
      Left = 9
      Top = 58
      Width = 26
      Height = 13
      Caption = 'Text:'
    end
    object lSubs: TLabel
      Left = 9
      Top = 19
      Width = 84
      Height = 13
      Caption = 'Current subtitles:'
    end
    object mOldSub: TMemo
      Left = 116
      Top = 43
      Width = 233
      Height = 56
      MaxLength = 89
      TabOrder = 0
      OnChange = mOldSubChange
    end
    object eOldFirstLineLength: TEdit
      Left = 116
      Top = 101
      Width = 233
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = '0'
    end
    object eOldSecondLineLength: TEdit
      Left = 116
      Top = 124
      Width = 233
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
      Text = '0'
    end
    object cbSubs: TComboBox
      Left = 116
      Top = 16
      Width = 233
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnChange = cbSubsChange
    end
  end
end
