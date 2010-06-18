unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MemoEdit, Menus, ImgList, ComCtrls, ToolWin, JvExComCtrls,
  JvToolBar, JvEdit, JvExStdCtrls, AppEvnts, ExtCtrls, DebugLog, BugsMgr;

type 
  TfrmMain = class(TForm)
    bPrev: TButton;
    bNext: TButton;
    mmMain: TMainMenu;
    miFile: TMenuItem;
    tbMain: TJvToolBar;
    ToolButton1: TToolButton;
    tbOpen: TToolButton;
    tbReload: TToolButton;
    tbSave: TToolButton;
    ToolButton4: TToolButton;
    tbDebugLog: TToolButton;
    tbAutoSave: TToolButton;
    tbMakeBackup: TToolButton;
    ToolButton2: TToolButton;
    tbAbout: TToolButton;
    ilToolBarDisabled: TImageList;
    ilToolBar: TImageList;
    sbMain: TStatusBar;
    miDEBUG_TEST: TMenuItem;
    miDEBUG_TEST1: TMenuItem;
    ePageNumber: TEdit;
    bGo: TButton;
    miOpen: TMenuItem;
    mOriginalLeft: TMemo;
    eLeft0: TEdit;
    eLeft1: TEdit;
    eLeft2: TEdit;
    eLeft3: TEdit;
    eLeft4: TEdit;
    mOriginalRight: TMemo;
    eRight0: TEdit;
    eRight1: TEdit;
    eRight2: TEdit;
    eRight3: TEdit;
    eRight4: TEdit;
    eRightPageNumber: TJvEdit;
    N1: TMenuItem;
    miQuit: TMenuItem;
    bFirst: TButton;
    bLast: TButton;
    miDEBUG_TEST2: TMenuItem;
    sdExport: TSaveDialog;
    odImport: TOpenDialog;
    aeMain: TApplicationEvents;
    miExport: TMenuItem;
    N2: TMenuItem;
    miDEBUG_TEST3: TMenuItem;
    eLeftCode0: TEdit;
    eLeftCode1: TEdit;
    eLeftCode2: TEdit;
    eLeftCode3: TEdit;
    eLeftCode4: TEdit;
    eRightCode0: TEdit;
    eRightCode1: TEdit;
    eRightCode2: TEdit;
    eRightCode3: TEdit;
    eRightCode4: TEdit;
    Label1: TLabel;
    bvlBottom: TBevel;
    Label2: TLabel;
    miSaveAs: TMenuItem;
    miDEBUG_TEST4: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    miDEBUG_TEST5: TMenuItem;
    miDEBUG_TEST6: TMenuItem;
    miSave: TMenuItem;
    miDEBUG_TEST7: TMenuItem;
    miDEBUG_TEST8: TMenuItem;
    N5: TMenuItem;
    miDEBUG_TEST9: TMenuItem;
    miView: TMenuItem;
    miHelp: TMenuItem;
    miOptions: TMenuItem;
    miMakeBackup: TMenuItem;
    miDebugLog: TMenuItem;
    N6: TMenuItem;
    miGoLastPage: TMenuItem;
    miGoFirstPage: TMenuItem;
    miGoNextPage: TMenuItem;
    miGoPreviousPage: TMenuItem;
    miReload: TMenuItem;
    N7: TMenuItem;
    miClose: TMenuItem;
    miAutoSave: TMenuItem;
    N8: TMenuItem;
    miImport: TMenuItem;
    miProjectHome: TMenuItem;
    miCheckForUpdate: TMenuItem;
    N9: TMenuItem;
    miAbout: TMenuItem;
    ToolButton3: TToolButton;
    N10: TMenuItem;
    miDEBUG_TEST10: TMenuItem;
    ToolButton5: TToolButton;
    tbImport: TToolButton;
    tbExport: TToolButton;
    N11: TMenuItem;
    miDEBUG_TEST11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    miProperties: TMenuItem;
    tbProperties: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNextClick(Sender: TObject);
    procedure bGoClick(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure bPrevClick(Sender: TObject);
    procedure tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure miDEBUG_TEST1Click(Sender: TObject);
    procedure miQuitClick(Sender: TObject);
    procedure bFirstClick(Sender: TObject);
    procedure bLastClick(Sender: TObject);
    procedure miDEBUG_TEST2Click(Sender: TObject);
    procedure miExportClick(Sender: TObject);
    procedure miDEBUG_TEST3Click(Sender: TObject);
    procedure ePageNumberKeyPress(Sender: TObject; var Key: Char);
    procedure eLeft0Change(Sender: TObject);
    procedure eLeftCode0Change(Sender: TObject);
    procedure eLeft0Enter(Sender: TObject);
    procedure miSaveAsClick(Sender: TObject);
    procedure miDEBUG_TEST4Click(Sender: TObject);
    procedure miDEBUG_TEST5Click(Sender: TObject);
    procedure miDEBUG_TEST6Click(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure miDEBUG_TEST7Click(Sender: TObject);
    procedure miDEBUG_TEST8Click(Sender: TObject);
    procedure miDEBUG_TEST9Click(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miAutoSaveClick(Sender: TObject);
    procedure miDebugLogClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure aeMainException(Sender: TObject; E: Exception);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miDEBUG_TEST10Click(Sender: TObject);
    procedure miMakeBackupClick(Sender: TObject);
    procedure aeMainHint(Sender: TObject);
    procedure miReloadClick(Sender: TObject);
    procedure miDEBUG_TEST11Click(Sender: TObject);
    procedure miImportClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miProjectHomeClick(Sender: TObject);
    procedure miCheckForUpdateClick(Sender: TObject);
    procedure miPropertiesClick(Sender: TObject);
    procedure eLeft0KeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
    fPageNumber: Integer;
    fFileModified: Boolean;
    fSelectedMessage: TDiaryEditorMessagesListItem;
    fSelectedFlagCodeEdit: TEdit;
    fAutoSave: Boolean;
    fDebugLogVisible: Boolean;
    fQuitOnFailure: Boolean;
    fMakeBackup: Boolean;
    fFilePropertiesVisible: Boolean;
    fSelectedLineIndex: Integer;
    fSelectedPageIndex: Integer;
    fSelectedPagePosition: TPagePosition;
    procedure BugsHandlerExceptionCallBack(Sender: TObject;
      ExceptionMessage: string);
    procedure BugsHandlerSaveLogRequest(Sender: TObject);
    procedure BugsHandlerQuitRequest(Sender: TObject);    
    procedure ClearEdits(PageType: TPagePosition);
    procedure DebugLogExceptionEvent(Sender: TObject; E: Exception);
    procedure DebugLogMainFormToFront(Sender: TObject);
    procedure DebugLogVisibilityChange(Sender: TObject; const Visible: Boolean);
    procedure DebugLogWindowActivated(Sender: TObject);    
    procedure FreeModules;
    procedure InitBugsHandler;    
    procedure InitDebugLog;
    procedure InitModules;
    procedure InitUI;
    function GetLineEdit(Page: TPagePosition; const LineIndex: Integer;
      var LineEditCtrl, TimeCodeEditCtrl: TEdit): Boolean; overload;
    function GetLineEdit(Page: TPagePosition; const LineIndex: Integer;
      var LineEditCtrl: TEdit): Boolean; overload;
    function GetOriginalTextMemo(Page: TPagePosition): TMemo;
    procedure SetPageNumber(const Value: Integer);
    function GetStatusText: string;
    procedure RetrieveSelectedLineInfo(Sender: TEdit;
      var LineIndex, PageIndex: Integer; var PagePosition: TPagePosition;
      var FlagCodeEdit: TEdit);    
    procedure SetAutoSave(const Value: Boolean);
    procedure SetControlsStateFileOperations(State: Boolean);
    procedure SetControlsStateSaveOperation(State: Boolean);
    procedure SetDebugLogVisible(const Value: Boolean);
    procedure SetFileModified(const Value: Boolean);
    procedure SetStatusText(const Value: string);
    procedure SetMakeBackup(const Value: Boolean);
    procedure SetFilePropertiesVisible(const Value: Boolean);
    property SelectedFlagCodeEdit: TEdit read fSelectedFlagCodeEdit;
    property QuitOnFailure: Boolean read fQuitOnFailure write fQuitOnFailure;    
  public
    { Déclarations publiques }
    procedure Clear(const OnlyUI: Boolean); overload;
    procedure Clear; overload;
    function LoadPage(const LeftPageIndex: Integer): Boolean;
    function MsgBox(const Text, Title: string; Flags: Integer): Integer;
    function SaveFileOnDemand(const CancelButton: Boolean): Boolean;
    property AutoSave: Boolean read fAutoSave write SetAutoSave;
    property DebugLogVisible: Boolean read fDebugLogVisible
      write SetDebugLogVisible;
    property FileModified: Boolean read fFileModified write SetFileModified;
    property FilePropertiesVisible: Boolean read fFilePropertiesVisible
      write SetFilePropertiesVisible;
    property MakeBackup: Boolean read fMakeBackup write SetMakeBackup;    
    property PageNumber: Integer read fPageNumber write SetPageNumber;
    property SelectedMessage: TDiaryEditorMessagesListItem
      read fSelectedMessage;
    property SelectedPageIndex: Integer read fSelectedPageIndex;
    property SelectedLineIndex: Integer read fSelectedLineIndex;
    property SelectedPagePosition: TPagePosition read fSelectedPagePosition;
    property StatusText: string read GetStatusText write SetStatusText;    
  end;

var
  frmMain: TfrmMain;
  DiaryEditor: TDiaryEditor;
  DebugLog: TDebugLogHandlerInterface;
  BugsHandler: TBugsHandlerInterface;
  
implementation

{$R *.dfm}

uses
  UITools, SysTools, FileSel, Config, About, FileProp;
  
procedure TfrmMain.bGoClick(Sender: TObject);
begin
  PageNumber := StrToIntDef(ePageNumber.Text, PageNumber);
end;

procedure TfrmMain.bPrevClick(Sender: TObject);
begin
  PageNumber := PageNumber - 2;
end;

procedure TfrmMain.BugsHandlerExceptionCallBack(Sender: TObject;
  ExceptionMessage: string);
begin
  DebugLog.AddLine(ltCritical, ExceptionMessage);
end;

procedure TfrmMain.BugsHandlerQuitRequest(Sender: TObject);
begin
  QuitOnFailure := True;
  Close;
end;

procedure TfrmMain.BugsHandlerSaveLogRequest(Sender: TObject);
begin
  DebugLog.SaveLogFile;
end;

procedure TfrmMain.aeMainException(Sender: TObject; E: Exception);
begin
  BugsHandler.Execute(Sender, E);  
  aeMain.CancelDispatch;
end;

procedure TfrmMain.aeMainHint(Sender: TObject);
begin
  StatusText := Application.Hint;
  aeMain.CancelDispatch;
end;

procedure TfrmMain.bFirstClick(Sender: TObject);
begin
  PageNumber := 0;
end;

procedure TfrmMain.bLastClick(Sender: TObject);
begin
  PageNumber := DiaryEditor.Pages.Count - 1;
end;

procedure TfrmMain.bNextClick(Sender: TObject);
begin
  PageNumber := PageNumber + 2;
end;

procedure TfrmMain.Clear(const OnlyUI: Boolean);
begin
  if not OnlyUI then
    DiaryEditor.Clear;

  fSelectedMessage := nil;
  FileModified := False;
  StatusText := '';
  ClearEdits(ppLeft);
  ClearEdits(ppRight);
  PageNumber := 0;
  SetControlsStateFileOperations(False);
  SetControlsStateSaveOperation(False);
  if Assigned(frmProperties) then  
    frmProperties.Clear;
end;

procedure TfrmMain.Clear;
begin
  Clear(False);
end;

procedure TfrmMain.ClearEdits(PageType: TPagePosition);
var
  i: Integer;
  LineEditCtrl, TimeCodeLineCtrl: TEdit;

begin
  for i := 0 to 4 do begin
    if GetLineEdit(PageType, i, LineEditCtrl, TimeCodeLineCtrl) then begin
      // Disabling events
      LineEditCtrl.OnChange := nil;
      TimeCodeLineCtrl.OnChange := nil;

      // Disabling fields
      ChangeEditEnabledState(LineEditCtrl, False);
      ChangeEditEnabledState(TimeCodeLineCtrl, False);

      // Deleting text
      LineEditCtrl.Text := '';
      TimeCodeLineCtrl.Text := '';
    end;
  end;
  GetOriginalTextMemo(PageType).Clear;
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

procedure TfrmMain.eLeft0Change(Sender: TObject);
begin
  // Setting the new text
  if DiaryEditor.Loaded then begin
    FileModified := True;
    SelectedMessage.Text := (Sender as TEdit).Text;
    ChangeEditEnabledState(SelectedFlagCodeEdit, SelectedMessage.Text <> '');
    if (SelectedMessage.Text <> '') and (SelectedFlagCodeEdit.Text = '') then
      SelectedFlagCodeEdit.Text := '0';
  end;
end;

procedure TfrmMain.eLeft0Enter(Sender: TObject);
begin
  fSelectedMessage := nil;
  if DiaryEditor.Loaded then begin
    // Getting UI infos
    RetrieveSelectedLineInfo(Sender as TEdit, fSelectedLineIndex,
      fSelectedPageIndex, fSelectedPagePosition, fSelectedFlagCodeEdit);

    // Setting the Form properties
    fSelectedMessage :=
      DiaryEditor.Pages[SelectedPageIndex].Messages[SelectedLineIndex];
  end;
end;

procedure TfrmMain.eLeft0KeyPress(Sender: TObject; var Key: Char);
var
  NextLineCtrl: TEdit;
  OK, LineFocused: Boolean;
  NextLineIndex: Integer;
  WorkPage: TPagePosition;
  
begin
  if Key = Chr(VK_RETURN) then begin
    Key := #0;

    // Calculate the next Line field
    WorkPage := SelectedPagePosition;
    NextLineIndex := SelectedLineIndex;
    LineFocused := False;
    
    repeat
      Inc(NextLineIndex);
    
      // Setting the page if needed
      if (NextLineIndex > 4) then begin
        NextLineIndex := 0;
        case WorkPage of
          ppLeft:   WorkPage := ppRight;
          ppRight:  WorkPage := ppLeft;
        end;
      end;               
                
      // Focusing the Line edit requested
      OK := GetLineEdit(WorkPage, NextLineIndex, NextLineCtrl);
      if OK and NextLineCtrl.Enabled then begin
        NextLineCtrl.SetFocus;
        EditSetCaretEndPosition(NextLineCtrl.Handle);
        LineFocused := True;
      end;      
    until LineFocused;
    
  end; // VK_RETURN
end;

procedure TfrmMain.eLeftCode0Change(Sender: TObject);
begin
  if (DiaryEditor.Loaded) and Assigned(SelectedMessage) then begin
    FileModified := True;  
    SelectedMessage.FlagCode := StrToIntDef((Sender as TEdit).Text, 0);
  end;
end;

procedure TfrmMain.ePageNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_RETURN) then begin
    bGo.Click;
    Key := #0;
  end;
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
  miDEBUG_TEST.Visible := False;
{$ENDIF}

  // Start Initializing...
  aeMain.OnException := nil;

  // Creating Internal Modules
  InitModules;

  // Load configuration
  LoadConfig;

  // Init the GUI
  InitUI;
  Clear;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Saving configuration
  SaveConfig;
  
  // Destroying application
  FreeModules;
end;

procedure TfrmMain.FreeModules;
begin
  // Disabling the Close button
  miQuit.Enabled := False;
  SetCloseWindowButtonState(Self, False);
  
  // Destroying the Diary Editor
  DiaryEditor.Free;

  // Destroying the Debug Log
  DebugLog.Free;

  // Cleaning Bugs Handler
  BugsHandler.Free;
end;

function TfrmMain.GetLineEdit(Page: TPagePosition;
  const LineIndex: Integer; var LineEditCtrl, TimeCodeEditCtrl: TEdit): Boolean;
var
  TimeCodeEditName: string;
  LineEditOk: Boolean;
  
begin
  // Retrieve the Line Edit
  LineEditOk := GetLineEdit(Page, LineIndex, LineEditCtrl);

  // Search the TimeCode Edit on the Form
  TimeCodeEditName := 'e' + PagePositionToString(Page) + 'Code' + IntToStr(LineIndex);
  TimeCodeEditCtrl := FindComponent(TimeCodeEditName) as TEdit;

  Result := LineEditOk and Assigned(TimeCodeEditCtrl);
end;

function TfrmMain.GetLineEdit(Page: TPagePosition; const LineIndex: Integer;
  var LineEditCtrl: TEdit): Boolean;
var
  LineEditName: string;

begin
  // Build the TEdit.Name
  LineEditName := 'e' + PagePositionToString(Page) + IntToStr(LineIndex);

  // Search the Edits on the Form
  LineEditCtrl := FindComponent(LineEditName) as TEdit;

  Result := Assigned(LineEditCtrl);
end;

function TfrmMain.GetOriginalTextMemo(Page: TPagePosition): TMemo;
begin
  Result := nil;
  case Page of
    ppLeft: Result := mOriginalLeft;
    ppRight: Result := mOriginalRight;
  end;
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
      DebugLog.Report(ltWarning, 'Unable to initialize the Bugs Handler!',
        'Reason: "' + E.Message + '"');
  end;
end;

procedure TfrmMain.InitDebugLog;
begin
  DebugLog := TDebugLogHandlerInterface.Create;
  with DebugLog do begin
    // Setting up events
    OnException := DebugLogExceptionEvent;
    OnMainWindowBringToFront := DebugLogMainFormToFront;
    OnVisibilityChange := DebugLogVisibilityChange;
    OnWindowActivated := DebugLogWindowActivated;
  end;

  // Setting up the properties
  DebugLog.Configuration := Configuration; // in this order!
end;

procedure TfrmMain.InitModules;
begin
  // Init the Bugs Handler
  InitBugsHandler;
  
  // Init the Debug Log
  InitDebugLog;
  
  // Init the Main Object
  DiaryEditor := TDiaryEditor.Create;
end;

procedure TfrmMain.InitUI;

  procedure InitTimeCodeEdits(PagePosition: TPagePosition);
  var
    i: Integer;
    Null, EditCtrl: TEdit;

  begin
    for i := 0 to 4 do
      if GetLineEdit(PagePosition, i, Null, EditCtrl) then
        MakeNumericOnly(EditCtrl.Handle);
  end;

begin
  Caption := Application.Title + ' v' + GetApplicationVersion;
  MakeNumericOnly(ePageNumber.Handle);

  // Init TimeCode edits
  InitTimeCodeEdits(ppLeft);
  InitTimeCodeEdits(ppRight);

  // Init Toolbar
  ToolBarInitControl(Self, tbMain);

//  Constraints.MinHeight := Height;
//  Constraints.MinWidth := Width;

  // Init the About Box
  InitAboutBox(
    Application.Title,
    GetApplicationVersion
  );  
end;

function TfrmMain.LoadPage(const LeftPageIndex: Integer): Boolean;
var
  RightPageIndex: Integer;
  LineEditCtrl, TimeCodeEditCtrl: TEdit;
  UIReady: Boolean;

  function LoadSinglePage(const PageIndex: Integer; Page: TPagePosition): Boolean;
  var
    Messages: TDiaryEditorMessagesList;
    i: Integer;
    MemoCtrl: TMemo;

  begin
    Result := False;

    // Retrieving messages
    Messages := nil;
    if (PageIndex >= 0) and (PageIndex < DiaryEditor.Pages.Count) then
      Messages := DiaryEditor.Pages[PageIndex].Messages;

    // If Messages are available...
    if Assigned(Messages) then begin
      // Prepare UI
      ClearEdits(Page);
      MemoCtrl := GetOriginalTextMemo(Page);

      // Fill UI
      for i := 0 to Messages.Count - 1 do begin
        MemoCtrl.Lines.Add(Messages[i].Text);
        UIReady := GetLineEdit(Page, i, LineEditCtrl, TimeCodeEditCtrl);

        // disabling temporary the event
        LineEditCtrl.OnChange := nil;
        TimeCodeEditCtrl.OnChange := nil;

        // filling the edit
        if Messages[i].Editable and UIReady then begin
            ChangeEditEnabledState(LineEditCtrl, True);
            TimeCodeEditCtrl.Text := IntToStr(Messages[i].FlagCode);
            if Messages[i].Text <> '' then begin
              LineEditCtrl.Text := Messages[i].Text;
              ChangeEditEnabledState(TimeCodeEditCtrl, True);
            end;
        end; // Editable and UIReady

        // Resetting the event
        TimeCodeEditCtrl.OnChange := eLeftCode0Change;
        LineEditCtrl.OnChange := eLeft0Change;
      end; // for

      Result := True;
    end; // Assigned

  end;

begin
  // Left page
  Result := LoadSinglePage(LeftPageIndex, ppLeft);

  // Right page
  RightPageIndex := LeftPageIndex + 1;

  if (RightPageIndex < DiaryEditor.Pages.Count) then
    Result := Result and LoadSinglePage(RightPageIndex, ppRight)
  else
    ClearEdits(ppRight);
end;

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
  RunAboutBox;
end;

procedure TfrmMain.miAutoSaveClick(Sender: TObject);
begin
  AutoSave := not AutoSave;
end;

procedure TfrmMain.miCheckForUpdateClick(Sender: TObject);
begin
  OpenLink('https://sourceforge.net/projects/shenmuesubs/files/');
end;

procedure TfrmMain.miCloseClick(Sender: TObject);
begin
  if not SaveFileOnDemand(True) then Exit;
  Clear;
  DebugLog.AddLine(ltInformation, 'Close successfully done for "' +
    DiaryEditor.DataSourceFileName + '".');
end;

procedure TfrmMain.miDebugLogClick(Sender: TObject);
begin
  DebugLogVisible := not DebugLogVisible;
end;

procedure TfrmMain.miDEBUG_TEST10Click(Sender: TObject);
{$IFDEF DEBUG}
begin
  raise EDivByZero.Create('BLAH!!!');
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST11Click(Sender: TObject);
{$IFDEF DEBUG}
begin
  MakeNumericOnly(ePageNumber.Handle);
//  ePageNumber.Enabled := True;
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST1Click(Sender: TObject);
{$IFDEF DEBUG}
begin
  DiaryEditor.LoadFromFile('memodata.bin', 'memoflg.bin');
//  DiaryEditor.Pages[2].Messages[0].Text := '@55555\eåöåúåúåúåúåúåúåúæ£!';
//  DiaryEditor.Pages[269].Messages[0].Text := 'K-OTIC!!!!';
  DiaryEditor.SaveToFile('memodata.hak', 'memoflg.hak');
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST2Click(Sender: TObject);
{$IFDEF DEBUG}
var
  S: string;
  p: Integer;
  m: Integer;

begin

  // 1st phase
  DiaryEditor.LoadFromFile('MEMODATA.BIN', 'MEMOFLG.BIN');
  DiaryEditor.Pages.ExportToFile('MEMODATA.XML');

  for p := 0 to DiaryEditor.Pages.Count - 1 do
    for m := 0 to DiaryEditor.Pages[p].Messages.Count - 1 do begin
      S := GetRandomString(19);
      if DiaryEditor.Pages[p].Messages[m].Editable then begin
        DiaryEditor.Pages[p].Messages[m].Text := S;
        DiaryEditor.Pages[p].Messages[m].FlagCode := Random(9999) + 1;
      end;
    end;

  DiaryEditor.SaveToFile('STRONG.HAK', 'STRONGFLG.HAK');

  // 2nd phase
  DiaryEditor.LoadFromFile('STRONG.HAK', 'STRONGFLG.HAK');
  DiaryEditor.Pages.ImportFromFile('MEMODATA.XML');
  DiaryEditor.SaveToFile('STRONG.NEW', 'STRONGFLG.NEW');

{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST3Click(Sender: TObject);
{$IFDEF DEBUG}

  procedure _exp(const Extension: TFileName);
  begin
    DiaryEditor.LoadFromFile('MEMODATA.' + Extension, 'MEMOFLG.' + Extension);
    DiaryEditor.Pages.ExportToCSV(
      'MSTR' + ExtractFileExt(DiaryEditor.DataSourceFileName) + '.CSV'
    );
  end;

begin
  _exp('ENG');
  _exp('FRE');
  _exp('GER');
  _exp('SPA');
  _exp('XB');
  _exp('XBD');

{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST4Click(Sender: TObject);
{$IFDEF DEBUG}
var
  S: string;
  p, m, i: Integer;

begin

  // 1st phase
  DiaryEditor.LoadFromFile('MEMODATA.BIN', 'MEMOFLG.BIN');
  DiaryEditor.Pages.ExportToFile('MEMODATA.XML');
  i := 0;

  repeat
    WriteLn('*** START PASS ', i, ' ***');

    for p := 0 to DiaryEditor.Pages.Count - 1 do
      for m := 0 to DiaryEditor.Pages[p].Messages.Count - 1 do begin
        S := GetRandomString(19);
        if DiaryEditor.Pages[p].Messages[m].Editable then begin
          DiaryEditor.Pages[p].Messages[m].Text := S;
          DiaryEditor.Pages[p].Messages[m].FlagCode := Random(9999) + 1;
        end;
      end;

    DiaryEditor.SaveToFile('STRONG.HAK', 'STRONGFLG.HAK');
    DiaryEditor.LoadFromFile('STRONG.HAK', 'STRONGFLG.HAK');

    WriteLn('*** END PASS ', i, ' ***');
    Inc(i);
  until i = 20;

  // 2nd phase
  DiaryEditor.Pages.ImportFromFile('MEMODATA.XML');
  DiaryEditor.SaveToFile('STRONG.NEW', 'STRONGFLG.NEW');

{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST5Click(Sender: TObject);
{$IFDEF DEBUG}
begin
  DiaryEditor.DumpStringDependancies('STRDEPS.CSV');
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST6Click(Sender: TObject);
{$IFDEF DEBUG}
var
  S: string;
  p, m, i: Integer;

begin

  // 1st phase
  DiaryEditor.LoadFromFile('MEMODATA.HAK', 'RETAIL.HAK');
  DiaryEditor.Pages.ExportToFile('MEMODATA.XML');
  i := 0;

  repeat
    WriteLn('*** START PASS ', i, ' ***');

    for p := 0 to DiaryEditor.Pages.Count - 1 do
      for m := 0 to DiaryEditor.Pages[p].Messages.Count - 1 do begin
        S := GetRandomString(19);
        if DiaryEditor.Pages[p].Messages[m].Editable then begin
          DiaryEditor.Pages[p].Messages[m].Text := S;
          DiaryEditor.Pages[p].Messages[m].FlagCode := Random(9999) + 1;
        end;
      end;

    DiaryEditor.SaveToFile('XBOXMEMO.HAK', 'XBOXFLG.HAK');
    DiaryEditor.LoadFromFile('XBOXMEMO.HAK', 'XBOXFLG.HAK');

    WriteLn('*** END PASS ', i, ' ***', sLineBreak);
    Inc(i);
  until i = 20;

  // 2nd phase
  DiaryEditor.Pages.ImportFromFile('MEMODATA.XML');
  DiaryEditor.SaveToFile('XBOXMEMO.NEW', 'XBOXFLG.NEW');

{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST7Click(Sender: TObject);
{$IFDEF DEBUG}
var
  S: string;
  p, m, i: Integer;

begin

  // 1st phase
  DiaryEditor.LoadFromFile('MEMODATA.HAK', 'RETAIL.HAK');
  DiaryEditor.Pages.ExportToFile('MEMODATA.XML');
  i := 0;

  repeat
    WriteLn('*** START PASS ', i, ' ***');

    for p := 0 to DiaryEditor.Pages.Count - 1 do
      for m := 0 to DiaryEditor.Pages[p].Messages.Count - 1 do begin
        S := GetRandomString(19);
        if DiaryEditor.Pages[p].Messages[m].Editable then begin
          DiaryEditor.Pages[p].Messages[m].Text := S;
          DiaryEditor.Pages[p].Messages[m].FlagCode := Random(9999) + 1;
        end;
      end;

    DiaryEditor.Save;

    WriteLn('*** END PASS ', i, ' ***', sLineBreak);
    Inc(i);
  until i = 20;

  // 2nd phase
  DiaryEditor.Pages.ImportFromFile('MEMODATA.XML');
  DiaryEditor.Save;

{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST8Click(Sender: TObject);
{$IFDEF DEBUG}
var
  i: Integer;

begin
  DiaryEditor.LoadFromFile('MEMODATA.TST', 'MEMOFLG.TST');
  for i := 0 to 6 do begin
    DiaryEditor.Pages[5].Messages[0].Text := 'RELOAD_TEST_' + GetRandomString(90);
    DiaryEditor.Save;
    DiaryEditor.Reload;
  end;
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST9Click(Sender: TObject);
{$IFDEF DEBUG}
var
  i: Integer;

begin
  DiaryEditor.LoadFromFile('MEMODATA.TST', 'RETAIL.HAK');
  for i := 0 to 6 do begin
    DiaryEditor.Pages[5].Messages[0].Text := 'RELOAD_TEST_' + GetRandomString(90);
    DiaryEditor.Save;
    DiaryEditor.Reload;
  end;
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miExportClick(Sender: TObject);
begin
  with sdExport do
    if Execute then begin
      StatusText := 'Exporting...';
      if DiaryEditor.Pages.ExportToFile(FileName) then
        DebugLog.AddLine(ltInformation, 'Notebook data successfully exported to "'
          + FileName + '".')
      else
        DebugLog.Report(ltWarning, 'Unable to export the Notebook data.',
          'FileName: "' + FileName + '"');
      StatusText := '';
    end;
end;

procedure TfrmMain.miImportClick(Sender: TObject);
begin
  with odImport do
    if Execute then begin
      StatusText := 'Importing...';
      if DiaryEditor.Pages.ImportFromFile(FileName) then begin
        DebugLog.AddLine(ltInformation, 'Notebook data successfully imported from "'
          + FileName + '".');
        PageNumber := PageNumber; // reload info...
        FileModified := True;
      end else
        DebugLog.Report(ltWarning, 'Unable to import the Notebook data.',
          'FileName: "' + FileName + '"');
      StatusText := '';
    end;
end;

procedure TfrmMain.miMakeBackupClick(Sender: TObject);
begin
  MakeBackup := not MakeBackup;
end;

procedure TfrmMain.miOpenClick(Sender: TObject);
begin
  with frmFileSelection do begin
    SelectionMode := fsmOpen;
    ShowModal;
    if ModalResult = mrOK then begin
      StatusText := 'Loading Notebook data...';
      Clear;
      if DiaryEditor.LoadFromFile(SelectedDataFile, SelectedFlagFile) then begin
        frmProperties.RefreshInfos;
        SetControlsStateFileOperations(True);      
        PageNumber := 0;
        DebugLog.AddLine(ltInformation, 'Load successfully done for "'
          + DiaryEditor.DataSourceFileName + '".');
      end;
      StatusText := '';
    end;
  end;
end;

procedure TfrmMain.miProjectHomeClick(Sender: TObject);
begin
  OpenLink('http://shenmuesubs.sourceforge.net/');
end;

procedure TfrmMain.miPropertiesClick(Sender: TObject);
begin
  FilePropertiesVisible := not FilePropertiesVisible;
end;

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miReloadClick(Sender: TObject);
var
  OldPageNumber: Integer;
  
begin
  if not SaveFileOnDemand(True) then Exit;

  OldPageNumber := PageNumber;
  StatusText := 'Reloading...';
  Clear(True);
  if DiaryEditor.Reload then begin
    SetControlsStateFileOperations(True);
    PageNumber := OldPageNumber; // reloading...
    DebugLog.AddLine(ltInformation, 'Successfully reloaded the file "'
      + DiaryEditor.DataSourceFileName + '".');
    frmProperties.RefreshInfos;
  end else
    DebugLog.Report(ltWarning, 'Unable to reload the file from disk!',
        'DataSource: "' + DiaryEditor.DataSourceFileName + '" '
      + 'FlagSource: "' + DiaryEditor.FlagSourceFileName + '"');

  StatusText := '';
end;

procedure TfrmMain.miSaveAsClick(Sender: TObject);
begin
  with frmFileSelection do begin
    SelectionMode := fsmSave;
    ShowModal;
    if ModalResult = mrOK then begin
      StatusText := 'Saving Notebook data...';
      if DiaryEditor.SaveToFile(SelectedDataFile, SelectedFlagFile) then
        DebugLog.AddLine(ltInformation, 'Save successfully done to "'
          + SelectedDataFile + '" and "' + SelectedFlagFile + '".')
      else
        DebugLog.Report(ltWarning, 'Unable to save the modified file!',
          'FileName: "' + SelectedDataFile + '"');
      StatusText := '';
      frmProperties.RefreshInfos;        
    end;
  end;
end;

procedure TfrmMain.miSaveClick(Sender: TObject);
begin
  StatusText := 'Saving Notebook data...';
  if DiaryEditor.Save then
    DebugLog.AddLine(ltInformation, 'Memo data successfully saved.')
  else
    DebugLog.Report(ltWarning, 'Unable to save the data!', 'FileName: "'
      + DiaryEditor.DataSourceFileName + '"');
  StatusText := '';
  FileModified := False;
  frmProperties.RefreshInfos;  
end;

function TfrmMain.MsgBox(const Text, Title: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Title), Flags);
end;

procedure TfrmMain.RetrieveSelectedLineInfo(Sender: TEdit;
  var LineIndex, PageIndex: Integer; var PagePosition: TPagePosition;
  var FlagCodeEdit: TEdit);
var
  FlagCodeEditName: string;

begin
  LineIndex := (Sender as TEdit).Tag;
  PageIndex := PageNumber; // PageNumber is the GUI value

  PagePosition := ppLeft;
  FlagCodeEditName := 'Left';

  if FindStr('Right', (Sender as TEdit).Name) then begin
    PagePosition := ppRight;
    Inc(PageIndex);
    FlagCodeEditName := 'Right';
  end;

  FlagCodeEditName := 'e' + FlagCodeEditName + 'Code' + IntToStr(LineIndex);
  FlagCodeEdit := FindComponent(FlagCodeEditName) as TEdit;
end;

function TfrmMain.SaveFileOnDemand(const CancelButton: Boolean): Boolean;
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
  miAutoSave.Checked := Value;
  tbAutoSave.Down := Value;
end;

procedure TfrmMain.SetControlsStateFileOperations(State: Boolean);
begin
  miClose.Enabled := State;
  miImport.Enabled := State;
  tbImport.Enabled := State;
  miExport.Enabled := State;
  tbExport.Enabled := State;
  miReload.Enabled := State;
  tbReload.Enabled := State;
end;

procedure TfrmMain.SetControlsStateSaveOperation(State: Boolean);
begin
  tbSave.Enabled := State;
  miSave.Enabled := State;
  miSaveAs.Enabled := State;
end;

procedure TfrmMain.SetDebugLogVisible(const Value: Boolean);
begin
  DebugLog.Active := Value;
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

procedure TfrmMain.SetFilePropertiesVisible(const Value: Boolean);
begin
  if fFilePropertiesVisible <> Value then begin
    fFilePropertiesVisible := Value;
    miProperties.Checked := Value;
    tbProperties.Down := Value;
    
    if Value then
      frmProperties.Show
    else
      if frmProperties.Visible then
        frmProperties.Close;
  end;
end;

procedure TfrmMain.SetMakeBackup(const Value: Boolean);
begin
  fMakeBackup := Value;
  miMakeBackup.Checked := fMakeBackup;
  tbMakeBackup.Down := fMakeBackup;
  DiaryEditor.MakeBackup := fMakeBackup;
end;

procedure TfrmMain.SetPageNumber(const Value: Integer);
var
  OldValue: Integer;
  RightPageIndex: Integer;

begin
  OldValue := fPageNumber;          
  fPageNumber := Value;

  // Only the Left page is used here...
  if (fPageNumber mod 2 = 1) then
    Dec(fPageNumber);

  // Load the page
  if not LoadPage(fPageNumber) then begin
    fPageNumber := OldValue;
    LoadPage(OldValue);
  end;
  RightPageIndex := fPageNumber + 1;

  // Update UI
  bGo.Enabled := DiaryEditor.Loaded;
  ePageNumber.Enabled := DiaryEditor.Loaded;
  bPrev.Enabled := (fPageNumber > 0) and DiaryEditor.Loaded;
  miGoPreviousPage.Enabled := bPrev.Enabled;
  bNext.Enabled := (RightPageIndex < DiaryEditor.Pages.Count - 1) and DiaryEditor.Loaded;
  miGoNextPage.Enabled := bNext.Enabled;
  bLast.Enabled := bNext.Enabled;
  miGoLastPage.Enabled := bLast.Enabled;  
  bFirst.Enabled := bPrev.Enabled;
  miGoFirstPage.Enabled := bFirst.Enabled;
  ePageNumber.Text := IntToStr(fPageNumber);
  eRightPageNumber.Text := IntToStr(RightPageIndex);
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
  ToolBarCustomDraw(tbMain);
end;

end.
