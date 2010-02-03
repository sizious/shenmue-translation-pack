unit pakfexec;

interface

// Define this if you want to generate a output log file when extracting PAKF
{$DEFINE CREATE_PAKF_LOG}

uses
  Windows, SysUtils, Classes, ScnfUtil, PakfExtr;

type
  TExtractionFinishedEvent = procedure(Sender: TObject; ProcessCanceled: Boolean;
    SuccessFiles, ErrornousFiles, TotalFiles: Integer) of object;

  TPAKFExtractorThread = class(TThread)
  private
{$IFDEF DEBUG}
    DebugStringResult: string;
{$ENDIF}  
    fTargetFileListEntry: TFileName;
    fErrornousFilesCount: Integer;
    fGameVersion: TGameVersion;
    fFilesList: TStringList;
    fSourceDirectory: TFileName;
    fSuccessFilesCount: Integer;
    fFileName: TFileName;
    fExtractionResult: TPAKFExtractionResult;
    fOutputDir: TFileName;
    fExtractionFinished: TExtractionFinishedEvent;
    procedure ExtractCurrentEntry;
    procedure SyncAddEntry;
    procedure SyncInitializeWindow;
    procedure SyncUpdateProgress;
  protected
    procedure AddEntry(const FileName: TFileName;
      ExtractionResult: TPAKFExtractionResult);
    procedure Execute; override;
    procedure InitializeWindow;
    procedure UpdateProgress;
    property ExtractionResult: TPAKFExtractionResult
      read fExtractionResult write fExtractionResult;
    property FilesList: TStringList read fFilesList write fFilesList;
    property GameVersion: TGameVersion read fGameVersion;
    property OutputDir: TFileName read fOutputDir write fOutputDir;    
    property SourceDirectory: TFileName read fSourceDirectory;
  public
    constructor Create(const SourceDirectory: TFileName;
      GameVersion: TGameVersion);
    property OnExtractionFinished: TExtractionFinishedEvent read
      fExtractionFinished write fExtractionFinished;
  end;

implementation

uses
  {$IFDEF DEBUG}TypInfo, {$ENDIF}
  Common, FacesExt, Img2Png, Utils;

{ TPAKFExtractorThread }

procedure TPAKFExtractorThread.AddEntry(const FileName: TFileName;
  ExtractionResult: TPAKFExtractionResult);
begin
  fFileName := FileName;
  fExtractionResult := ExtractionResult;
  Synchronize(SyncAddEntry);
end;

constructor TPAKFExtractorThread.Create(const SourceDirectory: TFileName;
  GameVersion: TGameVersion);
begin
  FreeOnTerminate := True;
  fSourceDirectory := SourceDirectory;
  fGameVersion := GameVersion;
  inherited Create(True);
end;

procedure TPAKFExtractorThread.Execute;
var
  SR : TSearchRec;
  i: Integer;
  ProcessCanceled: Boolean;
  
{$IFDEF DEBUG}{$IFDEF CREATE_PAKF_LOG}
  F_CSV: TextFile;
{$ENDIF}{$ENDIF}

