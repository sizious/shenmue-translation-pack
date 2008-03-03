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
    function deprocess_char(in_str:String; in_int:Integer): String;
    function mod_markers(add_marks:Boolean; in_str:String): String;
    procedure chars_count(in_str:String);
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

//This function count the number of occurence of the defined substring
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

function TForm1.deprocess_char(in_str:String; in_int:Integer): String;
var i:Integer;
begin
        //Inverting accentuated characters if needed
        Result := '';

        for i:=0 to chars_decimal_list.Count-1 do
        begin
                if chars_decimal_list[i] = in_int then
                begin
                        Result := chars_list[i];
                        Break;
                end
                else
                begin
                        Result := in_str;
                end;
        end;
end;

function TForm1.mod_markers(add_marks:Boolean; in_str:String): String;
var i, markers_num:Integer; marker_in, marker_out, temp_str:String;
begin
        //Adding new line marker or deleting it...
        if add_marks then
        begin
                marker_in := '¡õ';
                marker_out := sLineBreak;
        end
        else
        begin
                marker_in := sLineBreak;
                marker_out := '¡õ';
        end;

        markers_num := CountPos(marker_out, in_str);
        temp_str := '';

        for i:=0 to markers_num do
        begin
                if i < markers_num then
                begin
                        temp_str := temp_str + Trim(parse_section(marker_out, in_str, i)) + marker_in;
                end
                else
                begin
                        temp_str := temp_str + Trim(parse_section(marker_out, in_str, i));
                end;
        end;

        Result := temp_str;
end;

procedure TForm1.chars_count(in_str:String);
var i, line_num, substr_num, line_count:Integer; line_txt:String;
begin
        //Counting characters according to text length and markers
        line_num := CountPos(sLineBreak, in_str);
        for i:=0 to line_num do
        begin
                line_txt := Trim(parse_section(sLineBreak, in_str, i));
                line_count := Length(line_txt);

                if line_count > 0 then
                begin
                        substr_num := CountPos('=@', line_txt);
                        line_count := line_count - (substr_num*2) + (substr_num*3);
                        debug_memo.Lines.Add('Line '+IntToStr(i+1)+': '+IntToStr(line_count)+' characters'); 
                end;
        end;

end;

