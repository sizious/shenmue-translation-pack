unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IpacMgr, Menus, ComCtrls, JvExComCtrls, JvListView, ImgList, ToolWin,
  JvToolBar, Themes;

type
  TfrmMain = class(TForm)
    mmMain: TMainMenu;
    miFile: TMenuItem;
    miOpen: TMenuItem;
    N1: TMenuItem;
    miQuit: TMenuItem;
    miDebugMenu: TMenuItem;
    miDebugTest1: TMenuItem;
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
    N7: TMenuItem;
    GZipDecompress1: TMenuItem;
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
    ilToolbarDisabled: TImageList;
    odImport: TOpenDialog;
    sdSave: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miDebugTest1Click(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure lvIpacContentColumnClick(Sender: TObject; Column: TListColumn);
    procedure tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure miQuitClick(Sender: TObject);
    procedure GZipDecompress1Click(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miReloadClick(Sender: TObject);
    procedure miExportClick(Sender: TObject);
    procedure miImportClick(Sender: TObject);
    procedure miSaveAsClick(Sender: TObject);
  private
    { Déclarations privées }
    fStoredCaption: string;
    fFileModified: Boolean;
    function GetSelectedContentEntry: TIpacSectionsListItem;
    procedure SetFileModified(const Value: Boolean);
    procedure UpdateToolbarActions;
    property StoredCaption: string read fStoredCaption write fStoredCaption;
  protected
    procedure Clear; overload;
    procedure Clear(const OnlyUI: Boolean); overload;
    procedure ClearColumnsImages;
    procedure InitFileOperationDialogFilter(TargetDialog: TOpenDialog;
      const SpecificFilter: string);
    function GetFileOperationDialogFilterIndex(TargetDialog: TOpenDialog;
      SelectedContentEntry: TIpacSectionsListItem): Integer;
    function KindToImageIndex(Kind: string): Integer;
    procedure LoadFile(const FileName: TFileName);
    function SaveFileOnDemand(CancelButton: Boolean): Boolean;
    procedure SetWindowTitleCaption(const FileName: TFileName);
  public
    { Déclarations publiques }
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
    property FileModified: Boolean read fFileModified write SetFileModified;
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
  IpacUtil, GZipMgr, Utils;

procedure TfrmMain.Clear(const OnlyUI: Boolean);
begin
  if not OnlyUI then
    IPACEditor.Clear;
  ClearColumnsImages;
  lvIpacContent.Clear;
  SetWindowTitleCaption('');
  FileModified := False;
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

procedure TfrmMain.miCloseClick(Sender: TObject);
begin
  if not SaveFileOnDemand(True) then Exit;
  Clear;
end;

procedure TfrmMain.miDebugTest1Click(Sender: TObject);
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
end;

procedure TfrmMain.miExportClick(Sender: TObject);
begin
  with sdExport do begin
    FileName := SelectedContentEntry.Name;

    // Select the right filter
    DefaultExt := SelectedContentEntry.FileSectionDetails.Extension;
    FilterIndex := GetFileOperationDialogFilterIndex(sdExport, SelectedContentEntry);

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
    FilterIndex := GetFileOperationDialogFilterIndex(odImport, SelectedContentEntry);

    // Loading IPAC content section
    if Execute then
      FileModified := SelectedContentEntry.ImportFromFile(FileName);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Init the Main Form
  Caption := Application.Title;
  StoredCaption := Caption;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;

  // Creating the main IPAC Editor object
  IPACEditor := TIpacEditor.Create;
  Clear;

  // Init the ExportDialog Filter
  InitFileOperationDialogFilter(sdExport, '');
  InitFileOperationDialogFilter(odImport, '');

  // Initialize the Toolbar actions
  UpdateToolbarActions;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Destroying the IPAC Object
  IPACEditor.Free;
end;

function TfrmMain.GetFileOperationDialogFilterIndex(TargetDialog: TOpenDialog;
  SelectedContentEntry: TIpacSectionsListItem): Integer;
var
  i: Integer;
  SpecificFilter: string;

begin
  SpecificFilter := '';
  
  with SelectedContentEntry do begin
    // If we know more that is an 'CHRM' or 'BIN ' entry... we'll add the entry
    // in the first filter index
    if ExpandedFileSectionDetails then begin
      SpecificFilter := FileSectionDetails.Description + ' (*.' +
        FileSectionDetails.Extension + ')|*.' + FileSectionDetails.Extension + '|';
      Result := 0;
    end else begin
      // Selecting the right filter in the combo
      Result := High(IPAC_SECTION_KINDS) + 2; // select the "all files"
      for i := Low(IPAC_SECTION_KINDS) to High(IPAC_SECTION_KINDS) do
        if (IPAC_SECTION_KINDS[i].Extension) = FileSectionDetails.Extension then
          Result := i + 1;
    end;
  end;

  // Filling the dialog with the filters...
  InitFileOperationDialogFilter(TargetDialog, SpecificFilter);
end;

function TfrmMain.GetSelectedContentEntry: TIpacSectionsListItem;
begin
  try
    Result := IPACEditor.Content[Integer(lvIpacContent.Selected.Data)];
  except
    raise
      EIpacNotOpened.Create('Please open a IPAC file first (or disable the action control) !!');
  end;
end;

procedure TfrmMain.GZipDecompress1Click(Sender: TObject);
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

procedure TfrmMain.InitFileOperationDialogFilter(TargetDialog: TOpenDialog;
  const SpecificFilter: string);
var
  i: Integer;
  
begin
  TargetDialog.Filter := SpecificFilter;
  for i := Low(IPAC_SECTION_KINDS) to High(IPAC_SECTION_KINDS) do
    TargetDialog.Filter := TargetDialog.Filter +
      IPAC_SECTION_KINDS[i].Description + ' File (*.' +
      IPAC_SECTION_KINDS[i].Extension + ')|*.' + IPAC_SECTION_KINDS[i].Extension + '|';
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

procedure TfrmMain.UpdateToolbarActions;
var
  i: Integer;
  MenuName: TComponentName;
  MenuItem: TMenuItem;
  ShortCutStr: string;

begin
  for i := 0 to tbMain.ButtonCount - 1 do
    if tbMain.Buttons[i].Style = tbsButton then begin
      MenuName := 'mi' +
        Copy(tbMain.Buttons[i].Name, 3, Length(tbMain.Buttons[i].Name) - 2);
      MenuItem := FindComponent(MenuName) as TMenuItem;

      // setting action for the Tool button
      if Assigned(MenuItem) then begin
        tbMain.Buttons[i].Caption := StringReplace(MenuItem.Caption, '&', '', [rfReplaceAll]);
        ShortCutStr := ShortCutToText(MenuItem.ShortCut);
        if ShortCutStr <> '' then
          ShortCutStr := ' (' + ShortCutStr + ')';
        tbMain.Buttons[i].Hint := tbMain.Buttons[i].Caption + ShortCutStr;
        tbMain.Buttons[i].OnClick := MenuItem.OnClick;
      end else
        raise EInvalidToolbarButton.Create('Invalid main menu item : ' + MenuName + '.');
    end; // Style = tbsButton
end;

function TfrmMain.KindToImageIndex(Kind: string): Integer;
begin
  Result := -1;
  if Kind = IPAC_BIN then
    Result := 0
  else if Kind = IPAC_CHRM then
    Result := 1;
end;

procedure TfrmMain.LoadFile(const FileName: TFileName);
var
  i: Integer;

begin
  if IPACEditor.LoadFromFile(FileName) then begin
    // Clearing UI
    Clear(True);

    // Adding entries
    for i := 0 to IPACEditor.Content.Count - 1 do
      with lvIpacContent.Items.Add do
        with IPACEditor.Content[i] do begin
          Data := Pointer(i);
          Caption := GetOutputFileName;
          SubItems.Add(FileSectionDetails.Description);
          SubItems.Add(IntToStr(AbsoluteOffset));
          SubItems.Add(IntToStr(Size));
          ImageIndex := KindToImageIndex(Kind);
        end;

    // Changing title
    SetWindowTitleCaption(IPACEditor.SourceFileName);

  end else
    MsgBox('This file doesn''t contain a valid IPAC section.', 'Warning', MB_ICONWARNING);
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

procedure TfrmMain.miOpenClick(Sender: TObject);
begin
  with odOpen do
    if Execute then begin
      if not SaveFileOnDemand(True) then Exit;      
      LoadFile(FileName);
    end;
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
begin
  with sdSave do begin
    FileName := ExtractFileName(IPACEditor.SourceFileName);
    DefaultExt := ExtractFileExt(IPACEditor.SourceFileName);
    DefaultExt := Copy(DefaultExt, 2, Length(DefaultExt) - 1);
    if Execute then begin
      IPACEditor.SaveToFile(FileName);
    end;
  end;
end;

function TfrmMain.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

function TfrmMain.SaveFileOnDemand(CancelButton: Boolean): Boolean;
begin
  Result := True;
end;

procedure TfrmMain.SetFileModified(const Value: Boolean);
begin
  fFileModified := Value;
  if Value then
    sbMain.Panels[1].Text := 'Modified'
  else
    sbMain.Panels[1].Text := '';
end;

procedure TfrmMain.SetWindowTitleCaption(const FileName: TFileName);
begin
  if FileName = '' then
    Caption := StoredCaption
  else
    Caption := StoredCaption + ' - [' + ExtractFileName(FileName) + ']';
end;

end.
