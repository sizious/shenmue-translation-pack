//    This file is part of IDX Creator.
//
//    You should have received a copy of the GNU General Public License
//    along with IDX Creator.  If not, see <http://www.gnu.org/licenses/>.

unit s2idx_intf;

interface

uses
  Windows, SysUtils;
  
function CreateShenmue2Idx(const ModifiedAFS, OutputIDX: string): Boolean;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  {$IFNDEF APPTYPE_CONSOLE}Main, Forms, Math, progress, {$ENDIF} s2idx;


//------------------------------------------------------------------------------

{$IFNDEF APPTYPE_CONSOLE}

var
  fProgressWindow: TfrmProgress;

procedure S2IDX_OnStart(const MaxFiles: Integer);
begin
  fProgressWindow := TfrmProgress.Create(nil);

  //Setting progress form main value
  fProgressWindow.Caption := 'Creation in progress... ';
  fProgressWindow.lblCurrentTask.Caption := 'Current task:';
  fProgressWindow.Position := poMainFormCenter;
  fProgressWindow.ProgressBar1.Max := MaxFiles;
  fProgressWindow.btCancel.Enabled := False;
  fProgressWindow.Panel1.Caption := '0%';
  fProgressWindow.Show;
end;

procedure S2IDX_OnStatus(const Message: string);
begin
  frmMain.StatusChange(Message);
end;

procedure S2IDX_OnProgress();
var
  i: Integer;
  floatBuf: Real;
  
begin
  i := fProgressWindow.ProgressBar1.Position;
  fProgressWindow.ProgressBar1.Position := i+1;
  floatBuf := SimpleRoundTo((100*(i+1))/fProgressWindow.ProgressBar1.Max, -2);
  fProgressWindow.Panel1.Caption := FloatToStr(floatBuf)+'%';
  Application.ProcessMessages;
end;

procedure S2IDX_OnCompleted();
begin
  if Assigned(fProgressWindow) then
    fProgressWindow.Release;
end;

{$ELSE}

procedure S2IDX_OnStart(const MaxFiles: Integer);
begin

end;

procedure S2IDX_OnStatus(const Message: string);
begin
  WriteLn('[i] ', Message);
end;

procedure S2IDX_OnProgress();
begin

end;

procedure S2IDX_OnCompleted();
begin
  
end;

{$ENDIF}

//------------------------------------------------------------------------------

function CreateShenmue2Idx(const ModifiedAFS, OutputIDX: string): Boolean;
var
  S2IDXCreator: TS2IDXCreator;
  
begin
  Result := False;
  S2IDXCreator := TS2IDXCreator.Create;
  try
    S2IDXCreator.OnStart := S2IDX_OnStart;
    S2IDXCreator.OnStatus := S2IDX_OnStatus;
    S2IDXCreator.OnProgress := S2IDX_OnProgress;
    S2IDXCreator.OnCompleted := S2IDX_OnCompleted;
    try
      Result := S2IDXCreator.MakeIDX(ModifiedAFS, OutputIDX);
    except
      Result := False;
    end;
  finally
    S2IDXCreator.Free;
    if not Result then if FileExists(OutputIDX) then DeleteFile(OutputIDX);    
  end;
end;

//------------------------------------------------------------------------------

end.
