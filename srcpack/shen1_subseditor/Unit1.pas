//    This file is part of Shenmue I Subtitles Editor.
//
//    Shenmue I Subtitles Editor is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Shenmue I Subtitles Editor is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue I Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, cStreams, UIntList;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Saveas1: TMenuItem;
    Exit1: TMenuItem;
    ools1: TMenuItem;
    Exportmenu1: TMenuItem;
    Importmenu1: TMenuItem;
    CharsModmenu1: TMenuItem;
    StatusBar1: TStatusBar;
    subslist_grpbox: TGroupBox;
    ListBox1: TListBox;
    values_grpbox: TGroupBox;
    char_lbl: TLabel;
    char_edit: TEdit;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    nomod_checkbx: TCheckBox;
    text_memo: TMemo;
    debug_memo: TMemo;
    text_lbl: TLabel;
    debug_lbl: TLabel;
    procedure Exit1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Exportmenu1Click(Sender: TObject);
    procedure Importmenu1Click(Sender: TObject);
    procedure CharsModmenu1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure text_memoChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    function null_bytes_length(sub_txt_length:Integer): Integer;
    procedure open_srf_file(in_srf:String);
    procedure save_srf_file(out_srf:String);
    procedure save_subs_txt(out_txt:String);
    procedure load_subs_txt(in_txt:String);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    no_memo_edit:Boolean;
    filename:String;
  end;

var
  Form1: TForm1;

implementation
uses variables, USRFEntry;
{$R *.dfm}

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

procedure TForm1.open_srf_file(in_srf:String);
var fsrf:TFileStream; str_buffer:String;
i, current_offset, int_buffer:Integer;
byte_buffer:Byte;
begin
        //Modifying Form1
        ListBox1.Clear;
        char_edit.Clear;
        text_memo.Clear;
        debug_memo.Clear;
        Open1.Enabled := False;
        Saveas1.Enabled := False;
        Exportmenu1.Enabled := False;
        Importmenu1.Enabled := False;
        ListBox1.Enabled := False;
        char_edit.Enabled := False;
        text_memo.Enabled := False;
        debug_memo.Enabled := False;


        //Creating & setting variable
        fsrf := TFileStream.Create(in_srf, fsomRead);
        srf_data.Clear;

        current_offset := 0;
        fsrf.Position := current_offset;
        
        while current_offset <> fsrf.Size do
        begin
                //Reading first value of a subtitle section
                int_buffer := fsrf.Reader.ReadLongInt;

                if int_buffer = 8 then
                begin
                        //Creating variable
                        srf_infos := TSRFEntry.Create;

                        //Modifying srf_infos
                        srf_infos.FixedBlocks := TMemoryStream.Create;
                        srf_infos.NonEditable := False;

                        //Seeking to and reading character name
                        Inc(current_offset, 4);
                        fsrf.Position := current_offset;
                        str_buffer := Trim(fsrf.ReadStr(int_buffer-4));
                        srf_infos.CharID := str_buffer;

                        //Seeking to and reading subtitle text, if present
                        Inc(current_offset, int_buffer-4);
                        fsrf.Position := current_offset;
                        int_buffer := fsrf.Reader.ReadLongInt;

                        //Verifying subtitle length
                        if int_buffer > 4 then
                        begin
                                //There is subtitle text, so...
                                Inc(current_offset, 4);
                                fsrf.Position := current_offset;
                                str_buffer := Trim(fsrf.ReadStr(int_buffer-4));
                                srf_infos.Subtitle := str_buffer;
                                Inc(current_offset, int_buffer-4);
                                fsrf.Position := current_offset;
                        end
                        else
                        begin
                                srf_infos.NonEditable := True;
                                Inc(current_offset, 4);
                                fsrf.Position := current_offset;
                        end;

                        //Writing data to the MemoryStream
                        int_buffer := fsrf.Reader.ReadLongInt;
                        Inc(current_offset, 4);
                        fsrf.Position := current_offset;

                        for i:=0 to (int_buffer-4)-1 do
                        begin
                                fsrf.Reader.Read(byte_buffer, 1);
                                srf_infos.FixedBlocks.Write(byte_buffer, 1);
                        end;

                        //Seeking to the end of the data block
                        Inc(current_offset, int_buffer-4);
                        fsrf.Position := current_offset;

                        srf_data.Add(srf_infos);
                end
                else
                begin
                        Inc(current_offset);
                        fsrf.Position := current_offset;
                end;
        end;

        //Closing the file stream
        fsrf.Free;

        //Keeping the file name in a variable
        filename := ExtractFileName(in_srf);

        if srf_data.Count > 0 then
        begin
                //Filling ListBox1
                for i:=0 to srf_data.Count-1 do
                begin
                        ListBox1.Items.Add('Subtitle #'+IntToStr(i+1))
                end;

                //Modifying Form1
                Form1.Caption := 'Shenmue 1 Subtitles Editor v1 - '+filename;
                StatusBar1.Panels[0].Text := filename+' opened successfully !';

                Open1.Enabled := True;
                Saveas1.Enabled := True;
                Exportmenu1.Enabled := True;
                Importmenu1.Enabled := True;
                ListBox1.Enabled := True;
                char_edit.Enabled := True;
                text_memo.Enabled := True;
                debug_memo.Enabled := True;
        end
        else
        begin
                //Modifying Form1
                Open1.Enabled := True;
        end;
