unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SeqEdit, ComCtrls, Menus, ImgList, ToolWin, JvExComCtrls,
  JvToolBar, DebugLog, AppEvnts, BugsMgr, Viewer, JvListView;

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
    miOpen: TMenuItem;
    miView: TMenuItem;
    miHelp: TMenuItem;
    miDEBUG: TMenuItem;
    miDEBUG_TEST1: TMenuItem;
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
    N5: TMenuItem;
    miOriginal: TMenuItem;
    miOriginalColumn: TMenuItem;
    N6: TMenuItem;
    tbCharset: TToolButton;
    tbOriginal: TToolButton;
    miProjectHome: TMenuItem;
    N7: TMenuItem;
    miCheckForUpdate: TMenuItem;
    miDEBUG_TEST3: TMenuItem;
    lvSubs: TJvListView;
    miDEBUG_TEST4: TMenuItem;
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
    miDEBUG_TEST5: TMenuItem;
    miImport: TMenuItem;
    N8: TMenuItem;
    miExport: TMenuItem;
    odImportSubs: TOpenDialog;
    sdExportSubs: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure miOpenClick(Sender: TObject);
    procedure miDEBUG_TEST1Click(Sender: TObject);
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
    procedure miProjectHomeClick(Sender: TObject);
    procedure miCheckForUpdateClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miOriginalClick(Sender: TObject);
    procedure miOriginalColumnClick(Sender: TObject);
    procedure miDEBUG_TEST3Click(Sender: TObject);
    procedure miDEBUG_TEST4Click(Sender: TObject);
    procedure miDEBUG_TEST5Click(Sender: TObject);
    procedure miImportClick(Sender: TObject);
    procedure miExportClick(Sender: TObject);
  private
    { DÈclarations privÈes }  
    fSelectedSubtitleUI: TListItem;
    fSelectedSubtitle: TSpecialSequenceSubtitleItem;
    fDebugLogVisible: Boolean;
    fFileModified: Boolean;
    fQuitOnFailure: Boolean;
    fPreviewerVisible: Boolean;
    fDecodeSubtitles: Boolean;
    fOriginalSubtitleField: Boolean;
    fOriginalSubtitleColumn: Boolean;
    fOriginalSubtitlesColumnObject: TListColumn;
    fOriginalSubtitlesColumnObjectWidth: Integer;
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
    procedure ModulesFree;
    procedure ModulesInit;
    function GetSelectedSubtitle: string;
    function GetStatusText: string;
    procedure InitBugsHandler;
    procedure InitDebugLog;
    procedure InitPreviewer;
    procedure LoadFile(FileName: TFileName);
    procedure PreviewerWindowClosed(Sender: TObject);
    function SaveFileOnDemand(CancelButton: Boolean): Boolean;
    procedure SetSelectedSubtitle(const Value: string);
    procedure SetStatusReady;
    procedure SetStatusText(const Value: string);
    procedure SetDebugLogVisible(const Value: Boolean);
    procedure SetControlsStateFileOperations(State: Boolean);
    procedure SetControlsStateSaveOperation(State: Boolean);
    procedure SetFileModified(const Value: Boolean);
    procedure RefreshOldTextField;
    function RefreshSubtitlesList(UpdateView: Boolean): Boolean;
    procedure RefreshSubtitleSelection;
    procedure UpdateFileModifiedState;
    procedure SetPreviewerVisible(const Value: Boolean);
    procedure SetDecodeSubtitles(const Value: Boolean);
    procedure SetOriginalSubtitleField(const Value: Boolean);
    procedure SetOriginalSubtitleColumn(const Value: Boolean);
    function GetSelectedSubtitleBackupText: string;
    property OriginalSubtitlesColumnObject: TListColumn
      read fOriginalSubtitlesColumnObject write fOriginalSubtitlesColumnObject;
    property OriginalSubtitlesColumnObjectWidth: Integer
      read fOriginalSubtitlesColumnObjectWidth write fOriginalSubtitlesColumnObjectWidth;
    property QuitOnFailure: Boolean read fQuitOnFailure write fQuitOnFailure;
  public
    { DÈclarations publiques }
    function IsSubtitleSelected: Boolean;
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
    property DebugLogVisible: Boolean read fDebugLogVisible
      write SetDebugLogVisible;
    property DecodeSubtitles: Boolean read fDecodeSubtitles
      write SetDecodeSubtitles;
    property FileModified: Boolean read fFileModified write SetFileModified;
    property OriginalSubtitleField: Boolean read fOriginalSubtitleField
      write SetOriginalSubtitleField;
    property OriginalSubtitlesColumn: Boolean read fOriginalSubtitleColumn
      write SetOriginalSubtitleColumn;
    property PreviewerVisible: Boolean read fPreviewerVisible
      write SetPreviewerVisible;
    property SelectedSubtitle: string read GetSelectedSubtitle
      write SetSelectedSubtitle;
    property SelectedSubtitleBackupText: string
      read GetSelectedSubtitleBackupText;
    property StatusText: string read GetStatusText write SetStatusText;
  end;

