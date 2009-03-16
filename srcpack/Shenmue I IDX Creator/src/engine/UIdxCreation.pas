//    This file is part of IDX Creator for Shenmue.
//
//    You should have received a copy of the GNU General Public License
//    along with IDX Creator for Shenmue.  If not, see <http://www.gnu.org/licenses/>.

unit UIdxCreation;

interface

uses
  Classes, SysUtils, Forms, Math, progress, UAfsStruct, UIdxStruct, USrfStruct;

type
  TIdxCreation = class(TThread)
  private
    { Déclarations privées }
    fModAfsName: TFileName;
    fNewIdxName: TFileName;
    fCurrentTask: String;
    fProgressCount: Integer;
    fProgressWindow: TfrmProgress;
    procedure CreateIdx(var AfsStruct: TAfsStruct; var IdxStruct: TIdxStruct;
                        var SrfStruct: TSrfStruct; const Reversed: Boolean);
    function VerifyOrder(var AfsStruct: TAfsStruct): Boolean;
    function DeleteSubStr(Str, SubStr: String): String;
    procedure SyncPercentage;
    procedure SyncCurrentTask(const Task: String);
    procedure SyncDefaultFormValue;
    procedure UpdatePercentage;
    procedure UpdateCurrentTask;
    procedure UpdateDefaultFormValue;
    procedure CancelBtnClick(Sender: TObject);
    procedure CloseThread(Sender: TObject);
  protected
    procedure Execute; override;
  public
    ThreadTerminated: Boolean;
    ErrorRaised: Boolean;
    constructor Create(const AfsFileName, IdxFileName: TFileName);
  end;

implementation
{ TIdxCreation }

constructor TIdxCreation.Create(const AfsFileName, IdxFileName: TFileName);
begin
  inherited Create(False);

  fModAfsName := AfsFileName;
  fNewIdxName := IdxFileName;
  fProgressWindow := TfrmProgress.Create(nil);

  ThreadTerminated := False;
  ErrorRaised := False;
  OnTerminate := CloseThread;
end;

procedure TIdxCreation.Execute;
var
  newAfs: TAfsStruct;
  newIdx: TIdxStruct;
  newSrf: TSrfStruct;
  reversedOrder: Boolean;
begin
  //Creating instance and loading files if needed
  newAfs := TAfsStruct.Create;
  newAfs.LoadFromFile(fModAfsName);
  newIdx := TIdxStruct.Create;
  newSrf := TSrfStruct.Create;

  fProgressCount := newAfs.Count;
  if fProgressCount > 0 then begin
    SyncDefaultFormValue;
    //Verifying file order
    reversedOrder := VerifyOrder(newAfs);
    CreateIdx(newAfs, newIdx, newSrf, reversedOrder);

    if not Terminated then begin
      SyncCurrentTask('Saving new IDX...');
      newIdx.SaveToFile(fNewIdxName);
    end;
  end
  else begin
    ErrorRaised := True;
    Terminate;
  end;

  newAfs.Free;
  newIdx.Free;
  newSrf.Free;
end;

procedure TIdxCreation.CreateIdx(var AfsStruct: TAfsStruct;
var IdxStruct: TIdxStruct; var SrfStruct: TSrfStruct; const Reversed: Boolean);
var
  idxEntry: TIdxEntry;
  afsEntry: TAfsEntry;
  i, j, srfNum, subCount, subOffset, startFile, endFile: Integer;
  strBuf: String;
begin
  //Default value
  startFile := 0;
  if Reversed then begin
    Inc(startFile);
  end;

  endFile := -1;
  srfNum := 0;
  subCount := 0;

  //Adding entry until a SRF is found
  for i := 0 to AfsStruct.Count - 1 do begin
    if Terminated then begin
      Break;
    end;

    //Verifying if it's a SRF
    afsEntry := AfsStruct.Items[i];
    strBuf := ExtractFileExt(afsEntry.FileName);
    if LowerCase(strBuf) <> '.srf' then begin
      //Adding a new entry to the IDX
      SyncCurrentTask('Adding IDX entry... file #'+IntToStr(i));
      idxEntry := TIdxEntry.Create;
      idxEntry.Name := DeleteSubStr(afsEntry.FileName, ExtractFileExt(afsEntry.FileName));
      idxEntry.FileNumber := i;

      idxEntry.LinkedSrf := 0;
      idxEntry.SubOffset := 0;
      if not Reversed then begin
        Inc(endFile);
      end
      else begin
        if not subCount > SrfStruct.Count then begin
          idxEntry.LinkedSrf := srfNum;
          idxEntry.SubOffset := SrfStruct.Items[subCount].Offset;
          Inc(subCount);
        end
        else begin
          ErrorRaised := True;
          Terminate;
        end;
      end;

      IdxStruct.Add(idxEntry);
    end
    else begin
      SrfStruct.LoadFromFile(fModAfsName, afsEntry.Offset, afsEntry.Size);
      IdxStruct.SrfCount := IdxStruct.SrfCount + 1;
      SyncCurrentTask('Parsing SRF... file #'+IntToStr(i));

      //Parsing SRF to find subtitles offset
      if not Reversed then begin
        for j := startFile to endFile do begin
          //Modifying IDX entry
          idxEntry := IdxStruct.Items[j];
          idxEntry.LinkedSrf := i;
          subOffset := SrfStruct.Items[j-startFile].Offset;
          idxEntry.SubOffset := subOffset;
        end;
        startFile := i+1;
      end
      else begin
        srfNum := i;
        subCount := 0;
      end;
    end;
    SyncPercentage;
  end;
end;

function TIdxCreation.VerifyOrder(var AfsStruct: TAfsStruct): Boolean;
var
  strBuf: String;
begin
  Result := False;
  strBuf := ExtractFileExt(AfsStruct.Items[0].FileName);
  if LowerCase(strBuf) = '.srf' then begin
    Result := True;
  end;
end;

function TIdxCreation.DeleteSubStr(Str, SubStr: String): String;
begin
  if Pos(SubStr, Str) <> 0 then begin
    Delete(Str, Pos(SubStr, Str), Length(SubStr));
    Result := Str;
  end
  else begin
    Result := Str;
  end;
end;

procedure TIdxCreation.SyncPercentage;
begin
  Synchronize(UpdatePercentage);
end;

procedure TIdxCreation.SyncCurrentTask(const Task: string);
begin
  fCurrentTask := Task;
  Synchronize(UpdateCurrentTask);
end;

procedure TIdxCreation.SyncDefaultFormValue;
begin
  Synchronize(UpdateDefaultFormValue);
end;

procedure TIdxCreation.UpdatePercentage;
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

procedure TIdxCreation.UpdateCurrentTask;
begin
  fProgressWindow.lblCurrentTask.Caption := 'Current task: '+fCurrentTask;
end;

procedure TIdxCreation.UpdateDefaultFormValue;
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

procedure TIdxCreation.CancelBtnClick(Sender: TObject);
begin
  Terminate;
end;

procedure TIdxCreation.CloseThread(Sender: TObject);
begin
  if Assigned(fProgressWindow) then begin
    fProgressWindow.Release;
  end;
  ThreadTerminated := True;
end;

end.
