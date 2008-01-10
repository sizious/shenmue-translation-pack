//    This file is part of Shenmue II Subtitles Editor.
//
//    Shenmue II Subtitles Editor is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Shenmue II Subtitles Editor is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.


unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, StdCtrls, ExtCtrls, cStreams, UIntList, StrUtils;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Saveas1: TMenuItem;
    Exit1: TMenuItem;
    Tools1: TMenuItem;
    Exportsubstotxt1: TMenuItem;
    Importsubsfromtxt1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    GroupBox1: TGroupBox;
    StatusBar1: TStatusBar;
    ListBox1: TListBox;
    GroupBox2: TGroupBox;
    header_edit: TEdit;
    chid_len_edit: TEdit;
    chid_edit: TEdit;
    sub_memo: TMemo;
    debug_memo: TMemo;
    copy_no_mod: TCheckBox;
    chid_len_lbl: TLabel;
    header_lbl: TLabel;
    chid_lbl: TLabel;
    sub_lbl: TLabel;
    debug_lbl: TLabel;
    Enablecharsmod1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Exportsubstotxt1Click(Sender: TObject);
    procedure Importsubsfromtxt1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sub_memoChange(Sender: TObject);
    procedure Enablecharsmod1Click(Sender: TObject);

    function null_bytes_length(sub_txt_length:Integer): Integer;
    procedure form_disabled(confirmed:Boolean);
    procedure load_charlist;
    function process_char(txt:String): Integer;
    function deprocess_char(decimal:Integer): String;
    procedure open_srf_file(input_srf:String);
    procedure save_srf_file(output_srf:String);
    procedure save_subs_txt(output_txt:String);
    procedure load_subs_txt(input_txt:String);
  private
    { Déclarations privées }
  public
    no_edit:Integer;
    filename:String;
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation
uses variables, USRFEntry;
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

function TForm1.null_bytes_length(sub_txt_length:Integer): Integer;
var current_num, total_null_bytes:Integer;
begin
        //Finding the correct number of null bytes to write after the subtitle text
        current_num := 0;
        total_null_bytes := 4;

        while current_num <> sub_txt_length do
        begin
                if total_null_bytes = 1 then
                begin
                        total_null_bytes := 4;
                end
                else
                begin
                        Dec(total_null_bytes);
                end;

                Inc(current_num, 1);
        end;

        Result := total_null_bytes;
end;

procedure TForm1.form_disabled(confirmed:Boolean);
begin
        //If the form is disabled or not...
        if confirmed then
        begin
                GroupBox1.Enabled := False;
                GroupBox2.Enabled := False;
        end
        
        else
        begin
                GroupBox1.Enabled := True;
                GroupBox2.Enabled := True;
        end;
end;

procedure TForm1.load_charlist;
var fcsv:TextFile; Line, first, second:String;
begin
        //Opening the csv file
        if FileExists('chars_list.csv') then
        begin
                AssignFile(fcsv, 'chars_list.csv');
                Reset(fcsv);

                //Placing the decimal and the character in their variable
                repeat
                        ReadLn(fcsv, Line);
                        first := parse_section(',', Line, 0);
                        second := parse_section(',', Line, 1);
                        chars_list.Add(AnsiDequotedStr(second,'"'));
                        chars_decimal_list.Add(StrToInt(first));
                until EOF(fcsv);

                CloseFile(fcsv);
                Enablecharsmod1.Checked := True;
        end
        else
        begin
                Enablecharsmod1.Checked := False;
                Enablecharsmod1.Enabled := False;
        end;
end;

function TForm1.process_char(txt:String): Integer;
var i:Integer;
begin
        //The result will not be modified unless the character is found in 'chars_list'
        Result := -1;

        for i:=0 to chars_list.Count-1 do
        begin
                if txt = chars_list[i] then
                begin
                        Result := chars_decimal_list[i];
                        Break;
                end;
        end;
end;

function TForm1.deprocess_char(decimal:Integer): String;
var i:Integer;
begin
        //Return the correct character according to it's decimal
        //if the characters modification was used at saving...
        Result := '';

        for i:=0 to chars_decimal_list.Count-1 do
        begin
                if decimal = chars_decimal_list[i] then
                begin
                        Result := chars_list[i];
                        Break;
                end;
        end;
end;

