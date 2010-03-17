(*
  Pvr2Png Unit Implementation by [big_fury]SiZiOUS

  Powered by:
  - Pvr2Png 1.01 by Gzav
  - PvrX2Png 0.1 by SiZiOUS
*)
unit img2png;

interface

uses
  Windows, SysUtils, Classes, PNGImage;

type
  EPVRConverterEngineNotExists = class(Exception);

  TTextureType = (
    ttUnknow, ttSmallVQ128, ttSmallVQ64, ttSmallVQ32,
    ttSmallVQ16, ttVQ, ttTwiddle, ttRectangle,
    ttNotApplicable
  );

  TPixelFormat = (
    pfUnknow,
    pfBump, pfRGB565, pfYUV422, pfARGB4444, pfARGB1555,
    pfDXT1, pfDXT3, pfDXT5, pfUncompressed
  );

  TFileFormat = (ffUnknow, ffPVR, ffDDS, ffPVRX, ffGBIXPVRX);

  TFileType = (ftUnknow, ftDreamcast, ftXBox);
  
  TPVRConverter = class(TObject)
  private
    fTargetFileName: TFileName; // Output PNG file
    fSourceFileName: TFileName; // Input PVR file
    fConsoleOutputFileName: TFileName;
    fGlobalIndex: Integer;
    fDataSize: Integer;
    fWidth: Integer;
    fHeight: Integer;
    fEncoding: TTextureType;
    fMipmap: Boolean;
    fPixelFormat: TPixelFormat;
    fLoaded: Boolean;
    fFileType: TFileType;
    fFileFormat: TFileFormat;
    fWorkingDirectory: TFileName;
    fClearTargetFileName: Boolean;
  protected
    function GetFileSystemType(const FileName: TFileName): TFileType;
    function RunEngine: Boolean;
    procedure ParseConsoleOutputFile_Dreamcast;
    procedure ParseConsoleOutputFile_Xbox;
  public
    constructor Create(const WorkingTempDirectory: TFileName); overload;
    constructor Create(const WorkingTempDirectory: TFileName;
      ClearTargetFileName: Boolean); overload;
    destructor Destroy; override;
    
    procedure Clear;
    function LoadFromFile(const SourceFileName: TFileName): Boolean;

    property ClearTargetFileName: Boolean
      read fClearTargetFileName write fClearTargetFileName;
    property DataSize: Integer read fDataSize;
    property Encoding: TTextureType read fEncoding;
    property FileFormat: TFileFormat read fFileFormat;
    property FileType: TFileType read fFileType;
    property GlobalIndex: Integer read fGlobalIndex;
    property Height: Integer read fHeight;
    property Loaded: Boolean read fLoaded;
    property Mipmap: Boolean read fMipmap;
    property PixelFormat: TPixelFormat read fPixelFormat;
    property SourceFileName: TFileName read fSourceFileName;
    property TargetFileName: TFileName read fTargetFileName;
    property Width: Integer read fWidth;
    property WorkingDirectory: TFileName
      read fWorkingDirectory write fWorkingDirectory;
  end;

procedure PVRConverter_ExtractEngine(WorkingTempDirectory: TFileName);
procedure PVRConverter_DeleteEngine;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  Common, SysTools;

//==============================================================================

var
  PVR_EngineFile,
  PVRX_EngineFile: TFileName;

//------------------------------------------------------------------------------

procedure PVRConverter_ExtractEngine(WorkingTempDirectory: TFileName);
begin
  WorkingTempDirectory := IncludeTrailingPathDelimiter(WorkingTempDirectory);
  PVR_EngineFile := WorkingTempDirectory + 'pvr2png.exe';
  ExtractFile('PVR2PNG', PVR_EngineFile);
  PVRX_EngineFile := WorkingTempDirectory + 'pvrx2png.exe';
  ExtractFile('PVRX2PNG', PVRX_EngineFile);
end;

//------------------------------------------------------------------------------

procedure PVRConverter_DeleteEngine;
begin
  if FileExists(PVR_EngineFile) then
    DeleteFile(PVR_EngineFile);
  if FileExists(PVRX_EngineFile) then
    DeleteFile(PVRX_EngineFile);
end;

//==============================================================================
{ TPVRConverter }
//==============================================================================

function TPVRConverter.LoadFromFile(const SourceFileName: TFileName): Boolean;
var
  RadicalName: string;

