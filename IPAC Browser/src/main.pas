unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IpacMgr, Menus, ComCtrls, JvExComCtrls, JvListView, ImgList, ToolWin,
  JvToolBar, Themes, AppEvnts, JvBaseDlg, JvBrowseFolder, IpacUtil, DebugLog,
  BugsMgr, JvComponentBase, JvDragDrop;

type
  TfrmMain = class(TForm)
    mmMain: TMainMenu;
    miFile: TMenuItem;
    miOpen: TMenuItem;
    N1: TMenuItem;
    miQuit: TMenuItem;
    miDEBUG: TMenuItem;
    miDEBUG_TEST1: TMenuItem;
    lvIpacContent: TJvListView;
    sbMain: TStatusBar;
    odOpen: TOpenDialog;
    ilIpacContent: TImageList;
    ilHeader: TImageList;
    tbMain: TJvToolBar;
    ToolButton1: TToolButton;
    tbOpen: TToolButton;
    miHelp: TMenuItem;
    miAbout: TMenuItem;
    miClose: TMenuItem;
    miSave: TMenuItem;
    miSaveAs: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    miReload: TMenuItem;
    miEdit: TMenuItem;
    miUndo: TMenuItem;
    N4: TMenuItem;
    miImport: TMenuItem;
    miExport: TMenuItem;
    N5: TMenuItem;
    miExportAll: TMenuItem;
    miView: TMenuItem;
    miDebugLog: TMenuItem;
    miProperties: TMenuItem;
    N6: TMenuItem;
    ilToolBar: TImageList;
    tbSave: TToolButton;
    tbReload: TToolButton;
    ToolButton4: TToolButton;
    miDEBUG_TEST2: TMenuItem;
    miOptions: TMenuItem;
    miAutoSave: TMenuItem;
    miMakeBackup: TMenuItem;
    tbUndo: TToolButton;
    tbImport: TToolButton;
    tbExport: TToolButton;
    ToolButton8: TToolButton;
    tbExportAll: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    tbDebugLog: TToolButton;
    tbProperties: TToolButton;
    ToolButton14: TToolButton;
    tbAutoSave: TToolButton;
    tbMakeBackup: TToolButton;
    ToolButton17: TToolButton;
    tbAbout: TToolButton;
    pmIpacContent: TPopupMenu;
    miUndo2: TMenuItem;
    N8: TMenuItem;
    miImport2: TMenuItem;
    miExport2: TMenuItem;
    N9: TMenuItem;
    miExportAll2: TMenuItem;
    sdExport: TSaveDialog;
    ilToolBarDisabled: TImageList;
    odImport: TOpenDialog;
    sdSave: TSaveDialog;
    aeMain: TApplicationEvents;
    bfdExportAll: TJvBrowseForFolderDialog;
    miDEBUG_TEST3: TMenuItem;
    miDEBUG_TEST4: TMenuItem;
    JvDragDrop: TJvDragDrop;
    N7: TMenuItem;
    miAssociate: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miDEBUG_TEST1Click(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure lvIpacContentColumnClick(Sender: TObject; Column: TListColumn);
    procedure tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure miQuitClick(Sender: TObject);
    procedure miDEBUG_TEST2Click(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miReloadClick(Sender: TObject);
    procedure miExportClick(Sender: TObject);
    procedure miImportClick(Sender: TObject);
    procedure miSaveAsClick(Sender: TObject);
    procedure lvIpacContentSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure miDebugLogClick(Sender: TObject);
    procedure aeMainHint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure miAutoSaveClick(Sender: TObject);
    procedure miMakeBackupClick(Sender: TObject);
    procedure miUndoClick(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miExportAllClick(Sender: TObject);
    procedure miDEBUG_TEST3Click(Sender: TObject);
    procedure miDEBUG_TEST4Click(Sender: TObject);
    procedure aeMainException(Sender: TObject; E: Exception);
    procedure JvDragDropDrop(Sender: TObject; Pos: TPoint; Value: TStrings);
    procedure miPropertiesClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miAssociateClick(Sender: TObject);
  private
    { Déclarations privées }
    fStoredCaption: string;
    fFileModified: Boolean;
    fSelectedContentUI: TListItem;
    fDebugLogVisible: Boolean;
    fAutoSave: Boolean;
    fMakeBackup: Boolean;
    fQuitOnFailure: Boolean;
    fFilePropertiesVisible: Boolean;
    fFileAssociated: Boolean;
    procedure BugsHandlerExceptionCallBack(Sender: TObject;
      ExceptionMessage: string);
    procedure BugsHandlerSaveLogRequest(Sender: TObject);
    procedure BugsHandlerQuitRequest(Sender: TObject);
    procedure FreeApplication;
    function GetSelectedContentEntry: TIpacSectionListItem;
    procedure SetDebugLogVisible(const Value: Boolean);
    function GetStatusText: string;
    procedure SetStatusText(const Value: string);
    procedure SetAutoSave(const Value: Boolean);
    procedure SetMakeBackup(const Value: Boolean);
    procedure SetFilePropertiesVisible(const Value: Boolean);
    procedure SetFileAssociated(const Value: Boolean);
  protected
    procedure Clear; overload;
    procedure Clear(const UpdateOnlyUI: Boolean); overload;
    procedure ClearColumnsImages;
    function ExtendedKindToFilterString(
      SectionKind: TIpacSectionKind): string;
    function GetFileOperationDialogFilterIndex(
      TargetDialog: TOpenDialog): Integer;
    procedure InitToolbarControl;
    procedure InitBugsHandler;
    procedure InitContentPopupMenuControl;
    function SaveFileOnDemand(CancelButton: Boolean): Boolean;
    procedure SetControlsStateFileOperations(State: Boolean);
    procedure SetControlsStateSaveOperation(State: Boolean);
    procedure SetControlsStateSelectedContentModified(State: Boolean);
    procedure SetControlsStateUndoImporting(State: Boolean);
    procedure SetWindowTitleCaption(const FileName: TFileName);
    procedure UpdateFileModifiedState;
    property StoredCaption: string read fStoredCaption write fStoredCaption;
    property QuitOnFailure: Boolean read fQuitOnFailure write fQuitOnFailure;
  public
    { Déclarations publiques }
    procedure AddDebug(LineType: TLineType; Text: string);
    function MsgBox(Text: string): Integer; overload;
    function MsgBox(Text, Caption: string; Flags: Integer): Integer; overload;
    procedure ReportFailure(Text, AdditionalDebugText, Caption: string;
      FailureType: TLineType);
    procedure LoadFile(FileName: TFileName);

    property AutoSave: Boolean read fAutoSave write SetAutoSave;
    property DebugLogVisible: Boolean read fDebugLogVisible write SetDebugLogVisible;
    property FileAssociated: Boolean read fFileAssociated write SetFileAssociated;
    property FileModified: Boolean read fFileModified;
    property FilePropertiesVisible: Boolean read fFilePropertiesVisible
      write SetFilePropertiesVisible;
    property MakeBackup: Boolean read fMakeBackup write SetMakeBackup;
    property StatusText: string read GetStatusText write SetStatusText;
    property SelectedContentUI: TListItem read fSelectedContentUI;
    property SelectedContentEntry: TIpacSectionListItem
      read GetSelectedContentEntry;
  end;

  ExceptionGUI = class(Exception);
  EIpacNotOpened = class(ExceptionGUI);
  EInvalidToolbarButton = class(ExceptionGUI);

var
  frmMain: TfrmMain;
  IPACEditor: TIpacEditor;
  BugsHandler: TBugsHandlerInterface;

implementation

{$R *.dfm}

uses
  GZipMgr, Utils, FileProp, About, Shell;

procedure TfrmMain.Clear(const UpdateOnlyUI: Boolean);
begin
  if not UpdateOnlyUI then begin
    IPACEditor.Clear;  
    ClearColumnsImages;
    lvIpacContent.Clear;
    SetWindowTitleCaption('');
  end;

  UpdateFileModifiedState;
  SetControlsStateUndoImporting(False);
  SetControlsStateFileOperations(False);
  SetControlsStateSaveOperation(False);
end;

procedure TfrmMain.AddDebug(LineType: TLineType; Text: string);
begin
  if Assigned(frmDebugLog) then
    frmDebugLog.AddLine(LineType, Text);
end;

procedure TfrmMain.aeMainException(Sender: TObject; E: Exception);
begin
  BugsHandler.Execute(Sender, E);
  aeMain.CancelDispatch;
end;

procedure TfrmMain.aeMainHint(Sender: TObject);
begin
  frmDebugLog.ResetStatus;
  StatusText := Application.Hint;
  aeMain.CancelDispatch;
end;

procedure TfrmMain.miAssociateClick(Sender: TObject);
var
  CanDo: Integer;
  Msg: string;

begin
  // Better to do for the next version: retriving the managed extensions!!!
  // Go to the Shell unit to see what I mean
  
  if not FileAssociated then begin
    Msg := 'Are you sure to associate the Shenmue data files (*.PKS, *.PKF and '
       + '*.BIN) with this tool ?';
  end else
    Msg := 'Do you want to dissociate the Shenmue data files ?';

  CanDo := MsgBox(Msg, 'Question', MB_ICONQUESTION + MB_YESNO);
  if CanDo = IDNO then Exit;

  FileAssociated := not FileAssociated;
end;

procedure TfrmMain.BugsHandlerExceptionCallBack(Sender: TObject;
  ExceptionMessage: string);
begin
  AddDebug(ltCritical, ExceptionMessage);
end;

procedure TfrmMain.BugsHandlerQuitRequest(Sender: TObject);
begin
  QuitOnFailure := True;
  Close;
end;

procedure TfrmMain.BugsHandlerSaveLogRequest(Sender: TObject);
begin
  frmDebugLog.SaveLogFile;  
end;

procedure TfrmMain.Clear;
begin
  Clear(False);
end;

procedure TfrmMain.ClearColumnsImages;
var
  i: Integer;
  
begin
  for i := 0 to lvIpacContent.Columns.Count - 1 do
    lvIpacContent.Column[i].ImageIndex := -1;
end;

function TfrmMain.ExtendedKindToFilterString(
  SectionKind: TIpacSectionKind): string;
begin
  Result := SectionKind.Description + ' (*.' + SectionKind.Extension + ')|*.'
    + SectionKind.Extension + '|';
end;

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
  RunAboutBox;
end;

procedure TfrmMain.miAutoSaveClick(Sender: TObject);
begin
  AutoSave := not AutoSave;
end;

procedure TfrmMain.miCloseClick(Sender: TObject);
begin
  if not SaveFileOnDemand(True) then Exit;
  Clear;
  AddDebug(ltInformation, 'Close successfully done for "' +
    IpacEditor.SourceFileName + '".');
end;

procedure TfrmMain.miDebugLogClick(Sender: TObject);
begin
  DebugLogVisible := not DebugLogVisible;
end;

procedure TfrmMain.miDEBUG_TEST1Click(Sender: TObject);
{$IFDEF DEBUG}
begin
  IPACEditor.LoadFromFile('AKMI.PKS');
  IPACEditor.Content[0].ExportToFile('0_before.bin');
  IPACEditor.Content[0].ImportFromFile('TEST.BIN');
  ipaceditor.Content[1].ImportFromFile('scnf.bin');
  ipaceditor.Content[1].ExportToFolder('.\');
  ipaceditor.Content[1].CancelImport;
  IPACEditor.SaveToFile('OUT.BIN');
//  ipaceditor.Save;
  IPACEditor.Content[0].ExportToFile('0_after.bin');
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miExportAllClick(Sender: TObject);
var
  i: Integer;

begin
  with bfdExportAll do
    if Execute then begin
      frmMain.StatusText := 'Exporting all...';
      for i := 0 to IPACEditor.Content.Count - 1 do
        IpacEditor.Content[i].ExportToFolder(Directory);
      frmMain.StatusText := '';
      AddDebug(ltInformation, 'All the IPAC content was succesfully exported to the "'
        + Directory + '" directory.');
    end;
end;

procedure TfrmMain.miExportClick(Sender: TObject);
begin
  with sdExport do begin
    FileName := SelectedContentEntry.Name;

    // Select the right filter
    DefaultExt := SelectedContentEntry.ExpandedKind.Extension;
    FilterIndex := GetFileOperationDialogFilterIndex(sdExport);

    // Saving IPAC content section
    if Execute then begin
      StatusText := 'Exporting...';
      SelectedContentEntry.ExportToFile(FileName);
      StatusText := '';
      AddDebug(ltInformation, Format(
        'The current entry #%d [%s] was successfully saved to the "%s" file.',
        [SelectedContentEntry.Index, SelectedContentEntry.GetOutputFileName,
        FileName])
      );
    end;
  end;
end;

procedure TfrmMain.miImportClick(Sender: TObject);
var
  Buf: string;

begin
  with odImport do begin
    FileName := SelectedContentEntry.Name;

    // Select the right filter
    DefaultExt := SelectedContentEntry.ExpandedKind.Extension;
    FilterIndex := GetFileOperationDialogFilterIndex(odImport);
    Buf := Format('#%d [%s]', [SelectedContentEntry.Index,
      SelectedContentEntry.GetOutputFileName]);

    // Loading IPAC content section
    if Execute then begin
      StatusText := 'Importing...';
      if SelectedContentEntry.ImportFromFile(FileName) then begin
        SetControlsStateSelectedContentModified(True);
        SetControlsStateUndoImporting(True);
        AddDebug(ltInformation, 'Entry import for ' + Buf + ' done from "' + FileName + '".');
      end else
        AddDebug(ltWarning, 'Unable to import for ' + Buf + ' from "' + FileName + '".');
      StatusText := '';
    end;

  end; // with
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
  aeMain.OnException := nil;

  // Init the About Box
  InitAboutBox(
    Application.Title,
    GetAppVersion
  );

{$IFNDEF DEBUG}
  miDEBUG.Visible := False;
{$ENDIF}

  // Init the Main Form
  Caption := Application.Title + ' v' + GetAppVersion;
  StoredCaption := Caption;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;

  // Initialize the Bugs Handler
  InitBugsHandler;
  
  // Creating the main IPAC Editor object
  IPACEditor := TIpacEditor.Create;
  Clear;

  // Initialize some UI controls
  InitToolbarControl;
  InitContentPopupMenuControl;

  // Init the file Association menu
  fFileAssociated := ShellExtension.IsFilesAssociated;
  miAssociate.Checked := fFileAssociated;

  // Load configuration
  LoadConfigMain;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeApplication;
end;

procedure TfrmMain.FreeApplication;
var
  HandleMenu: THandle;

begin
  // Disabling the Quit control
  miQuit.Enabled := False;
  HandleMenu := GetSystemMenu(Handle, False);
  EnableMenuItem(HandleMenu, SC_CLOSE, MF_DISABLED);

  // Destroying the IPAC Object
  IPACEditor.Free;

  // Destroying BugsHandler
  BugsHandler.Free;
  
  // Saving configuration
  SaveConfigMain;
end;

function TfrmMain.GetSelectedContentEntry: TIpacSectionListItem;
begin
  try
    Result := IPACEditor.Content[Integer(SelectedContentUI.Data)];
  except
    raise
      EIpacNotOpened.Create('Please open a IPAC file first (or disable the action control) !!');
  end;
end;

function TfrmMain.GetStatusText: string;
begin
  Result := sbMain.Panels[2].Text;
end;

procedure TfrmMain.miDEBUG_TEST2Click(Sender: TObject);
{$IFDEF DEBUG}
var
  OutFile: TFileName;

begin
  GZipInitEngine(GetWorkingTempDirectory);
  GZipDecompress('TEXTURES.PKS', 'test', OutFile);
  GZipCompress('test\TEXTURES.PKSirs407947390.tmp', 'TEXTURES.PKS.new');
  MsgBox(OutFile, '', MB_OK);
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST3Click(Sender: TObject);
{$IFDEF DEBUG}
begin
  frmDebugLog.addline(ltinformation, 'information');
  frmDebugLog.AddLine(ltWarning, 'test warning');
  frmDebugLOG.addline(ltCritical, 'CRITICAL!!!');
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miDEBUG_TEST4Click(Sender: TObject);
{$IFDEF DEBUG}
begin
  raise Exception.Create('TEST EXCEPTION');
{$ELSE}
begin
{$ENDIF}
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
      ReportFailure('Unable to initialize the Bugs Handler!',
        'Reason: "' + E.Message + '"', 'Critical', ltWarning);
  end;
end;

procedure TfrmMain.InitContentPopupMenuControl;
begin
  miUndo2.Hint := miUndo.Hint;
  miImport2.Hint := miImport.Hint;
  miExport2.Hint := miExport.Hint;
  miExportAll2.Hint := miExportAll.Hint;
end;

function TfrmMain.GetFileOperationDialogFilterIndex(
  TargetDialog: TOpenDialog): Integer;
var
  i: Integer;
  StandardKind: TIpacSectionKind;
  
begin
  TargetDialog.Filter := '';
  Result := -1;
  
  // Filling with extended filter for the current entry
  with SelectedContentEntry do begin
    // If we know more that is an 'CHRM' or 'BIN ' entry... we'll add the entry
    // in the first filter index
    if ExpandedKindAvailable then begin
      TargetDialog.Filter := ExtendedKindToFilterString(ExpandedKind);
      Result := 0;
    end;
  end;

  // Filling with the standard kind corresponding to the extended (if any)
  for i := 0 to GetStandardKindCount - 1 do begin
    StandardKind := GetStandardKind(i);

    // Setting the FilterIndex
    if StandardKind.Name = SelectedContentEntry.Kind then begin
      // Select the Standard Kind if we don't have an Extended kind for this entry
      if Result = -1 then
        Result := i;

      // Adding the Filter to the Dialog
      TargetDialog.Filter := TargetDialog.Filter +
        ExtendedKindToFilterString(StandardKind);
    end;
  end;

  // If we don't have found the entry... select the all files filter
  Result := 0;
  
  // Adding the *.* filter
  TargetDialog.Filter := TargetDialog.Filter + 'All Files (*.*)|*.*';
end;

procedure TfrmMain.tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
  var DefaultDraw: Boolean);
var
  ElementDetails: TThemedElementDetails;
  NewRect : TRect;

begin
  // Thank you ...
  // http://www.brandonstaggs.com/2009/06/29/give-a-delphi-ttoolbar-a-proper-themed-background/
  if ThemeServices.ThemesEnabled then begin
    NewRect := Sender.ClientRect;
    NewRect.Top := NewRect.Top - GetSystemMetrics(SM_CYMENU);
    ElementDetails := ThemeServices.GetElementDetails(trRebarRoot);
    ThemeServices.DrawElement(Sender.Canvas.Handle, ElementDetails, NewRect);
  end;
end;

procedure TfrmMain.UpdateFileModifiedState;
var
  i: Integer;
  IpacContentIsModified: Boolean;

begin
  // Checking if a IPAC content entry is modified
  i := 0;
  IpacContentIsModified := False;
  while (i < IPACEditor.Content.Count) and (not IpacContentIsModified) do begin
    IpacContentIsModified := IPACEditor.Content[i].Updated;
    Inc(i);
  end;

  // Setting up the result
  fFileModified := IpacContentIsModified;

  // Update UI
  SetControlsStateSaveOperation(FileModified);
  if FileModified then
    sbMain.Panels[1].Text := 'Modified'
  else
    sbMain.Panels[1].Text := '';
end;

procedure TfrmMain.InitToolbarControl;
var
  i: Integer;
  MenuName: TComponentName;
  MenuItem: TMenuItem;
  ShortCutStr: string;

begin
  // Associating each ToolButton with the appropriate MenuItem
  for i := 0 to tbMain.ButtonCount - 1 do
    if tbMain.Buttons[i].Style = tbsButton then begin
      // Searching the MenuItem corresponding at the ToolButton
      MenuName := 'mi' +
        Copy(tbMain.Buttons[i].Name, 3, Length(tbMain.Buttons[i].Name) - 2);
      MenuItem := FindComponent(MenuName) as TMenuItem;

      // Setting action for the ToolButton
      if Assigned(MenuItem) then begin
        tbMain.Buttons[i].Caption := StringReplace(MenuItem.Caption, '&', '', [rfReplaceAll]);
        ShortCutStr := ShortCutToText(MenuItem.ShortCut);
        if ShortCutStr <> '' then
          ShortCutStr := ' (' + ShortCutStr + ')';
        tbMain.Buttons[i].Hint := tbMain.Buttons[i].Caption + ShortCutStr
          + '|' + MenuItem.Hint;
        tbMain.Buttons[i].OnClick := MenuItem.OnClick;
      end else
        raise EInvalidToolbarButton.Create('Invalid main menu item : ' + MenuName + '.');
    end; // Style = tbsButton
end;

procedure TfrmMain.JvDragDropDrop(Sender: TObject; Pos: TPoint;
  Value: TStrings);
begin
  if not SaveFileOnDemand(False) then Exit;
  if Value.Count > 0 then begin
    if Value.Count > 1 then
      ReportFailure('Only one file can be dropped at the same time on the application.',
        Format('FilesDroppedCount: %d', [Value.Count]), 'Warning', ltWarning);
    LoadFile(Value[0]);
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
  UpdateUI := (FileName = IPACEditor.SourceFileName);

  // Checking the file
  if not FileExists(FileName) then begin
    ReportFailure('The file "' + FileName + '" doesn''t exists.',
      'FullFileName: ' + FileName, 'Warning', ltWarning);
    Exit;
  end;

  // Updating UI
  StatusText := 'Loading file...';
  Clear(UpdateUI);  

  // Loading the file
  if IPACEditor.LoadFromFile(FileName) then begin

    // Filling the UI with the IPAC Content
    if IPACEditor.Content.Count > 0 then begin

      // Adding IPAC entries
      for i := 0 to IPACEditor.Content.Count - 1 do begin
        ListItem := nil;

        // Checking if we must update the current view...
        if UpdateUI then
          ListItem := lvIpacContent.FindData(0, Pointer(i), True, False); // finding the correct index

        (*  If we ListItem = nil, it says that we don't have found the correct
            Item index, or we opened a new file. So we'll create a new item
            and prepare it to be updated. *)
        if not Assigned(ListItem) then begin
          ListItem := lvIpacContent.Items.Add;
          ListItem.Caption := '';
          j := 0;
          repeat
            ListItem.SubItems.Add('');
            Inc(j);
          until j = 4;
        end;

        // Updating the current item with the new values
        with ListItem do
          with IPACEditor.Content[i] do begin
            Data := Pointer(i);
            Caption := GetOutputFileName;
            SubItems[0] := ExpandedKind.Description;
            SubItems[1] := IntToStr(AbsoluteOffset);
            SubItems[2] := IntToStr(Size);
            SubItems[3] := ''; // for updated
            ImageIndex := GetKindIndex(ExpandedKind.Name);
          end;
      end;

      // Updating UI
      if not UpdateUI then begin
        SetWindowTitleCaption(IPACEditor.SourceFileName);
        AddDebug(ltInformation, 'Load successfully done for "' + IPACEditor.SourceFileName
          + '".');
      end;
      SetControlsStateFileOperations(True);

      // Updating File Properties
      frmProperties.RefreshInfos;
    end else begin
      StatusText := 'IPAC section empty ! Loading aborted...';
      ReportFailure('This file contains a valid IPAC section, but the section itself is empty.',
        'FileName: ' + FileName, 'Nothing to edit in this file', ltInformation);
    end;

  end else
    ReportFailure('This file doesn''t contain a valid IPAC section.',
      'FileName: ' + FileName, 'Warning', ltWarning);

  StatusText := '';
end;

procedure TfrmMain.lvIpacContentColumnClick(Sender: TObject;
  Column: TListColumn);
var
  OldIndex: Integer;

begin
  OldIndex := Column.ImageIndex;
  
  ClearColumnsImages;

  if OldIndex = -1 then
    Column.ImageIndex := 0
  else
    Column.ImageIndex := (OldIndex + 1) mod ilHeader.Count;
end;

procedure TfrmMain.lvIpacContentSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then begin
    fSelectedContentUI := Item;
    SetControlsStateUndoImporting(SelectedContentEntry.Updated);
  end;
end;

procedure TfrmMain.miOpenClick(Sender: TObject);
begin
  if not SaveFileOnDemand(True) then Exit;   
  with odOpen do
    if Execute then
      LoadFile(FileName);
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
begin
  if not SaveFileOnDemand(True) then Exit;
  LoadFile(IPACEditor.SourceFileName);
  AddDebug(ltInformation, 'Successfully reloaded the file "'
    + IPACEditor.SourceFileName + '".');
end;

procedure TfrmMain.miSaveAsClick(Sender: TObject);
var
  Buf: string;
  ReloadFromDisk: Boolean;

begin
  with sdSave do begin
    FileName := ExtractFileName(IPACEditor.SourceFileName);
    Buf := ExtractFileExt(IPACEditor.SourceFileName);
    DefaultExt := Copy(Buf, 2, Length(Buf) - 1);

    // Executing dialog
    if Execute then begin
      StatusText := 'Saving file...';
      ReloadFromDisk := FileName = IPACEditor.SourceFileName;

      // Saving on the disk
      Buf := ' for "' + IPACEditor.SourceFileName + '" to "' + FileName + '".';
      if IPACEditor.SaveToFile(FileName) then
        AddDebug(ltInformation, 'Save successfully done' + Buf)
      else
        AddDebug(ltWarning, 'Unable to do the save' + Buf);

      // Reloading the view if needed
      if ReloadFromDisk then
        LoadFile(IPACEditor.SourceFileName);
      StatusText := '';
    end;
  end;
end;

procedure TfrmMain.miSaveClick(Sender: TObject);
begin
  StatusText := 'Saving file...';
  if IPACEditor.Save then
    AddDebug(ltInformation,
      Format('Save successfully done on the disk for "%s".',
      [IpacEditor.SourceFileName])
    )
  else
    AddDebug(ltWarning,
      Format('Unable to save on disk for "%s".',
      [IPACEditor.SourceFileName])
    );
  LoadFile(IPACEditor.SourceFileName);
end;

procedure TfrmMain.miUndoClick(Sender: TObject);
var
  CanDo: Integer;

begin
  CanDo := MsgBox('Sure to undo importing ?', 'Question', MB_ICONQUESTION
    + MB_YESNO);
  if CanDo = IDNO then Exit;
  
  SelectedContentEntry.CancelImport;
  SetControlsStateSelectedContentModified(False);
  AddDebug(ltInformation,
    Format('The import for the entry #%d [%s] of the file "%s" was canceled.', [
      SelectedContentEntry.Index, SelectedContentEntry.GetOutputFileName,
        IPACEditor.SourceFileName]));
end;

function TfrmMain.MsgBox(Text: string): Integer;
begin
  Result := MsgBox(Text, StoredCaption, MB_OK);
end;

function TfrmMain.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
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

procedure TfrmMain.SetDebugLogVisible(const Value: Boolean);
begin
  if fDebugLogVisible <> Value then begin
    fDebugLogVisible := Value;
    miDebugLog.Checked := Value;
    tbDebugLog.Down := Value;
    
    if Value then
      frmDebugLog.Show
    else
      if frmDebugLog.Visible then
        frmDebugLog.Close;
  end;
end;

procedure TfrmMain.SetFileAssociated(const Value: Boolean);
begin
  fFileAssociated := Value;
  miAssociate.Checked := Value;
  ShellExtension.RegisterShellFilesAssociation(Value);
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
  tbMakeBackup.Down := Value;
  miMakeBackup.Checked := Value;
  IpacEditor.MakeBackup := Value;
end;

procedure TfrmMain.SetAutoSave(const Value: Boolean);
begin
  fAutoSave := Value;
  tbAutoSave.Down := Value;
  miAutoSave.Checked := Value;
end;

procedure TfrmMain.SetControlsStateFileOperations(State: Boolean);
begin
  miReload.Enabled := State;
  miClose.Enabled := State;
  miImport.Enabled := State;
  miExport.Enabled := State;
  miExportAll.Enabled := State;
  miImport2.Enabled := State;
  miExport2.Enabled := State;
  miExportAll2.Enabled := State;
  tbReload.Enabled := State;
  tbImport.Enabled := State;
  tbExport.Enabled := State;
  tbExportAll.Enabled := State;
end;

procedure TfrmMain.SetControlsStateSaveOperation(State: Boolean);
begin
  miSave.Enabled := State;
  miSaveAs.Enabled := State;
  tbSave.Enabled := State;
end;

procedure TfrmMain.SetControlsStateSelectedContentModified(State: Boolean);
var
  Value: string;

begin
  Value := '';
  if State then
    Value := 'Yes';
  SelectedContentUI.SubItems[3] := Value;
  UpdateFileModifiedState;
  SetControlsStateUndoImporting(State);
end;

procedure TfrmMain.SetControlsStateUndoImporting(State: Boolean);
begin
  miUndo.Enabled := State;
  miUndo2.Enabled := State;
  tbUndo.Enabled := State;
end;

procedure TfrmMain.SetStatusText(const Value: string);
begin
  if Value = '' then
    sbMain.Panels[2].Text := 'Ready'
  else
    sbMain.Panels[2].Text := Value;
  Application.ProcessMessages;
end;

procedure TfrmMain.SetWindowTitleCaption(const FileName: TFileName);
begin
  if FileName = '' then
    Caption := StoredCaption
  else
    Caption := ExtractFileName(FileName) + ' - ' + StoredCaption;
  Application.Title := Caption;
end;

procedure TfrmMain.ReportFailure(Text, AdditionalDebugText, Caption: string;
  FailureType: TLineType);
var
  MsgIcon: Integer;
  
begin
  MsgIcon := 0;
  case FailureType of
    ltInformation: MsgIcon := MB_ICONINFORMATION;
    ltWarning: MsgIcon := MB_ICONWARNING;
    ltCritical: MsgIcon := MB_ICONERROR;
  end;

  if AdditionalDebugText <> '' then
    AdditionalDebugText := ' [' + AdditionalDebugText + '].';
  AddDebug(FailureType, Text + AdditionalDebugText);
  MsgBox(Text, Caption, MsgIcon + MB_OK);
end;

end.
