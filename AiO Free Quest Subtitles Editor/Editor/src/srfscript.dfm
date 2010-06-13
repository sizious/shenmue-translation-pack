object frmCinematicsScript: TfrmCinematicsScript
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cinematics Script Generator'
  ClientHeight = 358
  ClientWidth = 374
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    374
    358)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 7
    Width = 362
    Height = 39
    Caption = 
      'The Cinematic Script Generator is a tool made for Shenmue I. In ' +
      'this game, NPC characters dialogs are in FREExx archives, in fac' +
      't, subtitles in the HUMANS archive aren'#39't used by the game. '
    WordWrap = True
  end
  object Label2: TLabel
    Left = 4
    Top = 53
    Width = 299
    Height = 13
    Caption = 'This tool is here to generate SRF scripts from HUMANS scripts.'
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 4
    Top = 320
    Width = 368
    Height = 2
    Anchors = [akLeft, akBottom]
    ExplicitTop = 175
  end
  object gbTarget: TGroupBox
    Left = 3
    Top = 72
    Width = 368
    Height = 45
    Caption = ' < GENERATED > '
    TabOrder = 0
    object eTarget: TEdit
      Left = 8
      Top = 16
      Width = 314
      Height = 21
      TabOrder = 0
    end
    object bBrowse: TButton
      Left = 328
      Top = 14
      Width = 34
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = bBrowseClick
    end
  end
  object rgDiscNumber: TRadioGroup
    Left = 3
    Top = 121
    Width = 368
    Height = 48
    Caption = ' Disc Number Target : '
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'Disc &1'
      'Disc &2'
      'Disc &3')
    TabOrder = 1
    OnClick = rgDiscNumberClick
  end
  object bGenerate: TButton
    Left = 131
    Top = 326
    Width = 120
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Generate'
    ModalResult = 1
    TabOrder = 2
    OnClick = bGenerateClick
  end
  object bCancel: TButton
    Left = 251
    Top = 326
    Width = 120
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object gbBatchResult: TGroupBox
    Left = 4
    Top = 175
    Width = 367
    Height = 138
    Caption = ' Result : '
    TabOrder = 4
    object lvFiles: TListView
      Left = 6
      Top = 16
      Width = 356
      Height = 94
      Columns = <
        item
          Caption = 'File'
          Width = 240
        end
        item
          Caption = 'Status'
          Width = 80
        end>
      ColumnClick = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
    object pBar: TProgressBar
      Left = 7
      Top = 115
      Width = 292
      Height = 17
      TabOrder = 1
    end
    object lProgBar: TPanel
      Left = 303
      Top = 113
      Width = 59
      Height = 21
      BevelOuter = bvLowered
      Caption = '100,00%'
      TabOrder = 2
    end
  end
  object sdSRF: TSaveDialog
    DefaultExt = 'xml'
    Filter = 'Cinematic Import Script (*.XML)|*.xml|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save the Cinematic Script to...'
    Left = 248
    Top = 80
  end
  object bfdSRF: TJvBrowseForFolderDialog
    Title = 'Select output directory to export all SRF scripts:'
    Left = 278
    Top = 82
  end
end
