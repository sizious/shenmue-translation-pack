unit ProcUtil;

interface

uses 
  Windows, TLHelp32, SysUtils;

function GetProcessIdByName(const FileName: TFileName): THandle;

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

end.
