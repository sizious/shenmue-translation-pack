{
  FastCopyFile

  By SiZiOUS 2014, based on the work by Davy Landman
  www.sizious.com - @sizious - fb.com/sizious - sizious (at) gmail (dot) com

  This unit was designed to copy a file using the Windows API.
  It's faster than using the (old) BlockRead/Write and TFileStream methods.

  Every destination file will be overwritten (by choice), unless you specify
  the fcfmAppend CopyMode flag. In that case, the source file will be appened to
  the destination file (instead of overwriting it).

  You have the choice to use a normal procedure callback, method object callback
  or no callback at all. The callback is used to cancel the copy process and to
  display the copy progress on-screen.

  Developed and tested under Delphi 2007 (ANSI).
  If you are using a Unicode version of Delphi (greater than Delphi 2007), may
  be you need to do some adapations (beware of the WideString type).

  All credits flying to Davy Landman.
  http://stackoverflow.com/questions/438260/delphi-fast-file-copy   
}
unit FastCopy;

interface

uses
  Windows, SysUtils;

type
  TFastCopyFileMode = (fcfmCreate, fcfmAppend);
  TFastCopyFileNormalCallback = procedure(const FileName: TFileName;
    const CurrentSize, TotalSize: LongWord; var CanContinue: Boolean);
  TFastCopyFileMethodCallback = procedure(const FileName: TFileName;
    const CurrentSize, TotalSize: LongWord; var CanContinue: Boolean) of object;

// Simplest definition
function FastCopyFile(
  const ASourceFileName, ADestinationFileName: TFileName): Boolean; overload;

// Definition with CopyMode and without any callbacks
function FastCopyFile(
  const ASourceFileName, ADestinationFileName: TFileName;
  CopyMode: TFastCopyFileMode): Boolean; overload;

// Definition with normal procedure callback
function FastCopyFile(
  const ASourceFileName, ADestinationFileName: TFileName;
  CopyMode: TFastCopyFileMode;
  Callback: TFastCopyFileNormalCallback): Boolean; overload;

// Definition with object method callback  
function FastCopyFile(
  const ASourceFileName, ADestinationFileName: TFileName;
  CopyMode: TFastCopyFileMode;
  Callback: TFastCopyFileMethodCallback): Boolean; overload;
    
implementation

{ Dummy Callback: Method Version }
type
  TDummyCallBackClient = class(TObject)
  private
    procedure DummyCallback(const FileName: TFileName;
      const CurrentSize, TotalSize: LongWord; var CanContinue: Boolean);
  end;

procedure TDummyCallBackClient.DummyCallback(const FileName: TFileName;
  const CurrentSize, TotalSize: LongWord; var CanContinue: Boolean);
begin
  // Nothing
  CanContinue := True;
end;

{ Dummy Callback: Classical Procedure Version }
procedure DummyCallback(const FileName: TFileName;
  const CurrentSize, TotalSize: LongWord; var CanContinue: Boolean);
begin
  // Nothing
  CanContinue := True;
end;

{ CreateFileW API abstract layer }
function OpenLongFileName(ALongFileName: string; DesiredAccess, ShareMode,
  CreationDisposition: LongWord): THandle;
var
  IsUNC: Boolean;
  FileName: PWideChar;

begin
  // Translate relative paths to absolute ones
  ALongFileName := ExpandFileName(ALongFileName);
  
  // Check if already an UNC path
  IsUNC := Copy(ALongFileName, 1, 2) = '\\';
  if not IsUNC then
    ALongFileName := '\\?\' + ALongFileName;

  // Preparing the FileName for the CreateFileW API call
  FileName := PWideChar(WideString(ALongFileName));

  // Calling the API
  Result := CreateFileW(FileName, DesiredAccess, ShareMode, nil,
    CreationDisposition, FILE_ATTRIBUTE_NORMAL, 0);
end;

{ FastCopyFile implementation }
function FastCopyFile(const ASourceFileName, ADestinationFileName: TFileName;
  CopyMode: TFastCopyFileMode;
  Callback: TFastCopyFileNormalCallback;
  Callback2: TFastCopyFileMethodCallback): Boolean; overload;
const
  BUFFER_SIZE = 524288; // 512KB blocks, change this to tune your speed

var
  Buffer: array of Byte;
  ASourceFile, ADestinationFile: THandle;
  FileSize, BytesRead, BytesWritten, BytesWritten2, TotalBytesWritten,
  CreationDisposition: LongWord;
  CanContinue, CanContinueFlag: Boolean;

