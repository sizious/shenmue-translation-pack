program mteditor;

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
  seldir in 'seldir.pas' {frmSelectDir};

{$R *.res}

{$IFDEF DEBUG}
var
  AppTitle: string;
{$ENDIF}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Textured Model Objects Editor';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProgress, frmProgress);
  Application.CreateForm(TfrmSelectDir, frmSelectDir);
  {$IFDEF DEBUG}
  AppTitle := TApplication(Application).Title; // FIX for Delphi IDE...
  ReportMemoryLeaksOnShutdown := True;
  if AllocConsole then
    SetConsoleTitle(PChar(AppTitle + ' :: DEBUG CONSOLE'));
  {$ENDIF}

  Application.Run;

  {$IFDEF DEBUG}FreeConsole;{$ENDIF}
end.
