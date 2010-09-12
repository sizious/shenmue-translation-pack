program dbgprog;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  Classes,
  progress in '..\..\..\Common\Progress\progress.pas' {ProgressWindow},
  uitools in '..\..\..\Common\uitools.pas';

type
  TTestThread = class(TThread)
  private
    fClientDialog: TProgressionDialog;
    procedure EventCancelRequest(Sender: TObject);
    procedure EventCancelResult(Sender: TObject; Canceled: Boolean);
    procedure SetClientDialog(const Value: TProgressionDialog);
  protected
    procedure Execute; override;
  public
    property ClientDialog: TProgressionDialog read fClientDialog
      write SetClientDialog;
  end;

var
  ProgressDialog: TProgressionDialog;
  TestThread: TTestThread;

{ TTestThread }

procedure TTestThread.EventCancelRequest(Sender: TObject);
begin
  Suspend;
end;

procedure TTestThread.EventCancelResult(Sender: TObject; Canceled: Boolean);
begin
  Resume;
  if Canceled then begin
    WriteLn('CANCELED');
    Terminate;
  end;
end;

procedure TTestThread.Execute;
var
  i: Integer;

begin
  FreeOnTerminate := True;
  for i := 1 to 100 do begin
    if Terminated then Break;
    
    ClientDialog.Update('blah ' + IntToStr(i) + '...');
    Sleep(25);
  end;

  ClientDialog.Terminate;
end;


procedure TTestThread.SetClientDialog(const Value: TProgressionDialog);
begin
  fClientDialog := Value;
  fClientDialog.OnCancelRequest := EventCancelRequest;
  fClientDialog.OnCancelResult := EventCancelResult;  
end;

begin
  ReportMemoryLeaksOnShutdown := True;  
  try
    ProgressDialog := TProgressionDialog.Create;
    try
      ProgressDialog.Title := 'My Progress Dialog';

      TestThread := TTestThread.Create(True);
      TestThread.ClientDialog := ProgressDialog;
      TestThread.Resume;

      ProgressDialog.Initialize(100);
      WriteLn('RESULT = ', ProgressDialog.Execute);

      MessageBox(0, 'Main thread continues', 'Finished...', 0);
    finally
      ProgressDialog.Free;
    end;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
