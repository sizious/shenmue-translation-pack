//    This file is part of Shenmue AiO Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue AiO Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit USrfStructAiO;

interface

uses
  Windows, Classes, SysUtils;

type
  TGameVersion = (gvNone, gvShenmueOne, gvShenmueTwo);
  TSrfStruct = class;

  TCharsList = class
    private
      fLoaded: Boolean;
      fStrList: array of String;
      fDecList: array of Byte;
      function GetCount: Integer;
    public
      procedure Add(const Char: String; const Decimal: Integer);
      property Count: Integer read GetCount;
      destructor Destroy; override;
      procedure LoadFromFile(const FileName: TFileName);
      property Loaded: Boolean read fLoaded;
  end;

  TSrfEntry = class
    private
      sName: String;
      sText: String;
      sData: TMemoryStream;
      sOffset: Integer;
      sEditable: Boolean;
    public
      constructor Create;
      destructor Destroy; override;
      property CharName: String read sName write sName;
      property Text: String read sText write sText;
      property Data: TMemoryStream read sData;
      property Offset: Integer read sOffset write sOffset;
      property Editable: Boolean read sEditable write sEditable;
  end;

  TSrfStruct = class
    private
      fGameVersion: TGameVersion;
      fSrcName: TFileName;
      fList: TList;
      fCharsModOne: Boolean;
      fCharsModTwo: Boolean;
      fCharsListOne: TFileName;
      fCharsListTwo: TFileName;
      procedure CopyFileToMem(var F: File; var MemoryStream: TMemoryStream; const Offset, Size: Integer);
      procedure CopyMemToFile(var MemoryStream: TMemoryStream; var F: File);
      function GetCount: Integer;
      function GetItem(Index: Integer): TSrfEntry;
      procedure LoadShenmueOne(const FileName: TFileName; const Offset, Size: Integer);
      procedure LoadShenmueTwo(const FileName: TFileName; const Offset, Size: Integer);
      function ReadSubtitle(var F: File; const Offset, SubLength: Integer): String;
      procedure WriteSubtitle(var F: File; var SrfEntry: TSrfEntry);
      function ProcessText(const Text: String; var CharsList: TCharsList): String; 
      function DeprocessText(const Text: String; var CharsList: TCharsList): String;
      function AddMarker(const Text: String): String;
      function RemoveMarker(const Text: String): String;
      function NullByteLength(const Size: Integer): Integer;
      procedure SaveShenmueOne(const FileName: TFileName);
      procedure SaveShenmueTwo(const FileName: TFileName);
      function ValidateFile(const FileName: TFileName): TGameVersion;
      procedure WritePadding(var F: File; const Size: Integer);
    public
      constructor Create;
      destructor Destroy; override;

      procedure Add(var SrfEntry: TSrfEntry);
      property CharactersListOne: TFileName read fCharsListOne write fCharsListOne;
      property CharactersListTwo: TFileName read fCharsListTwo write fCharsListTwo;
      procedure Clear;
      property Count: Integer read GetCount;
      procedure Delete(const Index: Integer);
      property FileName: TFileName read fSrcName write fSrcName;
      property GameVersion: TGameVersion read fGameVersion write fGameVersion;
      function IsValid(const FileName: TFileName): Boolean;
      function LoadCharsList(const GameVersion: TGameVersion): Boolean;
      procedure LoadFromFile(const FileName: TFileName; const Offset: Integer = -1; const Size: Integer = -1); overload;
      property Items[Index: Integer]: TSrfEntry read GetItem;
      procedure SaveToFile(const FileName: TFileName);
      property UseCharsListOne: Boolean read fCharsModOne write fCharsModOne;
      property UseCharsListTwo: Boolean read fCharsModTwo write fCharsModTwo;
  end;

const
  _SizeOf_Byte = SizeOf(Byte);
  _SizeOf_Integer = SizeOf(Integer);
  LINE_BREAK = #$A1#$F5;

var
  CharsListOne: TCharsList;
  CharsListTwo: TCharsList;

