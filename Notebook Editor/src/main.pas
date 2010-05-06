unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MemoEdit, Menus, ImgList, ComCtrls, ToolWin, JvExComCtrls,
  JvToolBar, JvEdit, JvExStdCtrls, AppEvnts, ExtCtrls, Common;

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
    sdSave: TSaveDialog;
    odOpen: TOpenDialog;
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
  private
    { Déclarations privées }
    fPageNumber: Integer;
    fFileModified: Boolean;
    fSelectedMessage: TDiaryEditorMessagesListItem;
    fSelectedFlagCodeEdit: TEdit;
    fAutoSave: Boolean;
    procedure ClearEdits(PageType: TPagePosition);
    procedure FreeModules;
    procedure InitModules;
    procedure InitUI;
    function GetLineEdit(Page: TPagePosition; const LineIndex: Integer;
      var LineEditCtrl, TimeCodeEditCtrl: TEdit): Boolean;
    function GetOriginalTextMemo(Page: TPagePosition): TMemo;
    procedure SetPageNumber(const Value: Integer);
    function GetStatusText: string;
    procedure SetStatusText(const Value: string);
    procedure SetFileModified(const Value: Boolean);
    procedure SetAutoSave(const Value: Boolean);
    property SelectedFlagCodeEdit: TEdit read fSelectedFlagCodeEdit;
  public
    { Déclarations publiques }
    procedure Clear;
    function LoadPage(const LeftPageIndex: Integer): Boolean;
    function MsgBox(const Text, Title: string; Flags: Integer): Integer;
    function SaveFileOnDemand(const CancelButton: Boolean): Boolean;
    property AutoSave: Boolean read fAutoSave write SetAutoSave;
    property FileModified: Boolean read fFileModified write SetFileModified;
    property PageNumber: Integer read fPageNumber write SetPageNumber;
    property SelectedMessage: TDiaryEditorMessagesListItem
      read fSelectedMessage;
    property StatusText: string read GetStatusText write SetStatusText;    
  end;

var
  frmMain: TfrmMain;
  DiaryEditor: TDiaryEditor;

implementation

{$R *.dfm}

uses
  UITools, SysTools, FileSel;
  
procedure TfrmMain.bGoClick(Sender: TObject);
begin
  PageNumber := StrToIntDef(ePageNumber.Text, PageNumber);
end;

procedure TfrmMain.bPrevClick(Sender: TObject);
begin
  PageNumber := PageNumber - 2;
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

procedure TfrmMain.Clear;
begin
  DiaryEditor.Clear;
  fSelectedMessage := nil;
  FileModified := False;
  StatusText := '';
  ClearEdits(ptLeft);
  ClearEdits(ptRight);
  PageNumber := 0;
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
var
  LineIndex, PageIndex: Integer;
  RightPage: Boolean;
  FlagCodeEditName: string;

begin
  fSelectedMessage := nil;
  if DiaryEditor.Loaded then begin
    // Getting UI infos
    LineIndex := (Sender as TEdit).Tag;
    PageIndex := PageNumber; // PageNumber is the GUI value
    RightPage := FindStr('Right', (Sender as TEdit).Name);
    FlagCodeEditName := 'Left';
    if RightPage then begin
      Inc(PageIndex);
      FlagCodeEditName := 'Right';
    end;
    FlagCodeEditName := 'e' + FlagCodeEditName + 'Code' + IntToStr(LineIndex);

    // Setting the Form properties
    fSelectedMessage := DiaryEditor.Pages[PageIndex].Messages[LineIndex];
    fSelectedFlagCodeEdit := FindComponent(FlagCodeEditName) as TEdit;
  end;
end;

procedure TfrmMain.eLeftCode0Change(Sender: TObject);
begin
  if (DiaryEditor.Loaded) and Assigned(SelectedMessage) then
    SelectedMessage.FlagCode := StrToIntDef((Sender as TEdit).Text, 0);
