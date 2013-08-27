//    This file is part of IDX Maker.
//
//    You should have received a copy of the GNU General Public License
//    along with IDX Maker.  If not, see <http://www.gnu.org/licenses/>.

unit s1idx_intf;

interface

uses
  Windows, SysUtils, UIdxTemplateCreation, UIdxCreation;

procedure CreateShenmue1Idx(const ModifiedAFS, OutputIDX: string); overload;
procedure CreateShenmue1Idx(const ModifiedAFS, OutputIDX, TemplateAFS, TemplateIDX: string); overload;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

function StartTemplateCreation(const ModifiedAFS, OutputIDX, TemplateAFS, TemplateIDX: string): Boolean;
var
  idxThread: TIdxTemplateCreation;

begin
  Result := False;
  idxThread := TIdxTemplateCreation.Create(OutputIDX, ModifiedAFS, TemplateIDX, TemplateAFS);
  repeat
    Sleep(10);
  until (idxThread.ThreadTerminated);

  //If no error...
  if not idxThread.ErrorRaised then begin
    Result := True;
  end;

  idxThread.Free;
end;

//------------------------------------------------------------------------------

function StartCreation(const ModifiedAFS, OutputIDX: string): Boolean;
var
  idxThread: TIdxCreation;

begin
  Result := False;
  idxThread := TIdxCreation.Create(ModifiedAFS, OutputIDX);

  repeat
    Sleep(10);
  until (idxThread.ThreadTerminated);

  if not idxThread.ErrorRaised then begin
    Result := True;
  end;

  idxThread.Free;
end;

//------------------------------------------------------------------------------

procedure CreateShenmue1Idx(const ModifiedAFS, OutputIDX: string);
begin
  CreateShenmue1Idx(ModifiedAFS, OutputIDX, '', '');
end;

//------------------------------------------------------------------------------

procedure CreateShenmue1Idx(const ModifiedAFS, OutputIDX, TemplateAFS, TemplateIDX: string);
var
  thOK: Boolean;

begin
  //Starting creation
  WriteLn('[i] Starting creation...');
  if (TemplateAFS <> '') and (TemplateIDX <> '') then begin
    thOK := StartTemplateCreation(ModifiedAFS, OutputIDX, TemplateAFS, TemplateIDX);
  end else begin
    thOK := StartCreation(ModifiedAFS, OutputIDX);
  end;

  if thOK then
    WriteLn('[i] Creation completed for '+ ExtractFileName(OutputIDX) + ' !')
  else
    WriteLn('[!] "'+ExtractFileName(ModifiedAFS) + '" is not a valid Shenmue I AFS file. IDX creation stopped...');
end;

//------------------------------------------------------------------------------

end.
