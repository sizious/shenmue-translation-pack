{
  DrvUtils Unit :: Manage removable medias drives under Windows
  By [big_fury]SiZiOUS 2011.

  Date: 08/08/2011
  Version: 1

  Notes:
    - Sessions data aren't read, so it must be done.
    - Don't know if it works with ALL disc formats (CD-ROM and DVD-ROM at least)
    - DeviceIoControl with RAW_CDDA call is very very buggy, it doesn't like
      dynamic memory allocating so please use it with caution...
    - Coded under Delphi 2007 (yeah the last ANSI one), so don't know if works
      under Delphi 2009+ ...

  This unit is free software, in clear: do with it what you want, but if you can
  keep my name somewhere I'll be happy ;-)

  This code can be buggy, so feel free to send your bugs reports and/or your
  code fixes to sizious (at) gmail (dot) com.

  Thank you for reading!

  Your dear SiZ!
}
unit
  DrvUtils;

//------------------------------------------------------------------------------
interface
//------------------------------------------------------------------------------

uses
  Windows, SysUtils, Classes;

type
  TDriveUnitController = class;

  TTrackKind = (ttData, ttAudio);
  
  TDriveTracksListItem = class(TObject)
  private
    fSize: LongWord;
    fOffset: LongWord;
    fIndex: Integer;
    fOwner: TDriveUnitController;
    fKind: TTrackKind;
    procedure ReadData(OutStream: TStream; MaxSectors: LongWord);
    procedure ReadAudio(OutStream: TStream);
  public
    procedure Read(OutStream: TStream); overload;
    procedure Read(OutStream: TStream; MaxSectors: LongWord); overload;
    property Index: Integer read fIndex;
    property Kind: TTrackKind read fKind;
    property Offset: LongWord read fOffset;
    property Owner: TDriveUnitController read fOwner;
	  property Size: LongWord read fSize;
  end;

  TDriveTracksList = class(TObject)
  private
    fList: TList;
    fOwner: TDriveUnitController;
    function Add: TDriveTracksListItem;
    procedure Clear;    
    function GetItem(Index: Integer): TDriveTracksListItem;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TDriveTracksListItem read GetItem; default;
    property Owner: TDriveUnitController read fOwner;
  end;

  TTrackReadBeginEvent = procedure(Sender: TObject; Total: Int64) of object;
  TTrackReadEvent = procedure(Sender: TObject; Remaining, Total: Int64) of object;

  TDriveUnitController = class(TObject)
  private
    fHandleCD: THandle;
    fDrive: Char;
    fDriveTrackList: TDriveTracksList;
    fOnTrackRead: TTrackReadEvent;
    fBytesPerSector: LongWord;
    fSectorsPerTrack: LongWord;
    fTracksPerCylinder: LongWord;
    fVolumeLabel: string;
    fSerialNumber: string;
    fOnTrackReadEnd: TNotifyEvent;
    fOnTrackReadBegin: TTrackReadBeginEvent;
    fAborted: Boolean;
    function IsValidDriveHandle: Boolean;
    function SetDriveLockState(RequestLock: Boolean): Boolean;
    function GetDriveReady: Boolean;
    function QueryVolumeInformation(ADrive: Char): Boolean;
    property HandleCD: THandle read fHandleCD;
  public
    constructor Create; overload;
    constructor Create(ADrive: Char); overload;
    destructor Destroy; override;
    procedure Abort;
    procedure Close;
    function Eject: Boolean;
    function Inject: Boolean;
    function Lock: Boolean;
    function Open(ADrive: Char): Boolean;
    function Unlock: Boolean;
    property Aborted: Boolean read fAborted;
    property BytesPerSector: LongWord read fBytesPerSector;
    property Drive: Char read fDrive;
    property Ready: Boolean read GetDriveReady;
    property SectorsPerTrack: LongWord read fSectorsPerTrack;
    property SerialNumber: string read fSerialNumber;
    property Tracks: TDriveTracksList read fDriveTrackList;
    property TracksPerCylinder: LongWord read fTracksPerCylinder;
    property VolumeLabel: string read fVolumeLabel;
    property OnTrackReadBegin: TTrackReadBeginEvent read fOnTrackReadBegin
      write fOnTrackReadBegin;
    property OnTrackRead: TTrackReadEvent read fOnTrackRead write fOnTrackRead;
    property OnTrackReadEnd: TNotifyEvent read fOnTrackReadEnd
      write fOnTrackReadEnd;
  end;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

