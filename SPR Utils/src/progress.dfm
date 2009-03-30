object frmProgress: TfrmProgress
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSizeToolWin
  Caption = '< Dynamic title >'
  ClientHeight = 97
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblCurrentTask: TLabel
    Left = 8
    Top = 8
    Width = 117
    Height = 13
    Caption = '(current operation here)'
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 32
    Width = 313
    Height = 25
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 328
    Top = 32
    Width = 57
    Height = 25
    BevelOuter = bvLowered
    Caption = '0%'
    TabOrder = 1
  end
  object btCancel: TButton
    Left = 304
    Top = 72
    Width = 81
    Height = 17
    Caption = 'Cancel'
    TabOrder = 2
  end
end
