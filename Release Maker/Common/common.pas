unit Common;

// Define this to print on the screen the encrypted/decrypted buffers
// {$DEFINE DEBUG_CIPHER}

{$DEFINE USE_DCL}

interface

uses
  Windows, SysUtils, Classes, FilesLst
{$IFDEF USE_DCL}, HashIdx {$ENDIF}
  ;
  
const
  RUNTIME_EXTRA_RESOURCE_PASSWORD = 'MessageBoxW';

  APPCONFIG_UI_MESSAGES       = 'ui.ini';
  APPCONFIG_EULA              = 'eula.rtf';

  APPCONFIG_RELEASEINFO       = 'config.ini';

  SKIN_IMAGE_TOP              = 'top.bmp';
  SKIN_IMAGE_BOTTOM           = 'bottom.bmp';

  SKIN_IMAGE_LEFT_HOME        = 'home.bmp';
  SKIN_IMAGE_LEFT_DISCLAMER   = 'disclamer.bmp';
  SKIN_IMAGE_LEFT_LICENSE     = 'license.bmp';
  SKIN_IMAGE_LEFT_DISCAUTH    = 'discauth.bmp';
  SKIN_IMAGE_LEFT_AUTHFAIL    = 'authfail.bmp';
  SKIN_IMAGE_LEFT_PARAMS      = 'params.bmp';
  SKIN_IMAGE_LEFT_READY       = 'ready.bmp';
  SKIN_IMAGE_LEFT_WORKING     = 'working.bmp';
  SKIN_IMAGE_LEFT_DONE        = 'done.bmp';
  SKIN_IMAGE_LEFT_DONEFAIL    = 'donefail.bmp';

  SKIN_IMAGES_LEFT_ORDER      : array[0..9] of string = (
    SKIN_IMAGE_LEFT_HOME, SKIN_IMAGE_LEFT_DISCLAMER, SKIN_IMAGE_LEFT_LICENSE,
    SKIN_IMAGE_LEFT_DISCAUTH, SKIN_IMAGE_LEFT_AUTHFAIL, SKIN_IMAGE_LEFT_PARAMS,
    SKIN_IMAGE_LEFT_READY, SKIN_IMAGE_LEFT_WORKING, SKIN_IMAGE_LEFT_DONE,
    SKIN_IMAGE_LEFT_DONEFAIL
  );

type
  TResourceType = (rtDiscAuth, rtResPrimary, rtResSecondary, rtPackage);

  TSkinImages = class(TObject)
  private
    fLeftImages: TFilesList;
    fBottom: TFileName;
    fTop: TFileName;
    procedure SetBottom(const Value: TFileName);
    procedure SetTop(const Value: TFileName);
  public
    constructor Create;
    destructor Destroy; override;
    property Bottom: TFileName read fBottom write SetBottom;
    property Left: TFilesList read fLeftImages;
    property Top: TFileName read fTop write SetTop;
  end;

  TPackagePasswords = class(TObject)
  private
    fAES: string;
    fPC1: string;
    fCamellia: string;
  public
    procedure Assign(Source: TPackagePasswords);
    property AES: string read fAES write fAES;
    property PC1: string read fPC1 write fPC1;
    property Camellia: string read fCamellia write fCamellia;
  end;

  TPackageReleaseInfoItem = class(TObject)
  private
    fKey: string;
    fValue: string;
  public
    property Key: string read fKey write fKey;
    property Value: string read fValue write fValue;
  end;

  TPackageReleaseInfo = class(TObject)
  private
{$IFDEF USE_DCL}
    fHashIndexOptimizer: THashIndexOptimizer;
{$ENDIF}
    fList: TList;
    function GetItem(Index: Integer): TPackageReleaseInfoItem;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Key, Value: string): Integer;
    procedure Clear;
    function GetValueFromKey(const Key: string): string;
    function IndexOf(const Key: string): Integer;
    procedure LoadFromFile(const FileName: TFileName);
    procedure SaveToFile(const FileName: TFileName);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPackageReleaseInfoItem read GetItem;
  end;

procedure EncryptStream(Passwords: TPackagePasswords; InStream, OutStream: TStream);
procedure DecryptStream(Passwords: TPackagePasswords; InStream, OutStream: TStream);

implementation

