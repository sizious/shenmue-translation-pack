(*
  Application Icon Changer
  Updated by [big_fury]SiZiOUS from the Shentrad Team
  Copyleft 2013

  This unit allow you to replace the Delphi 'MAINICON' from a compiled
  executable with another .ico file.

  The main function to call is "UpdateAppIcon".
  It returns 'True' if everything was fine and 'False' else.
  An 'EApplicationIconUpdater' exception is raised if an error occurs.
  So please use this function in a try .. except block.

  See the implementation section to get the credits for this snippet.
  If you are the very original author of this code, please drop me a mail
  to sizious at google mail dot com.
*)
unit IconChng;

interface

uses
	Windows, SysUtils, Classes;

type
  EApplicationIconUpdater = class(Exception);

function UpdateAppIcon(const AppFileName, IconFileName: TFileName): Boolean;

////////////////////////////////////////////////////////////////////////////////
implementation
////////////////////////////////////////////////////////////////////////////////

(*
  Authors : mindkeeper, Enrico Ghezzi, or maybe other (real source is unknow)
  Date    : Dec. 12, 2008 00:19:01
  Sources : http://exelab.ru/f/index.php?action=vthread&forum=6&topic=13337&page=0#7
            http://www.codenewsfast.com/cnf/article//permalink.art-ng1427q87681
*)

const
  MAX_ENTRIES         = MaxInt shr 4 - 1;
  ICONDIR_MINSIZE     = SizeOf(Word) * 3;
  GRPICONDIR_MINSIZE  = SizeOf(Word) * 3;

type
	PICONDIRENTRYCOMMON = ^ICONDIRENTRYCOMMON;
	ICONDIRENTRYCOMMON = packed record
		bWidth: Byte; 				      // Width, in pixels, of the image
		bHeight: Byte; 				      // Height, in pixels, of the image
		bColorCount: Byte; 			    // Number of colors in image (0 if >=8bpp)
		bReserved: Byte; 			      // Reserved ( must be 0)
		wPlanes: Word; 				      // Color Planes
		wBitCount: Word; 			      // Bits per pixel
		dwBytesInRes: DWord; 		    // How many bytes in this resource?
	end;

	PICONDIRENTRY = ^ICONDIRENTRY;
  ICONDIRENTRY = packed record
		common: ICONDIRENTRYCOMMON;
		dwImageOffset: DWord; 		  // Where in the file is this image?
	end;

	PICONDIR = ^ICONDIR;
	ICONDIR = packed record
		idReserved: Word; 			    // Reserved (must be 0)
		idType: Word; 				      // Resource Type (1 for icons)
		idCount: Word; 				      // How many images?
		idEntries: array[0..MAX_ENTRIES] of ICONDIRENTRY; // An entry for each image (idCount of 'em)
	end;

	PGRPICONDIRENTRY = ^GRPICONDIRENTRY;
	GRPICONDIRENTRY = packed record
		common: ICONDIRENTRYCOMMON;
		nID: Word;                  // the ID
	end;

	PGRPICONDIR = ^GRPICONDIR;
	GRPICONDIR = packed record
		idReserved: Word; 			    // Reserved (must be 0)
		idType: Word; 				      // Resource type (1 for icons)
		idCount: Word; 				      // How many images?
		idEntries: array [0..MAX_ENTRIES] of GRPICONDIRENTRY; // The entries for each image
	end;

// IsValidIcon
function IsValidIcon(P: Pointer; Size: Cardinal): Boolean;
const
  DOS_HEADER_MAGIC = 'MZ';

var
	AOffset,
  ItemCount, ABuf: Cardinal;
	Buf: array[0..1] of Char;

begin
  Result := False;
  try
    // Reject 'MZ' headers...
    CopyMemory(@Buf, P, 2);
    if SameText(Buf, DOS_HEADER_MAGIC) then Exit;

    // The size is smaller than the minimal size of the ICONDIRENTRY size!
    if Size < ICONDIR_MINSIZE then Exit;

    // The size is smaller than the excepted header...
    ItemCount := PICONDIR(P).idCount;
    if Size < ICONDIR_MINSIZE + (ItemCount * SizeOf(ICONDIRENTRY)) then Exit;

    // Check each entries...
    P := @PICONDIR(P).idEntries;
    while ItemCount > 0 do
    begin
      AOffset := PICONDIRENTRY(P).dwImageOffset;
      ABuf := AOffset + PICONDIRENTRY(P).common.dwBytesInRes;
      if (ABuf < AOffset) or (ABuf > Size) then Exit;
      Inc(PICONDIRENTRY(P));
      Dec(ItemCount);
    end;

    Result := True;
  except
    Result := False;
  end;
end;

// GetResourceLanguage
function GetResourceLanguage(hMod: HMODULE; lpType, lpName: PAnsiChar;
  var wLanguage: Word): Boolean;

function __EnumLangsFunc(hModule: Cardinal; lpType, lpName: PAnsiChar;
  wLanguage: Word; lParam: Integer): Boolean; stdcall;
begin
  PWord(lParam)^ := wLanguage;
  Result := False;
end;

begin
  wLanguage := GetSystemDefaultLangID;
  EnumResourceLanguages(hMod, lpType, lpName, @__EnumLangsFunc, Integer(@wLanguage));
  Result := True;
end;

// UpdateIcons
function UpdateAppIcon(const AppFileName, IconFileName: TFileName): Boolean;
const
  TARGET_GROUP_ICON = 'MAINICON';

