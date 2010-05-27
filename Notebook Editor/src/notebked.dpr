program notebked;

{$R 'about\credits.res' 'about\credits.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  memoedit in 'engine\memoedit.pas',
  fsparser in '..\..\Common\fsparser.pas',
  strdeps in 'engine\strdeps.pas',
  uitools in '..\..\Common\uitools.pas',
  systools in '..\..\Common\systools.pas',
  chrutils in '..\..\Common\SubsUtil\chrutils.pas',
  common in 'common.pas',
  hashidx in '..\..\Common\hashidx.pas',
  filesel in 'filesel.pas' {frmFileSelection},
  debuglog in '..\..\Common\DebugLog\debuglog.pas' {frmDebugLog},
  bugsmgr in '..\..\Common\BugsMan\bugsmgr.pas' {frmBugsHandler},
  xmlconf in '..\..\Common\xmlconf.pas',
  about in '..\..\Common\About\about.pas' {frmAbout},
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
  Application.Title := 'Shenmue Notebook Editor';

  // Initialize the configuration engine
  InitConfiguration;

  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmFileSelection, frmFileSelection);
  Application.CreateForm(TfrmAbout, frmAbout);
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