const
  MAXIMUM_NUMBER_TRACKS = 100;

  TRACK_GAP_SECTORS_COUNT = 150;
  SESSION_GAP_SECTORS_COUNT = 11400;

  IOCTL_CDROM_MEDIA_REMOVAL       = $24804;
  IOCTL_CDROM_GET_DRIVE_GEOMETRY  = $2404C;
  IOCTL_CDROM_READ_TOC            = $24000;
  IOCTL_CDROM_RAW_READ            = $2403E;

  IOCTL_STORAGE_LOAD_MEDIA        = $2D480C;
  IOCTL_STORAGE_EJECT_MEDIA       = $2D4808;
  IOCTL_STORAGE_CHECK_VERIFY2     = $2D0800;

type
  TMEDIA_TYPE = (
    Unknown, F5_1Pt2_512, F3_1Pt44_512, F3_2Pt88_512, F3_20Pt8_512,
    F3_720_512,F5_360_512, F5_320_512, F5_320_1024, F5_180_512, F5_160_512,
    RemovableMedia, FixedMedia, F3_120M_512, F3_640_512, F5_640_512,
    F5_720_512, F3_1Pt2_512, F3_1Pt23_1024, F5_1Pt23_1024, F3_128Mb_512,
    F3_230Mb_512, F8_256_128, F3_200Mb_512, F3_240M_512, F3_32M_512
  );

  TTRACK_MODE_TYPE = (
    YellowMode2,
    XAForm2,
    CDDA,
    RawWithC2AndSubCode,
    RawWithC2,
    RawWithSubCode
  );

  TRAW_READ_INFO = record
    DiskOffset: LARGE_INTEGER;
    SectorCount: LongWord;
    TrackMode: TTRACK_MODE_TYPE;
  end;

  TTrackDataAddressArray = array[0..3] of Byte;

  TTRACK_DATA = record
  private
    function GetControl: Byte;
    function GetAdr: Byte;
  public
    Reserved: Byte;
    ControlAdr: Byte;
    TrackNumber: Byte;
    Reserved1: Byte;
    Address: TTrackDataAddressArray;
    property Control: Byte read GetControl;
    property Adr: Byte read GetAdr;
  end;
  
  TCDROM_TOC = record
    Length: Word;
    FirstTrack: Byte;
    LastTrack: Byte;
    TrackData: array[0..MAXIMUM_NUMBER_TRACKS - 1] of TTRACK_DATA;
  end;
  
  TDISK_GEOMETRY = record
    Cylinders: Int64;
    MediaType: TMEDIA_TYPE;
    TracksPerCylinder: LongWord;
    SectorsPerTrack: LongWord;
    BytesPerSector: LongWord;
  end;

  TPREVENT_MEDIA_REMOVAL = record
    PreventMediaRemoval: Boolean;
  end;

  TDrivePath = array[0..6] of Char;

//------------------------------------------------------------------------------
// Tools
//------------------------------------------------------------------------------

