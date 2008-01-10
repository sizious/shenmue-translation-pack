//    This file is part of SPR Utils.
//
//    SPR Utils is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    SPR Utils is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with SPR Utils.  If not, see <http://www.gnu.org/licenses/>.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, FileCtrl, ShellAPI, cStreams, UIntList;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ListBox1: TListBox;
    StatusBar1: TStatusBar;
    SaveSprBt: TButton;
    GzipCheckBx: TCheckBox;
    LoadListBt: TButton;
    DeleteItemBt: TButton;
    CreationRadioBt: TRadioButton;
    ExtractionRadioBt: TRadioButton;
    SprInputEdit: TEdit;
    Label1: TLabel;
    SprBrowseBt: TButton;
    Label2: TLabel;
    OutputDirEdit: TEdit;
    DirBrowseBt: TButton;
    StartExtractBt: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ClearListBt: TButton;
    procedure SprBrowseBtClick(Sender: TObject);
    procedure DirBrowseBtClick(Sender: TObject);
    procedure LoadListBtClick(Sender: TObject);
    procedure StartExtractBtClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CreationRadioBtClick(Sender: TObject);
    procedure ExtractionRadioBtClick(Sender: TObject);
    procedure SaveSprBtClick(Sender: TObject);
    procedure ClearListBtClick(Sender: TObject);

    procedure form_mod(panel:String; mode:Boolean);
    procedure create_spr(output:String);
    procedure extract_spr(input, output_dir:String);
    function null_bytes_length(files_count:Integer): Integer;
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

procedure TForm1.form_mod(panel:String; mode:Boolean);
begin
        if panel = 'creation' then
        begin
                ClearListBt.Enabled := mode;
                DeleteItemBt.Enabled := mode;
                GzipCheckBx.Enabled := mode;
                ListBox1.Enabled := mode;
                LoadListBt.Enabled := mode;
                SaveSprBt.Enabled := mode;
        end;

        if panel = 'extraction' then
        begin
                DirBrowseBt.Enabled := mode;
                Label1.Enabled := mode;
                Label2.Enabled := mode;
                OutputDirEdit.Enabled := mode;
                SprBrowseBt.Enabled := mode;
                SprInputEdit.Enabled := mode;
                StartExtractBt.Enabled := mode;
        end;
end;

function TForm1.null_bytes_length(files_count:Integer): Integer;
var current_num, total_null_bytes:Integer;
begin
        //Finding the correct number of null bytes to write after all the files
        current_num := 1;
        total_null_bytes := 4;

        while current_num <> files_count do
        begin
                if total_null_bytes = 16 then
                begin
                        total_null_bytes := 4;
                end
                else
                begin
                        Inc(total_null_bytes, 4);
                end;

                Inc(current_num, 1);
        end;

        Result := total_null_bytes;
end;

procedure TForm1.create_spr(output:String);
var fspr, fimg:TFileStream;
img_type, img_name, unk_num:String;
i, i2, current_index, null_bytes, int_temp:Integer;
begin
        //Setting the file stream & variables
        fspr := TFileStream.Create(output, fsomCreate);
        current_index := 0;

        //Modifying Form1
        ExtractionRadioBt.Enabled := False;
        form_mod('creation', False);
        StatusBar1.Panels[0].Text := 'Creation... processing '+ExtractFileName(output);

        //Writing the spr file
        for i:=0 to input_list.Count-1 do
        begin
                //Opening the image file
                fimg := TFileStream.Create(input_list[i], fsomRead);

                //Adding values into some variables
                img_name := misc_list[current_index];
                Inc(current_index);
                img_type := misc_list[current_index];
                Inc(current_index);

                if img_type = 'PVR' then
                begin
                        unk_num := misc_list[current_index];
                        Inc(current_index);
                end;

                //Writing section header
                fspr.WriteStr('TEXN');

                if img_type = 'PVR' then
                begin
                        int_temp := 28;
                end
                else
                begin
                        int_temp := 0;
                end;

                fspr.Writer.WriteLongInt((fimg.Size-int_temp)+44);
                fspr.WriteStr(img_name);

                if Length(img_name) < 8 then
                begin
                        for i2:=0 to (8-Length(img_name))-1 do
                        begin
                                fspr.Writer.WriteByte(0);
                        end;
                end;

                fspr.WriteStr('GBIX');
                fspr.Writer.WriteLongInt(4);
                fspr.Writer.WriteLongInt(0);

                fspr.WriteStr('PVRT');

                if img_type = 'PVR' then
                begin
                        int_temp := ((fimg.Size-28)+44)-36;
                end
                else
                begin
                        int_temp := (fimg.Size+44)-164;
                end;

                fspr.Writer.WriteLongInt(int_temp);

                if img_type = 'PVR' then
                begin
                        //Writing unknown number
                        fspr.Writer.WriteLongInt(StrToInt(unk_num));
                end
                else
                begin
                        //Writing DXT version
                        if misc_list[(i*2)+1] = 'DXT1' then
                        begin
                                fspr.Writer.WriteLongInt(32896);
                        end
                        else if misc_list[(i*2)+1] = 'DXT3' then
                        begin
                                fspr.Writer.WriteLongInt(32897);
                        end;
                end;

                fspr.Writer.WriteWord(res_list[i*2]); //Image width
                fspr.Writer.WriteWord(res_list[(i*2)+1]); //Image height

                if img_type = 'PVR' then
                begin
                        int_temp := fimg.Size-28;
                        fimg.Position := 28;
                end
                else
                begin
                        int_temp := fimg.Size;
                end;

                fimg.WriteTo(fspr, 1, int_temp);
                Application.ProcessMessages;

                //Closing image file stream
                fimg.Free;
        end;

        //Writing the null bytes
        null_bytes := null_bytes_length(input_list.Count);
        for i:=0 to null_bytes-1 do
        begin
                fspr.Writer.WriteByte(0);
        end;

        //Closing file stream
        fspr.Free;

        if (GzipCheckBx.Checked = True) and (FileExists(ExtractFilePath(Application.ExeName)+'gzip.exe')) then
        begin
                ShellExecute(Handle, 'open', PChar(ExtractFilePath(Application.ExeName)+'gzip.exe'), PChar('"'+output+'"'), nil, SW_SHOWNORMAL);
        end;
        Application.ProcessMessages; 

        //Modifying Form1
        ExtractionRadioBt.Enabled := True;
        form_mod('creation', True);
        StatusBar1.Panels[0].Text := 'Creation completed for '+ExtractFileName(output)+' !';
