program vmulcded;

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  lcdedit in 'engine\lcdedit.pas',
  systools in '..\..\Common\systools.pas';

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
  Application.Title := 'VMU Screen Editor';
  Application.CreateForm(TfrmMain, frmMain);

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
