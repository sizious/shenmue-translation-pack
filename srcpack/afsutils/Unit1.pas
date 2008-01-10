//    This file is part of AFS Utils.
//
//    AFS Utils is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    AFS Utils is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with AFS Utils.  If not, see <http://www.gnu.org/licenses/>.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, FileCtrl, cStreams, UIntList, Math, Menus;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    StatusBar1: TStatusBar;
    new_afs_radio: TRadioButton;
    GroupBox2: TGroupBox;
    extract_afs_radio: TRadioButton;
    Label1: TLabel;
    input_extract_txt: TEdit;
    BrowseAfsBt: TButton;
    Label2: TLabel;
    output_directory_txt: TEdit;
    BrowseDirBt: TButton;
    StartExtractBt: TButton;
    OpenDialog1: TOpenDialog;
    ListBox1: TListBox;
    SaveAfsBt: TButton;
    AddFileBt: TButton;
    DeleteFileBt: TButton;
    LoadListBt: TButton;
    SaveDialog1: TSaveDialog;
    create_list_check: TCheckBox;
    ClearListBt: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Quit1: TMenuItem;
    ools1: TMenuItem;
    Blocksize1: TMenuItem;
    Writefileslist1: TMenuItem;
    procedure BrowseAfsBtClick(Sender: TObject);
    procedure BrowseDirBtClick(Sender: TObject);
    procedure new_afs_radioClick(Sender: TObject);
    procedure extract_afs_radioClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StartExtractBtClick(Sender: TObject);
    procedure SaveAfsBtClick(Sender: TObject);
    procedure AddFileBtClick(Sender: TObject);
    procedure DeleteFileBtClick(Sender: TObject);
    procedure LoadListBtClick(Sender: TObject);
    procedure ClearListBtClick(Sender: TObject);
    procedure create_afs_file(output_afs:String);
    procedure extract_afs_file(input_afs:String; output_directory:String);
    procedure Quit1Click(Sender: TObject);
    procedure Blocksize1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Writefileslist1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation
uses Unit2, Unit3, variables;
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

//Counting the number of occurence of a substring within a string
function CountPos(const subtext: string; Text: string): Integer;
begin
        if (Length(subtext) = 0) or (Length(Text) = 0) or (Pos(subtext, Text) = 0) then
        begin
                Result := 0;
        end
        else
        begin
                Result := (Length(Text) - Length(StringReplace(Text, subtext, '', [rfReplaceAll]))) div Length(subtext);
        end;
end;

//Find the correct offset to write file data in the AFS
function find_offset_value(foffset:Integer; fsize:Integer): Integer;
var multiplier, min_next_offset, final_value:Integer;
begin
        multiplier := Round(foffset / global_block_size)+1;
        min_next_offset := foffset + fsize;
        final_value := global_block_size * multiplier;
        while final_value < min_next_offset do
        begin
                Inc(multiplier);
                final_value := global_block_size * multiplier;
        end;

        Result := final_value;
end;