uses
  IniFiles, SysTools, LibPC1, LibCamellia, Base64;

{$IFDEF DEBUG}

function StreamToString(S: TStream): string;
var
  i: Integer;
  C: Char;
  OldValue: Int64;

begin
  Result := '';
  OldValue := S.Position;
  S.Seek(0, soFromBeginning);
  for i := 0 to S.Size - 1 do
  begin
    S.Read(C, 1);
    Result := Result + C;
  end;
  S.Seek(OldValue, soFromBeginning);
end;

procedure LogCipher(
  Decrypt: Boolean;
  Passwords: TPackagePasswords;
  InStream, OutStream: TStream;
  Memory1, Memory2: TMemoryStream
);
var
  Lines: TStringList;
  OutFileName: TFileName;

  procedure __printStream(StreamName: string; Stream: TStream);
  begin
    with Lines do
    begin
      Add(StreamName + '.Size: ' + IntToStr(Stream.Size));
      Add(StreamName + '.Position: ' + IntToStr(Stream.Position));
      Add(StreamName + '.Buffer: ' +
        sLineBreak +
        '*****************************************************************************' +
        sLineBreak +
        StreamToString(Stream) +
        sLineBreak +
        '*****************************************************************************'
      );
    end;
  end;

begin
  OutFileName :=
    IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
    'LogCipher_' +
    StringReplace(DateToStr(Now), '/', '_', [rfReplaceAll]) + '_' +
    ExtractFileName(ChangeFileExt(ParamStr(0), '')) +
    '.log';
    
  Lines := TStringList.Create;
  try
    with Lines do
    begin
      if FileExists(OutFileName) then
        LoadFromFile(OutFileName);

      if Count = 0 then
        Add('Shenmue Translation Pack - LogCipher');

      Add(sLineBreak);
      Add('LogCipher CALL: ' + DateToStr(Now) + ', ' + TimeToStr(Now));
      Add('Decrypt: ' + BoolToStr(Decrypt, True));

      Add('Passwords.AES: ' + Passwords.AES);
      Add('Passwords.PC1: ' + Passwords.PC1);
      Add('Passwords.Camellia: ' + Passwords.Camellia);

      __printStream('InStream', InStream);
      __printStream('Memory1', Memory1);
      __printStream('Memory2', Memory2);
      __printStream('OutStream', OutStream);
      
      SaveToFile(OutFileName);
    end;
  finally
    Lines.Free;
  end;
end;

{$ENDIF}

procedure Cipher(Decrypt: Boolean; Passwords: TPackagePasswords;
  InStream, OutStream: TStream);
var
  Memory1, Memory2: TMemoryStream;

begin
  Memory1 := TMemoryStream.Create;
  Memory2 := TMemoryStream.Create;
  try
    // Cleaning and initializing
    Memory1.CopyFrom(InStream, 0);
    InStream.Seek(0, soFromBeginning);

{$IFDEF DEBUG}{$IFDEF DEBUG_CIPHER}
    WriteLn('  Source Buffer (', Memory1.Size,'): ');
    Write('--------------------------------------------------------------------------------');
    WriteMemoryStreamToConsole(Memory1);
    Write('--------------------------------------------------------------------------------');
    WriteLn('');
{$ENDIF}{$ENDIF}

    // 1st pass
    if Decrypt then
      CamelliaDecrypt(Passwords.Camellia, Memory1, Memory2)
    else
      PC1Encrypt(pmAdvanced, Passwords.PC1, Memory1, Memory2);

    // 2nd pass
    Memory1.Clear;
    Memory2.Seek(0, soFromBeginning);
    if Decrypt then
      PC1Decrypt(pmAdvanced, Passwords.PC1, Memory2, Memory1)
    else
      CamelliaEncrypt(Passwords.Camellia, Memory2, Memory1);
    Memory2.Clear;
    Memory1.Seek(0, soFromBeginning);

{$IFDEF DEBUG}{$IFDEF DEBUG_CIPHER}
    WriteLn('  Destination Buffer (', Memory1.Size,'): ');
    Write('--------------------------------------------------------------------------------');
    WriteMemoryStreamToConsole(Memory1);
    Write('--------------------------------------------------------------------------------');
    WriteLn('');
{$ENDIF}{$ENDIF}

    // Copy the result to the destination
    OutStream.CopyFrom(Memory1, 0);
    OutStream.Seek(0, soFromBeginning);

