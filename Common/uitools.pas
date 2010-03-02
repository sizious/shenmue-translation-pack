unit uitools;

interface

function GetApplicationVersion(LangID, SubLangID: Byte): string;
function GetShortApplicationTitle: string;

implementation

uses
  Windows, SysUtils, Forms;

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

end.
