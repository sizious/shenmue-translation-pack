unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, ExtCtrls, ComCtrls, cStreams, XPMan, SCNFEdit;

const
  APP_VERSION = '1.4';
  
type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    input_dir_edit: TEdit;
    browse_input_bt: TButton;
    GroupBox2: TGroupBox;
    output_dir_edit: TEdit;
    browse_output_bt: TButton;
    dissect_bt: TButton;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    XPManifest1: TXPManifest;
    CheckBox1: TCheckBox;
    cbSCNF: TCheckBox;
    procedure browse_input_btClick(Sender: TObject);
    procedure browse_output_btClick(Sender: TObject);
    procedure dissect_btClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    SCNFEditor: TSCNFEditor;
    procedure dissect_file(var ResumeTextFileHandle: TextFile;
      var ResumeCsvHandle: TextFile; filename, out_dir: string; OnlyResume: Boolean);
    procedure ChangeApplicationState(Idle: Boolean);
    function GetFilesCount(Folder, WildCard: string): Integer;
    //function null_bytes_length(data_size:Integer): Integer;
    procedure dissect_humans(in_dir, out_dir:String; OnlyResume, OnlySCNF: Boolean);
    procedure GetCharactersID(FileName: TFileName; var ChrID1, ChrID2: string);
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

uses
  config, ScnfUtil;
  
{$R *.dfm}

function IsFileValidScnf(const FileName: TFileName): Boolean;
const
  PAKS_SIGN = 'PAKS'; // Global "PKS" file sign
var
  F: File;
  Buf: array[0..4] of Char;
  intBuf: Integer;
begin
  Result := False;

  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  // Scanning the current file to see if it is a valid SCNF file
  try
    Seek(F, 0);
    BlockRead(F, Buf, SizeOf(Buf)); // Reading file header
    Buf[4] := #0;

    //Verifying if it's a valid PAKS file
    if PAKS_SIGN = PChar(@Buf) then begin
      Seek(F, 24);
      BlockRead(F, intBuf, SizeOf(intBuf));
      // Verifying subtitle presence
      if intBuf > 1 then begin
        Result := True;
      end;
    end;
  finally
    CloseFile(F);
  end;
end;

function TForm1.GetFilesCount(Folder, WildCard: string): Integer;
var
  intFound: Integer;
  SearchRec: TSearchRec;