end;

procedure TfrmMain.ePageNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_RETURN) then begin
    bGo.Click;
    Key := #0;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Start Initializing...
  InitUI;

  // Creating Internal Modules
  InitModules;

  // Clearing UI
  Clear;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeModules;
end;

procedure TfrmMain.FreeModules;
begin
  DiaryEditor.Free;
end;

function TfrmMain.GetLineEdit(Page: TPagePosition;
  const LineIndex: Integer; var LineEditCtrl, TimeCodeEditCtrl: TEdit): Boolean;
var
  PagePos, LineEditName, TimeCodeEditName: string;

begin
  // Build the TEdit.Name
  case Page of
    ptLeft  : PagePos := 'eLeft';
    ptRight : PagePos := 'eRight';
  end;
  LineEditName := PagePos + IntToStr(LineIndex);
  TimeCodeEditName := PagePos + 'Code' + IntToStr(LineIndex);

  // Search the Edits on the Form
  LineEditCtrl := FindComponent(LineEditName) as TEdit;
  TimeCodeEditCtrl := FindComponent(TimeCodeEditName) as TEdit;
  
  Result := Assigned(LineEditCtrl) and Assigned(TimeCodeEditCtrl);
end;

function TfrmMain.GetOriginalTextMemo(Page: TPagePosition): TMemo;
begin
  Result := nil;
  case Page of
    ptLeft: Result := mOriginalLeft;
    ptRight: Result := mOriginalRight;
  end;
end;

function TfrmMain.GetStatusText: string;
begin
  Result := sbMain.Panels[2].Text;
end;

procedure TfrmMain.InitModules;
begin
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
  InitTimeCodeEdits(ptLeft);
  InitTimeCodeEdits(ptRight);

  // Init Toolbar
  ToolBarInitControl(Self, tbMain);
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
  Result := LoadSinglePage(LeftPageIndex, ptLeft);

  // Right page
  RightPageIndex := LeftPageIndex + 1;

  if (RightPageIndex < DiaryEditor.Pages.Count) then
    Result := Result and LoadSinglePage(RightPageIndex, ptRight)
  else
    ClearEdits(ptRight);
end;

procedure TfrmMain.miCloseClick(Sender: TObject);
begin
  if not SaveFileOnDemand(True) then Exit;
  Clear;
(*  AddDebug(ltInformation, 'Close successfully done for "' +
    IpacEditor.SourceFileName + '".'); *)
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
  DiaryEditor.Pages.ExportToFile('MEMODATA.XML');
  DiaryEditor.Pages.ExportToCSV('MEMODATA.CSV');
end;

procedure TfrmMain.miOpenClick(Sender: TObject);
begin
  with frmFileSelection do begin
    SelectionMode := fsmOpen;
    ShowModal;
    if ModalResult = mrOK then begin
      StatusText := 'Loading Notebook data...';
      DiaryEditor.LoadFromFile(SelectedDataFile, SelectedFlagFile);
      PageNumber := 0;
      StatusText := '';
    end;
  end;
end;

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miSaveAsClick(Sender: TObject);
begin
  with frmFileSelection do begin
    SelectionMode := fsmSave;
    ShowModal;
    if ModalResult = mrOK then begin
      StatusText := 'Saving Notebook data...';
      DiaryEditor.SaveToFile(SelectedDataFile, SelectedFlagFile);
      StatusText := '';
    end;
  end;
end;

procedure TfrmMain.miSaveClick(Sender: TObject);
begin
  StatusText := 'Saving Notebook data...';
  DiaryEditor.Save;
  StatusText := '';
  FileModified := False;
end;

function TfrmMain.MsgBox(const Text, Title: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
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
end;

procedure TfrmMain.SetFileModified(const Value: Boolean);
begin
  fFileModified := Value;
  if Value then
    sbMain.Panels[1].Text := 'Modified'
  else
    sbMain.Panels[1].Text := '';  
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
