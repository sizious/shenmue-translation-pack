program IPACEdit;

{$R 'engine\gzipbin.res' 'engine\gzipbin.rc'}
{$R 'about\credits.res' 'about\credits.rc'}
{$R 'shicons.res' 'shicons.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  ipacmgr in 'engine\ipacmgr.pas',
  ipacutil in 'engine\ipacutil.pas',
  utils in 'utils.pas',
  fileprop in 'fileprop.pas' {frmProperties},
  shell in 'shell.pas',
  systools in '..\..\..\Common\systools.pas',
  xmlconf in '..\..\..\Common\xmlconf.pas',
  uitools in '..\..\..\Common\uitools.pas',
  debuglog in '..\..\..\Common\DebugLog\debuglog.pas' {frmDebugLog},
  bugsmgr in '..\..\..\Common\BugsMan\bugsmgr.pas' {frmBugsHandler},
  gzipmgr in '..\..\..\Common\gzipmgr.pas',
  about in '..\..\..\Common\About\about.pas' {frmAbout},
  regshell in '..\..\..\Common\ShellExt\regshell.pas',
  shellext in '..\..\..\Common\ShellExt\shellext.pas',
  appver in '..\..\..\Common\appver.pas';

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
  if ConsoleCreated then
    SetConsoleTitle(PChar(AppTitle + ' :: DEBUG CONSOLE'));
{$ENDIF}

  // Load the file passed in parameter if we have any
  if ParamCount > 0 then
    frmMain.LoadFile(ParamStr(1));

  // Run the application
  Application.Run;

{$IFDEF DEBUG}
  if ConsoleCreated then
    FreeConsole;
{$ENDIF}
end.
