program readdisc;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  Classes;

type
  TTrackDataAddressArray = array[0..3] of Byte;

  TTrackData = packed record
    Reserved: Byte;
    ControlAdr: Byte;
    TrackNumber: Byte;
    Reserved1: Byte;
    Address: TTrackDataAddressArray;
  end;

  TCDROMTOC = packed record
    Length: Word;
    FirstTrack: Byte;
    LastTrack: Byte;
    TrackData: array[0..99] of TTrackData;
  end;


  TRAWReadInfo = packed record
    DiskOffset: Int64;
    SectorCount: Cardinal;
    TrackMode: Cardinal;
  end;

const
  IOCTL_CDROM_READ_TOC = $00024000;
  IOCTL_CDROM_RAW_READ = $0002403e;

  YellowMode2 = 0;
  XAForm2 = 1;
  CDDA = 2;

const
  sector_size = 2352;
  sector_count = 20;

function AddressToSectors(addr: TTrackDataAddressArray): int64;
begin
  result := addr[1] * 75 * 60 + addr[2] * 75 + addr[3] - 150;
end;

procedure ReadTrackData(AStream: TStream; AID: integer; const AToc: TCDROMTOC;
  ADev: HFILE);
var
  buf: PByte;
  s: integer;
  c, rc: integer;
  offs: Int64;
  read: Cardinal;
  info: TRAWReadInfo;
  addr: int64;
  length: int64;
begin
  Writeln;
  Writeln('Reading track ', AID);

  //Calculate address and length of the track
  addr := AddressToSectors(AToc.TrackData[AID - AToc.FirstTrack].Address);
  length := AddressToSectors(AToc.TrackData[AID - AToc.FirstTrack + 1].Address) - addr;

  info.TrackMode := XAForm2; //CDDA;

  s := sector_size * sector_count;
  GetMem(buf, s);
  try
    c := length;
    offs := addr * 2048;

    while c > 0 do
    begin
      //Set the read offset
      info.DiskOffset := offs;

      if c > sector_count then
        rc := sector_count
      else
        rc := c;

      info.SectorCount := rc;

      //Read the data
      if not DeviceIoControl(ADev, IOCTL_CDROM_RAW_READ, @info, SizeOf(info), buf,
        rc * 2352, read, nil) then
        RaiseLastOSError;

      //Write it to the memory stream
      AStream.Write(buf^, read);

      //Calculate the next read address
      c := c - sector_count;
      offs := offs + sector_count * 2048;

      Write('Sectors remaining ', c, ' ', #13);
    end;
  finally
    FreeMem(buf, s);
  end;
  Writeln;
end;

var
  i: integer;
  fs: TStream;
  hndl: HFILE;
  dummy: Cardinal;
  toc: TCDROMTOC;

  Info: TRAWReadInfo;
  buf: PByte;

begin
  //Open the CD-Audio (F: is the drive letter of the cd drive)
  hndl := CreateFile('\\.\N:', GENERIC_READ,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);

  if hndl <> INVALID_HANDLE_VALUE then
  begin
    try
      //Read the cd audio table of content
      if not DeviceIoControl(hndl, IOCTL_CDROM_READ_TOC, nil, 0, @toc, SizeOf(toc), dummy,
        nil) then
        RaiseLastOSError;


      // TEST...
      GetMem(Buf, 20*2352);
      Info.DiskOffset := 1474560;
      Info.SectorCount := 20;
      Info.TrackMode := CDDA;

      if not ( DeviceIoControl( hndl, IOCTL_CDROM_RAW_READ,
        @Info, sizeof(Info), Buf, 20*2352, Dummy, nil ) ) then
        RaiseLastOSError;

      WriteLn(Buf^);

      FreeMem(Buf);
      ReadLn;
      Exit;
      // TEST...

      //Read every track
      for i := toc.FirstTrack to toc.LastTrack do
      begin
        fs := TFileStream.Create('track'+FormatFloat('00', i)+'.raw', fmCreate);
        try
          ReadTrackData(fs, i, toc, hndl);
        finally
          fs.Free;
        end;
      end;
    finally
      //Close the device
      CloseHandle(hndl);
    end;
  end;
end.
