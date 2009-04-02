unit multiscan;

interface

uses
  SysUtils, Classes, Forms, Math, DCL_Intf, HashMap;

type
  TMultiTranslationSubtitlesRetriever = class(TThread)
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
    procedure SyncUpdateScnfFileList;

    PROCEDURE TEST_METHOD;
  protected
    procedure Execute; override;
  public
    constructor Create(const BaseDir, FileList: string);
  end;

// -----------------------------------------------------------------------------
implementation
// -----------------------------------------------------------------------------

uses
  Main, Progress, ScnfEdit;

// -----------------------------------------------------------------------------
{ TSCNFScanDirectory }
// -----------------------------------------------------------------------------

constructor TMultiTranslationSubtitlesRetriever.Create(const BaseDir,
  FileList: string);
begin
  FreeOnTerminate := True;
  fBaseDir := BaseDir;
  fFileListParam := FileList;
  
  inherited Create(True);
end;

procedure TMultiTranslationSubtitlesRetriever.Execute;
var
  i, j: Integer;
  BaseDir, FileName: TFileName;
  hm: IStrMap;
  _tmp_scnf_edit: TSCNFEditor;
  Key: string;
  Value: TObject;
  
begin
  BaseDir := IncludeTrailingPathDelimiter(frmMain.SelectedDirectory);

  fFilesList := TStringList.Create;
  fFilesList.Text := Self.fFileListParam;

  hm := TStrHashMap.Create;
  _tmp_scnf_edit := TSCNFEditor.Create;
  try
    // scanning all found files
    InitializeProgressWindow(fFilesList.Count);
    
    for i := 0 to fFilesList.Count - 1 do begin
      if Terminated then Break;
      FileName := BaseDir + fFilesList[i];
      
      UpdateProgressOperation('Scanning ' + ExtractFileName(FileName) + '...');

      // retrieve all subs from this file
      _tmp_scnf_edit.LoadFromFile(FileName);

      for j := 0 to _tmp_scnf_edit.Subtitles.Count - 1 do begin
        Key := _tmp_scnf_edit.Subtitles[j].Text;
        Value := nil;
        if (not hm.ContainsKey(Key)) then begin
          hm.PutValue(Key, Value);
          {$IFDEF DEBUG} WriteLn('-> K: "', Key, '", V: "', '', '"'); {$ENDIF}

          fStrBuf := Key;
          Synchronize(TEST_METHOD);
        end;
      end;

      UpdatePercentage;
    end;

  finally
    fFilesList.Free;
    _tmp_scnf_edit.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMultiTranslationSubtitlesRetriever.InitializeProgressWindow(const FilesCount: Integer);
begin
  fIntBuf := FilesCount;
  Synchronize(SyncInitializeProgressWindow);
end;

// -----------------------------------------------------------------------------

procedure TMultiTranslationSubtitlesRetriever.UpdateProgressOperation(const S: string);
begin
  fStrBuf := S;
  Synchronize(SyncUpdateProgressOperation);
end;

// -----------------------------------------------------------------------------

procedure TMultiTranslationSubtitlesRetriever.UpdatePercentage;
begin
  Synchronize(frmProgress.UpdateProgressBar);
end;

// -----------------------------------------------------------------------------
// DON'T CALL DIRECTLY THESES METHODS
// -----------------------------------------------------------------------------

procedure TMultiTranslationSubtitlesRetriever.SyncInitializeProgressWindow;
begin
  frmProgress.pbar.Max := fIntBuf;
end;

procedure TMultiTranslationSubtitlesRetriever.SyncUpdateProgressOperation;
begin
  frmProgress.lInfos.Caption := fStrBuf;
end;

procedure TMultiTranslationSubtitlesRetriever.SyncUpdateScnfFileList;
begin
  frmMain.lbFilesList.Items.Add(fStrBuf);
end;

procedure TMultiTranslationSubtitlesRetriever.TEST_METHOD;
begin
  frmMain.cbSubs.Items.Add(fStrBuf);
end;

end.
