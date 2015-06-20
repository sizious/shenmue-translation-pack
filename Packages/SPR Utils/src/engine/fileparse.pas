//    This file is part of SPR Utils.
//
//    You should have received a copy of the GNU General Public License
//    along with SPR Utils.  If not, see <http://www.gnu.org/licenses/>.

unit fileparse;

interface

uses
  Classes, SysUtils, USprStruct;

function GenerateName(const FileName: TFileName): String;
function ParseDDS(const FileName: TFileName; const TextureName: String): TSprEntry;
function ParsePVR(const FileName: TFileName; const TextureName: String): TSprEntry;
function IsValidDDS(const FileName: TFileName): Boolean;
function IsValidPVR(const FileName: TFileName): Boolean;

const
  _SizeOf_Integer = SizeOf(Integer);
  _SizeOf_Word = SizeOf(Word);

implementation

function GenerateName(const FileName: TFileName): String;
var
  strBuf, fExt: String;
begin
  strBuf := ExtractFileName(FileName);
  fExt := ExtractFileExt(strBuf);
  Delete(strBuf, Pos(fExt, strBuf), Length(fExt));
  Result := strBuf;
end;

function ParseDDS(const FileName: TFileName; const TextureName: String): TSprEntry;
var
  F: File;
  tempEntry: TSprEntry;
  strBuf: String;
  intBuf: Integer;
begin
  //Initializing var
  tempEntry := TSprEntry.Create;
  Result := tempEntry;

  //Opening the file
  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  //Texture name
  if TextureName <> '' then begin
    tempEntry.TextureName := TextureName;
  end
  else begin
    tempEntry.TextureName := GenerateName(FileName);
  end;

  //Offset and size
  tempEntry.Offset := 0;
  tempEntry.Size := FileSize(F);
  tempEntry.Format := 'DDS';

  //DXT version
  Seek(F, 84);
  SetLength(strBuf, 4);
  BlockRead(F, Pointer(strBuf)^, Length(strBuf));
  if strBuf = 'DXT1' then begin
    tempEntry.FormatCode := 32896;
  end
  else if strBuf = 'DXT3' then begin
    tempEntry.FormatCode := 32897;
  end;

  //Image resolution
  Seek(F, 12);
  BlockRead(F, intBuf, _SizeOf_Integer);
  tempEntry.Height := intBuf;
  BlockRead(F, intBuf, _SizeOf_Integer);
  tempEntry.Width := intBuf;

  CloseFile(F);
  Result := tempEntry;
end;

function ParsePVR(const FileName: TFileName; const TextureName: String): TSprEntry;
const
  GBIX_SIGN = 'GBIX';
var
  F: File;
  tempEntry: TSprEntry;
  strBuf: String;
  intBuf: Integer;
  wordBuf: Word;
begin
  //Initializing var
  tempEntry := TSprEntry.Create;
  Result := tempEntry;

  //Opening the file
  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  //Generating texture name
  if TextureName <> '' then begin
    tempEntry.TextureName := TextureName;
  end
  else begin
    tempEntry.TextureName := GenerateName(FileName);
  end;

  tempEntry.Format := 'PVR';

  //Skipping GBIX section if present
  SetLength(strBuf, 4);
  BlockRead(F, Pointer(strBuf)^, Length(strBuf));
  if strBuf = GBIX_SIGN then begin
    BlockRead(F, intBuf, _SizeOf_Integer);
    Seek(F, FilePos(F)+intBuf+4);
  end;

  tempEntry.Offset := FilePos(F)-4;
  tempEntry.Size := FileSize(F) - tempEntry.Offset;

  //Seeking to format code and reading value
  Seek(F, FilePos(F)+4);
  BlockRead(F, intBuf, _SizeOf_Integer);
  tempEntry.FormatCode := intBuf;

  //Reading image resolution
  BlockRead(F, wordBuf, _SizeOf_Word);
  tempEntry.Width := wordBuf;
  BlockRead(F, wordBuf, _SizeOf_Word);
  tempEntry.Height := wordBuf;

  CloseFile(F);
  Result := tempEntry;
end;

function IsValidDDS(const FileName: TFileName): Boolean;
const
  DDS_SIGN = 'DDS';
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

  Seek(F, 0);

  //Reading header
  SetLength(strBuf, 3);
  BlockRead(F, Pointer(strBuf)^, Length(strBuf));

  if strBuf = DDS_SIGN then begin
    Result := True;
  end;

  CloseFile(F);
end;

function IsValidPVR(const FileName: TFileName): Boolean;
const
  GBIX_SIGN = 'GBIX';
  PVR_SIGN = 'PVRT';
var
  F: File;
  strBuf: String;
  intBuf: Integer;
begin
  Result := False;

  //Opening the file
  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  Seek(F, 0);

  //Reading header
  SetLength(strBuf, 4);
  BlockRead(F, Pointer(strBuf)^, Length(strBuf));
  if strBuf = PVR_SIGN then begin
    Result := True;
  end
  else if strBuf = GBIX_SIGN then begin
    //Skipping GBIX section
    BlockRead(F, intBuf, _SizeOf_Integer);
    Seek(F, FilePos(F)+intBuf);
    BlockRead(F, Pointer(strBuf)^, Length(strBuf));
    if strBuf = PVR_SIGN then begin
      Result := True;
    end;
  end;
end;

end.
