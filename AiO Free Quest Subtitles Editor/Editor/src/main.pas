//    This file is part of Shenmue AiO Free Quest Subtitles Editor.
//
//    Shenmue AiO Free Quest Subtitles Editor is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Shenmue AiO Free Quest Subtitles Editor is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue AiO Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit main;

// Uncomment this if you want to debug the Global-Translation selection node
// {$DEFINE GLOBAL_TRANSLATION_NODE_DEBUG}

// Uncomment this if you want to release a BETA build
// {$DEFINE DEBUG_BUILD_RELEASE}

{ Uncomment this to disable the old Multi-Translation and enable the new
  powerful (and unfinished) Multi-Translation function }
{$DEFINE OLD_MULTI_TRANSLATION_STYLE}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Menus, SCNFEdit, SCNFUtil, MultiScan, ExtCtrls, ScnfScan,
  MultiTrad, JvExExtCtrls, JvExComCtrls, JvListView, Clipbrd, ShellApi,
  AppEvnts, FilesLst, SubsExp, JvBaseDlg, JvBrowseFolder, Viewer_Intf, TextData,
  ImgList, ViewUpd, Progress, TextDB;

const
{$IFDEF DEBUG}
  DEBUG_VERSION = 'a';
{$ENDIF}

  APP_VERSION =
    '2.4.1' {$IFDEF DEBUG} {$IFDEF DEBUG_BUILD_RELEASE} + DEBUG_VERSION + ' [DEBUG BUILD]' {$ENDIF} {$ENDIF};

  COMPIL_DATE_TIME = 'February 13, 2010 @03:04PM';

