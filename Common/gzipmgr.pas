unit gzipmgr;

interface

uses
  Windows, SysUtils;

type
  EGZipGeneric = class(Exception);
  EGZipEngineMissing = class(EGZipGeneric);
  EGZipBatchFileWriting = class(EGZipGeneric);

function GZipCompress(const InputFileName: TFileName): Boolean; overload;
function GZipCompress(const InputFileName, OutputFileName: TFileName): Boolean; overload;
function GZipDecompress(const InputFileName: TFileName; OutputDir: TFileName;
  var OutputFileName: TFileName): Boolean;
function GZipInitEngine(WorkDirectory: TFileName): Boolean;

//==============================================================================
implementation
//==============================================================================

uses
  Classes, SysTools;

const
  GZIP_UNPACKED_FILE_TAG = 'replaced with ';

type
  TGZipAction = (gaCompress, gaDecompress);
  
var
  GZipExec: TFileName;

//==============================================================================

// The GZ format supports only ONE single file compressed.
function GZipExecuteAction(const InputFileName: TFileName; OutputDir: TFileName;
  var OutputFileName: TFileName; GZipAction: TGZipAction): Boolean;
var
{$IFDEF DEBUG}
  GZipDebugOutput: string;
{$ENDIF}
  BatchCommandLine, CmdSwitch: string;
  i: Integer;
  FBatchFile: TextFile;
  RadicalFileName,
  InternalSourceFileName, BatchFileName,
  ResultOutFile, CurrentDir: TFileName;
  ResultSL: TStringList;
  Done: Boolean;

begin
  Result := False;
  OutputFileName := '';

  // Setting up the command line switch
  case GZipAction of
    gaCompress: CmdSwitch := '9';
    gaDecompress: CmdSwitch := 'd';
  end;
  
  // Checking up the engine
  if not FileExists(GZipExec) then
    raise EGZipEngineMissing.Create('GZipDecompress [GZipMgr]: Engine doesn''t exists. ' +
      'Please call GZipInitEngine() first.');

  // Checking the source file
  if not FileExists(InputFileName) then
    Exit;

  // Checking the output directory
  OutputDir := IncludeTrailingPathDelimiter(ExpandFileName(OutputDir));
  if not DirectoryExists(OutputDir) then
    ForceDirectories(OutputDir);

  // Checking the file input
  RadicalFileName := ChangeFileExt(ExtractFileName(InputFileName), '');
  InternalSourceFileName := InputFileName;

  // Copy the file to decompress in the OutputDir
  if GZipAction = gaDecompress then begin
    InternalSourceFileName := OutputDir + RadicalFileName + '.GZ';
    CopyFile(InputFileName, InternalSourceFileName, False);
  end;

  // Create the batch
  try
    BatchFileName := OutputDir + RadicalFileName + '.BAT';
    ResultOutFile := OutputDir + RadicalFileName + '.OUT';

    // Writing the batch onto disk
    AssignFile(FBatchFile, BatchFileName);
    ReWrite(FBatchFile);

    WriteLn(FBatchFile,
      '@echo off', sLineBreak,
      'rem Generated by GZipMgr Unit by [big_fury]SiZiOUS', sLineBreak,
      '"', GZipExec, '" -', CmdSwitch, ' -v -f -N "',
        ExtractFileName(InternalSourceFileName), '" 2> "',
        ResultOutFile, '"', sLineBreak,
      ':del_batch', sLineBreak,
      'del "', BatchFileName, '"', sLineBreak,
      'if exist "', BatchFileName, '" goto del_batch'
    );
    
    CloseFile(FBatchFile);
  except
    on E:Exception do
      raise EGZipBatchFileWriting.Create('GZipExtract [GZipMgr]: Error '
        + 'when creating process Batch File.');
  end;

  // Running the batch file...
  CurrentDir := GetCurrentDir;
  SetCurrentDir(OutputDir);
  BatchCommandLine := '"' + BatchFileName + '" > nul 2> nul';
  Result := RunAndWait(BatchCommandLine);
  SetCurrentDir(CurrentDir);

  // Parsing output
  if Result and FileExists(ResultOutFile) then begin
    ResultSL := TStringList.Create;
    try
      ResultSL.LoadFromFile(ResultOutFile);
      DeleteFile(ResultOutFile);
{$IFDEF DEBUG}
      GZipDebugOutput := ResultSL.Text;
{$ENDIF}

      Done := False;
      i := 0;
      while (not Done) and (i < ResultSL.Count) do begin
        Done := Pos(ExtractFileName(InternalSourceFileName), ResultSL[i]) <> 0;
        if Done then
          OutputFileName := Right(GZIP_UNPACKED_FILE_TAG, ResultSL[i]);
        Inc(i);
      end;

    finally
      ResultSL.Free;
    end;
  end;

  // Checking result
  Result := OutputFileName <> '';
  OutputFileName := OutputDir + OutputFileName;

  // Cleaning temp file
  if FileExists(InternalSourceFileName) then
    DeleteFile(InternalSourceFileName);

{$IFDEF DEBUG}
  WriteLn(GZipDebugOutput);
  WriteLn('RunAndWait Result on GzipMgr: ', Result);
{$ENDIF}
end;

//------------------------------------------------------------------------------

function GZipCompress(const InputFileName: TFileName): Boolean; overload;
begin
  Result := GZipCompress(InputFileName, InputFileName);
end;

//------------------------------------------------------------------------------

function GZipCompress(const InputFileName, OutputFileName: TFileName): Boolean;
var
  OutputDir, GZipOutputFileName: TFileName;

begin
  OutputDir :=
    IncludeTrailingPathDelimiter(ExtractFilePath(ExpandFileName(InputFileName)));
  Result := GZipExecuteAction(InputFileName, OutputDir, GZipOutputFileName, gaCompress);
  if (Result) then
    RenameFile(GZipOutputFileName, OutputFileName);
end;

//------------------------------------------------------------------------------

function GZipDecompress(const InputFileName: TFileName; OutputDir: TFileName;
  var OutputFileName: TFileName): Boolean;
begin
  Result := GZipExecuteAction(InputFileName, OutputDir, OutputFileName, gaDecompress);
end;

//------------------------------------------------------------------------------

function GZipInitEngine(WorkDirectory: TFileName): Boolean;
begin
  GZipExec := IncludeTrailingPathDelimiter(WorkDirectory) + 'gzip.exe';
  Result := ExtractFile('GZIP', GZipExec);
end;

//------------------------------------------------------------------------------

function GZipClearEngine: Boolean;
begin
  Result := False;
  if FileExists(GZipExec) then
    Result := DeleteFile(GZipExec);
end;

//==============================================================================

initialization

//------------------------------------------------------------------------------

finalization
  GZipClearEngine;

//==============================================================================

end.