end;

procedure TForm1.extract_spr(input, output_dir:String);
var fspr, fout:TFileStream; str_buffer, name, out_name, img_type:String;
int_buffer, current_offset, count_f, total_size, res_x, res_y, minus_count:Integer;
txt_list:TextFile;
begin
        //Setting file stream & variables
        fspr := TFileStream.Create(input, fsomRead);
        AssignFile(txt_list, output_dir+'\'+ExtractFileName(input)+'.txt');
        Rewrite(txt_list);

        current_offset := 0;
        count_f := 0;

        //Modifying Form1
        CreationRadioBt.Enabled := False;
        form_mod('extraction', False);
        StatusBar1.Panels[0].Text := 'Extraction... processing '+ExtractFileName(input);

        while current_offset <> fspr.Size do
        begin
                str_buffer := fspr.ReadStr(4);

                if str_buffer = 'TEXN' then
                begin
                        Inc(count_f);

                        //Seeking to and reading section total size
                        Inc(current_offset, 4);
                        fspr.Position := current_offset;
                        total_size := fspr.Reader.ReadLongInt;

                        //Seeking to and reading texture name
                        Inc(current_offset, 4);
                        fspr.Position := current_offset;
                        name := Trim(fspr.ReadStr(8));

                        //Seeking to and reading «PVRT» size
                        Inc(current_offset, 24);
                        fspr.Position := current_offset;
                        int_buffer := fspr.Reader.ReadLongInt;

                        //Verifying the format of the image file
                        //A result of 164 = DDS & 36 = real PVR
                        if total_size-int_buffer = 164 then
                        begin
                                //Seeking to and reading the DXT version
                                Inc(current_offset, 4);
                                fspr.Position := current_offset;
                                int_buffer := fspr.Reader.ReadLongInt;

                                //Checking DXT version
                                if int_buffer = 32896 then
                                begin
                                        img_type := 'DXT1';
                                end
                                else if int_buffer = 32897 then
                                begin
                                        img_type := 'DXT3';
                                end;
                        end
                        else if total_size-int_buffer = 36 then
                        begin
                                img_type := 'PVR';

                                //Seeking to and reading the *unknown* number
                                Inc(current_offset, 4);
                                fspr.Position := current_offset;
                                int_buffer := fspr.Reader.ReadLongInt;
                        end;

                        //Seeking to and reading image width
                        Inc(current_offset, 4);
                        fspr.Position := current_offset;
                        res_x := fspr.Reader.ReadWord;

                        //Seeking to and reading image height
                        Inc(current_offset, 2);
                        fspr.Position := current_offset;
                        res_y := fspr.Reader.ReadWord;

                        //Calculating the correct offset
                        //Creating a name for the new file to write
                        if img_type = 'PVR' then
                        begin
                                current_offset := current_offset - 26;
                                minus_count := 16;
                                out_name := output_dir+'\'+'file_'+IntToStr(count_f)+'.pvr';
                        end
                        else
                        begin
                                Inc(current_offset, 2);
                                minus_count := 44;
                                out_name := output_dir+'\'+'file_'+IntToStr(count_f)+'.dds';
                        end;

                        //Seeking to the beginning of the image file
                        fspr.Position := current_offset;
                        Application.ProcessMessages;

                        //Writing the image to a new file
                        fout := TFileStream.Create(out_name, fsomCreate);
                        fspr.WriteTo(fout, 1, total_size - minus_count);
                        fout.Free;

                        Application.ProcessMessages;

                        //Writing the files list
                        if img_type = 'PVR' then
                        begin
                                Writeln(txt_list, out_name+'|'+name+'|'+img_type+'|'+IntToStr(int_buffer)+'|'+IntToStr(res_x)+'|'+IntToStr(res_y));
                        end
                        else
                        begin
                                Writeln(txt_list, out_name+'|'+name+'|'+img_type+'|'+IntToStr(res_x)+'|'+IntToStr(res_y));
                        end;

                        //Seeking to the next section
                        Inc(current_offset, total_size-minus_count);
                        fspr.Position := current_offset;
                end
                else
                begin
                        Inc(current_offset, 1);
                        fspr.Position := current_offset;
                end;
        end;

        //Closing the file stream
        fspr.Free;
        CloseFile(txt_list);

        //Modifying Form1
        CreationRadioBt.Enabled := True;
        form_mod('extraction', True);
        StatusBar1.Panels[0].Text := 'Extraction completed for '+ExtractFileName(input)+' !';
end;

procedure TForm1.SprBrowseBtClick(Sender: TObject);
begin
        OpenDialog1.Filter := 'SPR file (*.spr)|*.spr';

        if OpenDialog1.Execute then
        begin
                SprInputEdit.Text := OpenDialog1.FileName;
        end;
end;

procedure TForm1.DirBrowseBtClick(Sender: TObject);
var selected_directory:String;
begin
        if SelectDirectory('Select a directory', '*', selected_directory) then
        begin
                OutputDirEdit.Text := selected_directory;
        end;
end;

procedure TForm1.LoadListBtClick(Sender: TObject);
var ftxt:TextFile;  Line, str_temp:String;
begin
        OpenDialog1.Filter := 'Textures list (*.txt)|*.txt';

        if OpenDialog1.Execute then
        begin
                AssignFile(ftxt, OpenDialog1.FileName);
                Reset(ftxt);

                //Check if each file in the txt list exist
                repeat
                        Readln(ftxt, Line);
                        str_temp := parse_section('|', Line, 0);

                        if FileExists(str_temp) then
                        begin
                                ListBox1.Items.Add(ExtractFileName(str_temp));

                                input_list.Add(str_temp); //Add the file in the variable

                                str_temp := parse_section('|', Line, 1);
                                misc_list.Add(str_temp); //Add the texture name in the variable

                                str_temp := parse_section('|', Line, 2);
                                misc_list.Add(str_temp); //Add the image type in the variable

                                //Verifying image type
                                if str_temp = 'PVR' then
                                begin
                                        str_temp := parse_section('|', Line, 3);
                                        misc_list.Add(str_temp); //Add the unknown number in the variable
                                        str_temp := parse_section('|', Line, 4);
                                        res_list.Add(StrToInt(str_temp)); //Add the image width in the variable
                                        str_temp := parse_section('|', Line, 5);
                                        res_list.Add(StrToInt(str_temp)); //Add the image height in the variable
                                end
                                else
                                begin
                                        str_temp := parse_section('|', Line, 3);
                                        res_list.Add(StrToInt(str_temp)); //Add the image width in the variable
                                        str_temp := parse_section('|', Line, 4);
                                        res_list.Add(StrToInt(str_temp)); //Add the image height in the variable
                                end;
                        end
                        else
                        begin
                                MessageDlg('The file "'+ExtractFileName(str_temp)+'" doesn''t exist in '+ExtractFilePath(str_temp), mtError, [mbOk], 0);
                        end;
                until EOF(ftxt);

                CloseFile(ftxt);
        end;
end;

procedure TForm1.StartExtractBtClick(Sender: TObject);
begin
        if (SprInputEdit.Text <> '') and (OutputDirEdit.Text <> '') then
        begin
                extract_spr(SprInputEdit.Text, OutputDirEdit.Text);
        end
        else
        begin
                MessageDlg('The input file or the output directory might not be set.', mtError, [mbOk], 0);
        end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
        //Default startup
        CreationRadioBt.Checked := True;
        ExtractionRadioBt.Checked := False;
        form_mod('creation', True);
        form_mod('extraction', False);

        //Initializing variables
        input_list := TStringList.Create;
        misc_list := TStringList.Create;
        res_list := TIntList.Create;
end;

procedure TForm1.CreationRadioBtClick(Sender: TObject);
begin
        CreationRadioBt.Checked := True;
        ExtractionRadioBt.Checked := False;
        form_mod('creation', True);
        form_mod('extraction', False);
end;

procedure TForm1.ExtractionRadioBtClick(Sender: TObject);
begin
        ExtractionRadioBt.Checked := True;
        CreationRadioBt.Checked := False;
        form_mod('extraction', True);
        form_mod('creation', False);
end;

procedure TForm1.SaveSprBtClick(Sender: TObject);
begin
        if input_list.Count > 0 then
        begin
                SaveDialog1.Filter := 'SPR file (*.spr)|*.spr';
                SaveDialog1.DefaultExt := 'spr';

                if SaveDialog1.Execute then
                begin
                        create_spr(SaveDialog1.FileName);
                end;
        end
        else
        begin
                MessageDlg('No file was found in the list.', mtError, [mbOk], 0);
        end;
end;

procedure TForm1.ClearListBtClick(Sender: TObject);
begin
        input_list.Clear;
        misc_list.Clear;
        res_list.Clear;
        ListBox1.Clear;
end;

end.
 