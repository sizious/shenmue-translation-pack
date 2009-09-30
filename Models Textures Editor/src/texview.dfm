object frmTexPreview: TfrmTexPreview
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Texture preview'
  ClientHeight = 104
  ClientWidth = 122
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object iBkgnd: TImage
    Left = 0
    Top = 0
    Width = 122
    Height = 104
    Align = alClient
    ExplicitLeft = 84
    ExplicitTop = 10
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object iTexture: TImage
    Left = 0
    Top = 0
    Width = 122
    Height = 104
    Align = alClient
    ExplicitLeft = 84
    ExplicitTop = 10
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
end
