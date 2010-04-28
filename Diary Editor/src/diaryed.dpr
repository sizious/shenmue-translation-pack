program diaryed;

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  memoedit in 'engine\memoedit.pas',
  fsparser in '..\..\Common\fsparser.pas',
  strdeps in 'engine\strdeps.pas',
  uitools in '..\..\Common\uitools.pas',
  systools in '..\..\Common\systools.pas',
  common in 'engine\common.pas',
  chrutils in '..\..\Common\SubsUtil\chrutils.pas';

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
  Application.Title := 'Shenmue Diary Editor';
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
