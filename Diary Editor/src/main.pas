unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MemoEdit, Menus, ImgList, ComCtrls, ToolWin, JvExComCtrls,
  JvToolBar, JvEdit, JvExStdCtrls, AppEvnts, ExtCtrls;

type
  TPagePosition = (ptLeft, ptRight);
  
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
    tbPreview: TToolButton;
    tbOriginal: TToolButton;
    tbCharset: TToolButton;
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
    Quit1: TMenuItem;
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNextClick(Sender: TObject);
    procedure bGoClick(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure bPrevClick(Sender: TObject);
    procedure tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure miDEBUG_TEST1Click(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure bFirstClick(Sender: TObject);
    procedure bLastClick(Sender: TObject);
    procedure miDEBUG_TEST2Click(Sender: TObject);
    procedure miExportClick(Sender: TObject);
    procedure miDEBUG_TEST3Click(Sender: TObject);
    procedure ePageNumberKeyPress(Sender: TObject; var Key: Char);
  private
    fPageNumber: Integer;
    fFileModified: Boolean;
    { Déclarations privées }
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
  public
    { Déclarations publiques }
    procedure Clear;
    function LoadPage(const LeftPageIndex: Integer): Boolean;
    property FileModified: Boolean read fFileModified write SetFileModified;    
    property PageNumber: Integer read fPageNumber write SetPageNumber;
    property StatusText: string read GetStatusText write SetStatusText;    
  end;

var
  frmMain: TfrmMain;
  DiaryEditor: TDiaryEditor;

implementation

{$R *.dfm}

uses
  UITools, SysTools;
  
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
      ChangeEditEnabledState(LineEditCtrl, False);
      ChangeEditEnabledState(TimeCodeLineCtrl, False);
      LineEditCtrl.Text := '';
      TimeCodeLineCtrl.Text := '';
    end;
  end;
  GetOriginalTextMemo(PageType).Clear;
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
  InitUI;

  InitModules;

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
  Caption := Application.Title + ' v' + '0.0';
  MakeNumericOnly(ePageNumber.Handle);

  // Init TimeCode edits
  InitTimeCodeEdits(ptLeft);
  InitTimeCodeEdits(ptRight);
end;

function TfrmMain.LoadPage(const LeftPageIndex: Integer): Boolean;
var
  RightPageIndex: Integer;
  LineEditCtrl, TimeCodeEditCtrl: TEdit;

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

        if GetLineEdit(Page, i, LineEditCtrl, TimeCodeEditCtrl) then
          if Messages[i].Editable then begin
            LineEditCtrl.Text := Messages[i].Text;
            TimeCodeEditCtrl.Text := IntToStr(Messages[i].FlagCode);
            ChangeEditEnabledState(LineEditCtrl, True);
            ChangeEditEnabledState(TimeCodeEditCtrl, True);
          end;

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

procedure TfrmMain.miDEBUG_TEST1Click(Sender: TObject);
{$IFDEF DEBUG}
begin
  DiaryEditor.LoadFromFile('memodata.bin', 'memoflg.bin');
//  DiaryEditor.Pages[2].Messages[0].Text := '@55555\eåöåúåúåúåúåúåúåúæ£!';
  DiaryEditor.Pages[269].Messages[0].Text := 'K-OTIC!!!!';
  DiaryEditor.SaveToFile('BLAh.bin');
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
      if DiaryEditor.Pages[p].Messages[m].Editable then
        DiaryEditor.Pages[p].Messages[m].Text := S;
    end;

  DiaryEditor.SaveToFile('STRONG.BIN');

  // 2nd phase
  DiaryEditor.LoadFromFile('STRONG.BIN', 'MEMOFLG.BIN');
  DiaryEditor.Pages.ImportFromFile('MEMODATA.XML');
  DiaryEditor.SaveToFile('STRONG.NEW');

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
      'MSTR' + ExtractFileExt(DiaryEditor.SourceFileName) + '.CSV'
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

procedure TfrmMain.miExportClick(Sender: TObject);
begin
  DiaryEditor.Pages.ExportToFile('MEMODATA.XML');
  DiaryEditor.Pages.ExportToCSV('MEMODATA.CSV');
end;

procedure TfrmMain.miOpenClick(Sender: TObject);
begin
  DiaryEditor.LoadFromFile('MEMODATA.BIN', 'MEMOFLG.BIN');
  PageNumber := 0;
end;

procedure TfrmMain.Quit1Click(Sender: TObject);
begin
  Close;
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
  bNext.Enabled := (RightPageIndex < DiaryEditor.Pages.Count - 1) and DiaryEditor.Loaded;
  bLast.Enabled := bNext.Enabled;
  bFirst.Enabled := bPrev.Enabled;
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
