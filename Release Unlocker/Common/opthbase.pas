{
  Basic Template for Release Unlocker Threads...
}
unit OpThBase;

interface

uses
  Classes;

type
  TOperationStartEvent = procedure(Sender: TObject;
    Total: Int64) of object;

  TOperationProgressEvent = procedure(Sender: TObject;
    Current, Total: Int64) of object;

  TOperationThread = class(TThread)
  private
    fOnStart: TOperationStartEvent;
    fOnProgress: TOperationProgressEvent;
    fOnFinish: TNotifyEvent;
    procedure FinishEvent;
    procedure ProgressEvent;
    procedure StartEvent;
  protected
    fCurrent: Int64;
    fTotal: Int64;
    fAborted: Boolean;
    fTerminated: Boolean;
    procedure CallSyncFinishEvent;
    procedure CallSyncProgressEvent;
    procedure CallSyncStartEvent;
  public
    constructor Create; overload;
    procedure Abort; virtual;
    property Aborted: Boolean read fAborted;
    property Terminated: Boolean read fTerminated;
    property OnStart: TOperationStartEvent read fOnStart
      write fOnStart;
    property OnProgress: TOperationProgressEvent read fOnProgress
      write fOnProgress;
    property OnFinish: TNotifyEvent read fOnFinish write fOnFinish;
  end;

implementation

{ TOperationThread }

procedure TOperationThread.Abort;
begin
{$IFDEF DEBUG}
  WriteLn('TOperationThread.Abort');
{$ENDIF}

  // Don't fire any events from OperationThread, because we aborted it!
  fAborted := True;

  // Terminate the thread.
  Terminate;
end;

procedure TOperationThread.CallSyncFinishEvent;
begin
  Synchronize(FinishEvent);
end;

procedure TOperationThread.CallSyncProgressEvent;
begin
  Synchronize(ProgressEvent);
end;

procedure TOperationThread.CallSyncStartEvent;
begin
  Synchronize(StartEvent);
end;

constructor TOperationThread.Create;
begin
  inherited Create(True);
  fAborted := False;
  fTerminated := False;
  fCurrent := 0;
  fTotal := 0;
{$IFDEF DEBUG}
  WriteLn('TOperationThread.Create');
{$ENDIF}
end;

// don't call this directly
procedure TOperationThread.FinishEvent;
begin
  fTerminated := True;
  if Assigned(OnFinish) then
    OnFinish(Self);
end;

// don't call this directly
procedure TOperationThread.ProgressEvent;
begin
  if Assigned(OnProgress) then
    OnProgress(Self, fCurrent, fTotal);
end;

// don't call this directly
procedure TOperationThread.StartEvent;
begin
if Assigned(OnStart) then
    OnStart(Self, fTotal);
end;

end.
