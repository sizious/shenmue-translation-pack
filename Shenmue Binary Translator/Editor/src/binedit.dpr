program binedit;

{$R 'about\credits.res' 'about\credits.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  config in 'config.pas',
  mkxmlbin in 'engine\mkxmlbin.pas',
  xmlconf in '..\..\..\Common\xmlconf.pas',
  debuglog in '..\..\..\Common\DebugLog\debuglog.pas' {frmDebugLog},
  bugsmgr in '..\..\..\Common\BugsMan\bugsmgr.pas' {frmBugsHandler},
  systools in '..\..\..\Common\systools.pas',
  uitools in '..\..\..\Common\uitools.pas',
  about in '..\..\..\Common\About\about.pas' {frmAbout},
  filespec in '..\..\..\Common\filespec.pas';

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
  Application.Title := 'Shenmue Binary Translator';

  // Initialize the configuration engine
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
