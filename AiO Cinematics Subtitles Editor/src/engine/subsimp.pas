unit SubsImp;

interface

uses
  Windows, SysUtils, Classes, BatchExe, Progress;

type
  TBatchSubtitlesExporterThread = class;
  
  TBatchSubtitlesExporter = class
  private
    fProgressWindow: TProgressionDialog;
    fBatchThread: TBatchSubtitlesExporterThread;
    fThreadCanceled: Boolean;
    procedure CancelRequest(Sender: TObject);
    procedure CancelResult(Sender: TObject; Canceled: Boolean);
    procedure ThreadCompleted(Sender: TObject);
    property BatchThread: TBatchSubtitlesExporterThread read fBatchThread
      write fBatchThread;
    property ProgressWindow: TProgressionDialog read fProgressWindow
      write fProgressWindow;
    property ThreadCanceled: Boolean read fThreadCanceled
      write fThreadCanceled;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute(const Directory: TFileName);
  end;

  TBatchSubtitlesExporterThread = class(TBatchThread)
  private
    fStrBuf: string;
    fProgressDialog: TProgressionDialog;
    procedure SyncProgressInitialize;
    procedure SyncProgressFileProceed;
  protected
    procedure Execute; override;
  public
    property AProgressDialog: TProgressionDialog read fProgressDialog
      write fProgressDialog;
  end;

implementation

uses
  Main, ActiveX, SRFEdit, DebugLog, FilesLst;

var
  BatchSRF: TSRFEditor;

//==============================================================================
{ TBatchSubtitlesExporter }
//==============================================================================

procedure TBatchSubtitlesExporterThread.Execute;
var
  AppendExtension: Boolean;
  SourceFile: TFileEntry;
  WorkFile: TFileName;
  i, FailedFiles: Integer;
  Result: Boolean;

begin
  CoInitialize(nil);

  // Initializing the progress dialog
  Synchronize(SyncProgressInitialize);

  // Setting UI
  if Assigned(OnInitialize) then
    OnInitialize(Self, SourceFilesList.Count);

  // Mass exporting to the Cinematics SRF script
  FailedFiles := 0;

  i := 0;
  while (not Terminated) and (i < SourceFilesList.Count) do begin
    SourceFile := SourceFilesList[i];

    // Load the 
    BatchSRF.LoadFromFile(SourceFile.FileName);

    // Build the output file
    AppendExtension := not SameText(SourceFile.Extension, '.srf');
    WorkFile := TargetDirectory + SourceFile.ExtractedFileName('.xml', AppendExtension);

    // Updating the progress dialog
    fStrBuf := 'Exporting "' + SourceFile.ExtractedFileName + '"...';
    Synchronize(SyncProgressFileProceed);

    Result := BatchSRF.Subtitles.ExportToFile(WorkFile);

    // Event
    if Assigned(OnFileProceed) then
      OnFileProceed(Self, SourceFile.FileName, Result);

    // Updating counters
    if not Result then
      Inc(FailedFiles);

    Inc(i);
  end;
  
  // Send the final event
  if Assigned(OnCompleted) then
    OnCompleted(Self, FailedFiles, SourceFilesList.Count, Terminated);
end;

//==============================================================================
{ TBatchSubtitlesExporter }
//==============================================================================

procedure TBatchSubtitlesExporter.CancelRequest(Sender: TObject);
begin
  BatchThread.Suspend;
end;

procedure TBatchSubtitlesExporter.CancelResult(Sender: TObject;
  Canceled: Boolean);
begin
  BatchThread.Resume;
  if Canceled then begin
    ThreadCanceled := True;
    BatchThread.Terminate;
  end;
end;

procedure TBatchSubtitlesExporter.ThreadCompleted(Sender: TObject);
begin
  // Closing the progress dialog
  ProgressWindow.Terminate;

  if ThreadCanceled then  
    Debug.AddLine(ltInformation, 'The batch subtitles exporter process was ' +
      'canceled by the user!')
  else
    Debug.AddLine(ltInformation, 'The batch subtitles exporter process is done.');
    
  frmMain.StatusText := '';
end;

constructor TBatchSubtitlesExporter.Create;
begin
  fProgressWindow := TProgressionDialog.Create;
  with ProgressWindow do begin
    OnCancelRequest := CancelRequest;
    OnCancelResult := CancelResult;
    Title := 'Batch Subtitles Exporter';
  end;
end;

destructor TBatchSubtitlesExporter.Destroy;
begin
  ProgressWindow.Free;
  inherited Destroy;
end;

procedure TBatchSubtitlesExporter.Execute(const Directory: TFileName);
begin
  ThreadCanceled := False;

  // Creating the batch thread
  fBatchThread := TBatchSubtitlesExporterThread.Create;
  with BatchThread do
    try
      AProgressDialog := ProgressWindow;
      OnTerminate := ThreadCompleted;
      SourceFilesList.Assign(frmMain.WorkingFilesList);
      TargetDirectory := Directory;

      // Adding an entry to the Debug
      Debug.AddLine(ltInformation, 'Starting to batch exports subtitles to "'
        + TargetDirectory + '"...');
      frmMain.StatusText := 'Batch exporting...';
      
      // Running the thread
      Resume;

      // Showing the progress window
      ProgressWindow.Execute;

    finally
      Free;
    end;
end;

procedure TBatchSubtitlesExporterThread.SyncProgressFileProceed;
begin
  AProgressDialog.Update(fStrBuf);
end;

procedure TBatchSubtitlesExporterThread.SyncProgressInitialize;
begin
  AProgressDialog.Initialize(SourceFilesList.Count);
end;

initialization
  BatchSRF := TSRFEditor.Create;

finalization
  BatchSRF.Free;

end.
