unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NbikEdit, ComCtrls, Menus, ImgList, ToolWin, JvExComCtrls,
  JvToolBar;

type
  TfrmMain = class(TForm)
    lvSubs: TListView;
    Label1: TLabel;
    mOldSub: TMemo;
    memoText: TMemo;
    lblText: TLabel;
    MainMenu1: TMainMenu;
    miFile: TMenuItem;
    sbMain: TStatusBar;
    tbMain: TJvToolBar;
    ToolButton1: TToolButton;
    tbOpen: TToolButton;
    tbReload: TToolButton;
    tbSave: TToolButton;
    ToolButton4: TToolButton;
    tbDebugLog: TToolButton;
    tbAbout: TToolButton;
    ilToolBarDisabled: TImageList;
    ilToolBar: TImageList;
    tbPreview: TToolButton;
    ToolButton2: TToolButton;
    miOpen: TMenuItem;
    miView: TMenuItem;
    miHelp: TMenuItem;
    miDEBUG: TMenuItem;
    miDEBUG_TEST1: TMenuItem;
    miSave: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure miOpenClick(Sender: TObject);
    procedure miDEBUG_TEST1Click(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure Clear;
    procedure LoadFile(const FileName: TFileName);
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;
  SequenceEditor: TNozomiMotorcycleSequenceEditor;

implementation

{$R *.dfm}

uses
  UITools;
  
procedure TfrmMain.Clear;
begin
  lvSubs.Clear;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  
  SequenceEditor := TNozomiMotorcycleSequenceEditor.Create;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  SequenceEditor.Free;
end;

procedure TfrmMain.LoadFile(const FileName: TFileName);
var
  i: Integer;

begin
  if SequenceEditor.LoadFromFile(FileName) then begin
    Clear;

    // Loading the view
    for i := 0 to SequenceEditor.Subtitles.Count - 1 do
      with lvSubs.Items.Add do begin
        Caption := IntToStr(i);
        SubItems.Add(SequenceEditor.Subtitles[i].Text);
      end;
  end;  
end;

procedure TfrmMain.miDEBUG_TEST1Click(Sender: TObject);
{$IFDEF DEBUG}
var
  i: Integer;

begin
  SequenceEditor.LoadFromFile('PAL_DISC4.scn');
(*  SequenceEditor.Items[0].Text := 'This''s how we do!';
  SequenceEditor.Items[1].Text := 'BLAH!<br>MOTHA FUCKA!!!!';
  SequenceEditor.Items[2].Text := 'éa!';
  SequenceEditor.Items[3].Text := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ........<br>0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ........';
  SequenceEditor.Items[5].Text := 'MAPINFO HACKED HUH?! SEE?';
  SequenceEditor.Items[7].Text := 'Woohoo! This''s the lastest SiZiOUS hack.<br>Enjoy this GREAT exploit!';
  SequenceEditor.Items[8].Text := 'Woohoo! This''s the lastest SiZiOUS hack.<br>Enjoy this GREAT exploit!'; *)

  for i := 0 to SequenceEditor.Subtitles.Count - 1 do
    SequenceEditor.Subtitles[i].Text :=
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqr<br>abcdefghijklmnopqrABCDEFGHIJKLMNOPQRSTUVWXYZ';

  SequenceEditor.SaveToFile('PAL_DISC4.HAK');
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miOpenClick(Sender: TObject);
begin
  LoadFile('MAPINFO.BIN');
end;

procedure TfrmMain.miSaveClick(Sender: TObject);
begin
//  SequenceEditor.Subtitles[2].Text := 'MOTHA FOCKA!';
  SequenceEditor.SaveToFile('blah.bin');
end;

procedure TfrmMain.tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
  var DefaultDraw: Boolean);
begin
  ToolBarCustomDraw(Sender);
end;

end.
