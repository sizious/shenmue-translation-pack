unit pakfexec;

interface

uses
  Windows, SysUtils, Classes, ScnfUtil;

type
  TPAKFExtractorThread = class(TThread)
  private
    fGameVersion: TGameVersion;
    fFilesList: TStringList;
    fSourceDirectory: TFileName;
    fFileName: TFileName;
    fSuccess: Boolean;
    procedure SyncAddEntry;
    procedure SyncInitializeWindow;
    procedure SyncUpdateProgress;
  protected
    procedure AddEntry(const FileName: TFileName; Success: Boolean);
    procedure Execute; override;
    procedure InitializeWindow;
    procedure UpdateProgress;
    property FilesList: TStringList read fFilesList write fFilesList;
    property GameVersion: TGameVersion read fGameVersion;
    property SourceDirectory: TFileName read fSourceDirectory;
  public
    constructor Create(const SourceDirectory: TFileName;
      GameVersion: TGameVersion);
  end;

implementation

uses
  Common, FacesExt, PAKFExtr;

{ TPAKFExtractorThread }

procedure TPAKFExtractorThread.AddEntry(const FileName: TFileName;
  Success: Boolean);
begin
  fFileName := FileName;
  fSuccess := Success;
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
  OutputDir: TFileName;
  Success: Boolean;

begin
{$IFDEF DEBUG}
  WriteLn(#13#10, '*** NPC FACES EXTRACTOR MODULE ***');
{$ENDIF}

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

    for i := 0 to FilesList.Count - 1 do begin
      if Terminated then Break;
      
      // updating the file list
      Success := ExtractFaceFromPAKF(FilesList[i], OutputDir);
      AddEntry(ExtractFileName(FilesList[i]), Success);

      UpdateProgress;
    end;

  finally
    fFilesList.Free;
  end;
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
  with frmFacesExtractor.lvFiles.Items.Add do begin
    Caption := fFileName;
    if fSuccess then    
      SubItems.Add('SUCCESS')
    else
      SubItems.Add('FAILED');
    Selected := True;
  end;
end;

procedure TPAKFExtractorThread.SyncInitializeWindow;
begin
  frmFacesExtractor.Reset(fFilesList.Count);
end;

procedure TPAKFExtractorThread.SyncUpdateProgress;
begin
  frmFacesExtractor.UpdateProgressBar;
end;

end.
