unit s2idx;

interface

uses
  SysUtils, Classes, UIntList;

type
  TIDXCreationStartEvent = procedure(const MaxFiles: Integer);
  TIDXStatusEvent = procedure(const Message: string);
  TIDXCreationProgressEvent = procedure();
  TIDXCreationEndEvent = procedure();

  TS2IDXCreator = class
  private
    files_infos: TStringList;
    files_offset,
    files_size,
    srf_list,
    srf_offset,
    current_files_list: TIntList;
    fIDXCreationStart: TIDXCreationStartEvent;
    fIDXStatus: TIDXStatusEvent;
    fIDXCreationEndEvent: TIDXCreationEndEvent;
    fIDXCreationProgressEvent: TIDXCreationProgressEvent;
    function parse_section(substr:String; s:String; n:Integer): string;
  public
    procedure MakeIDX(InputAFS: string; OutputIDX: string); // SHENMUE II
    property OnStart: TIDXCreationStartEvent read fIDXCreationStart write fIDXCreationStart;
    property OnStatus: TIDXStatusEvent read fIDXStatus write fIDXStatus;
    property OnProgress: TIDXCreationProgressEvent read fIDXCreationProgressEvent write fIDXCreationProgressEvent;
    property OnCompleted: TIDXCreationEndEvent read fIDXCreationEndEvent write fIDXCreationEndEvent;
  end;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  cStreams;

//------------------------------------------------------------------------------
  
//This function retrieve the text between the defined substring
function TS2IDXCreator.parse_section(substr:String; s:String; n:Integer): string;
var i:integer;
begin
        S := S + substr;

        for i:=1 to n do
        begin
                S := copy(s, Pos(substr, s) + Length(substr), Length(s) - Pos(substr, s) + Length(substr));
        end;

        Result := Copy(s, 1, pos(substr, s)-1);
end;

//------------------------------------------------------------------------------

// if assigned(PAdeclencherFichier)

procedure TS2IDXCreator.MakeIDX(InputAFS:String; OutputIDX:String);
var
  fafs, fidx:TFileStream;
  buffer:String;
  i, i2, int_buffer, total_files, list_offset, current_offset, srf_size:Integer;
  file_begin, file_end, temp_int:Integer; Check:Boolean;
  delete1, delete2, filename:String;
  
