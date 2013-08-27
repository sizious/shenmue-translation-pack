unit fileprop;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvListView, Menus;

type
  TfrmProperties = class(TForm)
    pcProp: TPageControl;
    tsGeneral: TTabSheet;
    tsSections: TTabSheet;
    tsContent: TTabSheet;
    lvGeneral: TJvListView;
    lvSections: TJvListView;
    lvContent: TJvListView;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    procedure AddGeneralInfo(const Name, Value: string); overload;
    procedure AddGeneralInfo(const Name: string; Value: Boolean); overload;
    procedure AddGeneralInfo(const Name: string; Value: Int64); overload;    
  public
    { Déclarations publiques }
    procedure Clear;
    procedure RefreshInfos;
  end;

var
  frmProperties: TfrmProperties;

implementation

uses
  Main, SysTools, IpacMgr, Utils;

{$R *.dfm}

procedure TfrmProperties.AddGeneralInfo(const Name, Value: string);
begin
  with lvGeneral.Items.Add do begin
    Caption := Name;
    SubItems.Add(Value);
  end;
end;

procedure TfrmProperties.AddGeneralInfo(const Name: string; Value: Boolean);
var
  S: string;

begin
  S := 'No';
  if Value then S := 'Yes';
  AddGeneralInfo(Name, S);
end;

procedure TfrmProperties.AddGeneralInfo(const Name: string; Value: Int64);
begin
  AddGeneralInfo(Name, IntToStr(Value));
end;

procedure TfrmProperties.Clear;
begin
  lvGeneral.Clear;
  lvSections.Clear;
  lvContent.Clear;
end;

procedure TfrmProperties.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.FilePropertiesVisible := False;
end;

procedure TfrmProperties.FormCreate(Sender: TObject);
begin
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
  pcProp.TabIndex := 0;

  // Double Buffered
  lvGeneral.DoubleBuffered := True;
  lvSections.DoubleBuffered := True;
  lvContent.DoubleBuffered := True;
  DoubleBuffered := True;
  pcProp.DoubleBuffered := True;

  // Load Config
  LoadConfigProperties;
end;

procedure TfrmProperties.FormDestroy(Sender: TObject);
begin
  SaveConfigProperties;
end;

procedure TfrmProperties.RefreshInfos;
var
  i: Integer;
  Section: TFileSectionsListItem;
  Content: TIpacSectionListItem;

begin
  Clear;

  // General Info
  AddGeneralInfo('Compressed', IPACEditor.Compressed);
  AddGeneralInfo('Content count', IpacEditor.Content.Count);
  AddGeneralInfo('File', IPACEditor.SourceFileName);
  AddGeneralInfo('File size (Bytes)', GetFileSize(IpacEditor.SourceFileName));
  AddGeneralInfo('Sections count', IPACEditor.Sections.Count);

  // Sections Info
  for i := 0 to IpacEditor.Sections.Count - 1 do begin
    with lvSections.Items.Add do begin
      Section := IpacEditor.Sections[i];
      Caption := IntToStr(Section.Index);
      SubItems.Add(Section.Name);
      SubItems.Add(IntToStr(Section.Offset));
      SubItems.Add(IntToStr(Section.Size));
    end;
  end;

  // Content Info
  for i := 0 to IpacEditor.Content.Count - 1 do begin
    with lvContent.Items.Add do begin
      Content := IpacEditor.Content[i];
      Caption := IntToStr(Content.Index);
      SubItems.Add(Content.Name);
      SubItems.Add(Content.Kind);
      if Content.ExpandedKindAvailable then
        SubItems.Add(Content.ExpandedKind.Name)
      else
        SubItems.Add('-');
      SubItems.Add(IntToStr(Content.AbsoluteOffset));
      SubItems.Add(IntToStr(Content.Size));
    end;
  end;
end;

end.
