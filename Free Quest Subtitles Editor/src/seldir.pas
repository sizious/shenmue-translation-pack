(*
  This file is part of Shenmue Free Quest Subtitles Editor.

  Shenmue Free Quest Subtitles Editor is free software: you can redistribute it
  and/or modify it under the terms of the GNU General Public License as
  published by the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Shenmue AiO Free Quest Subtitles Editor is distributed in the hope that it
  will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Shenmue AiO Free Quest Subtitles Editor.  If not, see
  <http://www.gnu.org/licenses/>.
*)

unit SelDir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, JvBaseDlg, JvBrowseFolder;

type
  TfrmSelectDir = class(TForm)
    gbDirectory: TGroupBox;
    bBrowse: TButton;
    bOK: TButton;
    bCancel: TButton;
    bvDelimiter: TBevel;
    lInfo: TLabel;
    JvBrowseForFolderDialog: TJvBrowseForFolderDialog;
    cbDirectory: TComboBox;
    procedure bBrowseClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
    procedure LoadPreviousPath;
    procedure SavePreviousPath;
  public
    { Déclarations publiques }
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
    function GetSelectedDirectory: string;
    procedure SetDefaultDirectory(const Directory: TFileName);
  end;

var
  frmSelectDir: TfrmSelectDir;

implementation

{$R *.dfm}

uses
  Utils;
  
{ TfrmSelectDir }

procedure TfrmSelectDir.bBrowseClick(Sender: TObject);
begin
  with JvBrowseForFolderDialog do begin
    if DirectoryExists(cbDirectory.Text) then Directory := cbDirectory.Text;
    if Execute then
      cbDirectory.Text := IncludeTrailingPathDelimiter(Directory);
  end;
end;

procedure TfrmSelectDir.bOKClick(Sender: TObject);
begin
  if not DirectoryExists(GetSelectedDirectory) then begin
    MsgBox('Specified directory doesn''t exists.', 'Error', MB_ICONWARNING);
    ModalResult := mrNone;
  end else begin
    if cbDirectory.Items.IndexOf(GetSelectedDirectory) = -1 then
      cbDirectory.Items.Add(GetSelectedDirectory); // adding to the list
  end;
end;

procedure TfrmSelectDir.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Saving the ComboBox list
  SavePreviousPath;
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
  LoadPreviousPath;
  
  cbDirectory.SelectAll;
  cbDirectory.SetFocus;
end;

function TfrmSelectDir.GetSelectedDirectory: string;
begin
  Result := IncludeTrailingPathDelimiter(cbDirectory.Text);
end;

procedure TfrmSelectDir.LoadPreviousPath;
var
  i: Integer;
  SL: TStringList;

begin
  if not FileExists(GetPreviousSelectedPathFileName) then Exit;
  cbDirectory.Items.Clear;
  
  SL := TStringList.Create;
  try
    SL.LoadFromFile(GetPreviousSelectedPathFileName);
    for i := 0 to SL.Count - 1 do
      if DirectoryExists(SL[i]) then
        cbDirectory.Items.Add(SL[i]);
  finally
    SL.Free;
  end;
end;

function TfrmSelectDir.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmSelectDir.SavePreviousPath;
begin
  cbDirectory.Items.SaveToFile(GetPreviousSelectedPathFileName);
end;

procedure TfrmSelectDir.SetDefaultDirectory(const Directory: TFileName);
begin
  cbDirectory.Text := Directory;
end;

end.
