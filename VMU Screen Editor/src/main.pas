unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, LCDEdit, ImgList, ComCtrls, ToolWin, JvExComCtrls, JvToolBar,
  JvListView, ExtCtrls, StdCtrls, JvBaseDlg, JvBrowseFolder, ExtDlgs, DebugLog;

type
  TfrmMain = class(TForm)
    mmMain: TMainMenu;
    miFile: TMenuItem;
    miQuit: TMenuItem;
    lvIwadContent: TJvListView;
    miOpen: TMenuItem;
    odOpen: TOpenDialog;
    sbMain: TStatusBar;
    N1: TMenuItem;
    miSave: TMenuItem;
    miSaveAs: TMenuItem;
    N2: TMenuItem;
    miClose: TMenuItem;
    N3: TMenuItem;
    miEdit: TMenuItem;
    miUndo: TMenuItem;
    N4: TMenuItem;
    miImport: TMenuItem;
    miExport: TMenuItem;
    N5: TMenuItem;
    miExportAll: TMenuItem;
    miHelp: TMenuItem;
    miProjectHome: TMenuItem;
    miCheckForUpdate: TMenuItem;
    N6: TMenuItem;
    miAbout: TMenuItem;
    pmIwadContent: TPopupMenu;
    miUndo2: TMenuItem;
    N7: TMenuItem;
    miImport2: TMenuItem;
    miExport2: TMenuItem;
    N8: TMenuItem;
    miExportAll2: TMenuItem;
    bfdExportAll: TJvBrowseForFolderDialog;
    sdExport: TSaveDialog;
    odImport: TOpenPictureDialog;
    sdSave: TSaveDialog;
    miView: TMenuItem;
    miDebugLog: TMenuItem;
    N9: TMenuItem;
    miPreview: TMenuItem;
    ilToolBarDisabled: TImageList;
    ilToolBar: TImageList;
    tbMain: TJvToolBar;
    ToolButton1: TToolButton;
    tbOpen: TToolButton;
    tbReload: TToolButton;
    tbSave: TToolButton;
    ToolButton4: TToolButton;
    tbUndo: TToolButton;
    ToolButton8: TToolButton;
    tbImport: TToolButton;
    tbExport: TToolButton;
    ToolButton10: TToolButton;
    tbExportAll: TToolButton;
    ToolButton11: TToolButton;
    tbDebugLog: TToolButton;
    tbPreview: TToolButton;
    ToolButton17: TToolButton;
    tbAbout: TToolButton;
    miReload: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miQuitClick(Sender: TObject);
    procedure lvIwadContentSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure miUndoClick(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure miImportClick(Sender: TObject);
    procedure miExportClick(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure miSaveAsClick(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miExportAllClick(Sender: TObject);
    procedure miDebugLogClick(Sender: TObject);
    procedure miPreviewClick(Sender: TObject);
    procedure tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
  private
    { Déclarations privées }
    fFileModified: Boolean;
    fSelectedContentUI: TListItem;
    fDebugLogVisible: Boolean;
    fScreenPreview: Boolean;
    fStoredCaption: string;
    procedure DebugLogExceptionEvent(Sender: TObject; E: Exception);
    procedure DebugLogMainFormToFront(Sender: TObject);
    procedure DebugLogVisibilityChange(Sender: TObject; const Visible: Boolean);
    procedure DebugLogWindowActivated(Sender: TObject);
    function GetStatusText: string;
    procedure SetStatusText(const Value: string);
    function GetSelectedContentEntry: TVmuLcdEntry;
    procedure SetDebugLogVisible(const Value: Boolean);
    procedure SetScreenPreview(const Value: Boolean);
  protected
    procedure Clear; overload;
    procedure Clear(const UpdateOnlyUI: Boolean); overload;
    procedure InitDebugLog;
    procedure LoadFile(FileName: TFileName);
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
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
    property DebugLogVisible: Boolean read fDebugLogVisible
      write SetDebugLogVisible;    
    property FileModified: Boolean read fFileModified;
    property SelectedContentUI: TListItem read fSelectedContentUI;
    property ScreenPreview: Boolean read fScreenPreview write SetScreenPreview;
    property StatusText: string read GetStatusText write SetStatusText;
    property SelectedContentEntry: TVmuLcdEntry read GetSelectedContentEntry;
  end;

  ExceptionGUI = class(Exception);
  EIwadNotOpened = class(ExceptionGUI);

var
  frmMain: TfrmMain;

  LcdEditor: TVmuLcdEditor;
  DebugLog: TDebugLogHandlerInterface;

implementation

{$R *.dfm}

uses
  Themes, Preview, UITools, Utils;
  
procedure TfrmMain.AddDebug(LineType: TLineType; Text: string);
begin
  DebugLog.AddLine(LineType, Text);
end;

procedure TfrmMain.Clear(const UpdateOnlyUI: Boolean);
begin
  if not UpdateOnlyUI then begin
    LcdEditor.Clear;
    lvIwadContent.Clear;
    SetWindowTitleCaption('');
  end;

  UpdateFileModifiedState;
  SetControlsStateUndoImporting(False);
  SetControlsStateFileOperations(False);
  SetControlsStateSaveOperation(False);

  StatusText := '';
end;

procedure TfrmMain.DebugLogExceptionEvent(Sender: TObject; E: Exception);
begin
  showmessage('DebugLogExceptionEvent');
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
//  showmessage('DebugLogWindowActivated');
end;

procedure TfrmMain.Clear;
begin
  Clear(False);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Initialize modules
  InitDebugLog;
  LcdEditor := TVmuLcdEditor.Create;

  // Init the Main Form
  Caption := Application.Title + ' v' + GetAppVersion;
  StoredCaption := Caption;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;

  // Init the UI
  InitToolBarControl(Self, tbMain);
  Clear(False);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Destroying modules
  LcdEditor.Free;
  DebugLog.Free;
end;

function TfrmMain.GetSelectedContentEntry: TVmuLcdEntry;
begin
  try
    Result := LcdEditor.Items[Integer(SelectedContentUI.Data)];
  except
    raise
      EIwadNotOpened.Create('Please open a IWAD file first (or disable the action control) !!');
  end;
end;

function TfrmMain.GetStatusText: string;
begin
  Result := sbMain.Panels[2].Text;
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

    // Setting up the properties
//    Configuration := GetConfigurationObject; // in this order!
  end;
end;

procedure TfrmMain.miPreviewClick(Sender: TObject);
begin
  ScreenPreview := not ScreenPreview;
end;

procedure TfrmMain.LoadFile(FileName: TFileName);
var
  i, j: Integer;
  UpdateUI: Boolean;
  ListItem: TListItem;

begin
  // Extending filenames
  FileName := ExpandFileName(FileName);
  UpdateUI := SameText(FileName, LcdEditor.SourceFileName);

  // Checking the file
  if not FileExists(FileName) then begin
(*    ReportFailure('The file "' + FileName + '" doesn''t exists.',
      'FullFileName: ' + FileName, 'Warning', ltWarning); *)
    Exit;
  end;

  // Updating UI
  StatusText := 'Loading file...';
  Clear(UpdateUI);  

  // Loading the file
  if LcdEditor.LoadFromFile(FileName) then begin

    // Filling the UI with the IWAD content
    if LcdEditor.Count > 0 then begin

      // Adding entries
      for i := 0 to LcdEditor.Count - 1 do begin
        ListItem := nil;

        // Checking if we must update the current view...
        if UpdateUI then
          ListItem := lvIwadContent.FindData(0, Pointer(i), True, False); // finding the correct index

        (*  If we ListItem = nil, it says that we don't have found the correct
            Item index, or we opened a new file. So we'll create a new item
            and prepare it to be updated. *)
        if not Assigned(ListItem) then begin
          ListItem := lvIwadContent.Items.Add;
          ListItem.Caption := '';
          j := 0;
          repeat
            ListItem.SubItems.Add('');
            Inc(j);
          until j = 6;
        end;

        // Updating the current item with the new values
        with ListItem do
          with LcdEditor.Items[i] do begin
            Data := Pointer(i);
            Caption := IntToStr(i);
            SubItems[0] := Name;
            SubItems[1] := IntToStr(Offset);
            SubItems[2] := IntToStr(Size);
            SubItems[3] := IntToStr(Dimension.Width);
            SubItems[4] := IntToStr(Dimension.Height);
            SubItems[5] := ''; // for updated
//            ImageIndex := GetKindIndex(ExpandedKind.Name);
          end;
      end;

      // Updating UI
      if not UpdateUI then begin
        SetWindowTitleCaption(LcdEditor.SourceFileName);
        AddDebug(ltInformation, 'Load successfully done for "'
          + LcdEditor.SourceFileName + '".');
      end;
      SetControlsStateFileOperations(True);

      // Refreshing the view
      if Assigned(SelectedContentUI) then
        lvIwadContentSelectItem(Self, SelectedContentUI, True);

    end else begin
      StatusText := 'IWAD empty ! Loading aborted...';
(*      ReportFailure('This file contains a valid IPAC section, but the section itself is empty.',
        'FileName: ' + FileName, 'Nothing to edit in this file', ltInformation);
*)    end;

  end else
(*    ReportFailure('This file isn''t a valid IWAD file.',
      'FileName: ' + FileName, 'Warning', ltWarning);
*) msgbox('error','error', 0);

  StatusText := '';
end;

procedure TfrmMain.lvIwadContentSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then begin
    fSelectedContentUI := Item;
    SetControlsStateUndoImporting(SelectedContentEntry.Updated);
    frmPreview.AssignBitmap(SelectedContentEntry.DecodedImage);
  end;
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
      Directory := IncludeTrailingPathDelimiter(Directory);
      for i := 0 to LcdEditor.Count - 1 do begin
        LcdEditor[i].ExportToFile(Directory + Trim(LcdEditor[i].Name) + '.BMP');
        if (i mod 5) = 0 then
          Application.ProcessMessages;
      end;
      frmMain.StatusText := '';
      MsgBox('All the IWAD content was succesfully exported.',
        'Information', MB_ICONINFORMATION);
    end;
end;

procedure TfrmMain.miExportClick(Sender: TObject);
begin
  with sdExport do begin
    FileName := SelectedContentEntry.Name;

    // Saving IWAD content section
    if Execute then begin
      StatusText := 'Exporting...';
      SelectedContentEntry.ExportToFile(FileName);
      StatusText := '';
      AddDebug(ltInformation, Format(
        'The current entry #%d [%s] was successfully saved to the "%s" file.',
        [SelectedContentEntry.Index, SelectedContentEntry.Name,
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

    // Do the import
    if Execute then begin
      Buf := Format(' for #%d [%s] from "%s".',
        [SelectedContentEntry.Index, SelectedContentEntry.Name, FileName]);

      StatusText := 'Importing...';
      if SelectedContentEntry.ImportFromFile(FileName) then begin
        SetControlsStateSelectedContentModified(True);
        SetControlsStateUndoImporting(True);
        AddDebug(ltInformation, 'Import done successfully' + Buf);
      end else
        AddDebug(ltWarning, 'Unable to import' + Buf);
      StatusText := '';
    end;

  end; // with
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

procedure TfrmMain.miSaveAsClick(Sender: TObject);
var
  Buf: string;
  ReloadFromDisk: Boolean;

begin
  with sdSave do begin
    FileName := ExtractFileName(LcdEditor.SourceFileName);
    Buf := ExtractFileExt(LcdEditor.SourceFileName);
    DefaultExt := Copy(Buf, 2, Length(Buf) - 1);

    // Executing dialog
    if Execute then begin
      StatusText := 'Saving file...';
      ReloadFromDisk := FileName = LcdEditor.SourceFileName;

      // Saving on the disk
      Buf := ' for "' + LcdEditor.SourceFileName + '" to "' + FileName + '".';
      if LcdEditor.SaveToFile(FileName) then
        AddDebug(ltInformation, 'Save successfully done' + Buf)
      else
        AddDebug(ltWarning, 'Unable to do the save' + Buf);

      // Reloading the view if needed
      if ReloadFromDisk then
        LoadFile(LcdEditor.SourceFileName);
      StatusText := '';
    end;
  end;
end;

procedure TfrmMain.miSaveClick(Sender: TObject);
begin
  StatusText := 'Saving file...';
  if LcdEditor.Save then
    AddDebug(ltInformation, Format('Save successfully done on the disk for "%s".',
      [LcdEditor.SourceFileName])
    )
  else
    MsgBox(
      Format('Unable to save on disk for "%s".',
      [LcdEditor.SourceFileName]),
      'Warning',
      MB_ICONWARNING
    );
  LoadFile(LcdEditor.SourceFileName);
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
      SelectedContentEntry.Index, SelectedContentEntry.Name,
        LcdEditor.SourceFileName]));
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
  miImport2.Enabled := State;
  tbImport.Enabled := State;
  miExport.Enabled := State;
  miExport2.Enabled := State;
  tbExport.Enabled := State;
  miExportAll.Enabled := State;
  miExportAll2.Enabled := State;
  tbExportAll.Enabled := State;
  miReload.Enabled := State;
  tbReload.Enabled := State;
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
  SelectedContentUI.SubItems[5] := Value;
  UpdateFileModifiedState;
  SetControlsStateUndoImporting(State);
end;

procedure TfrmMain.SetControlsStateUndoImporting(State: Boolean);
begin
  miUndo.Enabled := State;
  miUndo2.Enabled := State;
  tbUndo.Enabled := State;
//  btnUndo.Enabled := State;
end;

procedure TfrmMain.SetDebugLogVisible(const Value: Boolean);
begin
  DebugLog.Active := Value;
end;

procedure TfrmMain.SetScreenPreview(const Value: Boolean);
begin
  if fScreenPreview <> Value then begin
    fScreenPreview := Value;
    miPreview.Checked := Value;
    tbPreview.Down := Value;

    with frmPreview do
      if (Value) and (not Visible) then
        Show
      else if (not Value) and (Visible) then
        Close;
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

procedure TfrmMain.SetWindowTitleCaption(const FileName: TFileName);
begin
  if FileName = '' then
    Caption := StoredCaption
  else
    Caption := ExtractFileName(FileName) + ' - ' + StoredCaption;
  Application.Title := Caption;
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
  ContentIsModified: Boolean;

begin
  // Checking if a Iwad content entry is modified
  i := 0;
  ContentIsModified := False;
  while (i < LcdEditor.Count) and (not ContentIsModified) do begin
    ContentIsModified := LcdEditor.Items[i].Updated;
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
