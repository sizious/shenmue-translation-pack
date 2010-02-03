unit lzmadec;

interface

uses
  SysUtils;

type
  ESevenZipEngineMissingException = class(Exception);
  
function SevenZipExtract(const SourceFile: TFileName; OutputDir: TFileName): Boolean;
function SevenZipInitEngine(WorkDirectory: TFileName): Boolean;

//==============================================================================
implementation
//==============================================================================

uses
  SysTools;

var
  SevenZipDecExec: TFileName;

//==============================================================================

function SevenZipExtract(const SourceFile: TFileName; OutputDir: TFileName): Boolean;
begin
  Result := False;
  if not FileExists(SevenZipDecExec) then
    raise ESevenZipEngineMissingException.Create('LZMADec: Engine doesn''t exists. Please call SevenZipInitEngine() first.');
  
  if not DirectoryExists(OutputDir) then
    ForceDirectories(OutputDir);

  // Delete the last "\" for the OutputDir
  if Copy(OutputDir, Length(OutputDir) - 1, 1) = '\' then
    OutputDir := Copy(OutputDir, 1, Length(OutputDir - 1));

  Result :=
    RunAndWait(SevenZipDecExec + ' x "' + SourceFile + '" "' + OutputDir + '"');

{$IFDEF DEBUG}
    WriteLn('RunAndWait Result on 7zDec: ', Result);
{$ENDIF}
end;

//------------------------------------------------------------------------------

function SevenZipInitEngine(WorkDirectory: TFileName): Boolean;
begin
  SevenZipDecExec := IncludeTrailingPathDelimiter(WorkDirectory) + '7zDec.exe';
  Result := ExtractFile('LZMA', SevenZipDecExec);
end;

//------------------------------------------------------------------------------

function SevenZipClearEngine: Boolean;
begin
  if FileExists(SevenZipDecExec) then
    Result := DeleteFile(SevenZipDecExec);
end;

//==============================================================================

initialization

//------------------------------------------------------------------------------

finalization
  SevenZipClearEngine;

//==============================================================================

end.
