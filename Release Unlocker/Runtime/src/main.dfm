object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = '<%GENERATED_TITLE%>'
  ClientHeight = 496
  ClientWidth = 691
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pcWizard: TPageControl
    Left = 173
    Top = 61
    Width = 518
    Height = 384
    ActivePage = tsLicense
    Align = alClient
    MultiLine = True
    Style = tsFlatButtons
    TabOrder = 0
    OnChange = pcWizardChange
    OnChanging = pcWizardChanging
    object tsHome: TTabSheet
      Caption = 'Home'
      object lblHomeTitle: TLabel
        Left = 12
        Top = 12
        Width = 112
        Height = 19
        Caption = '<%HOME%>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblHomeMessage: TLabel
        Left = 12
        Top = 41
        Width = 485
        Height = 304
        AutoSize = False
        Caption = '<%HOME_MESSAGE%>'
        WordWrap = True
      end
    end
    object tsDisclamer: TTabSheet
      Caption = 'Warn'
      ImageIndex = 1
      object lblDisclamerTitle: TLabel
        Left = 12
        Top = 12
        Width = 161
        Height = 19
        Caption = '<%DISCLAMER%>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblDisclamerMessage: TLabel
        Left = 12
        Top = 41
        Width = 485
        Height = 300
        AutoSize = False
        Caption = '<%DISCLAMER_SHENTRAD_MESSAGE%>'
        WordWrap = True
      end
    end
    object tsLicense: TTabSheet
      Caption = 'Eula'
      ImageIndex = 4
      object lblLicenseTitle: TLabel
        Left = 12
        Top = 12
        Width = 133
        Height = 19
        Caption = '<%LICENSE%>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblLicenseMessage: TLabel
        Left = 12
        Top = 41
        Width = 248
        Height = 13
        Caption = '<%PRESS_PAGE_DOWN_TO_READ_THE_NEXT%>'
      end
      object reEula: TRichEdit
        Left = 12
        Top = 68
        Width = 489
        Height = 254
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object rbnLicenseAccept: TRadioButton
        Left = 12
        Top = 328
        Width = 489
        Height = 17
        Caption = '<%LICENSE_ACCEPT%>'
        TabOrder = 1
        OnClick = rbnLicenseAcceptClick
      end
      object rbnLicenseDecline: TRadioButton
        Left = 12
        Top = 346
        Width = 489
        Height = 17
        Caption = '<%LICENCE_DECLINE%>'
        Checked = True
        TabOrder = 2
        TabStop = True
        OnClick = rbnLicenseAcceptClick
      end
    end
    object tsDiscAuth: TTabSheet
      Caption = 'Auth'
      ImageIndex = 2
      object lblDiscAuthTitle: TLabel
        Left = 12
        Top = 12
        Width = 151
        Height = 19
        Caption = '<%DISCAUTH%>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblDiscAuthMessage: TLabel
        Left = 12
        Top = 41
        Width = 485
        Height = 44
        AutoSize = False
        Caption = '<%DISCAUTH_DESCRIPTION%>'
        WordWrap = True
      end
      object lblDiscAuthWarning: TLabel
        Left = 20
        Top = 313
        Width = 477
        Height = 38
        AutoSize = False
        Caption = '<%DISCAUTH_WARNING%>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object grpDiscAuthSelectDrive: TGroupBox
        Left = 12
        Top = 97
        Width = 485
        Height = 68
        Caption = ' <%PLEASE_SELECT_DRIVE%> '
        TabOrder = 0
        object cbxDrives: TJvDriveCombo
          Left = 8
          Top = 20
          Width = 469
          Height = 22
          DriveTypes = [dtCDROM]
          Offset = 4
          ItemHeight = 16
          TabOrder = 0
        end
      end
      object grpDiscAuthProgress: TGroupBox
        Left = 12
        Top = 195
        Width = 485
        Height = 62
        Caption = ' <%DISCAUTH_PROGRESS%> '
        TabOrder = 1
        object pbValidator: TProgressBar
          Left = 8
          Top = 20
          Width = 469
          Height = 33
          TabOrder = 0
        end
      end
    end
    object tsAuthFail: TTabSheet
      Caption = 'AFail'
      ImageIndex = 3
      object lblAuthFailTitle: TLabel
        Left = 12
        Top = 12
        Width = 220
        Height = 19
        Caption = '<%DISCAUTH_FAILED%>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblAuthFailMessage: TLabel
        Left = 12
        Top = 41
        Width = 489
        Height = 296
        AutoSize = False
        Caption = '<%DISCAUTH_REASONS%>'
        WordWrap = True
      end
    end
    object tsParams: TTabSheet
      Caption = 'Param'
      ImageIndex = 5
      object lblParamsTitle: TLabel
        Left = 12
        Top = 12
        Width = 489
        Height = 19
        AutoSize = False
        Caption = '<%EXTRACT_PARAMS%>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblParamsMessage: TLabel
        Left = 12
        Top = 41
        Width = 489
        Height = 108
        AutoSize = False
        Caption = '<%EXTRACT_PARAMS_MESSAGE%>'
        WordWrap = True
      end
      object grpParamsExtract: TGroupBox
        Left = 12
        Top = 159
        Width = 489
        Height = 90
        Caption = ' <%EXTRACT_PARAMS_OUTPUT_DIR%> '
        TabOrder = 0
        object lblParamsUnpackedSize: TLabel
          Left = 8
          Top = 71
          Width = 127
          Height = 13
          Caption = '<%NEEDED_SPACE%>'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblParamsExtractToOutputDir: TLabel
          Left = 8
          Top = 17
          Width = 473
          Height = 25
          AutoSize = False
          Caption = '<%EXTRACT_PARAMS_OUTPUT_DIR_MESSAGE%>'
          WordWrap = True
        end
        object edtOutputDir: TEdit
          Left = 8
          Top = 44
          Width = 438
          Height = 21
          TabOrder = 0
          Text = 'C:\Output\'
        end
        object btnParamsBrowse: TButton
          Left = 452
          Top = 44
          Width = 29
          Height = 21
          Caption = '...'
          TabOrder = 1
        end
      end
    end
    object tsReady: TTabSheet
      Caption = 'Ready'
      ImageIndex = 8
      object lblReadyTitle: TLabel
        Left = 12
        Top = 12
        Width = 233
        Height = 19
        Caption = '<%READY_TO_UNPACK%>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblReadyMessage: TLabel
        Left = 12
        Top = 41
        Width = 485
        Height = 276
        AutoSize = False
        Caption = '<%READY_TO_UNPACK_MESSAGE%>'
        WordWrap = True
      end
    end
    object tsWorking: TTabSheet
      Caption = 'Work'
      ImageIndex = 7
      object lblWorkingTitle: TLabel
        Left = 12
        Top = 12
        Width = 146
        Height = 19
        Caption = '<%WORKING%>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblWorkingMessage: TLabel
        Left = 12
        Top = 41
        Width = 485
        Height = 88
        AutoSize = False
        Caption = '<%READY_TO_UNPACK_MESSAGE%>'
        WordWrap = True
      end
      object grpWorkingProgress: TGroupBox
        Left = 12
        Top = 155
        Width = 485
        Height = 62
        Caption = ' <%WORKING_PROGRESS%> '
        TabOrder = 0
        object lblUnpackProgress: TLabel
          Left = 415
          Top = 20
          Width = 62
          Height = 33
          Alignment = taRightJustify
          AutoSize = False
          Caption = '100,00%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
        end
        object pbTotal: TProgressBar
          Left = 8
          Top = 20
          Width = 409
          Height = 33
          TabOrder = 0
        end
      end
    end
    object tsDone: TTabSheet
      Caption = 'Done'
      ImageIndex = 6
      object lblDoneTitle: TLabel
        Left = 12
        Top = 12
        Width = 110
        Height = 19
        Caption = '<%DONE%>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblDoneMessage: TLabel
        Left = 12
        Top = 41
        Width = 485
        Height = 300
        AutoSize = False
        Caption = '<%READY_TO_UNPACK_MESSAGE%>'
        WordWrap = True
      end
    end
    object tsDoneFail: TTabSheet
      Caption = 'DFail'
      ImageIndex = 9
      object lblDoneFailTitle: TLabel
        Left = 12
        Top = 12
        Width = 179
        Height = 19
        Caption = '<%DONE_FAILED%>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblDoneFailMessage: TLabel
        Left = 12
        Top = 41
        Width = 489
        Height = 72
        AutoSize = False
        Caption = '<%DONE_FAILED_MESSAGE%>'
        WordWrap = True
      end
      object grpDoneFailErrorMessage: TGroupBox
        Left = 12
        Top = 160
        Width = 489
        Height = 191
        Caption = 'grpDoneFailErrorMessage'
        TabOrder = 0
        object memDoneFail: TMemo
          Left = 12
          Top = 20
          Width = 465
          Height = 161
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
        end
      end
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 691
    Height = 61
    Align = alTop
    BevelOuter = bvNone
    Color = clMaroon
    ParentBackground = False
    TabOrder = 1
    object imgTop: TImage
      Left = 0
      Top = 0
      Width = 691
      Height = 61
      Align = alClient
      ExplicitLeft = 80
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 445
    Width = 691
    Height = 51
    Align = alBottom
    BevelOuter = bvNone
    Color = clMaroon
    ParentBackground = False
    TabOrder = 2
    object imgBottom: TImage
      Left = 0
      Top = 0
      Width = 691
      Height = 51
      Align = alClient
      ExplicitTop = 2
      ExplicitHeight = 47
    end
    object btnPrev: TButton
      Left = 304
      Top = 16
      Width = 90
      Height = 25
      Caption = '<%PREV%>'
      TabOrder = 1
      OnClick = btnPrevClick
    end
    object btnNext: TButton
      Left = 399
      Top = 16
      Width = 90
      Height = 25
      Caption = '<%NEXT%>'
      TabOrder = 2
      OnClick = btnNextClick
    end
    object btnCancel: TButton
      Left = 576
      Top = 16
      Width = 90
      Height = 25
      Caption = '<%CANCEL%>'
      TabOrder = 3
      OnClick = btnCancelClick
    end
    object btnAbout: TButton
      Left = 36
      Top = 16
      Width = 90
      Height = 25
      Caption = '<%ABOUT%>'
      TabOrder = 0
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 61
    Width = 173
    Height = 384
    Align = alLeft
    BevelOuter = bvNone
    Color = clMaroon
    ParentBackground = False
    TabOrder = 3
    object imgLeft: TImage
      Left = 0
      Top = 0
      Width = 173
      Height = 384
      Align = alClient
      ExplicitHeight = 385
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    Left = 656
    Top = 88
  end
end