function InitializeDrivePath(ADrive: Char): TDrivePath;
const
  DRIVE_PATH_VALUE: TDrivePath = ('\', '\', '.', '\', '~', ':', #0);
  
begin
  CopyMemory(@Result, @DRIVE_PATH_VALUE, SizeOf(DRIVE_PATH_VALUE));
  Result[4] := ADrive;
end;

// MSF
function AddressToSectors(addr: TTrackDataAddressArray): Int64;
const
  CD_BLOCKS_PER_SECOND = 75;
  
begin
  Result := (addr[1] * (CD_BLOCKS_PER_SECOND * 60) +
            (addr[2] * CD_BLOCKS_PER_SECOND) + addr[3]) - TRACK_GAP_SECTORS_COUNT;
end;

//------------------------------------------------------------------------------
// TDriveUnitController
//------------------------------------------------------------------------------

// Cancel every pending operations, for example reading tracks
procedure TDriveUnitController.Abort;
begin
  fAborted := True;
end;

// Close the drive, free the drive handle
procedure TDriveUnitController.Close;
begin
  fDrive := #0;
  fVolumeLabel := '';
  fSerialNumber := '';

  Tracks.Clear;
  Unlock;

  // Free the handle.
  CloseHandle( fHandleCD );
  fHandleCD := INVALID_HANDLE_VALUE;
end;

// Constructor, if parameter ADrive is passed, then drive will be opened
constructor TDriveUnitController.Create(ADrive: Char);
begin
  fDrive := ADrive;
  fDriveTrackList := TDriveTracksList.Create;
  fDriveTrackList.fOwner := Self;
  if Drive <> #0 then Open(Drive);
end;

// Constructor without opening drive
constructor TDriveUnitController.Create;
begin
  Create(#0);
end;

// Destructor, clean everything...
destructor TDriveUnitController.Destroy;
begin
  Close;
  fDriveTrackList.Free;
  inherited Destroy;
end;

// Open the drive tray
function TDriveUnitController.Eject;
var
  hCD: THandle;
  dwNotUsed: LongWord;

begin
  Result := False;
  if not IsValidDriveHandle then Exit;
  Unlock;
  hCD := HandleCD;
	Result := DeviceIoControl( hCD, IOCTL_STORAGE_EJECT_MEDIA, nil, 0, nil, 0,
    dwNotUsed, nil );
end;

// Query if the drive is in the idle state or not
function TDriveUnitController.GetDriveReady;
var
  hCD: THandle;
  dwNotUsed: LongWord;

begin
  Result := False;
  if not IsValidDriveHandle then Exit;
	hCD := HandleCD;
	Result := DeviceIoControl( hCD, IOCTL_STORAGE_CHECK_VERIFY2, nil, 0, nil, 0,
    dwNotUsed, nil );
end;

// Close the drive tray
function TDriveUnitController.Inject;
var
  hCD: THandle;
  dwNotUsed: LongWord;

begin
  Result := False;
  if not IsValidDriveHandle then Exit;
  hCD := HandleCD;
	Result := DeviceIoControl( hCD, IOCTL_STORAGE_LOAD_MEDIA, nil, 0, nil, 0,
    dwNotUsed, nil );
end;

// Internal, return if the drive handle is valid or not
function TDriveUnitController.IsValidDriveHandle;
begin
  Result := fHandleCD <> INVALID_HANDLE_VALUE;
end;

// Lock the drive tray (to prevent the user to eject the disc)
function TDriveUnitController.Lock;
begin
  Result := SetDriveLockState(True);  
end;

// Main function, to open the disc in the selected drive
function TDriveUnitController.Open;
var
  i, j: Integer;
  dwNotUsed: LongWord;
  TocTable: TCDROM_TOC;
  dgCDROM: TDISK_GEOMETRY;
  DrivePath: TDrivePath;

begin
  Result := False;

  // First, close the drive if needed
	Close;

  // Query volume information with the API first...
  // If not CDFS system, then exit !
  if not QueryVolumeInformation(ADrive) then Exit;

	// Open drive handle
  DrivePath := InitializeDrivePath(ADrive); // THIS IS SHIT! IF WE USE PAnsiChar, TRACK_RAW_READ DOESN'T WORK!! FUCK IT !!!
  fHandleCD := CreateFile(  DrivePath, GENERIC_READ,
                            FILE_SHARE_READ, nil, OPEN_EXISTING,
                            FILE_ATTRIBUTE_NORMAL, 0 );

  Result := fHandleCD <> INVALID_HANDLE_VALUE;
  if not Result then begin
		fHandleCD := INVALID_HANDLE_VALUE;
    Exit;
	end;

	// Lock drive
  Result := Lock;
	if not Result then begin
		Close;
    Exit;
	end;

  // Get sector size of compact disc
  if (DeviceIoControl ( fHandleCD, IOCTL_CDROM_GET_DRIVE_GEOMETRY, nil, 0,
                        @dgCDROM, SizeOf(dgCDROM),
                        dwNotUsed, nil)) then
  begin
    fTracksPerCylinder := dgCDROM.TracksPerCylinder;
    fSectorsPerTrack := dgCDROM.SectorsPerTrack;
    fBytesPerSector := dgCDROM.BytesPerSector;

{$IFDEF DEBUG}
    WriteLn('Media Type: ', Integer(dgCDROM.MediaType), sLineBreak,
            'Tracks Per Cylinder: ', dgCDROM.TracksPerCylinder, sLineBreak,
            'Sectors Per Track: ', dgCDROM.SectorsPerTrack, sLineBreak,
            'Bytes Per Sector: ', dgCDROM.BytesPerSector);
{$ENDIF}
  end;

	// Get track-table and add it to the intern array
  Result := DeviceIoControl( fHandleCD, IOCTL_CDROM_READ_TOC, nil, 0,
                             @TocTable, SizeOf(TocTable), dwNotUsed, nil );
  if not Result then begin
		Close;
		Exit;
	end;

  // Reading the TOC
	for i := TocTable.FirstTrack to TocTable.LastTrack do
    with Tracks.Add do begin
      j := i - TocTable.FirstTrack;
		  fOffset := AddressToSectors( TocTable.TrackData[j].Address );
	  	fSize := AddressToSectors( TocTable.TrackData[j + 1].Address ) - Offset;
      if ( TocTable.TrackData[j].Control = 0 ) then
        fKind := ttAudio
      else begin
        fKind := ttData;
        if i <> TocTable.LastTrack then
          Dec(fSize, TRACK_GAP_SECTORS_COUNT); // more 150 sectors if not the last track
      end;      

{$IFDEF DEBUG}
      WriteLn(
        ' #', Index, ': addr=', Offset,
        ', len=', Size,
        ', type=', TocTable.TrackData[j].ControlAdr,
        ', control=', TocTable.TrackData[j].Control,
        ', adr=', TocTable.TrackData[j].Adr);
{$ENDIF}
		end;

	// Return if track-count > 0
	Result := Tracks.Count > 0;
  if Result then fDrive := ADrive;
end;

// Used by Open, to query disc information
function TDriveUnitController.QueryVolumeInformation;
const
  CDFS_FILESYSTEM = 'CDFS'; // for CD-ROM
  UDF_FILESYSTEM = 'UDF';   // for DVD-ROM
  
var
  VolName, FileSysName: array[0..MAX_PATH-1] of Char;
  VolSerial, FileMaxLen, FileFlags: DWord;
  S: string;

begin
  Result := False;

  fVolumeLabel := '';
  fSerialNumber := '';

  if GetVolumeInformation ( PChar(ADrive + ':\'), VolName, MAX_PATH, @VolSerial,
                            FileMaxLen, FileFlags, FileSysName, MAX_PATH) then
  begin
    Result := SameText(FileSysName, CDFS_FILESYSTEM)
      or SameText(FileSysName, UDF_FILESYSTEM);

    if Result then
    begin
      fVolumeLabel := VolName;
      S := IntToHex(VolSerial, 8);
      fSerialNumber := Copy(S, 1, 4) + '-' + Copy(S, 5, 8);
    end;

{$IFDEF DEBUG}
    WriteLn(
      'Volume name: ', VolumeLabel, sLineBreak,
      'System file: ', FileSysName, sLineBreak,
      'Serial number: ', SerialNumber
    );
{$ENDIF}
  end;
end;

// Internal, used to lock/unlock the drive tray
function TDriveUnitController.SetDriveLockState;
var
  pmrLockCDROM: TPREVENT_MEDIA_REMOVAL;
  dwNotUsed: LongWord;
  
begin
  Result := IsValidDriveHandle;
  if Result then begin
    // Lock the compact disc in the CD-ROM drive to prevent accidental
    // removal while reading from it.
    pmrLockCDROM.PreventMediaRemoval := RequestLock;
    Result := DeviceIoControl ( fHandleCD, IOCTL_CDROM_MEDIA_REMOVAL,
                                @pmrLockCDROM, sizeof(pmrLockCDROM), nil, 0,
                                dwNotUsed, nil );
  end;
end;

// Unlock the drive tray
function TDriveUnitController.Unlock;
begin
  Result := SetDriveLockState(False);
end;

//------------------------------------------------------------------------------
// TDriveTrackList
//------------------------------------------------------------------------------

function TDriveTracksList.Add;
begin
  Result := TDriveTracksListItem.Create;
  Result.fIndex := fList.Add(Result);
  Result.fOwner := Self.Owner;
end;

procedure TDriveTracksList.Clear;
var
  i: Integer;

begin
  for i := 0 to fList.Count - 1 do
    Items[i].Free;
  fList.Clear;
end;

constructor TDriveTracksList.Create;
begin
  fList := TList.Create;
end;

destructor TDriveTracksList.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TDriveTracksList.GetCount;
begin
  Result := fList.Count;
end;

function TDriveTracksList.GetItem;
begin
  Result := TDriveTracksListItem(fList[Index]);
end;

//------------------------------------------------------------------------------
// TDriveTrackItem
//------------------------------------------------------------------------------

procedure TDriveTracksListItem.Read(OutStream: TStream);
begin
  Read(OutStream, 0);
end;

procedure TDriveTracksListItem.Read(OutStream: TStream; MaxSectors: LongWord);
begin
  case Kind of
    ttData : ReadData(OutStream, MaxSectors);
    ttAudio: ReadAudio(OutStream); // MaxSectors not implemented for this...
  end;
end;

procedure TDriveTracksListItem.ReadAudio;
const
  CD_SECTOR_SIZE = 2048;
  SECTORS_AT_READ = 20;
  CDDA_RAW_SECTOR_SIZE = 2352;

var
  lpSector: PByte;
  offs: LARGE_INTEGER;
  dwSize, dwBytesRead, dwOutBufferSize,
  dwCurrentSize: LongWord;
  Info: TRAW_READ_INFO;
  SectorsRemaining, SectorsToRead: Integer;
  hCD: THandle;
//  lpCriticalSection: RTL_CRITICAL_SECTION;

begin
//  EnterCriticalSection(lpCriticalSection);

  // The DeviceIoControl API fail if we use the Delphi property... ("Incorrect Parameter")...
  hCD := Owner.HandleCD;
  
  Info.TrackMode := CDDA;

  dwSize := SECTORS_AT_READ * CDDA_RAW_SECTOR_SIZE;

  GetMem(lpSector, dwSize);
  try
    // Fire the begin event
    if Assigned(Owner.OnTrackReadBegin) then
      Owner.OnTrackReadBegin(Owner, Size);
      
    SectorsRemaining := Size;
    offs.QuadPart := Offset * CD_SECTOR_SIZE;

    dwCurrentSize := 0;
    while (SectorsRemaining > 0) and (not Owner.Aborted) do
    begin
      // Set the read offset
      info.DiskOffset := offs;

      if SectorsRemaining > SECTORS_AT_READ then
        SectorsToRead := SECTORS_AT_READ
      else
        SectorsToRead := SectorsRemaining;

      Info.SectorCount := SectorsToRead;

      // Read the data
      dwBytesRead := 0;
      dwOutBufferSize := SectorsToRead * CDDA_RAW_SECTOR_SIZE;
      if DeviceIoControl( hCD, IOCTL_CDROM_RAW_READ, @Info,
                          SizeOf(TRAW_READ_INFO), lpSector, dwOutBufferSize,
                          dwBytesRead, nil ) then
      begin
        // Write it to the memory stream
        OutStream.Write(lpSector^, dwBytesRead);
      end else
        RaiseLastOSError;

      // Calculate the next read address
      SectorsRemaining := SectorsRemaining - SectorsToRead;
      offs.QuadPart := offs.QuadPart + SectorsToRead * CD_SECTOR_SIZE;

//      Write('Sectors remaining ', SectorsRemaining, ' ', #13);
      if Assigned(Owner.OnTrackRead) then begin
        Inc(dwCurrentSize, SectorsToRead);
        Owner.OnTrackRead(Owner, dwCurrentSize, Size);
      end;
    end;

  finally
    // Fire the track read event, the last one.
    if Assigned(Owner.OnTrackRead) then
      Owner.OnTrackRead(Owner, Size, Size);

    FreeMem(lpSector, dwSize);

    // Fire the end event
    if Assigned(Owner.OnTrackReadEnd) then
      Owner.OnTrackReadEnd(Owner);

//    LeaveCriticalSection(lpCriticalSection);
  end;
end;

procedure TDriveTracksListItem.ReadData;
const
  BUFFER_SIZE = 4096;
  
type
  TSectorBlock = array[0..BUFFER_SIZE-1] of Byte;

var
  hCD: THandle;
  lpSector: TSectorBlock; //Was "PByte" before
  DiskOffset: LARGE_INTEGER;
  dwBytesRead, dwTotalSize, dwBlockSize, dwCurrentSize,
  SectorsRemaining: LongWord;
  
begin
  hCD := Owner.HandleCD;
  
  // Define dump properties...
  dwBlockSize := Owner.BytesPerSector;
  if (MaxSectors <= 0) or (MaxSectors > Size) then
    MaxSectors := Size;
  dwTotalSize := MaxSectors * dwBlockSize;

  DiskOffset.QuadPart := Offset * dwBlockSize;

  // Allocate buffer to hold sectors from compact disc. Note that
  // the buffer will be allocated on a sector boundary because the
  // allocation granularity is larger than the size of a sector on a
  // compact disk.
  (*lpSector := VirtualAlloc (  nil, dwBlockSize,
                              MEM_COMMIT or MEM_RESERVE,
                              PAGE_READWRITE); *)

  (* SetLength(lpSector, dwBlockSize);
  ZeroMemory(lpSector, dwBlockSize); *)

  // !!! IMPORTANT !!!
  // THIS IS REALLY SHIT THAT DEVICEIOCONTROL API. IT DOESN'T WORK IF WE CALL
  // THE READAUDIO METHOD AFTER THE READDATA METHOD, IF WE USE DYNAMIC BUFFERS
  // IN THE READDATA METHOD ????!!!!!
  // DEVICEIOCONTROL FUCKING STUPID SHIT API !!!!!!!!!!!!!!!!!!!!!

  try
    // Fire the begin event
    if Assigned(Owner.OnTrackReadBegin) then
      Owner.OnTrackReadBegin(Owner, dwTotalSize);

    SectorsRemaining := dwTotalSize;
    dwCurrentSize := 0;
    
    // Read the track !
    while (SectorsRemaining > 0) and (not Owner.Aborted) do
    begin
      // Move to the requested sector.
      SetFilePointer( hCD, DiskOffset.LowPart,
                      @DiskOffset.HighPart, FILE_BEGIN );

      // Read sectors from the compact disc
      if ReadFile ( hCD, lpSector[0], dwBlockSize, dwBytesRead, nil ) then
        // Write it to the memory stream
        OutStream.Write(lpSector[0], dwBytesRead)
      else
        RaiseLastOSError;

      // Calculate the next read address
      SectorsRemaining := SectorsRemaining - dwBytesRead;
      // If the dwBytesRead = 0 then stop to read the track...
      if dwBytesRead < 1 then SectorsRemaining := 0;
      DiskOffset.QuadPart := DiskOffset.QuadPart + dwBlockSize;

      // Fire the track read event
      if Assigned(Owner.OnTrackRead) then begin
        Inc(dwCurrentSize, dwBytesRead);
        Owner.OnTrackRead(Owner, dwCurrentSize, dwTotalSize);
      end;

    end;

  finally
    // Fire the track read event, the last one.
    if Assigned(Owner.OnTrackRead) then
      Owner.OnTrackRead(Owner, dwTotalSize, dwTotalSize);

    // Setting sector pointer
    DiskOffset.QuadPart := 0;
    SetFilePointer( hCD, DiskOffset.LowPart, @DiskOffset.HighPart, FILE_BEGIN );
//    hCD := INVALID_HANDLE_VALUE;
    
    // Destroying buffer.
    (* VirtualFree (lpSector, 0, MEM_RELEASE); *)
    
    // Fire the end event
    if Assigned(Owner.OnTrackReadEnd) then
      Owner.OnTrackReadEnd(Owner);
  end;
end;

//------------------------------------------------------------------------------
// TTRACK_DATA
//------------------------------------------------------------------------------

function TTRACK_DATA.GetAdr;
begin
  Result := (ControlAdr and $F0) shr 4;
end;

function TTRACK_DATA.GetControl;
begin
  Result := ControlAdr and $0F;
end;

end.
