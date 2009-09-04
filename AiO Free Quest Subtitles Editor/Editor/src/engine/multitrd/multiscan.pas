(*

  This unit was made to control the subtitles retriver process.
  It uses the textdata unit to store each subtitle info.
*)

unit multiscan;

interface

uses
  SysUtils, Classes, Forms, Math, ComCtrls, TextData, CharsLst, ScnfUtil;

type
  TMultiTranslationSubtitlesRetriever = class(TThread)
  private
//    fBufNode: TTreeNode;
    fStrBuf: string;
    fFilesList: TStringList;
    fIntBuf: Integer;
    fStrCurrentOperation: string;
    fStrSubtitle: string;
    fSubtitleInfoList: ISubtitleInfoList;
    fBaseDir: string;
    fFileListParam: string;
    fDecodeSubtitles: Boolean;
    fCharsList: TSubsCharsList;
//    fEnabled: Boolean;

    procedure InitializeProgressWindow(const FilesCount: Integer);
    procedure AddDebug(const Text: string);
    procedure UpdatePercentage;
    procedure UpdateProgressOperation(const S: string);
    procedure UpdateViewSubsList(const Subtitle: string;
      DataInfo: ISubtitleInfoList);
//    procedure ChangeUpdateMemoViewState(const Enabled: Boolean);

    // --- don't call directly ---
    procedure SyncAddDebug;
    procedure SyncInitializeProgressWindow;
    procedure SyncUpdateProgressOperation;
    procedure SyncUpdateViewSubsList;
//    procedure SyncChangeUpdateMemoViewState;
    
  protected
    procedure Execute; override;
    property CharsList: TSubsCharsList read fCharsList write fCharsList;
  public
    constructor Create(const BaseDir, FileList: string; DecodeSubtitles: Boolean);
  end;

// -----------------------------------------------------------------------------
implementation
// -----------------------------------------------------------------------------

uses
  Main, Progress, ScnfEdit, Utils, Common, IconsUI;

// -----------------------------------------------------------------------------
{ TMultiTranslationSubtitlesRetriever }
// -----------------------------------------------------------------------------

(*procedure TMultiTranslationSubtitlesRetriever.ChangeUpdateMemoViewState(
  const Enabled: Boolean);
begin
  fEnabled := Enabled;
  Synchronize(SyncChangeUpdateMemoViewState);
end;*)

// -----------------------------------------------------------------------------

procedure TMultiTranslationSubtitlesRetriever.AddDebug(const Text: string);
begin
  fStrBuf := Text;
  Synchronize(SyncAddDebug);
end;

constructor TMultiTranslationSubtitlesRetriever.Create(const BaseDir,
  FileList: string; DecodeSubtitles: Boolean);
begin
  FreeOnTerminate := True;
  fBaseDir := BaseDir;
  fFileListParam := FileList;
  fDecodeSubtitles := DecodeSubtitles;
  
  inherited Create(True);
end;

// -----------------------------------------------------------------------------

procedure TMultiTranslationSubtitlesRetriever.Execute;
var
  i, j: Integer;
  BaseDir, FileName: TFileName;
  _tmp_scnf_edit: TSCNFEditor;
  Code, Text: string;
  List: ISubtitleInfoList;
(*  CharsList: TSubsCharsList;
  CharsListFound: Boolean;
  PrevGameVersion: TGameVersion;  *)

begin
  BaseDir := IncludeTrailingPathDelimiter(frmMain.SelectedDirectory);

  fFilesList := TStringList.Create;
  fFilesList.Text := Self.fFileListParam;

  MultiTranslationTextData.Clear;

  //----------------------------------------------------------------------------
  // BUILDING THE TEXT DATA LIST
  //----------------------------------------------------------------------------

  CharsList := TSubsCharsList.Create;
  _tmp_scnf_edit := TSCNFEditor.Create;
  try
    // scanning all found files
    InitializeProgressWindow(fFilesList.Count);

    // For each file found...
    for i := 0 to fFilesList.Count - 1 do begin
      if Terminated then Break;
      FileName := BaseDir + fFilesList[i];

      UpdateProgressOperation('Scanning "' + ExtractFileName(FileName) + '"...');

      // Retrieve all subs from this file
      _tmp_scnf_edit.LoadFromFile(FileName);

      // Adding each subtitle of the file to the "database"
      for j := 0 to _tmp_scnf_edit.Subtitles.Count - 1 do begin
        Text := _tmp_scnf_edit.Subtitles[j].Text;
        Code := _tmp_scnf_edit.Subtitles[j].Code;

        MultiTranslationTextData.PutSubtitleInfo(Text, Code, FileName,
          _tmp_scnf_edit.GameVersion);
      end;

      UpdatePercentage;
    end;

    MultiTranslationTextData.Subtitles.Sort;

    //----------------------------------------------------------------------------
    // FILLING THE VIEW
    //----------------------------------------------------------------------------

    // Adding all infos to the TreeView
    InitializeProgressWindow(MultiTranslationTextData.Subtitles.Count);
    UpdateProgressOperation('Updating view with extracted datas...');