{$IFDEF DEBUG}
    LogCipher(Decrypt, Passwords, InStream, OutStream, Memory1, Memory2);
{$ENDIF}

  finally
    // Destroying buffers...
    Memory1.Free;
    Memory2.Free;
  end;
end;

procedure EncryptStream(Passwords: TPackagePasswords; InStream, OutStream: TStream);
begin
  Cipher(False, Passwords, InStream, OutStream);
end;

procedure DecryptStream(Passwords: TPackagePasswords; InStream, OutStream: TStream);
begin
  Cipher(True, Passwords, InStream, OutStream);
end;
   
{ TPackageManagerPasswords }

procedure TPackagePasswords.Assign;
begin
  AES := Source.AES;
  PC1 := Source.PC1;
  Camellia := Source.Camellia;
end;

{ TSkinImages }

constructor TSkinImages.Create;
begin
  fLeftImages := TFilesList.Create;
end;

destructor TSkinImages.Destroy;
begin
  fLeftImages.Free;
  inherited;
end;

procedure TSkinImages.SetBottom(const Value: TFileName);
begin
  fBottom := ExpandFileName(Value);
end;

procedure TSkinImages.SetTop(const Value: TFileName);
begin
  fTop := ExpandFileName(Value);
end;

{ TPackageReleaseInfo }

function TPackageReleaseInfo.Add(Key, Value: string): Integer;
var
  Item: TPackageReleaseInfoItem;

begin
  Item := TPackageReleaseInfoItem.Create;
  Item.Key := Key;
  Item.Value := Value;
  Result := fList.Add(Item);
{$IFDEF USE_DCL}
  fHashIndexOptimizer.Add(Key, Result);
{$ENDIF}
end;

procedure TPackageReleaseInfo.Clear;
var
  i: Integer;
  
begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fList.Clear;
end;

constructor TPackageReleaseInfo.Create;
begin
  fList := TList.Create;
{$IFDEF USE_DCL}
  fHashIndexOptimizer := THashIndexOptimizer.Create;
{$ENDIF}
end;

destructor TPackageReleaseInfo.Destroy;
begin
  Clear;
  fList.Free;
{$IFDEF USE_DCL}
  fHashIndexOptimizer.Free;
{$ENDIF}
  inherited;
end;

function TPackageReleaseInfo.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TPackageReleaseInfo.GetItem(Index: Integer): TPackageReleaseInfoItem;
begin
  Result := TPackageReleaseInfoItem(fList[Index]);
end;

function TPackageReleaseInfo.GetValueFromKey(const Key: string): string;
var
  i: Integer;

begin
  Result := '';
  i := IndexOf(Key);
  if i <> -1 then
    Result := Items[i].Value;
end;

function TPackageReleaseInfo.IndexOf(const Key: string): Integer;
{$IFDEF USE_DCL}
begin
  Result := fHashIndexOptimizer.IndexOf(Key);
{$ELSE}
var
  Done: Boolean;
  i: Integer;

begin
  Result := -1;

  i := 0;
  Done := False;
  while (i < Count) and (not Done) do
  begin
    Done := Items[i].Key = Key;
    Inc(i);
  end;

  if Done then
    Result := i;
{$ENDIF}
end;

procedure TPackageReleaseInfo.LoadFromFile(const FileName: TFileName);
var
  Ini: TIniFile;
  SL: TStringList;
  i: Integer;

begin
  Ini := TIniFile.Create(FileName);
  SL := TStringList.Create;
  with Ini do
  try
    ReadSection('ReleaseInfo', SL);
    for i := 0 to SL.Count - 1 do
      Add(SL[i], ReadString('ReleaseInfo', SL[i], ''));
  finally
    SL.Free;
    Free;
  end;
end;

procedure TPackageReleaseInfo.SaveToFile(const FileName: TFileName);
var
  Ini: TIniFile;
  i: Integer;
  
begin
  Ini := TIniFile.Create(FileName);
  with Ini do
  try
    for i := 0 to Count - 1 do
      WriteString('ReleaseInfo', Items[i].Key, Items[i].Value);
  finally
    Free;
  end;
end;

end.
