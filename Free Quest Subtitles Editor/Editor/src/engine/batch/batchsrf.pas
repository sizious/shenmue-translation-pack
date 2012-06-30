unit BatchSRF;

interface

uses
  Windows, SysUtils, Classes, SysTools, FilesLst, BatchExe;

type
  TCinematicsBatchThread = class(TBatchThread)
  private
    fDiscNumber: Integer;
  protected
    procedure Execute; override;
  public
    property TargetDiscNumber: Integer read fDiscNumber write fDiscNumber;
  end;

implementation

uses
  SCNFEdit, ActiveX, Common;

var
  BatchSCNF: TSCNFEditor;

procedure InitEngine;
begin
  CoInitialize(nil);

  if not Assigned(BatchSCNF) then begin

    // Creating the object
    BatchSCNF := TSCNFEditor.Create;

    // Loading the SRF Script Database
    BatchSCNF.CinematicsScriptGenerator.LoadFromFile(GetCinematicsScriptDatabase);
  end;
end;

{ TCinematicsBatchThread }

procedure TCinematicsBatchThread.Execute;
var
//  BatchSCNF: TSCNFEditor;
//  SearchRec: TSearchRec;
  WorkFile: TFileName;
  i, FailedFiles: Integer;
  Result: Boolean;

begin
  inherited;

  // Initialize the engine
  InitEngine;

//  SourceDirectory := IncludeTrailingPathDelimiter(SourceDirectory);

    // Searching the selected directory
    (*if FindFirst(SourceDirectory + '*.*', faAnyFile, SearchRec) = 0 then begin
      repeat
        WorkFile := SourceDirectory + SearchRec.Name;
        if BatchSCNF.LoadFromFile(WorkFile) then
          FilesList.Add(WorkFile);
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;*)

    // Setting UI
    if Assigned(OnInitialize) then
      OnInitialize(Self, SourceFilesList.Count);
    
    // Mass exporting to the Cinematics SRF script
    FailedFiles := 0;

    i := 0;
    while (not Terminated) and (i < SourceFilesList.Count) do begin
      BatchSCNF.LoadFromFile(SourceFilesList[i].FileName);
      WorkFile := TargetDirectory + BatchSCNF.VoiceShortID
        + '_srf_disc' + IntToStr(TargetDiscNumber) + '.xml';
      Result := FileExists(WorkFile);
      if not Result then
        Result := BatchSCNF.Subtitles.ExportToCinematicScript(WorkFile, TargetDiscNumber);

      // Event
      if Assigned(OnFileProceed) then
        OnFileProceed(Self, SourceFilesList[i].FileName, Result);

      // Updating counters
      if not Result then
        Inc(FailedFiles);

      Inc(i);
    end;

    // Send the final event
    if Assigned(OnCompleted) then
      OnCompleted(Self, FailedFiles, SourceFilesList.Count, Terminated);

end;

initialization
  BatchSCNF := nil;
  
finalization
  BatchSCNF.Free;

end.
