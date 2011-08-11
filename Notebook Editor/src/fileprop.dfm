object frmProperties: TfrmProperties
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'File properties'
  ClientHeight = 244
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pcProp: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 346
    Height = 238
    ActivePage = tsGeneral
    Align = alClient
    TabOrder = 0
    object tsGeneral: TTabSheet
      Caption = 'General'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lvGeneral: TJvListView
        Left = 0
        Top = 0
        Width = 338
        Height = 210
        Align = alClient
        Columns = <
          item
            Caption = 'Name'
            Width = 100
          end
          item
            Caption = 'Value'
            Width = 234
          end>
        ColumnClick = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        ColumnsOrder = '0=100,1=234'
        Groups = <>
        ExtendedColumns = <
          item
          end
          item
          end>
        ExplicitLeft = 6
        ExplicitTop = 14
        ExplicitWidth = 250
        ExplicitHeight = 150
      end
    end
    object tsSections: TTabSheet
      Caption = 'Sections'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lvSections: TJvListView
        Left = 0
        Top = 0
        Width = 338
        Height = 210
        Align = alClient
        Columns = <
          item
            Caption = '#'
            Width = 20
          end
          item
            Caption = 'Name'
            Width = 100
          end
          item
            Caption = 'Offset'
            Width = 70
          end
          item
            Caption = 'Size'
            Width = 70
          end>
        ColumnClick = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        ColumnsOrder = '0=20,1=100,2=70,3=70'
        Groups = <>
        ExtendedColumns = <
          item
          end>
        ExplicitWidth = 278
        ExplicitHeight = 190
      end
    end
  end
end