begin
  FileSize := 0;
  TotalBytesWritten := 0;
  CanContinue := True;
  SetLength(Buffer, BUFFER_SIZE);

  // Manage the Creation Disposition flag
  CreationDisposition := CREATE_ALWAYS;
  if CopyMode = fcfmAppend then
    CreationDisposition := OPEN_ALWAYS;

  // Opening the source file in read mode
  ASourceFile := OpenLongFileName(ASourceFileName, GENERIC_READ, 0, OPEN_EXISTING);
  if ASourceFile <> 0 then
  try
    FileSize := FileSeek(ASourceFile, 0, FILE_END);
    FileSeek(ASourceFile, 0, FILE_BEGIN);

    // Opening the destination file in write mode (in create/append state)
    ADestinationFile := OpenLongFileName(ADestinationFileName, GENERIC_WRITE,
      FILE_SHARE_READ, CreationDisposition);

    if ADestinationFile <> 0 then
    try
      // If append mode, jump to the file end
      if CopyMode = fcfmAppend then
        FileSeek(ADestinationFile, 0, FILE_END);

      // For each blocks in the source file
      while CanContinue and (LongWord(FileSeek(ASourceFile, 0, FILE_CURRENT)) < FileSize) do
      begin

        // Reading from source
        if (ReadFile(ASourceFile, Buffer[0], BUFFER_SIZE, BytesRead, nil)) and (BytesRead <> 0) then
        begin
          // Writing to destination
          WriteFile(ADestinationFile, Buffer[0], BytesRead, BytesWritten, nil);

          // Read/Write secure code block (e.g. for WiFi connections)
          if BytesWritten < BytesRead then
          begin
            WriteFile(ADestinationFile, Buffer[BytesWritten], BytesRead - BytesWritten, BytesWritten2, nil);
            Inc(BytesWritten, BytesWritten2);
            if BytesWritten < BytesRead then
              RaiseLastOSError;
          end;

          // Notifying the caller for the current state
          Inc(TotalBytesWritten, BytesWritten);
          CanContinueFlag := True;
          if Assigned(Callback) then
            Callback(ASourceFileName, TotalBytesWritten, FileSize, CanContinueFlag);
          CanContinue := CanContinue and CanContinueFlag;
          if Assigned(Callback2) then
            Callback2(ASourceFileName, TotalBytesWritten, FileSize, CanContinueFlag);
          CanContinue := CanContinue and CanContinueFlag;
        end;

      end;

    finally
      CloseHandle(ADestinationFile);
    end;

  finally
    CloseHandle(ASourceFile);
  end;

  // Check if cancelled or not
  if not CanContinue then
    if FileExists(ADestinationFileName) then
      DeleteFile(ADestinationFileName);

  // Results (checking CanContinue flag isn't needed)
  Result := (FileSize <> 0) and (FileSize = TotalBytesWritten); 
end;

{ FastCopyFile simple definition }
function FastCopyFile(const ASourceFileName, ADestinationFileName: TFileName): Boolean; overload;
begin
  Result := FastCopyFile(ASourceFileName, ADestinationFileName, fcfmCreate);
end;

{ FastCopyFile definition without any callbacks }
function FastCopyFile(const ASourceFileName, ADestinationFileName: TFileName;
  CopyMode: TFastCopyFileMode): Boolean; overload;
begin
  Result := FastCopyFile(ASourceFileName, ADestinationFileName, CopyMode,
    DummyCallback);
end;

{ FastCopyFile definition with normal procedure callback }
function FastCopyFile(const ASourceFileName, ADestinationFileName: TFileName;
  CopyMode: TFastCopyFileMode;
  Callback: TFastCopyFileNormalCallback): Boolean; overload;
var
  DummyObj: TDummyCallBackClient;

begin
  DummyObj := TDummyCallBackClient.Create;
  try
    Result := FastCopyFile(ASourceFileName, ADestinationFileName, CopyMode,
      Callback, DummyObj.DummyCallback);
  finally
    DummyObj.Free;
  end;
end;

{ FastCopyFile definition with object method callback }
function FastCopyFile(const ASourceFileName, ADestinationFileName: TFileName;
  CopyMode: TFastCopyFileMode;
  Callback: TFastCopyFileMethodCallback): Boolean; overload;
begin
  Result := FastCopyFile(ASourceFileName, ADestinationFileName, CopyMode,
    DummyCallback, Callback);
end;

end.
