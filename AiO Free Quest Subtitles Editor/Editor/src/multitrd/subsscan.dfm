object frmSubsRetriever: TfrmSubsRetriever
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Retrieving subtitles...'
  ClientHeight = 88
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lInfos: TLabel
    Left = 8
    Top = 8
    Width = 97
    Height = 13
    Caption = '<< OPERATION >>'
  end
  object Bevel1: TBevel
    Left = 4
    Top = 53
    Width = 336
    Height = 2
  end
  object lProgBar: TLabel
    Left = 287
    Top = 29
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = '<< % >>'
  end
  object pbar: TProgressBar
    Left = 8
    Top = 27
    Width = 277
    Height = 17
    Smooth = True
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 128
    Top = 58
    Width = 93
    Height = 25
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
end
