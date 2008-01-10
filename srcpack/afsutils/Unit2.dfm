object Form2: TForm2
  Left = 378
  Top = 187
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Progression...'
  ClientHeight = 57
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 19
    Height = 13
    Caption = 'File:'
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 8
    Width = 329
    Height = 17
    Min = 0
    Max = 100
    Smooth = True
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 288
    Top = 32
    Width = 49
    Height = 17
    BevelOuter = bvLowered
    Caption = '0%'
    TabOrder = 1
  end
end
