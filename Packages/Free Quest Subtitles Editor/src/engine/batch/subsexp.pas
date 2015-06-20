unit subsexp;

interface

uses
  SysUtils, Classes, Forms, FilesLst, ActiveX;

type
  TMassExporterCompletedEvent = procedure(Sender: TObject; FileExportedCount,
    FileErrornousCount: Integer) of object;
  TMassExporterErrornousFileEvent = procedure(Sender: TObject;
    ErrornousFileName: TFileName; ReasonMessage: string) of object;

  TSubsMassExporterThread = class(TThread)
  private
    fStrBuf: string;
    fIntBuf: Integer;
    fOutputDir: TFileName;
    fSourceFilesList: TFilesList;
    fOnCompleted: TMassExporterCompletedEvent;
    fOnErrornousFile: TMassExporterErrornousFileEvent;
    procedure InitializeProgressWindow(const FilesCount: Integer);
    procedure SyncInitializeProgressWindow;
    procedure SyncUpdateProgressOperation;
    procedure UpdateProgressOperation(const S: string);
  protected
    procedure Execute; override;
  public
    constructor Create(const OutputDir: TFileName; FilesList: TFilesList);
    property SourceFilesList: TFilesList read fSourceFilesList;
    property OutputDir: TFileName read fOutputDir;
    property OnErrornousFile: TMassExporterErrornousFileEvent read fOnErrornousFile write fOnErrornousFile;
    property OnCompleted: TMassExporterCompletedEvent read fOnCompleted write fOnCompleted;
  end;
  
implementation

uses
  ScnfEdit, Progress;
  
{ TSubsMassExporterThread }

constructor TSubsMassExporterThread.Create(const OutputDir: TFileName; FilesList: TFilesList);
begin
  FreeOnTerminate := True;
  fSourceFilesList := TFilesList.Create;
  fSourceFilesList.Assign(FilesList);
  fOutputDir := IncludeTrailingPathDelimiter(OutputDir);
  inherited Create(True);
end;

procedure TSubsMassExporterThread.Execute;
var
  _tmpScnfEditor: TSCNFEditor;
  i, Errors, Success: Integer;
  FName, SubsFile: TFileName;

begin
  CoInitialize(nil); // we use DOM Microsoft XML parser, which is COM based (check http://dn.codegear.com/article/29240).

  Errors := 0;
  Success := 0;
  _tmpScnfEditor := TSCNFEditor.Create;
  try
    // scanning all found files
    InitializeProgressWindow(SourceFilesList.Count);

    for i := 0 to SourceFilesList.Count - 1 do begin
      if Terminated then Break;

      FName := SourceFilesList[i].FileName;
      SubsFile := OutputDir + SourceFilesList.Files[i].ExtractedFileName('.xml', True);

      UpdateProgressOperation('Exporting subtitles from ' + ExtractFileName(SourceFilesList[i].ExtractedFileName) + '...');

      _tmpScnfEditor.LoadFromFile(FName);

      try
        if not _tmpScnfEditor.Subtitles.ExportToFile(SubsFile) then begin
          Inc(Errors);
          if Assigned(fOnErrornousFile) then
            fOnErrornousFile(Self, FName, 'File wasn''t created...');
        end else
          Inc(Success);
      except
        on E:Exception do begin
          Inc(Errors);
          if Assigned(fOnErrornousFile) then
            fOnErrornousFile(Self, FName, E.Message);
        end;
      end;

      Synchronize(frmProgress.UpdateProgressBar);
    end;

    if Assigned(fOnCompleted) then
      fOnCompleted(Self, Success, Errors);
      
  finally
    _tmpScnfEditor.Free;
    fSourceFilesList.Free;
    CoUninitialize;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSubsMassExporterThread.UpdateProgressOperation(const S: string);
begin
  fStrBuf := S;
  Synchronize(SyncUpdateProgressOperation);  
end;

// -----------------------------------------------------------------------------

procedure TSubsMassExporterThread.InitializeProgressWindow(const FilesCount: Integer);
begin
  fIntBuf := FilesCount;
  Synchronize(SyncInitializeProgressWindow);
end;

// -----------------------------------------------------------------------------

procedure TSubsMassExporterThread.SyncInitializeProgressWindow;
begin
  frmProgress.pbar.Max := fIntBuf;
end;

// -----------------------------------------------------------------------------

procedure TSubsMassExporterThread.SyncUpdateProgressOperation;
begin
  frmProgress.lInfos.Caption := fStrBuf;
end;

// -----------------------------------------------------------------------------

end.
