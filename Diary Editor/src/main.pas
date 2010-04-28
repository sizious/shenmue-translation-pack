unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MemoEdit, Menus, ImgList, ComCtrls, ToolWin, JvExComCtrls,
  JvToolBar;

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
    Button1: TButton;
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
    eRightPageNumber: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNextClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure bPrevClick(Sender: TObject);
    procedure tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure miDEBUG_TEST1Click(Sender: TObject);
  private
    fPageNumber: Integer;
    { Déclarations privées }
    procedure ClearEdits(PageType: TPagePosition);
    procedure FreeModules;
    procedure InitModules;
    function GetLineEdit(Page: TPagePosition; const LineIndex: Integer;
      var EditCtrl: TEdit): Boolean;
    function GetOriginalTextMemo(Page: TPagePosition): TMemo;
    procedure SetPageNumber(const Value: Integer);
  public
    { Déclarations publiques }
    procedure Clear;
    function LoadPage(const LeftPageIndex: Integer): Boolean;
    property PageNumber: Integer read fPageNumber write SetPageNumber;
  end;

var
  frmMain: TfrmMain;
  DiaryEditor: TDiaryEditor;

implementation

{$R *.dfm}

uses
  UITools;
  
procedure TfrmMain.Button1Click(Sender: TObject);
begin
  PageNumber := StrToIntDef(ePageNumber.Text, 0);
end;

procedure TfrmMain.bPrevClick(Sender: TObject);
begin
  PageNumber := PageNumber - 2;
end;

procedure TfrmMain.bNextClick(Sender: TObject);
begin
  PageNumber := PageNumber + 2;
end;

procedure TfrmMain.Clear;
begin
  ClearEdits(ptLeft);
  ClearEdits(ptRight);
  PageNumber := 0;
end;

procedure TfrmMain.ClearEdits(PageType: TPagePosition);
var
  i: Integer;
  EditCtrl: TEdit;

begin
  for i := 0 to 4 do begin
    if GetLineEdit(PageType, i, EditCtrl) then begin
      ChangeEditEnabledState(EditCtrl, False);
      EditCtrl.Text := '';
    end;
  end;
  GetOriginalTextMemo(PageType).Clear;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title + ' v' + '0.0';

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
  const LineIndex: Integer; var EditCtrl: TEdit): Boolean;
var
  EditName: string;

begin
  // Build the TEdit.Name
  case Page of
    ptLeft:
      EditName := 'eLeft';
    ptRight:
      EditName := 'eRight';
  end;
  EditName := EditName + IntToStr(LineIndex);

  // Search the Edit on the Form
  EditCtrl := FindComponent(EditName) as TEdit;
  Result := Assigned(EditCtrl);
end;

function TfrmMain.GetOriginalTextMemo(Page: TPagePosition): TMemo;
begin
  Result := nil;
  case Page of
    ptLeft: Result := mOriginalLeft;
    ptRight: Result := mOriginalRight;
  end;
end;

procedure TfrmMain.InitModules;
begin
  DiaryEditor := TDiaryEditor.Create;
end;

function TfrmMain.LoadPage(const LeftPageIndex: Integer): Boolean;
var
  RightPageIndex: Integer;
  EditCtrl: TEdit;

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

        if GetLineEdit(Page, i, EditCtrl) then
          if Messages[i].Editable then begin
            EditCtrl.Text := Messages[i].Text;
            ChangeEditEnabledState(EditCtrl, True);
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
  DiaryEditor.LoadFromFile('memodata.bin');
//  DiaryEditor.Pages[2].Messages[0].Text := 'BLOAH!';
  DiaryEditor.SaveToFile('BLAh.bin');
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miOpenClick(Sender: TObject);
begin
  DiaryEditor.LoadFromFile('MEMODATA.BIN');
  PageNumber := 0;
end;

procedure TfrmMain.SetPageNumber(const Value: Integer);
var
  OldValue: Integer;

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

  // Update UI
  bPrev.Enabled := (fPageNumber > 0) and DiaryEditor.Loaded;
  bNext.Enabled := (fPageNumber < DiaryEditor.Pages.Count - 1) and DiaryEditor.Loaded;
  ePageNumber.Text := IntToStr(fPageNumber);
  eRightPageNumber.Text := IntToStr(fPageNumber + 1);
end;

procedure TfrmMain.tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
  var DefaultDraw: Boolean);
begin
  ToolBarCustomDraw(tbMain);
end;

end.
