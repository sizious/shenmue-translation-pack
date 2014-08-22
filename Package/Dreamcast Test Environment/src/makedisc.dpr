program MakeDisc;



{$R 'engine\binaries.res' 'engine\binaries.rc'}
{$R 'engine\lzmabin.res' 'engine\lzmabin.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  dtecore in 'engine\dtecore.pas',
  presets in 'presets.pas' {frmPresets},
  systools in '..\..\..\Common\systools.pas',
  lzmadec in '..\..\..\Common\lzmadec.pas',
  workdir in '..\..\..\Common\workdir.pas',
  procutil in '..\..\..\Common\procutil.pas',
  uitools in '..\..\..\Common\uitools.pas',
  fastcopy in 'engine\fastcopy.pas',
  xmlconf in '..\..\..\Common\xmlconf.pas',
  config in 'config.pas';

{$R *.res}

{$IFDEF DEBUG}
var
  ConsoleCreated: Boolean;
  AppTitle: string;
{$ENDIF}

begin
{$IFDEF DEBUG}
  ConsoleCreated := AllocConsole;
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.Title := 'Shenmue Dreamcast Test Environment';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmPresets, frmPresets);
  {$IFDEF DEBUG}
  // Debug
  AppTitle := TApplication(Application).Title; // CodeGear IDE Workaround...
  if ConsoleCreated then SetConsoleTitle(PChar(AppTitle + ' :: DEBUG CONSOLE'));
{$ENDIF}

  // Run the application
  Application.Run;

{$IFDEF DEBUG}
  FreeConsole;
{$ENDIF}
end.