procedure TForm1.open_srf_file(input_srf:String);
var fsrf:TFileStream; byte_buffer:Byte;
i, current_offset, int_buffer, srf_size, sub_count:Integer;
str_buffer, temp_sub_txt, temp_str:String;
begin
        //Creating the file stream & other variables
        fsrf := TFileStream.Create(input_srf, fsomRead);
        srf_size := fsrf.Size;

        srf_data.Clear;
        sub_chars_list.Clear;
        sub_decimal_list.Clear;
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

                        //Clearing variables:
                        sub_chars_list.Clear;
                        sub_decimal_list.Clear;

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
                                for i:=0 to (int_buffer-4)-1 do
                                begin
                                        fsrf.Read(byte_buffer, 1);
                                        srf_infos.FixedBlocks.Write(byte_buffer, 1);
                                end;

                                Inc(current_offset, int_buffer-4);
                                fsrf.Position := current_offset;
                        end;

                        if srf_infos.NonEditable = 0 then
                        begin
                                //Reading subtitle length & seeking to subtitle text
                                int_buffer := fsrf.Reader.ReadLongInt;
                                Inc(current_offset, 4);
                                fsrf.Position := current_offset;

                                //Reading subtitle text
                                for i:=0 to (int_buffer-8)-1 do
                                begin
                                        sub_decimal_list.Add(fsrf.ReadByte);
                                        fsrf.Position := fsrf.Position - 1;
                                        sub_chars_list.Add(fsrf.ReadStr(1));
                                end;

                                //Deprocessing accentuated characters
                                temp_sub_txt := '';
                                for i:=0 to sub_chars_list.Count-1 do
                                begin
                                        if ((sub_chars_list[i] = '¡') and (sub_chars_list[i+1] = 'õ')) or ((sub_chars_list[i] = 'õ') and (sub_chars_list[i-1] = '¡')) then
                                        begin
                                                temp_str := sub_chars_list[i];
                                        end
                                        else
                                        begin
                                                temp_str := deprocess_char(sub_chars_list[i], sub_decimal_list[i]);
                                        end;

                                        //Adding characters to a temp variable
                                        temp_sub_txt := temp_sub_txt + temp_str;
                                end;

                                //Replacing new line marker (¡õ) by sLineBreak
                                srf_infos.Subtitle := mod_markers(False, temp_sub_txt);

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
                                for i:=0 to int_buffer-1 do
                                begin
                                        fsrf.Read(byte_buffer, 1);
                                        srf_infos.FixedBlocks.Write(byte_buffer, 1);
                                end;

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
                                for i:=0 to int_buffer-1 do
                                begin
                                        fsrf.Read(byte_buffer, 1);
                                        srf_infos.FixedBlocks.Write(byte_buffer, 1);
                                end;

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
var fsrf:TFileStream; byte_buffer:Byte; temp_sub:String;
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
                //Reverting subtitle text back to the original, with markers
                temp_sub := mod_markers(True, TSRFEntry(srf_data[i]).Subtitle);

                //Resetting variables
                sub_total_length := 0;

                //Calculating the length of the whole subtitle section
                Inc(sub_total_length, 8); //Header + Character ID length (LongInt)
                Inc(sub_total_length, Length(TSRFEntry(srf_data[i]).CharID)); //Character ID text length

                if TSRFEntry(srf_data[i]).NonEditable = 0 then
                begin
                        Inc(sub_total_length, 4); //Subtitle length (LongInt)
                        Inc(sub_total_length, Length(temp_sub) + null_bytes_length(Length(temp_sub))); //Subtitle text length + following null bytes
                end;

                Inc(sub_total_length, TSRFEntry(srf_data[i]).FixedBlocks.Size); // Non editable subtitle bytes, 'EXTD' & 'CLIP' length
                Inc(sub_total_length, 8); //Footer: 'ENDC' + 4 null bytes

                //Checking remaining space in the block

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
                        fsrf.Writer.WriteLongInt(Length(temp_sub) + null_bytes_length(Length(temp_sub)) + 8);

                        //Checking if the characters modification is enabled
                        if Enablecharsmod1.Checked then
                        begin
                                for i2:=1 to Length(temp_sub) do
                                begin
                                        //Sending the character to 'process_char'...
                                        if ((temp_sub[i2] = '¡') and (temp_sub[i2+1] = 'õ')) or ((temp_sub[i2] = 'õ') and (temp_sub[i2-1] = '¡')) then
                                        begin
                                                temp_int := -1;
                                        end
                                        else
                                        begin
                                                temp_int := process_char(temp_sub[i2]);
                                        end;

                                        //Writing in the SRF file
                                        if temp_int <> -1 then
                                        begin
                                                fsrf.Writer.WriteByte(temp_int);
                                        end
                                        else
                                        begin
                                                fsrf.WriteStr(temp_sub[i2]);
                                        end;
                                end;
                        end
                        else
                        begin
                                fsrf.WriteStr(temp_sub);
                        end;

                        for i2:=0 to null_bytes_length(Length(temp_sub))-1 do
                        begin
                                fsrf.Writer.WriteByte(0);
                        end;
                end;

                TSRFEntry(srf_data[i]).FixedBlocks.Seek(0, soFromBeginning);
                for i2:=0 to TSRFEntry(srf_data[i]).FixedBlocks.Size-1 do
                begin
                        TSRFEntry(srf_data[i]).FixedBlocks.Read(byte_buffer, 1);
                        fsrf.Write(byte_buffer, 1);
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
                        Writeln(ftxt, mod_markers(True, TSRFEntry(srf_data[i]).Subtitle));
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
                        TSRFEntry(srf_data[sub_current_num-1]).Subtitle := mod_markers(False, str_buffer);
                        Inc(next_line, 4);
                end;
        until EOF(ftxt);

        CloseFile(ftxt);

        //Modifying Form1
        StatusBar1.Panels[0].Text := 'Subtitles successfully imported from '+ExtractFileName(input_txt)+' !';
        ListBox1Click(Form1);
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
                debug_memo.Lines.Add('Header size: '+IntToStr(8+Length(TSRFEntry(srf_data[ListBox1.ItemIndex]).CharID))+' bytes');
                debug_memo.Lines.Add('Fixed Block size: '+IntToStr(TSRFEntry(srf_data[ListBox1.ItemIndex]).FixedBlocks.Size)+' bytes');
                debug_memo.Lines.Add('Total section size (estimate): n/a');

                if TSRFEntry(srf_data[ListBox1.ItemIndex]).NonEditable = 0 then
                begin
                        debug_memo.Lines.Add('');
                        chars_count(TSRFEntry(srf_data[ListBox1.ItemIndex]).Subtitle);
                end;

                no_edit := 0;
        end;
end;

procedure TForm1.sub_memoChange(Sender: TObject);
begin
        if no_edit = 0 then
        begin
                TSRFEntry(srf_data[ListBox1.ItemIndex]).Subtitle := sub_memo.Text;
                ListBox1.OnClick(sub_memo);
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

procedure TForm1.Importsubsfromtxt1Click(Sender: TObject);
begin
        OpenDialog1.FileName := '';
        OpenDialog1.Filter := 'Text file (*.txt)|*.txt';

        if OpenDialog1.Execute then
        begin
                load_subs_txt(OpenDialog1.FileName);
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

procedure TForm1.Exit1Click(Sender: TObject);
begin
        Close;
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

procedure TForm1.Open1Click(Sender: TObject);
begin
        OpenDialog1.FileName := '';
        OpenDialog1.Filter := 'SRF file (*.srf)|*.srf';

        if OpenDialog1.Execute then
        begin
                open_srf_file(OpenDialog1.FileName);
        end; 
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        srf_data.Clear;
        srf_data.Free;
        chars_list.Clear;
        chars_list.Free;
        chars_decimal_list.Clear;
        chars_decimal_list.Free;
        sub_chars_list.Clear;
        sub_chars_list.Free;
        sub_decimal_list.Clear;
        sub_decimal_list.Free;
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

procedure TForm1.FormCreate(Sender: TObject);
begin
        //Setting & creating variables
        DoubleBuffered := True;
        srf_data := TList.Create;
        chars_list := TStringList.Create;
        chars_decimal_list := TIntList.Create;
        sub_chars_list := TStringList.Create;
        sub_decimal_list := TIntList.Create;
end;

end.
