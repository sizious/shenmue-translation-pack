unit uitools;

interface

uses
  Windows, SysUtils, Forms, ComCtrls;

function FindNode(Node: TTreeNode; Text: string): TTreeNode;
function GetApplicationVersion(LangID, SubLangID: Byte): string;
function GetShortApplicationTitle: string;
procedure ListViewSelectItem(ListView: TCustomListView; Index: Integer);
procedure ShellOpenPropertiesDialog(FileName: TFileName);

implementation

uses
  ShellApi;
  
//------------------------------------------------------------------------------

function GetShortApplicationTitle: string;
const
  SHENMUE_TITLE_SIGN = 'Shenmue ';

begin
  Result := StringReplace(Application.Title, SHENMUE_TITLE_SIGN, '', [rfReplaceAll]);
end;

//------------------------------------------------------------------------------
(*  Based on the original function published by Nono40 (nono40.developpez.com)
    Thanks to Olivier Lance:
      http://delphi.developpez.com/faq/?page=systemedivers#langidcquoi *)
function ExtractApplicationVersion(const wLanguage: LANGID): string;
const
  VERSION_INFO_VALUE = '04E4';

var
  InfoSize,
  InfoLength: LongWord;
  Buffer,
  VersionPC: PChar;
  LangCode: string;

begin
  Result := '';
  Buffer := nil;

  LangCode := IntToHex(wLanguage, 4) + VERSION_INFO_VALUE;

  // Asking file version information size
  InfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), InfoSize);

  // We have file version information on the file.
  if InfoSize > 0 then
    try
      // Allocating memory for reading file info
      Buffer := AllocMem(InfoSize);

      // Copying file info in the buffer
      GetFileVersionInfo(PChar(ParamStr(0)), 0, InfoSize, Buffer);

      // Reading the ProductVersion value
      if VerQueryValue(Buffer, PChar('\StringFileInfo\' + LangCode
        + '\ProductVersion'), Pointer(VersionPC), InfoLength
      ) then
        Result := VersionPC;
    finally
      FreeMem(Buffer, InfoSize);
    end;
end;

//------------------------------------------------------------------------------

function MakeLangID(LangID, SubLangID: Byte): Word;
begin
  Result := (SubLangID shl 10) or LangID;
end;

//------------------------------------------------------------------------------

function GetApplicationVersion(LangID, SubLangID: Byte): string;
begin
  Result := ExtractApplicationVersion(MakeLangID(LangID, SubLangID));
end;

//------------------------------------------------------------------------------

function FindNode(Node: TTreeNode; Text: string): TTreeNode;
var
  i: Integer;

begin
  Result := nil;
  if not Node.HasChildren then Exit;

  for i := 0 to Node.Count - 1 do
    if Node.Item[i].Text = Text then begin
      Result := Node.Item[i];
      Break;
    end;

end;

//------------------------------------------------------------------------------

procedure ListViewSelectItem(ListView: TCustomListView; Index: Integer);
var
  P: TPoint;

begin
  if Index = 0 then begin
//    ListView.Scroll(0, - MaxInt);
    ListView.ItemIndex := 0;
  end else begin
    ListView.ItemIndex := Index - 1;
    P := ListView.Selected.Position;
    ListView.Scroll(0, P.Y);
    ListView.ItemIndex := Index;
  end;
end;

//------------------------------------------------------------------------------

procedure ShellOpenPropertiesDialog(FileName: TFileName);
var
  ShellExecuteInfo: TShellExecuteInfo;

begin
  FillChar(ShellExecuteInfo, SizeOf(ShellExecuteInfo), 0);
  ShellExecuteInfo.cbSize := SizeOf(ShellExecuteInfo);
  ShellExecuteInfo.fMask := SEE_MASK_INVOKEIDLIST;
  ShellExecuteInfo.lpVerb := 'properties';
  ShellExecuteInfo.lpFile := PChar(FileName);
  ShellExecuteEx(@ShellExecuteInfo);
end;

//------------------------------------------------------------------------------

end.
