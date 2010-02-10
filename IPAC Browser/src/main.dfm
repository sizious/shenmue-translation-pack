object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 294
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mmMain
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object mmMain: TMainMenu
    Left = 462
    Top = 30
    object miFile: TMenuItem
      Caption = '&File'
      object miOpen: TMenuItem
        Caption = '&Open...'
        ShortCut = 16463
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miQuit: TMenuItem
        Caption = 'Quit'
        ShortCut = 16465
      end
    end
    object miDebugMenu: TMenuItem
      Caption = 'DEBUG'
      object estIPACEditor1: TMenuItem
        Caption = 'Test IPACEditor'
        OnClick = estIPACEditor1Click
      end
    end
  end
end