//AFS creation procedure
procedure TForm1.create_afs_file(output_afs:String);
var fafs, finput:TFileStream;
i, i2, file_offset, pos_first:Integer;
min_next_offset, result_offset, FAge:Integer;
FDate:TDateTime; temp_date:String;
begin
        //Creating file stream for the output & clear variables
        fafs := TFileStream.Create(output_afs, fsomCreate);
        files_infos.Clear;
        files_dates.Clear;

        //Modifying Form1
        StatusBar1.Panels[0].Text := 'Creation in progress...';
        SaveAfsBt.Enabled := False;
        AddFileBt.Enabled := False;
        DeleteFileBt.Enabled := False;
        LoadListBt.Enabled := False;
        ClearListBt.Enabled := False;
        extract_afs_radio.Enabled := False;

        //Modifying Form2
        Form2.ProgressBar1.Position := 0;
        Form2.ProgressBar1.Max := input_list.Count;
        Form2.Label1.Caption := 'File: ';
        Form2.Panel1.Caption := '0%';

        Application.ProcessMessages;

        //Writing AFS Header and the number of files
        fafs.WriteStr('AFS');
        fafs.Writer.WriteByte(0);
        fafs.Writer.WriteLongInt(input_list.Count);

        //Writing null bytes for the offset/size list
        for i:=0 to (input_list.Count*8)-1 do
        begin
                fafs.Writer.WriteByte(0);
        end;

        //Writing null bytes before the first file data
        file_offset := 8;

        //If we need to create files list or not... checking menu...
        if Writefileslist1.Checked then
        begin
                min_next_offset := file_offset + (input_list.Count*8) + 8; //The last +8 for the files list at the end of the AFS
                result_offset := find_offset_value(file_offset, ((input_list.Count*8)+8));
        end
        else
        begin
                min_next_offset := file_offset + (input_list.Count*8);
                result_offset := find_offset_value(file_offset, (input_list.Count*8));
        end;

        //Writing null bytes
        for i:=0 to (result_offset-min_next_offset)-1 do
        begin
                fafs.Writer.WriteByte(0);
        end;
        
        file_offset := result_offset;
        
        //Modifying Form2
        Form2.Caption := 'Creation... processing '+ExtractFileName(output_afs);
        Form2.Show;

        //For each file, the following code is executed
        for i:=0 to input_list.Count-1 do
        begin
                //Creating the stream
                finput := TFileStream.Create(input_list[i], fsomRead);

                //Modifying Form2 label
                Form2.Label1.Caption := 'File: '+ExtractFileName(input_list[i]);
                Application.ProcessMessages;

                //Adding infos to a variable
                files_infos.Add(IntToStr(finput.Size));

                //Writing file size and offset in the afs, at the beginning of the file
                fafs.Position := 8 + (8*i);
                fafs.Writer.WriteLongInt(file_offset);
                fafs.Writer.WriteLongInt(finput.Size);

                //Writing file data to the correct offset
                fafs.Position := file_offset;
                finput.WriteTo(fafs, 1, finput.Size);

                //Finding offset for the next file
                min_next_offset := file_offset + finput.Size;
                result_offset := find_offset_value(file_offset, finput.Size);

                //Writing null bytes before the next file
                for i2:=0 to (result_offset-min_next_offset)-1 do
                begin
                        fafs.Writer.WriteByte(0);
                end;

                file_offset := result_offset;

                //Writing the files list if needed
                if Writefileslist1.Checked then
                begin
                        //Getting file date
                        FAge := FileGetDate(finput.FileHandle);
                        FDate := FileDateToDateTime(FAge);
                        DateTimeToString(temp_date, 'yyyy m d h n s', FDate);
                        files_dates.Add(temp_date);
                end;

                //Closing the file stream
                finput.Free;

                //Modifying Form2 progressbar and percentage panel
                Form2.ProgressBar1.Position := Form2.ProgressBar1.Position + 1;
                Form2.Panel1.Caption := FloatToStr(SimpleRoundTo((100*Form2.ProgressBar1.Position)/Form2.ProgressBar1.Max, -2))+'%';
                Application.ProcessMessages;
        end;

        if Writefileslist1.Checked then
        begin
                //Writing the offset & size of the files list before the first file
                fafs.Position := 8;
                pos_first := fafs.Reader.ReadLongInt;
                fafs.Position := pos_first - 8;
                fafs.Writer.WriteLongInt(file_offset);
                fafs.Writer.WriteLongInt(48*input_list.Count);

                //Writing files list
                fafs.Position := file_offset;
                for i:=0 to input_list.Count-1 do
                begin
                        fafs.WriteStr(ExtractFileName(input_list[i]));
                        for i2:=0 to (32-Length(ExtractFileName(input_list[i])))-1 do
                        begin
                                fafs.Writer.WriteByte(0);
                        end;

                        //Writing date and file size
                        fafs.Writer.WriteWord(StrToInt(parse_section(' ', files_dates[i], 0)));
                        fafs.Writer.WriteWord(StrToInt(parse_section(' ', files_dates[i], 1)));
                        fafs.Writer.WriteWord(StrToInt(parse_section(' ', files_dates[i], 2)));
                        fafs.Writer.WriteWord(StrToInt(parse_section(' ', files_dates[i], 3)));
                        fafs.Writer.WriteWord(StrToInt(parse_section(' ', files_dates[i], 4)));
                        fafs.Writer.WriteWord(StrToInt(parse_section(' ', files_dates[i], 5)));
                        fafs.Writer.WriteLongInt(StrToInt(files_infos[i]));
                end;

                //Finding the number of null bytes after the list
                min_next_offset := file_offset + (48*input_list.Count);
                result_offset := find_offset_value(file_offset, (48*input_list.Count));

                //Writing null bytes after the files list
                for i:=0 to (result_offset-min_next_offset)-1 do
                begin
                        fafs.Writer.WriteByte(0);
                end;
        end;

        //Closing the file stream & clearing variables
        fafs.Free;
        files_infos.Clear;
        files_dates.Clear;

        //Restoring Form1 and closing Form2
        StatusBar1.Panels[0].Text := 'Creation completed for '+ExtractFileName(output_afs)+' !';
        SaveAfsBt.Enabled := True;
        AddFileBt.Enabled := True;
        DeleteFileBt.Enabled := True;
        LoadListBt.Enabled := True;
        ClearListBt.Enabled := True;
        extract_afs_radio.Enabled := True;

        Form2.Close;
