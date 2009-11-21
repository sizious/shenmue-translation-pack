program mteditor;

{$R 'rsrc.res' 'rsrc.rc'}
{$R '..\..\Common\binaries.res' '..\..\Common\binaries.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  mtedit in 'engine\mtedit.pas',
  utils in 'engine\utils.pas',
  mtscan in 'engine\mtscan.pas',
  mtscan_intf in 'intf\mtscan_intf.pas',
  progress in 'intf\progress.pas' {frmProgress},
  fileslst in 'engine\fileslst.pas',
  seldir in 'seldir.pas' {frmSelectDir},
  texview in 'texview.pas' {frmTexPreview},
  common in 'engine\common.pas',
  img2png in '..\..\Common\img2png.pas',
  tools in 'tools.pas',
  texprop in 'texprop.pas' {frmTexProp};

{$R *.res}

{$IFDEF DEBUG}
var
  AppTitle: string;
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
  if AllocConsole then
    SetConsoleTitle(PChar(AppTitle + ' :: DEBUG CONSOLE'));
  {$ENDIF}

  Application.Run;

  {$IFDEF DEBUG}FreeConsole;{$ENDIF}
end.
