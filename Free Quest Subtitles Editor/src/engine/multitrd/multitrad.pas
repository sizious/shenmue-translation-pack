//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit multitrad;

interface

uses
  SysUtils, Classes;

type
  TMultiTranslationExecThreadCompletedEvent = procedure(Sender: TObject;
    SubsUpdatedCount, SubsUpdatedOccurencesCount: Integer) of object;
    
  TMultiTranslationExecThread = class(TThread)
  private
    fIntBuf: Integer;
    fStrBuf: string;
    fOnCompleted: TMultiTranslationExecThreadCompletedEvent;

    procedure InitializeProgressWindow(const FilesCount: Integer);
    procedure UpdatePercentage;
    procedure UpdateProgressOperation(const S: string);

    // --- don't call directly ---
    procedure SyncInitializeProgressWindow;
    procedure SyncUpdateProgressOperation;
  protected
    procedure Execute; override;
  public
    constructor Create;
    property OnCompleted: TMultiTranslationExecThreadCompletedEvent
      read fOnCompleted write fOnCompleted;
  end;

implementation

uses
  Forms, Main, Progress, ScnfEdit, TextData, NpcInfo
{$IFDEF DEBUG}
  , TypInfo
{$ENDIF}
  ;

{ TMultiTranslationExecThread }

constructor TMultiTranslationExecThread.Create;
begin
  FreeOnTerminate := True;
  inherited Create(True);
end;

procedure TMultiTranslationExecThread.Execute;
var
  CurrentFileInfo: TCurrentFileMultiTranslationModule;
  ExcludeFileName: TFileName;
  MT_SCNFEditor: TSCNFEditor;
  i, j, SubIndex, SubsUpdatedCount, SubsUpdatedOccurencesCount: Integer;
  NewSubtitleEntry: TSubEntry;
  SubInfo: TSubtitlesInfoList;
  SubUpdated, FileNeedToUpdate: Boolean;
  UserViewGender: TGenderType;
{$IFDEF DEBUG}
  LoadSuccess: Boolean;
{$ENDIF}

begin
{$IFDEF DEBUG}
  DebugLoadFromFile := False;
  DebugParseScnfSection := False;
  DebugSaveToFile := False;
  WriteLn(sLineBreak, '*** MULTI-TRANSLATING ***');
{$ENDIF}

  SubsUpdatedCount := 0;
  SubsUpdatedOccurencesCount := 0;

  // SCNFEditor is the current file edited. It contains the new subtitles values.
  ExcludeFileName := SCNFEditor.SourceFileName;
  UserViewGender := SCNFEditor.Gender;

  with frmMain.MultiTranslation do begin

    CurrentFileInfo := CurrentLoadedFile;

    MT_SCNFEditor := TSCNFEditor.Create;
    try
      MT_SCNFEditor.CharsList.Active := False;

      InitializeProgressWindow(CurrentFileInfo.Count);

      for i := 0 to CurrentFileInfo.Count - 1 do begin
        SubUpdated := False;
        
        // This is the new subtitle value
        NewSubtitleEntry := SCNFEditor.Subtitles[i];

        // Getting the files list that have this subtitle
        SubInfo := CurrentFileInfo.Subtitles[i];

{$IFDEF DEBUG}
        WriteLn('Subtitle ', i, ': ');
{$ENDIF}

        // Parsing Subtitle info
        if Assigned(SubInfo) then // can be "nil" if the object has been merged with other

          if SubInfo.SubtitleKey <> NewSubtitleEntry.RawText then begin

{$IFDEF DEBUG}
            WriteLn(' "', SubInfo.SubtitleKey, '" -> "', NewSubtitleEntry.RawText, '"');
{$ENDIF}

            for j := 0 to SubInfo.Count - 1 do begin
              
              UpdateProgressOperation('Proceeding "'
                + ExtractFileName(SubInfo[j].FileName) + '" ('
                + SubInfo[j].Code + ') ...');

              // Test if the file is needed to be updated
              FileNeedToUpdate := (SubInfo[j].FileName <> ExcludeFileName);
              if SubInfo[j].Gender <> gtUndef then
                FileNeedToUpdate := UserViewGender = SubInfo[j].Gender;

              // This file is to translate
              if FileNeedToUpdate then begin
                SubUpdated := True;
{$IFDEF DEBUG}
                LoadSuccess := MT_SCNFEditor.LoadFromFile(SubInfo[j].FileName);
                Write('   ', ExtractFileName(SubInfo[j].FileName), ': Loaded = ',
                  LoadSuccess);
{$ELSE}
                MT_SCNFEditor.LoadFromFile(SubInfo[j].FileName);
{$ENDIF}
                SubIndex := MT_SCNFEditor.Subtitles.IndexOfSubtitleByCode(SubInfo[j].Code);
                if SubIndex <> -1 then
                  MT_SCNFEditor.Subtitles[SubIndex].Text := NewSubtitleEntry.RawText;

{$IFDEF DEBUG}
                WriteLn(', Code = ', SubInfo[j].Code, ', Gender = ',
                GetEnumName(TypeInfo(TGenderType), Ord(SubInfo[j].Gender)),
                  ', SubIndex = ', SubIndex);
{$ENDIF}

                MT_SCNFEditor.Save;
                Inc(SubsUpdatedOccurencesCount);
              end; // SubInfo[j].FileName <> ExcludeFileName

            end; // for j

            // Updating SubtitleKey
            CurrentFileInfo.CacheList[i] :=
              TextDataList.UpdateSubtitleKey(SubInfo.SubtitleKey, NewSubtitleEntry.RawText);

            SubInfo.NewSubtitle := NewSubtitleEntry.RawText;

            if SubUpdated then
              Inc(SubsUpdatedCount);
            
          end; // SubInfo.SubtitleKey <> NewSubtitleEntry.RawText

        UpdatePercentage;
      end;

      if Assigned(fOnCompleted) then
        fOnCompleted(Self, SubsUpdatedCount, SubsUpdatedOccurencesCount);

    finally
      MT_SCNFEditor.Free;
    end;

  end; // with frmMain.MultiTranslation

{$IFDEF DEBUG}
  DebugLoadFromFile := True;
  DebugParseScnfSection := True;
  DebugSaveToFile := True;
  WriteLn('');
{$ENDIF}
end;

procedure TMultiTranslationExecThread.InitializeProgressWindow(const FilesCount: Integer);
begin
  fIntBuf := FilesCount;
  Synchronize(SyncInitializeProgressWindow);
end;

procedure TMultiTranslationExecThread.UpdateProgressOperation(const S: string);
begin
  fStrBuf := S;
  Synchronize(SyncUpdateProgressOperation);
end;

procedure TMultiTranslationExecThread.UpdatePercentage;
begin
  Synchronize(frmProgress.UpdateProgressBar);
end;

// --- Don't call directly theses methods --------------------------------------

procedure TMultiTranslationExecThread.SyncInitializeProgressWindow;
begin
  frmProgress.pbar.Max := fIntBuf;
  frmProgress.pbar.Position := 0;
end;

procedure TMultiTranslationExecThread.SyncUpdateProgressOperation;
begin
  frmProgress.lInfos.Caption := fStrBuf;
end;

end.
