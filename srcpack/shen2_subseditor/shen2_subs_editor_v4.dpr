program shen2_subs_editor_v4;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  variables in 'variables.pas',
  USRFEntry in 'USRFEntry.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Shenmue II Subtitles Editor v4.1';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
