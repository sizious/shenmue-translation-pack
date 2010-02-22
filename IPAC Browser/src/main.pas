unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IpacMgr, Menus, ComCtrls, JvExComCtrls, JvListView, ImgList, ToolWin,
  JvToolBar, Themes, AppEvnts, JvBaseDlg, JvBrowseFolder, IpacUtil, DebugLog;

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
  private
    { Déclarations privées }
    fStoredCaption: string;
    fFileModified: Boolean;
    fSelectedContentUI: TListItem;
    fDebugLogVisible: Boolean;
    fAutoSave: Boolean;
    fMakeBackup: Boolean;
    function GetSelectedContentEntry: TIpacSectionsListItem;
    procedure SetDebugLogVisible(const Value: Boolean);
    function GetStatusText: string;
    procedure SetStatusText(const Value: string);
    procedure SetAutoSave(const Value: Boolean);
    procedure SetMakeBackup(const Value: Boolean);
  protected
    procedure Clear; overload;
    procedure Clear(const OnlyUI: Boolean); overload;
    procedure ClearColumnsImages;
    function ExtendedKindToFilterString(
      SectionKind: TIpacSectionKind): string;
    function GetFileOperationDialogFilterIndex(
      TargetDialog: TOpenDialog): Integer;
    procedure InitToolbarControl;
    procedure InitContentPopupMenuControl;
    function SaveFileOnDemand(CancelButton: Boolean): Boolean;
    procedure SetControlsStateFileOperations(State: Boolean);
    procedure SetControlsStateSaveOperation(State: Boolean);
    procedure SetControlsStateSelectedContentModified(State: Boolean);
    procedure SetControlsStateUndoImporting(State: Boolean);
    procedure SetWindowTitleCaption(const FileName: TFileName);
    procedure UpdateFileModifiedState;
    property StoredCaption: string read fStoredCaption write fStoredCaption;
  public
    { Déclarations publiques }
    procedure AddDebug(LineType: TLineType; Text: string);
    function MsgBox(Text: string): Integer; overload;
    function MsgBox(Text, Caption: string; Flags: Integer): Integer; overload;
    procedure LoadFile(const FileName: TFileName);    

    property AutoSave: Boolean read fAutoSave write SetAutoSave;
    property DebugLogVisible: Boolean read fDebugLogVisible write SetDebugLogVisible;
    property FileModified: Boolean read fFileModified;
    property MakeBackup: Boolean read fMakeBackup write SetMakeBackup;
    property StatusText: string read GetStatusText write SetStatusText;
    property SelectedContentUI: TListItem read fSelectedContentUI;
    property SelectedContentEntry: TIpacSectionsListItem
      read GetSelectedContentEntry;
  end;

  ExceptionGUI = class(Exception);
  EIpacNotOpened = class(ExceptionGUI);
  EInvalidToolbarButton = class(ExceptionGUI);

var
  frmMain: TfrmMain;
  IPACEditor: TIpacEditor;

implementation

{$R *.dfm}

uses
  GZipMgr, Utils;

procedure TfrmMain.Clear(const OnlyUI: Boolean);
begin
  if not OnlyUI then
    IPACEditor.Clear;
  ClearColumnsImages;
  lvIpacContent.Clear;
  SetWindowTitleCaption('');
  UpdateFileModifiedState;
  SetControlsStateUndoImporting(False);
  SetControlsStateFileOperations(False);
  SetControlsStateSaveOperation(False);
end;

procedure TfrmMain.AddDebug(LineType: TLineType; Text: string);
begin
  frmDebugLog.AddLine(LineType, Text);
end;

procedure TfrmMain.aeMainHint(Sender: TObject);
begin
  StatusText := Application.Hint;
  aeMain.CancelDispatch;
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

procedure TfrmMain.miAutoSaveClick(Sender: TObject);
begin
  AutoSave := not AutoSave;
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
begin
{$IFDEF DEBUG}
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
      StatusText := 'Exporting all...';
      for i := 0 to IPACEditor.Content.Count - 1 do
        IpacEditor.Content[i].ExportToFolder(Directory);
      StatusText := '';
    end;
end;

