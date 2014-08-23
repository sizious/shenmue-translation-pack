unit ProcUtil;

interface

uses 
  Windows, TLHelp32, SysUtils;

function GetProcessIdByName(const FileName: TFileName): THandle;
function KillProcess(const FileName: TFileName): Integer;

implementation

function GetProcessIdByName(const FileName: TFileName): THandle;
var
  Snapshot: THandle;
  ProcEntry: TProcessEntry32;
  Found: Boolean;

begin
  Result := INVALID_HANDLE_VALUE;
  Found := False;
  Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (Snapshot <> INVALID_HANDLE_VALUE) then
  begin
    ProcEntry.dwSize := SizeOf(ProcessEntry32); 
    if (Process32First(Snapshot, ProcEntry)) then
    begin
      Found := UpperCase(ProcEntry.szExeFile) = UpperCase(FileName);
      while (not Found) and Process32Next(Snapshot, ProcEntry) do
      begin
        Found := UpperCase(ProcEntry.szExeFile) = UpperCase(FileName);
      end; 
    end; 
  end;
  if Found then
    Result := ProcEntry.th32ProcessID;
  CloseHandle(snapshot);
end;

function KillProcess(const FileName: TFileName): Integer;
var
  ContinueLoop: Boolean;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(FileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(FileName))) then
      Result := Integer(TerminateProcess(
                        OpenProcess(PROCESS_TERMINATE,
                                    BOOL(0),
                                    FProcessEntry32.th32ProcessID),
                                    0));
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

end.
