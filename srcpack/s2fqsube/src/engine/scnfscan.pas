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
    procedure SyncUpdatePercentage;
    procedure SyncUpdateProgressOperation;
    procedure SyncUpdateScnfFileList;
  protected
    procedure Execute; override;
  public
    procedure SetTargetDirectory(const Directory: string);
  end;

implementation

uses
  Main, ScanDir, ScnfUtil;
  
{
 Important : les méthodes et propriétés des objets de la VCL peuvent uniquement
  être utilisés dans une méthode appelée en utilisant Synchronize, comme :

      Synchronize(UpdateCaption);

  où UpdateCaption serait de la forme

    procedure TSCNFScanDirectory.UpdateCaption;
    begin
      Form1.Caption := 'Mis à jour dans un thread';
    end;
}
    
{ TSCNFScanDirectory }

procedure TSCNFScanDirectory.AddValidFile(const FileName: TFileName);
begin
  fStrBuf := FileName; 
  Synchronize(SyncUpdateScnfFileList);
end;

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

procedure TSCNFScanDirectory.InitializeProgressWindow(const FilesCount: Integer);
begin
  fIntBuf := FilesCount;
  Synchronize(SyncInitializeProgressWindow);
end;

procedure TSCNFScanDirectory.SetTargetDirectory(const Directory: string);
begin
  fTargetDirectory := Directory;
end;

procedure TSCNFScanDirectory.SyncInitializeProgressWindow;
begin
  frmDirScan.pbar.Max := fIntBuf;
end;

procedure TSCNFScanDirectory.SyncUpdatePercentage;
begin
  frmDirScan.pbar.Position := frmDirScan.pbar.Position + 1;
  frmDirScan.lProgBar.Caption := FloatToStr(SimpleRoundTo((100*frmDirScan.pbar.Position)/frmDirScan.pbar.Max, -2))+'%';
  Application.ProcessMessages;
end;

procedure TSCNFScanDirectory.SyncUpdateProgressOperation;
begin
  frmDirScan.lInfos.Caption := fStrBuf;
end;

procedure TSCNFScanDirectory.SyncUpdateScnfFileList;
begin
  frmMain.lbFilesList.Items.Add(fStrBuf);
end;

procedure TSCNFScanDirectory.UpdateProgressOperation(const S: string);
begin
  fStrBuf := S;
  Synchronize(SyncUpdateProgressOperation);  
end;

procedure TSCNFScanDirectory.UpdatePercentage;
begin
  Synchronize(SyncUpdatePercentage);
end;

end.
