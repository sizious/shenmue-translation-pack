unit FileProp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvListView, Menus;

type
  TfrmProperties = class(TForm)
    pcProp: TPageControl;
    tsGeneral: TTabSheet;
    tsSections: TTabSheet;
    lvGeneral: TJvListView;
    lvSections: TJvListView;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    procedure AddGeneralInfo(const Name, Value: string); overload;
//    procedure AddGeneralInfo(const Name: string; Value: Boolean); overload;
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
  Main, MemoEdit, SysTools, Config, FileSpec;

{$R *.dfm}

procedure TfrmProperties.AddGeneralInfo(const Name, Value: string);
begin
  with lvGeneral.Items.Add do begin
    Caption := Name;
    SubItems.Add(Value);
  end;
end;

(*procedure TfrmProperties.AddGeneralInfo(const Name: string; Value: Boolean);
var
  S: string;

begin
  S := 'No';
  if Value then S := 'Yes';
  AddGeneralInfo(Name, S);
end;*)

procedure TfrmProperties.AddGeneralInfo(const Name: string; Value: Int64);
begin
  AddGeneralInfo(Name, IntToStr(Value));
end;

procedure TfrmProperties.Clear;
begin
  lvGeneral.Clear;
  lvSections.Clear;
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

begin
  Clear;

  with DiaryEditor do begin
    // General Info
    AddGeneralInfo('Data Source File', DataSourceFileName);
    AddGeneralInfo('Flag Source File', FlagSourceFileName);
    AddGeneralInfo('Plateform', PlatformVersionToString(PlatformVersion));

    // Xbox
    with XboxMemoFlagInfo do begin
      AddGeneralInfo('XBE Executable version', ExecutableVersionToString(ExecutableVersion));
      AddGeneralInfo('XBE File', ExecutableFileName);      
      AddGeneralInfo('XBE Flag Offset', FlagOffset);
    end;

    // Sections
    for i := 0 to Sections.Count - 1 do
      with lvSections.Items.Add do begin
        Caption := IntToStr(i);
        SubItems.Add(Sections[i].Name);
        SubItems.Add(IntToStr(Sections[i].Offset));
        SubItems.Add(IntToStr(Sections[i].Size));
      end;
  end;

end;

end.
