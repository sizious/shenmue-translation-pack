unit mtexec;

interface

uses
  SysUtils, Classes, FilesLst;

type
  TTranslatingSubtitleEvent = procedure(Sender: TObject; OldSubtitle,
    NewSubtitle: string) of object;
  TCompletedEvent = procedure(Sender: TObject; SubsTranslated: Integer) of object;
  TTranslatedEvent = procedure(Sender: TObject; TargetFileName: TFileName;
    TargetSubtitleCode: string) of object;

  TMultiTranslationExecute = class(TThread)
  private
    fBufValue: Integer;
    fOperation: string;
    fSourcesFileList: TFilesList;
    fNewText: string;
    fSameSexOnly: Boolean;
    fOldText: string;
    fOnCompleted: TCompletedEvent;
    fOnFileTranslated: TTranslatedEvent;
    fOnTranslatingSubtitle: TTranslatingSubtitleEvent;
  protected
    procedure Execute; override;
    procedure InitCurrentFileProgressBar(MaxValue: Integer);
    procedure InitTotalProgressBar(MaxValue: Integer);
    procedure UpdateCurrentFileProgressBar;
    procedure UpdateTotalProgressBar;
    procedure UpdateOperation(Operation: string);
    procedure SyncInitCurrentFileProgressBar;
    procedure SyncInitTotalProgressBar;
    procedure SyncUpdateOperation;
    property OldText: string read fOldText write fOldText;
    property NewText: string read fNewText write fNewText;
    property SameSexOnly: Boolean read fSameSexOnly write fSameSexOnly;
    property SourceFilesList: TFilesList read fSourcesFileList write
      fSourcesFileList;
  public
    constructor Create(SourceFileList: TFilesList;
      OldSubtitle, NewSubtitle: string; UpdateSameSexOnly: Boolean);
    property OnTranslatingSubtitle: TTranslatingSubtitleEvent read
      fOnTranslatingSubtitle write fOnTranslatingSubtitle;
    property OnFileTranslated: TTranslatedEvent read fOnFileTranslated
      write fOnFileTranslated;
    property OnCompleted: TCompletedEvent read fOnCompleted write fOnCompleted;
  end;

implementation

uses
  Common, ScnfEdit, NPCInfo, Main, MultiTrd;

{ TMultiTranslationExecute }

constructor TMultiTranslationExecute.Create(SourceFileList: TFilesList;
  OldSubtitle, NewSubtitle: string; UpdateSameSexOnly: Boolean);
begin
  inherited Create(True);
  
  FreeOnTerminate := True;
  OldText := OldSubtitle;
  NewText := NewSubtitle;
  SameSexOnly := UpdateSameSexOnly;
  fSourcesFileList := SourceFileList;

  if not Assigned(fSourcesFileList) then
    raise Exception.Create('SourceFilesList = NIL!');
end;

procedure TMultiTranslationExecute.Execute;
var
  i, j, _cnt: Integer;
  _scnf: TSCNFEditor;
  _filename, _tmp: string;
  CurrentSub: TSubEntry;
  FileToUpdate: Boolean;

begin
  _cnt := 0;

  _scnf := TSCNFEditor.Create;
  try
    _scnf.NPCInfos.LoadFromFile(SCNFEditor.NPCInfos.LoadedFileName);
    _scnf.CharsList.LoadFromFile(SCNFEditor.CharsList.LoadedFileName);
    _scnf.CharsList.Active := True;

    if Assigned(fOnTranslatingSubtitle) then begin
      _tmp := StringReplace(OldText, sLineBreak, '<br>', [rfReplaceAll]);
      _filename := StringReplace(NewText, sLineBreak, '<br>', [rfReplaceAll]);
      fOnTranslatingSubtitle(Self, _tmp, _filename);
    end;

    InitTotalProgressBar(SourceFilesList.Count);

    for i := 0 to SourceFilesList.Count - 1 do begin
      if Terminated then Break;
      
      _filename := SourceFilesList[i].FileName;
      _scnf.LoadFromFile(_filename);

      UpdateOperation('Scanning "' + SourceFilesList[i].ExtractedFileName + '"...');

      FileToUpdate := True;
      if SameSexOnly then
        FileToUpdate := (_scnf.Gender = gtUndef) or (_scnf.Gender = SCNFEditor.Gender);

      if FileToUpdate then begin
        InitCurrentFileProgressBar(_scnf.Subtitles.Count);

        for j := 0 to _scnf.Subtitles.Count - 1 do begin
          if Terminated then Break;
          
          CurrentSub := _scnf.Subtitles[j];

          UpdateOperation('Scanning "' + SourceFilesList[i].ExtractedFileName
            + '" (' + CurrentSub.Code + ') ...');
          if CurrentSub.IsTextEquals(OldText) then begin
            CurrentSub.Text := NewText;
            Inc(_cnt);

            if Assigned(fOnFileTranslated) then
              fOnFileTranslated(Self, _filename, CurrentSub.Code); 
          end;

          UpdateCurrentFileProgressBar;
        end; // for

        _scnf.Save;

      end else
        InitCurrentFileProgressBar(0); // FileToUpdate

      UpdateTotalProgressBar;
    end;

    UpdateOperation('');
    
    if Assigned(fOnCompleted) then
      fOnCompleted(Self, _cnt);

  finally
    _scnf.Free;
//    MsgBox(IntToStr(_cnt) + ' subtitle(s) replaced with success.', 'Information', MB_ICONINFORMATION);
  end;
end;

procedure TMultiTranslationExecute.InitCurrentFileProgressBar(
  MaxValue: Integer);
begin
  fBufValue := MaxValue;
  Synchronize(SyncInitCurrentFileProgressBar);
end;

procedure TMultiTranslationExecute.InitTotalProgressBar(MaxValue: Integer);
begin
  fBufValue := MaxValue;
  Synchronize(SyncInitTotalProgressBar);
end;

procedure TMultiTranslationExecute.SyncInitCurrentFileProgressBar;
begin
  frmMultiTranslation.pbPAKS.Max := fBufValue;
  frmMultiTranslation.pbPAKS.Step := 1;
  frmMultiTranslation.pbPAKS.Position := 0;
end;

procedure TMultiTranslationExecute.SyncInitTotalProgressBar;
begin
  frmMultiTranslation.pbTotal.Max := fBufValue;
  frmMultiTranslation.pbTotal.Step := 1;
  frmMultiTranslation.pbTotal.Position := 0;
end;

procedure TMultiTranslationExecute.SyncUpdateOperation;
begin
  frmMultiTranslation.lblProgress.Caption := fOperation;
end;

procedure TMultiTranslationExecute.UpdateCurrentFileProgressBar;
begin
  Synchronize(frmMultiTranslation.pbPAKS.StepIt);
end;

procedure TMultiTranslationExecute.UpdateOperation(Operation: string);
begin
  fOperation := Operation;
  Synchronize(SyncUpdateOperation);
end;

procedure TMultiTranslationExecute.UpdateTotalProgressBar;
begin
  Synchronize(frmMultiTranslation.pbTotal.StepIt);
end;

end.
