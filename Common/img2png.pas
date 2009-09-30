(*
  Pvr2Png Unit Implementation by [big_fury]SiZiOUS

  Powered by Pvr2Png 1.01 by Gzav
*)
unit img2png;

interface

uses
  Windows, SysUtils, Classes;

type
  TTextureType = (ttUnknow, ttSmallVQ128, ttSmallVQ64, ttSmallVQ32,
                  ttSmallVQ16, ttVQ, ttTwiddle, ttRectangle);

  TPixelFormat = (pfUnknow, pfBump, pfRGB565, pfYUV422, pfARGB4444, pfARGB1555);

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
  protected
    function RunEngine: Boolean;
    procedure ParseConsoleOutputFile;
  public
    destructor Destroy; override;
    
    procedure Clear;
    function LoadFromFile(const SourceFileName: TFileName): Boolean;

    property DataSize: Integer read fDataSize;
    property Encoding: TTextureType read fEncoding;
    property GlobalIndex: Integer read fGlobalIndex;
    property Height: Integer read fHeight;
    property Loaded: Boolean read fLoaded;
    property Mipmap: Boolean read fMipmap;
    property PixelFormat: TPixelFormat read fPixelFormat;
    property SourceFileName: TFileName read fSourceFileName;
    property TargetFileName: TFileName read fTargetFileName;
    property Width: Integer read fWidth;
  end;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  Common, Utils;

var
  EngineFile: TFileName;

{ TPVRConverter }

function TPVRConverter.LoadFromFile(const SourceFileName: TFileName): Boolean;
var
  RadicalName: string;

begin
  Result := False;
  try
    Result := FileExists(SourceFileName);
    if not Result then Exit;
    Clear;

    fSourceFileName := SourceFileName;
    RadicalName := GetWorkingDirectory + ChangeFileExt(ExtractFileName(SourceFileName), '');
    fTargetFileName := RadicalName + '.png';
    fConsoleOutputFileName := RadicalName + '.out';

    // Run conversion
    if RunEngine then begin
      Result := True;
      fLoaded := True;
      ParseConsoleOutputFile; // fill infos file
    end;
  except
{$IFDEF DEBUG}
    on E:Exception do WriteLn('TPVRConverter.LoadFromFile: EXCEPTION: ', E.Message);
{$ENDIF}
  end;
end;

procedure TPVRConverter.ParseConsoleOutputFile;
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
  finally
    ConvResults.Free;

    if FileExists(fConsoleOutputFileName) then
      DeleteFile(fConsoleOutputFileName);
  end;
end;

function TPVRConverter.RunEngine: Boolean;
var
  BatchContent: TStringList;
  BatchTarget: TFileName;

begin
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

procedure TPVRConverter.Clear;
begin
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

destructor TPVRConverter.Destroy;
begin
  Clear;
  inherited Destroy;
end;

initialization
  EngineFile := GetWorkingDirectory + 'pvr2png.exe';
  ExtractFile('PVR2PNG', EngineFile);

end.