var 
  hApp: THandle;
  hMod: HMODULE;
  hRes: HRSRC;
  Res: HGLOBAL; 
  GroupIconDir,
  NewGroupIconDir: PGRPICONDIR;
  i: Integer;
  wLanguage: Word; 
  FS: TFileStream;
  Ico: PICONDIR;
  IcoFileSize, cbData: Cardinal;
  NewGroupIconDirSize: LongInt;
  lpData: Pointer;
  lpName: PAnsiChar;
   
begin
  Result := False;

  if not FileExists(AppFileName) then
    raise EApplicationIconUpdater.Create('Application file wasn''t found!');

  if not FileExists(IconFileName) then
    raise EApplicationIconUpdater.Create('Icon file wasn''t found!');

  if Win32Platform <> VER_PLATFORM_WIN32_NT then
    raise EApplicationIconUpdater.Create('Only supported on Windows NT and above!');

  Ico := nil; 

  try
    { Load the icons }
    FS := TFileStream.Create(IconFileName, fmOpenRead, fmShareDenyWrite);
    try
      IcoFileSize := FS.Size;
      if IcoFileSize > $100000 then  { sanity check }
        raise EApplicationIconUpdater.Create('Icon file is too large!');

      GetMem(Ico, IcoFileSize);
      FS.Read(Ico^, IcoFileSize);
    finally 
      FS.Free;
    end;

    { Ensure the icon is valid } 
    if not IsValidIcon(Ico, IcoFileSize) then
      raise EApplicationIconUpdater.Create('Icon file is invalid!');

    { Update the resources }
    hApp := BeginUpdateResource(PChar(AppFileName), False);
    if hApp = 0 then
      raise EApplicationIconUpdater.Create('BeginUpdateResource failed (1)!');

    try

      hMod := LoadLibraryEx(PChar(AppFileName), 0, LOAD_LIBRARY_AS_DATAFILE);
      if hMod = 0 then
        raise EApplicationIconUpdater.Create('LoadLibraryEx failed (1)');

      try
        { Load the 'TARGET_GROUP_ICON' group icon resource }
        hRes := FindResource(hMod, TARGET_GROUP_ICON, RT_GROUP_ICON);
        if hRes = 0 then
          raise EApplicationIconUpdater.Create('FindResource failed (1)');

        Res := LoadResource(hMod, hRes);
        if Res = 0 then
          raise EApplicationIconUpdater.Create('LoadResource failed (1)');

        GroupIconDir := LockResource(Res);
        if GroupIconDir = nil then
          raise EApplicationIconUpdater.Create('LockResource failed (1)');

        if not GetResourceLanguage(hMod, RT_GROUP_ICON, TARGET_GROUP_ICON, wLanguage) then
          raise EApplicationIconUpdater.Create('GetResourceLanguage failed (1)');

        { Delete 'TARGET_GROUP_ICON' }
        if not UpdateResource(hApp, RT_GROUP_ICON, TARGET_GROUP_ICON, wLanguage, nil, 0) then
          raise EApplicationIconUpdater.Create('UpdateResource failed (1)');

        { Delete the RT_ICON icon resources that belonged to 'TARGET_GROUP_ICON' }
        for i := 0 to GroupIconDir.idCount - 1 do
        begin
          lpName := MakeIntResource(GroupIconDir.idEntries[i].nID);
          if not UpdateResource(hApp, RT_ICON, lpName, wLanguage, nil, 0) then
            raise EApplicationIconUpdater.Create('UpdateResource failed (2)'); 
        end;

        { Build the new group icon resource }
        NewGroupIconDirSize := GRPICONDIR_MINSIZE + Ico.idCount * SizeOf(GRPICONDIRENTRY);
        GetMem(NewGroupIconDir, NewGroupIconDirSize);
        try
          { Build the new group icon resource }
          NewGroupIconDir.idReserved := GroupIconDir.idReserved;
          NewGroupIconDir.idType := GroupIconDir.idType;
          NewGroupIconDir.idCount := Ico.idCount;
          for i := 0 to NewGroupIconDir.idCount - 1 do
          begin
            NewGroupIconDir.idEntries[i].common := Ico.idEntries[i].common;
            NewGroupIconDir.idEntries[i].nID := i + 1; // assumes that there aren't any icons left
          end;

          { Update 'TARGET_GROUP_ICON' }
          for i := 0 to NewGroupIconDir.idCount - 1 do
          begin
            lpName := MakeIntResource(NewGroupIconDir.idEntries[i].nID);
            lpData := Pointer(DWORD(Ico) + Ico.idEntries[i].dwImageOffset);
            cbData := Ico.idEntries[i].common.dwBytesInRes;
            if not UpdateResource(hApp, RT_ICON, lpName, wLanguage, lpData, cbData) then
              raise EApplicationIconUpdater.Create('UpdateResource failed (3) !');
          end;

          { Update the icons }
          if not UpdateResource(hApp, RT_GROUP_ICON, TARGET_GROUP_ICON, wLanguage,
                                NewGroupIconDir, NewGroupIconDirSize) then
            raise EApplicationIconUpdater.Create('UpdateResource failed (4) !');

          Result := True;
        finally
          FreeMem(NewGroupIconDir);
        end;
			
      finally
        FreeLibrary(hMod); 
      end;

    except
      EndUpdateResource(hApp, True); { discard changes }
      raise; 
    end;

    if not EndUpdateResource(hApp, False) then
      raise EApplicationIconUpdater.Create('EndUpdateResource failed!');

  finally
    FreeMem(Ico);
  end;
end;

end.

