object frmSubsPreview: TfrmSubsPreview
  Left = 0
  Top = 0
  AlphaBlend = True
  AlphaBlendValue = 200
  BorderStyle = bsToolWindow
  Caption = 'Subtitles Preview'
  ClientHeight = 480
  ClientWidth = 640
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object iSub1: TImage
    Left = 2
    Top = 418
    Width = 640
    Height = 30
    Center = True
    Transparent = True
  end
  object iSub2: TImage
    Left = 2
    Top = 386
    Width = 640
    Height = 30
    Center = True
    Transparent = True
  end
end