begin
{$IFDEF DEBUG}
  WriteLn(#13#10, '*** NPC FACES EXTRACTOR MODULE ***');
{$ENDIF}

  fSuccessFilesCount := 0;
  fErrornousFilesCount := 0;
  ProcessCanceled := False;
  
  fSourceDirectory := IncludeTrailingPathDelimiter(fSourceDirectory);
//  GetFullPathName(
  fFilesList := TStringList.Create;
  OutputDir := GetFacesDirectory(GameVersion);
  
  try
    if FindFirst(SourceDirectory + '*.*', faAnyFile, SR) = 0 then
    begin
      // Scanning the whole directory
      repeat
        if (SR.Name[1] <> '.') and (SR.Attr and faDirectory = 0) then
          FilesList.Add(SourceDirectory + SR.Name);
      until Terminated or (FindNext(SR) <> 0);
      FindClose(SR); // Must free up resources used by these successful finds
    end;

    // Initialize Window
    InitializeWindow;

{$IFDEF DEBUG}{$IFDEF CREATE_PAKF_LOG}
    // Create debug output CSV for tracing purpose
    AssignFile(F_CSV, OutputDir + '__OUTPUT.csv');
    ReWrite(F_CSV);
    WriteLn(F_CSV, '"FileName";"Result";"Read CharID";"Texture Name"');
{$ENDIF}{$ENDIF}

    // Extracting the PVR conversion engine
    PVRConverter_ExtractEngine(GetWorkingTempDirectory);

    // Converting all found files
    for i := 0 to FilesList.Count - 1 do begin
      if Terminated then begin
        ProcessCanceled := True;
        Break;
      end;
      
      // Extracting the current PKF file entry
      fTargetFileListEntry := FilesList[i];
      Synchronize(ExtractCurrentEntry);

      UpdateProgress;

{$IFDEF DEBUG}
      WriteLn('Extraction Result for "', ExtractFileName(FilesList[i]), '": ',
        GetEnumName(TypeInfo(TPAKFExtractionResult), Ord(fExtractionResult)));
{$IFDEF CREATE_PAKF_LOG}
      WriteLn(F_CSV, '"', ExtractFileName(FilesList[i]), '";"',
        GetEnumName(TypeInfo(TPAKFExtractionResult), Ord(fExtractionResult)), '";', DebugStringResult);
{$ENDIF}{$ENDIF}
    end;

    // Finished Event
    if Assigned(fExtractionFinished) then
      fExtractionFinished(Self, ProcessCanceled, fSuccessFilesCount,
        fErrornousFilesCount, fFilesList.Count);

  finally
    fFilesList.Free;
{$IFDEF DEBUG}{$IFDEF CREATE_PAKF_LOG}
    CloseFile(F_CSV);
{$ENDIF}{$ENDIF}
  end;
end;

procedure TPAKFExtractorThread.ExtractCurrentEntry;
begin
  fExtractionResult := ExtractFaceFromPAKF(fTargetFileListEntry,
    OutputDir, GameVersion {$IFDEF DEBUG}, DebugStringResult{$ENDIF});
  AddEntry(ExtractFileName(fTargetFileListEntry), fExtractionResult);
end;

procedure TPAKFExtractorThread.InitializeWindow;
begin
  Synchronize(SyncInitializeWindow);
end;

procedure TPAKFExtractorThread.UpdateProgress;
begin
  Synchronize(SyncUpdateProgress);
end;

//------------------------------------------------------------------------------
// SYNCHRONIZED METHODS
//------------------------------------------------------------------------------

procedure TPAKFExtractorThread.SyncAddEntry;
begin
  with frmFacesExtractor.lvFiles do begin
    with Items.Add do begin
      Caption := fFileName;
      case fExtractionResult of
        perUnknow:
          begin
            SubItems.Add('UNKNOW');
            Inc(fErrornousFilesCount);
          end;
        perNotValidFile:
          SubItems.Add('Unneeded');
        perConversionFailed:
          begin
            SubItems.Add('FAILED');
            Inc(fErrornousFilesCount);
          end;
        perTargetAlreadyExists:
          SubItems.Add('Exists');
        perSuccess:
          begin
            SubItems.Add('Success');
            Inc(fSuccessFilesCount);
          end;
      end;
      Selected := True;
    end;
    ItemIndex := Items.Count - 1;
    Scroll(0, 100);
  end;
end;

procedure TPAKFExtractorThread.SyncInitializeWindow;
begin
  frmFacesExtractor.Reset(fFilesList.Count);
  try
    frmFacesExtractor.lvFiles.SetFocus;
  except
    // nothing
  end;
end;

procedure TPAKFExtractorThread.SyncUpdateProgress;
begin
  frmFacesExtractor.UpdateProgressBar;
end;

end.
