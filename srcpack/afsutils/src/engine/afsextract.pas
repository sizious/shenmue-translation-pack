unit afsextract;

interface

uses
  Windows, SysUtils, Classes, UIntList, Forms;

type
  TAfsInfos = Record
    FileName: TStringList;
    FileOffset: TIntList;
    FileSize: TIntList;
    FileDate: TStringList;
  end;

type
  TAfsQueue = Record
    NameIndex: Integer;
    OutputDir: String;
    FileIndex: TIntList;
  end;

procedure InitializeVars;
procedure FreeVars;
procedure ClearVars;
procedure ClearQueue;
function StartAfsExtraction: Boolean;

var
  afsMain:TAfsInfos;
  afsMainQueue: TAfsQueue;
  afsFileName: TStringList;
  doXmlList: Boolean;

implementation
uses UAfsExtraction;

procedure InitializeVars;
begin
  afsMain.FileName := TStringList.Create;
  afsMain.FileOffset := TIntList.Create;
  afsMain.FileSize := TIntList.Create;
  afsMain.FileDate := TStringList.Create;
  afsMainQueue.FileIndex := TIntList.Create;
  afsFileName := TStringList.Create;
  doXmlList:= True;
end;

procedure FreeVars;
begin
  afsMain.FileName.Free;
  afsMain.FileOffset.Free;
  afsMain.FileSize.Free;
  afsMain.FileDate.Free;
  afsMainQueue.FileIndex.Free;
  afsFileName.Free;
end;

procedure ClearVars;
begin
  afsMain.FileName.Clear;
  afsMain.FileOffset.Clear;
  afsMain.FileSize.Clear;
  afsMain.FileDate.Clear;
end;

procedure ClearQueue;
begin
  afsMainQueue.NameIndex := -1;
  afsMainQueue.OutputDir := '';
  afsMainQueue.FileIndex.Clear;
end;

function StartAfsExtraction: Boolean;
var
  AfsExtractThread: TAfsExtraction;
begin
  //This will start the extraction thread with afsMainQueue content
  afsExtractThread := TAfsExtraction.Create;

  repeat
    //Waiting until the thread is finished
    Application.ProcessMessages;
  until (afsExtractThread.ThreadTerminated);
  Result := True;
end;

end.