implementation
uses charsutils;

constructor TSrfEntry.Create;
begin
  sData := TMemoryStream.Create;
end;

destructor TSrfEntry.Destroy;
begin
  sData.Free;
  inherited;
end;

destructor TCharsList.Destroy;
begin
  Finalize(fStrList);
  Finalize(fDecList);
  inherited;
end;

function TCharsList.GetCount: Integer;
begin
  Result := 0;
  if Length(fStrList) = Length(fDecList) then begin
    Result := Length(fStrList);
  end;
end;

procedure TCharsList.Add(const Char: string; const Decimal: Integer);
begin
  SetLength(fStrList, Length(fStrList)+1);
  SetLength(fDecList, Length(fDecList)+1);
  fStrList[Length(fStrList)-1] := Char;
  fDecList[Length(fDecList)-1] := Decimal;
end;

procedure TCharsList.LoadFromFile(const FileName: TFileName);
var
  F: TextFile;
  Line, charBuf, decBuf: String;
begin
  fLoaded := False;
  if FileExists(FileName) then begin
    AssignFile(F, FileName);
    Reset(F);
    repeat
      ReadLn(F, Line);
      if (Line <> '') and (Line[1] <> '#') then begin
        decBuf := ParseSection(',', Line, 0);
        charBuf := ParseSection(',', Line, 1);
        charBuf := Copy(charBuf, 2, 1);
        Add(charBuf, StrToInt(decBuf));
      end;
    until EOF(F);
    CloseFile(F);

    if Count > 0 then begin
      fLoaded := True;
    end;
  end;
end;

constructor TSrfStruct.Create;
begin
  fList := TList.Create;
  fGameVersion := gvNone;
  fCharsModOne := False;
  fCharsModTwo := False;
  fCharsListOne := '';
  fCharsListTwo := '';
  CharsListOne := TCharsList.Create;
  CharsListTwo := TCharsList.Create;
end;

destructor TSrfStruct.Destroy;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    TSrfEntry(fList[i]).Free;
  end;
  fList.Free;
  CharsListOne.Free;
  CharsListTwo.Free;
  inherited;
end;

function TSrfStruct.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TSrfStruct.GetItem(Index: Integer): TSrfEntry;
begin
  Result := TSrfEntry(fList[Index]);
end;

procedure TSrfStruct.Add(var SrfEntry: TSrfEntry);
begin
  fList.Add(SrfEntry);
end;

procedure TSrfStruct.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    TSrfEntry(fList[i]).Free;
  end;
  fList.Clear;
  fGameVersion := gvNone;
  fSrcName := '';
end;

procedure TSrfStruct.Delete(const Index: Integer);
begin
  TSrfEntry(fList[Index]).Free;
  fList.Delete(Index);
end;

function TSrfStruct.LoadCharsList(const GameVersion: TGameVersion): Boolean;
begin
  Result := False;
  if (GameVersion = gvShenmueOne) and (fCharsListOne <> '') then begin
    CharsListOne.LoadFromFile(fCharsListOne);
    fCharsModOne := CharsListOne.Loaded;
    if CharsListOne.Loaded then begin
      Result := True;
    end;
  end
  else if (GameVersion = gvShenmueTwo) and (fCharsListTwo <> '') then begin
    CharsListTwo.LoadFromFile(fCharsListTwo);
    fCharsModTwo := CharsListTwo.Loaded;
    if CharsListTwo.Loaded then begin
      Result := True;
    end;
  end;
end;

function TSrfStruct.IsValid(const FileName: TFileName): Boolean;
begin
  Result := False;
  if ValidateFile(FileName) <> gvNone then begin
    Result := True;
  end;
end;

procedure TSrfStruct.LoadFromFile(const FileName: TFileName; const Offset: Integer = -1; const Size: Integer = -1);
var
  tempVersion: TGameVersion;
begin
  tempVersion := ValidateFile(FileName);
  if tempVersion = gvShenmueOne then begin
    LoadShenmueOne(FileName, Offset, Size);
  end
  else if tempVersion = gvShenmueTwo then begin
    LoadShenmueTwo(FileName, Offset, Size);
  end;
