unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MemoEdit, Menus, ImgList, ComCtrls, ToolWin, JvExComCtrls,
  JvToolBar;

type
  TfrmMain = class(TForm)
    Button2: TButton;
    Button3: TButton;
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
    Memo3: TMemo;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    eLeft0: TEdit;
    eLeft2: TEdit;
    eLeft3: TEdit;
    eLeft4: TEdit;
    eLeft1: TEdit;
    eRight1: TEdit;
    eRight2: TEdit;
    eRight3: TEdit;
    eRight4: TEdit;
    eRight0: TEdit;
    miDEBUG_TEST: TMenuItem;
    miDEBUG_TEST1: TMenuItem;
    ePageNumber: TEdit;
    Button1: TButton;
    miOpen: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    fPageNumber: Integer;
    { Déclarations privées }
    procedure FreeModules;
    procedure InitModules;
    procedure SetPageNumber(const Value: Integer);
  public
    { Déclarations publiques }
    procedure LoadPage(const LeftPageIndex: Integer);
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

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  PageNumber := PageNumber - 2;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  PageNumber := PageNumber + 2;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  fPageNumber := 0;
  InitModules;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeModules;
end;

procedure TfrmMain.FreeModules;
begin
  DiaryEditor.Free;
end;

procedure TfrmMain.InitModules;
begin
  DiaryEditor := TDiaryEditor.Create;
end;

procedure TfrmMain.LoadPage(const LeftPageIndex: Integer);
type
  TPageType = (ptLeft, ptRight);

var
  RightPageIndex: Integer;
  EditCtrl: TEdit;

  function PageTypeToString(PageType: TPageType): string;
  begin
    case PageType of
      ptLeft:
        Result := 'eLeft';
      ptRight:
        Result := 'eRight';
    end;
  end;

  procedure ClearEdits(PageType: TPageType);
  var
    i: Integer;

  begin
    for i := 0 to 4 do begin
      EditCtrl := FindComponent(PageTypeToString(PageType) + IntToStr(i)) as TEdit;
      if Assigned(EditCtrl) then begin
        ChangeEditEnabledState(EditCtrl, False);
        EditCtrl.Text := '';
      end;
    end;
  end;
  
  procedure LoadSinglePage(const PageIndex: Integer; PageType: TPageType);
  var
    Messages: TDiaryEditorMessagesList;
    sPageType: string;
    i: Integer;

  begin
    Messages := DiaryEditor.Pages[PageIndex].Messages;
    sPageType := PageTypeToString(PageType);

    ClearEdits(PageType);

    for i := 0 to Messages.Count - 1 do begin
      EditCtrl := FindComponent(sPageType + IntToStr(i)) as TEdit;
      if Assigned(EditCtrl) then
        if Messages[i].Editable then begin
          EditCtrl.Text := Messages[i].Text;
          ChangeEditEnabledState(EditCtrl, True);
        end;

    end; // for
  end;


begin
  // Left page
  LoadSinglePage(LeftPageIndex, ptLeft);

  // Right page
  RightPageIndex := LeftPageIndex + 1;

  if RightPageIndex < DiaryEditor.Pages.Count then  
    LoadSinglePage(RightPageIndex, ptRight)
  else
    ClearEdits(ptRight);
end;

procedure TfrmMain.miOpenClick(Sender: TObject);
begin
  DiaryEditor.LoadFromFile('MEMODATA.BIN');
end;

procedure TfrmMain.SetPageNumber(const Value: Integer);
begin
  fPageNumber := Value;

  if (fPageNumber mod 2 = 1) then
    Dec(fPageNumber);

  ePageNumber.Text := IntToStr(fPageNumber);
  LoadPage(fPageNumber);
end;

end.
