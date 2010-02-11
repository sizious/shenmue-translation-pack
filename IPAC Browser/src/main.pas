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
    StatusBar1: TStatusBar;
    od: TOpenDialog;
    ilIpacContent: TImageList;
    ilHeader: TImageList;
    JvToolBar1: TJvToolBar;
    ToolButton1: TToolButton;
    tbOpen: TToolButton;
    Help1: TMenuItem;
    About1: TMenuItem;
    Close1: TMenuItem;
    Save1: TMenuItem;
    Saveas1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Reload1: TMenuItem;
    Edit1: TMenuItem;
    Undochanges1: TMenuItem;
    N4: TMenuItem;
    Import1: TMenuItem;
    Export1: TMenuItem;
    N5: TMenuItem;
    Exportall1: TMenuItem;
    View1: TMenuItem;
    Debug1: TMenuItem;
    Fileinformations1: TMenuItem;
    N6: TMenuItem;
    ilToolBar: TImageList;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miDebugTest1Click(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure lvIpacContentColumnClick(Sender: TObject; Column: TListColumn);
    procedure JvToolBar1CustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure miQuitClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure Clear;
    procedure ClearColumnsImages;
    function KindToImageIndex(Kind: string): Integer;
    procedure LoadFile(const FileName: TFileName);
  public
    { Déclarations publiques }
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
  end;

var
  frmMain: TfrmMain;
  IPACEditor: TIpacEditor;

implementation

{$R *.dfm}

uses
  IpacUtil;

procedure TfrmMain.Clear;
begin
  ClearColumnsImages;
  lvIpacContent.Clear;
end;

procedure TfrmMain.ClearColumnsImages;
var
  i: Integer;
  
begin
  for i := 0 to lvIpacContent.Columns.Count - 1 do
    lvIpacContent.Column[i].ImageIndex := -1;
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

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;

  // Creating the main IPAC Editor object
  IPACEditor := TIpacEditor.Create;

  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Destroying the IPAC Object
  IPACEditor.Free;
end;

procedure TfrmMain.JvToolBar1CustomDraw(Sender: TToolBar; const ARect: TRect;
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
    Clear;

    // Adding entries
    for i := 0 to IPACEditor.Content.Count - 1 do
      with lvIpacContent.Items.Add do
        with IPACEditor.Content[i] do begin
          Caption := Name + FileExtension;
          SubItems.Add(KindToFriendlyName(Kind));
          SubItems.Add(IntToStr(AbsoluteOffset));
          SubItems.Add(IntToStr(Size));
          ImageIndex := KindToImageIndex(Kind);
        end;

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
  with od do
    if Execute then
      LoadFile(FileName);
end;

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

function TfrmMain.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

end.
