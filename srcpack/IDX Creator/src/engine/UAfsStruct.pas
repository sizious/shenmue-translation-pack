//    This file is part of IDX Creator.
//
//    You should have received a copy of the GNU General Public License
//    along with IDX Creator.  If not, see <http://www.gnu.org/licenses/>.

unit UAfsStruct;

interface

uses
  Classes, SysUtils;

type
  TAfsStruct = class;

  TAfsEntry = class
    private
      fName: String;
      fOffset: Integer;
      fSize: Integer;
      fDate: String;
    public
      property FileName: String read fName write fName;
      property Offset: Integer read fOffset write fOffset;
      property Size: Integer read fSize write fSize;
      property Date: String read fDate write fDate;
  end;

  TAfsStruct = class
    private
      fSrcFileName: TFileName;
      fList: TList;
      function GetCount: Integer;
      function GetItem(Index: Integer): TAfsEntry;
    public
      constructor Create;
      destructor Destroy; override;

      procedure Add(var AfsEntry: TAfsEntry);
      procedure LoadFromFile(const FileName: TFileName);
      property FileName: TFileName read fSrcFileName;
      property Count: Integer read GetCount;
      property Items[Index: Integer]: TAfsEntry read GetItem;
      procedure Delete(const Index: Integer);
      procedure Clear;
  end;

const
  _SizeOf_Integer = SizeOf(Integer);
  _SizeOf_Word = SizeOf(Word);

implementation

constructor TAfsStruct.Create;
begin
  fList := TList.Create;
end;

destructor TAfsStruct.Destroy;
var
  i: Integer;
begin
  for i := 0 to fList.Count - 1 do begin
    TAfsEntry(fList[i]).Free;
  end;
  fList.Free;
  inherited;
end;

procedure TAfsStruct.Add(var AfsEntry: TAfsEntry);
begin
  fList.Add(AfsEntry);
end;

procedure TAfsStruct.Clear;
var
  i: Integer;
begin
  for i := 0 to fList.Count - 1 do begin
    TAfsEntry(fList[i]).Free;
  end;
  fList.Clear;
  fSrcFileName := '';
end;

procedure TAfsStruct.Delete(const Index: Integer);
begin
  TAfsEntry(fList[Index]).Free;
  fList.Delete(Index);
end;

function TAfsStruct.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TAfsStruct.GetItem(Index: Integer): TAfsEntry;
begin
  Result := TAfsEntry(fList[Index]);
end;

procedure TAfsStruct.LoadFromFile(const FileName: TFileName);
const
  AFS_SIGN = 'AFS';
var
  F: File;
  AfsEntry: TAfsEntry;
  i, j, intBuf, fCount, lOffset: Integer;
  wordBuf: Word;
  strBuf: String;
  rDate: array[1..6] of String;

  function FindList(var F: File; const Count, Offset: Integer): Integer;
  var
    j: Integer;
  begin
    Result := -1;
    j := 8+(8*Count);
    if Offset-j >= 8 then begin
      Seek(F, Offset-8);
      BlockRead(F, j, _SizeOf_Integer);
      if j > 0 then begin
        Result := j;
      end;
    end;
  end;

begin
  Clear;
  fSrcFileName := FileName; //Keeping filename
  lOffset := -1;

  //Opening file
  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  //Reading header
  SetLength(strBuf, 3);
  BlockRead(F, Pointer(strBuf)^, Length(strBuf));
  if strBuf = AFS_SIGN then begin
    Seek(F, FilePos(F)+1); //Seeking to file count
    BlockRead(F, fCount, _SizeOf_Integer); //Reading file count

    //Loop
    for i := 0 to fCount - 1 do begin
      AfsEntry := TAfsEntry.Create;

      //Reading offset/size
      Seek(F, 8+(8*i));
      BlockRead(F, intBuf, _SizeOf_Integer);
      AfsEntry.fOffset := intBuf;
      BlockRead(F, intBuf, _SizeOf_Integer);
      AfsEntry.fSize := intBuf;

      if i = 0 then begin
        //Finding files list...
        lOffset := FindList(F, fCount, AfsEntry.fOffset);
      end;

      if lOffset <> -1 then begin
        //Reading informations from list
        Seek(F, lOffset+(48*i));
        SetLength(strBuf, 32);
        BlockRead(F, Pointer(strBuf)^, Length(strBuf)); //Filename
        AfsEntry.fName := Trim(strBuf);

        //File date
        for j := 1 to 6 do begin
          BlockRead(F, wordBuf, _SizeOf_Word);
          rDate[j] := IntToStr(wordBuf);
        end;
        AfsEntry.fDate := rDate[1]+'/'+rDate[2]+'/'+rDate[3]+' ';
        AfsEntry.fDate := AfsEntry.fDate+rDate[4]+':'+rDate[5]+':'+rDate[6];
      end
      else begin
        //Filling var with something...
        AfsEntry.fName := 'file_'+IntToStr(i);
        DateTimeToString(AfsEntry.fDate, 'yyyy/mm/dd hh:nn:ss', Now);
      end;

      Add(AfsEntry);      
    end;
  end;

  CloseFile(F);  
end;

end.
