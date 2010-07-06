program scinsube;

{$R 'about\credits.res' 'about\credits.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  systools in '..\..\Common\systools.pas',
  uitools in '..\..\Common\uitools.pas',
  fsparser in '..\..\Common\fsparser.pas',
  debuglog in '..\..\Common\DebugLog\debuglog.pas' {frmDebugLog},
  xmlconf in '..\..\Common\xmlconf.pas',
  config in 'config.pas',
  bugsmgr in '..\..\Common\BugsMan\bugsmgr.pas' {frmBugsHandler},
  imgtools in '..\..\Common\imgtools.pas',
  oldskool_font_mapper in '..\..\Common\SubsUtil\Preview\oldskool_font_mapper.pas',
  oldskool_font_vcl in '..\..\Common\SubsUtil\Preview\oldskool_font_vcl.pas',
  viewer in '..\..\Common\SubsUtil\Preview\viewer.pas' {frmSubsPreview},
  about in '..\..\Common\About\about.pas' {frmAbout},
  chrcodec in '..\..\Common\SubsUtil\chrcodec.pas',
  chrcount in '..\..\Common\SubsUtil\chrcount.pas',
  srfedit in 'engine\srfedit.pas';

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
  Application.Title := 'Shenmue AiO Cinematics Subtitles Editor';
  InitConfiguration;

  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAbout, frmAbout);
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
