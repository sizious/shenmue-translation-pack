unit BatchSRF;

interface

uses
  Windows, SysUtils, Classes, SysTools, FilesLst;

type
  TCinematicsBatchThread = class(TThread)
  private
    fDirectory: TFileName;
    fInitialize: TBatchThreadInitializeEvent;
    fFileProceed: TBatchThreadFileProceed;
    fCompleted: TBatchThreadCompletedEvent;
    fDiscNumber: Integer;
//    fSourceDirectory: TFileName;
    fFilesList: TFilesList;
  protected
    procedure Execute; override;
  public
    constructor Create; overload;
    destructor Destroy; override;
    property FilesList: TFilesList read fFilesList;
//    property SourceDirectory: TFileName read fSourceDirectory write fSourceDirectory;
    property TargetDiscNumber: Integer read fDiscNumber write fDiscNumber;
    property TargetDirectory: TFileName read fDirectory write fDirectory;
    property OnInitialize: TBatchThreadInitializeEvent
      read fInitialize write fInitialize;
    property OnFileProceed: TBatchThreadFileProceed read fFileProceed
      write fFileProceed;
    property OnCompleted: TBatchThreadCompletedEvent read fCompleted
      write fCompleted;
  end;

implementation

uses
  SCNFEdit, ActiveX, Common;

var
  BatchSCNF: TSCNFEditor;
  
{ Important : les m�thodes et propri�t�s des objets de la VCL peuvent uniquement
  �tre utilis�s dans une m�thode appel�e en utilisant Synchronize, comme :

      Synchronize(UpdateCaption);

  o� UpdateCaption serait de la forme

    procedure TCinematicsBatchThread.UpdateCaption;
    begin
      Form1.Caption := 'Mis � jour dans un thread';
    end; }

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

constructor TCinematicsBatchThread.Create;
begin
  inherited Create(True);
  fFilesList := TFilesList.Create;
end;

destructor TCinematicsBatchThread.Destroy;
begin
  fFilesList.Free;
  inherited;
end;

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
      OnInitialize(Self, FilesList.Count);
    
    // Mass exporting to the Cinematics SRF script
    FailedFiles := 0;

    i := 0;
    while (not Terminated) and (i < FilesList.Count) do begin
      BatchSCNF.LoadFromFile(FilesList[i].FileName);
      WorkFile := TargetDirectory + BatchSCNF.VoiceShortID
        + '_srf_disc' + IntToStr(TargetDiscNumber) + '.xml';
      Result := FileExists(WorkFile);
      if not Result then
        Result := BatchSCNF.Subtitles.ExportToCinematicScript(WorkFile, TargetDiscNumber);

      // Event
      if Assigned(OnFileProceed) then
        OnFileProceed(Self, FilesList[i].FileName, Result);

      // Updating counters
      if not Result then
        Inc(FailedFiles);

      Inc(i);
    end;

    // Send the final event
    if Assigned(OnCompleted) then
      OnCompleted(Self, FailedFiles, FilesList.Count, Terminated);

end;

initialization
  BatchSCNF := nil;
  
finalization
  BatchSCNF.Free;

end.
