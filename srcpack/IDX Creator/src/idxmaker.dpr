program idxmaker;

{$APPTYPE CONSOLE}

{$R 'idxmaker.res' 'idxmaker.rc'}

uses
  SysUtils,
  s2idx_intf in 'engine\s2idx_intf.pas',
  s2idx in 'engine\s2idx.pas';

const
  APP_VERSION = '1.0';
  
procedure PrintUsage;
begin
  WriteLn(
    'This''s the console version of Manic''s IDX Creator.', #13#10,
    'ONLY SHENMUE II IS SUPPORTED NOW.', #13#10#13#10,
    'Usage:', #13#10,
    '  ', ExtractFileName(ChangeFileExt(ParamStr(0), '')), ' <modified.afs> <output.idx>'
  );
end;

begin
  try

  WriteLn('IDXMAKER - v' + APP_VERSION + ' - (C)reated by [big_fury]SiZiOUS');
  WriteLn('http://shenmuesubs.sourceforge.net/',#13#10);

  if ParamCount < 2 then begin
    PrintUsage;
    Halt(1);
  end;

  CreateShenmue2Idx(ParamStr(1), ParamStr(2));

  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
