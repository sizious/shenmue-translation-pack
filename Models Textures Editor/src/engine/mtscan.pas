unit mtscan;

interface

uses
  SysUtils, Classes, Math;

type
  TMTScanStartEvent = procedure(Sender: TObject; FilesCount: Integer) of object;
  TMTScanFileFoundEvent = procedure(Sender: TObject; FileName: TFileName) of object;
  TMTScanFileResultEvent = procedure(Sender: TObject; FileName: TFileName;
    FileValid: Boolean) of object;

  TMTScanDirectoryThread = class(TThread)
  private
    fFilesList: TStringList;
    fDirectory: TFileName;
    fOnStart: TMTScanStartEvent;
    fOnFileFound: TMTScanFileFoundEvent;
    fOnFileScanned: TMTScanFileResultEvent;
    fOnTerminate: TNotifyEvent;
    fOnInitGettingFilesList: TNotifyEvent;
  protected
    procedure Execute; override;
    procedure GetDirectoryFilesList(Directory: TFileName;
      var OutputList: TStringList);
  public
    constructor Create(const Directory: TFileName);
    destructor Destroy; override;

    // Properties
    property Directory: TFileName read fDirectory;
    
    // Events
    property OnInitGettingFilesList: TNotifyEvent read fOnInitGettingFilesList write fOnInitGettingFilesList;
    property OnStart: TMTScanStartEvent read fOnStart write fOnStart;
    property OnFileFound: TMTScanFileFoundEvent read fOnFileFound write fOnFileFound;
    property OnFileScanned: TMTScanFileResultEvent read fOnFileScanned write fOnFileScanned;
    property OnTerminate: TNotifyEvent read fOnTerminate write fOnTerminate;
  end;

// -----------------------------------------------------------------------------
implementation
// -----------------------------------------------------------------------------

uses
  Main, MTEdit;

{ TMTScanDirectoryThread }

constructor TMTScanDirectoryThread.Create(const Directory: TFileName);
begin
  FreeOnTerminate := True;
  fDirectory := IncludeTrailingPathDelimiter(Directory);
  fFilesList := TStringList.Create;

  inherited Create(True);
end;

destructor TMTScanDirectoryThread.Destroy;
begin
  fFilesList.Free;  
  inherited;
end;

procedure TMTScanDirectoryThread.Execute;
var
  i: Integer;
  FName: TFileName;
  ValidFile: Boolean;
  MTE_TestFiles: TModelTexturedEditor;

begin
  MTE_TestFiles := TModelTexturedEditor.Create;
  try
    // Retrieving files list from the directory
    if Assigned(fOnInitGettingFilesList) then
      fOnInitGettingFilesList(Self);
    GetDirectoryFilesList(Directory, fFilesList);
    fFilesList.Sort;

    // scanning all found files
    if Assigned(fOnStart) then
      fOnStart(Self, fFilesList.Count);

    i := 0;
    while (not Terminated) and (i < fFilesList.Count - 1) do begin
      FName := fFilesList[i];

      if Assigned(fOnFileFound) then
        fOnFileFound(Self, FName);

      // Opening and testing file...
      ValidFile := MTE_TestFiles.LoadFromFile(FName);
      if ValidFile then
        ValidFile := MTE_TestFiles.Textures.Count > 0;
      MTE_TestFiles.Close;
      
      // We have found a valid file or not ?
      if Assigned(fOnFileScanned) then
        fOnFileScanned(Self, FName, ValidFile);

      Inc(i);
    end;

  finally
    MTE_TestFiles.Free;
  end;

  // Notify the Listener that the thread is over
  if Assigned(fOnTerminate) then
    fOnTerminate(Self);
end;

procedure TMTScanDirectoryThread.GetDirectoryFilesList(Directory: TFileName; var OutputList: TStringList);
var
  SR : TSearchRec;

begin
  Assert(Assigned(OutputList), 'OutputList must be set !');
  Directory := IncludeTrailingPathDelimiter(Directory);
  
  if (FindFirst(Directory + '*.*', faAnyFile, SR) = 0) then begin
    // Scanning the whole directory
    repeat
      if ((SR.Name <> '.') and (SR.Name <> '..')) then
        OutputList.Add(Directory + SR.Name);
    until (Terminated) or (FindNext(SR) <> 0);
    FindClose(SR); // Must free up resources used by these successful finds
  end;
end;

end.
