unit progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls;

type
  TfrmProgress = class(TForm)
    lInfos: TLabel;
    pbar: TProgressBar;
    btnCancel: TButton;
    Bevel1: TBevel;
    pProgBar: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
    fCurrentThread: TThread;
    fAborted: Boolean;
    fTerminated: Boolean;
  public
    { Déclarations publiques }
    procedure Reset;

    procedure InitProgressBar(const TotalValue: Integer);
    function MsgBox(const Message, Title: string; Flags: Integer): Integer;
    procedure SetProgressEvent(const Title: string);
    procedure UpdateProgressBar;
    procedure SetWindowTitle(const Title: string);

    // Properties
    property Aborted: Boolean read fAborted write fAborted;
    property Terminated: Boolean read fTerminated write fTerminated;
    property WorkThread: TThread read fCurrentThread write fCurrentThread;
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}

uses
  Main, Math;

procedure TfrmProgress.btnCancelClick(Sender: TObject);
begin
  btnCancel.Enabled := False;
  Aborted := True;
  Close;
end;

procedure TfrmProgress.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  CanDo: Integer;

begin
  if (Aborted) or (not Terminated) then begin

    if Assigned(fCurrentThread) then begin
      fCurrentThread.Suspend; // pause the thread
      CanClose := False;      // window will be closed in the OnTerminate event of the fCurrentThread (waiting the end of the thread)
      Aborted := False;       // the second pass is to really close the form (with the OnTerminate event) so we set Aborted to false to do this

      CanDo := MsgBox('Are you sure to cancel this process ?', 'Question', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2);
      fCurrentThread.Resume; // restart thread...
      if CanDo = IDNO then begin
        btnCancel.Enabled := True;
        Exit; //...if the thread continue : OK
      end;

      fCurrentThread.Terminate; //...if the thread must stop: calling Thread.Terminate (it will be stopped in the Thread Execute function)
    end;

  end;
end;

procedure TfrmProgress.FormCreate(Sender: TObject);
begin
  Reset;
  DoubleBuffered := True;
  pProgBar.DoubleBuffered := True;
end;

procedure TfrmProgress.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then Close;
end;

procedure TfrmProgress.InitProgressBar(const TotalValue: Integer);
begin
  Self.pbar.Max := TotalValue;
end;

function TfrmProgress.MsgBox(const Message, Title: string;
  Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Message), PChar(Title), Flags);
end;

procedure TfrmProgress.Reset;
begin
  Terminated := False;
  Aborted := False;
  pbar.Position := 0;
  pProgBar.Caption := '0%';
  Self.lInfos.Caption := '';
  btnCancel.Enabled := True;
end;

procedure TfrmProgress.SetProgressEvent(const Title: string);
begin
  Self.lInfos.Caption := Title;
end;

procedure TfrmProgress.SetWindowTitle(const Title: string);
begin
  Self.Caption := Title;
end;

procedure TfrmProgress.UpdateProgressBar;
begin
  pbar.Position := frmProgress.pbar.Position + 1;
  pProgBar.Caption := FormatFloat('0.00', SimpleRoundTo((100 * pbar.Position) / pbar.Max, -2)) + '%';
  Application.ProcessMessages;
end;

end.
