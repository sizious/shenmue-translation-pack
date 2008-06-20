unit afsparser;

interface

uses
  SysUtils;

function parseAfs(const FileName: TFileName): Boolean;
function IsValidAfs(const FileName: TFileName): Boolean;

implementation
uses afsextract;

//Function to parse afs infos
function ParseAfs(const FileName: TFileName): Boolean;
const
  _SizeOf_Integer = SizeOf(Integer);
  _SizeOf_Word = SizeOf(Word);
var
  F: File;
  strBuf, fileDate: String;
  i, j, intBuf, fileCnt, fileLstOffset: Integer;
  wordBuf: Word;
  dateArray:array[1..6] of Word;
begin
  Result := False;
  ClearVars;

  //Opening the file
  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  //Reading file count
  Seek(F, 4);
  BlockRead(F, fileCnt, _SizeOf_Integer);

  //Reading file offset/file size list
  for i := 0 to fileCnt - 1 do begin
    Seek(F, 8+(8*i));
    BlockRead(F, intBuf, _SizeOf_Integer); //File offset
    afsMain.FileOffset.Add(intBuf);
    BlockRead(F, intBuf, _SizeOf_Integer); //File size
    afsMain.FileSize.Add(intBuf);
  end;

  //Detecting files list presence
  intBuf := 8 + (fileCnt*8);
  fileLstOffset := 0;
  if (afsMain.FileOffset[0] - intBuf) >= 8 then begin
    //Reading files list offset
    Seek(F, afsMain.FileOffset[0]-8);
    BlockRead(F, fileLstOffset, _SizeOf_Integer);
  end;

  if fileLstOffset <> 0 then begin
    //Reading files list infos
    for i := 0 to fileCnt - 1 do begin
      Seek(F, fileLstOffset+(48*i));
      SetLength(strBuf, 32);
      BlockRead(F, Pointer(strBuf)^, Length(strBuf));
      afsMain.FileName.Add(Trim(strBuf));

      //File date & time
      for j := 1 to 6 do begin
        BlockRead(F, wordBuf, _SizeOf_Word);
        dateArray[j] := wordBuf;
      end;
      fileDate := IntToStr(dateArray[3])+'/'+IntToStr(dateArray[2])+'/'+IntToStr(dateArray[1])+' '+IntToStr(dateArray[4])+':'+IntToStr(dateArray[5])+':'+IntToStr(dateArray[6]);
      afsMain.FileDate.Add(fileDate);
    end;
  end
  else begin
    //Filling vars with nothing interesting
    for i := 0 to fileCnt - 1 do begin
      afsMain.FileName.Add('file_'+IntToStr(i+1));
      afsMain.FileDate.Add('');
    end;
  end;

  if afsMain.FileName.Count > 0 then begin
    Result := True;
  end
  else begin
    ClearVars;
  end;

  CloseFile(F);
end;

//Function to validate files to be opened...
function IsValidAfs(const FileName: TFileName): Boolean;
const
  AFS_SIGN = 'AFS'; //File header
var
  F: File;
  strBuf: String;
begin
  Result := False;

  //Opening the file
  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  try
    //Reading header
    Seek(F, 0);
    SetLength(strBuf, 3);
    BlockRead(F, Pointer(strBuf)^, Length(strBuf));
    if strBuf = AFS_SIGN then begin
      Result := True;
    end;
  finally
    CloseFile(F);
  end;
  
end;

end.
