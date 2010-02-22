unit debuglog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, JvExStdCtrls, JvRichEdit, ComCtrls, JvExComCtrls,
  JvStatusBar, AppEvnts;

type
  TfrmDebugLog = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Options1: TMenuItem;
    miOnTop: TMenuItem;
    Save1: TMenuItem;
    Copy1: TMenuItem;
    Clearall1: TMenuItem;
    N1: TMenuItem;
    Copy2: TMenuItem;
    Selectall1: TMenuItem;
    N2: TMenuItem;
    Close1: TMenuItem;
    eDebug: TJvRichEdit;
    sbDebug: TJvStatusBar;
    aeDebug: TApplicationEvents;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure aeDebugHint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure miOnTopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fOnTop: Boolean;
    procedure SetOnTop(const Value: Boolean);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property OnTop: Boolean read fOnTop write SetOnTop;
  end;

var
  frmDebugLog: TfrmDebugLog;

implementation

uses
  Main, Utils;

{$R *.dfm}

procedure TfrmDebugLog.aeDebugHint(Sender: TObject);
begin
  sbDebug.SimpleText := Application.Hint;
  aeDebug.CancelDispatch;
end;

procedure TfrmDebugLog.FormActivate(Sender: TObject);
begin
  aeDebug.Activate;
end;

procedure TfrmDebugLog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.DebugLogVisible := False;
end;

procedure TfrmDebugLog.FormCreate(Sender: TObject);
begin
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
  sbDebug.SimplePanel := True;

  // Load config
  LoadConfigDebug;
end;

procedure TfrmDebugLog.FormDestroy(Sender: TObject);
begin
  SaveConfigDebug;
end;

procedure TfrmDebugLog.miOnTopClick(Sender: TObject);
begin
  OnTop := not OnTop;
end;

procedure TfrmDebugLog.SetOnTop(const Value: Boolean);
begin
  fOnTop := Value;
  miOnTop.Checked := Value;
  if Value then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

end.
