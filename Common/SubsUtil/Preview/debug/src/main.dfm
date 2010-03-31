object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Shenmue Subtitles Preview Tester'
  ClientHeight = 83
  ClientWidth = 309
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 224
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Update'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 6
    Top = 18
    Width = 216
    Height = 21
    TabOrder = 1
    Text = 'Shenmue'#161#245'Previewer'
  end
end
