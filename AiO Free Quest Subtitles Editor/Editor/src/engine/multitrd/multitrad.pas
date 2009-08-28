//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit multitrad;

interface

uses
  SysUtils, Classes, Forms, Math;

type
  TMultiTranslator = class(TThread)
  private
    fFilesList: TStringList;
    fIntBuf: Integer;
    fStrBuf: string;
    fBaseDir: string;
    fFileListParam: string;

    procedure InitializeProgressWindow(const FilesCount: Integer);
    procedure UpdatePercentage;
    procedure UpdateProgressOperation(const S: string);

    // --- don't call directly ---
    procedure SyncInitializeProgressWindow;
    procedure SyncUpdateProgressOperation;
//    procedure SyncUpdateScnfFileList;
  protected
    procedure Execute; override;
  public
    property BaseDir: string read fBaseDir write fBaseDir;
    property FileList: string read fFileListParam write fFileListParam;
  end;

implementation

uses
  Main, Progress;

{ TSCNFScanDirectory }

procedure TMultiTranslator.Execute;
var
  i: Integer;
  BaseDir, FileName: TFileName;
  
begin
  BaseDir := IncludeTrailingPathDelimiter(frmMain.SelectedDirectory);

  raise Exception.Create('TO DO');
  
  sleep(1000);
  
  fFilesList := TStringList.Create;
  fFilesList.Text := Self.fFileListParam;
  try
    // scanning all found files
    InitializeProgressWindow(fFilesList.Count);
    
    for i := 0 to fFilesList.Count - 1 do begin
      if Terminated then Break;
      FileName := BaseDir + fFilesList[i];
      
      UpdateProgressOperation('Scanning ' + FileName + '...');

      // retrieve all subs from this file
      // Sleep(5000);

      UpdatePercentage;
    end;

  finally
    fFilesList.Free;
  end;
end;

procedure TMultiTranslator.InitializeProgressWindow(const FilesCount: Integer);
begin
  fIntBuf := FilesCount;
  Synchronize(SyncInitializeProgressWindow);
end;

procedure TMultiTranslator.UpdateProgressOperation(const S: string);
begin
  fStrBuf := S;
  Synchronize(SyncUpdateProgressOperation);
end;

procedure TMultiTranslator.UpdatePercentage;
begin
  Synchronize(frmProgress.UpdateProgressBar);
end;

// --- Don't call directly theses methods --------------------------------------

procedure TMultiTranslator.SyncInitializeProgressWindow;
begin
  frmProgress.pbar.Max := fIntBuf;
end;

procedure TMultiTranslator.SyncUpdateProgressOperation;
begin
  frmProgress.lInfos.Caption := fStrBuf;
end;

(*procedure TMultiTranslator.SyncUpdateScnfFileList;
begin
  frmMain.lbFilesList.Items.Add(fStrBuf);
end;*)

end.
