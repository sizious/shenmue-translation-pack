object frmMultiTranslation: TfrmMultiTranslation
  Left = 0
  Top = 0
  Caption = 'Multi-Translation'
  ClientHeight = 466
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  DesignSize = (
    512
    466)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 3
    Top = 432
    Width = 506
    Height = 2
    Anchors = [akLeft, akRight, akBottom]
    ExplicitTop = 402
    ExplicitWidth = 491
  end
  object bGo: TButton
    Left = 311
    Top = 437
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Translate'
    TabOrder = 0
    OnClick = bGoClick
  end
  object bClose: TButton
    Left = 409
    Top = 437
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = bCloseClick
  end
  object gbProgress: TGroupBox
    Left = 3
    Top = 354
    Width = 506
    Height = 74
    Anchors = [akLeft, akRight, akBottom]
    Caption = ' Progress : '
    TabOrder = 2
    DesignSize = (
      506
      74)
    object lblProgress: TLabel
      Left = 7
      Top = 16
      Width = 30
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Idle...'
    end
    object pbPAKS: TProgressBar
      Left = 7
      Top = 31
      Width = 493
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object pbTotal: TProgressBar
      Left = 7
      Top = 51
      Width = 493
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
  end
  object pcMulti: TPageControl
    Left = 3
    Top = 3
    Width = 506
    Height = 348
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'T&ranslator'
      DesignSize = (
        498
        320)
      object GroupBox1: TGroupBox
        Left = 1
        Top = 0
        Width = 494
        Height = 179
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' Search this string : '
        TabOrder = 0
        DesignSize = (
          494
          179)
        object Label1: TLabel
          Left = 6
          Top = 20
          Width = 25
          Height = 13
          Caption = 'Files:'
        end
        object lvSubsSelect: TJvListView
          Left = 6
          Top = 39
          Width = 482
          Height = 133
          Anchors = [akLeft, akTop, akRight, akBottom]
          Columns = <
            item
              Caption = 'CharID'
            end
            item
              Caption = 'Code'
            end
            item
              AutoSize = True
              Caption = 'Subtitle'
            end>
          ColumnClick = False
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnSelectItem = lvSubsSelectSelectItem
          ColumnsOrder = '0=50,1=50,2=378'
          Groups = <>
          ExtendedColumns = <
            item
            end
            item
            end
            item
            end>
        end
        object cbFiles: TComboBox
          Left = 37
          Top = 16
          Width = 451
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 1
          OnSelect = cbFilesSelect
        end
      end
      object GroupBox2: TGroupBox
        Left = 1
        Top = 182
        Width = 494
        Height = 134
        Anchors = [akLeft, akRight, akBottom]
        Caption = ' Replace the string with : '
        TabOrder = 1
        DesignSize = (
          494
          134)
        object Label4: TLabel
          Left = 148
          Top = 113
          Width = 91
          Height = 13
          Caption = 'Second line length:'
        end
        object Label5: TLabel
          Left = 11
          Top = 112
          Width = 77
          Height = 13
          Caption = 'First line length:'
        end
        object Label6: TLabel
          Left = 11
          Top = 76
          Width = 48
          Height = 13
          Caption = 'New text:'
        end
        object lOriginalSub: TLabel
          Left = 11
          Top = 32
          Width = 67
          Height = 13
          Caption = '<Generated>'
        end
        object eNewFirstLineLength: TEdit
          Left = 102
          Top = 109
          Width = 40
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
          Text = '0'
        end
        object eNewSecondLineLength: TEdit
          Left = 245
          Top = 110
          Width = 40
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
          Text = '0'
        end
        object mNewSub: TMemo
          Left = 102
          Top = 63
          Width = 382
          Height = 44
          Anchors = [akLeft, akTop, akRight]
          Lines.Strings = (
            'LINE01_____________________________________'
            'LINE02_____________________________________')
          MaxLength = 89
          TabOrder = 2
          OnChange = mNewSubChange
        end
        object mOldSub: TMemo
          Left = 102
          Top = 16
          Width = 382
          Height = 44
          Anchors = [akLeft, akTop, akRight]
          Color = clBtnFace
          Lines.Strings = (
            'LINE01_____________________________________'
            'LINE02_____________________________________')
          MaxLength = 89
          ReadOnly = True
          TabOrder = 3
          OnChange = mOldSubChange
        end
        object cbSameSex: TCheckBox
          Left = 294
          Top = 113
          Width = 189
          Height = 17
          Alignment = taLeftJustify
          Anchors = [akTop, akRight]
          Caption = 'Translate NPC only with same sex'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = '&Debug Log'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        498
        320)
      object mDebugLog: TMemo
        Left = 0
        Top = 0
        Width = 495
        Height = 317
        Anchors = [akLeft, akTop, akRight, akBottom]
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
  end
end
