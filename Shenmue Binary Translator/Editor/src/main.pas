unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, ImgList, ToolWin, JvExComCtrls,
  JvToolBar, DebugLog, AppEvnts, BugsMgr, JvListView, ExtCtrls, MkXmlBin,
  JvExStdCtrls, JvListComb;

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
    miAbout: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    aeMain: TApplicationEvents;
    miDEBUG_TEST2: TMenuItem;
    miCharset: TMenuItem;
    N5: TMenuItem;
    miOriginal: TMenuItem;
    N6: TMenuItem;
    tbCharset: TToolButton;
    tbOriginal: TToolButton;
    ProjectHome1: TMenuItem;
    N7: TMenuItem;
    Checkforupdate1: TMenuItem;
    miDEBUG_TEST3: TMenuItem;
    miDEBUG_TEST4: TMenuItem;
    GroupBox1: TGroupBox;
    mOldString: TMemo;
    GroupBox2: TGroupBox;
    mNewString: TMemo;
    GroupBox3: TGroupBox;
    cbSections: TComboBox;
    GroupBox4: TGroupBox;
    lbStrings: TListBox;
    N8: TMenuItem;
    New1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure miOpenClick(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure mNewStringChange(Sender: TObject);
    procedure miQuitClick(Sender: TObject);
    procedure miDebugLogClick(Sender: TObject);
    procedure miSaveAsClick(Sender: TObject);
    procedure aeMainException(Sender: TObject; E: Exception);
    procedure FormActivate(Sender: TObject);
    procedure aeMainHint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miCloseClick(Sender: TObject);
    procedure miReloadClick(Sender: TObject);
    procedure miCharsetClick(Sender: TObject);
    procedure ProjectHome1Click(Sender: TObject);
    procedure Checkforupdate1Click(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miOriginalClick(Sender: TObject);
    procedure cbSectionsSelect(Sender: TObject);
    procedure lbStringsClick(Sender: TObject);
  private
    { Déclarations privées }  
    fSelectedSubtitleUI: TListItem;
//    fSelectedSubtitle: TNozomiMotorcycleSequenceSubtitleItem;
    fDebugLogVisible: Boolean;
    fFileModified: Boolean;
//    fSelectedSubtitlePrevInfo: TSubtitlesTextManagerListItem;
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
    function GetStatusText: string;
    procedure InitBugsHandler;
    procedure InitDebugLog;
    procedure LoadFile(FileName: TFileName);
    function SaveFileOnDemand(CancelButton: Boolean): Boolean;
    procedure SetSelectedSubtitle(const Value: string);
    procedure SetStatusText(const Value: string);
    procedure SetDebugLogVisible(const Value: Boolean);
    procedure SetControlsStateFileOperations(State: Boolean);
    procedure SetControlsStateSaveOperation(State: Boolean);
    procedure SetFileModified(const Value: Boolean);
    procedure UpdateFileModifiedState;
    procedure SetPreviewerVisible(const Value: Boolean);
    procedure SetDecodeSubtitles(const Value: Boolean);
    procedure SetOriginalSubtitleField(const Value: Boolean);
    procedure SetOriginalSubtitleColumn(const Value: Boolean);
    property OriginalSubtitlesColumnObject: TListColumn
      read fOriginalSubtitlesColumnObject write fOriginalSubtitlesColumnObject;
    property OriginalSubtitlesColumnObjectWidth: Integer
      read fOriginalSubtitlesColumnObjectWidth write fOriginalSubtitlesColumnObjectWidth;
    property QuitOnFailure: Boolean read fQuitOnFailure write fQuitOnFailure;
  public
    { Déclarations publiques }
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
    property DebugLogVisible: Boolean read fDebugLogVisible
      write SetDebugLogVisible;
    property DecodeSubtitles: Boolean read fDecodeSubtitles
      write SetDecodeSubtitles;
    property FileModified: Boolean read fFileModified write SetFileModified;
    property OriginalSubtitleField: Boolean read fOriginalSubtitleField
      write SetOriginalSubtitleField;
    property StatusText: string read GetStatusText write SetStatusText;
  end;

var
  frmMain: TfrmMain;
  DebugLog: TDebugLogHandlerInterface;
  BugsHandler: TBugsHandlerInterface;
  BinaryScriptEditor: TBinaryScriptEditor;

implementation

{$R *.dfm}

uses
  Config, UITools, SysTools, About;

procedure TfrmMain.Clear(const UpdateOnlyUI: Boolean);
begin
  if not UpdateOnlyUI then begin
    cbSections.Clear;
  end;

//  UpdateFileModifiedState;
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

procedure TfrmMain.cbSectionsSelect(Sender: TObject);
var
  Index: Integer;
  Element: TStringTable;
  i: Integer;

begin
  Index := Integer(cbSections.Items.Objects[cbSections.ItemIndex]);
  Element := BinaryScriptEditor.Sections[Index].Table;
  lbStrings.Clear;
  for i := 0 to Element.Count - 1 do
    lbStrings.Items.Add(Element[i].Text);
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

  // Destroying the engine
  BinaryScriptEditor.Free;

  // Destroying Debug Log
  DebugLog.Free;

  // Cleaning Bugs Handler
  BugsHandler.Free;
end;

procedure TfrmMain.ModulesInit;
begin
  // Init Bugs Handler
  InitBugsHandler;

  // Init Debug Log
  InitDebugLog;

  BinaryScriptEditor := TBinaryScriptEditor.Create;

  // Init the About Box
  InitAboutBox(
    Application.Title,
    GetApplicationVersion,
    'Binary Editor'
  );  
end;

function TfrmMain.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmMain.ProjectHome1Click(Sender: TObject);
begin
  OpenLink('http://shenmuesubs.sourceforge.net/');
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

procedure TfrmMain.lbStringsClick(Sender: TObject);
begin
  mOldString.Text := lbStrings.Items[lbStrings.ItemIndex];
  mNewString.Text := mOldString.Text;
end;

procedure TfrmMain.LoadFile(FileName: TFileName);
var
  i: Integer;
  UpdateUI: Boolean;

begin
  // Extending filenames
  FileName := ExpandFileName(FileName);

  // Checking the file
  if not FileExists(FileName) then begin
    DebugLog.Report(ltWarning, 'The file "' + FileName + '" doesn''t exists.',
      'FullFileName: ' + FileName);
    Exit;
  end;

  // Updating UI
  StatusText := 'Loading file...';
//  Clear(UpdateUI);

  BinaryScriptEditor.LoadFromFile(FileName);

  for i := 0 to BinaryScriptEditor.Sections.Count - 1 do begin
    cbSections.Items.AddObject(BinaryScriptEditor.Sections[i].Name, Pointer(i));
  end;
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

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miReloadClick(Sender: TObject);
begin
  if not SaveFileOnDemand(True) then Exit;
(*  LoadFile(SequenceEditor.SourceFileName);
  DebugLog.AddLine(ltInformation, 'Successfully reloaded the file "'
    + SequenceEditor.SourceFileName + '".');*)
end;

procedure TfrmMain.miSaveAsClick(Sender: TObject);
var
  Buf: string;
  ReloadFromDisk: Boolean;

begin
(*  with sdSave do begin
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
  end;*)
end;

procedure TfrmMain.miSaveClick(Sender: TObject);
begin
(*  StatusText := 'Saving file...';
  if SequenceEditor.Save then
    DebugLog.AddLine(ltInformation, Format('Save successfully done on the ' +
      'disk for "%s".', [SequenceEditor.SourceFileName])
    )
  else
    DebugLog.Report(ltWarning, 'Unable to save the file on the disk!',
      Format('Unable to save on disk for "%s".', [SequenceEditor.SourceFileName])
    );
  LoadFile(SequenceEditor.SourceFileName);*)
end;

procedure TfrmMain.mNewStringChange(Sender: TObject);
begin
(*  // Update the subtitle
  SelectedSubtitle := mNewSub.Text;

  // Update the modified state
  UpdateFileModifiedState;

  // Update Previewer
  Previewer.Update(SelectedSubtitle);

  // Update the subtitle length count
  UpdateSubtitleLengthControls(SelectedSubtitle, eFirstLineLength, eSecondLineLength);*)
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
(*  miImport.Enabled := State;
  miImport2.Enabled := State;
  tbImport.Enabled := State;
  miExport.Enabled := State;
  miExport2.Enabled := State;
  tbExport.Enabled := State; *)
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
(*  SequenceEditor.Subtitles.DecodeText := fDecodeSubtitles;

  // Update the GUI: ListView
  for i := 0 to lvSubs.Items.Count - 1 do begin
    ListItem := lvSubs.FindData(0, Pointer(i), True, False);
    if Assigned(ListItem) then begin
      ListItem.SubItems[0] := BR(SequenceEditor.Subtitles[i].Text);
      ListItem.SubItems[1] := BR(SequenceEditor.Subtitles.TransformText(SubtitlesTextManager.Subtitles[i].InitialText));
    end;
  end;

  // Update the GUI: Memos
  mOldSub.Text := SequenceEditor.Subtitles.TransformText(mOldSub.Text);
  mNewSub.Text := SequenceEditor.Subtitles.TransformText(mNewSub.Text);*)
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
(*  fOriginalSubtitleColumn := Value;
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
    end;*)
end;

procedure TfrmMain.SetOriginalSubtitleField(const Value: Boolean);
begin
  fOriginalSubtitleField := Value;
  miOriginal.Checked := Value;
  tbOriginal.Down := Value;
end;

procedure TfrmMain.SetPreviewerVisible(const Value: Boolean);
begin
(*  fPreviewerVisible := Value;
  miPreview.Checked := fPreviewerVisible;
  tbPreview.Down := fPreviewerVisible;

  // Change the previewer state
  if fPreviewerVisible then
    Previewer.Show(SelectedSubtitle)
  else
    Previewer.Hide;*)
end;

procedure TfrmMain.SetSelectedSubtitle(const Value: string);
begin
(*  if IsSubtitleSelected then begin
    fSelectedSubtitleUI.SubItems[0] := BR(Value);
    fSelectedSubtitle.Text := Value;
  end;*)
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

procedure TfrmMain.UpdateFileModifiedState;
var
  i: Integer;
  Modified: Boolean;
  OldSubtitle, NewSubtitle: string;

begin
(*  Modified := False;
  for i := 0 to SequenceEditor.Subtitles.Count - 1 do begin
    OldSubtitle := SubtitlesTextManager.Subtitles[i].OriginalText;
    NewSubtitle := SequenceEditor.Subtitles[i].RawText;
(*{$IFDEF DEBUG}
    WriteLn(i, ' Old: "', OldSubtitle, '"', sLineBreak, i, ' New: "', NewSubtitle, '"');
{$ENDIF}*)
(*    Modified := Modified or (OldSubtitle <> NewSubtitle);
  end;
  FileModified := Modified;*)
end;

end.
