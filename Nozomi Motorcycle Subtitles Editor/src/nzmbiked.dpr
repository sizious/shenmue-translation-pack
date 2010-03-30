program nzmbiked;

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  nbikedit in 'engine\nbikedit.pas',
  systools in '..\..\Common\systools.pas',
  uitools in '..\..\Common\uitools.pas',
  datadefs in 'engine\datadefs.pas',
  fsparser in '..\..\Common\fsparser.pas',
  chrcodec in '..\..\Common\ChrTools\chrcodec.pas',
  debuglog in '..\..\Common\DebugLog\debuglog.pas' {frmDebugLog},
  xmlconf in '..\..\Common\xmlconf.pas',
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
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Shenmue Nozomi Motorcycle Subtitles Editor';
  InitConfigurationFile;

  Application.CreateForm(TfrmMain, frmMain);

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
