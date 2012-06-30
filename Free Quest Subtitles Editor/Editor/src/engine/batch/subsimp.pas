unit subsimp;

interface

uses
  WINDOWS, SysUtils, Classes, Forms, FilesLst, ActiveX, ScnfEdit;

type
  TImportResult = (irUndef, irSuccess, irFailed, irSubsFileNotFound,
    irSubsFileAmbiguous);

  TMassImporterCompletedEvent = procedure(Sender: TObject; FilesImported,
    FilesFailure: Integer) of object;
  TMassImporterOperationEvent = procedure(Sender: TObject;
    TargetFileName, SubsFileName: TFileName; ImportResult: TImportResult) of object;

  TSubsMassImporterThread = class(TThread)
  private
    fImportScnfEditor: TSCNFEditor;
    fIntBuf: Integer;
    fOutputDir: TFileName;
    fSourceFilesList: TFilesList;
    fOnCompleted: TMassImporterCompletedEvent;
    fOnFileImported: TMassImporterOperationEvent;
    procedure InitializeProgressWindow(const FilesCount: Integer);
    procedure SyncInitializeProgressWindow;
  protected
    procedure Execute; override;
  public
    constructor Create(const OutputDir: TFileName; FilesList: TFilesList);
    destructor Destroy; override;
    property SourceFilesList: TFilesList read fSourceFilesList;
    property OutputDir: TFileName read fOutputDir;
    property OnFileImported: TMassImporterOperationEvent read fOnFileImported write fOnFileImported;
    property OnCompleted: TMassImporterCompletedEvent read fOnCompleted write fOnCompleted;
  end;


implementation

uses
  MassImp;
  
{ TSubsMassExporterThread }

constructor TSubsMassImporterThread.Create(const OutputDir: TFileName; FilesList: TFilesList);
begin
  FreeOnTerminate := True;
  fSourceFilesList := TFilesList.Create;
  fSourceFilesList.Assign(FilesList);
  fOutputDir := IncludeTrailingPathDelimiter(OutputDir);
  inherited Create(True);
end;

destructor TSubsMassImporterThread.Destroy;
begin
  fImportScnfEditor.Free;
  fSourceFilesList.Free;
  inherited;
end;

procedure TSubsMassImporterThread.Execute;
var
  i, Errors, Success: Integer;
  FName, SubsFile1, SubsFile2, SubsFile: TFileName;
  Subs1Exists, Subs2Exists: Boolean;
  Result: TImportResult;

begin
  CoInitialize(nil); // we use DOM Microsoft XML parser, which is COM based (check http://dn.codegear.com/article/29240).

  Errors := 0;
  Success := 0;
  fImportScnfEditor := TSCNFEditor.Create;

  try
    // scanning all found files
    InitializeProgressWindow(SourceFilesList.Count);

    for i := 0 to SourceFilesList.Count - 1 do begin
      if Terminated then Break;

      // for the current PAKS file
      FName := SourceFilesList[i].FileName;

      // Retriveing the XML subtitle file...
      SubsFile1 := OutputDir + SourceFilesList.Files[i].ExtractedFileName('.xml', False); // <radical>.xml
      SubsFile2 := OutputDir + SourceFilesList.Files[i].ExtractedFileName('.xml', True);  // <radical.pks>.xml

      // We'll test if XML subtitles file exists or not
      Result := irUndef;
      Subs1Exists := FileExists(SubsFile1);
      Subs2Exists := FileExists(SubsFile2);

      // The goal of this is to take the XML subtitles file that's corresponding for the current PAKS
      // Checking if <radical_paks_name>.xml or <radical_paks_name.pks>.xml exists

      if Subs1Exists then SubsFile := SubsFile1; // the SubsFile is SubsFile1
      if Subs2Exists then SubsFile := SubsFile2; // the SubsFile is SubsFile2

      // This is only if the source file has an extension
      if SourceFilesList.Files[i].HasExtension then begin
        // we can't make the choice, Subs1 and Subs2 exists, it's the end user to
        // do the choice so the result is marked as "ambiguous"
        if Subs1Exists and Subs2Exists then begin
          Result := irSubsFileAmbiguous;
          Inc(Errors);
        end;
      end else begin
        { The file has NOT extension, then the SubsFile must be the SubsFile2
          (<radical_paks_name[.noext]>.xml }
        SubsFile := SubsFile2;
      end;

      // Not any subs XML file found
      { In the case of the source file has not extension, the SubsFile1 is in
        fact the real PAKS file, and the SubsFile2 is the SubsXML file. }
      if (not Subs1Exists) and (not Subs2Exists) then begin
        Result := irSubsFileNotFound;
        Inc(Errors);
      end;

      // Importing the XML to the PAKS and saving the modified PAKS
      if Result = irUndef then
        try
          fImportScnfEditor.LoadFromFile(FName);
          if (fImportScnfEditor.Subtitles.ImportFromFile(SubsFile)) then begin
            Inc(Success);
            Result := irSuccess;
            fImportScnfEditor.SaveToFile(FName);
          end else begin
            Inc(Errors);
            Result := irFailed;
          end;

        except
          on E:Exception do begin
            Inc(Errors);
            Result := irFailed;
          end;
        end;

      // Send the event
      if not Terminated then begin
        if Assigned(fOnFileImported) then
          fOnFileImported(Self, FName, SubsFile, Result);

        // update progressbar
        Synchronize(frmMassImport.UpdateProgressBar);
      end;
      
    end;

    if Assigned(fOnCompleted) then
      fOnCompleted(Self, Success, Errors);
  finally
    CoUninitialize;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSubsMassImporterThread.InitializeProgressWindow(const FilesCount: Integer);
begin
  fIntBuf := FilesCount;
  Synchronize(SyncInitializeProgressWindow);
end;

// -----------------------------------------------------------------------------

procedure TSubsMassImporterThread.SyncInitializeProgressWindow;
begin
  frmMassImport.pbar.Max := fIntBuf;
end;

// -----------------------------------------------------------------------------

end.
