program rlzmaker;

{$R 'runtime.res' 'runtime.rc'}
{$R '..\..\Common\d7zip\d7z.res' '..\..\Common\d7zip\d7z.rc'}
{$R 'about\credits.res' 'about\credits.rc'}
{$R '..\..\Common\upx\upx.res' '..\..\Common\upx\upx.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  discauth in '..\..\Common\discauth.pas',
  libpc1 in '..\..\..\Common\Crypto\libpc1\libpc1.pas',
  libcamellia in '..\..\..\Common\Crypto\libcamellia\libcamellia.pas',
  cam_base in '..\..\..\Common\Crypto\libcamellia\src\cam_base.pas',
  MD5Api in '..\..\..\Common\MD5\MD5Api.pas',
  MD5Core in '..\..\..\Common\MD5\MD5Core.pas',
  systools in '..\..\..\Common\systools.pas',
  uitools in '..\..\..\Common\uitools.pas',
  drvutils in '..\..\..\Common\drvutils.pas',
  d7zipapi in '..\..\Common\d7zip\d7zipapi.pas',
  packer in '..\..\Common\packer.pas',
  opthbase in '..\..\Common\opthbase.pas',
  workdir in '..\..\..\Common\workdir.pas',
  Base64 in '..\..\..\Common\Crypto\Base64.pas',
  common in '..\..\Common\common.pas',
  fileslst in '..\..\..\Common\fileslst.pas',
  about in '..\..\..\Common\About\about.pas' {frmAbout},
  appver in '..\..\..\Common\appver.pas',
  xmlconf in '..\..\..\Common\xmlconf.pas',
  config in 'config.pas',
  upxlib in '..\..\Common\upx\upxlib.pas',
  hashidx in '..\..\..\Common\hashidx.pas';

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
  Application.Title := 'Shenmue Release Maker';
  Application.CreateForm(TfrmMain, frmMain);
  {$IFDEF DEBUG}
  AppTitle := TApplication(Application).Title; // CodeGear IDE Workaround...
  if ConsoleCreated then
    SetConsoleTitle(PChar(AppTitle + ' :: DEBUG CONSOLE'));
{$ENDIF}

  Application.Run;

{$IFDEF DEBUG}
  if ConsoleCreated then
    FreeConsole;
{$ENDIF}
end.

