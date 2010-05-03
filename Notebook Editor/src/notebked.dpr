program notebked;

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  memoedit in 'engine\memoedit.pas',
  fsparser in '..\..\Common\fsparser.pas',
  strdeps in 'engine\strdeps.pas',
  uitools in '..\..\Common\uitools.pas',
  systools in '..\..\Common\systools.pas',
  chrutils in '..\..\Common\SubsUtil\chrutils.pas',
  common in 'common.pas',
  hashidx in '..\..\Common\hashidx.pas',
  filesel in 'filesel.pas' {frmFileSelection};

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
  Application.Title := 'Shenmue Notebook Editor';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmFileSelection, frmFileSelection);
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
