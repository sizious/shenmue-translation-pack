object frmPresets: TfrmPresets
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Presets Definition'
  ClientHeight = 240
  ClientWidth = 534
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
  object Bevel1: TBevel
    Left = 4
    Top = 203
    Width = 525
    Height = 2
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 2
    Width = 197
    Height = 191
    Caption = ' Presets: '
    TabOrder = 0
    object ListBox1: TListBox
      Left = 8
      Top = 17
      Width = 181
      Height = 162
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object GroupBox1: TGroupBox
    Left = 207
    Top = 2
    Width = 322
    Height = 191
    Caption = ' Preset Details : '
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 18
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object Label2: TLabel
      Left = 8
      Top = 60
      Width = 68
      Height = 13
      Caption = 'Volume Name:'
    end
    object Label3: TLabel
      Left = 8
      Top = 143
      Width = 86
      Height = 13
      Caption = 'Output File Name:'
    end
    object Label4: TLabel
      Left = 8
      Top = 101
      Width = 84
      Height = 13
      Caption = 'Source Directory:'
    end
    object Edit1: TEdit
      Left = 8
      Top = 33
      Width = 305
      Height = 21
      TabOrder = 0
      Text = 'Edit1'
    end
    object Edit2: TEdit
      Left = 9
      Top = 74
      Width = 304
      Height = 21
      TabOrder = 1
      Text = 'Edit1'
    end
    object Edit3: TEdit
      Left = 8
      Top = 158
      Width = 275
      Height = 21
      TabOrder = 2
      Text = 'Edit1'
    end
    object Edit4: TEdit
      Left = 8
      Top = 116
      Width = 275
      Height = 21
      TabOrder = 3
      Text = 'Edit1'
    end
    object Button5: TButton
      Left = 289
      Top = 116
      Width = 25
      Height = 21
      Caption = '...'
      TabOrder = 4
    end
    object Button6: TButton
      Left = 289
      Top = 158
      Width = 25
      Height = 21
      Caption = '...'
      TabOrder = 5
    end
  end
  object Button1: TButton
    Left = 4
    Top = 211
    Width = 87
    Height = 25
    Caption = 'New...'
    TabOrder = 2
  end
  object Button4: TButton
    Left = 97
    Top = 211
    Width = 87
    Height = 25
    Caption = 'Copy...'
    TabOrder = 3
  end
  object Button2: TButton
    Left = 222
    Top = 211
    Width = 87
    Height = 25
    Caption = 'Edit...'
    TabOrder = 4
  end
  object Button3: TButton
    Left = 315
    Top = 211
    Width = 87
    Height = 25
    Caption = 'Delete...'
    TabOrder = 5
  end
  object Button7: TButton
    Left = 442
    Top = 211
    Width = 87
    Height = 25
    Caption = 'Close'
    TabOrder = 6
  end
end
