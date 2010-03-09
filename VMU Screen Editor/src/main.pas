unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, LCDEdit, ImgList, ComCtrls, ToolWin, JvExComCtrls, JvToolBar,
  JvListView, ExtCtrls, StdCtrls, JvBaseDlg, JvBrowseFolder, ExtDlgs;

type
  TfrmMain = class(TForm)
    mmMain: TMainMenu;
    miFile: TMenuItem;
    miQuit: TMenuItem;
    lvIwadContent: TJvListView;
    miOpen: TMenuItem;
    odOpen: TOpenDialog;
    pnlRightCommands: TPanel;
    sbMain: TStatusBar;
    pnlScreenPreview: TPanel;
    imgScreenPreview: TImage;
    btnImport: TButton;
    btnExport: TButton;
    btnExportAll: TButton;
    btnUndo: TButton;
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
  private
    { Déclarations privées }
    fFileModified: Boolean;
    fSelectedContentUI: TListItem;
    function GetStatusText: string;
    procedure SetStatusText(const Value: string);
    function GetSelectedContentEntry: TVmuLcdEntry;
  protected
    procedure Clear; overload;
    procedure Clear(const UpdateOnlyUI: Boolean); overload;
    procedure LoadFile(FileName: TFileName);
    function SaveFileOnDemand(CancelButton: Boolean): Boolean;
    procedure SetControlsStateFileOperations(State: Boolean);
    procedure SetControlsStateSaveOperation(State: Boolean);
    procedure SetControlsStateSelectedContentModified(State: Boolean);
    procedure SetControlsStateUndoImporting(State: Boolean);
    procedure UpdateFileModifiedState;
  public
    { Déclarations publiques }
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;    
    property FileModified: Boolean read fFileModified;
    property SelectedContentUI: TListItem read fSelectedContentUI;
    property StatusText: string read GetStatusText write SetStatusText;
    property SelectedContentEntry: TVmuLcdEntry read GetSelectedContentEntry;
  end;

  ExceptionGUI = class(Exception);
  EIwadNotOpened = class(ExceptionGUI);

var
  frmMain: TfrmMain;
  LcdEditor: TVmuLcdEditor;

implementation

{$R *.dfm}

uses
  Themes;
  
procedure TfrmMain.Clear(const UpdateOnlyUI: Boolean);
begin
  if not UpdateOnlyUI then begin
    LcdEditor.Clear;
    lvIwadContent.Clear;
//    SetWindowTitleCaption('');
  end;

  UpdateFileModifiedState;
  SetControlsStateUndoImporting(False);
  SetControlsStateFileOperations(False);
  SetControlsStateSaveOperation(False);

  StatusText := '';
end;

procedure TfrmMain.Clear;
begin
  Clear(False);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  pnlScreenPreview.DoubleBuffered := True;
  LcdEditor := TVmuLcdEditor.Create;

  // Setting the Form
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;

  // Init the UI
  Clear(False);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  LcdEditor.Free;
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

procedure TfrmMain.LoadFile(FileName: TFileName);
var
  i, j: Integer;
  UpdateUI: Boolean;
  ListItem: TListItem;

begin
  // Extending filenames
  FileName := ExpandFileName(FileName);
  UpdateUI := (FileName = LcdEditor.SourceFileName);

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

    // Filling the UI with the IPAC Content
    if LcdEditor.Count > 0 then begin

      // Adding IPAC entries
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
(*        SetWindowTitleCaption(IPACEditor.SourceFileName);
        AddDebug(ltInformation, 'Load successfully done for "' + IPACEditor.SourceFileName
          + '".');
*)      end;
      SetControlsStateFileOperations(True);

      // Updating File Properties
//      frmProperties.RefreshInfos;
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
  end;
end;

procedure TfrmMain.miCloseClick(Sender: TObject);
begin
  if not SaveFileOnDemand(True) then Exit;
  Clear;
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
        if i mod 5 = 0 then
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
(*      AddDebug(ltInformation, Format(
        'The current entry #%d [%s] was successfully saved to the "%s" file.',
        [SelectedContentEntry.Index, SelectedContentEntry.GetOutputFileName,
        FileName])
      ); *)
    end;
  end;
end;

procedure TfrmMain.miImportClick(Sender: TObject);
begin
  with odImport do begin
    FileName := SelectedContentEntry.Name;

    // Loading IPAC content section
    if Execute then begin
      StatusText := 'Importing...';
      if SelectedContentEntry.ImportFromFile(FileName) then begin
        SetControlsStateSelectedContentModified(True);
        SetControlsStateUndoImporting(True);
//        AddDebug(ltInformation, 'Entry import for ' + Buf + ' done from "' + FileName + '".');
      end else
        msgbox('error', 'error', 0);
//        AddDebug(ltWarning, 'Unable to import for ' + Buf + ' from "' + FileName + '".');
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
        MsgBox('Save successfully done' + Buf, 'Information', MB_ICONINFORMATION)
      else
        MsgBox('Unable to do the save' + Buf, 'Warning', MB_ICONWARNING);

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
    MsgBox(Format('Save successfully done on the disk for "%s".',
      [LcdEditor.SourceFileName]), 'Information', MB_ICONINFORMATION
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
  (*AddDebug(ltInformation,
    Format('The import for the entry #%d [%s] of the file "%s" was canceled.', [
      SelectedContentEntry.Index, SelectedContentEntry.GetOutputFileName,
        IPACEditor.SourceFileName]));*)
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
  btnImport.Enabled := State;
  miExport.Enabled := State;
  miExport2.Enabled := State;
  btnExport.Enabled := State;  
  miExportAll.Enabled := State;
  miExportAll2.Enabled := State;
  btnExportAll.Enabled := State;
end;

procedure TfrmMain.SetControlsStateSaveOperation(State: Boolean);
begin
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
  btnUndo.Enabled := State;
end;

procedure TfrmMain.SetStatusText(const Value: string);
begin
  if Value = '' then
    sbMain.Panels[2].Text := 'Ready'
  else
    sbMain.Panels[2].Text := Value;
  Application.ProcessMessages;
end;

procedure TfrmMain.UpdateFileModifiedState;
var
  i: Integer;
  IpacContentIsModified: Boolean;

begin
  // Checking if a Iwad content entry is modified
  i := 0;
  IpacContentIsModified := False;
  while (i < LcdEditor.Count) and (not IpacContentIsModified) do begin
    IpacContentIsModified := LcdEditor.Items[i].Updated;
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

end.
