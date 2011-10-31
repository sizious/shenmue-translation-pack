program RlzUlock;

{$R '..\..\Common\d7zip\d7zlite.res' '..\..\Common\d7zip\d7zlite.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  resman in 'resman.pas',
  libpc1 in '..\..\..\Common\Crypto\libpc1\libpc1.pas',
  libcamellia in '..\..\..\Common\Crypto\libcamellia\libcamellia.pas',
  cam_base in '..\..\..\Common\Crypto\libcamellia\src\cam_base.pas',
  discauth in '..\..\Common\discauth.pas',
  MD5Api in '..\..\..\Common\MD5\MD5Api.pas',
  MD5Core in '..\..\..\Common\MD5\MD5Core.pas',
  drvutils in '..\..\..\Common\drvutils.pas',
  opthbase in '..\..\Common\opthbase.pas',
  Base64 in '..\..\..\Common\Crypto\Base64.pas',
  d7zipapi in '..\..\Common\d7zip\d7zipapi.pas',
  workdir in '..\..\..\Common\workdir.pas',
  systools in '..\..\..\Common\systools.pas',
  uitools in '..\..\..\Common\uitools.pas',
  common in '..\..\Common\common.pas',
  unpacker in '..\..\Common\unpacker.pas',
  hashidx in '..\..\..\Common\hashidx.pas',
  fileslst in '..\..\..\Common\fileslst.pas';

{$R *.res}

var
  DecompileOK: Boolean;
{$IFDEF DEBUG}
  ConsoleCreated: Boolean;
  AppTitle: string;
{$ENDIF}

begin
{$IFDEF DEBUG}
  ConsoleCreated := AllocConsole;
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}

  // Decompress every binded file to the temp directory !
  DecompileOK := DecompileRuntimePackage;
{$IFDEF DEBUG}
  WriteLn('Decompile Result : ', DecompileOK);
{$ENDIF}
{$IFDEF RELEASE}
  if not DecompileOK then
  begin
    MessageBoxA(0, 'Package is corrupted!', 'Error', MB_ICONERROR);
    Halt(0);
  end;
{$ENDIF}

  // Init VCL application...
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Shenmue Release Unlocker';
  Application.CreateForm(TfrmMain, frmMain);
  {$IFDEF DEBUG}
  AppTitle := TApplication(Application).Title; // CodeGear IDE Workaround...
  if ConsoleCreated then
    SetConsoleTitle(PChar(AppTitle + ' :: DEBUG CONSOLE'));
{$ENDIF}

  // Run the application !
  Application.Run;

{$IFDEF DEBUG}
  if ConsoleCreated then
    FreeConsole;
{$ENDIF}
end.
