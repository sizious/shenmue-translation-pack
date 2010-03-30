//    This file is part of IDX Maker.
//
//    You should have received a copy of the GNU General Public License
//    along with IDX Maker.  If not, see <http://www.gnu.org/licenses/>.

program idxmaker;

{$APPTYPE CONSOLE}

{$R 'idxmaker.res' 'idxmaker.rc'}

uses
  SysUtils,
  s2idx_intf in 'engine\s2idx_intf.pas',
  s2idx in 'engine\s2idx.pas',
  UIdxTemplateCreation in 'engine\UIdxTemplateCreation.pas',
  USrfStruct in 'engine\USrfStruct.pas',
  UAfsStruct in 'engine\UAfsStruct.pas',
  UIdxStruct in 'engine\UIdxStruct.pas',
  UIdxCreation in 'engine\UIdxCreation.pas',
  s1idx_intf in 'engine\s1idx_intf.pas',
  systools in '..\..\Common\systools.pas';

//------------------------------------------------------------------------------

const
  APP_VERSION = '1.1';

//------------------------------------------------------------------------------

procedure PrintUsage;
var
  ProgName: string;

begin
  ProgName := ExtractFileName(ChangeFileExt(ParamStr(0), ''));
  WriteLn(
    'This''s the console version of Manic''s IDX Creator.',#13#10,
    'This proggy was created to generate indexes files (IDX) from AFS for',#13#10,
    'Shenmue I and II in command line, in order to use automatized scripts.',
    #13#10,
    #13#10,
    'Usage:',
    #13#10,
    '  ', ProgName, ' <game_ver> <edited.afs> <new.idx> [template.afs] [template.idx]',
    #13#10,#13#10,
    'Game version switches: ',
    #13#10,
    '  ', '-1: Generate Shenmue I IDX',#13#10,
    '  ', '-2: Generate Shenmue II IDX',#13#10,
    #13#10,
    'Templates:',
    #13#10,
    '  ', 'Create a IDX based on [template.afs] and [template.idx] (Shenmue I only)',#13#10,
    #13#10,
    'Examples:', #13#10,
    '  ', ProgName, ' -1 SC1_TEST.AFS SC1_TEST.IDX', #13#10,
    '  ', ProgName, ' -1 MANIC_.AFS MANIC_.IDX OLD_MANIC_.AFS OLD_MANIC_.IDX',#13#10,
    '  ', ProgName, ' -2 SIZ_.AFS SIZ_.IDX'
  );
end;

//------------------------------------------------------------------------------

begin
  try

    WriteLn('IDXMAKER - v' + APP_VERSION + ' - (C)reated by [big_fury]SiZiOUS');
    WriteLn('http://shenmuesubs.sourceforge.net/',#13#10);

    if ParamCount < 3 then begin
      PrintUsage;
      Halt(1);
    end;

    // Check switches
    if (ParamStr(1) <> '-1') and (ParamStr(1) <> '-2') then begin
      WriteLn(ParamStr(1), ': Invalid switch.');
      PrintUsage;
      Halt(2);
    end;

    WriteLn('Input AFS......: ', ParamStr(2));
    WriteLn('Output IDX.....: ', ParamStr(3));

    // Go !
    if ParamStr(1) = '-1' then begin

      WriteLn('Game version...: Shenmue I');

      // Create Shenmue I IDX
      if ParamCount > 4 then begin
        WriteLn('Operation......: Updating IDX based on template');
        WriteLn('Template AFS...: ', ParamStr(4));
        WriteLn('Template IDX...: ', ParamStr(5), #13#10);

        CreateShenmue1Idx(ParamStr(2), ParamStr(3), ParamStr(4), ParamStr(5))
      end else begin
        WriteLn('Operation......: Creating new IDX', #13#10);

        CreateShenmue1Idx(ParamStr(2), ParamStr(3));
      end;

    end else begin
      // Create Shenmue II IDX
      WriteLn('Game version...: Shenmue II');
      WriteLn('Operation......: Creating new IDX',#13#10);

      if ParamCount > 4 then begin
        WriteLn('[!] TEMPLATES IS FOR SHENMUE I ONLY.');
      end;

      CreateShenmue2Idx(ParamStr(2), ParamStr(3));
    end;

  except
    on E:Exception do
      Writeln('[!] UNHANDLED EXCEPTION: ', E.Classname, ': ', E.Message);
  end;
end.