end;

procedure TForm1.save_srf_file(out_srf:String);
var fsrf:TFileStream; byte_buffer:Byte;
i, i2, block_size, block_num, sub_total_length:Integer;
begin
        //Modifying Form1
        Open1.Enabled := False;
        Saveas1.Enabled := False;
        Exportmenu1.Enabled := False;
        Importmenu1.Enabled := False;
        ListBox1.Enabled := False;
        char_edit.Enabled := False;
        text_memo.Enabled := False;
        debug_memo.Enabled := False;

        //Creating & setting variables
        fsrf := TFileStream.Create(out_srf, fsomCreate);
        block_size := 2048;
        block_num := 1;

        //Main loop
        for i:=0 to srf_data.Count-1 do
        begin
                //Resetting variable
                sub_total_length := 0;

                //Calculating the size of the whole subtitle section
                Inc(sub_total_length, 12+Length(TSRFEntry(srf_data[i]).CharID)); // 3 x 4 bytes + Length of the character name
                Inc(sub_total_length, TSRFEntry(srf_data[i]).FixedBlocks.Size); //FixedBlocks data size

                if TSRFEntry(srf_data[i]).NonEditable = False then
                begin
                        Inc(sub_total_length, Length(TSRFEntry(srf_data[i]).Subtitle)+null_bytes_length(Length(TSRFEntry(srf_data[i]).Subtitle)))
                end;

                //Checking remaining space in the block
                if (fsrf.Size+sub_total_length) > (block_size*block_num) then
                begin
                        for i2:=0 to ((block_size*block_num)-fsrf.Size)-1 do
                        begin
                                fsrf.Writer.WriteByte(0);
                        end;

                        Inc(block_num);
                end;

                //Writing the whole subtitle section
                fsrf.Writer.WriteLongInt(4+Length(TSRFEntry(srf_data[i]).CharID));

                //Verifying if there's a CharID
                if TSRFEntry(srf_data[i]).CharID <> '' then
                begin
                        fsrf.WriteStr(TSRFEntry(srf_data[i]).CharID);
                end
                else
                begin
                        fsrf.Writer.WriteLongInt(0);
                end;

                //Writing the subtitle, if present
                if TSRFEntry(srf_data[i]).NonEditable then
                begin
                        fsrf.Writer.WriteLongInt(4);
                end
                else
                begin
                        fsrf.Writer.WriteLongInt(4+Length(TSRFEntry(srf_data[i]).Subtitle)+null_bytes_length(Length(TSRFEntry(srf_data[i]).Subtitle)));
                        fsrf.WriteStr(TSRFEntry(srf_data[i]).Subtitle);

                        for i2:=0 to null_bytes_length(Length(TSRFEntry(srf_data[i]).Subtitle))-1 do
                        begin
                                fsrf.Writer.WriteByte(0);
                        end;
                end;

                //Writing 'FixedBlocks' content
                fsrf.Writer.WriteLongInt(4+TSRFEntry(srf_data[i]).FixedBlocks.Size);
                TSRFEntry(srf_data[i]).FixedBlocks.Seek(0, soFromBeginning);

                for i2:=0 to TSRFEntry(srf_data[i]).FixedBlocks.Size-1 do
                begin
                        TSRFEntry(srf_data[i]).FixedBlocks.Read(byte_buffer, 1);
                        fsrf.Write(byte_buffer, 1);
                end;
        end;

        //Closing the file stream
        fsrf.Free;

        //Keeping the file name in a variable
        filename := ExtractFileName(out_srf);

        //Modifying Form1
        Form1.Caption := 'Shenmue 1 Subtitles Editor v1 - '+filename;
        StatusBar1.Panels[0].Text := filename+' saved successfully !';
        Open1.Enabled := True;
        Saveas1.Enabled := True;
        Exportmenu1.Enabled := True;
        Importmenu1.Enabled := True;
        ListBox1.Enabled := True;
        ListBox1Click(Saveas1);
end;

procedure TForm1.save_subs_txt(out_txt:String);
var ftxt:TextFile; i:Integer;
begin
        //Saving all editable subtitle to a text file
        AssignFile(ftxt, out_txt);
        Rewrite(ftxt);

        Writeln(ftxt, filename);
        Writeln(ftxt, IntToStr(srf_data.Count));

        for i:=0 to srf_data.Count-1 do
        begin
                if TSRFEntry(srf_data[i]).NonEditable = False then
                begin
                        Writeln(ftxt, '----------');
                        Writeln(ftxt, IntToStr(i+1));
                        Writeln(ftxt, TSRFEntry(srf_data[i]).CharID);
                        Writeln(ftxt, TSRFEntry(srf_data[i]).Subtitle);
                end;
        end;

        CloseFile(ftxt);
        StatusBar1.Panels[0].Text := 'Subtitles successfully exported in '+ExtractFileName(out_txt)+' !';
