object frmTexPreview: TfrmTexPreview
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Texture preview'
  ClientHeight = 232
  ClientWidth = 250
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
    Width = 250
    Height = 232
    Align = alClient
    ExplicitLeft = 84
    ExplicitTop = 10
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object iTexture: TImage
    Left = 0
    Top = 0
    Width = 250
    Height = 232
    Align = alClient
    Center = True
    PopupMenu = pmTexture
    OnContextPopup = iTextureContextPopup
    ExplicitLeft = 84
    ExplicitTop = 10
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object sdTexture: TSaveDialog
    DefaultExt = 'png'
    Filter = 'Portable Network Graphics (*.PNG)|*.PNG|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save texture to...'
    Left = 34
    Top = 106
  end
  object pmTexture: TPopupMenu
    Left = 66
    Top = 102
    object miSaveTex: TMenuItem
      Caption = '&Save...'
      OnClick = miSaveTexClick
    end
  end
end
