unit multiscan;

interface

uses
  SysUtils, Classes, Forms, Math, TextData; //, DCL_Intf, HashMap;

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

//    PROCEDURE TEST_METHOD;
//    PROCEDURE CLEAR_COMBO;
  protected
    procedure Execute; override;
  public
    constructor Create(const BaseDir, FileList: string);
  end;

var
  MultiTranslationTextData: TMultiTranslationTextData;

// -----------------------------------------------------------------------------
implementation
// -----------------------------------------------------------------------------

uses
  Main, Progress, ScnfEdit;

// -----------------------------------------------------------------------------
{ TMultiTranslationSubtitlesRetriever }
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
  _tmp_scnf_edit: TSCNFEditor;
  Code, Text: string;
  //FileName: TFileName;

//  TEXTDATA_OBJ: TMultiTranslationTextData;

begin
  BaseDir := IncludeTrailingPathDelimiter(frmMain.SelectedDirectory);

  fFilesList := TStringList.Create;
  fFilesList.Text := Self.fFileListParam;

//  SYNCHRONIZE(CLEAR_COMBO);

//  hm := TStrHashMap.Create();
//  TEXTDATA_OBJ := TMultiTranslationTextData.Create;
  MultiTranslationTextData.Clear;

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
        Text := _tmp_scnf_edit.Subtitles[j].Text;
        Code := _tmp_scnf_edit.Subtitles[j].Code;

        if MultiTranslationTextData.PutSubtitleInfo(Text, Code, FileName) then begin

 //       Value := nil;
//        if (not hm.ContainsKey(Key)) then begin
//          hm.PutValue(Key, Value);

//          {$IFDEF DEBUG} WriteLn('-> K: "', Key, '", V: "', '', '"'); {$ENDIF}

 //         fStrBuf := Key;
 //         Synchronize(TEST_METHOD);
        end;
      end;

      UpdatePercentage;
    end;

{    writeln('');writeln('');


     writeln(TEXTDATA_OBJ.Subtitles[0]);

    for i := 0 to TEXTDATA_OBJ.GetSubtitleInfo(TEXTDATA_OBJ.Subtitles[0]).Count - 1 do
      writeln('FILE: ', extractfilename(TEXTDATA_OBJ.GetSubtitleInfo(TEXTDATA_OBJ.Subtitles[0]).Items[i].FileName), ' CODE: ', TEXTDATA_OBJ.GetSubtitleInfo(TEXTDATA_OBJ.Subtitles[0]).Items[i].Code);



    TEXTDATA_OBJ.FREE;
}

    MultiTranslationTextData.Subtitles.Sort;



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

{
procedure TMultiTranslationSubtitlesRetriever.TEST_METHOD;
begin
  frmMain.cbSubs.Items.Add(fStrBuf);
end;

PROCEDURE TMultiTranslationSubtitlesRetriever.CLEAR_COMBO;
begin
  frmMain.cbSubs.Items.Clear;
end;
}

initialization
  MultiTranslationTextData := TMultiTranslationTextData.Create;

finalization
  MultiTranslationTextData.Free;
  
end.