begin
  list_offset := 0;

        //Creating the file stream for input
        fafs := TFileStream.Create(InputAFS, fsomRead);

        //Reading header of the AFS
        buffer := fafs.ReadStr(3);

        //Verify if this is a valid AFS file
        if buffer = 'AFS' then
        begin
                //Creating the file stream for output
                fidx := TFileStream.Create(OutputIDX, fsomCreate);

                //Initializing variables
                files_infos := TStringList.Create;
                files_offset := TIntList.Create;
                files_size := TIntList.Create;
                srf_list := TIntList.Create;
                srf_offset := TIntList.Create;
                current_files_list := TIntList.Create;

                //Modifying Form1
                {CreateIdxBt.Enabled := False;
                BrowseAfsBt.Enabled := False;
                BrowseIdxBt.Enabled := False;
                ProgressBar1.Position := 0;
                Panel1.Caption := '0%';}

                //Seeking to the number of files and reading the value
                fafs.Position := 4;
                total_files := fafs.Reader.ReadLongInt;

                {ProgressBar1.Max := total_files;
                StatusBar1.Panels[0].Text := 'Building files list...';
                Application.ProcessMessages;}
                if Assigned(fIDXCreationStart) then
                  fIDXCreationStart(total_files);
                if Assigned(fIDXStatus) then
                  fIDXStatus('Building files list...');

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

                {StatusBar1.Panels[0].Text := 'Finding SRF files...';
                Application.ProcessMessages;}
                if Assigned(fIDXStatus) then
                  fIDXStatus('Finding SRF files...');

                //Analyzing 'files_infos' variables to find srf file
                for i:=0 to files_infos.Count-1 do
                begin
                        if LowerCase(ExtractFileExt(files_infos[i])) = '.srf' then
                        begin
                                srf_list.Add(i);
                        end;
                end;

                {StatusBar1.Panels[0].Text := 'Parsing SRF files...';
                Application.ProcessMessages;}
                if Assigned(fIDXStatus) then
                  fIDXStatus('Parsing SRF files...');

                //Parsing the srf file - Lite version of the srf parser
                //of Shenmue II Subtitles Editor v4 & up
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
                                buffer := fafs.ReadStr(4);
                                if buffer = 'CHID' then
                                begin
                                        srf_offset.Add((fafs.Position-4) - files_offset[srf_list[i]]);

                                        //Continue throught the file to the next 'CHID'
                                        //Skip the header
                                        Inc(current_offset, 4);
                                        fafs.Position := current_offset;
                                        //Skip the Character ID
                                        int_buffer := fafs.Reader.ReadLongInt;
                                        Inc(current_offset, int_buffer);
                                        fafs.Position := current_offset;
                                        //Skip subtitle text or data
                                        int_buffer := fafs.Reader.ReadLongInt;
                                        Inc(current_offset, int_buffer);
                                        fafs.Position := current_offset;
                                        //Skip 'EXTD' section
                                        int_buffer := fafs.Reader.ReadLongInt;
                                        Inc(current_offset, int_buffer);
                                        fafs.Position := current_offset;
                                        //Skip 'CLIP' & 'ENDC' section
                                        int_buffer := fafs.Reader.ReadLongInt;
                                        Inc(current_offset, int_buffer+4);
                                        fafs.Position := current_offset;
                                end
                                else
                                begin
                                        Inc(current_offset);
                                        fafs.Position := current_offset;
                                end;
                        end;
                end;

                {StatusBar1.Panels[0].Text := 'Writing IDX file...';
                Application.ProcessMessages;}
                if Assigned(fIDXStatus) then
                  fIDXStatus('Writing IDX file...');

                //Writing IDX Header
                fidx.WriteStr('IDXD');
                fidx.Writer.WriteLongInt(20);
                fidx.Writer.WriteWord(total_files);
                fidx.Writer.WriteWord(total_files-srf_list.Count);

                for i:=0 to 7 do
                begin
                        fidx.Writer.WriteByte(0);
                end;

                fidx.WriteStr('TABL');
                fidx.Writer.WriteLongInt(((total_files-srf_list.Count)*8)+8);

                //Writing files list & other things
                for i:=0 to srf_list.Count-1 do
                begin
                        //Setting 'current_files_list' variable
                        if i = 0 then
                        begin
                                file_begin := 0;
                                file_end := srf_list[i] - 1;
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

                        //Finding what to delete in the filename...
                        delete1 := parse_section('.', files_infos[srf_list[i]], 0);

                        for i2:=0 to current_files_list.Count-1 do
                        begin
                                filename := files_infos[current_files_list[i2]];
                                delete2 := ExtractFileExt(filename);
                                Delete(filename, Pos(delete1, filename), Length(delete1));
                                Delete(filename, Pos(delete2, filename), Length(delete2));
                                fidx.WriteStr(filename);
                                fidx.Writer.WriteWord(current_files_list[i2]);
                                temp_int := Round(srf_offset[current_files_list[i2]-i]/4);
                                fidx.Writer.WriteWord(temp_int);

                                //Modifying Form1
                                {ProgressBar1.Position := ProgressBar1.Position + 1;
                                Panel1.Caption := IntToStr(Round((100*ProgressBar1.Position)/ProgressBar1.Max))+'%';
                                Application.ProcessMessages;}
                                if Assigned(fIDXCreationProgressEvent) then
                                  fIDXCreationProgressEvent();
                        end;
                end;

                //Writing list footer & srf list header
                fidx.WriteStr('SIXD');
                fidx.Writer.WriteLongInt((12*srf_list.Count)+20); //Need to be verified

                //Writing srf list
                for i:=0 to srf_list.Count-1 do
                begin
                        filename := files_infos[srf_list[i]];
                        delete1 := ExtractFileExt(filename);
                        Delete(filename, Pos(delete1, filename), Length(delete1));

                        temp_int := 8 - Length(filename);

                        for i2:=0 to temp_int-1 do
                        begin
                                fidx.Writer.WriteByte(95);
                        end;

                        fidx.WriteStr(filename);

                        if i = 0 then
                        begin
                                temp_int := 0;
                        end
                        else
                        begin
                                temp_int := srf_list[i-1] - (i-1);
                        end;

                        fidx.Writer.WriteWord(temp_int);
                        fidx.Writer.WriteWord(srf_list[i]);

                        //Modifying Form1
                        {ProgressBar1.Position := ProgressBar1.Position + 1;
                        Panel1.Caption := IntToStr(Round((100*ProgressBar1.Position)/ProgressBar1.Max))+'%';
                        Application.ProcessMessages;}
                        if Assigned(fIDXCreationProgressEvent) then
                          fIDXCreationProgressEvent();
                end;

                //Writing idx footer
                fidx.WriteStr('eNDieNDi');
                fidx.Writer.WriteLongInt(total_files-srf_list.Count);
                fidx.WriteStr('ENDI');

                for i:=0 to 3 do
                begin
                        fidx.Writer.WriteByte(0);
                end;

                //Modifying Form1
                {StatusBar1.Panels[0].Text := 'Creation completed for '+ExtractFileName(output_idx)+' !';
                Application.ProcessMessages;

                CreateIdxBt.Enabled := True;
                BrowseAfsBt.Enabled := True;
                BrowseIdxBt.Enabled := True;}
                if Assigned(fIDXStatus) then
                  fIDXStatus('Creation completed for '+ExtractFileName(OutputIDX)+' !');
                if Assigned(fIDXCreationEndEvent) then
                  fIDXCreationEndEvent();

                //Freeing variables
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
                //MessageDlg('"'+ExtractFileName(input_afs)+'" is not a valid AFS file.'+sLineBreak+sLineBreak+'IDX creation stopped...', mtError, [mbOk], 0);
              if Assigned(fIDXStatus) then
                fIDXStatus('"'+ExtractFileName(InputAFS)+'" is not a valid AFS file. IDX creation stopped...');
              if Assigned(fIDXCreationEndEvent) then
                fIDXCreationEndEvent();
        end;

        //Closing the file stream & variables
        fafs.Free;
end;

end.
