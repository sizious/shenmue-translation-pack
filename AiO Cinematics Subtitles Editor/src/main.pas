unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, ImgList, ToolWin, JvExComCtrls,
  JvToolBar, DebugLog, AppEvnts, BugsMgr, Viewer, JvListView, SRFEdit, ExtCtrls,
  FilesLst, JvBaseDlg, JvBrowseFolder;

type
  TfrmMain = class(TForm)
    mmMain: TMainMenu;
    miFile: TMenuItem;
    sbMain: TStatusBar;
    tbMain: TJvToolBar;
    ToolButton1: TToolButton;
    tbOpen: TToolButton;
    tbReload: TToolButton;
    tbSave: TToolButton;
    ToolButton4: TToolButton;
    tbDebugLog: TToolButton;
    tbAbout: TToolButton;
    ilToolBarDisabled: TImageList;
    ilToolBar: TImageList;
    tbPreview: TToolButton;
    ToolButton2: TToolButton;
    miOpenFiles: TMenuItem;
    miView: TMenuItem;
    miHelp: TMenuItem;
    miDEBUG: TMenuItem;
    miSave: TMenuItem;
    odOpen: TOpenDialog;
    sdSave: TSaveDialog;
    N1: TMenuItem;
    miQuit: TMenuItem;
    miDebugLog: TMenuItem;
    miSaveAs: TMenuItem;
    miReload: TMenuItem;
    miClose: TMenuItem;
    miPreview: TMenuItem;
    miAbout: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    aeMain: TApplicationEvents;
    miDEBUG_TEST2: TMenuItem;
    miCharset: TMenuItem;
    N6: TMenuItem;
    tbCharset: TToolButton;
    ProjectHome1: TMenuItem;
    N7: TMenuItem;
    Checkforupdate1: TMenuItem;
    GroupBox1: TGroupBox;
    gbFilesList: TGroupBox;
    lbFilesList: TListBox;
    lvSubs: TJvListView;
    lOldSub: TLabel;
    mOldSub: TMemo;
    lblText: TLabel;
    mNewSub: TMemo;
    Label3: TLabel;
    eFirstLineLength: TEdit;
    Label4: TLabel;
    eSecondLineLength: TEdit;
    Label8: TLabel;
    eSubCount: TEdit;
    miOpen: TMenuItem;
    Panel2: TPanel;
    Label9: TLabel;
    eFilesCount: TEdit;
    Label1: TLabel;
    eSelectedDirectory: TEdit;
    miCloseAll: TMenuItem;
    N5: TMenuItem;
    miImportSubtitles: TMenuItem;
    miExportSubtitles: TMenuItem;
    miTools: TMenuItem;
    miBatchImportSubtitles: TMenuItem;
    miBatchExportSubtitles: TMenuItem;
    sdExport: TSaveDialog;
    odImport: TOpenDialog;
    tbImportSubtitles: TToolButton;
    ToolButton5: TToolButton;
    tbExportSubtitles: TToolButton;
    tbBatchImportSubtitles: TToolButton;
    tbBatchExportSubtitles: TToolButton;
    ToolButton9: TToolButton;
    pmFilesList: TPopupMenu;
    miImportSubtitles2: TMenuItem;
    miExportSubtitles2: TMenuItem;
    miClose2: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    miAutoSave: TMenuItem;
    miMakeBackup: TMenuItem;
    bfdBatchExport: TJvBrowseForFolderDialog;
    tbAutoSave: TToolButton;
    ToolButton6: TToolButton;
    tbMakeBackup: TToolButton;
    N10: TMenuItem;
    miBrowseDirectory2: TMenuItem;
    miLocateOnDisk2: TMenuItem;
    N11: TMenuItem;
    miFileProperties2: TMenuItem;
    miCloseAll2: TMenuItem;
    miExportFilesList2: TMenuItem;
    miRefreshFilesList2: TMenuItem;
    miReload2: TMenuItem;
    N12: TMenuItem;
    miLocateOnDisk: TMenuItem;
    miBrowseDirectory: TMenuItem;
    miRefreshFilesList: TMenuItem;
    miExportFilesList: TMenuItem;
    miFileProperties: TMenuItem;
    N14: TMenuItem;
    sdExportFilesList: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure miOpenFilesClick(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure mNewSubChange(Sender: TObject);
    procedure miQuitClick(Sender: TObject);
    procedure miDebugLogClick(Sender: TObject);
    procedure miSaveAsClick(Sender: TObject);
    procedure aeMainException(Sender: TObject; E: Exception);
    procedure FormActivate(Sender: TObject);
    procedure aeMainHint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miCloseClick(Sender: TObject);
    procedure miReloadClick(Sender: TObject);
    procedure miDEBUG_TEST2Click(Sender: TObject);
    procedure miPreviewClick(Sender: TObject);
    procedure lvSubsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure miCharsetClick(Sender: TObject);
    procedure ProjectHome1Click(Sender: TObject);
    procedure Checkforupdate1Click(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lbFilesListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbFilesListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miCloseAllClick(Sender: TObject);
    procedure miImportSubtitlesClick(Sender: TObject);
    procedure miExportSubtitlesClick(Sender: TObject);
    procedure miBatchExportSubtitlesClick(Sender: TObject);
    procedure miAutoSaveClick(Sender: TObject);
    procedure miMakeBackupClick(Sender: TObject);
    procedure miBatchImportSubtitlesClick(Sender: TObject);
    procedure lbFilesListContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure miLocateOnDiskClick(Sender: TObject);
    procedure miBrowseDirectoryClick(Sender: TObject);
    procedure miFilePropertiesClick(Sender: TObject);
    procedure miRefreshFilesListClick(Sender: TObject);
    procedure miExportFilesListClick(Sender: TObject);
  private
    { Déclarations privées }  
    fSelectedSubtitleUI: TListItem;
    fSelectedSubtitle: TSRFSubtitlesListItem;
    fDebugLogVisible: Boolean;
    fFileModified: Boolean;
    fQuitOnFailure: Boolean;
    fPreviewerVisible: Boolean;
    fDecodeSubtitles: Boolean;
    fWorkingFilesList: TFilesList;
    fSelectedFileIndex: Integer;
    fBatchExportPreviousSelectedDirectory: TFileName;
    fAutoSave: Boolean;
    fMakeBackup: Boolean;
    fCharsetFileShenmue2: TFileName;
    fCharsetFileShenmue: TFileName;
    fCharsetCanEnableShenmue2: Boolean;
    fCharsetCanEnableShenmue: Boolean;
    procedure BugsHandlerExceptionCallBack(Sender: TObject;
      ExceptionMessage: string);
    procedure BugsHandlerSaveLogRequest(Sender: TObject);
    procedure BugsHandlerQuitRequest(Sender: TObject);
    procedure Clear(const UpdateOnlyUI: Boolean); overload;
    procedure Clear; overload;
    procedure DebugLogExceptionEvent(Sender: TObject; E: Exception);
    procedure DebugLogMainFormToFront(Sender: TObject);
    procedure DebugLogVisibilityChange(Sender: TObject; const Visible: Boolean);
    procedure DebugLogWindowActivated(Sender: TObject);
    procedure DirectoryScannerCompleted(Sender: TObject; Canceled: Boolean;
      ValidFiles, TotalFiles: Integer);
    procedure DirectoryScannerFileProceed(Sender: TObject; FileName: TFileName;
      Result: Boolean);
    procedure DirectoryScannerInitialize(Sender: TObject; MaxValue: Integer);
    procedure FilesListAdd(const FileName: TFileName);    
    procedure FilesListClear;
    procedure FilesListRemove(const ItemIndex: Integer);
    function GetSelectedDirectory: TFileName;
    function GetSelectedSubtitle: string;
    function GetStatusText: string;
    procedure InitBugsHandler;
    procedure InitDebugLog;
    procedure InitPreviewer;
    procedure LoadFile(FileName: TFileName);
    procedure LoadSelectedFile;
    procedure LoadShenmueCharset;
    procedure ModulesFree;
    procedure ModulesInit;    
    procedure PreviewerWindowClosed(Sender: TObject);
    function PromptImportConfirmation: Boolean;
    procedure RefreshSubtitleSelection;
    function SaveFileOnDemand(CancelButton: Boolean): Boolean;
    procedure SetAutoSave(const Value: Boolean);
    procedure SetControlsStateCharsetOperations(State: Boolean);
    procedure SetControlsStateCharsetOperationsChecked(Checked: Boolean);
    procedure SetControlsStateDirectoryOperations(State: Boolean);
    procedure SetControlsStateFileOperations(State: Boolean);
    procedure SetControlsStateSaveOperation(State: Boolean);
    procedure SetDebugLogVisible(const Value: Boolean);
    procedure SetDecodeSubtitles(const Value: Boolean);
    procedure SetFileModified(const Value: Boolean);
    procedure SetMakeBackup(const Value: Boolean);    
    procedure SetPreviewerVisible(const Value: Boolean);
    procedure SetSelectedSubtitle(const Value: string);
    procedure SetSelectedDirectory(const Value: TFileName);
    procedure SetStatusText(const Value: string);
    function GetSelectedFileName: TFileName;
    function GetSelectedFileEntry: TFileEntry;
    property CharsetCanEnableShenmue: Boolean read fCharsetCanEnableShenmue;
    property CharsetCanEnableShenmue2: Boolean read fCharsetCanEnableShenmue2;
    property CharsetFileShenmue: TFileName read fCharsetFileShenmue
      write fCharsetFileShenmue;
    property CharsetFileShenmue2: TFileName read fCharsetFileShenmue2
      write fCharsetFileShenmue2;
    property QuitOnFailure: Boolean read fQuitOnFailure write fQuitOnFailure;
  public
    { Déclarations publiques }
    function IsSubtitleSelected: Boolean;
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
    procedure ReloadFile;
    property AutoSave: Boolean read fAutoSave write SetAutoSave;
    property BatchPreviousSelectedDirectory: TFileName
      read fBatchExportPreviousSelectedDirectory
      write fBatchExportPreviousSelectedDirectory;    
    property DebugLogVisible: Boolean read fDebugLogVisible
      write SetDebugLogVisible;
    property DecodeSubtitles: Boolean read fDecodeSubtitles
      write SetDecodeSubtitles;
    property FileModified: Boolean read fFileModified write SetFileModified;
    property MakeBackup: Boolean read fMakeBackup write SetMakeBackup;
    property PreviewerVisible: Boolean read fPreviewerVisible
      write SetPreviewerVisible;
    property SelectedDirectory: TFileName read GetSelectedDirectory write
      SetSelectedDirectory;
    property SelectedFileEntry: TFileEntry read GetSelectedFileEntry;
    property SelectedFileName: TFileName read GetSelectedFileName;
    property SelectedFileIndex: Integer read fSelectedFileIndex
      write fSelectedFileIndex;
    property SelectedSubtitle: string read GetSelectedSubtitle
      write SetSelectedSubtitle;
    property StatusText: string read GetStatusText write SetStatusText;
    property WorkingFilesList: TFilesList read fWorkingFilesList
      write fWorkingFilesList;
  end;

var
  frmMain: TfrmMain;
  SRFEditor: TSRFEditor;
  Debug: TDebugLogHandlerInterface;
  BugsHandler: TBugsHandlerInterface;
  Previewer: TSubtitlesPreviewer;
  
//==============================================================================
implementation
//==============================================================================

{$R *.dfm}

uses
  Config, UITools, SysTools, ChrCount, About, DirScan, SubsExp, MassImp;

const
  SUBTITLES_COLUMN_INDEX = 1;

type
  TSRFDirectoryScanner = class(TDirectoryScanner)
  private
    fSRFEditorEngine: TSRFEditor;
    property SRFEditorEngine: TSRFEditor read fSRFEditorEngine
      write fSRFEditorEngine;
  protected
    function IsValidFile(const FileName: TFileName): Boolean; override;
  public
    constructor Create; overload;
    destructor Destroy; override;
  end;

var
  SRFDirectoryScanner: TSRFDirectoryScanner;
  BatchExporter: TBatchSubtitlesExporter;

//==============================================================================

procedure TfrmMain.Clear(const UpdateOnlyUI: Boolean);
begin
  if not UpdateOnlyUI then begin
    SRFEditor.Clear;
    lvSubs.Clear;
    fSelectedSubtitleUI := nil;
    fSelectedSubtitle := nil;
    mOldSub.Text := '';
    mNewSub.Text := '';
    UpdateSubtitleLengthControls('', eFirstLineLength, eSecondLineLength);
    eSubCount.Text := '0';
  end;

  FileModified := False;
  SetControlsStateFileOperations(False);
  SetControlsStateSaveOperation(False);

  StatusText := '';
end;

procedure TfrmMain.aeMainException(Sender: TObject; E: Exception);
begin
  BugsHandler.Execute(Sender, E);  
  aeMain.CancelDispatch;
end;

procedure TfrmMain.aeMainHint(Sender: TObject);
begin
  if (Application.Hint = '') or (Application.Hint <> SelectedDirectory) then
    StatusText := Application.Hint;
  aeMain.CancelDispatch;
end;

procedure TfrmMain.BugsHandlerExceptionCallBack(Sender: TObject;
  ExceptionMessage: string);
begin
  Debug.AddLine(ltCritical, ExceptionMessage);
end;

procedure TfrmMain.BugsHandlerQuitRequest(Sender: TObject);
begin
  QuitOnFailure := True;
  Close;
end;

procedure TfrmMain.BugsHandlerSaveLogRequest(Sender: TObject);
begin
  Debug.SaveLogFile;
end;

procedure TfrmMain.Checkforupdate1Click(Sender: TObject);
begin
  OpenLink('https://sourceforge.net/projects/shenmuesubs/files/');
end;

procedure TfrmMain.Clear;
begin
  Clear(False);
end;

procedure TfrmMain.DebugLogExceptionEvent(Sender: TObject; E: Exception);
begin
  BugsHandler.Execute(Sender, E);
end;

procedure TfrmMain.DebugLogMainFormToFront(Sender: TObject);
begin
  BringToFront;  
end;

procedure TfrmMain.DebugLogVisibilityChange(Sender: TObject;
  const Visible: Boolean);
begin
  fDebugLogVisible := Visible;
  miDebugLog.Checked := Visible;
  tbDebugLog.Down := Visible;  
end;

procedure TfrmMain.DebugLogWindowActivated(Sender: TObject);
begin
  StatusText := '';
end;

procedure TfrmMain.DirectoryScannerCompleted(Sender: TObject; Canceled: Boolean;
  ValidFiles, TotalFiles: Integer);
begin
  SetControlsStateDirectoryOperations(True);
  if Canceled then
    Debug.AddLine(ltInformation, 'Directory scanning canceled!')
  else begin
    Debug.AddLine(ltInformation, 'Directory scanning completed. ' +
      IntToStr(ValidFiles) + ' valid file(s) on ' + IntToStr(TotalFiles) +
      ' retrieved.');
  end;
  StatusText := '';
end;

procedure TfrmMain.DirectoryScannerFileProceed(Sender: TObject;
  FileName: TFileName; Result: Boolean);
begin
  if Result then begin
    FilesListAdd(FileName);
  end;
end;

procedure TfrmMain.DirectoryScannerInitialize(Sender: TObject;
  MaxValue: Integer);
begin
  Clear;
  FilesListClear;
  StatusText := 'Scanning directory... please wait.';

  SelectedDirectory := SRFDirectoryScanner.SourceDirectory;
  
  Debug.AddLine(ltInformation, 'Scanning directory "'
    + SelectedDirectory + '"...');
end;

procedure TfrmMain.miDEBUG_TEST2Click(Sender: TObject);
begin
{$IFDEF DEBUG}  raise Exception.Create('TEST EXCEPTION'); {$ENDIF}
end;

procedure TfrmMain.miExportFilesListClick(Sender: TObject);
begin
  with sdExportFilesList do begin
    FileName := ExtractDirectoryName(SelectedDirectory) + '_FilesList';
    if Execute then
      WorkingFilesList.SaveToFile(FileName);
  end;
end;

procedure TfrmMain.miExportSubtitlesClick(Sender: TObject);
var
  Buf: string;

begin
  if SaveFileOnDemand(True) then
    with sdExport do begin
      FileName := SelectedFileEntry.ExtractedFileName('');
      if Execute then begin
        Buf := ' subtitles from "' + SRFEditor.SourceFileName + '" to "'
          + FileName + '"';

        StatusText := 'Exporting...';
        if SRFEditor.Subtitles.ExportToFile(FileName) then
          Debug.AddLine(ltInformation, 'Successfully exported' + Buf + '.')
        else
          Debug.AddLine(ltWarning, 'Failed when exporting' + Buf + ' !');
        ReloadFile;
        StatusText := '';
      end;
    end;
end;

procedure TfrmMain.miFilePropertiesClick(Sender: TObject);
begin
  ShellOpenPropertiesDialog(SelectedFileName);
end;

procedure TfrmMain.miImportSubtitlesClick(Sender: TObject);
var
  Buf: string;

begin
  if PromptImportConfirmation then  
    with odImport do begin
      FileName := SelectedFileEntry.ExtractedFileName('');
      if Execute then begin
        Buf := ' subtitles from "' + FileName + '" into "'
          + SRFEditor.SourceFileName + '"';

        StatusText := 'Importing...';
        if SRFEditor.Subtitles.ImportFromFile(FileName) then begin
          SRFEditor.Save; // sauvegarde du fichier importé        
          Debug.AddLine(ltInformation, 'Successfully imported' + Buf + '.')
        end else
          Debug.Report(ltWarning, 'Import failed. The imported file is ' +
            'incorrect for the current entry !',
            'Import file structure mismatch when importing' + Buf + ' !');
        ReloadFile;
        StatusText := '';
      end;
    end;
end;

procedure TfrmMain.miLocateOnDiskClick(Sender: TObject);
begin
  if SelectedFileName <> '' then
    LocateFileOnDisk(SelectedFileName);
end;

procedure TfrmMain.miMakeBackupClick(Sender: TObject);
begin
  MakeBackup := not MakeBackup;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  aeMain.OnException := aeMainException;
  aeMain.Activate;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (not QuitOnFailure) and (not SaveFileOnDemand(True)) then begin
    Action := caNone;
    Exit;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
{$IFNDEF DEBUG}
  miDEBUG.Visible := False;
{$ENDIF}

  aeMain.OnException := nil;

  // Init UI
  Caption := Application.Title + ' v' + GetApplicationVersion;
  Application.Title := Caption;
  ToolBarInitControl(Self, tbMain);
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;

  // Init Menu Items
  CopyMenuItem(miImportSubtitles, miImportSubtitles2);
  CopyMenuItem(miExportSubtitles, miExportSubtitles2);
  CopyMenuItem(miClose, miClose2);
  CopyMenuItem(miBrowseDirectory, miBrowseDirectory2);
  CopyMenuItem(miLocateOnDisk, miLocateOnDisk2);
  CopyMenuItem(miReload, miReload2);
  CopyMenuItem(miExportFilesList, miExportFilesList2);
  CopyMenuItem(miRefreshFilesList, miRefreshFilesList2);
  CopyMenuItem(miFileProperties, miFileProperties2);
  CopyMenuItem(miCloseAll, miCloseAll2);
  
  // Init Modules
  ModulesInit;

  // Initialize the application
  Clear;
  SetControlsStateDirectoryOperations(False);

  SelectedDirectory := '';
  BatchPreviousSelectedDirectory := GetApplicationDirectory;
    
  // Load configuration
  LoadConfig;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Saving configuration
  SaveConfig;
  
  // Destroying application
  ModulesFree;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

procedure TfrmMain.ModulesFree;
begin
  // Disabling the Close button
  miQuit.Enabled := False;
  SetCloseWindowButtonState(Self, False);

  // Destroying the Batch Subtitles Exporter
  BatchExporter.Free;

  // Destroying the SRF Directory Scanner
  SRFDirectoryScanner.Free;

  // Destroying the Previewer
  Previewer.Free;

  // Destroying NBIK Sequence Editor
  SRFEditor.Free;

  // Destroying the Files List
  WorkingFilesList.Free;
  
  // Destroying Debug Log
  Debug.Free;

  // Cleaning Bugs Handler
  BugsHandler.Free;
end;

procedure TfrmMain.ModulesInit;

  function CheckCharsetExists(FileName: TFileName; Version: TSRFGameVersion): Boolean;
  begin
    Result := FileExists(FileName);
    if not Result then
      Debug.Report(ltWarning, 'Sorry, the ' + SRFGameVersionToString(Version)
        + ' Charset list wasn''t found! The '
        + 'Shenmue Decode subtitle function won''t be available.',
        'FileName: "' + FileName + '".');
  end;

begin
  // Init Bugs Handler
  InitBugsHandler;

  // Init Debug Log
  InitDebugLog;

  // Create the Files List
  fWorkingFilesList := TFilesList.Create;

  // Init NBIK Sequence Editor
  SRFEditor := TSRFEditor.Create;

  // Prepare Charset Functionality
  CharsetFileShenmue := GetApplicationDataDirectory + 'chrlist1.csv';
  fCharsetCanEnableShenmue := CheckCharsetExists(CharsetFileShenmue, sgvShenmue);
  CharsetFileShenmue2 := GetapplicationDataDirectory + 'chrlist2.csv';
  fCharsetCanEnableShenmue2 := CheckCharsetExists(CharsetFileShenmue2, sgvShenmue2);
  DecodeSubtitles := CharsetCanEnableShenmue or CharsetCanEnableShenmue2;

  // Init the Previewer
  InitPreviewer;

  // Init the About Box
  InitAboutBox(
    Application.Title,
    GetApplicationVersion,
    'SRF Editor'
  );

  // Init the SRF Directory Scanner Module
  FilesListClear;
  SRFDirectoryScanner := TSRFDirectoryScanner.Create;
  with SRFDirectoryScanner do begin
//    ProgressProperties.ShowDialog := False; {DEBUG}
    QueryProperties.MRUDirectoriesDatabase :=
      GetApplicationDirectory + 'dirscan.mru';
    OnCompleted := DirectoryScannerCompleted;
    OnInitialize := DirectoryScannerInitialize;
    OnFileProceed := DirectoryScannerFileProceed;
  end;

  // Creating the Batch Subtitles Exporter
  BatchExporter := TBatchSubtitlesExporter.Create;

  // Init Auto Save
  AutoSave := True;
end;

function TfrmMain.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmMain.PreviewerWindowClosed(Sender: TObject);
begin
  PreviewerVisible := False;
end;

procedure TfrmMain.ProjectHome1Click(Sender: TObject);
begin
  OpenLink('http://shenmuesubs.sourceforge.net/');
end;

function TfrmMain.PromptImportConfirmation: Boolean;
var
  CanDo: Integer;

begin
  Result := True;
  if FileModified then begin
    CanDo := MsgBox('Are you sure to import subtitles on a modified file ?'
      + WrapStr + 'Current modifications will be lost!', 'Warning',
      MB_ICONWARNING + MB_DEFBUTTON2 + MB_YESNO);
    Result := CanDo = IDYES;
  end;
end;

procedure TfrmMain.RefreshSubtitleSelection;
begin
  if IsSubtitleSelected then
    lvSubsSelectItem(Self, fSelectedSubtitleUI, True);
end;

procedure TfrmMain.ReloadFile;
begin
  if SRFEditor.Loaded then begin
    LoadFile(SelectedFileName);
    Debug.AddLine(ltInformation, 'Successfully reloaded the file "'
      + SRFEditor.SourceFileName + '".');
  end;
end;

procedure TfrmMain.FilesListAdd(const FileName: TFileName);
begin
  WorkingFilesList.Add(FileName);
  lbFilesList.Items.Add(ExtractFileName(FileName));
  eFilesCount.Text := IntToStr(WorkingFilesList.Count);
end;

procedure TfrmMain.FilesListClear;
begin
  SelectedFileIndex := -1;
  lbFilesList.Clear;
  WorkingFilesList.Clear;
  eFilesCount.Text := '0';
  SelectedDirectory := '';
end;

procedure TfrmMain.FilesListRemove(const ItemIndex: Integer);
begin
  if (ItemIndex >= 0) and (ItemIndex < WorkingFilesList.Count)  then begin
    // Delete from Files list
    WorkingFilesList[SelectedFileIndex].Remove;

    // Delete from UI
    lbFilesList.Items.Delete(SelectedFileIndex);
  end;
end;

function TfrmMain.GetSelectedDirectory: TFileName;
begin
  Result := eSelectedDirectory.Text;
end;

function TfrmMain.GetSelectedFileEntry: TFileEntry;
begin
  Result := nil;
  if SelectedFileIndex <> -1 then
    Result := WorkingFilesList[SelectedFileIndex];
end;

function TfrmMain.GetSelectedFileName: TFileName;
begin
  Result := '';
  if Assigned(SelectedFileEntry) then
    Result := SelectedFileEntry.FileName;
end;

function TfrmMain.GetSelectedSubtitle: string;
begin
  Result := '';
  if not IsSubtitleSelected then Exit;
  Result := fSelectedSubtitle.Text;
end;

function TfrmMain.GetStatusText: string;
begin
  Result := sbMain.Panels[2].Text;
end;

procedure TfrmMain.InitBugsHandler;
begin
  QuitOnFailure := False;
  BugsHandler := TBugsHandlerInterface.Create;
  try
    BugsHandler.OnExceptionCallBack := BugsHandlerExceptionCallBack;
    BugsHandler.OnSaveLogRequest := BugsHandlerSaveLogRequest;
    BugsHandler.OnQuitRequest := BugsHandlerQuitRequest;
  except
    on E: Exception do
      Debug.Report(ltWarning, 'Unable to initialize the Bugs Handler!',
        'Reason: "' + E.Message + '"');
  end;
end;

procedure TfrmMain.InitDebugLog;
begin
  Debug := TDebugLogHandlerInterface.Create;
  with Debug do begin
    // Setting up events
    OnException := DebugLogExceptionEvent;
    OnMainWindowBringToFront := DebugLogMainFormToFront;
    OnVisibilityChange := DebugLogVisibilityChange;
    OnWindowActivated := DebugLogWindowActivated;
  end;

  // Setting up the properties
  Debug.Configuration := Configuration; // in this order!
end;

procedure TfrmMain.InitPreviewer;
begin
  Previewer := TSubtitlesPreviewer.Create(GetApplicationDataDirectory + 'bmpfont');
  Previewer.OnWindowClosed := PreviewerWindowClosed;
end;

function TfrmMain.IsSubtitleSelected: Boolean;
begin
  Result := Assigned(fSelectedSubtitle);
end;

procedure TfrmMain.lbFilesListContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  // Enable right-click selection
  DoRightClickSelection;
end;

procedure TfrmMain.lbFilesListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  LoadSelectedFile;
end;

procedure TfrmMain.lbFilesListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  LoadSelectedFile;
end;

procedure TfrmMain.lvSubsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  Index: Integer;

begin
  if Selected then begin
    // Setting the variables to store the selected item
    fSelectedSubtitleUI := Item;
    Index := Integer(Item.Data);
    fSelectedSubtitle := SRFEditor.Subtitles[Index];

    // Refresh the view
    mOldSub.Text := SelectedSubtitle;
    mNewSub.Text := SelectedSubtitle;

    // Updating the Previewer if possible
    Previewer.Update(SelectedSubtitle);

    // Update the subtitle length count
    UpdateSubtitleLengthControls(SelectedSubtitle, eFirstLineLength, eSecondLineLength);
  end;
end;

procedure TfrmMain.LoadFile(FileName: TFileName);
var
  i, j: Integer;
  UpdateUI: Boolean;
  ListItem: TListItem;

begin
  // Extending filenames
  FileName := ExpandFileName(FileName);
  UpdateUI := SameText(FileName, SRFEditor.SourceFileName);

  // Checking the file
  if not FileExists(FileName) then begin
    Debug.Report(ltWarning, 'The file "' + FileName + '" doesn''t exists.',
      'FullFileName: ' + FileName);
    Exit;
  end;

  // Updating UI
  StatusText := 'Loading file...';
  Clear(UpdateUI);  

  // Loading the file
  if SRFEditor.LoadFromFile(FileName) then begin

    // Load Charset
    LoadShenmueCharset;

    // Filling the UI with the content
    if SRFEditor.Loaded then begin

      // Display the subtitles count
      eSubCount.Text := IntToStr(SRFEditor.Subtitles.Count);

      // Adding entries
      for i := 0 to SRFEditor.Subtitles.Count - 1 do begin
        ListItem := nil;

        // Checking if we must update the current view...
        if UpdateUI then
          ListItem := lvSubs.FindData(0, Pointer(i), True, False); // finding the correct index

        (*  If we ListItem = nil, it says that we don't have found the correct
            Item index, or we opened a new file. So we'll create a new item
            and prepare it to be updated. *)
        if not Assigned(ListItem) then begin
          ListItem := lvSubs.Items.Add;
          ListItem.Caption := '';
          j := 0;
          repeat
            ListItem.SubItems.Add('');
            Inc(j);
          until j = 2;
        end;

        // Updating the current item with the new values
        with ListItem do
          with SRFEditor.Subtitles[i] do begin
            Data := Pointer(i);
            Caption := IntToStr(i);
            SubItems[0] := CharID;
            SubItems[SUBTITLES_COLUMN_INDEX] := BR(SRFEditor.Subtitles[i].Text);
          end;
      end;                   

      // Updating UI
      if not UpdateUI then begin
        Debug.AddLine(ltInformation, 'Load successfully done for "'
          + SRFEditor.SourceFileName + '".');
      end;
      SetControlsStateFileOperations(True);

      // Refreshing the view
      RefreshSubtitleSelection;

    end else begin
      StatusText := 'Nothing to edit !';
      Debug.Report(ltInformation, 'This file is valid, but nothing to edit !',
        'FileName: ' + FileName);
    end;

  end else
    Debug.Report(ltWarning, 'This file isn''t a supported NBIK sequence MAPINFO.BIN file.',
      'FileName: ' + FileName);

  StatusText := '';
end;

procedure TfrmMain.LoadSelectedFile;
var
  i: Integer;

begin
  i := lbFilesList.ItemIndex;
  if (i <> -1) and (SelectedFileIndex <> i) then begin
    SelectedFileIndex := i;  
    Sleep(10);
    Application.ProcessMessages;
    SaveFileOnDemand(False);
    LoadFile(SelectedFileName);
  end;
end;

procedure TfrmMain.LoadShenmueCharset;
var
  CharsetFile: TFileName;
  CharsetCanEnable: Boolean;

begin
  CharsetCanEnable := False;
  CharsetFile := '';
  
  // Determine the right charset to use
  case SRFEditor.GameVersion of
    sgvShenmue:
      begin
        CharsetFile := CharsetFileShenmue;
        CharsetCanEnable := CharsetCanEnableShenmue;
      end;
    sgvShenmue2:
      begin
        CharsetFile := CharsetFileShenmue2;
        CharsetCanEnable := CharsetCanEnableShenmue2;
      end;
  end;

  // Change the buttons state
  SetControlsStateCharsetOperations(CharsetCanEnable);

  // Apply the charset
  if CharsetCanEnable then
    SRFEditor.Charset.LoadFromFile(CharsetFile)
end;

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
  RunAboutBox;
end;

procedure TfrmMain.miAutoSaveClick(Sender: TObject);
begin
  AutoSave := not AutoSave;
end;

procedure TfrmMain.miBatchExportSubtitlesClick(Sender: TObject);
begin
  if SaveFileOnDemand(True) then
    with bfdBatchExport do begin
      Directory := BatchPreviousSelectedDirectory;
      if Execute then begin
        BatchPreviousSelectedDirectory := Directory;
        BatchExporter.Execute(Directory);
      end;
    end;
end;

procedure TfrmMain.miBatchImportSubtitlesClick(Sender: TObject);
var
  MassImport: TfrmMassImport;

begin
  if PromptImportConfirmation then begin
    MassImport := TfrmMassImport.Create(Application);
    with MassImport do
      try
        SourceDirectory := BatchPreviousSelectedDirectory;
        ShowModal;
      finally
        Free;
      end;
  end;
end;

procedure TfrmMain.miBrowseDirectoryClick(Sender: TObject);
begin
  OpenWindowsExplorer(SelectedDirectory);
end;

procedure TfrmMain.miCharsetClick(Sender: TObject);
begin
  DecodeSubtitles := not DecodeSubtitles;
end;

procedure TfrmMain.miCloseAllClick(Sender: TObject);
begin
  if SaveFileOnDemand(True) then begin
    Clear;
    FilesListClear;
    Debug.AddLine(ltInformation, 'All files were closed.');
    SetControlsStateDirectoryOperations(False);
  end;
end;

procedure TfrmMain.miCloseClick(Sender: TObject);
begin
  if not SaveFileOnDemand(True) then Exit;
  Clear;
  Debug.AddLine(ltInformation, 'File "' + SelectedFileName
    + '" successfully closed.');
  FilesListRemove(SelectedFileIndex);
  SelectedFileIndex := -1;
end;

procedure TfrmMain.miDebugLogClick(Sender: TObject);
begin
  DebugLogVisible := not DebugLogVisible;
end;

procedure TfrmMain.miOpenClick(Sender: TObject);
begin
  if SaveFileOnDemand(False) then  
    SRFDirectoryScanner.Execute(True);
end;

procedure TfrmMain.miOpenFilesClick(Sender: TObject);
var
  i: Integer;
  Dir: TFileName;

begin
  if SaveFileOnDemand(False) then
    with odOpen do
      if Execute then begin
        Clear;
        FilesListClear;
        Dir := '';
        for i := 0 to Files.Count - 1 do
          FilesListAdd(Files[i]);
        if WorkingFilesList.Count > 0 then begin
          SelectedDirectory := WorkingFilesList[0].ExtractedPath;
          SetControlsStateDirectoryOperations(True);
          Debug.AddLine(ltInformation, 'Files sucessfully opened from the directory.');
        end;
      end;
end;

procedure TfrmMain.miPreviewClick(Sender: TObject);
begin
  PreviewerVisible := not PreviewerVisible;
end;

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miRefreshFilesListClick(Sender: TObject);
begin
  if DirectoryExists(SelectedDirectory) then begin
    SRFDirectoryScanner.SourceDirectory := SelectedDirectory;
    SRFDirectoryScanner.Execute;
  end;
end;

procedure TfrmMain.miReloadClick(Sender: TObject);
begin
  if not SaveFileOnDemand(True) then Exit;
  ReloadFile;
end;

procedure TfrmMain.miSaveAsClick(Sender: TObject);
var
  Buf: string;
  ReloadFromDisk: Boolean;

begin
  with sdSave do begin
    FileName := ExtractFileName(SRFEditor.SourceFileName);
    Buf := ExtractFileExt(SRFEditor.SourceFileName);
    DefaultExt := Copy(Buf, 2, Length(Buf) - 1);

    // Executing dialog
    if Execute then begin
      StatusText := 'Saving file...';
      ReloadFromDisk := FileName = SRFEditor.SourceFileName;

      // Saving on the disk
      Buf := ' for "' + SRFEditor.SourceFileName + '" to "' + FileName + '".';
      if SRFEditor.SaveToFile(FileName) then
        Debug.AddLine(ltInformation, 'Save successfully done' + Buf)
      else
        Debug.Report(ltWarning, 'Unable to do the save !', 'Unable to save' + Buf);

      // Reloading the view if needed
      if ReloadFromDisk then
        LoadFile(SRFEditor.SourceFileName);
      StatusText := '';
    end;
  end;
end;

procedure TfrmMain.miSaveClick(Sender: TObject);
begin
  StatusText := 'Saving file...';
  if SRFEditor.Save then
    Debug.AddLine(ltInformation, Format('Save successfully done on the ' +
      'disk for "%s".', [SelectedFileName])
    )
  else
    Debug.Report(ltWarning, 'Unable to save the file on the disk!',
      Format('Unable to save on disk for "%s".', [SelectedFileName])
    );
  LoadFile(SelectedFileName);
end;

procedure TfrmMain.mNewSubChange(Sender: TObject);
begin
  if SelectedSubtitle <> mNewSub.Text then begin  
    // Update the subtitle
    SelectedSubtitle := mNewSub.Text;

    // Update the modified state
    FileModified := True;

    // Update Previewer
    Previewer.Update(SelectedSubtitle);

    // Update the subtitle length count
    UpdateSubtitleLengthControls(SelectedSubtitle, eFirstLineLength, eSecondLineLength);
  end;
end;

function TfrmMain.SaveFileOnDemand(CancelButton: Boolean): Boolean;
var
  CanDo: Integer;
  MsgBtns: Integer;
  MustSave: Boolean;

begin
  Result := True;
  if not FileModified then Exit;
  
  Result := False;
  MustSave := True;
  
  if not AutoSave then begin
    // If not AutoSave, then check if we must save or not
    MsgBtns := MB_YESNO;
    if CancelButton then
      MsgBtns := MB_YESNOCANCEL;

    CanDo := MsgBox('The file was modified. Save changes?', 'Warning',
      MB_ICONWARNING + MsgBtns);
    if CanDo = IDCANCEL then Exit;
    MustSave := (CanDo = IDYES);
  end; // AutoSave

  // We save the file
  if MustSave then
    miSave.Click;

  Result := True;
end;

procedure TfrmMain.SetAutoSave(const Value: Boolean);
begin
  fAutoSave := Value;
  tbAutoSave.Down := Value;
  miAutoSave.Checked := Value;
end;

procedure TfrmMain.SetControlsStateCharsetOperations(State: Boolean);
begin
  tbCharset.Enabled := State;
  miCharset.Enabled := tbCharset.Enabled;
  SetControlsStateCharsetOperationsChecked(State and DecodeSubtitles);
  SRFEditor.Subtitles.DecodeText := State and DecodeSubtitles;
end;

procedure TfrmMain.SetControlsStateCharsetOperationsChecked(Checked: Boolean);
begin
  tbCharset.Down := Checked;
  miCharset.Checked := Checked;
end;

procedure TfrmMain.SetControlsStateDirectoryOperations(State: Boolean);
var
  CanEnable: Boolean;

begin
  CanEnable := State and (WorkingFilesList.Count > 0);
  miCloseAll.Enabled := CanEnable;
  miCloseAll2.Enabled := CanEnable;
  miBatchImportSubtitles.Enabled := CanEnable;
  tbBatchImportSubtitles.Enabled := CanEnable;
  miBatchExportSubtitles.Enabled := CanEnable;
  tbBatchExportSubtitles.Enabled := CanEnable;
  miBrowseDirectory.Enabled := State;
  miBrowseDirectory2.Enabled := State;
  miExportFilesList.Enabled := CanEnable;
  miExportFilesList2.Enabled := CanEnable;
end;

procedure TfrmMain.SetControlsStateFileOperations(State: Boolean);
begin
  miClose.Enabled := State;
  miClose2.Enabled := State;
  miImportSubtitles.Enabled := State;
  miImportSubtitles2.Enabled := State;
  tbImportSubtitles.Enabled := State;
  miExportSubtitles.Enabled := State;
  miExportSubtitles2.Enabled := State;
  tbExportSubtitles.Enabled := State;
  miReload.Enabled := State;
  tbReload.Enabled := State;
  miReload2.Enabled := State;  
  miLocateOnDisk.Enabled := State;
  miLocateOnDisk2.Enabled := State;
  miFileProperties.Enabled := State;
  miFileProperties2.Enabled := State;
end;

procedure TfrmMain.SetControlsStateSaveOperation(State: Boolean);
begin
  tbSave.Enabled := State;
  miSave.Enabled := State;
  miSaveAs.Enabled := State;
end;

procedure TfrmMain.SetDebugLogVisible(const Value: Boolean);
begin
  Debug.Active := Value;
end;

procedure TfrmMain.SetDecodeSubtitles(const Value: Boolean);
var
  i: Integer;
  ListItem: TListItem;

begin
  fDecodeSubtitles := Value;

  // Update the GUI options controls
  SetControlsStateCharsetOperationsChecked(DecodeSubtitles);

  // Update the SRF Editor
  SRFEditor.Subtitles.DecodeText := DecodeSubtitles;

  // Update the GUI
  if SRFEditor.Loaded then begin

    // ListView
    for i := 0 to lvSubs.Items.Count - 1 do begin
      ListItem := lvSubs.FindData(0, Pointer(i), True, False);
      if Assigned(ListItem) then begin
        ListItem.SubItems[SUBTITLES_COLUMN_INDEX] := BR(SRFEditor.Subtitles[i].Text);
      end;
    end;

    // Memos
    mOldSub.Text := SRFEditor.Subtitles.TransformText(mOldSub.Text);
    mNewSub.Text := SRFEditor.Subtitles.TransformText(mNewSub.Text);

  end;
end;

procedure TfrmMain.SetFileModified(const Value: Boolean);
begin
  fFileModified := Value;
  if Value then
    sbMain.Panels[1].Text := 'Modified'
  else
    sbMain.Panels[1].Text := '';
  SetControlsStateSaveOperation(fFileModified);
end;

procedure TfrmMain.SetMakeBackup(const Value: Boolean);
begin
  fMakeBackup := Value;
  miMakeBackup.Checked := Value;
  tbMakeBackup.Down := Value;
  SRFEditor.MakeBackup := Value;
end;

procedure TfrmMain.SetPreviewerVisible(const Value: Boolean);
begin
  fPreviewerVisible := Value;
  miPreview.Checked := fPreviewerVisible;
  tbPreview.Down := fPreviewerVisible;

  // Change the previewer state
  if fPreviewerVisible then
    Previewer.Show(SelectedSubtitle)
  else
    Previewer.Hide;
end;

procedure TfrmMain.SetSelectedDirectory(const Value: TFileName);
var
  DirExists: Boolean;

begin
  DirExists := DirectoryExists(Value);
  miRefreshFilesList.Enabled := DirExists;
  miRefreshFilesList2.Enabled := DirExists;
  with eSelectedDirectory do begin
    Text := Value;
    Hint := Value;
  end;
end;

procedure TfrmMain.SetSelectedSubtitle(const Value: string);
begin
  if IsSubtitleSelected then begin
    fSelectedSubtitleUI.SubItems[SUBTITLES_COLUMN_INDEX] := BR(Value);
    fSelectedSubtitle.Text := Value;
  end;
end;

procedure TfrmMain.SetStatusText(const Value: string);
begin
  if Value = '' then
    sbMain.Panels[2].Text := 'Ready'
  else
    sbMain.Panels[2].Text := Value;
  Application.ProcessMessages;
end;

procedure TfrmMain.tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
  var DefaultDraw: Boolean);
begin
  ToolBarCustomDraw(Sender);
end;

//==============================================================================
// TSRFDirectoryScanner
//==============================================================================

constructor TSRFDirectoryScanner.Create;
begin
  inherited Create;
  fSRFEditorEngine := TSRFEditor.Create;
end;

destructor TSRFDirectoryScanner.Destroy;
begin
  SRFEditorEngine.Free;
  inherited Destroy;
end;

function TSRFDirectoryScanner.IsValidFile(const FileName: TFileName): Boolean;
begin
  Result := SRFEditorEngine.LoadFromFile(FileName);
end;

end.