procedure TForm1.open_srf_file(input_srf:String);
var fsrf:TFileStream;
i, current_offset, int_buffer, srf_size, sub_count, temp_int:Integer;
str_buffer, temp_str:String; byte_buffer:array of Byte;
begin
        //Creating the file stream & other variables
        fsrf := TFileStream.Create(input_srf, fsomCreateOnWrite);
        srf_size := fsrf.Size;

        srf_data.Clear;
        current_offset := 0;
        sub_count := 0;

        //Modifying Form1
        ListBox1.Clear;
        header_edit.Clear;
        chid_len_edit.Clear;
        chid_edit.Clear;
        sub_memo.Clear;
        sub_memo.ReadOnly := True;
        debug_memo.Clear;
        form_disabled(true);

        //Main loop parsing the file
        while current_offset <> srf_size do
        begin
                str_buffer := fsrf.ReadStr(4);

                if str_buffer = 'CHID' then
                begin
                        //Creating variables
                        srf_infos := TSRFEntry.Create;

                        //Modifying srf_infos
                        srf_infos.FixedBlocks := TMemoryStream.Create;
                        srf_infos.NonEditable := 0;

                        //Seeking to Character ID length
                        Inc(current_offset, 4);
                        fsrf.Position := current_offset;

                        //Reading length & seeking to Character ID value
                        int_buffer := fsrf.Reader.ReadLongInt;
                        Inc(current_offset, 4);
                        fsrf.Position := current_offset;

                        //Reading Character ID value & seeking to the next value
                        srf_infos.CharID := fsrf.ReadStr(int_buffer-4);
                        Inc(current_offset, int_buffer-4);
                        fsrf.Position := current_offset;

                        if AnsiContainsStr(srf_infos.CharID, 'ENDC') then
                        begin
                                srf_infos.NonEditable := 1;
                                srf_infos.Subtitle := '';
                                srf_data.Add(srf_infos);

                                Inc(sub_count);
                                ListBox1.Items.Add('Subtitle #'+IntToStr(sub_count));

                                Continue;
                        end
                        else if AnsiContainsStr(srf_infos.CharID, 'STDL') = False then
                        begin
                                srf_infos.NonEditable := 1;
                        end;

                        if srf_infos.NonEditable = 1 then
                        begin
                                //If the current CHID section doesn't contain editable subtitles,
                                //the byte following the Character ID value must be copied without modifications

                                //Reading length & seeking back
                                int_buffer := fsrf.Reader.ReadLongInt;
                                fsrf.Position := current_offset;

                                //Writing bytes to 'srf_infos.FixedBlocks'
                                SetLength(byte_buffer, int_buffer-4);
                                for i:=0 to Length(byte_buffer)-1 do
                                begin
                                        fsrf.Read(byte_buffer[i], 1);
                                end;
                                for i:=0 to Length(byte_buffer)-1 do
                                begin
                                        srf_infos.FixedBlocks.Write(byte_buffer[i], 1);
                                end;
                                Finalize(byte_buffer);

                                Inc(current_offset, int_buffer-4);
                                fsrf.Position := current_offset;
                        end;

                        if srf_infos.NonEditable = 0 then
                        begin
                                //Reading subtitle length & seeking to subtitle text
                                int_buffer := fsrf.Reader.ReadLongInt;
                                Inc(current_offset, 4);
                                fsrf.Position := current_offset;

                                //Reading subtitle text & |converting accentuated characters|
                                srf_infos.Subtitle := Trim(fsrf.ReadStr(int_buffer-8));

                                //Seeking to the next sub-section
                                Inc(current_offset, int_buffer-8);
                                fsrf.Position := current_offset;
                        end;

                        //Verifying the sub-section, 'EXTD' & 'CLIP'
                        str_buffer := fsrf.ReadStr(4);

                        if str_buffer = 'EXTD' then
                        begin
                                //Seeking to sub-section length & reading value
                                Inc(current_offset, 4);
                                fsrf.Position := current_offset;
                                int_buffer := fsrf.Reader.ReadLongInt;

                                //Writing the sub-section to 'srf_infos.FixedBlocks'
                                fsrf.Position := current_offset - 4;
                                SetLength(byte_buffer, int_buffer);
                                for i:=0 to Length(byte_buffer)-1 do
                                begin
                                        fsrf.Read(byte_buffer[i], 1);
                                end;
                                for i:=0 to Length(byte_buffer)-1 do
                                begin
                                        srf_infos.FixedBlocks.Write(byte_buffer[i], 1);
                                end;
                                Finalize(byte_buffer);

                                //Seeking to the end of the sub-section
                                Inc(current_offset, int_buffer-4);
                                fsrf.Position := current_offset;
                                str_buffer := fsrf.ReadStr(4);
                        end;

                        if str_buffer = 'CLIP' then
                        begin
                                //Seeking to sub-section length & reading value
                                Inc(current_offset, 4);
                                fsrf.Position := current_offset;
                                int_buffer := fsrf.Reader.ReadLongInt;

                                //Writing the sub-section to 'srf_infos.FixedBlocks'
                                fsrf.Position := current_offset - 4;
                                SetLength(byte_buffer, int_buffer);
                                for i:=0 to Length(byte_buffer)-1 do
                                begin
                                        fsrf.Read(byte_buffer[i], 1);
                                end;
                                for i:=0 to Length(byte_buffer)-1 do
                                begin
                                        srf_infos.FixedBlocks.Write(byte_buffer[i], 1);
                                end;
                                Finalize(byte_buffer);

                                //Seeking to the end of the sub-section
                                Inc(current_offset, int_buffer-4);
                                fsrf.Position := current_offset;
                        end;

                        srf_data.Add(srf_infos);

                        Inc(sub_count);
                        ListBox1.Items.Add('Subtitle #'+IntToStr(sub_count));
                end

                else
                begin
                        Inc(current_offset);
                        fsrf.Position := current_offset;
                end;
        end;

        //Closing the file stream & other variables if needed
        fsrf.Free;

        //Modifying Form1
        Form1.Caption := Application.Title+' - '+ExtractFileName(input_srf);
        StatusBar1.Panels[0].Text := ExtractFileName(input_srf)+' opened successfully !';
        form_disabled(false);
        if srf_data.Count > 0 then
        begin
                sub_memo.ReadOnly := False;
                Exportsubstotxt1.Enabled := True;
                Importsubsfromtxt1.Enabled := True;
                Saveas1.Enabled := True;
        end
        else
        begin
                sub_memo.ReadOnly := True;
                Exportsubstotxt1.Enabled := False;
                Importsubsfromtxt1.Enabled := False;
                Saveas1.Enabled := False;
        end;

        //Keeping the filename in a variable
        filename := ExtractFileName(input_srf);
