unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MemoEdit;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure FreeModules;
    procedure InitModules;
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;
  DiaryEditor: TDiaryEditor;

implementation

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
var
  i: Integer;

begin
  DiaryEditor.LoadFromFile('MEMODATA.BIN');

  for i := 0 to DiaryEditor.Messages.Count - 1 do begin
    Memo1.Lines.Add(DiaryEditor.Messages[i].Text);
  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
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

end.
