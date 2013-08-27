unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MTEdit, StdCtrls, Menus, ComCtrls, FilesLst, JvBaseDlg,
  JvBrowseFolder, ExtCtrls;

{$IFDEF DEBUG}
const
  APP_VERSION_DEBUG = 'a';
{$ENDIF}

type
  TfrmMain = class(TForm)
    mmMain: TMainMenu;
    miFile: TMenuItem;
    miHelp: TMenuItem;
    miAbout: TMenuItem;
    miQuit: TMenuItem;
    miOpenFiles: TMenuItem;
    N1: TMenuItem;
    GroupBox1: TGroupBox;
    odFileSelect: TOpenDialog;
    miOpenDirectory: TMenuItem;
    lbFilesList: TListBox;
    Label9: TLabel;
    eFilesCount: TEdit;
    miOptions: TMenuItem;
    miAutoSave: TMenuItem;
    miMakeBackup: TMenuItem;
    miSave: TMenuItem;
    N2: TMenuItem;
    miSaveAs: TMenuItem;
    miTexturesPreview: TMenuItem;
    sdExportTex: TSaveDialog;
    bfdExportAllTex: TJvBrowseForFolderDialog;
    miView: TMenuItem;
    pmFilesList: TPopupMenu;
    miRefresh: TMenuItem;
    pcMain: TPageControl;
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
    miSaveDebug: TMenuItem;
    miClearDebug: TMenuItem;
    miEdit: TMenuItem;
    miUndo: TMenuItem;
    N5: TMenuItem;
    miImport: TMenuItem;
    miExport: TMenuItem;
    N6: TMenuItem;
    miExportAll: TMenuItem;
    pmTextures: TPopupMenu;
    miImport2: TMenuItem;
    miExport2: TMenuItem;
    N7: TMenuItem;
    miExportAll2: TMenuItem;
    pmSections: TPopupMenu;
    miDumpSection: TMenuItem;
    sdDumpSection: TSaveDialog;
    bUndo: TButton;
    odImportTexture: TOpenDialog;
    rgVersion: TRadioGroup;
    miTexturesProperties: TMenuItem;
    sbMain: TStatusBar;
    N3: TMenuItem;
    miTexturesPreview2: TMenuItem;
    miTexturesProperties2: TMenuItem;
    miUndo2: TMenuItem;
    N8: TMenuItem;
    miLocateOnDisk: TMenuItem;
    miReload2: TMenuItem;
    miClose2: TMenuItem;
    N9: TMenuItem;
    miCloseAll2: TMenuItem;
    miExportFilesList: TMenuItem;
    miBrowseDirectory: TMenuItem;
    miClose: TMenuItem;
    miCloseAll: TMenuItem;
    N10: TMenuItem;
    sdExportList: TSaveDialog;
    miReload: TMenuItem;
    bDumpSection: TButton;
    bDumpAll: TButton;
    sdSaveAs: TSaveDialog;
    N11: TMenuItem;
    miDumpAll2: TMenuItem;
    sdSaveDebug: TSaveDialog;
    bfdDumpSections: TJvBrowseForFolderDialog;
    N12: TMenuItem;
    miProperties2: TMenuItem;
    miProperties: TMenuItem;
    N13: TMenuItem;
    miProjectHome: TMenuItem;
    N14: TMenuItem;
    miCheckForUpdate: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miOpenFilesClick(Sender: TObject);
    procedure bExportClick(Sender: TObject);
    procedure miOpenDirectoryClick(Sender: TObject);
    procedure lbFilesListClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miQuitClick(Sender: TObject);
    procedure bExportAllClick(Sender: TObject);
    procedure miTexturesPreviewClick(Sender: TObject);
    procedure lvTexturesListClick(Sender: TObject);
    procedure miRefreshClick(Sender: TObject);
    procedure lvTexturesListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miSaveClick(Sender: TObject);
    procedure miDumpSectionClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvTexturesListContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure bImportClick(Sender: TObject);
    procedure bUndoClick(Sender: TObject);
    procedure miTexturesPropertiesClick(Sender: TObject);
    procedure miMakeBackupClick(Sender: TObject);
    procedure miAutoSaveClick(Sender: TObject);
    procedure miLocateOnDiskClick(Sender: TObject);
    procedure miBrowseDirectoryClick(Sender: TObject);
    procedure miExportFilesListClick(Sender: TObject);
    procedure lbFilesListContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure miCloseAllClick(Sender: TObject);
    procedure miReloadClick(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miSaveAsClick(Sender: TObject);
    procedure lvSectionsListContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure lvSectionsListClick(Sender: TObject);
    procedure miClearDebugClick(Sender: TObject);
    procedure miSaveDebugClick(Sender: TObject);
    procedure bDumpAllClick(Sender: TObject);
    procedure miPropertiesClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miProjectHomeClick(Sender: TObject);
    procedure miCheckForUpdateClick(Sender: TObject);
  private
    { Déclarations privées }
    fFilesList: TFilesList;
    fSourceDirectory: TFileName;
    fExportDirectory: TFileName;
    fSelectedTexture: TTexturesListEntry;
    fSelectedItem: TListItem;
    fSelectedFileEntry: TFileEntry;
    fMakeBackup: Boolean;
    fAutoSave: Boolean;
    fFileModified: Boolean;
    fSelectedFileTexturesModifiedCount: Integer;
    procedure FilesListEvent_ListCleared(Sender: TObject);
    procedure FilesListEvent_ItemAdded(Sender: TObject; FileName: TFileName;
      ListIndex: Integer);
    function GetStatus: string;
    procedure SetAutoSave(const Value: Boolean);
    procedure SetMakeBackup(const Value: Boolean);
    procedure SetStatus(const Value: string);
    procedure SetFileModified(const Value: Boolean);
    procedure SetSelectedFileEntry(const Value: TFileEntry);
    procedure SetSourceDirectory(const Value: TFileName);
  protected
    procedure ChangeControlsState(State: Boolean);
    procedure ChangeExportAllControlsState(State: Boolean);
    procedure ChangeMultiDumpOperationsControlsState(State: Boolean);
    procedure ChangeSingleDumpOperationsControlsState(State: Boolean);
    procedure ChangeMultiFileOperationsControlsState(State: Boolean);
    procedure ChangeSingleFileOperationsControlsState(State: Boolean);
    procedure ChangeSingleFileSaveOperationsControlsState(State: Boolean);
    procedure ChangeSelectedFolderOperationsControlsState(State: Boolean);
    procedure ChangeUndoImportControlsState(State: Boolean);
    procedure LoadFileEntry(FileEntry: TFileEntry);
    procedure LoadSelectedFileInView;
    function SaveCurrentFileOnDemand(CancelButton: Boolean): Boolean;
    procedure SetApplicationConfigParameters;
    property SelectedFileTexturesModifiedCount: Integer
      read fSelectedFileTexturesModifiedCount write fSelectedFileTexturesModifiedCount;
  public
    { Déclarations publiques }
    procedure AddDebug(Text: string);
    procedure Clear;
    procedure ClearFilesListControls;
    procedure ClearFilesInfos;
    procedure ClearImportedTexturesStatus;
    procedure RemoveSelectedFile;
    function UpdateTexturePreviewWindow: Boolean;
    function MsgBox(const Text, Caption: string; Flags: Integer): Integer;
    procedure ResetStatus;
    property AutoSave: Boolean read fAutoSave write SetAutoSave;
    property ExportDirectory: TFileName read fExportDirectory write fExportDirectory;
    property FilesList: TFilesList read fFilesList;
    property FileModified: Boolean read fFileModified write SetFileModified;
    property MakeBackup: Boolean read fMakeBackup write SetMakeBackup;
    property SelectedFileEntry: TFileEntry read fSelectedFileEntry write SetSelectedFileEntry;
    property SelectedTextureUI: TListItem read fSelectedItem write fSelectedItem;
    property SelectedTexture: TTexturesListEntry read fSelectedTexture write fSelectedTexture;
    property SourceDirectory: TFileName read fSourceDirectory write SetSourceDirectory;
    property Status: string read GetStatus write SetStatus;
  end;

var
  frmMain: TfrmMain;
  MTEditor: TModelTexturedEditor;

implementation

uses
  ShellApi, MTScan_Intf, Progress, SelDir, TexView, Common, Img2Png, Tools,
  texprop, about, SysTools;

const
  DEFAULT_WIDTH = 600;
  DEFAULT_HEIGHT = 570;
   
{$R *.dfm}

procedure TfrmMain.AddDebug(Text: string);
begin
  mDebug.Lines.Add('[' + DateToStr(Date) + ' ' + TimeToStr(Now) + '] ' + Text);
end;

procedure TfrmMain.bDumpAllClick(Sender: TObject);
var
  i: Integer;
  
begin
  with bfdDumpSections do begin
    if ExportDirectory = '' then
      ExportDirectory := IncludeTrailingPathDelimiter(ExtractFilePath(MTEditor.SourceFileName));
    Directory := ExportDirectory;
    if Execute then begin
      Status := 'Dumping sections...';
      Directory := IncludeTrailingPathDelimiter(Directory);
      ExportDirectory := Directory;
      for i := 0 to MTEditor.Textures.Count - 1 do
        MTEditor.Sections[i].ExportToFile(Directory);

      ResetStatus;
      AddDebug('Sections from the "' + ExtractFileName(MTEditor.SourceFileName) +
        '" successfully dumped into the "' + Directory + '" directory.');
    end;
  end;
end;

procedure TfrmMain.bExportAllClick(Sender: TObject);
var
  i: Integer;

begin
  with bfdExportAllTex do begin
    if ExportDirectory = '' then
      ExportDirectory := IncludeTrailingPathDelimiter(ExtractFilePath(MTEditor.SourceFileName));
    Directory := ExportDirectory;
    if Execute then begin
      Status := 'Exporting textures...';
      Directory := IncludeTrailingPathDelimiter(Directory);
      ExportDirectory := Directory;
      for i := 0 to MTEditor.Textures.Count - 1 do
        MTEditor.Textures[i].ExportToFolder(Directory);

      ResetStatus;
      AddDebug('Textures from the "' + ExtractFileName(MTEditor.SourceFileName) +
        '" successfully exported into the "' + Directory + '" directory.');
    end;
  end;
end;

procedure TfrmMain.bExportClick(Sender: TObject);
var
  OutputFormat: TExportFormat;

begin
  if lvTexturesList.ItemIndex = -1 then begin
    MsgBox('Please select an item in the textures list.', 'Warning', MB_ICONEXCLAMATION);
    Exit;
  end;

  with sdExportTex do begin
    FileName := ChangeFileExt(ExtractFileName(MTEditor.SourceFileName), '') + '_TEX#'
      + Format('%2.2d', [SelectedTexture.Index + 1]);

    // Add the DDS for Shenmue 2X
    if MTEditor.GameVersion = gvShenmue2X then begin
      DefaultExt := 'dds';
      Filter := 'DirectDraw Surface Files (*.DDS)|*.dds|PowerVR Textures Files (*.PVR)|*.pvr|All Files (*.*)|*.*'
    end else begin
      DefaultExt := 'pvr';
      Filter := 'PowerVR Textures Files (*.PVR)|*.pvr|All Files (*.*)|*.*';
    end;
    FilterIndex := 1;

    if Execute then begin
      OutputFormat := efPVR;
      if (FilterIndex = 1) and (MTEditor.GameVersion = gvShenmue2X) then
        OutputFormat := efDDS;

      Status := 'Exporting texture...';
      SelectedTexture.ExportToFile(FileName, OutputFormat);

      ResetStatus;
      AddDebug('File texture succesfully exported to "' + FileName + '".');
    end;

  end;
end;

procedure TfrmMain.bImportClick(Sender: TObject);
begin
  with odImportTexture do begin

    // Add the DDS for Shenmue 2X
    if MTEditor.GameVersion = gvShenmue2X then begin
      DefaultExt := 'dds';
      Filter := 'DirectDraw Surface Files (*.DDS)|*.dds|PowerVR Textures Files (*.PVR)|*.pvr|All Files (*.*)|*.*'
    end else begin
      DefaultExt := 'pvr';
      Filter := 'PowerVR Textures Files (*.PVR)|*.pvr|All Files (*.*)|*.*';
    end;
    FilterIndex := 1;

    // Execute
    if Execute then begin
      Status := 'Importing new texture file...';
      SelectedTexture.ImportFromFile(FileName);

      // Updating GUI
      if SelectedTextureUI.SubItems[2] = '' then begin
        Inc(fSelectedFileTexturesModifiedCount);
        SelectedTextureUI.SubItems[2] := 'Yes';
        FileModified := True;
      end;

      // updating debug
      ResetStatus;
      AddDebug('Texture file successfully imported from "' + FileName + '".');
    end;
  end;
end;

procedure TfrmMain.bUndoClick(Sender: TObject);
var
  CanDo: Integer;

begin
  CanDo := MsgBox('Are you sure to cancel the texture remplacement ?',
    'Question', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;

  Status := 'Cancelling...';

  bUndo.Enabled := False;
  SelectedTexture.CancelImport;
  SelectedTextureUI.SubItems[2] := '';
  Dec(fSelectedFileTexturesModifiedCount);
  FileModified := (SelectedFileTexturesModifiedCount > 0);

  ResetStatus;
  AddDebug('Import for the texture #' + IntToStr(SelectedTextureUI.Index + 1) + ' of the file "' +
    SelectedFileEntry.ExtractedFileName + '" cancelled.');
end;

procedure TfrmMain.ChangeControlsState(State: Boolean);
begin
  bImport.Enabled := State;
  bExport.Enabled := State;
  miImport.Enabled := bImport.Enabled;
  miExport.Enabled := bExport.Enabled;
  miImport2.Enabled := bImport.Enabled;
  miExport2.Enabled := bExport.Enabled;
end;

procedure TfrmMain.ChangeExportAllControlsState(State: Boolean);
begin
  bExportAll.Enabled := State;
  miExportAll.Enabled := State;
  miExportAll2.Enabled := State;
end;

procedure TfrmMain.ChangeMultiDumpOperationsControlsState(State: Boolean);
begin
  bDumpAll.Enabled := State;
  miDumpAll2.Enabled := State;
end;

procedure TfrmMain.ChangeMultiFileOperationsControlsState(State: Boolean);
begin
  miCloseAll.Enabled := State;
  miCloseAll2.Enabled := State;
  miExportFilesList.Enabled := State;
end;

procedure TfrmMain.ChangeSelectedFolderOperationsControlsState(State: Boolean);
begin
  miBrowseDirectory.Enabled := State;
  miRefresh.Enabled := State;
end;

procedure TfrmMain.ChangeSingleDumpOperationsControlsState(State: Boolean);
begin
  bDumpSection.Enabled := State;
  miDumpSection.Enabled := State;
end;

procedure TfrmMain.ChangeSingleFileOperationsControlsState(State: Boolean);
begin
  miLocateOnDisk.Enabled := State;
  miReload.Enabled := State;
  miReload2.Enabled := State;
  miClose.Enabled := State;
  miClose2.Enabled := State;
  miProperties.Enabled := State;
  miProperties2.Enabled := State;
end;

procedure TfrmMain.ChangeSingleFileSaveOperationsControlsState(State: Boolean);
begin
  miSave.Enabled := State;
  miSaveAs.Enabled := State;
end;

procedure TfrmMain.ChangeUndoImportControlsState(State: Boolean);
begin
  bUndo.Enabled := State;
  miUndo.Enabled := State;
  miUndo2.Enabled := State;
end;

procedure TfrmMain.Clear;
begin
  ClearFilesListControls;
  ClearFilesInfos;
  ChangeUndoImportControlsState(False);
  ChangeControlsState(False);
  ChangeExportAllControlsState(False);
end;

procedure TfrmMain.FilesListEvent_ItemAdded(Sender: TObject;
  FileName: TFileName; ListIndex: Integer);
begin
  ChangeMultiFileOperationsControlsState(True);
end;

procedure TfrmMain.FilesListEvent_ListCleared(Sender: TObject);
begin
  ChangeMultiFileOperationsControlsState(False);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveConfig;
  if not SaveCurrentFileOnDemand(True) then
    Action := caNone;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  AppVersion: TApplicationFileVersion;
  DebugStr: string;

begin
{$IFDEF DEBUG}
  DebugStr := '/' + APP_VERSION_DEBUG;
{$ELSE}
  DebugStr := '';
{$ENDIF}

  // Application title and version
  AppVersion := GetApplicationFileVersion;
  Caption := Application.Title + ' - v' + IntToStr(AppVersion.Major) + '.'
    + IntToStr(AppVersion.Minor) + DebugStr + ' - (C)reated by [big_fury]SiZiOUS';
  Clear;

  // Extract the Engine for the PVR / PVR-X conversion
  PVRConverter_ExtractEngine(GetWorkingDirectory);

  // Initialization of the engine
  MTEditor := TModelTexturedEditor.Create;

  // Initialization of the FileList object
  fFilesList := TFilesList.Create;
  fFilesList.OnListCleared := FilesListEvent_ListCleared;
  fFilesList.OnItemAdded := FilesListEvent_ItemAdded;
  ChangeMultiFileOperationsControlsState(False); // first run

  Height := DEFAULT_HEIGHT;
  Width := DEFAULT_WIDTH;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
  pcMain.TabIndex := 0;

  FileModified := False;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  fFilesList.Free;
  MTEditor.Free;
  ClearFilesInfos;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
//  Application.Title := frmMain.Caption;
  SetApplicationConfigParameters;
end;

function TfrmMain.GetStatus: string;
begin
  Result := sbMain.Panels[2].Text;
end;

procedure TfrmMain.lbFilesListClick(Sender: TObject);
begin
  if lbFilesList.ItemIndex = -1 then Exit;

  if Assigned(SelectedFileEntry) then begin
    // Check if another file is selected
    if SelectedFileEntry.ExtractedFileName = lbFilesList.Items[lbFilesList.ItemIndex] then Exit;

    // Autosaving the previous file
    SaveCurrentFileOnDemand(False);
  end;

  // Loading the next file
  SelectedFileEntry := FilesList[lbFilesList.ItemIndex];
  // changing source directory in case of the directory is different...
//  SourceDirectory := FilesList[lbFilesList.ItemIndex].ExtractedPath; [EDIT: NOT NEEDED]
  LoadFileEntry(SelectedFileEntry);
end;

procedure TfrmMain.lbFilesListContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  Point : TPoint;

begin
  // enable right-click selection
  GetCursorPos(Point);
  Mouse_Event(MOUSEEVENTF_LEFTDOWN, Point.X, Point.Y, 0, 0);
  Mouse_Event(MOUSEEVENTF_LEFTUP, Point.X, Point.Y, 0, 0);
  Application.ProcessMessages;
end;

procedure TfrmMain.LoadFileEntry(FileEntry: TFileEntry);
begin
  if FileEntry.Exists then begin
    Status := 'Loading...';
    MTEditor.LoadFromFile(FileEntry.FileName);
    LoadSelectedFileInView; // load textures

    // Clear preview window
    if Assigned(frmTexPreview) then
      frmTexPreview.Clear;

    // Clear properties window
    if Assigned(frmTexProp) then
      frmTexProp.Clear;

    ResetStatus;
  end else begin
    // The file on the disk was deleted...
    AddDebug('ERROR: "' + FileEntry.ExtractedFileName + '" has been DELETED from the disk!');
    RemoveSelectedFile;
  end;
end;

procedure TfrmMain.LoadSelectedFileInView;
var
  i: Integer;
  TmpPvr: TFileName;
  PVRConverter: TPVRConverter;
  HasTextures: Boolean;

begin
  ClearFilesInfos;

  rgVersion.ItemIndex := Integer(MTEditor.GameVersion);

  // Textures
  HasTextures := MTEditor.Textures.Count > 0;
  for i := 0 to MTEditor.Textures.Count - 1 do begin
    with lvTexturesList.Items.Add do begin
      Caption := IntToStr(i+1);
      SubItems.Add(IntToStr(MTEditor.Textures[i].Offset));
      SubItems.Add(IntToStr(MTEditor.Textures[i].Size));
      SubItems.Add('');

      // Decoding the PVR texture to PNG...
      Data := TPVRConverter.Create(GetWorkingDirectory);
      PVRConverter := TPVRConverter(Data);
      TmpPvr := MTEditor.Textures[i].ExportToFolder(GetWorkingDirectory, efPVR);
      if PVRConverter.LoadFromFile(TmpPvr) then
        DeleteFile(TmpPvr);
    end;
  end;

  ChangeExportAllControlsState(HasTextures);

  (*if HasTextures then begin
    lvTexturesList.ItemIndex := 0;
    lvTexturesList.SetFocus;
    lvTexturesListClick(Self);
  end;*)

  // Sections
  for i := 0 to MTEditor.Sections.Count - 1 do begin
    with lvSectionsList.Items.Add do begin
      Caption := MTEditor.Sections[i].Name;
      SubItems.Add(IntToStr(MTEditor.Sections[i].Offset));
      SubItems.Add(IntToStr(MTEditor.Sections[i].Size));
    end;
    ChangeMultiDumpOperationsControlsState(True);
  end;

end;

procedure TfrmMain.lvSectionsListClick(Sender: TObject);
begin
  ChangeSingleDumpOperationsControlsState(lvSectionsList.ItemIndex <> -1);  
end;

procedure TfrmMain.lvSectionsListContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  lvSectionsListClick(Self);
end;

procedure TfrmMain.lvTexturesListClick(Sender: TObject);
var
  TextureSelected: Boolean;

begin
  TextureSelected := UpdateTexturePreviewWindow;

  // Enable or disable Import / export options
  ChangeControlsState(TextureSelected);

  if TextureSelected then begin
    bUndo.Enabled := SelectedTextureUI.SubItems[2] = 'Yes';
    miUndo.Enabled := bUndo.Enabled;
    miUndo2.Enabled := miUndo.Enabled;
  end;
end;

procedure TfrmMain.lvTexturesListContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  lvTexturesListClick(Self);
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

procedure TfrmMain.miProjectHomeClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://shenmuesubs.sourceforge.net/', '', '', SW_SHOWNORMAL);
end;

procedure TfrmMain.ClearFilesInfos;
var
  i: Integer;

begin
  for i := 0 to lvTexturesList.Items.Count - 1 do
    TPVRConverter(lvTexturesList.Items[i].Data).Free;
  lvTexturesList.Clear;
  lvSectionsList.Clear;
  ChangeMultiDumpOperationsControlsState(False);
  ChangeSingleDumpOperationsControlsState(False);
  ChangeControlsState(False);
  SelectedFileTexturesModifiedCount := 0;
  FileModified := False;
  SelectedTextureUI := nil;
  SelectedTexture := nil;    
end;

procedure TfrmMain.ClearFilesListControls;
begin
  SelectedFileEntry := nil;
  lbFilesList.Clear;
  eFilesCount.Text := '0';
//  SourceDirectory := '';
  if Assigned(FilesList) then
    FilesList.Clear;
end;

procedure TfrmMain.ClearImportedTexturesStatus;
var
  i: Integer;

begin
  for i := 0 to lvTexturesList.Items.Count - 1 do
    lvTexturesList.Items[i].SubItems[2] := '';
end;

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
  frmAbout := TfrmAbout.Create(Application);
  try
    frmAbout.ShowModal;
  finally
    frmAbout.Free;
  end;
end;

procedure TfrmMain.miAutoSaveClick(Sender: TObject);
begin
  AutoSave := not AutoSave;
end;

procedure TfrmMain.miBrowseDirectoryClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'explorer', PChar(SourceDirectory), '', SW_SHOWNORMAL);
end;

procedure TfrmMain.miCheckForUpdateClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
    'http://sourceforge.net/projects/shenmuesubs/files/', '', '',
    SW_SHOWNORMAL);