end;

//AFS extraction procedure
procedure TForm1.extract_afs_file(input_afs:String; output_directory:String);
var fafs, fout:TFileStream; buffer, listname:String; flist:TextFile;
i, current_offset, files_count, file_offset, file_size, filelist_offset, temp_int:Integer;
file_date: array of Integer; FDate:TDateTime; FAge:Integer; filelist_presence:Boolean;
begin
        //Setting file stream for the input & variables
        fafs := TFileStream.Create(input_afs, fsomRead);
        current_offset := 0;
        filelist_presence := False;
        filelist_offset := 0;
        Finalize(file_date);
        
        StatusBar1.Panels[0].Text := '';

        //Setting date & time format
        DateSeparator := '/';
        ShortDateFormat := 'd/m/yyyy';
        TimeSeparator := ':';
        LongTimeFormat := 'h:n:s';

        //Reading the first 3 bytes of the afs
        buffer := fafs.ReadStr(3);

        //Verifying if this is a valid afs file
        if buffer = 'AFS' then
        begin
                //Modifying Form1
                StatusBar1.Panels[0].Text := 'Extraction in progress...';
                BrowseAfsBt.Enabled := False;
                BrowseDirBt.Enabled := False;
                StartExtractBt.Enabled := False;
                create_list_check.Enabled := False;
                new_afs_radio.Enabled := False;

                //If the user want to create a list at the same time
                if create_list_check.Checked then
                begin
                        listname := parse_section('.afs', ExtractFileName(input_afs), CountPos('.afs', ExtractFileName(input_afs))-1)+'_list.txt';
                        AssignFile(flist, output_directory+'\'+listname);
                        Rewrite(flist);        
                end;

                //Changing position in the afs
                Inc(current_offset, 4);
                fafs.Position := current_offset;

                //Reading the number of files in the afs
                files_count := fafs.Reader.ReadLongInt;

                //Calculating end offset of the size/offset list
                temp_int := 8+(files_count*8);

                //Modifying Form2
                Form2.Caption := 'Extraction... processing '+ExtractFileName(input_afs);
                Form2.ProgressBar1.Max := files_count;
                Form2.ProgressBar1.Position := 0;
                Form2.Panel1.Caption := '0%';
                Form2.Show;

                //Set length for 'file_date' variable
                SetLength(file_date, 6);

                //Changing position in the afs
                Inc(current_offset, 4);
                fafs.Position := current_offset;

                for i:=0 to files_count-1 do
                begin
                        //Reading current file offset and size
                        file_offset := fafs.Reader.ReadLongInt;
                        Inc(current_offset, 4);
                        fafs.Position := current_offset;
                        file_size := fafs.Reader.ReadLongInt;
                        Inc(current_offset, 4);

                        //If it's the first file: verifying files list presence
                        if i = 0 then
                        begin
                                if (file_offset - temp_int) >= 8 then
                                begin
                                        fafs.Position := file_offset - 8;
                                        filelist_offset := fafs.Reader.ReadLongInt;
                                end;

                                if filelist_offset > 0 then
                                begin
                                        filelist_presence := True;
                                end;
                        end;

                        //Seeking to files list to read filename & date
                        if filelist_presence then
                        begin
                                fafs.Position := filelist_offset+(48*i);
                                buffer := Trim(fafs.ReadStr(32));
                                file_date[0] := fafs.Reader.ReadWord;
                                file_date[1] := fafs.Reader.ReadWord;
                                file_date[2] := fafs.Reader.ReadWord;
                                file_date[3] := fafs.Reader.ReadWord;
                                file_date[4] := fafs.Reader.ReadWord;
                                file_date[5] := fafs.Reader.ReadWord;
                        end
                        else
                        begin
                                buffer := 'file_'+IntToStr(i);
                        end;

                        //Modifying Form2 label
                        Form2.Label1.Caption := 'File: '+buffer;
                        Application.ProcessMessages;

                        //Seeking to current file offset and copy the byte to a new file
                        fafs.Position := file_offset;
                        fout := TFileStream.Create(output_directory+'\'+buffer, fsomCreate);
                        fafs.WriteTo(fout, 1, file_size);

                        //Changing the date of the file
                        if filelist_presence then
                        begin
                                FDate := StrToDateTime(IntToStr(file_date[2])+'/'+IntToStr(file_date[1])+'/'+IntToStr(file_date[0])+' '+IntToStr(file_date[3])+':'+IntToStr(file_date[4])+':'+IntToStr(file_date[5]));
                                FAge := DateTimeToFileDate(FDate);
                                FileSetDate(fout.FileHandle, FAge);
                        end;

                        //Closing the file stream
                        fout.Free;

                        //Seeking back to next file offset
                        fafs.Position := current_offset;

                        //Modifying Form2 and writing to files list
                        Form2.ProgressBar1.Position := Form2.ProgressBar1.Position + 1;
                        Form2.Panel1.Caption := FloatToStr(SimpleRoundTo((100*Form2.ProgressBar1.Position)/Form2.ProgressBar1.Max, -2))+'%';

                        //Writing file path to the txt
                        if create_list_check.Checked then
                        begin
                                Writeln(flist, output_directory+'\'+buffer);
                        end;

                        Application.ProcessMessages;
                end;

                //Clearing variables
                Finalize(file_date);

                //Close the files list
                if create_list_check.Checked then
                begin
                        CloseFile(flist);
                end;

                //Modifying Form1 and closing Form2
                StatusBar1.Panels[0].Text := 'Extraction completed for '+ExtractFileName(input_afs)+' !';
                BrowseAfsBt.Enabled := True;
                BrowseDirBt.Enabled := True;
                StartExtractBt.Enabled := True;
                create_list_check.Enabled := True;
                new_afs_radio.Enabled := True;
                
                Form2.Close;
        end

        else
        begin
                MessageDlg('"'+ExtractFileName(input_afs)+'" is not a valid AFS file.'+sLineBreak+sLineBreak+'Extraction stopped...', mtError, [mbOk], 0);
        end;

        //Closing the file stream
        fafs.Free;
end;

procedure TForm1.StartExtractBtClick(Sender: TObject);
begin
        if (input_extract_txt.Text <> '') and (output_directory_txt.Text <> '') then
        begin
                extract_afs_file(input_extract_txt.Text, output_directory_txt.Text);
        end
        else
        begin
                MessageDlg('The input file or the output directory might not be set.', mtError, [mbOk], 0);
        end;
end;

procedure TForm1.BrowseDirBtClick(Sender: TObject);
var selected_directory:String;
begin
        if SelectDirectory('Select a directory', '*', selected_directory) then
        begin
                output_directory_txt.Text := selected_directory;
        end;
end;

procedure TForm1.BrowseAfsBtClick(Sender: TObject);
begin
        OpenDialog1.Filter := 'AFS file (*.afs)|*.afs';

        if OpenDialog1.Execute then
        begin
                input_extract_txt.Text := OpenDialog1.FileName;
        end;
end;

procedure TForm1.SaveAfsBtClick(Sender: TObject);
begin
        if input_list.Count > 0 then
        begin
                SaveDialog1.Filter := 'AFS file (*.afs)|*.afs';
                SaveDialog1.DefaultExt := 'afs';

                if SaveDialog1.Execute then
                begin
                        create_afs_file(SaveDialog1.FileName);
                end;
        end

        else
        begin
                MessageDlg('No file was found in the list.', mtError, [mbOk], 0);
        end;
end;

procedure TForm1.ClearListBtClick(Sender: TObject);
begin
        //Clear variables and listbox
        input_list.Clear;
        ListBox1.Clear;
end;

procedure TForm1.LoadListBtClick(Sender: TObject);
var ftxt:TextFile; fpath:String;
begin
        OpenDialog1.Filter := 'Files list (*.txt)|*.txt';

        if OpenDialog1.Execute then
        begin
                AssignFile(ftxt, OpenDialog1.FileName);
                Reset(ftxt);

                //Check if each file in the txt list exist
                repeat
                        Readln(ftxt, fpath);
                        if FileExists(fpath) then
                        begin
                                input_list.Add(fpath);
                                ListBox1.Items.Add(ExtractFileName(fpath));
                        end
                        else
                        begin
                                MessageDlg('The file "'+ExtractFileName(fpath)+'" doesn''t exist in '+ExtractFilePath(fpath), mtError, [mbOk], 0);
                        end;
                until EOF(ftxt);

                CloseFile(ftxt);
        end;
end;

procedure TForm1.DeleteFileBtClick(Sender: TObject);
begin
        if ListBox1.Items.Count > 0 then
        begin
                input_list.Delete(ListBox1.ItemIndex);
                ListBox1.Items.Delete(ListBox1.ItemIndex);
        end

        else
        begin
                MessageDlg('The current files list is empty. No file can be deleted.', mtError, [mbOk], 0);
        end;
end;

procedure TForm1.AddFileBtClick(Sender: TObject);
begin
        OpenDialog1.Filter := 'All files (*.*)|*.*';

        if OpenDialog1.Execute then
        begin
                //Adding the file to the list
                input_list.Add(OpenDialog1.FileName);
                ListBox1.Items.Add(ExtractFileName(OpenDialog1.FileName));
        end;
end;

procedure TForm1.extract_afs_radioClick(Sender: TObject);
begin
        //Deactivation of the 'creation' panel
        new_afs_radio.Checked := False;
        ListBox1.Enabled := False;
        SaveAfsBt.Enabled := False;
        AddFileBt.Enabled := False;
        DeleteFileBt.Enabled := False;
        LoadListBt.Enabled := False;
        ClearListBt.Enabled := False;

        //Activation of the 'extract' panel
        Label1.Enabled := True;
        Label2.Enabled := True;
        input_extract_txt.Enabled := True;
        output_directory_txt.Enabled := True;
        BrowseAfsBt.Enabled := True;
        BrowseDirBt.Enabled := True;
        StartExtractBt.Enabled := True;
        create_list_check.Enabled := True;
end;

procedure TForm1.new_afs_radioClick(Sender: TObject);
begin
        //Deactivation of the 'extract' panel
        extract_afs_radio.Checked := False;
        Label1.Enabled := False;
        Label2.Enabled := False;
        input_extract_txt.Enabled := False;
        output_directory_txt.Enabled := False;
        BrowseAfsBt.Enabled := False;
        BrowseDirBt.Enabled := False;
        StartExtractBt.Enabled := False;
        create_list_check.Enabled := False;

        //Activation of the 'creation' panel
        ListBox1.Enabled := True;
        SaveAfsBt.Enabled := True;
        AddFileBt.Enabled := True;
        DeleteFileBt.Enabled := True;
        LoadListBt.Enabled := True;
        ClearListBt.Enabled := True;
end;

procedure TForm1.Writefileslist1Click(Sender: TObject);
begin
        if Writefileslist1.Checked = False then
        begin
                Writefileslist1.Checked := True;
        end
        else
        begin
                Writefileslist1.Checked := False;
        end;
end;

procedure TForm1.Blocksize1Click(Sender: TObject);
begin
        //Opening a form
        blocksize_form.Show;
end;

procedure TForm1.Quit1Click(Sender: TObject);
begin
        Close;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
        //Default startup
        //Deactivation of the 'extract' panel
        extract_afs_radio.Checked := False;
        Label1.Enabled := False;
        Label2.Enabled := False;
        input_extract_txt.Enabled := False;
        output_directory_txt.Enabled := False;
        BrowseAfsBt.Enabled := False;
        BrowseDirBt.Enabled := False;
        StartExtractBt.Enabled := False;
        create_list_check.Enabled := False;

        //Activating 'Write files list' in the menu
        Writefileslist1.Checked := True;

        //Activation of the 'creation' panel
        new_afs_radio.Checked := True;
        ListBox1.Enabled := True;
        SaveAfsBt.Enabled := True;
        AddFileBt.Enabled := True;
        DeleteFileBt.Enabled := True;
        LoadListBt.Enabled := True;
        ClearListBt.Enabled := True;

        //Initializing variables
        input_list := TStringList.Create;
        files_infos := TStringList.Create;
        files_dates := TStringList.Create;
        DecimalSeparator := '.';
end;

procedure TForm1.FormCreate(Sender: TObject);
var num:Integer;
begin
        //Setting variable
        DoubleBuffered := True;

        //Setting block size variable
        global_block_size := 2048;

        //Creating block size list, used in blocksize_form...
        block_value_list := TIntList.Create;
        num := 1;
        while num < (4096*2) do
        begin
                block_value_list.Add(num);
                num := num*2;        
        end;
end;

end.
