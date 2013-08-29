program dctstenv;



{$R 'engine\binaries.res' 'engine\binaries.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  makedisc in 'engine\makedisc.pas',
  presets in 'presets.pas' {frmPresets},
  config in 'config.pas' {frmConfig};

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
  Application.Title := 'Shenmue Dreamcast Test Environment';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmPresets, frmPresets);
  Application.CreateForm(TfrmConfig, frmConfig);
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

