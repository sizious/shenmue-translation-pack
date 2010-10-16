object frmNewProject: TfrmNewProject
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'New Project'
  ClientHeight = 258
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 4
    Top = 3
    Width = 361
    Height = 41
    Caption = ' Game : '
    TabOrder = 0
    object Label1: TLabel
      Left = 148
      Top = 10
      Width = 61
      Height = 25
      Caption = 'Shenmue  US Shenmue'
      WordWrap = True
    end
    object RadioButton1: TRadioButton
      Left = 8
      Top = 16
      Width = 113
      Height = 17
      Caption = 'What'#39's Shenmue'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 126
      Top = 16
      Width = 113
      Height = 17
      TabOrder = 1
    end
    object RadioButton3: TRadioButton
      Left = 245
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Shenmue II'
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 47
    Width = 361
    Height = 41
    Caption = ' Region : '
    TabOrder = 1
    object RadioButton4: TRadioButton
      Left = 8
      Top = 16
      Width = 113
      Height = 17
      Caption = 'NTSC-J (JAP)'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton5: TRadioButton
      Left = 126
      Top = 16
      Width = 113
      Height = 17
      Caption = 'NTSC-U (USA)'
      TabOrder = 1
    end
    object RadioButton6: TRadioButton
      Left = 245
      Top = 16
      Width = 113
      Height = 17
      Caption = 'PAL (EUR)'
      TabOrder = 2
    end
  end
  object GroupBox3: TGroupBox
    Left = 4
    Top = 92
    Width = 361
    Height = 41
    Caption = ' Platform : '
    TabOrder = 2
    object RadioButton7: TRadioButton
      Left = 8
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Dreamcast'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton8: TRadioButton
      Left = 126
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Xbox'
      TabOrder = 1
    end
  end
end