begin
  Result := 0;
  if (Folder <> '') and (Folder[Length(Folder)] <> '\') then
    Folder := Folder + '\';
  intFound := FindFirst(Folder + WildCard, faAnyFile, SearchRec);
  while (intFound = 0) do
  begin
    if not (SearchRec.Attr and faDirectory = faDirectory) then
      Inc(Result);
    intFound := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end;
{
function TForm1.null_bytes_length(data_size:Integer): Integer;
var current_num, total_null_bytes:Integer;
begin
        //Finding the correct number of null bytes after file data
        current_num := 0;
        total_null_bytes := 32;

        while current_num <> data_size do
        begin
                if total_null_bytes = 1 then
                begin
                        total_null_bytes := 32;
                end
                else
                begin
                        Dec(total_null_bytes);
                end;

                Inc(current_num, 1);
        end;

        Result := total_null_bytes;
end;
}

procedure TForm1.GetCharactersID(FileName: TFileName; var ChrID1, ChrID2: string);
var
  F: File;
  Buf: array[0..4] of Char;

begin
  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  try
    Seek(F, FileSize(F)-20);
    BlockRead(F, Buf, SizeOf(Buf));
    Buf[4] := #0;
    ChrID1 := PChar(@Buf);

    Seek(F, FileSize(F)-40);
    BlockRead(F, Buf, SizeOf(Buf));
    Buf[4] := #0;
    ChrID2 := PChar(@Buf);
  finally
    CloseFile(F);
  end;
end;

procedure TForm1.dissect_file(var ResumeTextFileHandle: TextFile;
  var ResumeCsvHandle: TextFile; filename, out_dir: string; OnlyResume: Boolean);
var
  finput, foutput:TFileStream;
  str_buffer:String;
  int_buffer, ftr_offset, current_offset, null_cnt:Integer;
  ftxt:TextFile; first_section:Boolean;
  fname: string;

  chrID1, chrID2: string;
  SubtitlesCount: string;

begin
  if not IsFileValidScnf(filename) then Exit;

  GetCharactersID(filename, chrID1, chrID2);

  //Resetting variable
  current_offset := 24;
  null_cnt := 0;
  first_section := True;

  //Creating filestream & reading value
  try
  finput := TFileStream.Create(filename, fsomRead);
  finput.Position := current_offset;
  int_buffer := finput.Reader.ReadLongInt;

  //Verifying subtitles presence
  if int_buffer > 1 then
  begin
          //Creating folder to save files
          fname := ExtractFileName(ChangeFileExt(filename,''));

          if not OnlyResume then begin
            out_dir := IncludeTrailingPathDelimiter(out_dir) + fname + '\';

            if DirectoryExists(out_dir) = False then
            begin
                    CreateDir(out_dir);
                    while DirectoryExists(out_dir) <> True do
                    begin
                            Sleep(0);
                    end;
            end;
          end;

          //Reading footer offset
          Inc(current_offset, 4);
          finput.Position := current_offset;
          ftr_offset := finput.Reader.ReadLongInt;
          Inc(ftr_offset, 16);

          //Seeking to first section
          Inc(current_offset, 4);
          finput.Position := current_offset;

          //Creating txt file & writing infos
          if not OnlyResume then begin
            AssignFile(ftxt, out_dir+fname+'.txt');
            Rewrite(ftxt);
            while FileExists(out_dir+fname+'.txt') <> True do
            begin                                                         
                  Sleep(0);
            end;
            WriteLn(ftxt, 'File: '+ExtractFileName(filename));
            WriteLn(ftxt, 'Unknown number: '+IntToStr(int_buffer));
          end;

          // Writing subtitles count
          SubtitlesCount := '';
          if SCNFEditor.LoadFromFile(filename) then
            SubtitlesCount := IntToStr(SCNFEditor.Subtitles.Count);

          // write to resume file
          Write(ResumeTextFileHandle, ExtractFileName(filename), ': ',
            'CharID #1: ', chrID1, ', CharID #2: ', chrID2, ', Subs Count: ',
            SubtitlesCount, ', Sections: ');
          Write(ResumeCsvHandle,  ExtractFileName(filename), ';', chrID1, ';', chrID2,
          ';', SubtitlesCount);

          //Loop to read each section until footer is reached
          while current_offset <> ftr_offset do
          begin
                  //Reading section name & seeking to section length
                  str_buffer := Trim(finput.ReadStr(4));

                  if Length(str_buffer) = 4 then
                  begin
                          if first_section = False then
                          begin
                                  //Writing null bytes count for previous section
                                  if not OnlyResume then WriteLn(ftxt, '-- Null bytes: '+IntToStr(null_cnt));
                          end;

                          finput.Position := current_offset + 4;

                          //Reading section length & seeking back to section start
                          int_buffer := finput.Reader.ReadLongInt;
                          finput.Position := current_offset;

                          //Creating output filestream & closing it when finished
                          if not OnlyResume then begin
                            foutput := TFileStream.Create(out_dir+str_buffer+'.BIN', fsomCreate);
                            finput.WriteTo(foutput, 1, int_buffer);
                            foutput.Free;

                            //Writing infos to txt
                            WriteLn(ftxt, sLineBreak+'Section name: '+str_buffer);
                            WriteLn(ftxt, '-- Size: '+IntToStr(int_buffer)+' bytes');
                          end;
                          
                          Write(ResumeTextFileHandle, str_buffer, ' ');
                          Write(ResumeCsvHandle,  ';', str_buffer);

                          //Resetting null bytes count
                          null_cnt := 0;

                          //Seeking to the next section
                          Inc(current_offset, int_buffer);
                          finput.Position := current_offset;

                          first_section := False;
                          
                  end
                  else
                  begin
                          Inc(null_cnt);
                          Inc(current_offset);
                          finput.Position := current_offset;
                          if null_cnt > 255 then
                            Break; // empêche de tourner en boucle
                          
                  end;
          end;

          //Writing null bytes count for last section
          if not OnlyResume then begin
            WriteLn(ftxt, '-- Null bytes: '+IntToStr(null_cnt));

            //Writing footer to a file
            foutput := TFileStream.Create(out_dir+'\FOOTER.BIN', fsomCreate);
            finput.WriteTo(foutput, 1, finput.Size-current_offset);
            foutput.Free;

            //Closing txt file
            CloseFile(ftxt);
          end;

          WriteLn(ResumeTextFileHandle, '');
          WriteLn(ResumeCsvHandle, '');
  end;

  //Clearing and modifying variables
  finput.Free;
  except
    on E: Exception do
      MessageDlg(ExtractFileName(filename) + ': ' +E.Message, mtError, [mbOk], 0); //Self.StatusBar1.SimpleText := E.Message;
  end;
end;

procedure TForm1.dissect_humans(in_dir, out_dir:String; OnlyResume, OnlySCNF: Boolean);
var
  searchResult: TSearchRec;
  ResumeFileHandle: TextFile;
  ResumeCsvHandle: TextFile;
  filename: TFileName;

begin
  ChangeApplicationState(False);

  in_dir := IncludeTrailingPathDelimiter(in_dir);
  out_dir := IncludeTrailingPathDelimiter(out_dir);

  // def le max
  Self.ProgressBar1.Max := GetFilesCount(in_dir, '*.*');

  AssignFile(ResumeFileHandle, out_dir + 'resume.txt');
  Rewrite(ResumeFileHandle);
  AssignFile(ResumeCsvHandle, out_dir + 'resume.csv');
  ReWrite(ResumeCsvHandle);
  while FileExists(out_dir + 'resume.txt') <> True do
  begin
    Sleep(0);
  end;

  WriteLn(ResumeFileHandle, Caption);
  WriteLn(ResumeFileHandle, 'Source dir: ', in_dir);
  WriteLn(ResumeFileHandle, 'Output dir: ', out_dir, #13#10);

  if OnlySCNF then
    Write(ResumeCsvHandle, 'FileName;Char ID #1;Char ID #2;Real CharID;Subtitles Count;Game Version')
  else
    Write(ResumeCsvHandle, 'FileName;Char ID #1;Char ID #2;Subtitles Count');

  if FindFirst(in_dir + '*.*', faAnyFile, searchResult) = 0 then
  begin
    repeat
      if not (SearchResult.Attr and faDirectory = faDirectory) then begin
        StatusBar1.Panels[0].Text := 'Parsing and dissecting... '+SearchResult.Name;

        filename := in_dir + SearchResult.Name;

        if not OnlySCNF then begin
          WriteLn(ResumeCsvHandle, 'Section #1;Section #2;Section #3;Section #4;Section #5');
          dissect_file(ResumeFileHandle, ResumeCsvHandle, filename, out_dir,
            OnlyResume)
        end else begin
          if SCNFEditor.LoadFromFile(filename) then begin

            WriteLn(ResumeFileHandle, ExtractFileName(filename), ': ',
              'CharID #1: ', SCNFEditor.Sections[0].CharID, ', CharID #2: ',
                SCNFEditor.Sections[1].CharID, ', Real CharID: ', SCNFEditor.CharacterID,
                ', Subs Count: ', SCNFEditor.Subtitles.Count, ', Game Version: ', GameVersionToFriendlyString(SCNFEditor.GameVersion));

            Write(ResumeCsvHandle,
              sLineBreak,
              ExtractFileName(filename), ';',
              SCNFEditor.Sections[0].CharID, ';',
              SCNFEditor.Sections[1].CharID, ';',
              SCNFEditor.CharacterID, ';',
              SCNFEditor.Subtitles.Count, ';',
              GameVersionToFriendlyString(SCNFEditor.GameVersion));
          end;
        end;          

        Self.ProgressBar1.Position := Self.ProgressBar1.Position + 1;
        Panel1.Caption := IntToStr(Round((100*ProgressBar1.Position)/ProgressBar1.Max))+'%';
        Application.ProcessMessages;
      end;
    until FindNext(searchResult) <> 0;

    // Must free up resources used by these successful finds
    FindClose(searchResult);
  end;

  CloseFile(ResumeFileHandle);
  CloseFile(ResumeCsvHandle);
  
  ChangeApplicationState(True);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveConfig;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  Caption := StringReplace(Caption, '#VERSION#', APP_VERSION, [rfReplaceAll]);
  SCNFEditor := TSCNFEditor.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SCNFEditor.Free;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  LoadConfig;
end;

procedure TForm1.browse_input_btClick(Sender: TObject);
var selected_dir:String;
begin
  selected_dir := input_dir_edit.Text;
  if not DirectoryExists(selected_dir) then selected_dir := '';
  
        if SelectDirectory('Select input folder', '*', selected_dir) then
        begin
                input_dir_edit.Text := selected_dir;
        end;
end;

procedure TForm1.browse_output_btClick(Sender: TObject);
var selected_dir:String;
begin
        if SelectDirectory('Select output folder', '*', selected_dir) then
        begin
                output_dir_edit.Text := selected_dir;
        end;
end;

procedure TForm1.ChangeApplicationState(Idle: Boolean);
begin
  cbSCNF.Enabled := Idle;
  input_dir_edit.Enabled := Idle;
  browse_input_bt.Enabled := Idle;
  output_dir_edit.Enabled := Idle;
  browse_output_bt.Enabled := Idle;
  dissect_bt.Enabled := Idle;

  if Idle then
    StatusBar1.Panels[0].Text := 'Dissection completed !'
  else begin
    StatusBar1.Panels[0].Text := '';
    Self.ProgressBar1.Position := 0;
    Self.Panel1.Caption := '0%';
  end;
end;

procedure TForm1.dissect_btClick(Sender: TObject);
begin
        if DirectoryExists(input_dir_edit.Text) and DirectoryExists(output_dir_edit.Text) then
        begin
                dissect_humans(input_dir_edit.Text, output_dir_edit.Text,
                  CheckBox1.Checked, cbSCNF.Checked);
        end
        else
        begin
                MessageDlg('Input or output folder not set properly.', mtError, [mbOk], 0);
        end;
end;

end.