end;

procedure TfrmMain.miClearDebugClick(Sender: TObject);
var
  CanDo: Integer;

begin
  CanDo := MsgBox('Clear debug log ?', 'Confirm', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;
  mDebug.Clear;
end;

procedure TfrmMain.miCloseAllClick(Sender: TObject);
var
  CanDo: Integer;

begin
  CanDo := MsgBox('Are you sure to clear all the files list?'  + sLineBreak
  + 'Changes not saved will be LOST!', 'Warning',
    + MB_ICONWARNING + MB_DEFBUTTON2 + MB_YESNO);
  if CanDo = IDNO then Exit;

  Clear;
end;

procedure TfrmMain.miCloseClick(Sender: TObject);
var
  CanDo: Integer;

begin
  if FileModified then begin
    CanDo := MsgBox('Close the selected file? Changes not saved will be LOST!', 'Warning',
      MB_OKCANCEL + MB_ICONWARNING + MB_DEFBUTTON2);
    if CanDo = IDCANCEL then Exit;
  end;
  
  RemoveSelectedFile;
end;

procedure TfrmMain.miDumpSectionClick(Sender: TObject);
var
  Target: TSectionsListEntry;

begin
  if lvSectionsList.Selected = nil then Exit;
  with sdDumpSection do begin
    Target := MTEditor.Sections[lvSectionsList.Selected.Index];
    FileName := MTEditor.SourceFileName + '_' + Target.Name;
    if Execute then begin
      Status := 'Dumping section...';

      Target.SaveToFile(FileName);

      ResetStatus;
      AddDebug('Section ' + Target.Name + ' successfully dumped from "'
        + SelectedFileEntry.ExtractedFileName + '" saved to "' + FileName + '".');
    end;
  end;
end;

procedure TfrmMain.miExportFilesListClick(Sender: TObject);
begin
  with sdExportList do begin
    FileName := ExtremeRight('\', Copy(SourceDirectory, 1, Length(SourceDirectory) - 1))
      + '_FilesList.txt';
    if Execute then
      lbFilesList.Items.SaveToFile(FileName);
  end;
end;

procedure TfrmMain.miLocateOnDiskClick(Sender: TObject);
var
  FName: string;

begin
  FName := MTEditor.SourceFileName;
  ShellExecute(Handle, 'open', 'explorer', PChar('/e,/select,' + FName), '', SW_SHOWNORMAL);
end;

procedure TfrmMain.miMakeBackupClick(Sender: TObject);
begin
  MakeBackup := not MakeBackup;
end;

procedure TfrmMain.miTexturesPreviewClick(Sender: TObject);
begin
  frmTexPreview.Show;
  UpdateTexturePreviewWindow;
end;

procedure TfrmMain.miTexturesPropertiesClick(Sender: TObject);
begin
  frmTexProp.Show;
  UpdateTexturePreviewWindow;
end;

procedure TfrmMain.miOpenFilesClick(Sender: TObject);
var
  i: Integer;
  FileLoaded, FileValid: Boolean;
  
begin
  if not SaveCurrentFileOnDemand(True) then Exit;

  FileValid := False;
  with odFileSelect do
    if Execute then begin
      Clear;

      // scanning every selected file
      for i := 0 to Files.Count - 1 do begin
        FileLoaded := MTEditor.LoadFromFile(Files[i]);
        if FileLoaded then begin
          FileValid := MTEditor.Textures.Count > 0;
          MTEditor.Close;

          // if the file opened is valid then add it to the software
          if FileValid then begin
            FilesList.Add(Files[i]);
            lbFilesList.Items.Add(ExtractFileName(Files[i]));
            eFilesCount.Text := IntToStr(FilesList.Count);
          end; // FileValid
        end; // FileLoaded

        if (not FileLoaded) or (not FileValid) then
          AddDebug('The "' + ExtractFileName(Files[i]) + '" isn''t an editable MT package.');            
      end; // for

      // loading the first item
      if lbFilesList.Items.Count > 0 then begin
        SourceDirectory := FilesList[0].ExtractedPath;
        lbFilesList.ItemIndex := 0;
        lbFilesListClick(Self);
      end else
        MsgBox('No editable MT package was selected.', 'Warning', MB_ICONWARNING);
    end; // if Execute
end;

procedure TfrmMain.miPropertiesClick(Sender: TObject);
begin
  if Assigned(SelectedFileEntry) then
    ShellOpenPropertiesDialog(SelectedFileEntry.FileName);
end;

procedure TfrmMain.miOpenDirectoryClick(Sender: TObject);
begin
  with frmSelectDir do begin
    if Execute(SourceDirectory) then begin
      SourceDirectory := GetSelectedDirectory;
      ScanDirectory(SourceDirectory);
    end;
  end;
end;

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miRefreshClick(Sender: TObject);
begin
  ScanDirectory(SourceDirectory);
end;

procedure TfrmMain.miReloadClick(Sender: TObject);
var
  CanDo: Integer;
  FName: TFileName;

begin
  if not Assigned(SelectedFileEntry) then Exit;

  FName := SelectedFileEntry.ExtractedFileName;
  CanDo := MsgBox(
    'Reload the "' + FName + '" file ? '
    + sLineBreak + 'Changes not saved will be LOST!',
    'Warning',
    MB_ICONWARNING + MB_YESNO + MB_DEFBUTTON2);
  if (CanDo = IDNO) then Exit;

  LoadFileEntry(SelectedFileEntry);
  AddDebug('File "' + SelectedFileEntry.ExtractedFileName + '" successfully reloaded from disk.');
end;

procedure TfrmMain.RemoveSelectedFile;
begin
  ClearFilesInfos;
  SelectedFileEntry.RemoveEntry;
  SelectedFileEntry := nil;
  lbFilesList.DeleteSelected;
end;

procedure TfrmMain.ResetStatus;
begin
  Status := 'Ready';
end;

procedure TfrmMain.miSaveAsClick(Sender: TObject);
const
  FILTER_ALL = 'Shenmue Models Files (*.???)|*.???|All Files (*.*)|*.*';

begin
  with sdSaveAs do begin

    Filter := StringReplace(FILTER_ALL, '???',
      SelectedFileEntry.ExtractedExtension, [rfReplaceAll]);
    DefaultExt := SelectedFileEntry.ExtractedExtension;

    if Execute then
      if MTEditor.SaveToFile(FileName) then
        AddDebug('Current editor state successfully saved to the file "' + FileName + '".')
      else
        AddDebug('Failed when saving the editor state to "' + FileName + '" !');

  end; // with
end;

procedure TfrmMain.miSaveClick(Sender: TObject);
begin
  Status := 'Saving...';
  if MTEditor.Save then begin
    AddDebug('File "' + ExtractFileName(MTEditor.SourceFileName) + '" successfully saved.');
    FileModified := False;
    LoadFileEntry(SelectedFileEntry);
  end else begin
    AddDebug('Error when saving the "' +  MTEditor.SourceFileName + ' file !');
  end;
  ResetStatus;
end;

procedure TfrmMain.miSaveDebugClick(Sender: TObject);
begin
  with sdSaveDebug do
    if Execute then
      mDebug.Lines.SaveToFile(FileName);
end;

function TfrmMain.SaveCurrentFileOnDemand(CancelButton: Boolean): Boolean;
var
  CanDo, MsgButtons, MsgIcon: Integer;

begin
  Result := True;
  
  if CancelButton then begin
    MsgButtons := MB_YESNOCANCEL;
    MsgIcon := MB_ICONWARNING;
  end else begin
    MsgButtons := MB_YESNO;
    MsgIcon := MB_ICONQUESTION;
  end;

  if FileModified then
    if AutoSave then
      miSave.Click  // no problem, we save the file
    else begin
      CanDo := MsgBox('The file was modified. Save changes ?', 'File modified not saved', MsgIcon + MsgButtons);
      case CanDo of
        IDYES:
          miSave.Click;
        IDCANCEL:
          Result := False;
      end;
    end;
end;

procedure TfrmMain.SetApplicationConfigParameters;
begin
  if not LoadConfig then begin
    AutoSave := False;
    SourceDirectory := GetApplicationDirectory;
    MakeBackup := True;
  end;
end;

procedure TfrmMain.SetAutoSave(const Value: Boolean);
begin
  fAutoSave := Value;
  miAutoSave.Checked := Value;
end;

procedure TfrmMain.SetFileModified(const Value: Boolean);
begin
  fFileModified := Value;
  if Value then
    sbMain.Panels[1].Text := 'Modified'
  else begin
    ClearImportedTexturesStatus;
    sbMain.Panels[1].Text := '';
  end;
  ChangeSingleFileSaveOperationsControlsState(Value);
end;

procedure TfrmMain.SetMakeBackup(const Value: Boolean);
begin
  fMakeBackup := Value;
  miMakeBackup.Checked := Value;
  MTEditor.MakeBackup := Value;
end;

procedure TfrmMain.SetSelectedFileEntry(const Value: TFileEntry);
begin
  fSelectedFileEntry := Value;
  ChangeSingleFileOperationsControlsState(Value <> nil);
end;

procedure TfrmMain.SetSourceDirectory(const Value: TFileName);
begin
  fSourceDirectory := Value;
  ChangeSelectedFolderOperationsControlsState(DirectoryExists(SourceDirectory));
end;

procedure TfrmMain.SetStatus(const Value: string);
begin
  sbMain.Panels[2].Text := Value;
  Application.ProcessMessages;
end;

function TfrmMain.UpdateTexturePreviewWindow: Boolean;
var
  PVRConverter: TPVRConverter;

begin
  Result := False;
  if lvTexturesList.ItemIndex = -1 then Exit;

  // Set the current item selected
  SelectedTexture := MTEditor.Textures[lvTexturesList.ItemIndex];
  SelectedTextureUI  := lvTexturesList.Items[lvTexturesList.ItemIndex];

  // Load the proper picture
  PVRConverter := SelectedTextureUI.Data;
  if not Assigned(PVRConverter) then Exit;

  // Refresh the window
  frmTexPreview.UpdateTexture(PVRConverter);
  frmTexProp.UpdateProperties(PVRConverter);

  Result := True;
end;

end.