begin
  Result := False;
  try
    fFileType := ftUnknow;
    fFileFormat := ffUnknow;
    
    Result := FileExists(SourceFileName);
    if not Result then Exit;
    Clear;

    fSourceFileName := SourceFileName;
    RadicalName := WorkingDirectory + ChangeFileExt(ExtractFileName(SourceFileName), '');
    fTargetFileName := RadicalName + '.png';
    fConsoleOutputFileName := RadicalName + '.out';

    fFileType := GetFileSystemType(SourceFileName);

    // Run conversion
    if RunEngine then begin
      Result := True;
      fLoaded := True;
      // Fill infos file;
      case FileType of
        ftDreamcast: ParseConsoleOutputFile_Dreamcast;
        ftXBox: ParseConsoleOutputFile_Xbox;
        ftUnknow: raise Exception.Create('SORRY IMPOSSIBLE TO DETERMINATE THE FILE TYPE...');
      end;

    end;
  except
{$IFDEF DEBUG}
    on E:Exception do WriteLn('TPVRConverter.LoadFromFile: EXCEPTION: ', E.Message);
{$ENDIF}
  end;
end;

//------------------------------------------------------------------------------

procedure TPVRConverter.ParseConsoleOutputFile_Dreamcast;
var
  ConvResults: TStringList;
  Buf: string;
  
begin
  ConvResults := TStringList.Create;
  try
    ConvResults.LoadFromFile(fConsoleOutputFileName);

    // Global Index (GBIX)
    fGlobalIndex := StrToIntDef(Right(': ', ConvResults[5]), 0);

    // Image size
    fWidth := StrToIntDef(ExtractStr(': ', 'x', ConvResults[6]), 0);
    fHeight := StrToIntDef(Right('x', ConvResults[6]), 0);

    // Data size
    fDataSize := StrToIntDef(Right(': ', ConvResults[7]), 0);

    // Pixel format
    fPixelFormat := pfUnknow;
    Buf := Right(': ', ConvResults[8]);
    if Buf = 'Bump' then fPixelFormat := pfBump;
    if Buf = 'RGB565' then fPixelFormat := pfRGB565;
    if Buf = 'YUV422' then fPixelFormat := pfYUV422;
    if Buf = 'ARGB4444' then fPixelFormat := pfARGB4444;
    if Buf = 'ARGB1555' then fPixelFormat := pfARGB1555;

    // Texture type
    fEncoding := ttUnknow;
    Buf := Right(': ', ConvResults[9]);
    if Buf = 'SmallVQ(128)' then fEncoding := ttSmallVQ128;
    if Buf = 'SmallVQ(64)' then fEncoding := ttSmallVQ64;
    if Buf = 'SmallVQ(32)' then fEncoding := ttSmallVQ32;
    if Buf = 'SmallVQ(16)' then fEncoding := ttSmallVQ16;
    if Buf = 'VQ' then fEncoding := ttVQ;
    if Buf = 'Twiddle' then fEncoding := ttTwiddle;
    if Buf = 'Rectangle' then fEncoding := ttRectangle;

    // Mipmap
    fMipMap := Right(': ', ConvResults[10]) = 'Yes';

    fFileFormat := ffPVR;
  finally
    ConvResults.Free;

    if FileExists(fConsoleOutputFileName) then
      DeleteFile(fConsoleOutputFileName);
  end;
end;

//------------------------------------------------------------------------------

procedure TPVRConverter.ParseConsoleOutputFile_Xbox;
var
  ConvResults: TStringList;
  Buf: string;
  
begin
  ConvResults := TStringList.Create;
  try
    ConvResults.LoadFromFile(fConsoleOutputFileName);

    // File format
    Buf := Right(': ', ConvResults[5]);
    if Buf = 'GBIX / PVR-X' then fFileFormat := ffGBIXPVRX;
    if Buf = 'PVR-X' then fFileFormat := ffPVRX;
    if Buf = 'DDS' then fFileFormat := ffDDS;

    // Global Index (GBIX)
    fGlobalIndex := StrToIntDef(Right(': ', ConvResults[6]), 0);

    // Image size
    fWidth := StrToIntDef(ExtractStr(': ', 'x', ConvResults[7]), 0);
    fHeight := StrToIntDef(Right('x', ConvResults[7]), 0);

    // Data size
    fDataSize := StrToIntDef(Right(': ', ConvResults[8]), 0);

    // Pixel format
    fPixelFormat := pfUnknow;
    Buf := Right(': ', ConvResults[9]);
    if Buf = 'Uncompressed' then fPixelFormat := pfUncompressed;
    if Buf = 'DXT1' then fPixelFormat := pfDXT1;
    if Buf = 'DXT3' then fPixelFormat := pfDXT3;
    if Buf = 'DXT5' then fPixelFormat := pfDXT5;

    // Texture type
    fEncoding := ttNotApplicable;

    // Mipmap
    fMipMap := False;
  finally
    ConvResults.Free;

    if FileExists(fConsoleOutputFileName) then
      DeleteFile(fConsoleOutputFileName);
  end;
