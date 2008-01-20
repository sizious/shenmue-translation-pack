//    This file is part of IDX Creator for Shenmue.
//
//    IDX Creator for Shenmue is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    IDX Creator for Shenmue is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with IDX Creator for Shenmue.  If not, see <http://www.gnu.org/licenses/>.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cStreams, ComCtrls, UIntList, ExtCtrls;

type
  TForm1 = class(TForm)
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
    procedure BrowseAfsBtClick(Sender: TObject);
    procedure BrowseIdxBtClick(Sender: TObject);
    procedure CreateIdxBtClick(Sender: TObject);
    
    procedure create_idx_file(input_afs:String; output_idx:String);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation
uses variables;
{$R *.dfm}

//This function retrieve the text between the defined substring
function parse_section(substr:String; s:String; n:Integer): string;
var i:integer;
begin
        S := S + substr;

        for i:=1 to n do
        begin
                S := copy(s, Pos(substr, s) + Length(substr), Length(s) - Pos(substr, s) + Length(substr));
        end;

        Result := Copy(s, 1, pos(substr, s)-1);
end;

procedure TForm1.create_idx_file(input_afs:String; output_idx:String);
var fafs, fidx:TFileStream; str_buffer:String;
i, i2, int_buffer, total_files, list_offset, current_offset, srf_size:Integer;
file_begin, file_end, lowest_srf:Integer; Check:Boolean;
delete2, filename:String;
begin
        //Creating the file stream for input
        fafs := TFileStream.Create(input_afs, fsomRead);

        //Reading header of the AFS
        str_buffer := fafs.ReadStr(3);

        //Verify if this is a valid AFS file
        if str_buffer = 'AFS' then
        begin
                //Creating the file stream for output
                fidx := TFileStream.Create(output_idx, fsomCreate);

                //Initializing variables
                files_infos := TStringList.Create;
                files_offset := TIntList.Create;
                files_size := TIntList.Create;
                srf_list := TIntList.Create;
                srf_offset := TIntList.Create;
                current_files_list := TIntList.Create;

                list_offset := 0;
                lowest_srf := 0;

                //Modifying Form1
                CreateIdxBt.Enabled := False;
                BrowseAfsBt.Enabled := False;
                BrowseIdxBt.Enabled := False;
                ProgressBar1.Position := 0;
                Panel1.Caption := '0%';

                //Seeking to the number of files and reading the value
                fafs.Position := 4;
                total_files := fafs.Reader.ReadLongInt;

                ProgressBar1.Max := total_files;
                StatusBar1.Panels[0].Text := 'Building files list...';
                Application.ProcessMessages;

                //Seeking to the offset/size list and reading the values
                fafs.Position := 8;
                for i:=0 to total_files-1 do
                begin
                        //Seeking to the correct offset for the current file
                        fafs.Position := 8 + (8*i);

                        //Reading current file offset and seeking to size
                        files_offset.Add(fafs.Reader.ReadLongInt);
                        files_size.Add(fafs.Reader.ReadLongInt);

                        //Seeking before the first file to find the files list offset
                        if i = 0 then
                        begin
                                fafs.Position := files_offset[i] - 8;
                                list_offset := fafs.Reader.ReadLongInt;
                        end;

                        //Seeking to files list
                        fafs.Position := list_offset+(48*i);

                        //Reading filename
                        files_infos.Add(trim(fafs.ReadStr(32)));
                end;

                StatusBar1.Panels[0].Text := 'Finding SRF files...';
                Application.ProcessMessages;

                //Analyzing 'files_infos' variables to find srf file
                for i:=0 to files_infos.Count-1 do
                begin
                        if LowerCase(ExtractFileExt(files_infos[i])) = '.srf' then
                        begin
                                srf_list.Add(i);
                        end;
                end;

                StatusBar1.Panels[0].Text := 'Parsing SRF files...';
                Application.ProcessMessages;

                //Parsing the srf file - Lite version of the srf parser
                //of Shenmue I Subtitles Editor v1
                for i:=0 to srf_list.Count-1 do
                begin
                        //Seeking to current srf offset & setting variable
                        fafs.Position := files_offset[srf_list[i]];
                        current_offset := files_offset[srf_list[i]];
                        srf_size := files_offset[srf_list[i]] + files_size[srf_list[i]];

                        //Loop that read the file
                        while current_offset <> srf_size do
                        begin
                                //Reading & verifying subtitle header
                                int_buffer := fafs.Reader.ReadLongInt;
                                if int_buffer = 8 then
                                begin
                                        srf_offset.Add((fafs.Position-4) - files_offset[srf_list[i]]);

                                        //Continue throught the file to the next subtitle
                                        //Skip the header
                                        Inc(current_offset, 8);
                                        fafs.Position := current_offset;
                                        //Skip subtitle text
                                        int_buffer := fafs.Reader.ReadLongInt;
                                        Inc(current_offset, int_buffer);
                                        fafs.Position := current_offset;
                                        //Skip data section
                                        int_buffer := fafs.Reader.ReadLongInt;
                                        Inc(current_offset, int_buffer);
                                        fafs.Position := current_offset;
                                end
                                else
                                begin
                                        Inc(current_offset);
                                        fafs.Position := current_offset;
                                end;
                        end;
                end;

                StatusBar1.Panels[0].Text := 'Writing IDX file...';
                Application.ProcessMessages;

                //Writing IDX Header
                fidx.WriteStr('IDX');
                fidx.WriteStr('0');
                fidx.Writer.WriteWord(total_files);
                fidx.Writer.WriteWord(total_files-srf_list.Count);

                //Writing null bytes
                for i:=0 to 11 do
                begin
                        fidx.Writer.WriteByte(0);
                end;

                //Finding lowest SRF file number
                for i:=0 to srf_list.Count-1 do
                begin
                        if i = 0 then
                        begin
                                lowest_srf := srf_list[i];
                        end
                        else
                        begin
                                if srf_list[i] < lowest_srf then
                                begin
                                        lowest_srf := srf_list[i];
                                end;
                        end;
                end;

                //Writing files list
                for i:=0 to srf_list.Count-1 do
                begin
                        //Setting 'current_files_list' variable
                        if srf_list[i] = lowest_srf then
                        begin
                                file_begin := 0;
                                file_end := lowest_srf - 1;
                        end
                        else
                        begin
                                file_begin := srf_list[i-1] + 1;
                                file_end := srf_list[i] - 1;
                        end;

                        current_files_list.Clear;
                        for i2:=file_begin to file_end do
                        begin
                                current_files_list.Add(i2);
                        end;

                        //Sorting files by name
                        if current_files_list.Count > 1 then
                        begin
                                repeat
                                        Check := False;
                                        int_buffer := 0;
                                        repeat
                                                if CompareStr(files_infos[current_files_list[int_buffer]], files_infos[current_files_list[int_buffer+1]]) > 0 then
                                                begin
                                                        current_files_list.Exchange(int_buffer, int_buffer+1);
                                                        Check := True;
                                                end;
                                                Inc(int_buffer);
                                        until(int_buffer = current_files_list.Count-1);
                                until(Check = False);
                        end;

                        for i2:=0 to current_files_list.Count-1 do
                        begin
                                //Writing list
                                filename := files_infos[current_files_list[i2]];
                                delete2 := ExtractFileExt(filename);
                                Delete(filename, Pos(delete2, filename), Length(delete2));
                                fidx.WriteStr(filename);

                                for int_buffer:=0 to (12-Length(filename)-1) do
                                begin
                                        fidx.Writer.WriteByte(0);
                                end;

                                fidx.Writer.WriteWord(current_files_list[i2]); //File number
                                fidx.Writer.WriteWord(srf_list[i]);// Linked SRF
                                fidx.Writer.WriteLongInt(srf_offset[current_files_list[i2]-i]); //Subtitle offset in the SRF

                                //Modifying Form1
                                ProgressBar1.Position := ProgressBar1.Position + 1;
                                Panel1.Caption := IntToStr(Round((100*ProgressBar1.Position)/ProgressBar1.Max))+'%';
                                Application.ProcessMessages;
                        end;

                        //Modifying Form1 (again, for each SRF)
                        ProgressBar1.Position := ProgressBar1.Position + 1;
                        Panel1.Caption := IntToStr(Round((100*ProgressBar1.Position)/ProgressBar1.Max))+'%';
                        Application.ProcessMessages;
                end;

                //Modifying Form1
                StatusBar1.Panels[0].Text := 'Creation completed for '+ExtractFileName(output_idx)+' !';
                Application.ProcessMessages;

                CreateIdxBt.Enabled := True;
                BrowseAfsBt.Enabled := True;
                BrowseIdxBt.Enabled := True;

                //Freeing file stream & variables
                fidx.Free;
                files_infos.Free;
                files_offset.Free;
                files_size.Free;
                srf_list.Free;
                srf_offset.Free;
                current_files_list.Free;
        end

        else
        begin
                MessageDlg('"'+ExtractFileName(input_afs)+'" is not a valid AFS file.'+sLineBreak+sLineBreak+'IDX creation stopped...', mtError, [mbOk], 0);
        end;

        //Closing the AFS file stream
        fafs.Free;
end;

procedure TForm1.BrowseAfsBtClick(Sender: TObject);
begin
        OpenDialog1.Filter := 'AFS file (*.afs)|*.afs';

        if OpenDialog1.Execute then
        begin
                input_afs_txt.Text := OpenDialog1.FileName;
        end;
end;

procedure TForm1.BrowseIdxBtClick(Sender: TObject);
begin
        SaveDialog1.Filter := 'IDX file (*.idx)|*.idx';
        SaveDialog1.DefaultExt := 'idx';

        if SaveDialog1.Execute then
        begin
                output_idx_txt.Text := SaveDialog1.FileName;
        end;
end;

procedure TForm1.CreateIdxBtClick(Sender: TObject);
begin
        if (input_afs_txt.Text <> '') and (output_idx_txt.Text <> '') then
        begin
                create_idx_file(input_afs_txt.Text, output_idx_txt.Text);
        end
        else
        begin
                MessageDlg('The input AFS or the output IDX might not be set.', mtError, [mbOk], 0);
        end;
end;

end.