var
  frmMain: TfrmMain;
  SequenceEditor: TSpecialSequenceEditor;
  DebugLog: TDebugLogHandlerInterface;
  BugsHandler: TBugsHandlerInterface;
  Previewer: TSubtitlesPreviewer;

implementation

{$R *.dfm}

uses
  Config, UITools, SysTools, ChrCount, About, AppVer;

procedure TfrmMain.Clear(const UpdateOnlyUI: Boolean);
begin
  if not UpdateOnlyUI then begin
    SequenceEditor.Clear;
    lvSubs.Clear;
    fSelectedSubtitleUI := nil;
    fSelectedSubtitle := nil;
    mOldSub.Text := '';
    mNewSub.Text := '';
    UpdateSubtitleLengthControls('', eFirstLineLength, eSecondLineLength);
    eSubCount.Text := '0';
  end;

  UpdateFileModifiedState;
  SetControlsStateFileOperations(False);
  SetControlsStateSaveOperation(False);

  StatusText := '';
  FileModified := False;
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

procedure TfrmMain.miCheckForUpdateClick(Sender: TObject);
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

procedure TfrmMain.miDEBUG_TEST2Click(Sender: TObject);
begin
{$IFDEF DEBUG}  raise Exception.Create('TEST EXCEPTION'); {$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST3Click(Sender: TObject);
begin
{$IFDEF DEBUG}
  WriteLn(SequenceEditor.Subtitles.TransformText('If you will always be by my side,ÈÈ'));
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST4Click(Sender: TObject);
{$IFDEF DEBUG}
var
  i, j: Integer;

begin

  SequenceEditor.LoadFromFile('USA_DISC4.BIN');

  try
//    i := -1;
//    j := -1;

    for i := 1 to 20 do begin

      for j := 0 to SequenceEditor.Subtitles.Count - 1 do
        SequenceEditor.Subtitles[j].Text := GetRandomString(90);

      SequenceEditor.Save;
      Application.ProcessMessages;
    end;

  except
    on E:Exception do begin
//      E.Message := 'TEST: "' + E.Message + '". i = ' + IntToStr(i) + ', j = ' + IntToStr(j);
      raise;
    end;
  end;

{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST5Click(Sender: TObject);
{$IFDEF DEBUG}
const
  MAX_SUB = '____________________________________________' + sLineBreak
    + '____________________________________________';
begin
  // for NBIK test
  LoadFile('MAPINFO\NBIK_P_4.BIN');
  SequenceEditor.Subtitles[0].Text := MAX_SUB;
  SequenceEditor.Subtitles[10].Text := MAX_SUB;
  SequenceEditor.Save;
  LoadFile('MAPINFO\NBIK_P_4.BIN');
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miExportClick(Sender: TObject);
begin
  with sdExportSubs do begin
    FileName := ChangeFileExt(ExtractFileName(SequenceEditor.SourceFileName), '.xml');
    InitialDir := ExtractFilePath(SequenceEditor.SourceFileName);
    if Execute then begin
      SetStatusText('Exporting subtitles...');
      SequenceEditor.Subtitles.ExportToFile(FileName);
      DebugLog.AddLine(ltInformation, 'Subtitles was successfully exported from "'
        + ExtractFileName(SequenceEditor.SourceFileName) + '" to the "' + FileName + '" file.');
      SetStatusReady;
    end;
  end;
end;

procedure TfrmMain.miImportClick(Sender: TObject);
begin
  with odImportSubs do begin
    if Execute then begin
      SetStatusText('Importing subtitles...');
      if SequenceEditor.Subtitles.ImportFromFile(FileName) then begin
        RefreshSubtitlesList(True);
        SetFileModified(True);
        DebugLog.AddLine(ltInformation, 'Subtitles was successfully imported from the "' + FileName
          + '" file to the "'+ ExtractFileName(SequenceEditor.SourceFileName)
          + '" file.');
      end
      else begin
        DebugLog.AddLine(ltWarning, 'Subtitles importation: Error ª XML not valid for the current file.');
      end;
      SetStatusReady;
    end;
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
  miDEBUG.Visible := False;
{$ENDIF}

  aeMain.OnException := nil;

  // Init UI
  Caption := Application.Title + ' v' + GetApplicationVersion;
  ToolBarInitControl(Self, tbMain);
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;

  // 'Original' column
  fOriginalSubtitlesColumnObject := lvSubs.Columns[2];
  OriginalSubtitlesColumnObjectWidth := lvSubs.Columns[2].Width;
  OriginalSubtitlesColumn := True;
  
  // Init Modules
  ModulesInit;

  // Initialize the application
  Clear;

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

procedure TfrmMain.ModulesFree;
begin
  // Disabling the Close button
  miQuit.Enabled := False;
  SetCloseWindowButtonState(Self, False);

  // Destroying the Previewer
  Previewer.Free;
  
  // Destroying Special Sequence Editor
  SequenceEditor.Free;

  // Destroying Debug Log
  DebugLog.Free;

  // Cleaning Bugs Handler
  BugsHandler.Free;
end;

procedure TfrmMain.ModulesInit;
var
  CharsetFile: TFileName;

begin
  // Init Bugs Handler
  InitBugsHandler;

  // Init Debug Log
  InitDebugLog;

  // Init Special Sequence Editor
  SequenceEditor := TSpecialSequenceEditor.Create;

  // Load Charset
  CharsetFile := GetApplicationDataDirectory + 'chrlist1.csv';
  if FileExists(CharsetFile) then
    DecodeSubtitles := SequenceEditor.Charset.LoadFromFile(CharsetFile)
  else begin
    tbCharset.Enabled := False;
    miCharset.Enabled := False;
    DebugLog.Report(ltWarning, 'Sorry, the Charset list wasn''t found! The ' +
      'Shenmue Decode subtitle function won''t be available.',
      'FileName: "' + CharsetFile + '".');
  end;

  // Init the Previewer
  InitPreviewer;

  // Init the About Box
  InitAboutBox(
    Application.Title,
    GetApplicationVersion,
    'Special Scenes Editor'
  );  
end;

function TfrmMain.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmMain.PreviewerWindowClosed(Sender: TObject);
begin
  PreviewerVisible := False;
end;

procedure TfrmMain.miProjectHomeClick(Sender: TObject);
begin
  OpenLink('http://shenmuesubs.sourceforge.net/');
end;

procedure TfrmMain.RefreshOldTextField;
begin
  if OriginalSubtitleField then begin
    lOldSub.Caption := 'Original text:';
  end else begin
    lOldSub.Caption := 'Old text:';
  end;
  mOldSub.Text := SelectedSubtitleBackupText;
end;

procedure TfrmMain.RefreshSubtitleSelection;
begin
  if IsSubtitleSelected then
    lvSubsSelectItem(Self, fSelectedSubtitleUI, True);
end;

function TfrmMain.RefreshSubtitlesList;
var
  i, j: Integer;
  ListItem: TListItem;

begin
  Result := SequenceEditor.Loaded;

  // Filling the UI with the content
  if Result then begin
    // Display the subtitles count
    eSubCount.Text := IntToStr(SequenceEditor.Subtitles.Count);

    // Adding entries
    for i := 0 to SequenceEditor.Subtitles.Count - 1 do begin
      ListItem := nil;

      // Checking if we must update the current view...
      if UpdateView then
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
        with SequenceEditor.Subtitles[i] do begin
          Data := Pointer(i);
          Caption := IntToStr(i);
          SubItems[0] := BR(SequenceEditor.Subtitles[i].Text);
          SubItems[1] := BR(SequenceEditor.Subtitles[i].BackupText.InitialText);
        end;
    end;

    // Updating UI
    if not UpdateView then begin
      DebugLog.AddLine(ltInformation, 'Load successfully done for "'
        + SequenceEditor.SourceFileName + '".');
    end;
    SetControlsStateFileOperations(True);

    // Refreshing the view
    RefreshSubtitleSelection;

  end;
end;

function TfrmMain.GetSelectedSubtitle: string;
begin
  Result := '';
  if not IsSubtitleSelected then Exit;
  Result := fSelectedSubtitle.Text;
end;

function TfrmMain.GetSelectedSubtitleBackupText: string;
begin
  Result := '';
  if not IsSubtitleSelected then Exit;
  if OriginalSubtitleField then
    Result := fSelectedSubtitle.BackupText.InitialText
  else
    Result := fSelectedSubtitle.BackupText.OriginalText;
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

procedure TfrmMain.InitPreviewer;
begin
  Previewer := TSubtitlesPreviewer.Create(GetApplicationDataDirectory + 'bmpfont');
  Previewer.OnWindowClosed := PreviewerWindowClosed;
end;

function TfrmMain.IsSubtitleSelected: Boolean;
begin
  Result := Assigned(fSelectedSubtitle);
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
    fSelectedSubtitle := SequenceEditor.Subtitles[Index];

    // Refresh the view
    RefreshOldTextField;
    mNewSub.Text := SelectedSubtitle;

    // Updating the Previewer if possible
    Previewer.Update(SelectedSubtitle);
  end;
end;

procedure TfrmMain.LoadFile;
var
  UpdateUI: Boolean;

begin
  // Extending filenames
  FileName := ExpandFileName(FileName);
  UpdateUI := SameText(FileName, SequenceEditor.SourceFileName);

  // Checking the file
  if not FileExists(FileName) then begin
    DebugLog.Report(ltWarning, 'The file "' + FileName + '" doesn''t exists.',
      'FullFileName: ' + FileName);
    Exit;
  end;

  // Updating UI
  StatusText := 'Loading file...';

  // Loading the file
  Clear(UpdateUI);
  if SequenceEditor.LoadFromFile(FileName) then begin
    if not RefreshSubtitlesList(UpdateUI) then begin
      StatusText := 'Nothing to edit!';
      DebugLog.Report(ltInformation, 'This file is valid, but nothing to edit!',
        'FileName: ' + FileName);
    end;
  end else
    DebugLog.Report(ltWarning, 'This file isn''t a supported NBIK sequence MAPINFO.BIN file.',
      'FileName: ' + FileName);

  StatusText := '';
end;

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
  RunAboutBox;
end;

procedure TfrmMain.miCharsetClick(Sender: TObject);
begin
  DecodeSubtitles := not DecodeSubtitles;
end;

procedure TfrmMain.miCloseClick(Sender: TObject);
begin
  if not SaveFileOnDemand(True) then Exit;
  Clear;
end;

procedure TfrmMain.miDebugLogClick(Sender: TObject);
begin
  DebugLogVisible := not DebugLogVisible;
end;

procedure TfrmMain.miDEBUG_TEST1Click(Sender: TObject);
{$IFDEF DEBUG}
var
  i: Integer;

begin
  SequenceEditor.LoadFromFile('PAL_DISC3.bin');
(*  SequenceEditor.Subtitles[0].Text := 'Like a dream I once saw,Åïit passes by as it touches my cheek.!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
  SequenceEditor.Subtitles[1].Text := 'BLAH!<br>MOTHA FUCKA!!!!';
  SequenceEditor.Subtitles[2].Text := 'Èa!';
  SequenceEditor.Subtitles[3].Text := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ........<br>0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ........';
  SequenceEditor.Subtitles[5].Text := 'MAPINFO HACKED HUH?! SEE?';
  SequenceEditor.Subtitles[7].Text := 'Woohoo! This''s the lastest SiZiOUS hack.<br>Enjoy this GREAT exploit!';
  SequenceEditor.Subtitles[8].Text := 'Woohoo! This''s the lastest SiZiOUS hack.<br>Enjoy this GREAT exploit!'; *)

  for i := 0 to SequenceEditor.Subtitles.Count - 1 do
    SequenceEditor.Subtitles[i].Text :=
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqr<br>abcdefghijklmnopqrABCDEFGHIJKLMNOPQRSTUVWXYZ';

  SequenceEditor.SaveToFile('PAL_DISC3.HAK');
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miOpenClick(Sender: TObject);
begin
  with odOpen do
    if Execute then
      LoadFile(FileName);
end;

procedure TfrmMain.miOriginalClick(Sender: TObject);
begin
  OriginalSubtitleField := not OriginalSubtitleField;
end;

procedure TfrmMain.miOriginalColumnClick(Sender: TObject);
begin
  OriginalSubtitlesColumn := not OriginalSubtitlesColumn;
end;

procedure TfrmMain.miPreviewClick(Sender: TObject);
begin
  PreviewerVisible := not PreviewerVisible;
end;

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miReloadClick(Sender: TObject);
begin
  if not SaveFileOnDemand(True) then Exit;
  LoadFile(SequenceEditor.SourceFileName);
  DebugLog.AddLine(ltInformation, 'Successfully reloaded the file "'
    + SequenceEditor.SourceFileName + '".');
end;

procedure TfrmMain.miSaveAsClick(Sender: TObject);
var
  Buf: string;
  ReloadFromDisk: Boolean;

begin
  with sdSave do begin
    FileName := ExtractFileName(SequenceEditor.SourceFileName);
    Buf := ExtractFileExt(SequenceEditor.SourceFileName);
    DefaultExt := Copy(Buf, 2, Length(Buf) - 1);

    // Executing dialog
    if Execute then begin
      StatusText := 'Saving file...';
      ReloadFromDisk := FileName = SequenceEditor.SourceFileName;

      // Saving on the disk
      Buf := ' for "' + SequenceEditor.SourceFileName + '" to "' + FileName + '".';
      if SequenceEditor.SaveToFile(FileName) then
        DebugLog.AddLine(ltInformation, 'Save successfully done' + Buf)
      else
        DebugLog.Report(ltWarning, 'Unable to do the save !', 'Unable to save' + Buf);

      // Reloading the view if needed
      if ReloadFromDisk then
        LoadFile(SequenceEditor.SourceFileName);
      StatusText := '';
    end;
  end;
end;

procedure TfrmMain.miSaveClick(Sender: TObject);
begin
  StatusText := 'Saving file...';
  if SequenceEditor.Save then
    DebugLog.AddLine(ltInformation, Format('Save successfully done on the ' +
      'disk for "%s".', [SequenceEditor.SourceFileName])
    )
  else
    DebugLog.Report(ltWarning, 'Unable to save the file on the disk!',
      Format('Unable to save on disk for "%s".', [SequenceEditor.SourceFileName])
    );
  LoadFile(SequenceEditor.SourceFileName);
end;

procedure TfrmMain.mNewSubChange(Sender: TObject);
begin
  // Update the subtitle
  SelectedSubtitle := mNewSub.Text;

  // Update the modified state
  UpdateFileModifiedState;

  // Update Previewer
  Previewer.Update(SelectedSubtitle);

  // Update the subtitle length count
  UpdateSubtitleLengthControls(SelectedSubtitle, eFirstLineLength, eSecondLineLength);
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

  MsgBtns := MB_YESNO;
  if CancelButton then
    MsgBtns := MB_YESNOCANCEL;

  CanDo := MsgBox('The file was modified. Save changes?', 'Warning',
    MB_ICONWARNING + MsgBtns);
  if CanDo = IDCANCEL then Exit;
  MustSave := (CanDo = IDYES);

  // We save the file
  if MustSave then
    miSave.Click;

  Result := True;
end;

procedure TfrmMain.SetControlsStateFileOperations(State: Boolean);
begin
  miClose.Enabled := State;
  miImport.Enabled := State;
  miExport.Enabled := State;
  (*miImport2.Enabled := State;
  tbImport.Enabled := State;
  miExport2.Enabled := State;
  tbExport.Enabled := State;*)
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

procedure TfrmMain.SetDecodeSubtitles(const Value: Boolean);
var
  i: Integer;
  ListItem: TListItem;

begin
  fDecodeSubtitles := Value;
  tbCharset.Down := fDecodeSubtitles;
  miCharset.Checked := fDecodeSubtitles;

  // Update the SequenceEditor
  SequenceEditor.Subtitles.DecodeText := fDecodeSubtitles;

  // Update the GUI: ListView
  for i := 0 to lvSubs.Items.Count - 1 do begin
    ListItem := lvSubs.FindData(0, Pointer(i), True, False);
    if Assigned(ListItem) then begin
      ListItem.SubItems[0] := BR(SequenceEditor.Subtitles[i].Text);
      ListItem.SubItems[1] := BR(SequenceEditor.Subtitles[i].BackupText.InitialText);
    end;
  end;

  // Update the GUI: Memos
  mOldSub.Text := SequenceEditor.Subtitles.TransformText(mOldSub.Text);
  mNewSub.Text := SequenceEditor.Subtitles.TransformText(mNewSub.Text);
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

procedure TfrmMain.SetOriginalSubtitleColumn(const Value: Boolean);
begin
  fOriginalSubtitleColumn := Value;
  miOriginalColumn.Checked := Value;

  // Preparing Original Subtitles Column
  if fOriginalSubtitleColumn then begin
    if not Assigned(OriginalSubtitlesColumnObject) then begin
      OriginalSubtitlesColumnObject := lvSubs.Columns.Add;
      OriginalSubtitlesColumnObject.Caption := 'Original';
      OriginalSubtitlesColumnObject.Width := OriginalSubtitlesColumnObjectWidth;
    end;
  end else
    if Assigned(OriginalSubtitlesColumnObject) then begin
      OriginalSubtitlesColumnObjectWidth := OriginalSubtitlesColumnObject.Width;
      lvSubs.Columns.Delete(OriginalSubtitlesColumnObject.Index);
      OriginalSubtitlesColumnObject := nil;
    end;
end;

procedure TfrmMain.SetOriginalSubtitleField(const Value: Boolean);
begin
  fOriginalSubtitleField := Value;
  miOriginal.Checked := Value;
  tbOriginal.Down := Value;
  RefreshOldTextField;
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

procedure TfrmMain.SetSelectedSubtitle(const Value: string);
begin
  if IsSubtitleSelected then begin
    fSelectedSubtitleUI.SubItems[0] := BR(Value);
    fSelectedSubtitle.Text := Value;
  end;
end;

procedure TfrmMain.SetStatusReady;
begin
  SetStatusText('Ready');
end;

procedure TfrmMain.SetStatusText(const Value: string);
begin
  if Value = '' then
    sbMain.Panels[2].Text := 'Ready'
  else
    sbMain.Panels[2].Text := Value;

  if (sbMain.Panels[2].Text = 'Ready') then
    Screen.Cursor := crDefault
  else
    Screen.Cursor := crAppStart;

  Application.ProcessMessages;
end;

procedure TfrmMain.tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
  var DefaultDraw: Boolean);
begin
  ToolBarCustomDraw(Sender);
end;

procedure TfrmMain.UpdateFileModifiedState;
var
  i: Integer;
  Modified: Boolean;
  OldSubtitle, NewSubtitle: string;

begin
  Modified := False;
  for i := 0 to SequenceEditor.Subtitles.Count - 1 do
  begin
    OldSubtitle := SequenceEditor.Subtitles[i].BackupText.RawOriginalText;
    NewSubtitle := SequenceEditor.Subtitles[i].RawText;
{$IFDEF DEBUG}
    WriteLn(i, ' Old: "', OldSubtitle, '"', sLineBreak, i, ' New: "', NewSubtitle, '"');
{$ENDIF}
    Modified := Modified or (OldSubtitle <> NewSubtitle);
  end;
  FileModified := Modified;
end;

end.
