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
  srfkeydb in 'engine\srfkeydb.pas',
  fileslst in '..\..\..\Common\fileslst.pas',
  hashidx in '..\..\..\Common\hashidx.pas',
  chrcodec in '..\..\..\Common\SubsUtil\chrcodec.pas',
  systools in '..\..\..\Common\systools.pas',
  filespec in '..\..\..\Common\filespec.pas',
  lzmadec in '..\..\..\Common\lzmadec.pas',
  workdir in '..\..\..\Common\workdir.pas',
  MD5Api in '..\..\..\Common\MD5\MD5Api.pas',
  MD5Core in '..\..\..\Common\MD5\MD5Core.pas',
  oldskool_font_mapper in '..\..\..\Common\SubsUtil\Preview\oldskool_font_mapper.pas',
  oldskool_font_vcl in '..\..\..\Common\SubsUtil\Preview\oldskool_font_vcl.pas',
  viewer in '..\..\..\Common\SubsUtil\Preview\viewer.pas' {frmSubsPreview},
  bugsmgr in '..\..\..\Common\BugsMan\bugsmgr.pas' {frmBugsHandler},
  debuglog in '..\..\..\Common\DebugLog\debuglog.pas' {frmDebugLog},
  xmlconf in '..\..\..\Common\xmlconf.pas',
  dbindex in '..\..\..\Common\TextDB\dbindex.pas',
  dbinlay in '..\..\..\Common\TextDB\dbinlay.pas',
  textdb in '..\..\..\Common\TextDB\textdb.pas',
  appver in '..\..\..\Common\appver.pas',
  batchexe in '..\..\..\Common\batchexe.pas',
  uitools in '..\..\..\Common\uitools.pas',
  progress in '..\..\..\Common\Progress\progress.pas' {ProgressWindow},
  dirscan in '..\..\..\Common\DirScan\dirscan.pas' {DirectoryScannerQueryWindow},
  about in '..\..\..\Common\About\about.pas' {frmAbout},
  chrcount in '..\..\..\Common\SubsUtil\chrcount.pas';

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
