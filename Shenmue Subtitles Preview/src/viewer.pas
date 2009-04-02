unit viewer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TfrmSubsPreview = class(TForm)
    iSub1: TImage;
    iSub2: TImage;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmSubsPreview: TfrmSubsPreview;

implementation

{$R *.dfm}

procedure TfrmSubsPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MessageBoxA(Handle, PChar(
    'Please remove the frmSubsPreview from the' +
    ' ''Form created by Delphi'' in the Project option dialog.'),
    'Exception',
    MB_ICONERROR
  );
end;

end.
