program vmulcded;

{$R 'about\credits.res' 'about\credits.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  lcdedit in 'engine\lcdedit.pas',
  systools in '..\..\Common\systools.pas',
  debuglog in '..\..\Common\DebugLog\debuglog.pas' {frmDebugLog},
  xmlconf in '..\..\Common\xmlconf.pas',
  preview in 'preview.pas' {frmPreview},
  uitools in '..\..\Common\uitools.pas',
  utils in 'utils.pas',
  about in '..\..\Common\About\about.pas' {frmAbout},
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
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Shenmue VMU Screen Editor';
  InitConfigurationFile;
  
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmPreview, frmPreview);
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
