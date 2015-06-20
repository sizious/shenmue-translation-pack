unit SubsImp;

interface

uses
  Windows, SysUtils, Classes, BatchExe;

type
  TBatchSubtitlesImporterThread = class;
  TBatchThreadImportedResult = (irSuccess, irNotFound, irFailed);

  TBatchThreadImportedFileProceed = procedure(Sender: TObject;
    FileName: TFileName; Result: TBatchThreadImportedResult) of object;

  TBatchSubtitlesImporterThread = class(TBatchThread)
  private
    fFileProceed: TBatchThreadImportedFileProceed;
  protected
    procedure Execute; override;
  public
    property OnFileProceed: TBatchThreadImportedFileProceed read fFileProceed
      write fFileProceed;
  end;

function ImportResultToString(R: TBatchThreadImportedResult): string;

implementation

uses
  Main, ActiveX, SRFEdit, DebugLog, FilesLst;

var
  BatchSRF: TSRFEditor;

//==============================================================================
{ TBatchSubtitlesImporterThread }
//==============================================================================

procedure TBatchSubtitlesImporterThread.Execute;
var
  AppendExtension: Boolean;
  SourceFile: TFileEntry;
  WorkFile: TFileName;
  i, FailedFiles: Integer;
  Result: TBatchThreadImportedResult;

begin
  CoInitialize(nil);

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
    if not FileExists(WorkFile) then
      WorkFile := ChangeFileExt(WorkFile, '.txt');

    Result := irFailed;
    if not FileExists(WorkFile) then
      Result := irNotFound
    else
      if BatchSRF.Subtitles.ImportFromFile(WorkFile) then begin
        Result := irSuccess;
        BatchSRF.Save;
      end;

    // Event
    if Assigned(OnFileProceed) then
      OnFileProceed(Self, SourceFile.FileName, TBatchThreadImportedResult(Result));

    // Updating counters
    if Result <> irSuccess then
      Inc(FailedFiles);

    Inc(i);
  end;

  // Send the final event
  if Assigned(OnCompleted) then
    OnCompleted(Self, FailedFiles, SourceFilesList.Count, Terminated);
end;

function ImportResultToString(R: TBatchThreadImportedResult): string;
begin
  case R of
    irSuccess:
      Result := 'SUCCESS';
    irNotFound:
      Result := 'NOT FOUND';
    irFailed:
      Result := 'FAILED';
  end;
end;

initialization
  BatchSRF := TSRFEditor.Create;

finalization
  BatchSRF.Free;

end.
