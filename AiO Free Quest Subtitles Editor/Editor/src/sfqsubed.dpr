program sfqsubed;

{$R '..\..\..\Shenmue Subtitles Preview\src\font.res' '..\..\..\Shenmue Subtitles Preview\src\font.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  progress in 'progress.pas' {frmProgress},
  seldir in 'seldir.pas' {frmSelectDir},
  multitrd in 'multitrd.pas' {frmMultiTranslation},
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
  viewer in '..\..\..\Shenmue Subtitles Preview\src\viewer.pas' {frmSubsPreview};

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
  Application.CreateForm(TfrmMultiTranslation, frmMultiTranslation);
  Application.CreateForm(TfrmFileInfo, frmFileInfo);
  Application.CreateForm(TfrmMassImport, frmMassImport);
  {$IFDEF DEBUG}
  AppTitle := TApplication(Application).Title; // CodeGear IDE Workaround...
  if ConsoleCreated then SetConsoleTitle(PChar(AppTitle + ' :: DEBUG CONSOLE'));
  {$ENDIF}

  // Show migration Warning
  ShowWarningIfNeeded;

  Application.Run;

  {$IFDEF DEBUG}FreeConsole;{$ENDIF}
end.
