program ipacedit;

{$R 'engine\gzipbin.res' 'engine\gzipbin.rc'}
{$R 'about\credits.res' 'about\credits.rc'}
{$R 'shicons.res' 'shicons.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  ipacmgr in 'engine\ipacmgr.pas',
  systools in '..\..\Common\systools.pas',
  ipacutil in 'engine\ipacutil.pas',
  gzipmgr in '..\..\Common\gzipmgr.pas',
  utils in 'utils.pas',
  xmlconf in '..\..\Common\xmlconf.pas',
  bugsmgr in '..\..\Common\BugsMan\bugsmgr.pas' {frmBugsHandler},
  fileprop in 'fileprop.pas' {frmProperties},
  about in '..\..\Common\About\about.pas' {frmAbout},
  uitools in '..\..\Common\uitools.pas',
  shell in 'shell.pas',
  shellext in '..\..\Common\ShellExt\shellext.pas',
  regshell in '..\..\Common\ShellExt\regshell.pas',
  debuglog in '..\..\Common\DebugLog\debuglog.pas' {frmDebugLog};

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
  Application.Title := 'Shenmue IPAC Browser';
  InitializeShellExtension;

  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProperties, frmProperties);
  {$IFDEF DEBUG}
  // Debug
  AppTitle := TApplication(Application).Title; // CodeGear IDE Workaround...
  if ConsoleCreated then SetConsoleTitle(PChar(AppTitle + ' :: DEBUG CONSOLE'));
{$ENDIF}

  // Load the file passed in parameter if we have any
  if ParamCount > 0 then
    frmMain.LoadFile(ParamStr(1));

  // Run the application
  Application.Run;

{$IFDEF DEBUG}
  FreeConsole;
{$ENDIF}
end.