end;

procedure TSrfStruct.SaveToFile(const FileName: TFileName);
begin
  if fGameVersion = gvShenmueOne then begin
    SaveShenmueOne(FileName);
  end
  else if fGameVersion = gvShenmueTwo then begin
    SaveShenmueTwo(FileName);
  end;
end;

function TSrfStruct.ValidateFile(const FileName: TFileName): TGameVersion;
const
  ONE_SIGN = 8;
  TWO_SIGN = 'CHID';
var
  F: File;
  intBuf: Integer;
  strBuf: String;
begin
  Result := gvNone; //Default result

  //Trying to verify if the file is a valid SRF from Shenmue I or II.
  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  if FileSize(F) > 4 then begin
    //Shenmue I header
    BlockRead(F, intBuf, _SizeOf_Integer);
    Seek(F, 0);

    //Shenmue II header
    SetLength(strBuf, 4);
    BlockRead(F, Pointer(strBuf)^, Length(strBuf));

    //Final verification
    if intBuf = ONE_SIGN then begin
      Result := gvShenmueOne;
    end
    else if strBuf = TWO_SIGN then begin
      Result := gvShenmueTwo;
    end;
  end;

  CloseFile(F);
end;

procedure TSrfStruct.CopyFileToMem(var F: file; var MemoryStream: TMemoryStream; const Offset, Size: Integer);
var
  i: Integer;
  Buf: Byte;
begin
  Seek(F, Offset);
  for i := 0 to Size - 1 do begin
    BlockRead(F, Buf, _SizeOf_Byte);
    MemoryStream.Write(Buf, _SizeOf_byte);
  end;
end;

procedure TSrfStruct.CopyMemToFile(var MemoryStream: TMemoryStream; var F: file);
var
  i: Integer;
  Buf: Byte;
begin
  MemoryStream.Seek(0, soFromBeginning);
  for i := 0 to MemoryStream.Size - 1 do begin
    MemoryStream.Read(Buf, _SizeOf_Byte);
    BlockWrite(F, Buf, _SizeOf_Byte);
  end;
end;

function TSrfStruct.ReadSubtitle(var F: file; const Offset, SubLength: Integer): String;
var
  subStr: String;
begin
  Seek(F, Offset);

  SetLength(subStr, SubLength);
  BlockRead(F, Pointer(subStr)^, Length(subStr));
  subStr := RemoveMarker(subStr);

  if fGameVersion = gvShenmueOne then begin
    if fCharsModOne then begin
      subStr := DeprocessText(subStr, CharsListOne);
    end;
  end
  else if fGameVersion = gvShenmueTwo then begin
    if fCharsModTwo then begin
      subStr := DeprocessText(subStr, CharsListTwo);
    end;
  end;

  Result := Trim(subStr);
end;

procedure TSrfStruct.WriteSubtitle(var F: file; var SrfEntry: TSrfEntry);
var
  j, intBuf: Integer;
  finalSub: String;
begin
      finalSub := SrfEntry.sText;
      j := Length(AddMarker(finalSub));

      if fGameVersion = gvShenmueOne then begin
        if fCharsModOne then begin
          finalSub := ProcessText(finalSub, CharsListOne);
        end;
        intBuf := j + 4 + NullByteLength(j);
      end
      else if fGameVersion = gvShenmueTwo then begin
        if fCharsModTwo then begin
          finalSub := ProcessText(finalSub, CharsListTwo);
        end;
        intBuf := j + 8 + NullByteLength(j);
      end;

      //New line marker modification
      finalSub := AddMarker(finalSub);

      BlockWrite(F, intBuf, _SizeOf_Integer);
      BlockWrite(F, Pointer(finalSub)^, j);
      WritePadding(F, NullByteLength(j));
end;

function TSrfStruct.ProcessText(const Text: string; var CharsList: TCharsList): String;
var
  i, j: Integer;
  finalSub, currChar: String;
