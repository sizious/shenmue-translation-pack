object frmMultiTranslation: TfrmMultiTranslation
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Multi-translation'
  ClientHeight = 436
  ClientWidth = 489
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
  OnMouseMove = FormMouseMove
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 5
    Top = 404
    Width = 481
    Height = 2
  end
  object Label7: TLabel
    Left = 8
    Top = 6
    Width = 463
    Height = 13
    Caption = 
      'This feature allow you to translate a subtitle string in all the' +
      ' files present in the list automatically.'
    WordWrap = True
  end
  object GroupBox2: TGroupBox
    Left = 5
    Top = 196
    Width = 480
    Height = 131
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Caption = ' Replace the string with : '
    TabOrder = 1
    object Label4: TLabel
      Left = 299
      Top = 109
      Width = 91
      Height = 13
      Caption = 'Second line length:'
    end
    object Label5: TLabel
      Left = 117
      Top = 109
      Width = 77
      Height = 13
      Caption = 'First line length:'
    end
    object Label6: TLabel
      Left = 10
      Top = 62
      Width = 26
      Height = 13
      Caption = 'Text:'
    end
    object mNewSub: TMemo
      Left = 120
      Top = 20
      Width = 353
      Height = 82
      MaxLength = 89
      TabOrder = 0
      OnChange = mNewSubChange
    end
    object eNewFirstLineLength: TEdit
      Left = 200
      Top = 106
      Width = 78
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = '0'
    end
    object eNewSecondLineLength: TEdit
      Left = 396
      Top = 106
      Width = 77
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
      Text = '0'
    end
  end
  object bTranslate: TButton
    Left = 243
    Top = 408
    Width = 120
    Height = 25
    Caption = '&Translate'
    TabOrder = 2
    OnClick = bTranslateClick
  end
  object bClose: TButton
    Left = 366
    Top = 408
    Width = 120
    Height = 25
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 3
    OnClick = bCloseClick
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 33
    Width = 481
    Height = 160
    Caption = ' Search this string : '
    TabOrder = 0
    object Label1: TLabel
      Left = 247
      Top = 103
      Width = 91
      Height = 13
      Caption = 'Second line length:'
    end
    object Label2: TLabel
      Left = 117
      Top = 103
      Width = 77
      Height = 13
      Caption = 'First line length:'
    end
    object Label3: TLabel
      Left = 10
      Top = 56
      Width = 26
      Height = 13
      Caption = 'Text:'
    end
    object lSubs: TLabel
      Left = 10
      Top = 127
      Width = 79
      Height = 13
      Caption = 'Current subtitle:'
    end
    object Label8: TLabel
      Left = 391
      Top = 103
      Width = 29
      Height = 13
      Caption = 'Code:'
    end
    object mOldSub: TMemo
      Left = 116
      Top = 15
      Width = 357
      Height = 82
      MaxLength = 89
      TabOrder = 0
      OnChange = mOldSubChange
    end
    object eOldFirstLineLength: TEdit
      Left = 200
      Top = 100
      Width = 41
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = '0'
    end
    object eOldSecondLineLength: TEdit
      Left = 344
      Top = 100
      Width = 41
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
      Text = '0'
    end
    object cbSubs: TComboBox
      Left = 117
      Top = 124
      Width = 356
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnChange = cbSubsChange
    end
    object eCode: TEdit
      Left = 426
      Top = 100
      Width = 47
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
  end
  object GroupBox3: TGroupBox
    Left = 5
    Top = 330
    Width = 481
    Height = 72
    Caption = ' Results : '
    TabOrder = 4
    object mResults: TMemo
      Left = 6
      Top = 18
      Width = 467
      Height = 47
      ReadOnly = True
      TabOrder = 0
    end
  end
end
