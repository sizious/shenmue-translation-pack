object frmSearch: TfrmSearch
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Search files to select...'
  ClientHeight = 89
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblInfo: TLabel
    Left = 8
    Top = 8
    Width = 295
    Height = 13
    Caption = 'You can use the wildcard '#39'*'#39'. The search is not case sensitive.'
  end
  object editSearch: TEdit
    Left = 8
    Top = 32
    Width = 329
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 272
    Top = 64
    Width = 65
    Height = 17
    Caption = 'Go'
    TabOrder = 1
    OnClick = Button1Click
  end
end