end;

procedure TForm1.save_srf_file(output_srf:String);
var fsrf:TFileStream; byte_buffer:array of Byte;
i, i2, block_num, block_size, sub_total_length, temp_int:Integer;
begin
        //Creating file stream & other variables
        fsrf := TFileStream.Create(output_srf, fsomCreate);
        block_size := 2048;
        block_num := 1;

        //Modifying Form1
        form_disabled(true);

        for i:=0 to srf_data.Count-1 do
        begin
                //Resetting variables
                sub_total_length := 0;

                //Calculating the length of the whole subtitle section
                Inc(sub_total_length, 8); //Header + Character ID length (LongInt)
                Inc(sub_total_length, Length(TSRFEntry(srf_data[i]).CharID)); //Character ID text length

                if TSRFEntry(srf_data[i]).NonEditable = 0 then
                begin
                        Inc(sub_total_length, 4); //Subtitle length (LongInt)
                        Inc(sub_total_length, Length(TSRFEntry(srf_data[i]).Subtitle) + null_bytes_length(Length(TSRFEntry(srf_data[i]).Subtitle))); //Subtitle text length + following null bytes
                end;

                Inc(sub_total_length, TSRFEntry(srf_data[i]).FixedBlocks.Size); // Non editable subtitle bytes, 'EXTD' & 'CLIP' length
                Inc(sub_total_length, 8); //Footer: 'ENDC' + 4 null bytes

                //Checking remaining space in the block
                {Inc(block_size, sub_total_length);}

                if (fsrf.Size+sub_total_length) > (block_size*block_num) then
                begin
                        for i2:=0 to ((block_size*block_num)-fsrf.Position)-1 do
                        begin
                                fsrf.Writer.WriteByte(0);
                        end;

                        Inc(block_num);
                end;

                //Writing the whole subtitle section
                fsrf.WriteStr('CHID'); //Header
                fsrf.Writer.WriteLongInt(Length(TSRFEntry(srf_data[i]).CharID)+4); //Character ID length (LongInt)
                fsrf.WriteStr(TSRFEntry(srf_data[i]).CharID); //Character ID value

                if TSRFEntry(srf_data[i]).NonEditable = 0 then
                begin
                        fsrf.Writer.WriteLongInt(Length(TSRFEntry(srf_data[i]).Subtitle) + null_bytes_length(Length(TSRFEntry(srf_data[i]).Subtitle)) + 8);

                        //Checkinf if the characters modification is enabled
                        if Enablecharsmod1.Checked then
                        begin
                                for i2:=1 to Length(TSRFEntry(srf_data[i]).Subtitle) do
                                begin
                                        //Sending the character to 'process_char'...
                                        if ((TSRFEntry(srf_data[i]).Subtitle[i2] = '¡') and (TSRFEntry(srf_data[i]).Subtitle[i2+1] = 'õ')) or ((TSRFEntry(srf_data[i]).Subtitle[i2] = 'õ') and (TSRFEntry(srf_data[i]).Subtitle[i2-1] = '¡')) then
                                        begin
                                                temp_int := -1;
                                        end
                                        else
                                        begin
                                                temp_int := process_char(TSRFEntry(srf_data[i]).Subtitle[i2]);
                                        end;

                                        //Writing in the SRF file
                                        if temp_int <> -1 then
                                        begin
                                                fsrf.Writer.WriteByte(temp_int);
                                        end
                                        else
                                        begin
                                                fsrf.WriteStr(TSRFEntry(srf_data[i]).Subtitle[i2]);
                                        end;
                                end;
                        end
                        else
                        begin
                                fsrf.WriteStr(TSRFEntry(srf_data[i]).Subtitle);
                        end;

                        for i2:=0 to null_bytes_length(Length(TSRFEntry(srf_data[i]).Subtitle))-1 do
                        begin
                                fsrf.Writer.WriteByte(0);
                        end;
                end;

                TSRFEntry(srf_data[i]).FixedBlocks.Seek(0, soFromBeginning);
                SetLength(byte_buffer, TSRFEntry(srf_data[i]).FixedBlocks.Size);
                for i2:=0 to Length(byte_buffer)-1 do
                begin
                        TSRFEntry(srf_data[i]).FixedBlocks.Read(byte_buffer[i2], 1);
                end;
                for i2:=0 to Length(byte_buffer)-1 do
                begin
                        fsrf.Write(byte_buffer[i2], 1);
                end;

                if AnsiContainsStr(TSRFEntry(srf_data[i]).CharID, 'ENDC') = False then
                begin
                        fsrf.WriteStr('ENDC');
                end;

                for i2:=0 to 3 do
                begin
                        fsrf.Writer.WriteByte(0);
                end;
        end;

        //Closing the file stream
        fsrf.Free;

        //Modifying Form1
        StatusBar1.Panels[0].Text := ExtractFileName(output_srf)+' saved successfully !';
        form_disabled(false);

        //Keeping the filename in a variable
        filename := ExtractFileName(output_srf);
