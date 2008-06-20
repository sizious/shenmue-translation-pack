unit afscreate;

interface

uses
  Windows, SysUtils, Classes, UIntList, Forms;

type
  TFileList = Record
    OutputFile: String;
    FileName: TStringList;

    procedure InitializeVar;
    procedure ClearVar;
    procedure FreeVar;
    procedure AddFile(FileName: TFileName);
    function GetFileName(FileIndex: Integer): TFileName;
    function GetCount: Integer;
    procedure DeleteFile(FileIndex: Integer);
  end;

procedure InitOptsVars;
function IsOptsInit: Boolean;
function StartAfsCreation: Boolean;

var
  createMainList: TFileList;
  blockSize: Integer;
  fPadding, fEndList: Boolean;
  optsInit: Boolean;

implementation
uses UAfsCreation;

procedure TFileList.InitializeVar;
begin
  Self.FileName := TStringList.Create;
end;

procedure TFileList.ClearVar;
begin
  Self.OutputFile := '';
  Self.FileName.Clear;
end;

procedure TFileList.FreeVar;
begin
  Self.FileName.Free;
end;

procedure TFileList.AddFile(FileName: TFileName);
begin
  Self.FileName.Add(FileName);
end;

function TFileList.GetFileName(FileIndex: Integer): TFileName;
begin
  Result := Self.FileName[FileIndex];
end;

function TFileList.GetCount: Integer;
begin
  Result := Self.FileName.Count;
end;

procedure TFileList.DeleteFile(FileIndex: Integer);
begin
  Self.FileName.Delete(FileIndex);
end;

procedure InitOptsVars;
begin
  blockSize := 2048;
  fPadding := False;
  fEndList := True;
  optsInit := True;
end;

function IsOptsInit: Boolean;
begin
  Result := optsInit;
end;

function StartAfsCreation: Boolean;
var
  afsCreateThread: TAfsCreation;
begin
  //Starting thread with createMainList content
  Result := False;
  afsCreateThread := TAfsCreation.Create;

  //Wait until the thread is finished
  repeat
    Application.ProcessMessages;
  until (afsCreateThread.ThreadTerminated);
  Result := True;
end;

end.
