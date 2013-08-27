object frmFileInfo: TfrmFileInfo
  Left = 0
  Top = 0
  Caption = 'File information'
  ClientHeight = 365
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pcFileInfo: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 476
    Height = 323
    ActivePage = tsGeneral
    Align = alClient
    TabOrder = 0
    object tsGeneral: TTabSheet
      Caption = '&Header'
      object lvHeader: TJvListView
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 462
        Height = 289
        Align = alClient
        Columns = <
          item
            Caption = 'Name'
            Width = 100
          end
          item
            AutoSize = True
            Caption = 'Value'
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        ColumnsOrder = '0=100,1=358'
        Groups = <>
        ExtendedColumns = <
          item
          end
          item
          end>
      end
    end
    object tsIpac: TTabSheet
      Caption = 'F&ooter'
      ImageIndex = 2
      object lvIpac: TJvListView
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 462
        Height = 289
        Align = alClient
        Columns = <
          item
            Caption = 'ID'
            Width = 135
          end
          item
            Caption = 'Type'
            Width = 80
          end
          item
            Caption = 'Offset'
            Width = 80
          end
          item
            AutoSize = True
            Caption = 'Size'
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        ColumnsOrder = '0=135,1=80,2=80,3=163'
        Groups = <>
        ExtendedColumns = <
          item
          end
          item
          end
          item
          end
          item
          end>
      end
    end
    object tsCharsIdDecode: TTabSheet
      Caption = 'CharID &table'
      ImageIndex = 3
      object lvCharsId: TJvListView
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 462
        Height = 289
        Align = alClient
        Columns = <
          item
            Caption = 'Code'
            Width = 100
          end
          item
            AutoSize = True
            Caption = 'CharID'
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        ColumnsOrder = '0=100,1=358'
        Groups = <>
        ExtendedColumns = <
          item
          end
          item
          end>
      end
    end
    object tsSubsInfo: TTabSheet
      Caption = '&Subtitles table'
      ImageIndex = 1
      object lvSubs: TJvListView
        AlignWithMargins = True
        Left = 1
        Top = 3
        Width = 464
        Height = 289
        Margins.Left = 1
        Align = alClient
        Columns = <
          item
            Caption = 'Code offset'
            Width = 70
          end
          item
            Caption = 'Text offset'
            Width = 70
          end
          item
            Caption = 'VoiceID'
            Width = 80
          end
          item
            Caption = 'CharID'
          end
          item
            Caption = 'Code'
            Width = 40
          end
          item
            AutoSize = True
            Caption = 'Text'
          end>
        ReadOnly = True
        RowSelect = True
        PopupMenu = pmSubs
        TabOrder = 0
        ViewStyle = vsReport
        ColumnsOrder = '0=70,1=70,2=80,3=50,4=40,5=150'
        Groups = <>
        ExtendedColumns = <
          item
          end
          item
          end
          item
          end
          item
          end
          item
          end
          item
          end>
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 329
    Width = 482
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      482
      36)
    object Bevel1: TBevel
      Left = 4
      Top = 3
      Width = 476
      Height = 2
      Anchors = [akLeft, akTop, akRight]
      ExplicitWidth = 479
    end
    object bClose: TButton
      Left = 364
      Top = 8
      Width = 111
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Close'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = bCloseClick
    end
    object bProperties: TButton
      Left = 262
      Top = 8
      Width = 101
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Properties...'
      TabOrder = 1
      OnClick = bPropertiesClick
    end
  end
  object pmSubs: TPopupMenu
    Left = 424
    Top = 278
    object Display1: TMenuItem
      Caption = '&Display values'
      object Hex1: TMenuItem
        Caption = '&Hex'
        Checked = True
        OnClick = Hex1Click
      end
      object Dec1: TMenuItem
        Caption = 'D&ec'
        OnClick = Dec1Click
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Savetofile1: TMenuItem
      Caption = '&Save to file...'
      OnClick = Savetofile1Click
    end
  end
  object sdSubsExport: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CSV Files (*.csv)|*.csv|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save subtitles dump to...'
    Left = 392
    Top = 278
  end
end