begin
  if CharsList.fLoaded then begin
    finalSub := '';
    for i := 1 to Length(Text) do begin
      currChar := Text[i];
      for j := 0 to CharsList.Count-1 do begin
        if Text[i] = CharsList.fStrList[j] then begin
          currChar := Chr(CharsList.fDecList[j]);
          Break;
        end;
      end;
      finalSub := finalSub + currChar;
    end;
    Result := finalSub;
  end
  else begin
    Result := Text;
  end; 
end;

function TSrfStruct.DeprocessText(const Text: string; var CharsList: TCharsList): String;
var
  i, j: Integer;
  finalSub, currChar: String;
begin
  if CharsList.fLoaded then begin
    finalSub := '';
    for i := 1 to Length(Text) do begin
      currChar := Text[i];
      for j := 0 to CharsList.Count-1 do begin
        if Ord(Text[i]) = CharsList.fDecList[j] then begin
          currChar := CharsList.fStrList[j];
          Break;
        end;
      end;
      finalSub := finalSub + currChar;
    end;
    Result := finalSub;
  end
  else begin
    Result := Text;
  end;
end;

function TSrfStruct.AddMarker(const Text: string): String;
begin
  Result := StringReplace(Text, sLineBreak, LINE_BREAK, [rfReplaceAll]);
end;

function TSrfStruct.RemoveMarker(const Text: string): String;
begin
  Result := StringReplace(Text, LINE_BREAK, sLineBreak, [rfReplaceAll]);
end;

function TSrfStruct.NullByteLength(const Size: Integer): Integer;
var
  currNum, totalNull: Integer;
begin
  //Text padding for Shenmue I/II
  currNum := 0;
  totalNull := 4;
  while currNum <> Size do begin
    if totalNull = 1 then begin
      totalNull := 4;
    end
    else begin
      Dec(totalNull);
    end;
      Inc(currNum);
  end;
  Result := totalNull;
end;

procedure TSrfStruct.WritePadding(var F: file; const Size: Integer);
const
  WORK_BUFFER_SIZE = 16384;
var
  Buf: array[0..WORK_BUFFER_SIZE-1] of Byte;
  i, j, BufSize: Integer;
  _Last_BufSize_Entry: Integer;
begin
  ZeroMemory(@Buf, Length(Buf));
  BufSize := SizeOf(Buf);
  _Last_BufSize_Entry := Size mod BufSize;
  j := Size div BufSize;
  for i := 0 to j - 1 do begin
    BlockWrite(F, Buf, SizeOf(Buf), BufSize);
  end;
  BlockWrite(F, Buf, _Last_BufSize_Entry);
end;

procedure TSrfStruct.LoadShenmueOne(const FileName: TFileName; const Offset: Integer; const Size: Integer);
const
  ONE_SIGN = 8;
var
  F: File;
  SrfEntry: TSrfEntry;
  intBuf, fOffset, fSize: Integer;
  strBuf: String;
begin
  Clear;
  fSrcName := FileName; //Keeping filename
  fGameVersion := gvShenmueOne; //Keeping game version

  //Opening the file
  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  if (Offset <> -1) and (Size <> -1) then begin
    fOffset := Offset;
    fSize := Size;
  end
  else begin
    fOffset := 0;
    fSize := FileSize(F);
  end;

  Seek(F, fOffset);

  while FilePos(F) <> (fOffset+fSize) do begin
    BlockRead(F, intBuf, _SizeOf_Integer);
    if intBuf = ONE_SIGN then begin
      SrfEntry := TSrfEntry.Create; //Creating entry
      SrfEntry.sOffset := FilePos(F) - 4;
      SrfEntry.sEditable := False;

      //Reading character's name
      SetLength(strBuf, intBuf-4);
      BlockRead(F, Pointer(strBuf)^, Length(strBuf));
      SrfEntry.sName := Trim(strBuf);

      //Reading subtitle
      BlockRead(F, intBuf, _SizeOf_Integer);
      if intBuf > 4 then begin
        SrfEntry.sText := ReadSubtitle(F, FilePos(F), intBuf-4);
        SrfEntry.sEditable := True;
      end;

      //Reading data
      BlockRead(F, intBuf, _SizeOf_Integer);
      CopyFileToMem(F, SrfEntry.sData, FilePos(F)-4, intBuf);

      Add(SrfEntry); //Finally!
    end
    else begin
      Seek(F, FilePos(F)-3);
    end;
  end;

  CloseFile(F); //Closing the file
