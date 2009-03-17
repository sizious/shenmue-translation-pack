//    This file is part of IDX Creator.
//
//    IDX Creator is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    IDX Creator is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with IDX Creator.  If not, see <http://www.gnu.org/licenses/>.

unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cStreams, ComCtrls, UIntList, ExtCtrls, XPMan, S2IDX;

type
  TfrmMain = class(TForm)
    GroupBox1: TGroupBox;
    CreateIdxBt: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    input_afs_txt: TEdit;
    BrowseAfsBt: TButton;
    GroupBox2: TGroupBox;
    output_idx_txt: TEdit;
    BrowseIdxBt: TButton;
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    XPManifest1: TXPManifest;
    procedure BrowseAfsBtClick(Sender: TObject);
    procedure BrowseIdxBtClick(Sender: TObject);
    procedure CreateIdxBtClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;
  IDXCreator: TS2IDXCreator;

implementation

{$R *.dfm}

procedure TfrmMain.BrowseAfsBtClick(Sender: TObject);
begin
        OpenDialog1.Filter := 'AFS file (*.afs)|*.afs';

        if OpenDialog1.Execute then
        begin
                input_afs_txt.Text := OpenDialog1.FileName;
        end;
end;

procedure TfrmMain.BrowseIdxBtClick(Sender: TObject);
begin
        SaveDialog1.Filter := 'IDX file (*.idx)|*.idx';
        SaveDialog1.DefaultExt := 'idx';

        if SaveDialog1.Execute then
        begin
                output_idx_txt.Text := SaveDialog1.FileName;
        end;
end;

procedure TfrmMain.CreateIdxBtClick(Sender: TObject);
begin
        if (input_afs_txt.Text <> '') and (output_idx_txt.Text <> '') then
        begin
                //create_idx_file(input_afs_txt.Text, output_idx_txt.Text);
                IDXCreator.MakeIDX(input_afs_txt.Text, output_idx_txt.Text);
        end
        else
        begin
                MessageDlg('The input AFS or the output IDX might not be set.', mtError, [mbOk], 0);
        end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  IDXCreator := TS2IDXCreator.Create;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  IDXCreator.Free;
end;

end.
