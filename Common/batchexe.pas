unit BatchExe;

interface

uses
  Windows, SysUtils, Classes, SysTools, FilesLst;

type
  // Batch Thread Events
  TBatchThreadInitializeEvent = procedure(Sender: TObject; MaxValue: Integer)
    of object;
  TBatchThreadFileProceed = procedure(Sender: TObject; FileName: TFileName;
    Result: Boolean) of object;
  TBatchThreadCompletedEvent = procedure(Sender: TObject;
    ErrornousFiles, TotalFiles: Integer; Canceled: Boolean) of object;

  // Batch Thread Object
  TBatchThread = class(TThread)
  private
    fCompleted: TBatchThreadCompletedEvent;
    fFileProceed: TBatchThreadFileProceed;
    fInitialize: TBatchThreadInitializeEvent;
    fSourceFilesList: TFilesList;
    fTargetDirectory: TFileName;
    procedure SetTargetDirectory(const Value: TFileName);
  public
    constructor Create; overload;
    destructor Destroy; override;
    property SourceFilesList: TFilesList read fSourceFilesList;
    property TargetDirectory: TFileName read fTargetDirectory
      write SetTargetDirectory;
    property OnInitialize: TBatchThreadInitializeEvent
      read fInitialize write fInitialize;
    property OnFileProceed: TBatchThreadFileProceed read fFileProceed
      write fFileProceed;
    property OnCompleted: TBatchThreadCompletedEvent read fCompleted
      write fCompleted;
  end;

//==============================================================================
implementation
//==============================================================================

{ TBatchThread }

constructor TBatchThread.Create;
begin
  inherited Create(True);
  fSourceFilesList := TFilesList.Create;
  fTargetDirectory := '';
end;

//------------------------------------------------------------------------------

destructor TBatchThread.Destroy;
begin
  fSourceFilesList.Free;
  inherited;
end;

procedure TBatchThread.SetTargetDirectory(const Value: TFileName);
begin
  fTargetDirectory := IncludeTrailingPathDelimiter(Value);
end;

//------------------------------------------------------------------------------

end.

