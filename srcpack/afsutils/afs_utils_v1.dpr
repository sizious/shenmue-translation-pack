program afs_utils_v1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  variables in 'variables.pas',
  Unit3 in 'Unit3.pas' {blocksize_form};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'AFS Utils v1.1';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(Tblocksize_form, blocksize_form);
  Application.Run;
end.
