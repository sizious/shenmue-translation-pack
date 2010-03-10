program vmulcded;

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
  utils in 'utils.pas';

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
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmPreview, frmPreview);
  {$IFDEF DEBUG}
  // Debug
  AppTitle := TApplication(Application).Title; // CodeGear IDE Workaround...
  if ConsoleCreated then SetConsoleTitle(PChar(AppTitle + ' :: DEBUG CONSOLE'));
{$ENDIF}

  Application.Run;

{$IFDEF DEBUG}
  FreeConsole;
{$ENDIF}
end.
