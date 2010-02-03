program hdissect;

uses
  Forms,
  main in 'main.pas' {Form1},
  config in 'config.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'HUMANS Dissecter';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
