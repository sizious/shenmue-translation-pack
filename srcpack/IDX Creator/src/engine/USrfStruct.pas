//    This file is part of IDX Creator.
//
//    You should have received a copy of the GNU General Public License
//    along with IDX Creator.  If not, see <http://www.gnu.org/licenses/>.

unit USrfStruct;

interface

uses
  Windows, Classes, SysUtils;

type
  TSrfStruct = class;

  TSrfEntry = class
    private
      sName: String;
      sText: String;
      sData: TMemoryStream;
      sOffset: Integer;
    public
      property CharName: String read sName write sName;
      property Text: String read sText write sText;
      property Data: TMemoryStream read sData;
      property Offset: Integer read sOffset;
  end;

  TSrfStruct = class
    private
      fSrcFileName: TFileName;
      fList: TList;
      function GetCount: Integer;
      function GetEntry(Index: Integer): TSrfEntry;
      procedure LoadFile(const FileName: TFileName; const Offset, Size: Integer);
    public
      constructor Create;
      destructor Destroy; override;

      procedure LoadFromFile(const FileName: TFileName); overload;
      procedure LoadFromFile(const FileName: TFileName; const Offset, Size: Integer); overload;
      procedure Add(var SrfEntry: TSrfEntry);
      procedure SaveToFile(const FileName: TFileName);
      property FileName: TFileName read fSrcFileName write fSrcFileName;
      property Count: Integer read GetCount;
      property Items[Index: Integer]: TSrfEntry read GetEntry;
      procedure Delete(const Index: Integer);
      procedure Clear;
  end;

const
  _SizeOf_Integer = SizeOf(Integer);

implementation

constructor TSrfStruct.Create;
begin
  fList := TList.Create;
end;

destructor TSrfStruct.Destroy;
var
  i: Integer;
begin
  for i := 0 to fList.Count - 1 do begin
    TSrfEntry(fList[i]).sData.Free;
    TSrfEntry(fList[i]).Free;
  end;
  fList.Free;
  inherited;
end;

procedure TSrfStruct.Add(var SrfEntry: TSrfEntry);
begin
  fList.Add(SrfEntry);
end;

procedure TSrfStruct.Delete(const Index: Integer);
begin
  TSrfEntry(fList[Index]).sData.Free;
  TSrfEntry(fList[Index]).Free;
  fList.Delete(Index);
end;

procedure TSrfStruct.Clear;
var
  i: Integer;
begin
  for i := 0 to fList.Count - 1 do begin
    TSrfEntry(fList[i]).sData.Free;
    TSrfEntry(fList[i]).Free;
  end;
  fList.Clear;
  fSrcFileName := '';
end;

function TSrfStruct.GetCount;
begin
  Result := fList.Count;
end;

function TSrfStruct.GetEntry(Index: Integer): TSrfEntry;
begin
  Result := TSrfEntry(fList[Index]);
end;

procedure TSrfStruct.LoadFromFile(const FileName: TFileName);
begin
  LoadFile(FileName, -1, -1);
end;

procedure TSrfStruct.LoadFromFile(const FileName: TFileName; const Offset, Size: Integer);
begin
  LoadFile(FileName, Offset, Size);
end;

procedure TSrfStruct.LoadFile(const FileName: TFileName; const Offset, Size: Integer);
var
  F: File;
  SrfEntry: TSrfEntry;
  i, intBuf, fSize, fOffset: Integer;
  strBuf: String;
  Buf: Byte;
