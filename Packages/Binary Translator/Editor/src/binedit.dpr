program binedit;

{$R 'about\credits.res' 'about\credits.rc'}
{$R 'engine\lzmabin.res' 'engine\lzmabin.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  config in 'config.pas',
  mkxmlbin in 'engine\mkxmlbin.pas',
  newproj in 'newproj.pas' {frmNewProject},
  debuglog in '..\..\..\..\Common\DebugLog\debuglog.pas' {frmDebugLog},
  xmlconf in '..\..\..\..\Common\xmlconf.pas',
  bugsmgr in '..\..\..\..\Common\BugsMan\bugsmgr.pas' {frmBugsHandler},
  filespec in '..\..\..\..\Common\filespec.pas',
  systools in '..\..\..\..\Common\systools.pas',
  chrcodec in '..\..\..\..\Common\SubsUtil\chrcodec.pas',
  hashidx in '..\..\..\..\Common\hashidx.pas',
  uitools in '..\..\..\..\Common\uitools.pas',
  lzmadec in '..\..\..\..\Common\lzmadec.pas',
  about in '..\..\..\..\Common\About\about.pas' {frmAbout},
  workdir in '..\..\..\..\Common\workdir.pas',
  appver in '..\..\..\..\Common\appver.pas';

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
