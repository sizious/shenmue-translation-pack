//    This file is part of SPR Utils.
//
//    You should have received a copy of the GNU General Public License
//    along with SPR Utils.  If not, see <http://www.gnu.org/licenses/>.

unit USprStruct;

interface

uses
  Classes, SysUtils;

type
  TSprStruct = class;

  TSprEntry = class
    private
      gTextureName: String;
      gOffset: Integer;
      gSize: Integer;
      gFormat: String;
      gFormatCode: Integer;
      gWidth: Word;
      gHeight: Word;
    public
      property TextureName: String read gTextureName write gTextureName;
      property Offset: Integer read gOffset write gOffset;
      property Size: Integer read gSize write gSize;
      property Format: String read gFormat write gFormat;
      property FormatCode: Integer read gFormatCode write gFormatCode;
      property Width: Word read gWidth write gWidth;
      property Height: Word read gHeight write gHeight;
  end;

  TSprStruct = class
    private
      fSrcFileName: String;
      fList: TList;
      function GetItem(Index: Integer): TSprEntry;
      function GetCount: Integer;
    public
      constructor Create;
      destructor Destroy; override;

      procedure Add(var SprEntry: TSprEntry);
      procedure Clear;
      procedure LoadFromFile(FileName: TFileName);
      property Count: Integer read GetCount;
      property FileName: String read fSrcFileName;
      property Items[Index: Integer]: TSprEntry read GetItem;
      procedure Delete(const Index: Integer);
  end;

const
  _SizeOf_Integer = SizeOf(Integer);
  _SizeOf_Word = SizeOf(Word);

implementation

constructor TSprStruct.Create;
begin
  fList := TList.Create;
end;

destructor TSprStruct.Destroy;
var
  i: Integer;
begin
  for i := 0 to fList.Count - 1 do begin
    TSprEntry(fList[i]).Free;
  end;
  fList.Free;
  inherited;
end;

function TSprStruct.GetItem(Index: Integer): TSprEntry;
begin
  Result := TSprEntry(fList[Index]);
end;

function TSprStruct.GetCount;
begin
  Result := fList.Count;
end;

procedure TSprStruct.Clear;
var
  i: Integer;
begin
  fSrcFileName := '';
  for i := 0 to fList.Count - 1 do begin
    TSprEntry(fList[i]).Free;
  end;
  fList.Clear;
end;

procedure TSprStruct.Add(var SprEntry: TSprEntry);
begin
  fList.Add(SprEntry);
end;

procedure TSprStruct.LoadFromFile(FileName: TFileName);
var
  F: File;
  sprEntry: TSPREntry;
  strBuf: String;
  intBuf, j, sOffset: Integer;
begin
  fSrcFileName := FileName; //Keeping filename
  Clear; //Clear entry list

  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  while FilePos(F) <> FileSize(F) do begin
    //Reading header
    SetLength(strBuf, 4);
    BlockRead(F, Pointer(strBuf)^, Length(strBuf));

    if strBuf = 'TEXN' then begin
      sprEntry := TSPREntry.Create;
      sOffset := FilePos(F)-4;

      //Reading section size
      BlockRead(F, j, _SizeOf_Integer);

      //Reading texture name
      SetLength(strBuf, 8);
      BlockRead(F, Pointer(strBuf)^, Length(strBuf));
      sprEntry.TextureName := Trim(strBuf);

      //Skip 'GBIX' section, going to 'PVRT' section
      Seek(F, FilePos(F)+4);
      BlockRead(F, intBuf, _SizeOf_Integer); //GBIX size
      Seek(F, FilePos(F)+intBuf+4); //Last +4 to skip 'PVRT' header

      //Reading file format
      BlockRead(F, intBuf, _SizeOf_Integer);
      case j-intBuf of
        164 : sprEntry.Format := 'DDS';
        36 : sprEntry.Format := 'PVR';
        else sprEntry.Format := 'Unknown';  
      end;

      //Reading specific format code
      BlockRead(F, sprEntry.gFormatCode, _SizeOf_Integer);

      //Reading width & height
      BlockRead(F, sprEntry.gWidth, _SizeOf_Word);
      BlockRead(F, sprEntry.gHeight, _SizeOf_Word);

      //Defining start offset and file size
      if sprEntry.Format = 'PVR' then begin
        sprEntry.Offset := sOffset + 16;
        sprEntry.Size := j-16;
      end
      else begin
        sprEntry.Offset := FilePos(F);
        sprEntry.Size := j-(FilePos(F)-sOffset);
      end;

      //Adding entry
      Add(sprEntry);
    end;
  end;

  CloseFile(F);
end;

procedure TSprStruct.Delete(const Index: Integer);
begin
  TSprEntry(fList[Index]).Free;
  fList.Delete(Index);
end;

end.