//    PrevGameVersion := gvUndef;
    
    for i := 0 to MultiTranslationTextData.Subtitles.Count - 1 do begin
      if Terminated then Break;
      Text := MultiTranslationTextData.Subtitles[i];
      List := MultiTranslationTextData.GetSubtitleInfo(Text);

      // Loading the correct charslist
      (*if not IsTheSameCharsList(PrevGameVersion, _tmp_scnf_edit.GameVersion) then begin
        CharsListFound := CharsList.LoadFromFile(GetCorrectCharsList(_tmp_scnf_edit.GameVersion));
        if CharsListFound then
          CharsList.Active := fDecodeSubtitles
        else
          CharsList.Active := False;
      end;
      PrevGameVersion := _tmp_scnf_edit.GameVersion;*)

//      UpdateViewSubsList(CharsList.DecodeSubtitle(Text), List);

      UpdateViewSubsList(Text, List);
      UpdatePercentage;
    end;

  finally
    fFilesList.Free;
    _tmp_scnf_edit.Free;
    CharsList.Free;
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
  fStrCurrentOperation := S;
  Synchronize(SyncUpdateProgressOperation);
end;

// -----------------------------------------------------------------------------

procedure TMultiTranslationSubtitlesRetriever.UpdateViewSubsList(
  const Subtitle: string; DataInfo: ISubtitleInfoList);
begin
  fStrSubtitle := Subtitle;
  fSubtitleInfoList := DataInfo;
  Synchronize(SyncUpdateViewSubsList);
end;

// -----------------------------------------------------------------------------

procedure TMultiTranslationSubtitlesRetriever.UpdatePercentage;
begin
  Synchronize(frmProgress.UpdateProgressBar);
end;

// -----------------------------------------------------------------------------
// DON'T CALL DIRECTLY THESES METHODS
// -----------------------------------------------------------------------------

(*procedure TMultiTranslationSubtitlesRetriever.SyncChangeUpdateMemoViewState;
begin
  if fEnabled then begin
    frmMain.tvMultiSubs.OnChange := frmMain.tvMultiSubsChange;
//    frmMain.mMTNewSub.OnChange := frmMain.mMTNewSubChange;
  end else begin
    frmMain.tvMultiSubs.OnChange := nil;
//    frmMain.mMTNewSub.OnChange := nil;
  end;
end;
*)

// -----------------------------------------------------------------------------

procedure TMultiTranslationSubtitlesRetriever.SyncAddDebug;
begin
  frmMain.AddDebug(fStrBuf);
end;

procedure TMultiTranslationSubtitlesRetriever.SyncInitializeProgressWindow;
begin
  frmProgress.pbar.Max := fIntBuf;
  frmProgress.pbar.Position := 0;
end;

// -----------------------------------------------------------------------------

procedure TMultiTranslationSubtitlesRetriever.SyncUpdateProgressOperation;
begin
  frmProgress.lInfos.Caption := fStrCurrentOperation;
end;

// -----------------------------------------------------------------------------

procedure TMultiTranslationSubtitlesRetriever.SyncUpdateViewSubsList;
var
  RootNode, TranslatedNode, EntriesNode, Node: TTreeNode;
  j: Integer;
  Code, FileName: string;
  GameVersion,
  PrevGameVersion: TGameVersion;
  CharsListProblematic, // true if in the same subtitle, 2 games types are present
  CharsListFound: Boolean;

  function NewNodeType(NodeViewType: TMultiTranslationNodeViewType;
    GameVersion: TGameVersion): PMultiTranslationNodeType;
  begin
    Result := New(PMultiTranslationNodeType);
    Result^.NodeViewType := NodeViewType;
    Result^.GameVersion := GameVersion;
  end;

  procedure SetGameVersion(Node: TTreeNode; GameVersion: TGameVersion);
  begin
    PMultiTranslationNodeType(Node.Data)^.GameVersion := GameVersion;
  end;

