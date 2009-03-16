program s2fqsube;

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  scandir in 'scandir.pas' {frmDirScan},
  seldir in 'seldir.pas' {frmSelectDir},
  multitrd in 'multitrd.pas' {frmMultiTranslation},
  scnfedit in 'engine\scnfedit.pas',
  scnfscan in 'engine\scnfscan.pas',
  scnfutil in 'engine\scnfutil.pas',
  utils in 'utils.pas',
  charscnt in 'engine\charscnt.pas',
  charsutil in 'engine\charsutil.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  AllocConsole;
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDirScan, frmDirScan);
  Application.CreateForm(TfrmSelectDir, frmSelectDir);
  Application.CreateForm(TfrmMultiTranslation, frmMultiTranslation);
  Application.Run;

  {$IFDEF DEBUG}FreeConsole;{$ENDIF}
end.
