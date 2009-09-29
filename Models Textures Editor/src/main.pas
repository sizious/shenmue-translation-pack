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
    miFile: TMenuItem;
    About1: TMenuItem;
    About2: TMenuItem;
    Quit1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    GroupBox1: TGroupBox;
    StatusBar1: TStatusBar;
    odFileSelect: TOpenDialog;
    Opendirectory1: TMenuItem;
    lbFilesList: TListBox;
    Label9: TLabel;
    eFilesCount: TEdit;
    miOptions: TMenuItem;
    Autosave1: TMenuItem;
    Makebackup1: TMenuItem;
    Save1: TMenuItem;
    N2: TMenuItem;
    Saveas1: TMenuItem;
    N3: TMenuItem;
    exturespreview1: TMenuItem;
    sdExportTex: TSaveDialog;
    bfdExportAllTex: TJvBrowseForFolderDialog;
    miView: TMenuItem;
    StripGBIXheader1: TMenuItem;
    pmFilesList: TPopupMenu;
    Refresh1: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Sections: TTabSheet;
    lvTexturesList: TListView;
    bImport: TButton;
    bExport: TButton;
    bExportAll: TButton;
    lvSectionsList: TListView;
    GroupBox2: TGroupBox;
    mDebug: TMemo;
    N4: TMenuItem;
    Savedebuglog1: TMenuItem;
    Cleardebuglog1: TMenuItem;
    Edit1: TMenuItem;
    Undo1: TMenuItem;
    N5: TMenuItem;
    Import1: TMenuItem;
    Export1: TMenuItem;
    N6: TMenuItem;
    Exportall1: TMenuItem;
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
    procedure Refresh1Click(Sender: TObject);
    procedure lvTexturesListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Save1Click(Sender: TObject);
  private
    { Déclarations privées }
    fFilesList: TFilesList;
    fSourceDirectory: TFileName;
    fExportDirectory: TFileName;
  protected
    procedure LoadFileInView;
  public
    { Déclarations publiques }
    procedure Clear;
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
  MTEditor: TModelTexturedEditor;

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
      ExportDirectory := IncludeTrailingPathDelimiter(ExtractFilePath(MTEditor.SourceFileName));
    Directory := ExportDirectory;
    if Execute then
      for i := 0 to MTEditor.Textures.Count - 1 do begin
        Directory := IncludeTrailingPathDelimiter(Directory);
        Item := MTEditor.Textures[i];
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
    FileName := MTEditor.Textures[lvTexturesList.ItemIndex].GetOutputTextureFileName;
    if Execute then
      MTEditor.Textures[lvTexturesList.ItemIndex].ExportToFile(FileName);
  end;
end;

procedure TfrmMain.Clear;
begin
  ClearFilesListControls;
  ClearFilesInfos;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title + ' - v' + APP_VERSION + ' - (C)reated by [big_fury]SiZiOUS';
  Clear;

  // Initialization of the engine
  MTEditor := TModelTexturedEditor.Create;

  // Initialization of the FileList object
  fFilesList := TFilesList.Create;

  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
  
  // DEBUG
//  SourceDirectory := 'G:\Sources\Shenmue\SHENMUE_2\SHENMUE2_DISC1\BUILD\DATA\SCENE\01\0001';
  SourceDirectory := '.';
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  fFilesList.Free;
  MTEditor.Free;
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
  if lbFilesList.ItemIndex = -1 then Exit;
  
  FileEntry := FilesList[lbFilesList.ItemIndex];
  if FileEntry.Exists then begin
    MTEditor.LoadFromFile(FileEntry.FileName);
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
  for i := 0 to MTEditor.Textures.Count - 1 do begin
    with lvTexturesList.Items.Add do begin
      Caption := IntToStr(i+1);
      SubItems.Add(IntToStr(MTEditor.Textures[i].Offset));
      SubItems.Add(IntToStr(MTEditor.Textures[i].Size));

      // Decoding the PVR texture to PNG...
      Data := TPVRConverter.Create;
      PVRConverter := TPVRConverter(Data);
      TmpPvr := MTEditor.Textures[i].ExportToFolder(GetWorkingDirectory);
      if PVRConverter.LoadFromFile(TmpPvr) then
        DeleteFile(TmpPvr);
    end;
  end;

  // Sections
  for i := 0 to MTEditor.Sections.Count - 1 do begin
    with lvSectionsList.Items.Add do begin
      Caption := MTEditor.Sections[i].Name;
      SubItems.Add(IntToStr(MTEditor.Sections[i].Offset));
      SubItems.Add(IntToStr(MTEditor.Sections[i].Size));
    end;
  end;
end;

procedure TfrmMain.lvTexturesListClick(Sender: TObject);
begin
  UpdateTexturePreviewWindow;
end;

procedure TfrmMain.lvTexturesListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  lvTexturesListClick(Self);
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
//  SourceDirectory := '';
  if Assigned(FilesList) then
    FilesList.Clear;
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
      MTEditor.LoadFromFile(FileName);
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
      SourceDirectory := GetSelectedDirectory;
      ScanDirectory(SourceDirectory);
    end;
  end;
end;

procedure TfrmMain.Quit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.Refresh1Click(Sender: TObject);
begin
  ScanDirectory(SourceDirectory);
end;

procedure TfrmMain.Save1Click(Sender: TObject);
begin
  MTEditor.SaveToFile('test.bin');
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