begin
  Clear;
  fSrcFileName := FileName; //Keeping filename

  //Opening file
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
    //Reading first value
    BlockRead(F, intBuf, _SizeOf_Integer);
    if intBuf = 8 then begin
      SrfEntry := TSrfEntry.Create; //Creating entry
      SrfEntry.sOffset := (FilePos(F) - fOffset) - 4;

      //Reading filename
      SetLength(strBuf, intBuf-4);
      BlockRead(F, Pointer(strBuf)^, intBuf-4);
      SrfEntry.CharName := Trim(strBuf);

      //Reading subtitle length
      //4 = no text; > 4 = there's text
      strBuf := '';
      BlockRead(F, intBuf, _SizeOf_Integer);
      if intBuf > 4 then begin
        SetLength(strBuf, intBuf-4);
        BlockRead(F, Pointer(strBuf)^, intBuf-4);
      end;
      SrfEntry.Text := Trim(strBuf);

      //Initializing memory stream and reading data
      SrfEntry.sData := TMemoryStream.Create;
      BlockRead(F, intBuf, _SizeOf_Integer); //Data size
      for i := 0 to (intBuf-4) - 1 do begin
        BlockRead(F, Buf, SizeOf(Buf));
        SrfEntry.sData.Write(Buf, SizeOf(Buf)); //Copy to MemoryStream
      end;
      Add(SrfEntry);
    end
    else begin
      Seek(F, FilePos(F)-3);
    end;
  end;

  CloseFile(F);
end;

procedure TSrfStruct.SaveToFile(const FileName: TFileName);
var
  F: File;
  SrfEntry: TSrfEntry;
  i, j, intBuf, subTotal, blockSize, blockNum: Integer;
  Buf: Byte;

  function NullByteLength(const DataSize: Integer): Integer;
  var
    currNum, totalNull: Integer;
  begin
    //Text padding for Shenmue 1/2 SRF
    currNum := 0;
    totalNull := 4;
    while currNum <> DataSize do begin
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

  procedure WritePadding(var F_out: File; PaddingSize: Integer);
  const
    WORK_BUFFER_SIZE = 16384;
  var
    Buf: array[0..WORK_BUFFER_SIZE-1] of Byte;
    i, j, BufSize: Integer;
    _Last_BufSize_Entry: Integer;
  begin
    ZeroMemory(@Buf, Length(Buf));
    BufSize := SizeOf(Buf);
    _Last_BufSize_Entry := PaddingSize mod BufSize;
    j := PaddingSize div BufSize;
    for i := 0 to j - 1 do begin
      BlockWrite(F_out, Buf, SizeOf(Buf), BufSize);
    end;
    BlockWrite(F_out, Buf, _Last_BufSize_Entry);
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
    subTotal := 0;
    Inc(subTotal, 12 + Length(SrfEntry.sName));
    Inc(subTotal, Length(SrfEntry.sText)+SrfEntry.sData.Size);
    if Length(SrfEntry.sText) > 0 then begin
      Inc(subTotal, NullByteLength(Length(SrfEntry.sText)));
    end;

    //Verifying remaining space in the current block
    if (FileSize(F)+subTotal) > (blockSize*blockNum) then begin
      WritePadding(F, (blockSize*blockNum)-FileSize(F));
      Inc(blockNum);
    end;

    //Writing Character name
    if SrfEntry.sName <> '' then begin
      intBuf := Length(SrfEntry.sName)+4;
      BlockWrite(F, intBuf, _SizeOf_Integer);
      BlockWrite(F, Pointer(SrfEntry.sName)^, Length(SrfEntry.sName));
    end
    else begin
      intBuf := 8;
      BlockWrite(F, intBuf, _SizeOf_Integer);
      intBuf := 0;
      BlockWrite(F, intBuf, _SizeOf_Integer);
    end;

    //Writing Subtitle text... doesn't provide accentuated characters support
    if SrfEntry.sText <> '' then begin
      j := Length(SrfEntry.sText);
      intBuf := 4 + j + NullByteLength(j);
      BlockWrite(F, intBuf, _SizeOf_Integer);
      BlockWrite(F, SrfEntry.sText, j);
      WritePadding(F, NullByteLength(j));
    end
    else begin
      intBuf := 4;
      BlockWrite(F, intBuf, _SizeOf_Integer);
    end;

    //Writing data
    intBuf := SrfEntry.sData.Size + 4;
    BlockWrite(F, intBuf, _SizeOf_Integer); //Data size
    for j := 0 to (intBuf-4) - 1 do begin
      SrfEntry.sData.Read(Buf, SizeOf(Buf));
      BlockWrite(F, Buf, SizeOf(Buf)); //Copy to file
    end;
  end;

  CloseFile(F);
end;

end.
