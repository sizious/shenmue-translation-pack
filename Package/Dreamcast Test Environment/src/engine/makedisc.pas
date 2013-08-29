unit MakeDisc;

interface

uses
  Windows, SysUtils;
  
type
  TVirtualDriveKind = (vdkNone, vdkAlcohol120, vdkDaemonTools);

  // Virtual Drive Settings
  TVirtualDriveSettings = class(TObject)
  private
    fDrive: Char;
    fKind: TVirtualDriveKind;
    fDirectory: TFileName;
  public
    property Drive: Char read fDrive write fDrive;
    property Kind: TVirtualDriveKind read fKind write fKind;
    property Directory: TFileName read fDirectory write fDirectory;
  end;

  // Settings Root
  TDreamcastImageSettings = class(TObject)
  private
    fVirtualDrive: TVirtualDriveSettings;
    fEmulator: TFileName;
  public
    constructor Create;
    destructor Destroy; override;
    property Emulator: TFileName read fEmulator write fEmulator;
    property VirtualDrive: TVirtualDriveSettings read fVirtualDrive;
  end;

  // Main Class
  TDreamcastImageMaker = class(TObject)
  private
    fSettings: TDreamcastImageSettings;
  public
    constructor Create;
    destructor Destroy; override;
    property Settings: TDreamcastImageSettings read fSettings;
  end;

implementation

const
  DATA1_FILESIZE = 69120000;

{ TDreamcastImageMaker }

constructor TDreamcastImageMaker.Create;
begin
  fSettings := TDreamcastImageSettings.Create;
end;

destructor TDreamcastImageMaker.Destroy;
begin
  fSettings.Free;
  inherited;
end;

{ TDreamcastImageSettings }

constructor TDreamcastImageSettings.Create;
begin
  fVirtualDrive := TVirtualDriveSettings.Create;
end;

destructor TDreamcastImageSettings.Destroy;
begin
  fVirtualDrive.Free;
  inherited;
end;

end.
