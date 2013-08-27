program scinsube;

{$R 'about\credits.res' 'about\credits.rc'}
{$R 'engine\lzmabin.res' 'engine\lzmabin.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  config in 'config.pas',
  srfedit in 'engine\srfedit.pas',
  subsexp in 'engine\subsexp.pas',
  massimp in 'massimp.pas' {frmMassImport},
  subsimp in 'engine\subsimp.pas',
  warning in 'warning.pas' {frmWarning},
  utextdb in 'engine\utextdb.pas',
  srfkeydb in 'engine\srfkeydb.pas';

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
  Application.MainFormOnTaskbar := False; // fix for the "hint" bug
  Application.Title := 'Shenmue Cinematics Subtitles Editor';
  InitConfiguration;

  // Show migration Warning
  ShowWarningOnDemand;

  // Create forms
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
