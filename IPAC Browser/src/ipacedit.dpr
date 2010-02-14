program ipacedit;

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  ipacmgr in 'engine\ipacmgr.pas',
  systools in '..\..\Common\systools.pas',
  ipacutil in 'engine\ipacutil.pas',
  gzipmgr in '..\..\Common\gzipmgr.pas';

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
  Application.Title := 'Shenmue IPAC Browser';
  Application.CreateForm(TfrmMain, frmMain);
  {$IFDEF DEBUG}
  AppTitle := TApplication(Application).Title; // CodeGear IDE Workaround...
  if ConsoleCreated then SetConsoleTitle(PChar(AppTitle + ' :: DEBUG CONSOLE'));
{$ENDIF}

  Application.Run;

{$IFDEF DEBUG}
  FreeConsole;
{$ENDIF}
end.
