program rlzmaker;

{$R 'runtime.res' 'runtime.rc'}
{$R '..\..\Common\d7zip\d7z.res' '..\..\Common\d7zip\d7z.rc'}
{$R 'about\credits.res' 'about\credits.rc'}
{$R '..\..\Common\upx\upx.res' '..\..\Common\upx\upx.rc'}
{$R 'deficon.res' 'deficon.rc'}
{$R 'fakepack.res' 'fakepack.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  discauth in '..\..\Common\discauth.pas',
  d7zipapi in '..\..\Common\d7zip\d7zipapi.pas',
  packer in '..\..\Common\packer.pas',
  opthbase in '..\..\Common\opthbase.pas',
  common in '..\..\Common\common.pas',
  config in 'config.pas',
  upxlib in '..\..\Common\upx\upxlib.pas',
  drvutils in '..\..\..\..\Common\drvutils.pas',
  MD5Api in '..\..\..\..\Common\MD5\MD5Api.pas',
  MD5Core in '..\..\..\..\Common\MD5\MD5Core.pas',
  libcamellia in '..\..\..\..\Common\Crypto\libcamellia\libcamellia.pas',
  libpc1 in '..\..\..\..\Common\Crypto\libpc1\libpc1.pas',
  base64 in '..\..\..\..\Common\Crypto\base64.pas',
  fileslst in '..\..\..\..\Common\fileslst.pas',
  hashidx in '..\..\..\..\Common\hashidx.pas',
  systools in '..\..\..\..\Common\systools.pas',
  cam_base in '..\..\..\..\Common\Crypto\libcamellia\src\cam_base.pas',
  workdir in '..\..\..\..\Common\workdir.pas',
  iconchng in '..\..\..\..\Common\iconchng.pas',
  uitools in '..\..\..\..\Common\uitools.pas',
  about in '..\..\..\..\Common\About\about.pas' {frmAbout},
  appver in '..\..\..\..\Common\appver.pas',
  xmlconf in '..\..\..\..\Common\xmlconf.pas';

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

