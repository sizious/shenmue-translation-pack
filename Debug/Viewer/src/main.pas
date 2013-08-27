unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Viewer;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    fDatasDirectory: TFileName;
    { Déclarations privées }
    procedure PreviewerClosedEvent(Sender: TObject);
  public
    { Déclarations publiques }
    property DatasDirectory: TFileName
      read fDatasDirectory write fDatasDirectory;
  end;

var
  Form1: TForm1;
  Previewer: TSubtitlesPreviewer;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Previewer.Show(Edit1.Text);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Previewer.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DatasDirectory :=
    IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'data';
  Previewer := TSubtitlesPreviewer.Create(DatasDirectory);
  Previewer.OnWindowClosed := PreviewerClosedEvent;

  // ä Ä â Â á À à Á ï Ï î Î í Í ë Ë ê Ê
  // Previewer.Show('é É è È ö Ö ô Ô ü Ü û Û ù Ù ç Ç ¡õ=@'); //¡õ é É è Ö ô ÔÜûÛùÙçÇCan
end;

procedure TForm1.PreviewerClosedEvent(Sender: TObject);
begin
  ShowMessage('Closed!');
end;

end.
