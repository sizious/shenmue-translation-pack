unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MTEdit, StdCtrls, Menus, ComCtrls, FilesLst, JvBaseDlg,
  JvBrowseFolder;

const
  APP_VERSION = '0.1a';
  
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
    bExportAll: TButton;
    bImport: TButton;
    ools1: TMenuItem;
    Autosave1: TMenuItem;
    Makebackup1: TMenuItem;
    Save1: TMenuItem;
    N2: TMenuItem;
    Saveas1: TMenuItem;
    N3: TMenuItem;
    exturespreview1: TMenuItem;
    sdExportTex: TSaveDialog;
    bfdExportAllTex: TJvBrowseForFolderDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure bExportClick(Sender: TObject);
    procedure Opendirectory1Click(Sender: TObject);
    procedure lbFilesListClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure bExportAllClick(Sender: TObject);
    procedure exturespreview1Click(Sender: TObject);
    procedure lvTexturesListClick(Sender: TObject);
  private
    { Déclarations privées }
    fFilesList: TFilesList;
    fSourceDirectory: TFileName;
    fExportDirectory: TFileName;
    procedure Clear;
    procedure LoadFileInView;
  public
    { Déclarations publiques }
    procedure ClearFilesListControls;
    procedure ClearFilesInfos;
    procedure UpdateTexturePreviewWindow;
    function MsgBox(const Text, Caption: string; Flags: Integer): Integer;
    procedure SetStatus(const Text: string);
    property ExportDirectory: TFileName read fExportDirectory write fExportDirectory;
    property FilesList: TFilesList read fFilesList;
    property SourceDirectory: TFileName read fSourceDirectory write fSourceDirectory;
  end;

var
  frmMain: TfrmMain;
  ModelEditor: TModelTexturedEditor;

implementation

uses
  MTScan_Intf, Progress, SelDir, TexView, Common, Pvr2Png;

{$R *.dfm}

procedure TfrmMain.bExportAllClick(Sender: TObject);
var
  i: Integer;
  Item: TTexturesListEntry;
  
begin
  with bfdExportAllTex do begin
    if ExportDirectory = '' then
      ExportDirectory := IncludeTrailingPathDelimiter(ExtractFilePath(ModelEditor.FileName));
    Directory := ExportDirectory;
    if Execute then
      for i := 0 to ModelEditor.Textures.Count - 1 do begin
        Directory := IncludeTrailingPathDelimiter(Directory);
        Item := ModelEditor.Textures[i];
        Item.ExportToFile(Directory + Item.GetOutputTextureFileName);
      end;
  end;
end;

procedure TfrmMain.bExportClick(Sender: TObject);
begin
  if lvTexturesList.ItemIndex = -1 then begin
    MsgBox('Please select an item in the textures list.', 'Warning', MB_ICONEXCLAMATION);
    Exit;
  end;

  with sdExportTex do begin
    FileName := ModelEditor.Textures[lvTexturesList.ItemIndex].GetOutputTextureFileName;
    if Execute then
      ModelEditor.Textures[lvTexturesList.ItemIndex].ExportToFile(FileName);
  end;
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

  // DEBUG
  SourceDirectory := 'G:\Sources\Shenmue\SHENMUE_2\SHENMUE2_DISC1\BUILD\DATA\SCENE\01\0001';
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  fFilesList.Free;
  ModelEditor.Free;
  ClearFilesInfos;
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
  TmpPvr: TFileName;
  PVRConverter: TPVRConverter;

begin
  ClearFilesInfos;

  // Textures
  for i := 0 to ModelEditor.Textures.Count - 1 do begin
    with lvTexturesList.Items.Add do begin
      Caption := IntToStr(i+1);
      SubItems.Add(IntToStr(ModelEditor.Textures[i].Offset));
      SubItems.Add(IntToStr(ModelEditor.Textures[i].Size));

      // Decoding the PVR texture to PNG...
      Data := TPVRConverter.Create;
      PVRConverter := TPVRConverter(Data);
      TmpPvr := ModelEditor.Textures[i].ExportToFolder(GetWorkingDirectory);
      if PVRConverter.LoadFromFile(TmpPvr) then
        DeleteFile(TmpPvr);
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

procedure TfrmMain.lvTexturesListClick(Sender: TObject);
begin
  UpdateTexturePreviewWindow;
end;

function TfrmMain.MsgBox(const Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmMain.ClearFilesInfos;
var
  i: Integer;

begin
  for i := 0 to lvTexturesList.Items.Count - 1 do
    TPVRConverter(lvTexturesList.Items[i].Data).Free;
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

procedure TfrmMain.exturespreview1Click(Sender: TObject);
begin
  frmTexPreview.Show;
  UpdateTexturePreviewWindow;
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

procedure TfrmMain.Quit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.SetStatus(const Text: string);
begin

end;

procedure TfrmMain.UpdateTexturePreviewWindow;
var
  PVRConverter: TPVRConverter;

begin
  if not Assigned(lvTexturesList.ItemFocused) then Exit;  
  PVRConverter := lvTexturesList.ItemFocused.Data;
  if not Assigned(PVRConverter) then Exit;
  
  if frmTexPreview.Visible then begin
    with frmTexPreview do begin
      ClientHeight := PVRConverter.Height;
      ClientWidth := PVRConverter.Width;
      iTexture.Picture.LoadFromFile(PVRConverter.TargetFileName);
    end;
  end;
end;

end.
