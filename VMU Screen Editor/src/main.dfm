object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 246
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lvIpacContent: TJvListView
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 331
    Height = 221
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 100
      end
      item
        Caption = 'Offset'
        Width = 65
      end
      item
        Caption = 'Size'
        Width = 65
      end
      item
        Caption = 'Updated'
        Width = 70
      end>
    ColumnClick = False
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    ColumnsOrder = '0=100,1=65,2=65,3=70'
    HeaderImagePosition = hipRight
    Groups = <>
    ExtendedColumns = <
      item
        HeaderImagePosition = hipRight
      end
      item
        HeaderImagePosition = hipRight
      end
      item
        HeaderImagePosition = hipRight
      end
      item
        HeaderImagePosition = hipRight
      end>
  end
  object Panel1: TPanel
    Left = 337
    Top = 0
    Width = 155
    Height = 227
    Margins.Left = 0
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 3
    object pnlScreenPreview: TPanel
      Left = 3
      Top = 3
      Width = 148
      Height = 100
      BevelOuter = bvLowered
      BevelWidth = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object imgScreenPreview: TImage
        Left = 2
        Top = 2
        Width = 144
        Height = 96
        Align = alClient
        Center = True
        Proportional = True
        Stretch = True
        ExplicitLeft = 12
        ExplicitTop = 6
      end
    end
    object Button1: TButton
      Left = 3
      Top = 109
      Width = 148
      Height = 25
      Caption = '&Import...'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 3
      Top = 137
      Width = 148
      Height = 25
      Caption = '&Export...'
      TabOrder = 2
    end
    object Button3: TButton
      Left = 3
      Top = 166
      Width = 148
      Height = 25
      Caption = '&Export all...'
      TabOrder = 3
    end
    object Button4: TButton
      Left = 3
      Top = 196
      Width = 148
      Height = 25
      Caption = '&Undo import...'
      TabOrder = 4
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 227
    Width = 492
    Height = 19
    Panels = <
      item
        Text = 'Status:'
        Width = 50
      end
      item
        Text = 'Modified'
        Width = 70
      end
      item
        Text = 'Ready'
        Width = 50
      end>
    ExplicitTop = 275
  end
  object MainMenu1: TMainMenu
    Left = 18
    Top = 94
    object File1: TMenuItem
      Caption = '&File'
      object miOpen: TMenuItem
        Caption = 'miOpen'
      end
      object miQuit: TMenuItem
        Caption = '&Quit'
        ShortCut = 16465
      end
    end
  end
  object odOpen: TOpenDialog
    DefaultExt = 'IWD'
    Filter = 'LCD Package Files (*.IWD)|*.IWD|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select the file to open...'
    Left = 8
    Top = 150
  end
end
