program fontutil;

uses
  Forms,
  main in 'main.pas' {frmMain},
  fontmgr in 'engine\fontmgr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Shenmue Font Utility';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
