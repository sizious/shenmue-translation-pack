object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '<%GENERATED_TITLE%>'
  ClientHeight = 452
  ClientWidth = 633
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
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 633
    Height = 65
    Align = alTop
    Pen.Style = psClear
    ExplicitLeft = 84
    ExplicitTop = 12
    ExplicitWidth = 65
  end
  object Bevel2: TBevel
    Left = 0
    Top = 65
    Width = 633
    Height = 2
    Align = alTop
    ExplicitTop = 4
    ExplicitWidth = 634
  end
  object Label4: TLabel
    Left = 15
    Top = 8
    Width = 352
    Height = 13
    Caption = 'Input here all the information needed to generate the release.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 392
    Width = 633
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 633
      Height = 2
      Align = alTop
      ExplicitLeft = 80
      ExplicitTop = 16
      ExplicitWidth = 50
    end
    object btnAbout: TButton
      Left = 8
      Top = 8
      Width = 99
      Height = 25
      Caption = '&About...'
      TabOrder = 0
    end
    object btnMake: TButton
      Left = 424
      Top = 8
      Width = 99
      Height = 25
      Caption = '&Make'
      TabOrder = 1
      OnClick = btnMakeClick
    end
    object btnQuit: TButton
      Left = 529
      Top = 8
      Width = 99
      Height = 25
      Caption = '&Quit'
      TabOrder = 2
      OnClick = btnQuitClick
    end
  end
  object pcMain: TPageControl
    Left = 7
    Top = 71
    Width = 618
    Height = 315
    ActivePage = tsGeneral
    TabOrder = 1
    object tsGeneral: TTabSheet
      Caption = 'Main'
      object gbxSource: TGroupBox
        Left = 3
        Top = 3
        Width = 604
        Height = 78
        Caption = ' Source Directory : '
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 17
          Width = 559
          Height = 26
          Caption = 
            'Select here the folder containing your work to release. All the ' +
            'files included in the path will be added on the package created ' +
            'by this application, and will be unpacked on the end-user'#39's comp' +
            'uter.'
          WordWrap = True
        end
        object edtSourceDir: TEdit
          Left = 8
          Top = 49
          Width = 556
          Height = 21
          TabOrder = 0
        end
        object btnSourceDir: TButton
          Left = 570
          Top = 49
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 1
          OnClick = btnSourceDirClick
        end
      end
      object gbxDestination: TGroupBox
        Left = 3
        Top = 87
        Width = 604
        Height = 66
        Caption = ' Destination Directory : '
        TabOrder = 1
        object Label5: TLabel
          Left = 8
          Top = 17
          Width = 337
          Height = 13
          Caption = 
            'Specify here the folder where the result of the process will be ' +
            'written.'
          WordWrap = True
        end
        object edtDestDir: TEdit
          Left = 8
          Top = 36
          Width = 556
          Height = 21
          TabOrder = 0
        end
        object btnDestDir: TButton
          Left = 570
          Top = 36
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 1
          OnClick = btnDestDirClick
        end
      end
    end
    object tsOptions: TTabSheet
      Caption = 'Config'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox2: TGroupBox
        Left = 3
        Top = 3
        Width = 604
        Height = 66
        Caption = ' Wizard UI File : '
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 17
          Width = 249
          Height = 13
          Caption = 'Specify here the folder containing the UI messages.'
        end
        object edtAppConfig: TEdit
          Left = 8
          Top = 36
          Width = 556
          Height = 21
          TabOrder = 0
        end
        object btnAppConfig: TButton
          Left = 570
          Top = 36
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 1
          OnClick = btnAppConfigClick
        end
      end
      object GroupBox7: TGroupBox
        Left = 3
        Top = 75
        Width = 604
        Height = 66
        Caption = ' EULA File : '
        TabOrder = 1
        object Label9: TLabel
          Left = 8
          Top = 17
          Width = 260
          Height = 13
          Caption = 'This license agreement will be shown at the beginning.'
        end
        object edtEULA: TEdit
          Left = 8
          Top = 36
          Width = 556
          Height = 21
          TabOrder = 0
        end
        object btnEULA: TButton
          Left = 570
          Top = 36
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 1
          OnClick = btnEULAClick
        end
      end
      object gbxKeysAuth: TGroupBox
        Left = 3
        Top = 147
        Width = 604
        Height = 133
        Caption = ' Package Encryption Keys : '
        TabOrder = 2
        object lblPC1: TLabel
          Left = 8
          Top = 52
          Width = 26
          Height = 13
          Caption = 'PC1 :'
        end
        object lblCamellia: TLabel
          Left = 8
          Top = 80
          Width = 46
          Height = 13
          Caption = 'Camellia :'
        end
        object lblAES: TLabel
          Left = 8
          Top = 105
          Width = 26
          Height = 13
          Caption = 'AES :'
        end
        object Label6: TLabel
          Left = 8
          Top = 19
          Width = 589
          Height = 13
          AutoSize = False
          Caption = 
            'Each release package is protected with 3 algorithms. This zone d' +
            'efines the keys necessary to unpack your production.'
          WordWrap = True
        end
        object edtPC1: TEdit
          Left = 60
          Top = 48
          Width = 462
          Height = 21
          MaxLength = 32
          TabOrder = 0
        end
        object edtCamellia: TEdit
          Left = 60
          Top = 75
          Width = 462
          Height = 21
          MaxLength = 32
          TabOrder = 1
        end
        object btnPC1: TButton
          Left = 528
          Top = 46
          Width = 69
          Height = 25
          Caption = 'Generate'
          TabOrder = 2
          OnClick = btnPC1Click
        end
        object btnCamellia: TButton
          Left = 528
          Top = 73
          Width = 69
          Height = 25
          Caption = 'Generate'
          TabOrder = 3
          OnClick = btnPC1Click
        end
        object edtAES: TEdit
          Left = 60
          Top = 102
          Width = 462
          Height = 21
          MaxLength = 32
          TabOrder = 4
        end
        object btnAES: TButton
          Left = 528
          Top = 100
          Width = 69
          Height = 25
          Caption = 'Generate'
          TabOrder = 5
          OnClick = btnPC1Click
        end
      end
    end
    object tsDiscAuth: TTabSheet
      Caption = 'Unlock'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object gbxDiscKeys: TGroupBox
        Left = 3
        Top = 74
        Width = 604
        Height = 210
        Caption = ' Possible Disc Keys : '
        TabOrder = 0
        object Label7: TLabel
          Left = 8
          Top = 19
          Width = 593
          Height = 34
          AutoSize = False
          Caption = 
            'This list show you all optical medias that will unlock the gener' +
            'ated package. The end-user needs to insert the same media disc t' +
            'hat you used to unlock the package produced with this applicatio' +
            'n.'
          WordWrap = True
        end
        object lvDiscKeys: TListView
          Left = 8
          Top = 52
          Width = 589
          Height = 147
          Columns = <
            item
              Caption = '#'
              Width = 20
            end
            item
              Caption = 'Source'
              Width = 300
            end
            item
              Caption = 'Key'
              Width = 245
            end>
          ColumnClick = False
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
      object GroupBox6: TGroupBox
        Left = 3
        Top = 3
        Width = 604
        Height = 65
        Caption = ' Manage Disc Keys List : '
        TabOrder = 1
        object Label8: TLabel
          Left = 8
          Top = 16
          Width = 484
          Height = 13
          Caption = 
            'To allow unlocking the package with a specific media, insert it ' +
            'on your drive then click the Get button.'
          WordWrap = True
        end
        object cbxDrives: TJvDriveCombo
          Left = 8
          Top = 35
          Width = 443
          Height = 22
          DriveTypes = [dtCDROM]
          Offset = 4
          ItemHeight = 16
          TabOrder = 0
        end
        object btnAddKey: TButton
          Left = 457
          Top = 33
          Width = 69
          Height = 25
          Caption = '&Get'
          TabOrder = 1
          OnClick = btnAddKeyClick
        end
        object btnDelKey: TButton
          Left = 528
          Top = 33
          Width = 69
          Height = 25
          Caption = '&Remove'
          TabOrder = 2
        end
      end
    end
    object tsSkin: TTabSheet
      Caption = 'Skin'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 3
        Top = 3
        Width = 604
        Height = 126
        Caption = ' Global Wizard Skin : '
        TabOrder = 0
        object Label10: TLabel
          Left = 8
          Top = 20
          Width = 115
          Height = 13
          Caption = 'Top Banner (691 x 61) :'
        end
        object Label11: TLabel
          Left = 8
          Top = 71
          Width = 131
          Height = 13
          Caption = 'Bottom Banner (691 x 51) :'
        end
        object edtSkinTop: TEdit
          Left = 8
          Top = 36
          Width = 556
          Height = 21
          TabOrder = 0
        end
        object btnSkinTop: TButton
          Left = 570
          Top = 36
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 1
          OnClick = btnSkinTopClick
        end
        object edtSkinBottom: TEdit
          Left = 8
          Top = 90
          Width = 556
          Height = 21
          TabOrder = 2
        end
        object btnSkinBottom: TButton
          Left = 570
          Top = 89
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 3
          OnClick = btnSkinBottomClick
        end
      end
      object GroupBox5: TGroupBox
        Left = 3
        Top = 135
        Width = 604
        Height = 149
        Caption = ' Center Skin : '
        TabOrder = 1
        object Label12: TLabel
          Left = 8
          Top = 20
          Width = 122
          Height = 13
          Caption = 'Left Banner (173 x 385) :'
        end
        object lvwSkinLeft: TListView
          Left = 8
          Top = 43
          Width = 589
          Height = 98
          Columns = <
            item
              Caption = '#'
              Width = 20
            end
            item
              Caption = 'File Name'
              Width = 150
            end
            item
              Caption = 'Path'
              Width = 390
            end>
          ColumnClick = False
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnDblClick = lvwSkinLeftDblClick
        end
        object btnSkinLeftAdd: TButton
          Left = 424
          Top = 12
          Width = 84
          Height = 25
          Caption = 'Edit'
          TabOrder = 1
          OnClick = btnSkinLeftAddClick
        end
        object btnSkinLeftDel: TButton
          Left = 514
          Top = 12
          Width = 83
          Height = 25
          Caption = 'Clear'
          TabOrder = 2
          OnClick = btnSkinLeftDelClick
        end
      end
    end
    object tsEula: TTabSheet
      Caption = 'EULA'
      ImageIndex = 3
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox3: TGroupBox
        Left = 3
        Top = 3
        Width = 604
        Height = 66
        Caption = ' Target EULA File : '
        TabOrder = 0
        object Label3: TLabel
          Left = 8
          Top = 17
          Width = 179
          Height = 13
          Caption = 'Select the target EULA file to display.'
        end
        object Edit3: TEdit
          Left = 8
          Top = 36
          Width = 556
          Height = 21
          TabOrder = 0
          Text = 'Edit1'
        end
        object Button4: TButton
          Left = 570
          Top = 36
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 1
        end
      end
      object GroupBox4: TGroupBox
        Left = 3
        Top = 75
        Width = 604
        Height = 211
        Caption = ' Preview : '
        TabOrder = 1
        object RichEdit1: TRichEdit
          Left = 8
          Top = 20
          Width = 589
          Height = 181
          Lines.Strings = (
            'RichEdit1')
          TabOrder = 0
        end
      end
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 433
    Width = 633
    Height = 19
    Panels = <
      item
        Text = 'Status'
        Width = 50
      end
      item
        Text = 'Ready'
        Width = 400
      end
      item
        Text = '<Progress Goes Here>'
        Width = 125
      end
      item
        Text = '100,00%'
        Width = 55
      end>
  end
  object pbMain: TProgressBar
    Left = 128
    Top = 400
    Width = 281
    Height = 17
    TabOrder = 3
  end
  object bfd: TJvBrowseForFolderDialog
    Options = [odStatusAvailable, odEditBox, odNewDialogStyle]
    Left = 544
    Top = 4
  end
  object od: TOpenDialog
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 576
    Top = 4
  end
  object opd: TOpenPictureDialog
    Left = 512
    Top = 4
  end
end
