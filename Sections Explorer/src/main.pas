unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, ImgList, ToolWin, JvExComCtrls,
  JvToolBar, DebugLog, AppEvnts, BugsMgr, JvListView, SectExpl, JvBaseDlg,
  JvBrowseFolder;

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
    miSave: TMenuItem;
    N1: TMenuItem;
    miQuit: TMenuItem;
    miDebugLog: TMenuItem;
    miReload: TMenuItem;
    miAbout: TMenuItem;
    aeMain: TApplicationEvents;
    sdSave: TSaveDialog;
    odOpen: TOpenDialog;
    miSaveAs: TMenuItem;
    miCheckForUpdate: TMenuItem;
    miProjectHome: TMenuItem;
    lvContent: TJvListView;
    miEdit: TMenuItem;
    miUndo: TMenuItem;
    N2: TMenuItem;
    miImport: TMenuItem;
    miExport: TMenuItem;
    N3: TMenuItem;
    miExportAll: TMenuItem;
    N4: TMenuItem;
    miClose: TMenuItem;
    N6: TMenuItem;
    N5: TMenuItem;
    sdExport: TSaveDialog;
    odImport: TOpenDialog;
    bfdExportAll: TJvBrowseForFolderDialog;
    ToolButton3: TToolButton;
    tbUndo: TToolButton;
    tbImport: TToolButton;
    tbExport: TToolButton;
    tbExportAll: TToolButton;
    ToolButton9: TToolButton;
    ToolButton5: TToolButton;
    pmContent: TPopupMenu;
    miUndo2: TMenuItem;
    N8: TMenuItem;
    miImport2: TMenuItem;
    miExport2: TMenuItem;
    N9: TMenuItem;
    miExportAll2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure miOpenClick(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure miQuitClick(Sender: TObject);
    procedure miDebugLogClick(Sender: TObject);
    procedure miSaveAsClick(Sender: TObject);
    procedure aeMainException(Sender: TObject; E: Exception);
    procedure FormActivate(Sender: TObject);
    procedure aeMainHint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miCloseClick(Sender: TObject);
    procedure miReloadClick(Sender: TObject);
    procedure miProjectHomeClick(Sender: TObject);
    procedure miCheckForUpdateClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miExportClick(Sender: TObject);
    procedure miImportClick(Sender: TObject);
    procedure miUndoClick(Sender: TObject);
    procedure lvContentSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure miExportAllClick(Sender: TObject);
  private
    { Déclarations privées }
    fDebugLogVisible: Boolean;
    fFileModified: Boolean;
    fQuitOnFailure: Boolean;
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
    procedure SetStatusText(const Value: string);
    procedure SetDebugLogVisible(const Value: Boolean);
    procedure SetControlsStateFileOperations(State: Boolean);
    procedure SetControlsStateItemSelected(State: Boolean);
    procedure SetControlsStateSaveOperation(State: Boolean);
    procedure SetControlsStateSelectedContentModified(State: Boolean);
    procedure SetControlsStateUndoImporting(State: Boolean);
    procedure SetFileModified(const Value: Boolean);
    procedure UpdateFileModifiedState;
    property QuitOnFailure: Boolean read fQuitOnFailure write fQuitOnFailure;
  public
    { Déclarations publiques }
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
    property DebugLogVisible: Boolean read fDebugLogVisible
      write SetDebugLogVisible;
    property FileModified: Boolean read fFileModified write SetFileModified;
    property StatusText: string read GetStatusText write SetStatusText;
  end;

var
  frmMain: TfrmMain;
  DebugLog: TDebugLogHandlerInterface;
  BugsHandler: TBugsHandlerInterface;
  SectionsExplorer: TSectionsExplorer;

implementation

{$R *.dfm}

uses
  Config, UITools, SysTools, About, AppVer;

procedure TfrmMain.Clear(const UpdateOnlyUI: Boolean);
begin
  UpdateFileModifiedState;
  SetControlsStateFileOperations(False);
  SetControlsStateSaveOperation(False);
  SetControlsStateUndoImporting(False);

  if not UpdateOnlyUI then
  begin
    SectionsExplorer.Clear;
  end;

  StatusText := '';

  lvContent.Clear;  
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
  aeMain.OnException := nil;

  // Init UI
  Caption := Application.Title + ' v' + GetApplicationVersion;
  ToolBarInitControl(Self, tbMain);
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
  miUndo2.Hint := miUndo.Hint;
  miImport2.Hint := miImport.Hint;
  miExport2.Hint := miExport.Hint;
  miExportAll2.Hint := miExportAll.Hint;
  
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

  // Destroying the Engine
  SectionsExplorer.Free;
  
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

  // Init the Engine
  SectionsExplorer := TSectionsExplorer.Create;

  // Init the About Box
  InitAboutBox(
    Application.Title,
    GetApplicationVersion
  );  
end;

function TfrmMain.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmMain.miProjectHomeClick(Sender: TObject);
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

procedure TfrmMain.LoadFile(FileName: TFileName);
var
  i: Integer;
  UpdateUI: Boolean;
  Item: TSectionsExplorerListItem;

begin
  // Extending filenames
  FileName := ExpandFileName(FileName);
  UpdateUI := SameText(FileName, SectionsExplorer.SourceFileName);

  // Checking the file
  if not FileExists(FileName) then
  begin
    DebugLog.Report(ltWarning, 'The file "' + FileName + '" doesn''t exists.',
      'FullFileName: ' + FileName);
    Exit;
  end;

  // Updating UI
  StatusText := 'Loading file...';
  Clear(UpdateUI);  

  // Loading the file
  if SectionsExplorer.LoadFromFile(FileName) then
  begin

    // Filling the UI with the content
    if SectionsExplorer.Loaded then
    begin

      for i := 0 to SectionsExplorer.Sections.Count - 1 do
        with lvContent.Items.Add do
        begin
          Item := SectionsExplorer.Sections[i];
          Caption := IntToStr(i);
          SubItems.Add(Item.Name);
          SubItems.Add(Item.Description);
          SubItems.Add(IntToStr(Item.Offset));
          SubItems.Add(IntToStr(Item.Size));
          SubItems.Add('');
        end;

      // Updating UI
      if not UpdateUI then begin
        DebugLog.AddLine(ltInformation, 'Load successfully done for "'
          + SectionsExplorer.SourceFileName + '".');
      end;
      SetControlsStateFileOperations(True);

    end else
    begin
      StatusText := 'Nothing to edit !';
      DebugLog.Report(ltInformation, 'This file is valid, but nothing to edit !',
        'FileName: ' + FileName);
    end;

  end else
    DebugLog.Report(ltWarning, 'This file seems not to be a valid Shenmue data file.',
      'FileName: ' + FileName);

  StatusText := '';
end;

procedure TfrmMain.lvContentSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  Section: TSectionsExplorerListItem;

begin
  if Selected then
  begin
    Section := SectionsExplorer.Sections[Item.Index];
    SetControlsStateUndoImporting(Section.Updated);
  end;
  SetControlsStateItemSelected(Selected);
end;

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
  RunAboutBox;
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

procedure TfrmMain.miExportAllClick(Sender: TObject);
var
  i: Integer;

begin
  with bfdExportAll do
    if Execute then begin
      frmMain.StatusText := 'Exporting all...';
      for i := 0 to SectionsExplorer.Sections.Count - 1 do
        SectionsExplorer.Sections[i].ExportToFolder(Directory);
      frmMain.StatusText := '';
      DebugLog.AddLine(ltInformation, 'All the content was succesfully exported to the "'
        + Directory + '" directory.');
    end;
end;

procedure TfrmMain.miExportClick(Sender: TObject);
var
  Section: TSectionsExplorerListItem;

begin
  if lvContent.ItemIndex <> -1 then
    with sdExport do
    begin
      Section := SectionsExplorer.Sections[lvContent.ItemIndex];
      FileName := Section.OutputFileName;
      if Execute then
      begin
        Section.SaveToFile(FileName);
        DebugLog.AddLine(ltInformation, 'Section "' + Section.Name
          + '" successfully saved to the file "'
          + FileName + '".');
      end;
    end;
end;

procedure TfrmMain.miImportClick(Sender: TObject);
var
  Section: TSectionsExplorerListItem;

begin
  if lvContent.ItemIndex <> -1 then
    with odImport do
    begin
      Section := SectionsExplorer.Sections[lvContent.ItemIndex];
      if Execute then
        if Section.LoadFromFile(FileName) then
        begin
          SetControlsStateSelectedContentModified(True);
          SetControlsStateUndoImporting(True);
          DebugLog.AddLine(ltInformation, 'Section "' + Section.Name
            + '" successfully imported from the file "'
            + FileName + '".');
        end else
          DebugLog.AddLine(ltWarning, 'Unable to import the section "'
            + Section.Name + '" from the file "'
            + FileName + '" !');
    end;
end;

procedure TfrmMain.miOpenClick(Sender: TObject);
begin
  with odOpen do
    if Execute then
      LoadFile(FileName);
end;

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miReloadClick(Sender: TObject);
begin
  if not SaveFileOnDemand(True) then Exit;
  LoadFile(SectionsExplorer.SourceFileName);
  DebugLog.AddLine(ltInformation, 'Successfully reloaded the file "'
    + SectionsExplorer.SourceFileName + '".');
end;

procedure TfrmMain.miSaveAsClick(Sender: TObject);
var
  Buf: string;
  ReloadFromDisk: Boolean;
  AFileName: TFileName;

begin
  AFileName := SectionsExplorer.SourceFileName;
  with sdSave do begin
    FileName := ExtractFileName(AFileName);
    Buf := ExtractFileExt(AFileName);
    DefaultExt := Copy(Buf, 2, Length(Buf) - 1);

    // Executing dialog
    if Execute then begin
      StatusText := 'Saving file...';
      ReloadFromDisk := FileName = AFileName;

      // Saving on the disk
      Buf := ' for "' + AFileName + '" to "' + FileName + '".';
      if SectionsExplorer.SaveToFile(FileName) then
        DebugLog.AddLine(ltInformation, 'Save successfully done' + Buf)
      else
        DebugLog.Report(ltWarning, 'Unable to do the save !', 'Unable to save' + Buf);

      // Reloading the view if needed
      if ReloadFromDisk then
        LoadFile(AFileName);
      StatusText := '';
    end;
  end;
end;

procedure TfrmMain.miSaveClick(Sender: TObject);
var
  AFileName: TFileName;

begin
  AFileName := SectionsExplorer.SourceFileName;
  StatusText := 'Saving file...';
  if SectionsExplorer.Save then
    DebugLog.AddLine(ltInformation, Format('Save successfully done on the ' +
      'disk for "%s".', [AFileName])
    )
  else
    DebugLog.Report(ltWarning, 'Unable to save the file on the disk!',
      Format('Unable to save on disk for "%s".', [AFileName])
    );
  LoadFile(AFileName);
end;

procedure TfrmMain.miUndoClick(Sender: TObject);
var
  CanDo: Integer;
  Item: TSectionsExplorerListItem;

begin
  if lvContent.ItemIndex = -1 then Exit;
  
  CanDo := MsgBox('Sure to undo importing ?', 'Question', MB_ICONQUESTION
    + MB_YESNO);
  if CanDo = IDNO then Exit;

  Item := SectionsExplorer.Sections[lvContent.ItemIndex];
  Item.CancelImport;
  SetControlsStateSelectedContentModified(False);
  DebugLog.AddLine(ltInformation,
    Format('The import for the entry #%d  of the file "%s" was canceled.', [
      Item.Index, SectionsExplorer.SourceFileName]));
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
  miReload.Enabled := State;
  tbReload.Enabled := State;
  miExportAll.Enabled := State;
  miExportAll2.Enabled := State;
  tbExportAll.Enabled := State;
  if not State then
  begin
    miUndo.Enabled := State;
    SetControlsStateItemSelected(State);
  end;
end;

procedure TfrmMain.SetControlsStateItemSelected(State: Boolean);
begin
  miImport.Enabled := State;
  miImport2.Enabled := State;
  tbImport.Enabled := State;
  miExport.Enabled := State;
  miExport2.Enabled := State;
  tbExport.Enabled := State;
end;

procedure TfrmMain.SetControlsStateSaveOperation(State: Boolean);
begin
  tbSave.Enabled := State;
  miSave.Enabled := State;
  miSaveAs.Enabled := State;
end;

procedure TfrmMain.SetControlsStateSelectedContentModified(State: Boolean);
var
  Value: string;

begin
  Value := '';
  if State then
    Value := 'Yes';
  lvContent.Selected.SubItems[4] := Value;
  UpdateFileModifiedState;
  SetControlsStateUndoImporting(State);
end;

procedure TfrmMain.SetControlsStateUndoImporting(State: Boolean);
begin
  miUndo.Enabled := State;
  miUndo2.Enabled := State;
  tbUndo.Enabled := State;
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
  ContentIsModified: Boolean;

begin
  // Checking if a IPAC content entry is modified
  i := 0;
  ContentIsModified := False;
  while (i < SectionsExplorer.Sections.Count) and (not ContentIsModified) do begin
    ContentIsModified := SectionsExplorer.Sections[i].Updated;
    Inc(i);
  end;

  // Setting up the result
  fFileModified := ContentIsModified;

  // Update UI
  SetControlsStateSaveOperation(FileModified);
  if FileModified then
    sbMain.Panels[1].Text := 'Modified'
  else
    sbMain.Panels[1].Text := '';
end;

end.
