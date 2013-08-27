unit DriveChk;

(*
   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   OLD UNIT DO NOT USE
   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*)

interface

uses
  Windows, SysUtils;

procedure GetMediaHashKey(const Drive: Char);
function GetDiscInfo(const Drive: Char): string;

//==============================================================================
implementation
//==============================================================================

const
  IOCTL_CDROM_MEDIA_REMOVAL       = $24804;
  IOCTL_CDROM_GET_DRIVE_GEOMETRY  = $2404C;

type
  TDISK_GEOMETRY = record
    Cylinders: _LARGE_INTEGER;
    MediaType: LongWord;
    TracksPerCylinder: LongWord;
    SectorsPerTrack: LongWord;
    BytesPerSector: LongWord;
  end;

  TPREVENT_MEDIA_REMOVAL = record
    PreventMediaRemoval: Boolean;
  end;

function DeviceIoControl(
    hDevice: THandle;
    dwIoControlCode: LongWord;
    lpInBuffer: Pointer;
    nInBuffer: LongWord;
    lpOutuffer: Pointer;
    nOutBuffer: LongWord;
    var BytesReturned: LongWord;
    Overlapped: pOverlapped
  ): Boolean; stdcall; external kernel32;

//==============================================================================

function IsDiscReady(const Drive: Char): Boolean;
var
  DrvNum: Byte;
  EMode: Word;

begin
  Result := False;
  if GetDriveType(PChar(Drive + ':\')) = DRIVE_CDROM then
  begin
    DrvNum := Ord(Drive);
    if DrvNum >= Ord('a') then
      Dec(DrvNum, $20);
    EMode := SetErrorMode(SEM_FAILCRITICALERRORS);
    try
      Result := (DiskSize(DrvNum - $40) <> -1);
    finally
      SetErrorMode(EMode);
    end;
  end;
end;

//------------------------------------------------------------------------------

// Define this to dump the first 300 sectors from the drive to the disk
{$DEFINE DUMP_SECTOR_TO_DISK}

// http://support.microsoft.com/kb/138434/en-us
procedure GetMediaHashKey(const Drive: Char);
const
  SECTOR_START_INDEX    = 0;
  SECTOR_COUNT          = 330;

var
{$IFDEF DEBUG}
{$IFDEF DUMP_SECTOR_TO_DISK}
  hFile: THandle;
{$ENDIF}
{$ENDIF}
  hCD: THandle;
  dwNotUsed, dwSize: LongWord;
  dgCDROM: TDISK_GEOMETRY;
  pmrLockCDROM: TPREVENT_MEDIA_REMOVAL;
  lpSector: PBYTE;
  SectorBuf: array of Byte;

begin
{$IFDEF DEBUG}
{$IFDEF DUMP_SECTOR_TO_DISK}
  //  Disk file that will hold the CD-ROM sector data.
  hFile := CreateFile ( 'sector.dat',
                        GENERIC_WRITE, 0, nil, CREATE_ALWAYS,
                        FILE_ATTRIBUTE_NORMAL, 0);
{$ENDIF}
{$ENDIF}

  // For the purposes of this sample, drive F: is the CD-ROM
  // drive.
  hCD := CreateFile ( PChar('\\.\' + Drive + ':'), GENERIC_READ,
                      FILE_SHARE_READ or FILE_SHARE_WRITE,
                      nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

  // If the CD-ROM drive was successfully opened, read sectors 16
  // and 17 from it and write their contents out to a disk file.
  if (hCD <> INVALID_HANDLE_VALUE) then
  begin
    // Lock the compact disc in the CD-ROM drive to prevent accidental
    // removal while reading from it.
    pmrLockCDROM.PreventMediaRemoval := True;
    DeviceIoControl ( hCD, IOCTL_CDROM_MEDIA_REMOVAL,
                      @pmrLockCDROM, sizeof(pmrLockCDROM), nil,
                      0, dwNotUsed, nil);

    // Get sector size of compact disc
    if (DeviceIoControl ( hCD, IOCTL_CDROM_GET_DRIVE_GEOMETRY, nil, 0,
                          @dgCDROM, sizeof(dgCDROM),
                          dwNotUsed, nil)) then
    begin
      dwSize := SECTOR_COUNT * dgCDROM.BytesPerSector;  // SECTOR_COUNT sectors

      // Allocate buffer to hold sectors from compact disc. Note that
      // the buffer will be allocated on a sector boundary because the
      // allocation granularity is larger than the size of a sector on a
      // compact disk.
      lpSector := VirtualAlloc (  nil, dwSize,
                                  MEM_COMMIT or MEM_RESERVE,
                                  PAGE_READWRITE);

      // Move to 16th sector for something interesting to read.
      SetFilePointer (  hCD, dgCDROM.BytesPerSector * SECTOR_START_INDEX,
                        nil, FILE_BEGIN);

      // Read sectors from the compact disc and write them to a file.
      if ReadFile (hCD, lpSector^, dwSize, dwNotUsed, nil) then begin
{$IFDEF DEBUG}
{$IFDEF DUMP_SECTOR_TO_DISK}
        WriteFile (hFile, lpSector^, dwSize, dwNotUsed, nil);
{$ENDIF}
{$ENDIF}
        // Moving the lpSector data to the SectorBuf array
        SetLength(SectorBuf, dwSize);
        Move(lpSector^, SectorBuf[0], dwSize);

        // Calculating checksum on the SectorBuf
        
      end;
      WriteLn(SysErrorMessage(GetLastError));

      VirtualFree (lpSector, 0, MEM_RELEASE);
    end;

    // Unlock the disc in the CD-ROM drive.
    pmrLockCDROM.PreventMediaRemoval := False;
    DeviceIoControl ( hCD, IOCTL_CDROM_MEDIA_REMOVAL,
                      @pmrLockCDROM, sizeof(pmrLockCDROM), nil,
                      0, dwNotUsed, nil);

    CloseHandle (hCD);
{$IFDEF DEBUG}
{$IFDEF DUMP_SECTOR_TO_DISK}
    CloseHandle (hFile);
{$ENDIF}
{$ENDIF}
  end;
end;

//------------------------------------------------------------------------------

function GetDiscInfo(const Drive: Char): string;
var
  VolName, FileSysName: Array[0..Max_Path] Of Char;
  VolSerial, FileMaxLen, FileFlags: DWord;

begin
  if GetVolumeInformation ( PChar(Drive + ':\'), VolName, Max_Path, @VolSerial,
                            FileMaxLen, FileFlags, FileSysName, Max_Path) then
  begin
{$IFDEF DEBUG}
    WriteLn('Volume name: ' + VolName
      , sLineBreak, 'System file: ', FileSysName
      , sLineBreak, 'Serial number: ', IntToStr(VolSerial)
    );
{$ENDIF}
  end;
end;

//------------------------------------------------------------------------------

function GetMediaKey(const Drive: Char; RequestKey: string; var ResultKey: string): Boolean;
begin
  Result := IsDiscReady(Drive);
  if Result then
  begin
    WriteLn('Disc Ready');
    GetMediaHashKey(Drive); 
  end else
    WriteLn('Disc Not Ready');
end;

//------------------------------------------------------------------------------

end.