type
  TGlobalTranslationModule = class;
  TMultiTranslationModule = class;
  
  TfrmMain = class(TForm)
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miOpenSingleFile: TMenuItem;
    miScanDirectory: TMenuItem;
    N1: TMenuItem;
    miQuit: TMenuItem;
    miTools: TMenuItem;
    miHelp: TMenuItem;
    miAbout: TMenuItem;
    N2: TMenuItem;
    miClearFilesList: TMenuItem;
    miSave: TMenuItem;
    miSaveAs: TMenuItem;
    N3: TMenuItem;
    miExportSubs: TMenuItem;
    N4: TMenuItem;
    miImportSubs: TMenuItem;
    miAutoSave: TMenuItem;
    N5: TMenuItem;
    miMakeBackup: TMenuItem;
    N6: TMenuItem;
    miClearDebugLog: TMenuItem;
    miSaveDebugLog: TMenuItem;
    miCloseFile: TMenuItem;
    odMain: TOpenDialog;
    sdMain: TSaveDialog;
    miEnableCharsMod: TMenuItem;
    gbFilesList: TGroupBox;
    lbFilesList: TListBox;
    pcSubs: TPageControl;
    tsEditor: TTabSheet;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    eSecondLineLength: TEdit;
    eFirstLineLength: TEdit;
    mSubText: TMemo;
    eSubCount: TEdit;
    eCharID: TEdit;
    tsMultiTrad: TTabSheet;
    GroupBox2: TGroupBox;
    GroupBox4: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    eMTFirstLineLength: TEdit;
    eMTSecondLineLength: TEdit;
    bMTRetrieveSubs: TButton;
    Panel2: TPanel;
    Label9: TLabel;
    eFilesCount: TEdit;
    gbDebug: TGroupBox;
    mDebug: TMemo;
    sb: TStatusBar;
    pmSubsSelect: TPopupMenu;
    miCopySub: TMenuItem;
    N8: TMenuItem;
    miSaveListToFile: TMenuItem;
    miSubsPreview: TMenuItem;
    sdSubsList: TSaveDialog;
    lvSubsSelect: TJvListView;
    N9: TMenuItem;
    miExportSubs2: TMenuItem;
    miImportSubs2: TMenuItem;
    pmFilesList: TPopupMenu;
    miFileProperties: TMenuItem;
    miBrowseDirectory: TMenuItem;
    miLocateFile: TMenuItem;
    N10: TMenuItem;
    miFileProperties2: TMenuItem;
    N11: TMenuItem;
    miBatchImportSubs: TMenuItem;
    miBatchExportSubs: TMenuItem;
    N13: TMenuItem;
    miReloadDir: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    bfdExportSubs: TJvBrowseForFolderDialog;
    mOldSubEd: TMemo;
    lOldText: TLabel;
    lGender: TLabel;
    rbMale: TRadioButton;
    rbFemale: TRadioButton;
    Panel1: TPanel;
    iFace: TImage;
    Panel4: TPanel;
    lCharType: TLabel;
    rbAdult: TRadioButton;
    rbChild: TRadioButton;
    Label7: TLabel;
    eVoiceID: TEdit;
    eGame: TEdit;
    Label5: TLabel;
    miProjectHome: TMenuItem;
    N14: TMenuItem;
    rbatUnknow: TRadioButton;
    rbcgUnknow: TRadioButton;
    miView: TMenuItem;
    N15: TMenuItem;
    miExportFilesList: TMenuItem;
    mMTOldSub: TMemo;
    mMTNewSub: TMemo;
    bMultiTranslate: TButton;
    bMTClear: TButton;
    tvMultiSubs: TTreeView;
    bMTExpandAll: TButton;
    bMTCollapseAll: TButton;
    ilMultiSubs: TImageList;
    pmMultiSubs: TPopupMenu;
    miGoTo: TMenuItem;
    miReloadCurrentFile: TMenuItem;
    N7: TMenuItem;
    miImportSubs3: TMenuItem;
    miExportSubs3: TMenuItem;
    miReloadCurrentFile2: TMenuItem;
    miCloseFile2: TMenuItem;
    miReloadDir2: TMenuItem;
    N12: TMenuItem;
    N16: TMenuItem;
    miFacesExtractor: TMenuItem;
    miClearFilesList2: TMenuItem;
    miCheckForUpdate: TMenuItem;
    miMultiTranslate: TMenuItem;
    miDEBUG: TMenuItem;
    miDumpMultiTranslationTextData: TMenuItem;
    DumpMultiTranslationCacheList1: TMenuItem;
    miOptions: TMenuItem;
    miReloadDirAtStartup: TMenuItem;
    InitTextDatabase1: TMenuItem;
    N17: TMenuItem;
    TextDatabaseCorrector1: TMenuItem;
    miShowOriginalText: TMenuItem;
    miBrowseDirectory2: TMenuItem;
    N18: TMenuItem;
    GenerateTestException1: TMenuItem;
    procedure miScanDirectoryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbFilesListClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mSubTextChange(Sender: TObject);
    procedure miQuitClick(Sender: TObject);
    procedure miMakeBackupClick(Sender: TObject);
    procedure miSaveAsClick(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure miClearFilesListClick(Sender: TObject);
    procedure miOpenSingleFileClick(Sender: TObject);
    procedure miClearDebugLogClick(Sender: TObject);
    procedure miSaveDebugLogClick(Sender: TObject);
    procedure miAutoSaveClick(Sender: TObject);
    procedure miExportSubsClick(Sender: TObject);
    procedure miCloseFileClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miImportSubsClick(Sender: TObject);
    procedure miEnableCharsModClick(Sender: TObject);
    procedure bMTRetrieveSubsClick(Sender: TObject);
    procedure bMultiTranslateClick(Sender: TObject);
    procedure miCopySubClick(Sender: TObject);
    procedure miSaveListToFileClick(Sender: TObject);
    procedure miSubsPreviewClick(Sender: TObject);
    procedure lvSubsSelectClick(Sender: TObject);
    procedure lvSubsSelectKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miFilePropertiesClick(Sender: TObject);
    procedure lbFilesListContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbFilesListDblClick(Sender: TObject);
    procedure miLocateFileClick(Sender: TObject);
    procedure miBrowseDirectoryClick(Sender: TObject);
    procedure miFileProperties2Click(Sender: TObject);
    procedure miBatchExportSubsClick(Sender: TObject);
    procedure miReloadDirClick(Sender: TObject);
    procedure miBatchImportSubsClick(Sender: TObject);
    procedure lbFilesListKeyPress(Sender: TObject; var Key: Char);
    procedure miProjectHomeClick(Sender: TObject);
    procedure miExportFilesListClick(Sender: TObject);
    procedure bMTClearClick(Sender: TObject);
    procedure tvMultiSubsClick(Sender: TObject);
    procedure tvMultiSubsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bMTExpandAllClick(Sender: TObject);
    procedure bMTCollapseAllClick(Sender: TObject);
    procedure tvMultiSubsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure miGoToClick(Sender: TObject);
    procedure mMTNewSubChange(Sender: TObject);
    procedure pcSubsChange(Sender: TObject);
    procedure miReloadCurrentFileClick(Sender: TObject);
    procedure miFacesExtractorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ApplicationEventsHint(Sender: TObject);
    procedure miCheckForUpdateClick(Sender: TObject);
    procedure miMultiTranslateClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure miDumpMultiTranslationTextDataClick(Sender: TObject);
    procedure DumpMultiTranslationCacheList1Click(Sender: TObject);
    procedure miReloadDirAtStartupClick(Sender: TObject);
    procedure InitTextDatabase1Click(Sender: TObject);
    procedure TextDatabaseCorrector1Click(Sender: TObject);
    procedure miShowOriginalTextClick(Sender: TObject);
    procedure GenerateTestException1Click(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
  private
    { Déclarations privées }
//    fPrevMessage: string;
    fGlobalTranslation: TGlobalTranslationModule;
    fTargetFileName: TFileName;
    fSelectedDirectory: string;
    fFileModified: Boolean;
    fAutoSave: Boolean;
    fMakeBackup: Boolean;
    fSubsViewerVisible: Boolean;
    fEnableCharsMod: Boolean;
//    fWorkFilesList: TFilesList;
    fFileListSelectedIndex: Integer;
    fSubtitleSelected: Integer;
    fCanEnableCharsMod1: Boolean;
    fCanEnableCharsMod2: Boolean;
    fMultiTranslation: TMultiTranslationModule;
    fReloadDirectoryAtStartup: Boolean;
    fPreviousLoadedGameVersion: TGameVersion;
    fOldSelectedSubtitleText: string;
    fOriginalSelectedSubtitleText: string;
    fEnableOriginalSubtitlesView: Boolean;
//    fWrapStr: string;
    procedure SetFileOperationMenusItemEnabledState(const State: Boolean);
    procedure SetAutoSave(const Value: Boolean);
    procedure SetMakeBackup(const Value: Boolean);
    procedure ResetApplication;
    procedure SetFileSaveOperationsMenusItemEnabledState(const State: Boolean);
    procedure SaveSubtitlesList(const FileName: TFileName);
    procedure RefreshSubtitlesList(UpdateView: Boolean);
    procedure BatchExportSubtitles(const OutputDirectory: TFileName);
    procedure SetEnableCharsMod(const Value: Boolean);
    procedure SetReloadDirectoryAtStartup(const Value: Boolean);
    procedure SetEnableOriginalSubtitlesView(const Value: Boolean);
  protected
    procedure CheckIfSubLengthIsCorrect(const Value: Integer; Field: TEdit);
    procedure FreeApplication;
    procedure InitApplicationReleaseType;
    procedure PreviewWindowClosedEvent(Sender: TObject);
    procedure SetModifiedIndicator(State: Boolean);
    procedure SetApplicationHint(const HintStr: string);
    procedure UpdateOldSubtitleField;
  public
    { Déclarations publiques }
    procedure AddDebug(m: string);
    procedure Clear;
    function GetTargetDirectory: string;
    function GetTargetFileName: TFileName;
    function MsgBox(const Text, Caption: string; Flags: Integer): Integer;
    procedure LoadSubtitleFile(const FileName: TFileName);
    procedure ReloadFileEditor;
    function SaveFileIfNeeded(const CancelButton: Boolean): Boolean;
    procedure ScanDirectory(const Directory: string);
    procedure SetStatus(const Text: string);
    procedure SetStatusReady; // SetStatus('Ready')
    procedure SetModified(const State: Boolean);
    procedure UpdateDirectoryControlsState;    
    procedure UpdateSubtitleLengthControls(SubtitleText: string; FirstLengthEditControl,
      SecondLengthEditControl: TEdit);

    // Procedures used in Multi-Translation / Global-Translation process
    procedure RetrieveSubtitles(TextDataList: TMultiTranslationTextData;
      ProgressFormMode: TProgressMode; RefreshRequest: Boolean);

    // Application State
    property FileModified: Boolean read fFileModified;
    property FileListSelectedIndex: Integer read fFileListSelectedIndex;

    // Options
    property AutoSave: Boolean read fAutoSave write SetAutoSave;
    property MakeBackup: Boolean read fMakeBackup write SetMakeBackup;
    property ReloadDirectoryAtStartup: Boolean read fReloadDirectoryAtStartup
      write SetReloadDirectoryAtStartup;

    { Implements the Global-Translation module }
    property GlobalTranslation: TGlobalTranslationModule read fGlobalTranslation
      write fGlobalTranslation;

    property SubsViewerVisible: Boolean read fSubsViewerVisible write fSubsViewerVisible;
    property SelectedDirectory: string read fSelectedDirectory write fSelectedDirectory;

    // Subtitle selected in the editor
    property SubtitleSelected: Integer read fSubtitleSelected write fSubtitleSelected;

    // For Chars Modification Translation (the charset used by the game isn't exactly the same as Windows)
    // For Shenmue 1:
    property CanEnableCharsMod1: Boolean read fCanEnableCharsMod1 write fCanEnableCharsMod1;
    // For Shenmue 2:
    property CanEnableCharsMod2: Boolean read fCanEnableCharsMod2 write fCanEnableCharsMod2;
    // If we must use this feature in the editor or not:
    property EnableCharsMod: Boolean read fEnableCharsMod write SetEnableCharsMod;

    property MultiTranslation: TMultiTranslationModule read fMultiTranslation
      write fMultiTranslation;
//    property WorkFilesList: TFilesList read fWorkFilesList write fWorkFilesList;

    // Properties for Text Correction DataBase (Original text from the game)
    property PreviousLoadedGameVersion: TGameVersion
      read fPreviousLoadedGameVersion write fPreviousLoadedGameVersion;
    property OriginalSelectedSubtitleText: string
      read fOriginalSelectedSubtitleText write fOriginalSelectedSubtitleText; // ORIGINAL text from AM2 developers
    property OldSelectedSubtitleText: string
      read fOldSelectedSubtitleText write fOldSelectedSubtitleText; // PREVIOUS text from the user (the translator)...
    property EnableOriginalSubtitlesView: Boolean
      read fEnableOriginalSubtitlesView write SetEnableOriginalSubtitlesView;      
  end;

  // This class implements the Multi-Translation function.
  TCurrentFileMultiTranslationModule = class(TObject)
  private
    fCacheIndexList: TList;
    fOwner: TMultiTranslationModule;
    function GetSubtitleInfo(Index: Integer): TSubtitlesInfoList;
    function GetSubtitleInfoCount: Integer;
    function GetCacheListItem(Index: Integer): Integer;
    procedure SetCacheListItem(Index: Integer; const Value: Integer);
  public
    constructor Create(AOwner: TMultiTranslationModule);
    destructor Destroy; override;

    { Build the cache index list used to know where subtitles info for the
    current file are located in the TextDataList. }
    procedure BuildCache;

    procedure UpdateLinkedSubtitles(SubtitleSelected: Integer;
      NewSubtitleValue: string);

{$IFDEF DEBUG}
    procedure DumpCacheList(const FileName: TFileName);
{$ENDIF}

    // Cache List items count
    property Count: Integer read GetSubtitleInfoCount;

    // Cache list getter / setter
    property CacheList[Index: Integer]: Integer read GetCacheListItem
      write SetCacheListItem;

    { This property uses the CacheIndexList built when loading a file in the
      Editor view. This list is here to know for the current loaded file where
      are located a subtitle in the (big) TextDataList. }
    property Subtitles[Index: Integer]: TSubtitlesInfoList read
      GetSubtitleInfo;
  end;
  
  TMultiTranslationModule = class(TObject)
  private
    fActive: Boolean;
    fActiveSavedState: Boolean;
    fDisabled: Boolean;
    fTextDataList: TMultiTranslationTextData;
    fCurrentLoadedFile: TCurrentFileMultiTranslationModule;
    
    procedure SetActive(const Value: Boolean);
    procedure SetDisabled(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    // Launch the Multi-Translation process.
    procedure Apply;

    // Resets the Multi-Translation module.
    procedure Clear;

    // Prepare the Multi-Translation module (retrieve subtitles)
    procedure Prepare(RefreshRequest: Boolean);

    // Indicate if the user has enabled the Multi-Translation module.
    property Active: Boolean read fActive write SetActive;

    property CurrentLoadedFile: TCurrentFileMultiTranslationModule read
      fCurrentLoadedFile;

    { If the Global-Translation module is active, Multi-Translation must be
      disabled. }
    property Disabled: Boolean read fDisabled write SetDisabled;

    { This object stores every information about the Multi-Translation. }
    property TextDataList: TMultiTranslationTextData read fTextDataList
      write fTextDataList;
  end;

  // This class implements the Global-Translation view.
  TGlobalTranslationModule = class(TObject)
  private
    fSelectedNodeIndex: Integer;
    fSelectedNode: TTreeNode;
    fSelectedKeySubNode: TTreeNode;
    fSubtitleModified: Boolean;
    fInUse: Boolean;
    fNodeImageIndex: Integer;
    fBusy: Boolean;
    fMustReloadEditorTab: Boolean;
    fMultiTranslationTextData: TMultiTranslationTextData;
  protected
    procedure Abort; // abort the Global-Translation processus
    procedure FreeTreeViewUI;
    procedure UpdateSubtitle(const DataSubtitleIndex: Integer;
      TranslatedTextNode: TTreeNode; NewSubtitle: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Apply(const NewText: string);
    procedure ChangeModifiedState(const State: Boolean);
    procedure LoadSelectedSubtitle;
    procedure Reset;
    function SaveFileModifiedEditor: Boolean;
    procedure UpdateCharsCount;

    // Indicate if a Global-Translation is currently in progress.
    property Busy: Boolean read fBusy write fBusy;

    // Indicate if the user is using the Global-Translation module.
    property InUse: Boolean read fInUse write fInUse;

    // Contains all multitranslation datas (filled by the TMultiTranslationSubtitlesRetriever)
    property TextDataList: TMultiTranslationTextData read
      fMultiTranslationTextData write fMultiTranslationTextData;

    { Notify the "Editor" tab to reload the current selected file (to show
      the last Global-Translation modifications) }
    property MustRefreshEditorTab: Boolean read fMustReloadEditorTab
      write fMustReloadEditorTab;

    { Used by the Apply function. }
    property NodeImageIndex: Integer read fNodeImageIndex write fNodeImageIndex;

    { This flag indicate if the user has translated a subtitle in the
      "Global-Translation" view but his modification has not be saved yet. }
    property SubtitleModified: Boolean read fSubtitleModified;

    { Indicates the Node index of the item selected in the list for the
      "Global-Translation" tab. }
    property SelectedNodeIndex: Integer read fSelectedNodeIndex
      write fSelectedNodeIndex;

    { This is the selected subtitle node }
    property SelectedNewSubNode: TTreeNode read fSelectedNode write fSelectedNode;

    property SelectedHashKeySubNode: TTreeNode read fSelectedKeySubNode
      write fSelectedKeySubNode;
  end;

var
  frmMain: TfrmMain;

  SCNFScanner: TSCNFScanDirectory;                    // enable to scan directory to retrieve valid SCNF files
  SCNFEditor: TSCNFEditor;                            // enable to edit any valid SCNF file: this's the main class of this application

  MultiTranslationSubsRetriever: TMultiTranslationSubtitlesRetriever; // enable to retrieve all subtitles from loaded file list
  MultiTranslationUpdater: TMultiTranslationExecThread;                  // enable to multi-translate subtitles
  MultiTranslationViewUpdater: TMTViewUpdater;

  BatchSubsExporter: TSubsMassExporterThread;         // enable to batch export subtitles

  Previewer: TSubtitlesPreviewWindow;                 // Implements the Subtitles Previewer

  TextDatabaseCorrector: TTextDatabaseCorrector;      // Implements the TextCorrectionDatabase

implementation

{$IFDEF DEBUG}
{$IFDEF DEBUG_BUILD_RELEASE}
{$MESSAGE WARN 'This is a DEBUG BUILD. Don''t release it if you don''t know what you are doing...'}
{$ENDIF}
{$ENDIF}

uses
  {$IFDEF DEBUG} TypInfo, DBLzma, {$ENDIF}
  {$IFDEF OLD_MULTI_TRANSLATION_STYLE} MultiTrd, {$ENDIF}
  SelDir, Utils, CharsCnt, CharsLst, FileInfo, MassImp,
  Common, NPCInfo, VistaUI, About, FacesExt, IconsUI,
  BugsMgr;

{$R *.dfm}

const
  WIN_MIN_HEIGHT = 550;
  WIN_MIN_WIDTH = 580;

{ TfrmMain }

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
  frmAbout := TfrmAbout.Create(Application);
  try
    frmAbout.ShowModal;
  finally
    frmAbout.Free;
  end;
end;

procedure TfrmMain.AddDebug(m: string);
begin
  mDebug.Lines.Add('[' + DateToStr(Date) + ' ' + TimeToStr(Now) + '] ' + m);
end;

procedure TfrmMain.miAutoSaveClick(Sender: TObject);
begin
  AutoSave := not AutoSave;
  {$IFDEF DEBUG} WriteLn('AutoSave: ', AutoSave); {$ENDIF}
end;

procedure TfrmMain.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  miSubsPreview.Enabled := not (E is ESubtitlesPreviewInterface);
  RunBugsHandler(Sender, E);
end;

procedure TfrmMain.ApplicationEventsHint(Sender: TObject);
begin
  SetApplicationHint(Application.Hint);
  ApplicationEvents.CancelDispatch;
end;

procedure TfrmMain.BatchExportSubtitles(const OutputDirectory: TFileName);
var
  Temp: TFilesList;
  i: Integer;

begin
  Temp := TFilesList.Create;
  try
    for i := 0 to lbFilesList.Items.Count - 1 do
      Temp.Add(Self.GetTargetDirectory + lbFilesList.Items[i]);

    BatchSubsExporter := TSubsMassExporterThread.Create(OutputDirectory, Temp);
    frmProgress.Mode := pmBatchSubsExport;
    BatchSubsExporter.Resume;
    frmProgress.ShowModal;
  finally
    Temp.Free;
  end;
end;

procedure TfrmMain.miBatchExportSubsClick(Sender: TObject);
begin
  with bfdExportSubs do begin
    Directory := GetTargetDirectory;
    if Execute then
      BatchExportSubtitles(Directory);
  end;
end;

procedure TfrmMain.miBatchImportSubsClick(Sender: TObject);
begin
  // Global-Translation warning (if used)
  if GlobalTranslation.InUse then begin
    MsgBox('Sorry, since you are using the Global-Translation feature, this action is unavailable.',
      'Global-Translation is in use!', MB_ICONWARNING);
    Exit;
  end;

  // Show the form.
  frmMassImport := TfrmMassImport.Create(Application);
  try
    frmMassImport.ShowModal;
    if frmMassImport.Success and MultiTranslation.Active then
      MultiTranslation.Prepare(True);
  finally
    frmMassImport.Free;
  end;
end;

procedure TfrmMain.bMultiTranslateClick(Sender: TObject);
begin
  GlobalTranslation.Apply(mMTNewSub.Text);
end;

procedure TfrmMain.bMTRetrieveSubsClick(Sender: TObject);
var
  CanDo: Integer;

begin
  if MultiTranslation.Active then begin
    CanDo := MsgBox(
      'You are currently using the Multi-Translation function and it can be used with' + WrapStr
      + 'the Global-Translation function. Are you sure to continue?' + WrapStr +
      'If you hit ''OK'', the Multi-Translation function will be DISABLED and all not saved ' + WrapStr +
      'datas will be LOST!',
      'Multi-Translation / Global-Translation uncompatiblity',
      MB_ICONWARNING + MB_OKCANCEL + MB_DEFBUTTON2);
    if CanDo = IDCANCEL then Exit;
  end;

  CanDo := MsgBox(
    'This function will build the Global-Translation list from the actual loaded files. ' + WrapStr +
    'If you have many files, this can takes some minutes. ' + WrapStr +
    'Continue ?',
    'Global-Translation retriever question',
    MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;

  MultiTranslation.Disabled := True;
  GlobalTranslation.Reset;
  RetrieveSubtitles(GlobalTranslation.TextDataList, pmGlobalScan, False);
end;

procedure TfrmMain.bMTExpandAllClick(Sender: TObject);
begin
  GlobalTranslationUpdateView(nvoExpandAll);
end;

procedure TfrmMain.bMTClearClick(Sender: TObject);
var
  CanDo: Integer;

begin
  if GlobalTranslation.SubtitleModified then
    CanDo := MsgBox(
      'This operation will cancel the current Global-Translation and clear all '
      + 'datas (but not undone all the work already made). ' + WrapStr
      + 'Continue ?', 'Warning: Global-Translation current work not saved',
      MB_ICONWARNING + MB_YESNO + MB_DEFBUTTON2)
  else
    CanDo := MsgBox(
      'This operation will clear all '
      + 'datas (but not undone all Global-Translation already made). ' + WrapStr
      + 'Continue ?', 'Reset Global-Translation ?',
      MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2);

  if CanDo = IDNO then Exit;
  GlobalTranslation.Reset;

  // Re-enable Multi-Translation if needeed
  MultiTranslation.Disabled := False;
end;

procedure TfrmMain.bMTCollapseAllClick(Sender: TObject);
begin
  GlobalTranslationUpdateView(nvoCollapseAll);
end;

procedure TfrmMain.miEnableCharsModClick(Sender: TObject);
begin
  EnableCharsMod := not EnableCharsMod;
end;

procedure TfrmMain.miCheckForUpdateClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
    'http://sourceforge.net/projects/shenmuesubs/files/', '', '',
    SW_SHOWNORMAL);
end;

procedure TfrmMain.CheckIfSubLengthIsCorrect(const Value: Integer;
  Field: TEdit);
begin
  if Value > 44 then begin
    Field.Font.Color := clRed;
    Field.Font.Style := [fsBold];
  end else begin
    Field.Font.Color := clWindowText;
    Field.Font.Style := [];
  end;
end;

procedure TfrmMain.Clear;
begin
  OriginalSelectedSubtitleText := '';
  OldSelectedSubtitleText := '';
  SubtitleSelected := -1;
  SetFileOperationMenusItemEnabledState(False);
  SetFileSaveOperationsMenusItemEnabledState(False);
  eGame.Clear;
  eCharID.Clear;
  eVoiceID.Clear;
  eFirstLineLength.Text := '0';
  CheckIfSubLengthIsCorrect(0, eFirstLineLength);
  eSecondLineLength.Text := '0';
  CheckIfSubLengthIsCorrect(0, eSecondLineLength);
  eSubCount.Text := '0';
  mSubText.Text := '';
  lvSubsSelect.Clear;
  eFilesCount.Text := IntToStr(lbFilesList.Count);
  SetStatusReady;
  SetModified(False);
  mOldSubEd.Clear;
  rbMale.Checked := False;
  rbFemale.Checked := False;
  rbAdult.Checked := False;
  rbChild.Checked := False;
  iFace.Picture := nil;
  UpdateDirectoryControlsState;
end;

procedure TfrmMain.InitApplicationReleaseType;
begin
{$IFDEF OLD_MULTI_TRANSLATION_STYLE}
  MultiTranslation.Active := False;
  miMultiTranslate.Caption := 'Multi-translation...';
  miMultiTranslate.Hint := 'Open the Multi-translation module.';
{$ENDIF}
end;

procedure TfrmMain.InitTextDatabase1Click(Sender: TObject);
begin
{$IFDEF DEBUG} ShowMessage(GetTextDatabaseIndexFile(gvShenmue2)); {$ENDIF}
end;

procedure TfrmMain.DumpMultiTranslationCacheList1Click(Sender: TObject);
{$IFDEF DEBUG}
var
  FName: string;

begin
  FName := ExtractFilePath(application.ExeName) + IntToHex(Random($FFFFFFF), 8) + '.csv';
  MultiTranslation.CurrentLoadedFile.DumpCacheList(FName);
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDumpMultiTranslationTextDataClick(Sender: TObject);
{$IFDEF DEBUG}
var
  FName: string;

begin
  FName := ExtractFilePath(Application.ExeName) + IntToHex(Random($FFFFFFF), 8) + '.csv';
  MultiTranslation.TextDataList.SaveDump(FName);
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miClearDebugLogClick(Sender: TObject);
var
  CanDo: Integer;

begin
  CanDo := MsgBox('Clear debug log ?', 'Confirm', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;
  mDebug.Clear;
end;

procedure TfrmMain.miClearFilesListClick(Sender: TObject);
var
  CanDo: Integer;
begin
  CanDo := MsgBox('Are you sure to clear all the files list?'  + WrapStr
  + 'Changes not saved will be LOST!', 'Warning',
    + MB_ICONWARNING + MB_DEFBUTTON2 + MB_YESNO);
  if CanDo = IDNO then Exit;
  ResetApplication;
end;

procedure TfrmMain.miCloseFileClick(Sender: TObject);
begin
  // Auto Save
  if not SaveFileIfNeeded(True) then Exit;

  // Delete item
  lbFilesList.DeleteSelected;

  // Select the next item if possible
  if (lbFilesList.Count > 0) then begin

    // Determine the correct index
    if FileListSelectedIndex >= lbFilesList.Count then
      fFileListSelectedIndex := lbFilesList.Count - 1;

    // Load the appropriate file
    lbFilesList.ItemIndex := FileListSelectedIndex;
    fTargetFileName := GetTargetDirectory + lbFilesList.Items[FileListSelectedIndex];
    LoadSubtitleFile(GetTargetFileName);
  end else
    ResetApplication; // else, clear the application if no more files is available
end;

procedure TfrmMain.miCopySubClick(Sender: TObject);
var
  i: Integer;

begin
  i := lvSubsSelect.ItemIndex ;
  if i <> -1 then begin
    Clipboard.SetTextBuf(PChar(lvSubsSelect.Items[i].SubItems[1]));
  end;
end;

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miExportFilesListClick(Sender: TObject);
begin
  with sdMain do begin
    FileName := ExtremeRight('\', Copy(SelectedDirectory, 1, Length(SelectedDirectory)-1)) + '_FilesList.txt';
    Title := 'Export files list to...';
    DefaultExt := 'txt';
    Filter := 'Text Files (*.txt)|*.txt';
    if Execute then
      lbFilesList.Items.SaveToFile(FileName);
  end;
end;

procedure TfrmMain.miExportSubsClick(Sender: TObject);
begin
  sdMain.Title := 'Export subtitles to';
  sdMain.Filter := 'XML Files (*.xml)|*.xml';
  sdMain.DefaultExt := 'xml';

  with sdMain do begin
    FileName := ChangeFileExt(ExtractFileName(SCNFEditor.SourceFileName), '.xml');
    InitialDir := ExtractFilePath(SCNFEditor.SourceFileName);
    if Execute then begin
      SetStatus('Exporting subtitles...');
      SCNFEditor.Subtitles.ExportToFile(FileName);
      AddDebug('Subtitles was successfully exported from "'
        + ExtractFileName(SCNFEditor.SourceFileName) + '" to the "' + FileName + '" file.');
      SetStatusReady;
    end;
  end;
end;

procedure TfrmMain.miImportSubsClick(Sender: TObject);
begin
  odMain.Title := 'Import subtitles from';
  odMain.Filter := 'XML Files (*.xml)|*.xml';

  with odMain do begin
    if Execute then begin
      SetStatus('Importing subtitles...');
      if SCNFEditor.Subtitles.ImportFromFile(FileName) then begin
        RefreshSubtitlesList(True);
        SetModified(True);
        AddDebug('Subtitles was successfully imported from the "' + FileName
          + '" file to the "'+ ExtractFileName(SCNFEditor.SourceFileName)
          + '" file.');
      end
      else begin
        AddDebug('Subtitles importation: Error » XML not valid for the current file.');
      end;
      SetStatusReady;
    end;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  CanDo: Integer;
  
begin
  // To apply the auto save feature or not !
  if FileModified then

    // If Global-Translation is used...
    if GlobalTranslation.InUse then begin
      CanDo := MsgBox('Since you are using the Global-Translation module, the current '
      + 'file modifications were not saved.' + WrapStr +
      'Do you want to save modifications to another file ?',
      'Save changes?', MB_ICONWARNING + MB_YESNOCANCEL + MB_DEFBUTTON3);
      case CanDo of
        IDCANCEL: begin
                    Action := caNone;
                    Exit;
                  end;
        IDYES:    begin
                    miSaveAs.Click;
                  end;
        end;


    end else // ... else we save as normal

      if not SaveFileIfNeeded(True) then begin
        Action := caNone;
        Exit;
      end;

  // Confirmation to exit if Global-Translation module in use.
  if GlobalTranslation.InUse then begin
    CanDo := MsgBox('You are currently using the Global-Translation module.' + WrapStr
    + 'Are you sure to exit ?',
      'Please confirm!', MB_ICONWARNING + MB_YESNO + MB_DEFBUTTON2);
    if CanDo = IDNO then begin
      Action := caNone;
      Exit;
    end;
  end;

  // Clearing all garbage datas before exiting
  FreeApplication;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title + ' - v' + APP_VERSION + ' - by [big_fury]SiZiOUS';

{$IFNDEF DEBUG}
  // Debug Menu
  miDebug.Visible := False;
{$ENDIF}

  // Initialize the Text Corrector Database
  PreviousLoadedGameVersion := gvUndef;
  TextDatabaseCorrector := TTextDatabaseCorrector.Create;
  EnableOriginalSubtitlesView := False;
  
//  WorkFilesList := TFilesList.Create;

  // Create the control object for the GlobalTranslation module
  // This module is here to implements the "Global" tab.
  GlobalTranslation := TGlobalTranslationModule.Create;

  MultiTranslation := TMultiTranslationModule.Create;

  // Create the Subtitles Previewer
  Previewer := TSubtitlesPreviewWindow.Create(GetBitmapFontDatasDirectory);
  Previewer.OnWindowClosed := PreviewWindowClosedEvent;

  // Create the main object: SCNF Editor (Subtitles Editor)
  SCNFEditor := TSCNFEditor.Create;
  
  AutoSave := miAutoSave.Checked;
  ResetApplication;
  SetFileOperationMenusItemEnabledState(False);
  SetModified(False);
//  SetStatus('Ready');
  SetStatusReady;

  // Reset the form
  Clear;
  GlobalTranslation.Reset;

  // Set the Hints
  miCloseFile2.Hint := miCloseFile.Hint;
  miReloadCurrentFile2.Hint := miReloadCurrentFile.Hint;
  miImportSubs2.Hint := miImportSubs.Hint;
  miImportSubs3.Hint := miImportSubs.Hint;
  miExportSubs2.Hint := miExportSubs.Hint;
  miExportSubs3.Hint := miExportSubs.Hint;
  miFileProperties.Hint := miFileProperties2.Hint;
  miClearFilesList2.Hint := miClearFilesList.Hint;
  miReloadDir.Hint := miReloadDir2.Hint;

  // Constraints for the form
  Height := WIN_MIN_HEIGHT;
  Width := WIN_MIN_WIDTH;
  Constraints.MinHeight := WIN_MIN_HEIGHT;
  Constraints.MinWidth := WIN_MIN_WIDTH;

  // Select Editor Tab
  pcSubs.TabIndex := 0;

  //----------------------------------------------------------------------------
  // CHARS LIST
  //----------------------------------------------------------------------------

  CanEnableCharsMod1 := IsCharsModAvailable(gvShenmue);
  CanEnableCharsMod2 := IsCharsModAvailable(gvShenmue2);
  miEnableCharsMod.Enabled := CanEnableCharsMod1 or CanEnableCharsMod2;
  EnableCharsMod := miEnableCharsMod.Enabled;
  
  if not CanEnableCharsMod1 then
    AddDebug('WARNING: Unable to enable subtitles text characters modifications '
      + 'for What''s Shenmue / Shenmue / US Shenmue. "'
      + GetCorrectCharsList(gvShenmue) + '" file was not found.');
  if not CanEnableCharsMod2 then
    AddDebug('WARNING: Unable to enable subtitles text characters modifications '
     + 'for Shenmue II / Shenmue 2X. "'
     + GetCorrectCharsList(gvShenmue) + '" file not found.');

  //----------------------------------------------------------------------------
  // NPC INFOS
  //----------------------------------------------------------------------------

  // Loading CharsID info
  SCNFEditor.NPCInfos.LoadFromFile(GetNPCInfoFile);
  if not SCNFEditor.NPCInfos.Loaded then begin
    AddDebug('WARNING: Unable to get NPC characters info. "' + GetNPCInfoFile
      + '" file not found.');
    lGender.Enabled := False;
    lCharType.Enabled := False;
  end;

  //----------------------------------------------------------------------------
  // LOADING CONFIG
  //----------------------------------------------------------------------------
  LoadConfig;

  //----------------------------------------------------------------------------
  // DEBUG
  //----------------------------------------------------------------------------
  InitApplicationReleaseType;  
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Saving configuration
  SaveConfig;

  // Destroying GlobalTranslation module
  GlobalTranslation.Free;

  // Destroying Multi-Translation data list
  MultiTranslation.Free;

  SCNFEditor.Free;
//  WorkFilesList.Free;

  TextDatabaseCorrector.Free;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
{$IFDEF DEBUG}
{$IFDEF DEBUG_BUILD_RELEASE}
  MsgBox('THIS IS A PRIVATE DEBUG BUILD.' + WrapStr
    + 'THIS IS A TEST BUILD ONLY. DON''T WORK WITH THIS VERSION ON REAL FILES.' + WrapStr
    + 'USE IT AT YOUR OWN RISKS.' + WrapStr
    + 'Thanks for your test.',
    'IMPORTANT BETA NOTICE, PLEASE READ',
    MB_ICONERROR);

  WriteLn(Application.Title, sLineBreak, 'Version: ', APP_VERSION, ' (', COMPIL_DATE_TIME, ')', sLineBreak);
{$ENDIF}
{$ENDIF}

  // Starting FormShow:
  ApplicationEvents.Activate;

  // Reloading directory at startup
  if ReloadDirectoryAtStartup then
    ScanDirectory(SelectedDirectory);
end;

procedure TfrmMain.FreeApplication;
var
  HandleMenu: THandle;
  
begin
  // Disabling the Close button (because freeing MultiTranslation view can be long)
  miQuit.Enabled := False;
  HandleMenu := GetSystemMenu(Handle, False);
  EnableMenuItem(HandleMenu, SC_CLOSE, MF_DISABLED);

  // Free the Previewer
  Previewer.Free;

  // Free the MultiTranslation view
  // FreeTreeViewUI;
end;

procedure TfrmMain.GenerateTestException1Click(Sender: TObject);
{$IFDEF DEBUG}
begin
  raise EDivByZero.Create('TEST EXCEPTION MESSAGE COOL!');
{$ELSE}
begin
{$ENDIF}
end;

function TfrmMain.GetTargetDirectory: string;
begin
  Result := fSelectedDirectory;
end;

function TfrmMain.GetTargetFileName: TFileName;
begin
  Result := fTargetFileName;
end;

procedure TfrmMain.miGoToClick(Sender: TObject);
var
  i: Integer;

begin
  i := lbFilesList.Items.IndexOf(tvMultiSubs.Selected.Parent.Text);
  if i <> -1 then begin
    lbFilesList.Selected[i] := True;

    while not SCNFEditor.FileLoaded do
      Application.ProcessMessages;
      
    i := SCNFEditor.Subtitles.IndexOfSubtitleByCode(tvMultiSubs.Selected.Text);

    while i > lvSubsSelect.Items.Count - 1 do
      Application.ProcessMessages;
    
    if i <> -1 then begin
      pcSubs.TabIndex := 0;
      lvSubsSelect.Items[i].Selected := True;
      lvSubsSelect.Items[i].Focused := True;
      lvSubsSelect.ItemFocused.Selected := True;
      lvSubsSelect.SetFocus;
    end;
  end;
end;

procedure TfrmMain.lbFilesListClick(Sender: TObject);
var
  _newFile: TFileName;
  
begin
  if lbFilesList.ItemIndex = -1 then Exit;

  _newFile := GetTargetDirectory + lbFilesList.Items[lbFilesList.ItemIndex];

  // do nothing if same item selected...
  if UpperCase(ExtractFileName(_newFile)) = UpperCase(ExtractFileName(GetTargetFileName)) then
    if lvSubsSelect.Items.Count <> 0 then Exit;

  // Save the current file before changing it on the editor
  if not SaveFileIfNeeded(True) then begin
    lbFilesList.ItemIndex := FileListSelectedIndex;
    Exit;
  end;

  Clear;
  fTargetFileName := _newFile;
  fFileListSelectedIndex := lbFilesList.ItemIndex;
  LoadSubtitleFile(GetTargetFileName);
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

  // enable or not some menus
  miFileProperties.Enabled := (lbFilesList.ItemIndex <> -1);
  miFileProperties2.Enabled := miFileProperties.Enabled;
  miExportFilesList.Enabled := lbFilesList.Items.Count > 0;
  miCloseFile2.Enabled := (lbFilesList.ItemIndex <> -1);
  miCloseFile.Enabled := miCloseFile2.Enabled;

  UpdateDirectoryControlsState;
end;

procedure TfrmMain.lbFilesListDblClick(Sender: TObject);
begin
  miFileProperties.Click;
end;

procedure TfrmMain.lbFilesListKeyPress(Sender: TObject; var Key: Char);
begin
    if (lbFilesList.ItemIndex <> -1) and (Ord(Key) = VK_RETURN) then
    miFilePropertiesClick(Self);
end;

procedure TfrmMain.RefreshSubtitlesList(UpdateView: Boolean);
var
  i: Integer;
  SubText: string;
  CharsList: TSubsCharsList;

begin
  if UpdateView then begin

    // Exits: we have nothing to update
    if lvSubsSelect.Items.Count = 0 then Exit;

    // Updating current view
    for i := 0 to SCNFEditor.Subtitles.Count - 1 do begin
//      SubText := StringReplace(SCNFEditor.Subtitles[i].Text, #13#10, '<br>', [rfReplaceAll]);
      SubText := SCNFEditor.Subtitles[i].Text;
      lvSubsSelect.Items[i].SubItems[1] := SubText;
    end;

    i := lvSubsSelect.ItemIndex;
    if (i <> -1) then
      mOldSubEd.Text := StringReplace(SCNFEditor.Subtitles[i].Text, '<br>', #13#10, [rfReplaceAll]);

    // Updating NewSubtitle Memo...
    CharsList := TSubsCharsList.Create;
    try
      // We can't use the built-in CharsList of SCNFEditor because it can be disabled...
      // CharsList.LoadFromFile(GetDatasDirectory + 'chars_list.LIST_CSV');
      CharsList.LoadFromFile(GetCorrectCharsList(SCNFEditor.GameVersion));
      CharsList.Active := True;

      if EnableCharsMod then begin
        mSubText.Text := CharsList.DecodeSubtitle(mSubText.Text);
        mSubText.Text := StringReplace(mSubText.Text, '<br>', #13#10, [rfReplaceAll]);
      end else
        mSubText.Text := CharsList.EncodeSubtitle(mSubText.Text);
    finally
      CharsList.Free;
    end;

  end else begin

    // Adding new subs
    lvSubsSelect.Clear;

    for i := 0 to SCNFEditor.Subtitles.Count - 1 do begin
      with lvSubsSelect.Items.Add do begin
        Caption := SCNFEditor.Subtitles[i].CharID;
        SubItems.Add(SCNFEditor.Subtitles[i].Code);
//        SubText := StringReplace(SCNFEditor.Subtitles[i].Text, #13#10, '<br>', [rfReplaceAll]);
        SubText := SCNFEditor.Subtitles[i].Text;
        SubItems.Add(SubText);
      end;
    end;

  end;
end;

procedure TfrmMain.ReloadFileEditor;
begin
  if SCNFEditor.FileLoaded then begin
    LoadSubtitleFile(SCNFEditor.SourceFileName);
    AddDebug('File "' + SCNFEditor.SourceFileName + '" was reloaded.');
  end;
end;

procedure TfrmMain.miReloadCurrentFileClick(Sender: TObject);
var
  CanDo: Integer;
  FName: TFileName;

begin
  FName := ExtractFileName(SCNFEditor.SourceFileName);
  CanDo := MsgBox(
    'Reload the "' + FName + '" file ? '
    + WrapStr + 'Changes not saved will be LOST!',
    'Warning',
    MB_ICONWARNING + MB_YESNO + MB_DEFBUTTON2);
  if (CanDo = IDNO) then Exit;

  ReloadFileEditor;
end;

procedure TfrmMain.miReloadDirAtStartupClick(Sender: TObject);
begin
  ReloadDirectoryAtStartup := not ReloadDirectoryAtStartup;
end;

procedure TfrmMain.miReloadDirClick(Sender: TObject);
begin
  ScanDirectory(GetTargetDirectory);
end;

procedure TfrmMain.LoadSubtitleFile(const FileName: TFileName);
var
  PictFile: TFileName; //, GameVersionFolder: TFileName;
//  GenderChar, AgeChar: string;
  LoadRes: Boolean;
  StrBuf: string;

begin
  if not FileExists(FileName) then Exit;
  Clear;

//  Screen.Cursor := crAppStart;
  SetStatus('Loading file...');

  // FATAL ERROR WHEN READING THE FILE: IT WAS CORRUPTED BY THE OLD EDITOR (v1.xx)!
  LoadRes := SCNFEditor.LoadFromFile(FileName);
  if not LoadRes then begin
//    Screen.Cursor := crDefault;
    AddDebug('ERROR: File "' + FileName + '" is UNREADABLE!');
    StrBuf := 'ERROR: File "' + ExtractFileName(FileName) + '" is UNREADABLE!';
    SetStatus('ERROR!');
    MsgBox(StrBuf, 'FATAL ERROR !', MB_ICONERROR);
//    SetStatus('Ready');
    SetStatusReady;
    Exit;
  end;

  // Setting the correct chars list file depending of the game version
  LoadRes :=
    SCNFEditor.CharsList.LoadFromFile(GetCorrectCharsList(SCNFEditor.GameVersion));
  if LoadRes then begin
    SCNFEditor.CharsList.Active := EnableCharsMod;
    miEnableCharsMod.Enabled := True;
  end else begin
    AddDebug('WARNING: Unable to load the characters list for "'
      + GameVersionToFriendlyString(SCNFEditor.GameVersion)
      + '" from "' + GetCorrectCharsList(SCNFEditor.GameVersion) + '".'
    );
    if pcSubs.TabIndex = 0 then begin // Only if we have the "Editor" tab shown...
      SCNFEditor.CharsList.Active := False; // because in Global mode, we can enable it
      miEnableCharsMod.Enabled := False;
    end;
  end;

  // ---- TEXT DB --------------------------------------------------------------

  // Initializing the text corrector database (which contains the original subtitles)
  if PreviousLoadedGameVersion <> SCNFEditor.GameVersion then begin
    if not TextDatabaseCorrector.LoadDatabase(SCNFEditor.GameVersion) then
      AddDebug('WARNING: Unable to load the original subtitles information database for the "'
        + GameVersionToFriendlyString(SCNFEditor.GameVersion) + '" game version !')
    else begin
      AddDebug('Original subtitles information database for the "'
        + GameVersionToFriendlyString(SCNFEditor.GameVersion) + '" game version successfully loaded.');
      TextDatabaseCorrector.Subtitles.CharsList.Active := EnableCharsMod;
    end;
    PreviousLoadedGameVersion := SCNFEditor.GameVersion;
  end;

  // Loading original text data from the TextDB
  if not TextDatabaseCorrector.LoadTableForNPC(SCNFEditor.VoiceShortID, SCNFEditor.CharacterID) then
      AddDebug('WARNING: Unable to retrieve original subtitles information from '
        + 'the database for the entry "' + SCNFEditor.VoiceShortID + '_'
        + SCNFEditor.CharacterID + '" !');

  // ---- UPDATING VIEW --------------------------------------------------------

  // Show game info
  eGame.Text := GameVersionToFriendlyString(SCNFEditor.GameVersion);
  eCharID.Text := SCNFEditor.CharacterID;
  eVoiceID.Text := SCNFEditor.VoiceShortID;

  rbcgUnknow.Checked := True;
  rbatUnknow.Checked := True;
  case SCNFEditor.Gender of
    gtMale:   begin
//                GenderChar := 'M';
                rbMale.Checked := True;
              end;
    gtFemale: begin
//                GenderChar := 'F';
                rbFemale.Checked := True;
              end;
  end;

  case SCNFEditor.AgeType of
    atAdult:  begin
//                AgeChar := 'A';
                rbAdult.Checked := True;
              end;
    atChild:  begin
//                AgeChar := 'C';
                rbChild.Checked := True;
              end;
  end;

  eSubCount.Text := IntToStr(SCNFEditor.Subtitles.Count);
  RefreshSubtitlesList(False);

  if lvSubsSelect.Items.Count > 0 then begin
    lvSubsSelect.ItemIndex := 0;
    lvSubsSelectClick(Self);
//    Self.miSubsPreview.Enabled := True;
  end else
    if Previewer.IsVisible then
      Previewer.Clear;

  SetFileOperationMenusItemEnabledState(True);
  // AddDebug('SCNF file "' + ExtractFileName(FileName) + '" loaded successfully.');

  // load face
  (*PictFile := GetDatasDirectory + 'faces\'
    + GameVersionFolder + '\' + SCNFEditor.CharacterID + GenderChar + '_'
    + AgeChar + '.JPG';*)
  PictFile := GetFacesImagesDirectory(SCNFEditor.GameVersion) +
//    SCNFEditor.CharacterID + GenderChar + '_' + AgeChar + '.JPG';
    SCNFEditor.CharacterID + '.JPG';

  if FileExists(PictFile) then
    iFace.Picture.LoadFromFile(PictFile)
  else
    iFace.Picture := nil;

  // Refresh FileInfo dialog
  frmFileInfo.LoadFileInfo;

  // Build Multi-Translation cache index list to know where to look when
  // Multi-translating...
  if MultiTranslation.Active then
    MultiTranslation.CurrentLoadedFile.BuildCache;

//  SetStatus('Ready');
  SetStatusReady;
end;

procedure TfrmMain.miLocateFileClick(Sender: TObject);
var
  FName: string;

begin
  FName := SCNFEditor.GetLoadedFileName;
  ShellExecute(Handle, 'open', 'explorer', PChar('/e,/select,' + FName), '', SW_SHOWNORMAL);
end;

procedure TfrmMain.lvSubsSelectClick(Sender: TObject);
var
  Sub: string;
  
begin
  SubtitleSelected := lvSubsSelect.ItemIndex;
  if SubtitleSelected <> -1 then begin
    Sub := SCNFEditor.Subtitles[SubtitleSelected].Text;
    mSubText.Text := StringReplace(Sub, '<br>', #13#10, [rfReplaceAll]);
    OldSelectedSubtitleText := mSubText.Text;

    // Loading the original text for this subtitle from the database
    if TextDatabaseCorrector.Loaded then
      OriginalSelectedSubtitleText :=
        StringReplace(TextDatabaseCorrector.Subtitles[SubtitleSelected].Text,
          '<br>', sLineBreak, [rfReplaceAll])
    else
      OriginalSelectedSubtitleText := ORIGINAL_TEXT_NOT_AVAILABLE;

    // Update the OldSubEd edit
    UpdateOldSubtitleField;
  end;
end;

procedure TfrmMain.lvSubsSelectKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  lvSubsSelectClick(Self);
end;

procedure TfrmMain.miMakeBackupClick(Sender: TObject);
begin
  MakeBackup := not MakeBackup;
end;

procedure TfrmMain.miMultiTranslateClick(Sender: TObject);
{$IFDEF OLD_MULTI_TRANSLATION_STYLE}
begin
  frmMultiTranslation := TfrmMultiTranslation.Create(Application);
  try
    frmMultiTranslation.ShowModal;
  finally
    frmMultiTranslation.Free;
  end;
{$ELSE}

var
  CanDo: Integer;

begin
  if FileModified and not MultiTranslation.Active then begin
    CanDo := MsgBox('You are currently editing the view. Enabling this feature'
      + WrapStr + 'will save the current modifications.' + WrapStr
      + 'Do you agree ?', 'Multi-Translation activation', MB_ICONWARNING
      + MB_YESNOCANCEL + MB_DEFBUTTON3);
    case CanDo of
      IDCANCEL: Exit;
      IDYES: miSave.Click;
    end;
  end;

  MultiTranslation.Active := not MultiTranslation.Active;
{$ENDIF}
end;

procedure TfrmMain.miSubsPreviewClick(Sender: TObject);
begin
  miSubsPreview.Checked := not miSubsPreview.Checked;
  SubsViewerVisible := miSubsPreview.Checked;

  if SubsViewerVisible then begin

    case pcSubs.TabIndex of
      0: Previewer.Show(mSubText.Text);
      1: Previewer.Show(mMTNewSub.Text);
    end;

  end else
    Previewer.Hide;
end;

procedure TfrmMain.mMTNewSubChange(Sender: TObject);
begin
  with GlobalTranslation.SelectedHashKeySubNode do begin
    ImageIndex := GT_ICON_TEXT_MODIFIED;
    SelectedIndex := GT_ICON_TEXT_MODIFIED;
    OverlayIndex := GT_ICON_TEXT_MODIFIED;
  end;
  GlobalTranslation.ChangeModifiedState(True);
  GlobalTranslation.UpdateCharsCount;

  // Update Previewer
  if Previewer.IsVisible then
    Previewer.Update(mMTNewSub.Text);
end;

function TfrmMain.MsgBox(const Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmMain.mSubTextChange(Sender: TObject);
var
  Subtitle: TSubEntry;
  NewSubtitle: string;

begin
  if SubtitleSelected = -1 then Exit;
  Subtitle := SCNFEditor.Subtitles[SubtitleSelected];
  NewSubtitle := StringReplace(mSubText.Text, #13#10, '<br>', [rfReplaceAll]);

  // Update the PAKS file
  if Subtitle.Text <> NewSubtitle then begin
    SetModified(True);

    // Updating subtitle
    Subtitle.Text := NewSubtitle;

    // Update View
    lvSubsSelect.Items[SubtitleSelected].SubItems[1] := Subtitle.Text;

    { Multi-Translation Linked Subtitle Process
      In case if the same file has multiple occurences of the same subtitle.
      This procedure is here to "multi-translate" in the same file, in live. }
    with MultiTranslation do
      if Active then begin
        CurrentLoadedFile.UpdateLinkedSubtitles(SubtitleSelected, NewSubtitle);
    end;
  end;

  // Update the chars count fields
  (*CalculateCharsCount(Subtitle.Text, l1, l2);
  eFirstLineLength.Text := IntToStr(l1);
  CheckIfSubLengthIsCorrect(l1, eFirstLineLength);
  eSecondLineLength.Text := IntToStr(l2);
  CheckIfSubLengthIsCorrect(l2, eSecondLineLength);*)
  UpdateSubtitleLengthControls(Subtitle.Text, eFirstLineLength, eSecondLineLength);

  // Update the Previewer
  if SubsViewerVisible then
    Previewer.Update(mSubText.Text);
end;

procedure TfrmMain.miBrowseDirectoryClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'explorer', PChar(SelectedDirectory), '', SW_SHOWNORMAL);
end;

procedure TfrmMain.miOpenSingleFileClick(Sender: TObject);
var
  i: Integer;

begin
  with odMain do begin
    Title := 'Open NPC file(s) from...';
    DefaultExt := '.pks';
    Filter := 'Shenmue PAKS Files (*.PKS)|*.PKS|All Files (*.*)|*.*';
    Options := odMain.Options + [ofAllowMultiSelect];
    if DirectoryExists(SelectedDirectory) then
      InitialDir := SelectedDirectory;

    if Execute then begin

      if not SaveFileIfNeeded(True) then Exit;

      ResetApplication;

      for i := 0 to Files.Count - 1 do begin
          
        if IsFileValidScnf(Files[i]) then begin
          fSelectedDirectory := ExtractFilePath(Files[i]);
          lbFilesList.Items.Add(ExtractFileName(Files[i]));
        end else begin
          if Files.Count <> 1 then
            AddDebug('The selected file, "' + Files[i] + '" isn''t a valid Shenmue Free Quest subtitles format.');
        end;

      end; // for

      if lbFilesList.Count > 0 then begin
        lbFilesList.ItemIndex := 0;
        lbFilesListClick(Self);
      end else
        MsgBox('This file isn''t a valid Shenmue Free Quest subtitles format.', 'Not a valid PAKS SCNF file', MB_ICONWARNING);

    end; // if Execute
    Options := Options - [ofAllowMultiSelect];
  end;
end;

procedure TfrmMain.pcSubsChange(Sender: TObject);
var
  OldSubtitleSelected: Integer;

begin
  case pcSubs.TabIndex of

    // EDITOR TabSheet
    0:  begin
          // Save the MT modification if needed
          if GlobalTranslation.SubtitleModified then begin
            bMultiTranslate.Click;
          end;

          // Reload the selected file in the editor to show MT modifications
          if FileListSelectedIndex <> -1 then begin
            if GlobalTranslation.MustRefreshEditorTab then begin
              OldSubtitleSelected := SubtitleSelected;
              LoadSubtitleFile(fTargetFileName);
              GlobalTranslation.MustRefreshEditorTab := False;
              ListViewSelectItem(lvSubsSelect, OldSubtitleSelected);
            end;

            // Change state of the the CharsMod menu depending of the file selected
            miEnableCharsMod.Enabled := IsCharsModAvailable(SCNFEditor.GameVersion);
          end;
        end;

    // GLOBAL-TRANSLATION TabSheet
    1:  begin
          // Save files changes if needed
          SaveFileIfNeeded(False);
          miEnableCharsMod.Enabled := CanEnableCharsMod1 or CanEnableCharsMod2;
        end;

  end;

end;

procedure TfrmMain.PreviewWindowClosedEvent(Sender: TObject);
begin
  Self.miSubsPreview.Checked := False;
end;

procedure TfrmMain.miFileProperties2Click(Sender: TObject);
begin
  miFilePropertiesClick(Self);
end;

procedure TfrmMain.miFilePropertiesClick(Sender: TObject);
begin
  frmFileInfo.Show;
end;

procedure TfrmMain.ResetApplication;
begin
  Clear;
  fFileListSelectedIndex := -1;
  lbFilesList.Clear;
  MultiTranslation.Clear;
  miClearFilesList.Enabled := False;
  miClearFilesList2.Enabled := False;
  miBatchImportSubs.Enabled := False;
  miBatchExportSubs.Enabled := False;
  if SubsViewerVisible then
    Previewer.Clear();
end;

procedure TfrmMain.RetrieveSubtitles(TextDataList: TMultiTranslationTextData;
  ProgressFormMode: TProgressMode; RefreshRequest: Boolean);
var
  FillGlobalTranslationView: Boolean;

begin
  FillGlobalTranslationView := (ProgressFormMode = pmGlobalScan);
  
  // start the retrieving scanner thread
  MultiTranslationSubsRetriever :=
    TMultiTranslationSubtitlesRetriever.Create(SelectedDirectory,
      lbFilesList.Items.Text, EnableCharsMod, TextDataList,
      FillGlobalTranslationView, RefreshRequest);
  MultiTranslationSubsRetriever.Priority := tpHighest;
  frmProgress.Mode := ProgressFormMode;

  MultiTranslationSubsRetriever.Resume;

  // show the progress window
  if not frmProgress.Visible then
    frmProgress.ShowModal;
end;

procedure TfrmMain.miFacesExtractorClick(Sender: TObject);
begin
  frmFacesExtractor := TfrmFacesExtractor.Create(Application);
  try
    frmFacesExtractor.ShowModal;
  finally
    frmFacesExtractor.Free;
  end;
end;

procedure TfrmMain.miSaveClick(Sender: TObject);
begin
  if SCNFEditor.FileLoaded then begin

    // Global-Translation warning (if used)
    if GlobalTranslation.InUse then begin
      GlobalTranslation.SaveFileModifiedEditor;
      Exit;
    end;

    // Saving the file
    SetStatus('Saving...');
    SCNFEditor.Save;

    // Display the result
    AddDebug('File "' + SCNFEditor.GetLoadedFileName + '" successfully saved.');

    // Reseting form
    SetStatusReady;
    SetModified(False);
    if SubtitleSelected <> -1 then
      mOldSubEd.Text := SCNFEditor.Subtitles[SubtitleSelected].Text;

    // Reloading FileInfo
    frmFileInfo.LoadFileInfo;

    // Applying Multi-Translation
    if MultiTranslation.Active then
      MultiTranslation.Apply;
    
    {$IFDEF DEBUG} WriteLn('Saving file : ', ExtractFileName(SCNFEditor.GetLoadedFileName), #13#10); {$ENDIF}
  end;
end;

procedure TfrmMain.miSaveAsClick(Sender: TObject);
var
  Saved: Boolean;

begin
  sdMain.Title := 'Save patched NPC file to';
  sdMain.Filter := 'All Files (*.*)|*.*';
  sdMain.DefaultExt := '';
  Saved := True;
  
  if SCNFEditor.FileLoaded then begin
    with sdMain do begin
      FileName := ExtractFileName(SCNFEditor.GetLoadedFileName);
      InitialDir := ExtractFilePath(SCNFEditor.GetLoadedFileName);

      if Execute then begin
//        Screen.Cursor := crAppStart;
        SetStatus('Saving...');
        SCNFEditor.SaveToFile(FileName);
        AddDebug('Current Editor state successfully saved to the file "' + FileName + '".');
//        SetStatus('Ready');
        SetStatusReady;
//        SetModified(False);  // NO! We must keep the actual editor state
        {$IFDEF DEBUG} WriteLn('Saving file to: ', SCNFEditor.GetLoadedFileName, #13#10); {$ENDIF}
      end else // Execute
        Saved := False;
        
    end; // sdMain

    // If MultiTranslationInUse, we must reload the file to lost any changes!
    if GlobalTranslation.InUse then begin
      if not Saved then
        AddDebug('Save was cancelled by user !');
      SCNFEditor.ReloadFile;
      SetModified(False);
      AddDebug('Since you are using the Global-Translation module, the current file was '
      + 'reloaded from the disk to cancel every modifications.');
      LoadSubtitleFile(GetTargetFileName);
    end; // MultiTranslationInUse

  end; // FileLoaded
end;

procedure TfrmMain.miSaveDebugLogClick(Sender: TObject);
begin
  sdMain.Title := 'Save debug log as';
  sdMain.Filter := 'Debug Log Files (*.log)|*.log|Text Files (*.txt)|*.txt|All Files (*.*)|*.*';
  sdMain.DefaultExt := 'log';

  with sdMain do
    if Execute then
      mDebug.Lines.SaveToFile(FileName);    
end;

function TfrmMain.SaveFileIfNeeded(const CancelButton: Boolean): Boolean;
var
  CanDo, Buttons: Integer;
  NextMsg: string;

begin
  Result := False;
  NextMsg := '';

  if CancelButton then
    Buttons := MB_YESNOCANCEL
  else begin
    Buttons := MB_YESNO;
    NextMsg := ' If you hit ''No'', changes will be LOST!';
  end;
    
  // AutoSave
  if FileModified then begin

    // Global-Translation warning (if used)
    if GlobalTranslation.InUse then begin
      GlobalTranslation.SaveFileModifiedEditor;
      Exit;
    end;

    // Saving the file
    if AutoSave then begin
      miSave.Click;
      Result := True;
    end else begin
      CanDo := MsgBox('Do you want to save file modifications ?' + NextMsg,
        'Save changes?', Buttons + MB_ICONWARNING);
      case CanDo of
         IDCANCEL : Exit;
         IDNO     : begin
                      Result := True;
                      if not CancelButton then // reload the file
                        ReloadFileEditor;
                    end;
         IDYES    : begin
                      miSave.Click;
                      Result := True;
                    end;
      end;
    end; // if AutoSave

  end else
    Result := True; // no need to save, so continue
end;

procedure TfrmMain.SaveSubtitlesList(const FileName: TFileName);
var
  FileFormat, IndexText, SubText: string;
  i: Integer;
  List: TStringList;

begin
  FileFormat := ExtractFileExt(FileName);
  List := TStringList.Create;
  try
    if LowerCase(FileFormat) = '.csv' then begin

      // CSV format
      List.Add('Index;CharID;Code;Subtitle');
      for i := 0 to SCNFEditor.Subtitles.Count - 1 do begin
        IndexText := IntToStr(i + 1);
//        SubText := StringReplace(ScnfEditor.Subtitles[i].Text, #13#10, '<br>', [rfReplaceAll]);
        SubText := ScnfEditor.Subtitles[i].Text;
        List.Add(IndexText + ';' + ScnfEditor.Subtitles[i].CharID + ';'
          + ScnfEditor.Subtitles[i].Code + ';' + SubText);
      end;

    end else begin

      // Text format
      with List do begin
        Add(Caption);
        Add('---');
        Add('');
        Add('Input File   : ' + SCNFEditor.SourceFileName);
        Add('Character ID : ' + SCNFEditor.CharacterID);
        Add('Voice ID     : ' + SCNFEditor.VoiceShortID);
        Add('Game Version : ' + GameVersionToFriendlyString(SCNFEditor.GameVersion));
        Add('');
        Add('Subtitles    :');
      end;
      for i := 0 to ScnfEditor.Subtitles.Count - 1 do begin
//        SubText := StringReplace(ScnfEditor.Subtitles[i].Text, #13#10, '<br>', [rfReplaceAll]);
        SubText := ScnfEditor.Subtitles[i].Text;
        List.Add(ScnfEditor.Subtitles[i].Code
          + ' (' + ScnfEditor.Subtitles[i].CharID + '): ' + SubText);
      end;

    end;
    
    List.SaveToFile(FileName);

  finally
    List.Free;
  end;
end;

procedure TfrmMain.miSaveListToFileClick(Sender: TObject);
begin
  with sdSubsList do begin
    FileName := ChangeFileExt(ExtractFileName(SCNFEditor.SourceFileName), '');
    InitialDir := ExtractFilePath(SCNFEditor.SourceFileName);
    if Execute then
      SaveSubtitlesList(FileName);
  end;
end;

procedure TfrmMain.ScanDirectory(const Directory: string);
begin
  if not DirectoryExists(Directory) then Exit;
  
  // init main form
  ResetApplication;

  // start the scanning thread
  SelectedDirectory := IncludeTrailingPathDelimiter(Directory);

  SCNFScanner := TSCNFScanDirectory.Create(SelectedDirectory);
  frmProgress.Mode := pmSCNFScanner;

  SCNFScanner.Resume;

  frmProgress.ShowModal;

  miClearFilesList.Enabled := True;
  miClearFilesList2.Enabled := True;
  miBatchImportSubs.Enabled := True;
  miBatchExportSubs.Enabled := True;
end;

procedure TfrmMain.miScanDirectoryClick(Sender: TObject);
begin
  with frmSelectDir do begin
    SetDefaultDirectory(SelectedDirectory);
    ShowModal;
    if ModalResult = mrOK then
      ScanDirectory(GetSelectedDirectory);
  end;
end;

procedure TfrmMain.SetApplicationHint(const HintStr: string);
begin
  if HintStr = '' then
//    SetStatus('Ready')
    SetStatusReady
  else begin
    sb.Panels[2].Text := HintStr;
  end;
end;

procedure TfrmMain.SetAutoSave(const Value: Boolean);
begin
  fAutoSave := Value;
  miAutoSave.Checked := AutoSave;
end;

procedure TfrmMain.SetEnableCharsMod(const Value: Boolean);
begin
  miEnableCharsMod.Checked := Value;
  fEnableCharsMod := Value;

  // Single view
  if SCNFEditor.CharsList.Loaded then begin
    SCNFEditor.CharsList.Active := Value;
    RefreshSubtitlesList(True);
  end;

  // Global-Translation
  if GlobalTranslation.InUse then
    if Value then
      GlobalTranslationUpdateView(nvoDecodeText)
    else
      GlobalTranslationUpdateView(nvoEncodeText);

  // File Infos
  if Assigned(frmFileInfo) and frmFileInfo.Visible then
    frmFileInfo.UpdateSubtitles;

  // Original text function
  if Value then begin
     OriginalSelectedSubtitleText := TextDatabaseCorrector
      .Subtitles.CharsList.DecodeSubtitle(OriginalSelectedSubtitleText);
     OldSelectedSubtitleText := TextDatabaseCorrector
      .Subtitles.CharsList.DecodeSubtitle(OldSelectedSubtitleText);
  end else begin
     OriginalSelectedSubtitleText := TextDatabaseCorrector
      .Subtitles.CharsList.EncodeSubtitle(OriginalSelectedSubtitleText);
     OldSelectedSubtitleText := TextDatabaseCorrector
      .Subtitles.CharsList.EncodeSubtitle(OldSelectedSubtitleText);
  end;
  TextDatabaseCorrector.Subtitles.CharsList.Active := Value;
end;

procedure TfrmMain.SetEnableOriginalSubtitlesView(const Value: Boolean);
begin
  fEnableOriginalSubtitlesView := Value;
  miShowOriginalText.Checked := Value;
  UpdateOldSubtitleField;
  if Value then
    lOldText.Caption := 'Original text:'
  else
    lOldText.Caption := 'Old text:';
end;

procedure TfrmMain.SetFileOperationMenusItemEnabledState(const State: Boolean);
begin
  miCloseFile.Enabled := State;
  miCloseFile2.Enabled := State;
  miReloadCurrentFile.Enabled := State;
  miReloadCurrentFile2.Enabled := State;
  miImportSubs.Enabled := State;
  miExportSubs.Enabled := State;
  miImportSubs3.Enabled := State;
  miExportSubs3.Enabled := State;
  miFileProperties.Enabled := State;
  miFileProperties2.Enabled := State;
  if State then
    lvSubsSelect.PopupMenu := pmSubsSelect
  else
    lvSubsSelect.PopupMenu := nil;
  Self.miLocateFile.Enabled := State;
  // Self.Multitranslation1.Enabled := State;
end;

procedure TfrmMain.SetFileSaveOperationsMenusItemEnabledState(
  const State: Boolean);
begin
  miSave.Enabled := State;
  miSaveAs.Enabled := State;
end;

procedure TfrmMain.SetMakeBackup(const Value: Boolean);
begin
  fMakeBackup := Value;
  SCNFEditor.MakeBackup := Value;
  miMakeBackup.Checked := Value;
end;

procedure TfrmMain.SetModified(const State: Boolean);
begin
  SetModifiedIndicator(State);
  fFileModified := State;
  SetFileSaveOperationsMenusItemEnabledState(State);
end;

procedure TfrmMain.SetModifiedIndicator(State: Boolean);
begin
  GlobalTranslation.fSubtitleModified := State;
  if State then
    sb.Panels[1].Text := 'Modified'
  else
    sb.Panels[1].Text := '';
end;

procedure TfrmMain.SetReloadDirectoryAtStartup(const Value: Boolean);
begin
  fReloadDirectoryAtStartup := Value;
  miReloadDirAtStartup.Checked := Value;
end;

procedure TfrmMain.SetStatus(const Text: string);
begin
  if (Text = 'Ready') then
    Screen.Cursor := crDefault
  else
    Screen.Cursor := crAppStart;

  sb.Panels[2].Text := Text;
  Application.ProcessMessages;
end;

procedure TfrmMain.SetStatusReady;
begin
  SetStatus('Ready');
end;

procedure TfrmMain.miShowOriginalTextClick(Sender: TObject);
begin
  EnableOriginalSubtitlesView := not EnableOriginalSubtitlesView; 
end;

procedure TfrmMain.TextDatabaseCorrector1Click(Sender: TObject);
{$IFDEF DEBUG}
var
  DB: TTextDatabaseCorrector;

begin
  if SubtitleSelected = -1 then begin
    ShowMessage('select a subtitle in the list!!!');
    Exit;
  end;

  DB := TTextDatabaseCorrector.Create;
  try
    DB.LoadDatabase(gvShenmue2);
    if DB.LoadTableForNPC(SCNFEditor.VoiceShortID, SCNFEditor.CharacterID) then
      ShowMessage(DB.Subtitles[SubtitleSelected].Text)
    else
      ShowMessage('ENTRY NOT FOUND!!!');
  finally
    DB.Free;
  end;
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.tvMultiSubsClick(Sender: TObject);
begin
  GlobalTranslation.LoadSelectedSubtitle;
end;

procedure TfrmMain.tvMultiSubsContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  NodeType: TMultiTranslationNodeType;

begin
  if tvMultiSubs.Selected = nil then Exit;
  NodeType := PMultiTranslationNodeType(tvMultiSubs.Selected.Data)^;
  if NodeType.NodeViewType = nvtSubCode then
    tvMultiSubs.PopupMenu := pmMultiSubs
  else
    tvMultiSubs.PopupMenu := nil;
end;

procedure TfrmMain.tvMultiSubsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  tvMultiSubsClick(Sender);
end;

procedure TfrmMain.UpdateDirectoryControlsState;
begin
  miReloadDir.Enabled := DirectoryExists(SelectedDirectory);
  miReloadDir2.Enabled := miReloadDir.Enabled;
  miBrowseDirectory.Enabled := miReloadDir.Enabled;
  miBrowseDirectory2.Enabled := miBrowseDirectory.Enabled;
end;

procedure TfrmMain.UpdateOldSubtitleField;
begin
  if EnableOriginalSubtitlesView then
    mOldSubEd.Text := OriginalSelectedSubtitleText
  else
    mOldSubEd.Text := OldSelectedSubtitleText;
end;

procedure TfrmMain.UpdateSubtitleLengthControls(SubtitleText: string;
  FirstLengthEditControl, SecondLengthEditControl: TEdit);
var
  Line1, Line2: Integer;

begin
  CalculateCharsCount(SubtitleText, Line1, Line2);
  FirstLengthEditControl.Text := IntToStr(Line1);
  CheckIfSubLengthIsCorrect(Line1, FirstLengthEditControl);
  SecondLengthEditControl.Text := IntToStr(Line2);
  CheckIfSubLengthIsCorrect(Line2, SecondLengthEditControl);
end;

procedure TfrmMain.miProjectHomeClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://shenmuesubs.sourceforge.net/', '', '', SW_SHOWNORMAL);
end;

//------------------------------------------------------------------------------
// GLOBAL-TRANSLATION MODULE
//------------------------------------------------------------------------------

procedure TGlobalTranslationModule.Apply(const NewText: string);
begin
  if Busy then begin
    frmMain.AddDebug('WARNING: Global-Translation module is busy, so please wait and retry again.');
    Exit;
  end;

  UpdateSubtitle(SelectedNodeIndex, SelectedNewSubNode, NewText);
end;

procedure TGlobalTranslationModule.ChangeModifiedState(const State: Boolean);
begin
  with frmMain do begin
    SetModifiedIndicator(State);
    bMultiTranslate.Enabled := State;

    if not State then begin
      SetStatusReady;
      Busy := False;
    end;
  end; // with frmMain
end;

procedure TGlobalTranslationModule.Abort;
begin
  ChangeModifiedState(False);
  with SelectedHashKeySubNode do begin
    ImageIndex := NodeImageIndex;
    SelectedIndex := NodeImageIndex;
    OverlayIndex := NodeImageIndex;
  end;
end;

constructor TGlobalTranslationModule.Create;
begin
  TextDataList := TMultiTranslationTextData.Create;
end;

destructor TGlobalTranslationModule.Destroy;
begin
  FreeTreeViewUI;
  TextDataList.Free;
  inherited Destroy;
end;

procedure TGlobalTranslationModule.FreeTreeViewUI;
var
  i: Integer;

begin
  for i := 0 to frmMain.tvMultiSubs.Items.Count - 1 do begin
    Dispose(PMultiTranslationNodeType(frmMain.tvMultiSubs.Items[i].Data));
    if (i mod 200) = 0 then
      Application.ProcessMessages;
  end;
end;

procedure TGlobalTranslationModule.LoadSelectedSubtitle;
var
  NodeType, PrevNodeType: TMultiTranslationNodeType;
  Node: TTreeNode;
  
begin
  with frmMain do begin

    Node := tvMultiSubs.Selected;
    if Node = nil then Exit;

    if Assigned(SelectedHashKeySubNode) then
      PrevNodeType :=
        PMultiTranslationNodeType(SelectedHashKeySubNode.Data)^;

    NodeType := PMultiTranslationNodeType(Node.Data)^;

{$IFDEF DEBUG}
{$IFDEF GLOBAL_TRANSLATION_NODE_DEBUG}
    WriteLn(
      'NodeType: ',
      GetEnumName(TypeInfo(TMultiTranslationNodeViewType), Ord(NodeType.NodeViewType)),
      ', GameVersion: ',
      GetEnumName(TypeInfo(TGameVersion), Ord(NodeType.GameVersion))
    );
{$ENDIF}
{$ENDIF}

    // Normal node that can be edited
    if NodeType.NodeViewType = nvtSubtitleKey then begin

      // if working, then exits
      if Busy then Exit;

      // Check if not the same node selected...
      if Node = SelectedHashKeySubNode then Exit;

      // Translate the previous subtitle if needed
      if (PrevNodeType.GameVersion <> gvUndef)
        and Assigned(SelectedHashKeySubNode) then
          UpdateSubtitle(SelectedNodeIndex, SelectedNewSubNode, mMTNewSub.Text);

      // Initialize the current node
      mMTNewSub.OnChange := nil;
      SelectedHashKeySubNode := Node;
      NodeImageIndex := Node.ImageIndex;
      SelectedNodeIndex := Node.Index;
      SelectedNewSubNode := Node.Item[0];

      // This node can't be edited (ERRORNOUS NODE!)
      mMTNewSub.Enabled := NodeType.GameVersion <> gvUndef;
      if not mMTNewSub.Enabled then begin
        AddDebug('WARNING: "' + Node.Text
          + '": This errornous subtitle can''t be translated, since two '
          + 'different chars list was used!');
        mMTNewSub.Clear;
        mMTOldSub.Clear;
        Exit;
      end;

      // Loading text to translate
      if (Node.ImageIndex = GT_ICON_NOT_TRANSLATED) then begin // BASED ON THE ImageIndex to know if it is translated or not !!!
        // Not yet translated
        mMTOldSub.Text := StringReplace(Node.Text, '<br>', #13#10, [rfReplaceAll]);
        mMTNewSub.Text := mMTOldSub.Text;
      end else begin
        // Already translated, so reload the old "new" subtitle
        mMTOldSub.Text := StringReplace(Node.Item[0].Text, '<br>', #13#10, [rfReplaceAll]);
        mMTNewSub.Text := mMTOldSub.Text;
      end;
      UpdateCharsCount;
      mMTNewSub.OnChange := mMTNewSubChange;

      // Update Previewer
      if SubsViewerVisible then
        Previewer.Update(mMTNewSub.Text);
    end;

  end; // with frmMain
end;

procedure TGlobalTranslationModule.Reset;
begin
  with frmMain do begin
    // Clear MultiSubs view
    FreeTreeViewUI;
    tvMultiSubs.Items.Clear;

    mMTOldSub.Clear;
    mMTNewSub.Clear;
    bMultiTranslate.Enabled := False;

    eMTFirstLineLength.Text := '0';
    CheckIfSubLengthIsCorrect(0, eMTFirstLineLength);
    eMTSecondLineLength.Text := '0';
    CheckIfSubLengthIsCorrect(0, eMTSecondLineLength);

    SelectedNodeIndex := -1;
    NodeImageIndex := -1;
    SelectedHashKeySubNode := nil;
    SelectedNewSubNode := nil;
    InUse := False;
    fSubtitleModified := False;
  end;
end;

function TGlobalTranslationModule.SaveFileModifiedEditor: Boolean;
var
  CanDo: Integer;

begin
  with frmMain do begin
    Result := False;
    CanDo := MsgBox('Sorry, since you are using the Global-Translation module, the save '
      + 'feature was disabled.' + WrapStr
      + 'You MUST save your modifications to another file. ' + WrapStr
      + 'Do it now ? If you don''t, modifications will be LOST!',
      'File was not saved! Save as another file ?', MB_ICONWARNING + MB_OKCANCEL);
    if CanDo = IDCANCEL then
      ReloadFileEditor
    else begin
      miSaveAs.Click;
      Result := True;
    end;
  end;
end;

(*procedure TGlobalTranslationModule.SetInUse(const Value: Boolean);
begin
  fInUse := Value;
  frmMain.miBatchImportSubs.Enabled := not Value;
end;*)

procedure TGlobalTranslationModule.UpdateCharsCount;
(*var
  l1, l2: Integer;*)
begin
  (*with frmMain do begin
    CalculateCharsCount(mMTNewSub.Text, l1, l2);
    eMTFirstLineLength.Text := IntToStr(l1);
    CheckIfSubLengthIsCorrect(l1, eMTFirstLineLength);
    eMTSecondLineLength.Text := IntToStr(l2);
    CheckIfSubLengthIsCorrect(l2, eMTSecondLineLength);
  end;*)
  with frmMain do
    UpdateSubtitleLengthControls(mMTNewSub.Text, eMTFirstLineLength, eMTSecondLineLength);
end;

procedure TGlobalTranslationModule.UpdateSubtitle(
  const DataSubtitleIndex: Integer;
  TranslatedTextNode: TTreeNode;
  NewSubtitle: string);
var
  SubInfoList: TSubtitlesInfoList;
  GlobalTranslationSCNFEditor: TSCNFEditor;
  TmpCharsList: TSubsCharsList;
  i, SubIndex: Integer;
  TargetSubEntry: TSubEntry;
  TargetHashKeySub, // subtitle hash key (can't be modified). it's in fact the ORIGINAL subtitle when the list is built
  OldSubtitle: string; // this's the real old subtitle. when it's modified the first time, OldSubtitle = TargetKeySub
  NodeType: TMultiTranslationNodeType;

begin
  with frmMain do begin
    // Retrieve the Concerned subtitle
    TargetHashKeySub := '';
    if DataSubtitleIndex = -1 then Exit;
    try
      // This's the Hash Key of the Target Subtitle
      TargetHashKeySub := TextDataList.Subtitles[DataSubtitleIndex].SubtitleKey;
    except
      Exit;
    end;

    // Check if new subtitle isn't empty
    if NewSubtitle = '' then begin
      frmMain.AddDebug('Subtitle can''t be empty. Global-Translation cancelled for this one.');
      Abort;
      Exit;
    end;

    // Retrieve current Selected Key Node infos
    NodeType := PMultiTranslationNodeType(SelectedHashKeySubNode.Data)^;

    // OK now we are ready to retrieve the list of subtiles to update if possible.
    TmpCharsList := TSubsCharsList.Create;
    try
      TmpCharsList.LoadFromFile(GetCorrectCharsList(NodeType.GameVersion));
      TmpCharsList.Active := frmMain.EnableCharsMod;

      // Retrieve the list of subtitles code to update
      {with TextDataList do
        SubInfoList := GetSubtitleInfo(TargetHashKeySub);}
      SubInfoList := TextDataList.FindBySubtitleKey(TargetHashKeySub);

      // Getting Old and New subtitle...
      NewSubtitle := TmpCharsList.EncodeSubtitle(NewSubtitle);
      OldSubtitle := SubInfoList.NewSubtitle; // already encoded

      // Exits if it's the same text
      if (SameText(NewSubtitle, OldSubtitle)) then begin
        // Warning if needeed
        if SubtitleModified then
          frmMain.AddDebug('Unable to multi-translate a subtitle ... to his same value!');
        Abort;
        Exit;
      end;

      // *************************************************************************
      // GLOBAL-TRANSLATING NOW !!
      // *************************************************************************

      // Updating the TextData item
      SubInfoList.NewSubtitle := NewSubtitle; // already Encoded by CharsList
      // This single value must be encoded with Shenmue 1 or Shenmue 2 charslist!

      // Applying modification
      GlobalTranslationSCNFEditor := TSCNFEditor.Create;
      try
  //      Screen.Cursor := crAppStart;
        SetStatus('Global-translating...');
        Busy := True;

        // Updating the Global-Translation node to show working icon
        with SelectedHashKeySubNode do begin
          ImageIndex := GT_ICON_TRANSLATION_IN_PROGRESS;
          SelectedIndex := GT_ICON_TRANSLATION_IN_PROGRESS;
          OverlayIndex := -1;
        end;
        Application.ProcessMessages;

{$IFDEF DEBUG}
        WriteLn(#13#10, 'Global-translating ... Hash Key = "', TargetHashKeySub, '"');
{$ENDIF}

        // Updating all subtitles by SubCode
        for i := 0 to SubInfoList.Count - 1 do begin

{$IFDEF DEBUG}
    WriteLn('  ', SubInfoList.Items[i].Code, ': ', ExtractFileName(SubInfoList.Items[i].FileName));
{$ENDIF}

          // Load the target file if necessary (if it's the same, we skip this to improve speed)
          with GlobalTranslationSCNFEditor do
            if not SameText(GetLoadedFileName, SubInfoList.Items[i].FileName) then begin
              if FileLoaded then Save; // save the loaded PAKS file (if more than one entry to translate)
              LoadFromFile(SubInfoList.Items[i].FileName);
            end;

          // updating the subtitle...
          SubIndex := GlobalTranslationSCNFEditor.Subtitles.IndexOfSubtitleByCode(SubInfoList.Items[i].Code);
          if SubIndex <> -1 then begin // not found ??
            TargetSubEntry := GlobalTranslationSCNFEditor.Subtitles[SubIndex];

            // protection "anti-change" outside the Global-Translation module
            if TargetSubEntry.Text = OldSubtitle then
              TargetSubEntry.Text := NewSubtitle
            else
              AddDebug('WARNING: Subtitle "' + SubInfoList.Items[i].Code + '" of the '
                + 'file "' + SubInfoList.Items[i].FileName + '" has CHANGED outside the '
                + 'Global-Translation module! It HAS NOT BE MODIFIED with the new '
                + 'Global-Translation value!');
          end else
            AddDebug('WARNING: Subtitle "' + SubInfoList.Items[i].Code + '" was '
              + 'NOT found in the file "' + SubInfoList.Items[i].FileName + '"! '
              + 'THIS IS IMPOSSIBLE! Do you have modified the file outside this editor?');

        end;

        //Saving the last file
        GlobalTranslationSCNFEditor.Save;

        // Updating the view
        if EnableCharsMod then
          TranslatedTextNode.Text := TmpCharsList.DecodeSubtitle(SubInfoList.NewSubtitle)
        else
          // TranslatedTextNode.Text := StringReplace(SubInfoList.NewSubtitle, #13#10, '<br>', [rfReplaceAll]);
          TranslatedTextNode.Text := SubInfoList.NewSubtitle;

        // New image for the node!
        NodeImageIndex := GT_ICON_TRANSLATED;

        // Modifing Subtitle Root image
        SelectedHashKeySubNode.ImageIndex := NodeImageIndex;
        SelectedHashKeySubNode.SelectedIndex := NodeImageIndex;
        SelectedHashKeySubNode.OverlayIndex := -1;

        // Removing the "Modified" state
        ChangeModifiedState(False);

        // Notify the "Editor" tab to reload the current selected file (to show
        // the last MT modifications)
        MustRefreshEditorTab := True;
      finally
        GlobalTranslationSCNFEditor.Free;
      end;

    finally
      TmpCharsList.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------
// TMultiTranslationModule
//------------------------------------------------------------------------------

procedure TMultiTranslationModule.Apply;
begin
  MultiTranslationUpdater := TMultiTranslationExecThread.Create;
  frmProgress.Mode := pmMultiExec;
  MultiTranslationUpdater.Resume;
  frmProgress.ShowModal;
end;

procedure TMultiTranslationModule.Clear;
begin
  TextDataList.Clear;
end;

constructor TMultiTranslationModule.Create;
begin
  TextDataList := TMultiTranslationTextData.Create;
  fCurrentLoadedFile := TCurrentFileMultiTranslationModule.Create(Self);
end;

destructor TMultiTranslationModule.Destroy;
begin
  fCurrentLoadedFile.Free;
  TextDataList.Free;
  inherited;
end;

procedure TMultiTranslationModule.Prepare(RefreshRequest: Boolean);
begin
  // afficher un warning ?

  // Building the Multi-Translation list
  Clear;
  if frmMain.lbFilesList.Items.Count > 0 then
    frmMain.RetrieveSubtitles(TextDataList, pmMultiScan, RefreshRequest);
end;

procedure TMultiTranslationModule.SetActive(const Value: Boolean);
begin
  fActive := Value;
  frmMain.miMultiTranslate.Checked := fActive;
  fActiveSavedState := fActive;
  
  if Active then begin
    Prepare(False);

    // Build cache
    if frmMain.FileModified then
      frmMain.ReloadFileEditor  // view modified: reload from disk everything
    else
      CurrentLoadedFile.BuildCache; // not modified: update only cache
      
  end else
    Clear; // clear all datas
end;

procedure TMultiTranslationModule.SetDisabled(const Value: Boolean);
begin
  fDisabled := Value;
  
  if Disabled then
    frmMain.miMultiTranslate.Checked := False
  else
    frmMain.MultiTranslation.Active := fActiveSavedState;
    
  frmMain.miMultiTranslate.Enabled := not Disabled;
end;

//------------------------------------------------------------------------------
// TCurrentFileMultiTranslationModule
//------------------------------------------------------------------------------

procedure TCurrentFileMultiTranslationModule.BuildCache;
var
  i, TextDataIndex: Integer;

begin
  fCacheIndexList.Clear;

  for i := 0 to SCNFEditor.Subtitles.Count - 1 do begin
    TextDataIndex := fOwner.TextDataList.IndexOfSubtitleKey(SCNFEditor.Subtitles[i].RawText);
    if TextDataIndex <> -1 then
      fCacheIndexList.Add(Pointer(TextDataIndex));
  end;
end;

constructor TCurrentFileMultiTranslationModule.Create(
  AOwner: TMultiTranslationModule);
begin
  fCacheIndexList := TList.Create;
  fOwner := AOwner;
end;

destructor TCurrentFileMultiTranslationModule.Destroy;
begin
  fCacheIndexList.Free;
  inherited;
end;

function TCurrentFileMultiTranslationModule.GetCacheListItem(
  Index: Integer): Integer;
begin
  Result := Integer(fCacheIndexList.Items[Index]);
end;

function TCurrentFileMultiTranslationModule.GetSubtitleInfo(
  Index: Integer): TSubtitlesInfoList;
begin
  Result := fOwner.TextDataList.Subtitles[CacheList[Index]];
end;

function TCurrentFileMultiTranslationModule.GetSubtitleInfoCount: Integer;
begin
  Result := fCacheIndexList.Count;
end;

{$IFDEF DEBUG}

procedure TCurrentFileMultiTranslationModule.DumpCacheList(
  const FileName: TFileName);
var
  SL: TStringList;
  i: Integer;

begin
  SL := TStringList.Create;
  try
    SL.Add('Index;TextDataIndex;SubtitleKey;SCNFEditorText');
    for i := 0 to fCacheIndexList.Count - 1 do
      SL.Add(IntToStr(i) + ';' + IntToStr(Integer(fCacheIndexList[i]))
      + ';' + Self.Subtitles[i].SubtitleKey + ';'
      + SCNFEditor.Subtitles[i].RawText);
    SL.SaveToFile(FileName);
  finally
    SL.Free;
  end;
end;

{$ENDIF}

procedure TCurrentFileMultiTranslationModule.SetCacheListItem(Index: Integer;
  const Value: Integer);
begin
  fCacheIndexList.Items[Index] := Pointer(Value);
end;

procedure TCurrentFileMultiTranslationModule.UpdateLinkedSubtitles(
  SubtitleSelected: Integer; NewSubtitleValue: string);
var
  SubtitlesInfoList: TSubtitlesInfoList;
  i, SubIndex: Integer;

begin
  // update same subtitles in the same file
  SubtitlesInfoList := Subtitles[SubtitleSelected]; // from TextData  
  for i := 0 to SubtitlesInfoList.Count - 1 do
    // in the same file...
    if SubtitlesInfoList.Items[i].FileName = SCNFEditor.SourceFileName then begin
      // ... update sames subs!
      SubIndex := SCNFEditor.Subtitles.IndexOfSubtitleByCode(SubtitlesInfoList.Items[i].Code);

      // update SCNFEditor object
      SCNFEditor.Subtitles[SubIndex].Text := NewSubtitleValue;

      // update view
      frmMain.lvSubsSelect.Items[SubIndex].SubItems[1] := NewSubtitleValue;
    end;
end;

end.
