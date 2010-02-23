program ipacedit;

{$R 'engine\gzipbin.res' 'engine\gzipbin.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  ipacmgr in 'engine\ipacmgr.pas',
  systools in '..\..\Common\systools.pas',
  ipacutil in 'engine\ipacutil.pas',
  gzipmgr in '..\..\Common\gzipmgr.pas',
  utils in 'utils.pas',
  debuglog in 'debuglog.pas' {frmDebugLog},
  xmlconf in '..\..\Common\xmlconf.pas',
  bugsmgr in '..\..\Common\BugsMan\bugsmgr.pas' {frmBugsHandler};

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
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDebugLog, frmDebugLog);
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