procedure TfrmMain.miExportClick(Sender: TObject);
begin
  with sdExport do begin
    FileName := SelectedContentEntry.Name;

    // Select the right filter
    DefaultExt := SelectedContentEntry.FileSectionDetails.Extension;
    FilterIndex := GetFileOperationDialogFilterIndex(sdExport);

    // Saving IPAC content section
    if Execute then
      SelectedContentEntry.ExportToFile(FileName);
  end;
end;

procedure TfrmMain.miImportClick(Sender: TObject);
begin
  with odImport do begin
    FileName := SelectedContentEntry.Name;

    // Select the right filter
    DefaultExt := SelectedContentEntry.FileSectionDetails.Extension;
    FilterIndex := GetFileOperationDialogFilterIndex(odImport);

    // Loading IPAC content section
    if Execute then
      if SelectedContentEntry.ImportFromFile(FileName) then begin
        SetControlsStateSelectedContentModified(True);
        SetControlsStateUndoImporting(True);
      end;

  end; // with
end;

procedure TfrmMain.miMakeBackupClick(Sender: TObject);
begin
  MakeBackup := not MakeBackup;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  aeMain.Activate;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not SaveFileOnDemand(True) then begin
    Action := caNone;
    Exit;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Init the Main Form
  Caption := Application.Title + ' v' + GetAppVersion;
  StoredCaption := Caption;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;

  // Creating the main IPAC Editor object
  IPACEditor := TIpacEditor.Create;
  Clear;

  // Initialize some UI controls
  InitToolbarControl;
  InitContentPopupMenuControl;

  // Load configuration
  LoadConfigMain;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Destroying the IPAC Object
  IPACEditor.Free;

  // Saving configuration
  SaveConfigMain;
end;

function TfrmMain.GetSelectedContentEntry: TIpacSectionsListItem;
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
    if FileSectionDetailsAvailable then begin
      TargetDialog.Filter := ExtendedKindToFilterString(FileSectionDetails);
      Result := 0;
    end;
  end;

  // Filling with all standard kinds
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

procedure TfrmMain.LoadFile(const FileName: TFileName);
var
  i: Integer;

begin
  // Checking the file
  if not FileExists(FileName) then begin
    MsgBox('The file "' + FileName + '" doesn''t exists.', 'Warning', MB_ICONWARNING);
    Exit;
  end;

  // Updating UI
  StatusText := 'Loading file...';
  Clear(True);  

  // Loading the file
  if IPACEditor.LoadFromFile(FileName) then begin

    // Filling the UI with the IPAC Content
    if IPACEditor.Content.Count > 0 then begin

      // Adding entries
      for i := 0 to IPACEditor.Content.Count - 1 do
        with lvIpacContent.Items.Add do
          with IPACEditor.Content[i] do begin
            Data := Pointer(i);
            Caption := GetOutputFileName;
            SubItems.Add(FileSectionDetails.Description);
            SubItems.Add(IntToStr(AbsoluteOffset));
            SubItems.Add(IntToStr(Size));
            SubItems.Add(''); // for updated
            ImageIndex := GetKindIndex(FileSectionDetails.Name);
          end;

      // Updating UI
      SetWindowTitleCaption(IPACEditor.SourceFileName);
      SetControlsStateFileOperations(True);
      AddDebug(ltInformation, 'The file "' + IPACEditor.SourceFileName + '" was successfully opened.');
    end else begin
      StatusText := 'IPAC section empty ! Loading aborted...';
      MsgBox('This file contains a valid IPAC section, but the section itself is empty.',
        'Nothing to edit in this file', MB_ICONINFORMATION);
    end;

  end else
    MsgBox('This file doesn''t contain a valid IPAC section.', 'Warning', MB_ICONWARNING);

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

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miReloadClick(Sender: TObject);
begin
  if not SaveFileOnDemand(True) then Exit;
  LoadFile(IPACEditor.SourceFileName);
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
    if Execute then begin
      StatusText := 'Saving file...';
      ReloadFromDisk := FileName = IPACEditor.SourceFileName;
      IPACEditor.SaveToFile(FileName);
      if ReloadFromDisk then
        LoadFile(IPACEditor.SourceFileName);
      StatusText := '';
    end;
  end;
end;

procedure TfrmMain.miSaveClick(Sender: TObject);
begin
  StatusText := 'Saving file...';
  IPACEditor.Save;
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
    Caption := StoredCaption + ' - [' + ExtractFileName(FileName) + ']';
  Application.Title := Caption;
end;

end.
