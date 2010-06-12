program sfqsubed;

{$R 'engine\lzmabin.res' 'engine\lzmabin.rc'}
{$R 'engine\npc\pakf\pakfbin.res' 'engine\npc\pakf\pakfbin.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  progress in 'progress.pas' {frmProgress},
  seldir in 'seldir.pas' {frmSelectDir},
  scnfedit in 'engine\scnfedit.pas',
  scnfscan in 'engine\scnfscan.pas',
  scnfutil in 'engine\scnfutil.pas',
  utils in 'utils.pas',
  charscnt in 'engine\charscnt.pas',
  charslst in 'engine\charslst.pas',
  multiscan in 'engine\multitrd\multiscan.pas',
  fileinfo in 'fileinfo.pas' {frmFileInfo},
  fileslst in 'engine\fileslst.pas',
  massimp in 'massimp.pas' {frmMassImport},
  subsexp in 'engine\batch\subsexp.pas',
  subsimp in 'engine\batch\subsimp.pas',
  common in 'engine\common.pas',
  warning in 'warning.pas' {frmWarning},
  vistaui in 'vistaui.pas',
  textdata in 'engine\multitrd\textdata.pas',
  about in 'about.pas' {frmAbout},
  viewupd in 'engine\multitrd\ui\viewupd.pas',
  facesext in 'facesext.pas' {frmFacesExtractor},
  iconsui in 'engine\multitrd\ui\iconsui.pas',
  multitrd in 'multitrd\multitrd.pas' {frmMultiTranslation},
  mtexec in 'multitrd\mtexec.pas',
  systools in '..\..\..\Common\systools.pas',
  textdb in 'engine\textdb\textdb.pas',
  dbindex in 'engine\textdb\dbindex.pas',
  dbinlay in 'engine\textdb\dbinlay.pas',
  bugsmgr in 'bugsmgr.pas' {frmBugsHandler},
  img2png in '..\..\..\Common\img2png.pas',
  lzmadec in '..\..\..\Common\lzmadec.pas',
  dblzma in 'engine\textdb\dblzma.pas',
  npcinfo in 'engine\npc\npcinfo.pas',
  pakfexec in 'engine\npc\pakf\pakfexec.pas',
  pakfextr in 'engine\npc\pakf\pakfextr.pas',
  pakfutil in 'engine\npc\pakf\pakfutil.pas',
  npclist in 'engine\npc\npclist.pas',
  imgtools in '..\..\..\Common\imgtools.pas',
  pakfmgr in 'engine\npc\pakf\pakfmgr.pas',
  uitools in '..\..\..\Common\uitools.pas',
  oldskool_font_mapper in '..\..\..\Common\SubsUtil\Preview\oldskool_font_mapper.pas',
  oldskool_font_vcl in '..\..\..\Common\SubsUtil\Preview\oldskool_font_vcl.pas',
  viewer in '..\..\..\Common\SubsUtil\Preview\viewer.pas' {frmSubsPreview},
  hashidx in '..\..\..\Common\hashidx.pas',
  srfdb in 'engine\srfdb.pas',
  srfscript in 'srfscript.pas' {frmCinematicsScript},
  batchsrf in 'engine\batch\batchsrf.pas';

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
  Application.Title := 'Shenmue AiO Free Quest Subtitles Editor';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProgress, frmProgress);
  Application.CreateForm(TfrmSelectDir, frmSelectDir);
  Application.CreateForm(TfrmFileInfo, frmFileInfo);
  Application.CreateForm(TfrmCinematicsScript, frmCinematicsScript);
  {$IFDEF DEBUG}
  AppTitle := TApplication(Application).Title; // CodeGear IDE Workaround...
  if ConsoleCreated then SetConsoleTitle(PChar(AppTitle + ' :: DEBUG CONSOLE'));
{$ENDIF}

  // Show migration Warning
  ShowWarningIfNeeded;

  Application.Run;

{$IFDEF DEBUG}
  FreeConsole;
{$ENDIF}
end.
