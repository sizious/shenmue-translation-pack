//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit scnfscan;

interface

uses
  SysUtils, Classes, Forms, Math;

type
  TSCNFScanDirectory = class(TThread)
  private
    fFilesList: TStringList;
    fIntBuf: Integer;
    fTargetDirectory: string;
    fStrBuf: string;

    procedure AddValidFile(const FileName: TFileName);
    procedure InitializeProgressWindow(const FilesCount: Integer);
    procedure UpdatePercentage;
    procedure UpdateProgressOperation(const S: string);

    // --- don't call directly ---
    procedure SyncInitializeProgressWindow;
    procedure SyncUpdateProgressOperation;
    procedure SyncUpdateScnfFileList;
  protected
    procedure Execute; override;
  public
    constructor Create(const TargetDirectory: string);
  end;

// -----------------------------------------------------------------------------
implementation
// -----------------------------------------------------------------------------

uses
  Main, Progress, ScnfUtil;

// -----------------------------------------------------------------------------
{ TSCNFScanDirectory }
// -----------------------------------------------------------------------------

procedure TSCNFScanDirectory.AddValidFile(const FileName: TFileName);
begin
  fStrBuf := FileName; 
  Synchronize(SyncUpdateScnfFileList);
end;
 
// -----------------------------------------------------------------------------

constructor TSCNFScanDirectory.Create(const TargetDirectory: string);
begin
  FreeOnTerminate := True;
  fTargetDirectory := TargetDirectory;

  inherited Create(True);
end;

// -----------------------------------------------------------------------------

procedure TSCNFScanDirectory.Execute;
var
  SR : TSearchRec;
  i: Integer;
  
begin
  fTargetDirectory := IncludeTrailingPathDelimiter(fTargetDirectory);

  fFilesList := TStringList.Create;
  try
    // Try to find SCNF "PAKS" files in the specified directory.
    UpdateProgressOperation('Retrieving files list... Please wait.');
    
    if FindFirst(fTargetDirectory + '*.*', faAnyFile, SR) = 0 then
    begin
      // Scanning the whole directory
      repeat
        fFilesList.Add(fTargetDirectory + SR.Name);
      until Terminated or (FindNext(SR) <> 0);
      FindClose(SR); // Must free up resources used by these successful finds
    end;

    // scanning all found files
    InitializeProgressWindow(fFilesList.Count);
    
    for i := 0 to fFilesList.Count - 1 do begin
      if Terminated then Break;
      
      UpdateProgressOperation('Scanning ' + ExtractFileName(fFilesList[i]) + '...');

      // updating the file list
      if IsFileValidScnf(fFilesList[i]) then
        AddValidFile(ExtractFileName(fFilesList[i]));

      UpdatePercentage;
    end;

  finally
    fFilesList.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSCNFScanDirectory.InitializeProgressWindow(const FilesCount: Integer);
begin
  fIntBuf := FilesCount;
  Synchronize(SyncInitializeProgressWindow);
end;

// -----------------------------------------------------------------------------

procedure TSCNFScanDirectory.SyncInitializeProgressWindow;
begin
  frmProgress.pbar.Max := fIntBuf;
end;

// -----------------------------------------------------------------------------

procedure TSCNFScanDirectory.SyncUpdateProgressOperation;
begin
  frmProgress.lInfos.Caption := fStrBuf;
end;

// -----------------------------------------------------------------------------

procedure TSCNFScanDirectory.SyncUpdateScnfFileList;
begin
  frmMain.lbFilesList.Items.Add(fStrBuf);
end;

// -----------------------------------------------------------------------------

procedure TSCNFScanDirectory.UpdateProgressOperation(const S: string);
begin
  fStrBuf := S;
  Synchronize(SyncUpdateProgressOperation);  
end;

// -----------------------------------------------------------------------------

procedure TSCNFScanDirectory.UpdatePercentage;
begin
  Synchronize(frmProgress.UpdateProgressBar);
end;
 
// -----------------------------------------------------------------------------

end.
