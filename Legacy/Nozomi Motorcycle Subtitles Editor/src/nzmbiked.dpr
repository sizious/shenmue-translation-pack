program nzmbiked;

{$R 'about\credits.res' 'about\credits.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  nbikedit in 'engine\nbikedit.pas',
  datadefs in 'engine\datadefs.pas',
  config in 'config.pas',
  submodif in 'engine\submodif.pas',
  fsparser in '..\..\..\Common\fsparser.pas',
  systools in '..\..\..\Common\systools.pas',
  hashidx in '..\..\..\Common\hashidx.pas',
  chrcodec in '..\..\..\Common\SubsUtil\chrcodec.pas',
  chrcount in '..\..\..\Common\SubsUtil\chrcount.pas',
  oldskool_font_mapper in '..\..\..\Common\SubsUtil\Preview\oldskool_font_mapper.pas',
  oldskool_font_vcl in '..\..\..\Common\SubsUtil\Preview\oldskool_font_vcl.pas',
  viewer in '..\..\..\Common\SubsUtil\Preview\viewer.pas' {frmSubsPreview},
  debuglog in '..\..\..\Common\DebugLog\debuglog.pas' {frmDebugLog},
  bugsmgr in '..\..\..\Common\BugsMan\bugsmgr.pas' {frmBugsHandler},
  xmlconf in '..\..\..\Common\xmlconf.pas',
  uitools in '..\..\..\Common\uitools.pas',
  about in '..\..\..\Common\About\about.pas' {frmAbout},
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
  Application.Title := 'Shenmue Nozomi Motorcycle Subtitles Editor';

  // Initialize the configuration engine
  InitConfiguration;

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