end;

procedure TSrfStruct.LoadShenmueTwo(const FileName: TFileName; const Offset: Integer; const Size: Integer);
const
  TWO_SIGN = 'CHID';
var
  F: File;
  SrfEntry: TSrfEntry;
  intBuf, fOffset, fSize: Integer;
  strBuf, charCode: String;
  noSub: Boolean;

  function GetCharCode(const CharId: String): String;
  begin
    Result := Copy(CharId, Length(CharId)-3, 4);
  end;

begin
  Clear;
  fSrcName := FileName; //Keeping filename
  fGameVersion := gvShenmueTwo;

  //Opening the file
  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  if (Offset <> -1) and (Size <> -1) then begin
    fOffset := Offset;
    fSize := Size;
  end
  else begin
    fOffset := 0;
    fSize := FileSize(F);
  end;

  Seek(F, fOffset);

  while FilePos(F) <> (fOffset+fSize) do begin
    SetLength(strBuf, 4);
    BlockRead(F, Pointer(strBuf)^, Length(strBuf));
    if strBuf = TWO_SIGN then begin
      noSub := False;

      SrfEntry := TSrfEntry.Create; //Creating entry
      SrfEntry.sOffset := FilePos(F)-4;
      SrfEntry.sEditable := False;

      //Reading character's name
      BlockRead(F, intBuf, _SizeOf_Integer);
      SetLength(strBuf, intBuf-4);
      BlockRead(F, Pointer(strBuf)^, Length(strBuf));
      SrfEntry.sName := Trim(strBuf);

      //Parsing character 'code'
      charCode := GetCharCode(SrfEntry.sName);

      //Dreamcast 'ENDC' hack
      if charCode = 'ENDC' then begin
        SrfEntry.sText := '';
        Seek(F, FilePos(F)+4);
        Add(SrfEntry);
        Continue;
      end
      else if charCode = 'STDL' then begin
        //Reading subtitle text
        BlockRead(F, intBuf, _SizeOf_Integer);
        SrfEntry.sText := ReadSubtitle(F, FilePos(F), intBuf-8);
        SrfEntry.sEditable := True;          
      end
      else begin
        SrfEntry.sText := '';
        noSub := True;
      end;

       if noSub then begin
        BlockRead(F, intBuf, _SizeOf_Integer);
        Seek(F, FilePos(F)-4);
        CopyFileToMem(F, SrfEntry.sData, FilePos(F), intBuf-4);
       end;

       //Reading data
       strBuf := '';
       while strBuf <> 'ENDC' do begin
        SetLength(strBuf, 4);
        BlockRead(F, Pointer(strBuf)^, Length(strBuf)); //Section header
        if strBuf <> 'ENDC' then begin
          BlockRead(F, intBuf, _SizeOf_Integer);
          Seek(F, FilePos(F)-8);
          CopyFileToMem(F, SrfEntry.sData, FilePos(F), intBuf);
        end;
       end;

       Seek(F, FilePos(F)+4);
       Add(SrfEntry);
    end
    else begin
      Seek(F, FilePos(F)-3);
    end;
  end;

  CloseFile(F);
end;

procedure TSrfStruct.SaveShenmueOne(const FileName: TFileName);
var
  F: File;
  SrfEntry: TSrfEntry;
  i, intBuf, subTotal, blockNum, blockSize: Integer;