end;

procedure TForm1.save_subs_txt(output_txt:String);
var ftxt:TextFile; i:Integer;
begin
        //Saving all editable subtitles to a text file
        AssignFile(ftxt, output_txt);
        Rewrite(ftxt);

        Writeln(ftxt, filename);
        Writeln(ftxt, IntToStr(srf_data.Count));

        for i:=0 to srf_data.Count-1 do
        begin
                if TSRFEntry(srf_data[i]).NonEditable = 0 then
                begin
                        Writeln(ftxt, '----------');
                        Writeln(ftxt, IntToStr(i+1));
                        Writeln(ftxt, TSRFEntry(srf_data[i]).CharID);
                        Writeln(ftxt, TSRFEntry(srf_data[i]).Subtitle);
                end;
        end;

        CloseFile(ftxt);
        StatusBar1.Panels[0].Text := 'Subtitles successfully exported in '+ExtractFileName(output_txt)+' !';
end;

procedure TForm1.load_subs_txt(input_txt:String);
var ftxt:TextFile; str_buffer:String;
current_line, next_line, sub_current_num:Integer;
begin
        //Loading subtitles from a text file
        AssignFile(ftxt, input_txt);
        Reset(ftxt);

        //Setting variables...
        current_line := 0;
        next_line := 4;
        sub_current_num := 0;

        repeat
                Inc(current_line);
                Readln(ftxt, str_buffer);

                if (current_line = next_line) and (str_buffer <> '') then
                begin
                        sub_current_num := StrToInt(str_buffer);
                end;

                if (current_line = next_line + 2) and (str_buffer <> '') then
                begin
                        TSRFEntry(srf_data[sub_current_num-1]).Subtitle := str_buffer;
                        Inc(next_line, 4);
                end;
        until EOF(ftxt);

        CloseFile(ftxt);
        StatusBar1.Panels[0].Text := 'Subtitles successfully imported from '+ExtractFileName(input_txt)+' !';
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
        OpenDialog1.FileName := '';
        OpenDialog1.Filter := 'SRF file (*.srf)|*.srf';

        if OpenDialog1.Execute then
        begin
                open_srf_file(OpenDialog1.FileName);
        end; 
