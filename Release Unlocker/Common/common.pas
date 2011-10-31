unit Common;

// Define this to print on the screen the encrypted/decrypted buffers
// {$DEFINE DEBUG_CIPHER}

interface

uses
  Windows, SysUtils, Classes, FilesLst;
  
const
  RESTYPE_DISCAUTH = 0;
  RESTYPE_APPCONFIG = 1;
  RUNTIME_EXTRA_RESOURCE_PASSWORD = 'MessageBoxW';

  APPCONFIG_UI_MESSAGES       = 'ui.ini';
  APPCONFIG_EULA              = 'eula.rtf';

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
  TSkinImages = class(TObject)
  private
    fLeftImages: TFilesList;
    fBottom: TFileName;
    fTop: TFileName;
  public
    constructor Create;
    destructor Destroy; override;
    property Bottom: TFileName read fBottom write fBottom;
    property Left: TFilesList read fLeftImages;
    property Top: TFileName read fTop write fTop;
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

procedure EncryptStream(Passwords: TPackagePasswords; InStream, OutStream: TStream);
procedure DecryptStream(Passwords: TPackagePasswords; InStream, OutStream: TStream);

implementation

uses
  SysTools, LibPC1, LibCamellia, Base64;

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

end.
