//    This file is part of IDX Creator.
//
//    You should have received a copy of the GNU General Public License
//    along with IDX Creator.  If not, see <http://www.gnu.org/licenses/>.

unit UIdxTemplateCreation;

interface

uses
  Classes, SysUtils, Math {$IFNDEF APPTYPE_CONSOLE}, Forms, progress{$ENDIF};

type
  TIdxTemplateCreation = class(TThread)
  private
    { Déclarations privées }
    fNewIdxName: TFileName;
    fNewAfsName: TFileName;
    fOldIdxName: TFileName;
    fOldAfsName: TFileName;
    fProgressCount: Integer; //Used to track creation progress
    {$IFNDEF APPTYPE_CONSOLE}
    fCurrentTask: String;
    fProgressWindow: TfrmProgress;
    {$ENDIF}
    function VerifyCount(const OldIdxCount, OldAfsCount, NewAfsCount: Integer): Boolean;
    procedure SyncCurrentTask(const Task: String);
    {$IFNDEF APPTYPE_CONSOLE}
    procedure SyncPercentage;
    procedure SyncDefaultFormValue;
    procedure UpdatePercentage;
    procedure UpdateCurrentTask;
    procedure UpdateDefaultFormValue;
    procedure CancelBtnClick(Sender: TObject);
    {$ENDIF}
    procedure RaiseError;
    procedure CloseThread(Sender: TObject);
  protected
    procedure Execute; override;
  public
    ThreadTerminated: Boolean;
    ErrorRaised: Boolean;
    constructor Create(const NewIdxFileName, NewAfsFileName,
    OldIdxFileName, OldAfsFileName: TFileName);
  end;

implementation
uses UIdxStruct, UAfsStruct, USrfStruct;
{ TIdxCreation }

constructor TIdxTemplateCreation.Create(const NewIdxFileName, NewAfsFileName,
OldIdxFileName, OldAfsFileName: TFileName);
begin
  inherited Create(False);

  fNewIdxName := NewIdxFileName;
  fNewAfsName := NewAfsFileName;
  fOldIdxName := OldIdxFileName;
  fOldAfsName := OldAfsFileName;

  {$IFNDEF APPTYPE_CONSOLE}fProgressWindow := TfrmProgress.Create(nil);{$ENDIF}
  ThreadTerminated := False;
  ErrorRaised := False;
  OnTerminate := CloseThread;
end;

procedure TIdxTemplateCreation.Execute;
var
  newIdx, oldIdx: TIdxStruct;
  newAfs, oldAfs: TAfsStruct;
  oldSrf, newSrf: TSrfStruct;
  i, j, subNum, subOffset, lastSrf: Integer;
  srfNum: Word;
begin
  oldIdx := nil;
  oldSrf := nil;
  oldAfs := nil;
  newAfs := nil;
  newSrf := nil;
  try
    try
      //Creating instance and loading files
      oldIdx := TIdxStruct.Create;
      oldIdx.LoadFromFile(fOldIdxName);
      oldAfs := TAfsStruct.Create;
      oldAfs.LoadFromFile(fOldAfsName);
      newAfs := TAfsStruct.Create;
      newAfs.LoadFromFile(fNewAfsName);

      //newIdx is a copy of the old one that will be updated
      newIdx := TIdxStruct.Create;
      oldIdx.CopyTo(newIdx);

      //Creating new instance of TSrfStruct
      oldSrf := TSrfStruct.Create;
      newSrf := TsrfStruct.Create;

      if not VerifyCount(oldIdx.Count+oldIdx.SrfCount, oldAfs.Count, newAfs.Count) then begin
        RaiseError;
      end
      else begin
        fProgressCount := oldIdx.Count;
        {$IFNDEF APPTYPE_CONSOLE}SyncDefaultFormValue;{$ENDIF}
      end;

      lastSrf := -1;
      subNum := -1;
      for i := 0 to oldIdx.Count - 1 do begin
        if not Terminated then begin
          srfNum := oldIdx.Items[i].LinkedSrf;
          subOffset := oldIdx.Items[i].SubOffset;

          if (srfNum <= oldAfs.Count) then begin
            //Loading original and new SRF
            if srfNum <> lastSrf then begin
              oldSrf.LoadFromFile(oldAfs.FileName, oldAfs.Items[srfNum].Offset, oldAfs.Items[srfNum].Size);
              newSrf.LoadFromFile(newAfs.FileName, newAfs.Items[srfNum].Offset, newAfs.Items[srfNum].Size);
            end;

            //Finding new offset
            for j := 0 to oldSrf.Count - 1 do begin
              if subOffset = oldSrf.Items[j].Offset then begin
                subNum := j;
                Break;
              end;
            end;

            //Updating newIdx
            SyncCurrentTask('Updating IDX... entry #'+IntToStr(i));
            if subNum <> -1 then begin
              subOffset := newSrf.Items[subNum].Offset;
              newIdx.Items[i].SubOffset := subOffset;
            end
            else begin
              RaiseError;
            end;
          end;

          //Keeping SRF number and updating form
          lastSrf := srfNum;
          {$IFNDEF APPTYPE_CONSOLE}SyncPercentage;{$ENDIF}
        end
        else begin
          Break;
        end;
      end;

      //Saving new IDX
      if not Terminated then begin
        SyncCurrentTask('Saving new IDX...');
        newIdx.SaveToFile(fNewIdxName);
      end;

    except
      RaiseError;
    end;

  finally
    //Freeing main var
    oldSrf.Free;
    newSrf.Free;
    oldIdx.Free;
    oldAfs.Free;
    newIdx.Free;
    newAfs.Free;
  end;

  {$IFDEF APPTYPE_CONSOLE}CloseThread(Self);{$ENDIF}
