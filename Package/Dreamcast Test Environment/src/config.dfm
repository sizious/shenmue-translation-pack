object frmConfig: TfrmConfig
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 300
  ClientWidth = 524
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 5
    Top = 8
    Width = 513
    Height = 245
    ActivePage = TabSheet2
    TabOrder = 0
    object TabSheet2: TTabSheet
      Caption = 'Virtual Drive'
      ImageIndex = 1
      object Label1: TLabel
        Left = 33
        Top = 188
        Width = 464
        Height = 26
        Caption = 
          'If you have Alcohol 120% or Daemon Tools installed into your com' +
          'puter, this tool can mount the generated image for you in the vi' +
          'rtual drive specified here.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Image1: TImage
        Left = 8
        Top = 188
        Width = 16
        Height = 16
        Picture.Data = {
          055449636F6E0000010001001010000001002000680400001600000028000000
          1000000020000000010020000000000040040000000000000000000000000000
          0000000000000000000000000000000000000000727172467271728D727172C7
          727172F0727172F0727172C77271728D72717246000000000000000000000000
          000000000000000000000000727172207271728C878585F5A5A1A0FFBEB9B7FF
          D0C9C8FFD0C9C8FFBEB9B7FFA5A1A0FF878585F57271728C7271722000000000
          000000000000000072717220727172A39B9797FFC4B3AFFFC99282FFC36950FF
          96462CFF96472DFFA46651FFCC8F80FFC5B2AEFF9B9797FF727172A372717220
          00000000000000007271728C9B9797FFCBB0A6FFBF6F54FFB6401CFFC98C78FF
          DDBBB1FFDDBCB4FFB06854FF983214FFC86D57FFCEACA3FF9B9797FF7271728C
          0000000072717246878585F5C5B6B1FFBD6F53FFB1441FFFB1401BFFD7AA9BFF
          FAFBFBFFFAFBFBFFB97664FF9A3315FFBF4020FFC76D57FFC4B2AEFF878585F5
          727172467271728DA5A1A0FFCC9A87FFB24921FFAF441EFFB0401BFFD7AA9BFF
          D1D2D4FFFAFBFBFFB87664FF953114FFBA3F1FFFBA401FFFC99081FFA5A1A0FF
          7271728D727172C7BEB9B7FFCA7D5FFFBF5831FFB04721FFAC3F1AFFD7AA9BFF
          D7D8DAFFFAFBFBFFBD8372FF943114FFB7401DFFB33F1CFFBC684EFFBEB9B7FF
          727172C7727172F0D0C9C8FFCA6C47FFCA633CFFC35C34FFB0451EFFD7AA9BFF
          D7D8DAFFFAFBFBFFC18E7DFF953213FFB2401BFFAD3F1BFFB04B2AFFD0C9C8FF
          727172F0727172F0D0C9C8FFD1714DFFCE6941FFCF6942FFCA623AFFD7AA9BFF
          D7D8DAFFFAFBFBFFBA8370FF943011FFB0411BFFAA401BFFAE4C2AFFD0C9C8FF
          727172F0727172C7BEB9B7FFD78D6FFFD47047FFD46F47FFD56F47FFD7AA9BFF
          F6E4DDFFFAFBFBFFB4755FFFA83F1AFFAE451FFFAD451FFFBA6D51FFBEB9B7FF
          727172C77271728DA5A1A0FFD7AC9BFFDD754AFFDB774EFFD9764EFFE87F57FF
          ED7345FFE57247FFDE5D2DFFCD653CFFC66039FFC15C35FFCC9B89FFA5A1A0FF
          7271728D72717246878585F5C8B8B4FFDD9C82FFE57D51FFE17C53FFF4936DFF
          F5E4DDFFFFF9F2FFEE8B65FFCF653AFFCD6A41FFCD8669FFC5B5B0FF878585F5
          72717246000000007271728C9B9797FFD3B9B0FFE1A087FFEF8359FFF79C78FF
          FFFFFFFFFFFFFFFFF4946EFFD56D42FFD48B6EFFCFB4AAFF9B9797FF7271728C
          000000000000000072717220727172A39B9797FFC8B8B4FFDBB0A0FFEA9A76FF
          F0916BFFF0916BFFE68A64FFD6A693FFC6B7B2FF9B9797FF727172A372717220
          000000000000000000000000727172207271728C878585F5A5A1A0FFBEB9B7FF
          D0C9C8FFD0C9C8FFBEB9B7FFA5A1A0FF878585F57271728C7271722000000000
          0000000000000000000000000000000000000000727172467271728D727172C7
          727172F0727172F0727172C77271728D72717246000000000000000000000000
          00000000F00F0000C00300008001000080010000000000000000000000000000
          00000000000000000000000000000000000000008001000080010000C0030000
          F00F0000}
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 3
        Width = 341
        Height = 45
        Caption = ' Software Type : '
        TabOrder = 1
        object RadioButton1: TRadioButton
          Left = 8
          Top = 18
          Width = 101
          Height = 17
          Caption = 'None'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RadioButton2: TRadioButton
          Left = 115
          Top = 18
          Width = 106
          Height = 17
          Caption = 'Alcohol 120%'
          TabOrder = 1
        end
        object RadioButton3: TRadioButton
          Left = 229
          Top = 18
          Width = 105
          Height = 17
          Caption = 'Daemon Tools'
          TabOrder = 2
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 55
        Width = 489
        Height = 45
        Caption = ' Software Location : '
        TabOrder = 0
        object Edit2: TEdit
          Left = 8
          Top = 16
          Width = 442
          Height = 21
          TabOrder = 0
          Text = 'Edit1'
        end
        object Button2: TButton
          Left = 456
          Top = 16
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 1
        end
      end
      object GroupBox4: TGroupBox
        Left = 355
        Top = 3
        Width = 142
        Height = 45
        Caption = ' Virtual Drive : '
        TabOrder = 2
        object ComboBox1: TComboBox
          Left = 9
          Top = 16
          Width = 124
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'ComboBox1'
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'nullDC'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label2: TLabel
        Left = 33
        Top = 137
        Width = 455
        Height = 26
        Caption = 
          'If you have specified a valid Virtual Drive software in the prev' +
          'ious tab, you can use the nullDC Dreamcast Emulator feature.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Image2: TImage
        Left = 8
        Top = 137
        Width = 16
        Height = 16
        Picture.Data = {
          055449636F6E0000010001001010000001002000680400001600000028000000
          1000000020000000010020000000000040040000000000000000000000000000
          0000000000000000000000000000000000000000727172467271728D727172C7
          727172F0727172F0727172C77271728D72717246000000000000000000000000
          000000000000000000000000727172207271728C878585F5A5A1A0FFBEB9B7FF
          D0C9C8FFD0C9C8FFBEB9B7FFA5A1A0FF878585F57271728C7271722000000000
          000000000000000072717220727172A39B9797FFC4B3AFFFC99282FFC36950FF
          96462CFF96472DFFA46651FFCC8F80FFC5B2AEFF9B9797FF727172A372717220
          00000000000000007271728C9B9797FFCBB0A6FFBF6F54FFB6401CFFC98C78FF
          DDBBB1FFDDBCB4FFB06854FF983214FFC86D57FFCEACA3FF9B9797FF7271728C
          0000000072717246878585F5C5B6B1FFBD6F53FFB1441FFFB1401BFFD7AA9BFF
          FAFBFBFFFAFBFBFFB97664FF9A3315FFBF4020FFC76D57FFC4B2AEFF878585F5
          727172467271728DA5A1A0FFCC9A87FFB24921FFAF441EFFB0401BFFD7AA9BFF
          D1D2D4FFFAFBFBFFB87664FF953114FFBA3F1FFFBA401FFFC99081FFA5A1A0FF
          7271728D727172C7BEB9B7FFCA7D5FFFBF5831FFB04721FFAC3F1AFFD7AA9BFF
          D7D8DAFFFAFBFBFFBD8372FF943114FFB7401DFFB33F1CFFBC684EFFBEB9B7FF
          727172C7727172F0D0C9C8FFCA6C47FFCA633CFFC35C34FFB0451EFFD7AA9BFF
          D7D8DAFFFAFBFBFFC18E7DFF953213FFB2401BFFAD3F1BFFB04B2AFFD0C9C8FF
          727172F0727172F0D0C9C8FFD1714DFFCE6941FFCF6942FFCA623AFFD7AA9BFF
          D7D8DAFFFAFBFBFFBA8370FF943011FFB0411BFFAA401BFFAE4C2AFFD0C9C8FF
          727172F0727172C7BEB9B7FFD78D6FFFD47047FFD46F47FFD56F47FFD7AA9BFF
          F6E4DDFFFAFBFBFFB4755FFFA83F1AFFAE451FFFAD451FFFBA6D51FFBEB9B7FF
          727172C77271728DA5A1A0FFD7AC9BFFDD754AFFDB774EFFD9764EFFE87F57FF
          ED7345FFE57247FFDE5D2DFFCD653CFFC66039FFC15C35FFCC9B89FFA5A1A0FF
          7271728D72717246878585F5C8B8B4FFDD9C82FFE57D51FFE17C53FFF4936DFF
          F5E4DDFFFFF9F2FFEE8B65FFCF653AFFCD6A41FFCD8669FFC5B5B0FF878585F5
          72717246000000007271728C9B9797FFD3B9B0FFE1A087FFEF8359FFF79C78FF
          FFFFFFFFFFFFFFFFF4946EFFD56D42FFD48B6EFFCFB4AAFF9B9797FF7271728C
          000000000000000072717220727172A39B9797FFC8B8B4FFDBB0A0FFEA9A76FF
          F0916BFFF0916BFFE68A64FFD6A693FFC6B7B2FF9B9797FF727172A372717220
          000000000000000000000000727172207271728C878585F5A5A1A0FFBEB9B7FF
          D0C9C8FFD0C9C8FFBEB9B7FFA5A1A0FF878585F57271728C7271722000000000
          0000000000000000000000000000000000000000727172467271728D727172C7
          727172F0727172F0727172C77271728D72717246000000000000000000000000
          00000000F00F0000C00300008001000080010000000000000000000000000000
          00000000000000000000000000000000000000008001000080010000C0030000
          F00F0000}
      end
      object Label3: TLabel
        Left = 33
        Top = 169
        Width = 277
        Height = 13
        Caption = 'This allows you to run your image directly in the emulator.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label4: TLabel
        Left = 33
        Top = 188
        Width = 441
        Height = 26
        Caption = 
          'Please note that only the nullDC emulator can be used, demul doe' +
          'sn'#39't support the images generated by this tool.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 3
        Width = 489
        Height = 45
        Caption = ' nullDC Dreamcast Emulator Location : '
        TabOrder = 0
        object Edit1: TEdit
          Left = 8
          Top = 16
          Width = 442
          Height = 21
          TabOrder = 0
          Text = 'Edit1'
        end
        object Button1: TButton
          Left = 456
          Top = 16
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 1
        end
      end
    end
  end
end
