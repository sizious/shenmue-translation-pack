program convert;

{$APPTYPE CONSOLE}

{$R 'version.res' 'version.rc'}

uses
  Windows,
  ActiveX,
  SysUtils,
  Classes,
  utils in 'utils.pas',
  old_scnfutil in 'engine\old_scnfutil.pas',
  old_charsutil in 'engine\old_charsutil.pas',
  old_scnfedit in 'engine\old_scnfedit.pas';

const
  APP_VERSION = '1.0';

var
  ExportOK, OverWrite: Boolean;
  ED: TSCNFEditor;
  Buf, Input, Output: TFileName;

begin
  CoInitialize(nil);

  WriteLn(
    'Shenmue II Free Quest Subtitles Editor v1.xx to v1.02+ Exporter', #13#10,
    'Version v', APP_VERSION, ' - (C)reated by [big_fury]SiZiOUS', #13#10,
    'http://shenmuesubs.sourceforge.net/', #13#10
  );

  // Not enough parameters
  if ParamCount < 1 then begin
    PrintUsage;
    Halt(1);
  end;

  // Retreive command parameter
  Buf := LowerCase(ParamStr(1));

  // Print help
  if (Buf = '/h') or (Buf = '-h') or (Buf = '--help') or (Buf = '/help') or
    (Buf = '-help') then begin
    PrintUsage;
    Halt(1);
  end;

  // Print "Why this proggy ?" screen
  if (Buf = '/w') or (Buf = '-w') or (Buf = '--why') or (Buf = '/why') or
    (Buf = '-why') then begin
    PrintWhy;
    Halt(1);
  end;

  // Print "Why this proggy ?" screen
  if (Buf = '/v') or (Buf = '-v') or (Buf = '--version') or (Buf = '/version') or
    (Buf = '-version') then begin
    WriteLn('This screen prints out the engine version used on this converter.', #13#10,#13#10,
      'Engine version : ', SCNF_EDITOR_ENGINE_VERSION, #13#10,
      'Engine date    : ', SCNF_EDITOR_ENGINE_COMPIL_DATE_TIME, #13#10, #13#10,
      'Yes, this''is a messed up engine version ! Please don''t work with applications',#13#10,
      'using it anymore!'
    );
    Halt(1);
  end;

  // Option not recognized !
  if not ((Buf = '/e') or (Buf = '-e') or (Buf = '--extract') or (Buf = '/extract') or
    (Buf = '-extract')) then begin
    WriteLn(Buf, ': Unknow command !',
    #13#10, 'Check the help by entering the -h command.');
    Halt(5);
  end;

  // ---------------------------------------------------------------------------
  // RUNNING EXTRACTION FROM MESSED UP PAKS !
  // ---------------------------------------------------------------------------

  if ParamCount < 2 then begin
    WriteLn('Extract command need an [old_npc.pks] argument.'
    ,#13#10, 'Check the help by entering the -h command.');
    Halt(6);
  end;

  // Check input exists
  Input := ParamStr(2);
  if not FileExists(ExpandFileName(Input)) then begin
    WriteLn('[!] "', Input, '": Messed up PAKS file not found !');
    ExitCode := 2;
    Exit;
  end;
  Input := ExpandFileName(Input);

  // Overwrite ?
  Buf := LowerCase(ParamStr(ParamCount)); // last parameter
  OverWrite := (Buf = '-o') or (Buf = '/o') or (Buf = '/overwrite')
    or (Buf = '--overwrite') or (Buf = '-overwrite');

  // For the output
  Output := ChangeFileExt(Input, ApplyCase('.xml', ExtractFileExt(Input)));
  if (ParamStr(3) <> '') then begin
    if (OverWrite and (ParamStr(3) <> '-o')) then
      Output := ParamStr(3);
  end;


  if FileExists(Output) and not (OverWrite) then begin
    WriteLn('[!] "',
      ExtractFileName(Output), '": Output file exists.', #13#10,
      'Enable the "-o" switch if you want to overwrite!'
    );
    Halt(2);
  end;

  // Begin conversion
  ED := TSCNFEditor.Create;
  try
    try
      ED.LoadFromFile(Input);
      ED.ExportSubtitlesToFile(Output);
      ExportOK := FileExists(Output);

      if ExportOK then
        WriteLn('[i] "', ExtractFileName(Input), '": Subtitles extraction OK!')
      else begin
        WriteLn('[!] "', ExtractFileName(Input), '": Unable to extract subtitles !');
        ExitCode := 4;
      end;

    except
      WriteLn('[!] ', ExtractFileName(Input), ': Unable to extract subtitles !');
      ExitCode := 3;
    end;

  finally
    ED.Free;
  end;

  CoUninitialize;
end.
