program rlzulock;

{$R '..\..\Common\d7zip\d7zlite.res' '..\..\Common\d7zip\d7zlite.rc'}
{$R 'about\credits.res' 'about\credits.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  resman in 'resman.pas',
  discauth in '..\..\Common\discauth.pas',
  opthbase in '..\..\Common\opthbase.pas',
  d7zipapi in '..\..\Common\d7zip\d7zipapi.pas',
  common in '..\..\Common\common.pas',
  unpacker in '..\..\Common\unpacker.pas',
  fileslst in '..\..\..\..\Common\fileslst.pas',
  hashidx in '..\..\..\..\Common\hashidx.pas',
  systools in '..\..\..\..\Common\systools.pas',
  libpc1 in '..\..\..\..\Common\Crypto\libpc1\libpc1.pas',
  libcamellia in '..\..\..\..\Common\Crypto\libcamellia\libcamellia.pas',
  cam_base in '..\..\..\..\Common\Crypto\libcamellia\src\cam_base.pas',
  base64 in '..\..\..\..\Common\Crypto\base64.pas',
  workdir in '..\..\..\..\Common\workdir.pas',
  uitools in '..\..\..\..\Common\uitools.pas',
  drvutils in '..\..\..\..\Common\drvutils.pas',
  MD5Api in '..\..\..\..\Common\MD5\MD5Api.pas',
  MD5Core in '..\..\..\..\Common\MD5\MD5Core.pas',
  about in '..\..\..\..\Common\About\about.pas' {frmAbout},
  appver in '..\..\..\..\Common\appver.pas';

{$R *.res}

var
  DecompileOK: Boolean;
{$IFDEF DEBUG}
  ConsoleCreated: Boolean;
  AppTitle: string;
{$ENDIF}

//==============================================================================

function MsgBox(Text, Caption: string; Flags: Integer): Integer; overload;
begin
  Result := MessageBoxA(0, PChar(Text), PChar(Caption), Flags);
end;

//------------------------------------------------------------------------------

{$IFDEF DEBUG}
function MsgBox(Text: string): Integer; overload;
begin
  Result := MsgBox(Text, 'Information', MB_OK);
end;
{$ENDIF}

//==============================================================================

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
    MsgBox('Package is corrupted!', 'Error', MB_ICONERROR);
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