begin
  //Assigning output file
  AssignFile(F, FileName);
  FileMode := fmOpenWrite;
  ReWrite(F, 1);

  blockNum := 1;
  blockSize := 2048;

  for i := 0 to Count - 1 do begin
    SrfEntry := Items[i];

    //Calculating total section size
    subTotal := 0;
    Inc(subTotal, 12+Length(SrfEntry.sName));
    Inc(subTotal, Length(SrfEntry.sText)+SrfEntry.sData.Size);
    if Length(SrfEntry.sText) > 0 then begin
      Inc(subTotal, NullByteLength(Length(SrfEntry.sText)));
    end;

    //Verifying remaining space
    if (FileSize(F)+subTotal) > (blockNum*blockSize) then begin
      WritePadding(F, (blockNum*blockSize)-FileSize(F));
      Inc(blockNum);
    end;

    //Writing character name
    if SrfEntry.sName <> '' then begin
      intBuf := Length(SrfEntry.sName)+4;
      BlockWrite(F, intBuf, _SizeOf_Integer);
      BlockWrite(F, Pointer(SrfEntry.sName)^, Length(SrfEntry.sName));
    end
    else begin
      intBuf := 8;
      BlockWrite(F, intBuf, _SizeOf_Integer);
      WritePadding(F, 4);
    end;

    //Writing subtitle text (no accentuated characters support)
    if SrfEntry.Editable then begin
      WriteSubtitle(F, SrfEntry);
    end
    else begin
      intBuf := 4;
      BlockWrite(F, intBuf, _SizeOf_Integer);
    end;

    //Writing data
    CopyMemToFile(SrfEntry.sData, F);
  end;

  CloseFile(F);
end;

procedure TSrfStruct.SaveShenmueTwo(const FileName: TFileName);
var
  F: File;
  SrfEntry: TSrfEntry;
  i, intBuf, subTotal, blockNum, blockSize: Integer;
  strBuf: String;

  function SubSize(var SrfEntry: TSrfEntry): Integer;
  var
    intBuf, subTotal: Integer;
  begin
    subTotal := 0;
    Inc(subTotal, 8); //Header + CharID length = 2 x 4 bytes
    Inc(subTotal, Length(SrfEntry.sName)); //CharID
    if Pos('ENDC', SrfEntry.sName) = 0 then begin
      if Pos('STDL', SrfEntry.sName) <> 0 then begin
        intBuf := Length(SrfEntry.sText);
        Inc(subTotal, 4+intBuf+NullByteLength(intBuf));
      end;
      Inc(subTotal, SrfEntry.Data.Size+4); //Data size + ENDC
    end;
    Inc(subTotal, 4);
    Result := subTotal;
  end;
  
begin
  //Assigning output file
  AssignFile(F, FileName);
  FileMode := fmOpenWrite;
  ReWrite(F, 1);

  blockNum := 1;
  blockSize := 2048;

  for i := 0 to Count - 1 do begin
    SrfEntry := Items[i];

    //Calculating section total size
    subTotal := SubSize(SrfEntry);

    //Verifying remaining space in the current block
    if (FileSize(F)+subTotal) > (blockNum*blockSize) then begin
      WritePadding(F, (blockNum*blockSize)-FileSize(F));
      Inc(blockNum);
    end;

    //Writing header
    strBuf := 'CHID';
    BlockWrite(F, Pointer(strBuf)^, Length(strBuf));

    //Writing character name
    intBuf := Length(SrfEntry.sName)+4;
    BlockWrite(F, intBuf, _SizeOf_Integer);
    BlockWrite(F, Pointer(SrfEntry.sName)^, Length(SrfEntry.sName));

    //Writing subtitle (no accentuated characters support)
    if SrfEntry.Editable then begin
      WriteSubtitle(F, SrfEntry);
    end;

    //Writing data
    CopyMemToFile(SrfEntry.sData, F);

    //Writing 'ENDC' and padding
    if Pos('ENDC', SrfEntry.sName) = 0 then begin
      strBuf := 'ENDC';
      BlockWrite(F, Pointer(strBuf)^, Length(strBuf));
    end;
    WritePadding(F, 4);
  end;

  CloseFile(F);
end;

end.
