//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit seldir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, JvBaseDlg, JvBrowseFolder;

type
  TfrmSelectDir = class(TForm)
    GroupBox1: TGroupBox;
    eDirectory: TEdit;
    bBrowse: TButton;
    bOK: TButton;
    bCancel: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    JvBrowseForFolderDialog: TJvBrowseForFolderDialog;
    procedure bBrowseClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
    function Execute(const DefaultDirectory: TFileName): Boolean;
    function GetSelectedDirectory: string;
  end;

var
  frmSelectDir: TfrmSelectDir;

implementation

{$R *.dfm}

{ TfrmSelectDir }

procedure TfrmSelectDir.bBrowseClick(Sender: TObject);
begin
  with JvBrowseForFolderDialog do begin
    if DirectoryExists(eDirectory.Text) then Directory := eDirectory.Text;
    if Execute then eDirectory.Text := Directory;
  end;
end;

procedure TfrmSelectDir.bOKClick(Sender: TObject);
begin
  if not DirectoryExists(GetSelectedDirectory) then begin
    MsgBox('Specified directory doesn''t exists.', 'Error', MB_ICONWARNING);
    ModalResult := mrNone;
  end;
end;

function TfrmSelectDir.Execute(const DefaultDirectory: TFileName): Boolean;
begin
  Self.eDirectory.Text := DefaultDirectory;
  Result := (ShowModal = mrOK);
end;

procedure TfrmSelectDir.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

procedure TfrmSelectDir.FormShow(Sender: TObject);
begin
  Self.eDirectory.SelectAll;
  Self.eDirectory.SetFocus;
end;

function TfrmSelectDir.GetSelectedDirectory: string;
begin
  Result := IncludeTrailingPathDelimiter(eDirectory.Text);
end;

function TfrmSelectDir.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

end.
