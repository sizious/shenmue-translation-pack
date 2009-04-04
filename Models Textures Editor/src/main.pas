unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MTEdit, StdCtrls, Menus, ComCtrls, FilesLst;

const
  APP_VERSION = '1.0';
  
type
  TfrmMain = class(TForm)
    mmMain: TMainMenu;
    File1: TMenuItem;
    About1: TMenuItem;
    About2: TMenuItem;
    Quit1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    StatusBar1: TStatusBar;
    lvTexturesList: TListView;
    odFileSelect: TOpenDialog;
    bExport: TButton;
    Opendirectory1: TMenuItem;
    lbFilesList: TListBox;
    Label9: TLabel;
    eFilesCount: TEdit;
    GroupBox3: TGroupBox;
    lvSectionsList: TListView;
    Button1: TButton;
    Button2: TButton;
    ools1: TMenuItem;
    Autosave1: TMenuItem;
    Makebackup1: TMenuItem;
    Save1: TMenuItem;
    N2: TMenuItem;
    Saveas1: TMenuItem;
    N3: TMenuItem;
    exturespreview1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure bExportClick(Sender: TObject);
    procedure Opendirectory1Click(Sender: TObject);
    procedure lbFilesListClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    fFilesList: TFilesList;
    fSourceDirectory: TFileName;
    procedure Clear;
    procedure LoadFileInView;
  public
    { Déclarations publiques }
    procedure ClearFilesListControls;
    procedure ClearFilesInfos;
    procedure SetStatus(const Text: string);
    property FilesList: TFilesList read fFilesList;
    property SourceDirectory: TFileName read fSourceDirectory write fSourceDirectory;
  end;

var
  frmMain: TfrmMain;
  ModelEditor: TModelTexturedEditor;

implementation

uses
  MTScan_Intf, Progress, seldir;
  
{$R *.dfm}

procedure TfrmMain.bExportClick(Sender: TObject);
begin
  ModelEditor.Textures[0].ExportToFile;
end;

procedure TfrmMain.Clear;
begin
  ClearFilesListControls;
  ClearFilesInfos;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  frmMain.Caption := Application.Title + ' - v' + APP_VERSION + ' - (C)reated by [big_fury]SiZiOUS';
  Clear;
  ModelEditor := TModelTexturedEditor.Create;
  fFilesList := TFilesList.Create;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  fFilesList.Free;
  ModelEditor.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  Application.Title := frmMain.Caption;
end;

procedure TfrmMain.lbFilesListClick(Sender: TObject);
var
  FileEntry: TFileEntry;

begin
  FileEntry := FilesList[lbFilesList.ItemIndex];
  if FileEntry.Exists then begin
    ModelEditor.LoadFromFile(FileEntry.FileName);
    LoadFileInView; // load textures
  end else
    SetStatus(FileEntry.ExtractedFileName + ' has been deleted!');
end;

procedure TfrmMain.LoadFileInView;
var
  i: Integer;

begin
  ClearFilesInfos;

  // Textures
  for i := 0 to ModelEditor.Textures.Count - 1 do begin
    with lvTexturesList.Items.Add do begin
      Caption := IntToStr(i+1);
      SubItems.Add(IntToStr(ModelEditor.Textures[i].Offset));
      SubItems.Add(IntToStr(ModelEditor.Textures[i].Size));
    end;
  end;

  // Sections
  for i := 0 to ModelEditor.Sections.Count - 1 do begin
    with lvSectionsList.Items.Add do begin
      Caption := ModelEditor.Sections[i].Name;
      SubItems.Add(IntToStr(ModelEditor.Sections[i].Offset));
      SubItems.Add(IntToStr(ModelEditor.Sections[i].Size));
    end;
  end;
end;

procedure TfrmMain.ClearFilesInfos;
begin
  lvTexturesList.Clear;
  lvSectionsList.Clear;
end;

procedure TfrmMain.ClearFilesListControls;
begin
  lbFilesList.Clear;
  eFilesCount.Text := '0';
  SourceDirectory := '';
  if Assigned(FilesList) then FilesList.Clear;
end;

procedure TfrmMain.Open1Click(Sender: TObject);
begin
  with odFileSelect do
    if Execute then begin
      Clear;
      ModelEditor.LoadFromFile(FileName);
      FilesList.Add(FileName);
      lbFilesList.Items.Add(ExtractFileName(FileName));
      lbFilesList.ItemIndex := 0;
      LoadFileInView;
    end;
end;

procedure TfrmMain.Opendirectory1Click(Sender: TObject);
begin
  with frmSelectDir do begin
    if Execute(SourceDirectory) then begin
      Clear;
      SourceDirectory := GetSelectedDirectory;
      SetStatus('Scanning directory ... Please wait.');
      ScanDirectory(SourceDirectory);
    end;
  end;
end;

procedure TfrmMain.SetStatus(const Text: string);
begin

end;

end.
