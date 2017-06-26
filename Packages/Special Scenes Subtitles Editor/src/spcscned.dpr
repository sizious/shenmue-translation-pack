program spcscned;

{$R 'about\credits.res' 'about\credits.rc'}
{$R 'engine\lzmabin.res' 'engine\lzmabin.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  seqedit in 'engine\seqedit.pas',
  config in 'config.pas',
  seqdb in 'engine\seqdb.pas',
  oldskool_font_mapper in '..\..\..\Common\SubsUtil\Preview\oldskool_font_mapper.pas',
  oldskool_font_vcl in '..\..\..\Common\SubsUtil\Preview\oldskool_font_vcl.pas',
  viewer in '..\..\..\Common\SubsUtil\Preview\viewer.pas' {frmSubsPreview},
  bugsmgr in '..\..\..\Common\BugsMan\bugsmgr.pas' {frmBugsHandler},
  debuglog in '..\..\..\Common\DebugLog\debuglog.pas' {frmDebugLog},
  xmlconf in '..\..\..\Common\xmlconf.pas',
  chrcodec in '..\..\..\Common\SubsUtil\chrcodec.pas',
  chrcount in '..\..\..\Common\SubsUtil\chrcount.pas',
  hashidx in '..\..\..\Common\hashidx.pas',
  systools in '..\..\..\Common\systools.pas',
  fsparser in '..\..\..\Common\fsparser.pas',
  filespec in '..\..\..\Common\filespec.pas',
  workdir in '..\..\..\Common\workdir.pas',
  lzmadec in '..\..\..\Common\lzmadec.pas',
  appver in '..\..\..\Common\appver.pas',
  uitools in '..\..\..\Common\uitools.pas',
  about in '..\..\..\Common\About\about.pas' {frmAbout},
  binhack in '..\..\..\Common\binhack.pas';

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
  Application.Title := 'Shenmue Special Scenes Subtitles Editor';
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