end;

procedure TForm1.Saveas1Click(Sender: TObject);
begin
        SaveDialog1.FileName := '';
        SaveDialog1.Filter := 'SRF file (*.srf)|*.srf';
        SaveDialog1.DefaultExt := 'srf';

        if SaveDialog1.Execute then
        begin
                save_srf_file(SaveDialog1.FileName);
        end;
end;

procedure TForm1.Exportsubstotxt1Click(Sender: TObject);
begin
        SaveDialog1.FileName := '';
        SaveDialog1.Filter := 'Text file (*.txt)|*.txt';
        SaveDialog1.DefaultExt := 'txt';

        if SaveDialog1.Execute then
        begin
                save_subs_txt(SaveDialog1.FileName);
        end;
end;

procedure TForm1.Importsubsfromtxt1Click(Sender: TObject);
begin
        OpenDialog1.FileName := '';
        OpenDialog1.Filter := 'Text file (*.txt)|*.txt';

        if OpenDialog1.Execute then
        begin
                load_subs_txt(OpenDialog1.FileName);
        end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
        form_disabled(true);
        Exportsubstotxt1.Enabled := False;
        Importsubsfromtxt1.Enabled := False;
        Saveas1.Enabled := False;
        sub_memo.ReadOnly := True;
        debug_memo.ReadOnly := True;
        copy_no_mod.Enabled := False;

        load_charlist;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
        if (ListBox1.Items.Count > 0) and (ListBox1.ItemIndex > -1) then
        begin
                no_edit := 1;

                header_edit.Text := 'CHID';
                chid_len_edit.Text := IntToStr(Length(TSRFEntry(srf_data[ListBox1.ItemIndex]).CharID));
                chid_edit.Text := TSRFEntry(srf_data[ListBox1.ItemIndex]).CharID;

                if TSRFEntry(srf_data[ListBox1.ItemIndex]).NonEditable = 0 then
                begin
                        sub_memo.Text := TSRFEntry(srf_data[ListBox1.ItemIndex]).Subtitle;

                        //Modifying Form1
                        sub_memo.Enabled := True;
                        header_edit.Enabled := True;
                        chid_len_edit.Enabled := True;
                        chid_edit.Enabled := True;
                        copy_no_mod.Enabled := False;
                        copy_no_mod.Checked := False;
                end
                else
                begin
                        sub_memo.Text := '* No editable subtitle *';

                        //Modifying Form1
                        sub_memo.Enabled := False;
                        header_edit.Enabled := False;
                        chid_len_edit.Enabled := False;
                        chid_edit.Enabled := False;
                        copy_no_mod.Enabled := False;
                        copy_no_mod.Checked := True;
                end;

                debug_memo.Clear;
                debug_memo.Lines.Add('Fixed Block size: '+IntToStr(TSRFEntry(srf_data[ListBox1.ItemIndex]).FixedBlocks.Size)+' bytes');
                debug_memo.Lines.Add('Total section size: n/a');

                no_edit := 0;
        end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        srf_data := TList.Create;
        chars_list := TStringList.Create;
        chars_decimal_list := TIntList.Create;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
        Close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        srf_data.Clear;
        srf_data.Free;
        chars_list.Clear;
        chars_list.Free;
        chars_decimal_list.Clear;
        chars_decimal_list.Free;
end;

procedure TForm1.sub_memoChange(Sender: TObject);
begin
        if no_edit = 0 then
        begin
                TSRFEntry(srf_data[ListBox1.ItemIndex]).Subtitle := sub_memo.Text;
        end;
end;

procedure TForm1.Enablecharsmod1Click(Sender: TObject);
begin
        if Enablecharsmod1.Checked then
        begin
                Enablecharsmod1.Checked := False;
        end
        else
        begin
                Enablecharsmod1.Checked := True;
        end;
end;

end.
