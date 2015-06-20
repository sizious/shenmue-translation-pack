program mteditor;

{$R 'rsrc.res' 'rsrc.rc'}
{$R 'engine\imgbins.res' 'engine\imgbins.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  mtedit in 'engine\mtedit.pas',
  mtscan in 'engine\mtscan.pas',
  mtscan_intf in 'intf\mtscan_intf.pas',
  progress in 'intf\progress.pas' {frmProgress},
  fileslst in 'engine\fileslst.pas',
  seldir in 'seldir.pas' {frmSelectDir},
  texview in 'texview.pas' {frmTexPreview},
  common in 'engine\common.pas',
  tools in 'tools.pas',
  texprop in 'texprop.pas' {frmTexProp},
  about in 'about.pas' {frmAbout},
  systools in '..\..\..\Common\systools.pas',
  img2png in '..\..\..\Common\img2png.pas';

{$R *.res}

{$IFDEF DEBUG}
var
  AppTitle: string;
  AppVersion: TApplicationFileVersion;
{$ENDIF}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Shenmue Models Textures Editor';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProgress, frmProgress);
  Application.CreateForm(TfrmSelectDir, frmSelectDir);
  Application.CreateForm(TfrmTexPreview, frmTexPreview);
  Application.CreateForm(TfrmTexProp, frmTexProp);
  {$IFDEF DEBUG}
  AppTitle := TApplication(Application).Title; // FIX for Delphi IDE...
  ReportMemoryLeaksOnShutdown := True;
  if AllocConsole then begin
    SetConsoleTitle(PChar(AppTitle + ' :: DEBUG CONSOLE'));
    AppVersion := GetApplicationFileVersion;
    WriteLn('Welcome to ', AppTitle, ' !', sLineBreak,
      '  Version       : ', AppVersion.Major, '.', AppVersion.Minor, '.',
        AppVersion.Release, '.', AppVersion.Build, sLineBreak,
      '  Debug release : ', APP_VERSION_DEBUG, sLineBreak
    );
  end;
{$ENDIF}

  Application.Run;

{$IFDEF DEBUG}
  FreeConsole;
{$ENDIF}
end.