end;

//------------------------------------------------------------------------------

function TPVRConverter.RunEngine: Boolean;
var
  BatchContent: TStringList;
  BatchTarget, EngineFile: TFileName;

begin
  Result := False;
  
  case FileType of
    ftUnknow: Exit;
    ftDreamcast: EngineFile := PVR_EngineFile;
    ftXBox: EngineFile := PVRX_EngineFile;
  end;

  // Exception raised if the Engine doesn't exists
  if not FileExists(EngineFile) then
    raise EPVRConverterEngineNotExists
      .Create('PVRConverter.RunEngine [img2png]: The PVR conversion engine doesn''t exists!');

  // Creating the batch file
  BatchTarget := ChangeFileExt(fTargetFileName, '.bat');
  BatchContent := TStringList.Create;
  try
    with BatchContent do begin
      Add('@echo off');
      Add('"' + EngineFile + '" '
        + '"' + SourceFileName + '" '
        + '"' + TargetFileName + '" > '
        + '"' + fConsoleOutputFileName + '"');
      {Add(':label');
      Add('del "' + BatchTarget + '" > nul 2> nul');
      Add('if exist "' + BatchTarget + '" goto label');}
      SaveToFile(BatchTarget);
    end;
  finally
    BatchContent.Free;
  end;

  // Run the proggy and wait for output...
  Result := RunAndWait(BatchTarget);
  if FileExists(BatchTarget) then
    DeleteFile(BatchTarget);
end;

//------------------------------------------------------------------------------

procedure TPVRConverter.Clear;
begin
  if ClearTargetFileName then
    if FileExists(TargetFileName) then
      DeleteFile(TargetFileName);
    
  fLoaded := False;
  fTargetFileName := '';
  fSourceFileName := '';
  fConsoleOutputFileName := '';
  fGlobalIndex := 0;
  fDataSize := 0;
  fWidth := 0;
  fHeight := 0;
  fEncoding := ttUnknow;
  fMipmap := False;
  fPixelFormat := pfUnknow;
end;

//------------------------------------------------------------------------------

constructor TPVRConverter.Create(const WorkingTempDirectory: TFileName;
  ClearTargetFileName: Boolean);
begin
  Self.fWorkingDirectory := WorkingTempDirectory;
  fClearTargetFileName := ClearTargetFileName;
end;

//------------------------------------------------------------------------------

constructor TPVRConverter.Create(const WorkingTempDirectory: TFileName);
begin
  Create(WorkingTempDirectory, True);
end;

//------------------------------------------------------------------------------

destructor TPVRConverter.Destroy;
begin
  Clear;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

function TPVRConverter.GetFileSystemType(const FileName: TFileName): TFileType;
type
  TRawEntry = record
    Name: array[0..3] of Char;
    Size: LongWord;
  end;

const
  GBIX_SIGN = 'GBIX';
  PVRT_SIGN = 'PVRT';
  DDS__SIGN = 'DDS ';
  PVRT_SIZE = 8;
  
var
  Stream: TFileStream;
  Entry: TRawEntry;

begin
  Result := ftUnknow;
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    // Read GBIX
    Stream.Read(Entry, SizeOf(Entry));
    if not (Entry.Name = GBIX_SIGN) then Exit;
    Stream.Seek(Entry.Size, soCurrent);

    // Read PVRT
    Stream.Read(Entry, SizeOf(Entry));
    if not (Entry.Name = PVRT_SIGN) then Exit;
    Stream.Seek(PVRT_SIZE, soCurrent);

    // Read PVRT data
    Stream.Read(Entry, SizeOf(Entry));
    if (Entry.Name = DDS__SIGN) then
      Result := ftXBox
    else
      Result := ftDreamcast;
  finally
    Stream.Free;
  end;
end;

//==============================================================================

initialization

//------------------------------------------------------------------------------

finalization
  PVRConverter_DeleteEngine; // auto-cleanup the engine

//==============================================================================

end.
