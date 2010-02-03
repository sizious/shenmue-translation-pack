program sfqsubed;

{$R '..\..\..\Shenmue Subtitles Preview\src\font.res' '..\..\..\Shenmue Subtitles Preview\src\font.rc'}
{$R 'engine\npcpakf\pakfbin.res' 'engine\npcpakf\pakfbin.rc'}
{$R 'engine\lzmabin.res' 'engine\lzmabin.rc'}

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
  multitrad in 'engine\multitrd\multitrad.pas',
  fileinfo in 'fileinfo.pas' {frmFileInfo},
  fileslst in 'engine\fileslst.pas',
  massimp in 'massimp.pas' {frmMassImport},
  subsexp in 'engine\batch\subsexp.pas',
  npcinfo in 'engine\npcinfo.pas',
  subsimp in 'engine\batch\subsimp.pas',
  common in 'engine\common.pas',
  warning in 'warning.pas' {frmWarning},
  vistaui in 'vistaui.pas',
  viewer_intf in '..\..\..\Shenmue Subtitles Preview\src\viewer_intf.pas',
  oldskool_font_mapper in '..\..\..\Shenmue Subtitles Preview\src\oldskool_font_mapper.pas',
  oldskool_font_vcl in '..\..\..\Shenmue Subtitles Preview\src\oldskool_font_vcl.pas',
  viewer in '..\..\..\Shenmue Subtitles Preview\src\viewer.pas' {frmSubsPreview},
  textdata in 'engine\multitrd\textdata.pas',
  about in 'about.pas' {frmAbout},
  viewupd in 'engine\multitrd\ui\viewupd.pas',
  pakfexec in 'engine\npcpakf\pakfexec.pas',
  pakfextr in 'engine\npcpakf\pakfextr.pas',
  pakfutil in 'engine\npcpakf\pakfutil.pas',
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
  npcsid in 'engine\npcpakf\npcsid.pas';

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