end;

function TIdxTemplateCreation.VerifyCount(const OldIdxCount, OldAfsCount, NewAfsCount: Integer): Boolean;
var
  mainCnt: Integer;
begin
  Result := False;
  mainCnt := OldAfsCount;
  if (OldIdxCount = mainCnt) and (NewAfsCount = mainCnt) then begin
    Result := True;
  end;
end;

procedure TIdxTemplateCreation.SyncCurrentTask(const Task: string);
begin
  {$IFNDEF APPTYPE_CONSOLE}
  fCurrentTask := Task;
  Synchronize(UpdateCurrentTask);
  {$ELSE}
  WriteLn('[i] ', Task);
  {$ENDIF}
end;

{$IFNDEF APPTYPE_CONSOLE}

procedure TIdxTemplateCreation.SyncPercentage;
begin
  Synchronize(UpdatePercentage);
end;

procedure TIdxTemplateCreation.SyncDefaultFormValue;
begin
  Synchronize(UpdateDefaultFormValue);
end;

procedure TIdxTemplateCreation.UpdatePercentage;
var
  i: Integer;
  floatBuf: Real;
begin
  i := fProgressWindow.ProgressBar1.Position;
  fProgressWindow.ProgressBar1.Position := i+1;
  floatBuf := SimpleRoundTo((100*(i+1))/fProgressCount, -2);
  fProgressWindow.Panel1.Caption := FloatToStr(floatBuf)+'%';
  Application.ProcessMessages;
end;

procedure TIdxTemplateCreation.UpdateCurrentTask;
begin
  fProgressWindow.lblCurrentTask.Caption := 'Current task: '+fCurrentTask;
end;

procedure TIdxTemplateCreation.UpdateDefaultFormValue;
begin
  //Setting progress form main value
  fProgressWindow.Caption := 'Creation in progress... '+ExtractFileName(fNewIdxName);
  fProgressWindow.lblCurrentTask.Caption := 'Current task:';
  fProgressWindow.Position := poMainFormCenter;
  fProgressWindow.ProgressBar1.Max := fProgressCount;
  fProgressWindow.btCancel.OnClick := Self.CancelBtnClick;
  fProgressWindow.Panel1.Caption := '0%';
  fProgressWindow.Show;
end;

procedure TIdxTemplateCreation.CancelBtnClick(Sender: TObject);
begin
  Terminate;
end;

{$ENDIF}

procedure TIdxTemplateCreation.RaiseError;
begin
  ErrorRaised := True;
  Terminate;
end;

procedure TIdxTemplateCreation.CloseThread(Sender: TObject);
begin
  {$IFNDEF APPTYPE_CONSOLE}
  if Assigned(fProgressWindow) then begin
    fProgressWindow.Release;
  end;
  {$ENDIF}
  ThreadTerminated := True;
end;

end.
