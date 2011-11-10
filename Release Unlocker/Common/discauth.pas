{
  Threaded object to retrieve hash key from medias.
}
unit
  DiscAuth;

// Enable this to dump the read sectors onto the disk
// {$DEFINE DUMP_SECTORS_TO_DISK}

interface

uses
  Windows, SysUtils, Classes, DrvUtils, OpThBase;

type
  TDiscValidatorSuccessEvent = procedure(Sender: TObject;
    const MediaKey: string) of object;

  TDiscValidatorThread = class(TOperationThread)
  private
    fMediaHashKey: string;
    fDrive: Char;
    fOnFail: TNotifyEvent;
    fOnSuccess: TDiscValidatorSuccessEvent;
    fDriveUnitController: TDriveUnitController;
    procedure EventFailed;
    procedure EventSuccess;
    procedure EventTrackReadBegin(Sender: TObject; Total: Int64);
    procedure EventTrackRead(Sender: TObject; Remaining, Total: Int64);
    procedure EventTrackReadEnd(Sender: TObject);
    function GetVolumeLabel: string;
    property DriveUnitController: TDriveUnitController read
      fDriveUnitController write fDriveUnitController;
  protected
    function GetMediaHashKey(InputMemoryStream: TMemoryStream): Boolean;
    procedure Execute; override;
  public
    procedure Abort; override;
    property Drive: Char read fDrive write fDrive;
    property VolumeLabel: string read GetVolumeLabel;
    property OnFail: TNotifyEvent read fOnFail write fOnFail;
    property OnSuccess: TDiscValidatorSuccessEvent read fOnSuccess
      write fOnSuccess;
  end;

implementation

uses
  MD5Api, Base64;
  
{ TDiscValidatorThread }

procedure TDiscValidatorThread.Abort;
begin
{$IFDEF DEBUG}
  WriteLn('TDiscValidatorThread.Abort');
{$ENDIF}

  // Cancel the read of the track inside the DriveUnitController
  DriveUnitController.Abort;

  // Call original method
  inherited Abort;
end;

procedure TDiscValidatorThread.EventFailed;
begin
  DriveUnitController.Eject;
  if Assigned(OnFail) then
    OnFail(Self);
end;

procedure TDiscValidatorThread.EventSuccess;
begin
  if Assigned(OnSuccess) then
    OnSuccess(Self, fMediaHashKey);
end;

procedure TDiscValidatorThread.EventTrackRead(Sender: TObject; Remaining,
  Total: Int64);
begin
  fCurrent := Remaining;
  fTotal := Total;
  CallSyncProgressEvent;
{$IFDEF DEBUG}
  Write(' Reading... ', Remaining, ' / ', Total, #13);
{$ENDIF}
end;

procedure TDiscValidatorThread.EventTrackReadBegin;
begin
  fTotal := Total;
  CallSyncStartEvent;
end;

procedure TDiscValidatorThread.EventTrackReadEnd(Sender: TObject);
begin
{$IFDEF DEBUG}
  WriteLn(' Done...');
{$ENDIF}
end;

procedure TDiscValidatorThread.Execute;
const
  XBOX_TRACKID_SECTORS_SIZE = 6992;

var
  Result: Boolean;
  MemoryStream: TMemoryStream;
  i: Integer;

begin
  // Was the thread cancelled ?
  fAborted := False;

  // Was the job done ?
  fTerminated := False;

  // Will contains the result of the authentification : True = Disc OK
  Result := False;

  // Use the DriveUnitController class to read data from the discs
  DriveUnitController := TDriveUnitController.Create;
  MemoryStream := TMemoryStream.Create;
  try
    // Assign events....
    with DriveUnitController do
    begin
      OnTrackReadBegin := EventTrackReadBegin;
      OnTrackRead := EventTrackRead;
      OnTrackReadEnd := EventTrackReadEnd;
    end;

    // Run track dump !
    try
      // Open the selected drive if possible...
      if DriveUnitController.Open(Drive) then
      begin
        // Read the tracks...
          i := 0;
//        for i := 0 to DriveUnitController.Tracks.Count - 1 do
          DriveUnitController.Tracks[i].Read(MemoryStream, XBOX_TRACKID_SECTORS_SIZE);

{$IFDEF DEBUG}{$IFDEF DUMP_SECTORS_TO_DISK}
        MemoryStream.SaveToFile('DISCAUTH.BIN');
{$ENDIF}{$ENDIF}

        // Retrive the Media Hash Key
        Result := GetMediaHashKey(MemoryStream);
      end
{$IFDEF DEBUG}
      else
        WriteLn('Error when reading drive ', Drive, '...')
{$ENDIF};

      // Finish !!!
      if not Aborted then
      begin
        Sleep(2000);

        // Fire the right event...
        if Result then
          Synchronize(EventSuccess)
        else
          Synchronize(EventFailed);
      end;

    except
      // If an exception occurs, fire the failed event.
      if not Aborted then
        Synchronize(EventFailed);
    end;

  finally
    DriveUnitController.Free;
    MemoryStream.Free;
    CallSyncFinishEvent;
  end;
end;

function TDiscValidatorThread.GetMediaHashKey;
var
  Hash: TMD5Data;
  Buf: PByte;
  Size: LongWord;
  S: string;

begin
  Size := InputMemoryStream.Size;
  GetMem(Buf, Size);
  try
    // Convert the MemoryStream to a continous buffer
    ZeroMemory(Buf, Size);
    InputMemoryStream.Seek(0, soFromBeginning);
    InputMemoryStream.Read(Buf^, Size);

    // Compute MD5 and return it
    Hash := MD5DataFromBuffer(Buf^, Size);
    Hash := MD5OddSwap(MD5Reverse(Hash));
    S := StrToBase64(MD5DataToStr(Hash));
    fMediaHashKey := MD5DataToStr(MD5DataFromString(S));
    Result := MD5StrCheck(fMediaHashKey);
  finally
    FreeMem(Buf, Size);
  end;
end;


function TDiscValidatorThread.GetVolumeLabel: string;
begin
  try
    Result := DriveUnitController.VolumeLabel;
  except
    Result := '';
  end;
end;

end.