end;

procedure TForm1.load_subs_txt(in_txt:String);
var ftxt:TextFile; str_buffer:String;
current_line, next_line, sub_current_num:Integer;
begin
        //Loading subtitles from a text file
        AssignFile(ftxt, in_txt);
        Reset(ftxt);

        //Setting variables
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

        //Modifying Form1
        StatusBar1.Panels[0].Text := 'Subtitles successfully imported from '+ExtractFileName(in_txt)+' !';
        ListBox1Click(Importmenu1);
end;

procedure TForm1.text_memoChange(Sender: TObject);
begin
        if no_memo_edit = False then
        begin
                TSRFEntry(srf_data[ListBox1.ItemIndex]).Subtitle := text_memo.Text;
        end;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var subtotal:Integer; char_no_txt:Boolean;
begin
        if (ListBox1.Items.Count > 0) and (ListBox1.ItemIndex <> -1) then
        begin
                no_memo_edit := True;

                //Displaying character name
                if TSRFEntry(srf_data[ListBox1.ItemIndex]).CharID = '' then
                begin
                        char_edit.Text := '(no identifier)';
                end
                else
                begin
                        char_edit.Text := TSRFEntry(srf_data[ListBox1.ItemIndex]).CharID;
                end;

                //Verifying if the subtitle is editable
                if TSRFEntry(srf_data[ListBox1.ItemIndex]).NonEditable = False then
                begin
                        text_memo.Text := TSRFEntry(srf_data[ListBox1.ItemIndex]).Subtitle;

                        //Modifying Form1
                        char_edit.Enabled := True;
                        text_memo.Enabled := True;
                        debug_memo.Enabled := True;
                        nomod_checkbx.Checked := False;

                        //Calculating sub-total:
                        subtotal := 12+Length(TSRFEntry(srf_data[ListBox1.ItemIndex]).CharID)+Length(TSRFEntry(srf_data[ListBox1.ItemIndex]).Subtitle)+null_bytes_length(Length(TSRFEntry(srf_data[ListBox1.ItemIndex]).Subtitle))+TSRFEntry(srf_data[ListBox1.ItemIndex]).FixedBlocks.Size;
                end
                else
                begin
                        text_memo.Text := '* No editable subtitle *';

                        //Modifying Form1
                        char_edit.Enabled := False;
                        text_memo.Enabled := False;
                        debug_memo.Enabled := False;
                        nomod_checkbx.Checked := True;

                        //Calculating sub-total
                        subtotal := 12+Length(TSRFEntry(srf_data[ListBox1.ItemIndex]).CharID)+Length(TSRFEntry(srf_data[ListBox1.ItemIndex]).Subtitle)+TSRFEntry(srf_data[ListBox1.ItemIndex]).FixedBlocks.Size;
                end;

                debug_memo.Clear;
                debug_memo.Lines.Add('Fixed Block size: '+IntToStr(TSRFEntry(srf_data[ListBox1.ItemIndex]).FixedBlocks.Size)+' bytes');
                debug_memo.Lines.Add('Sub-total: '+IntToStr(subtotal)+' bytes');
                debug_memo.Lines.Add('Total section size: n/a');

                no_memo_edit := False;
        end
        else
        begin
                char_edit.Enabled := False;
                text_memo.Enabled := False;
                debug_memo.Enabled := False;
        end;
end;

procedure TForm1.CharsModmenu1Click(Sender: TObject);
begin
        if CharsModmenu1.Checked then
        begin
                CharsModmenu1.Checked := False;
        end
        else
        begin
                CharsModmenu1.Checked := True;
        end;
end;

procedure TForm1.Importmenu1Click(Sender: TObject);
begin
        OpenDialog1.Filter := 'Text file (*.txt)|*.txt';
        if OpenDialog1.Execute then
        begin
                load_subs_txt(OpenDialog1.FileName);
        end;
end;

procedure TForm1.Exportmenu1Click(Sender: TObject);
begin
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
        SaveDialog1.Filter := 'SRF file (*.srf)|*.srf';
        SaveDialog1.DefaultExt := 'srf';
        if SaveDialog1.Execute then
        begin
                save_srf_file(SaveDialog1.FileName);
        end;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
        OpenDialog1.Filter := 'SRF file (*.srf)|*.srf';
        if OpenDialog1.Execute then
        begin
                open_srf_file(OpenDialog1.FileName);
        end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
        //Default Form1 display
        Saveas1.Enabled := False;
        Exportmenu1.Enabled := False;
        Importmenu1.Enabled := False;
        CharsModmenu1.Enabled := False;
        ListBox1.Enabled := False;
        char_edit.Enabled := False;
        text_memo.Enabled := False;
        debug_memo.Enabled := False;
        nomod_checkbx.Enabled := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        srf_data := TList.Create;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        srf_data.Clear;
        srf_data.Free;
end;

end.
