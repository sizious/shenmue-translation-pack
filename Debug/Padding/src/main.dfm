object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 127
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 35
    Width = 129
    Height = 25
    Caption = 'Old Padding Calc'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 261
    Height = 21
    TabOrder = 1
    Text = '2048'
  end
  object Button2: TButton
    Left = 139
    Top = 35
    Width = 129
    Height = 25
    Caption = 'Perf'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 66
    Width = 129
    Height = 25
    Caption = 'New Padding Calc'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 139
    Top = 66
    Width = 129
    Height = 25
    Caption = 'Perf'
    TabOrder = 4
    OnClick = Button4Click
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 97
    Width = 257
    Height = 17
    Caption = 'Padding 4'
    TabOrder = 5
  end
end
