program Explorer;

{$R 'about\credits.res' 'about\credits.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  appver in '..\..\Common\appver.pas',
  systools in '..\..\Common\systools.pas',
  uitools in '..\..\Common\uitools.pas',
  workdir in '..\..\Common\workdir.pas',
  debuglog in '..\..\Common\DebugLog\debuglog.pas' {frmDebugLog},
  xmlconf in '..\..\Common\xmlconf.pas',
  config in 'config.pas',
  about in '..\..\Common\About\about.pas' {frmAbout},
  bugsmgr in '..\..\Common\BugsMan\bugsmgr.pas' {frmBugsHandler},
  fsparser in '..\..\Common\fsparser.pas',
  sectexpl in 'engine\sectexpl.pas',
  hashidx in '..\..\Common\hashidx.pas',
  sectutil in 'engine\sectutil.pas';

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
  Application.Title := 'Shenmue Sections Explorer';
  InitConfiguration;

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



