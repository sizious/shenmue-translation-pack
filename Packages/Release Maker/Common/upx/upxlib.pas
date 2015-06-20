unit UPXLib;

interface

uses
  Windows, SysUtils;

procedure CompressBinary(const OutputFileName: TFileName);

implementation

uses
  SysTools, WorkDir;

var
  szUpxLib: TFileName;

procedure CompressBinary(const OutputFileName: TFileName);
begin
  RunAndWait(szUpxLib + ' -9 ' + OutputFileName);  
end;

initialization
  // Extracting 7z library to the temp directory.
  szUpxLib := GetWorkingTempDirectory + 'upx.exe';
  ExtractFile('UPX', szUpxLib);

end.