begin
  // Adding the original node
  RootNode := frmMain.tvMultiSubs.Items.Add(nil, fStrSubtitle);
  RootNode.Data := NewNodeType(nvtSubtitleKey, gvUndef);
  RootNode.ImageIndex := GT_ICON_NOT_TRANSLATED;
  RootNode.SelectedIndex := GT_ICON_NOT_TRANSLATED;
  RootNode.OverlayIndex := -1;

  try
    // Adding the NewSubtitle node
    TranslatedNode := frmMain.tvMultiSubs.Items.AddChild(RootNode, MT_NOT_TRANSLATED_YET);
    TranslatedNode.Data := NewNodeType(nvtSubTranslated, gvUndef);
    TranslatedNode.ImageIndex := GT_ICON_TRANSLATED_TEXT;
    TranslatedNode.SelectedIndex := GT_ICON_TRANSLATED_TEXT;
    TranslatedNode.OverlayIndex := -1;

    // Creating the Entries node if needed
    EntriesNode := frmMain.tvMultiSubs.Items.AddChild(RootNode, 'Subtitles');
    EntriesNode.Data := NewNodeType(nvtUndef, gvUndef);
    EntriesNode.ImageIndex := GT_ICON_SUBTITLES_FOLDER;
    EntriesNode.SelectedIndex := GT_ICON_SUBTITLES_FOLDER;
    EntriesNode.OverlayIndex := -1;

    // Put plural or not...
    Code := 'entry';
    if fSubtitleInfoList.Count <> 1 then Code := 'entries';
    EntriesNode.Text := EntriesNode.Text + ' (' +
      IntToStr(fSubtitleInfoList.Count) + ' ' + Code + ')';

    // Filling the "EntriesNode"
    PrevGameVersion := gvUndef;
    CharsListProblematic := False;   
    for j := 0 to fSubtitleInfoList.Count - 1 do begin
      FileName := ExtractFileName(fSubtitleInfoList.Items[j].FileName);
      Code := fSubtitleInfoList.Items[j].Code;
      GameVersion := fSubtitleInfoList.Items[j].GameVersion;

      // Checks if for the SAME subtitles TWO charsets are used (Problem!
      // How to determine the right charset??)
      if (PrevGameVersion <> gvUndef) and (not CharsListProblematic) then
        CharsListProblematic := not IsTheSameCharsList(PrevGameVersion, GameVersion);
      PrevGameVersion := GameVersion;

      // Adding the file node
      Node := FindNode(EntriesNode, FileName);
      if Node = nil then begin
        Node := frmMain.tvMultiSubs.Items.AddChild(EntriesNode, FileName);
        Node.Data := NewNodeType(nvtSourceFile, GameVersion);
        Node.ImageIndex := GT_ICON_PAKS_FILE;
        Node.SelectedIndex := GT_ICON_PAKS_FILE;
        Node.OverlayIndex := -1;
      end;

      // Adding the Sub code node
      Node := frmMain.tvMultiSubs.Items.AddChild(Node, Code);
      Node.Data := NewNodeType(nvtSubCode, gvUndef);
      Node.ImageIndex := GT_ICON_SUBTITLE_CODE;
      Node.SelectedIndex := GT_ICON_SUBTITLE_CODE;
      Node.OverlayIndex := -1;
    end;

    // Final: setting the GameVersion for the RootNode (SubKey) and TranslatedNode (TranslatedText)
    if CharsListProblematic then begin
      AddDebug('WARNING: Chars list problem for the subtitle "'
        + fStrSubtitle + '" ! Two different game versions was detected, '
        + 'so unable to multi-translate this item.');
      RootNode.ImageIndex := GT_ICON_ERRORNOUS_SUBTITLE;
      RootNode.SelectedIndex := GT_ICON_ERRORNOUS_SUBTITLE;
      RootNode.OverlayIndex := -1;
    end else begin
      SetGameVersion(RootNode, PrevGameVersion);
      SetGameVersion(TranslatedNode, PrevGameVersion);

      CharsListFound := CharsList.LoadFromFile(GetCorrectCharsList(PrevGameVersion));
      if CharsListFound then
        CharsList.Active := fDecodeSubtitles
      else
        CharsList.Active := False;
      RootNode.Text := CharsList.DecodeSubtitle(RootNode.Text);
    end;

    RootNode.Selected := True;
  except 
    // nothing
  end;
end;

// -----------------------------------------------------------------------------

initialization
  MultiTranslationTextData := TMultiTranslationTextData.Create;

finalization
  MultiTranslationTextData.Free;

// -----------------------------------------------------------------------------
  
end.
