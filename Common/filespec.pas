unit FileSpec;

interface

uses
  Windows, SysUtils;
  
type
  // Game version
  TGameVersion = (gvUndef, gvWhatsShenmue, gvShenmue, gvUSShenmue, gvShenmue2);

  // Game region
  TGameRegion = (prUndef, prJapan, prUSA, prEurope);

  // System version
  TPlatformVersion = (pvUndef, pvDreamcast, pvXbox);

function CodeStringToGameVersion(S: string): TGameVersion;
function CodeStringToGameRegion(S: string): TGameRegion;
function CodeStringToPlatformVersion(S: string): TPlatformVersion;
function GameRegionCodeStringToString(S: string): string;
function GameRegionToCodeString(GameRegion: TGameRegion): string;
function GameRegionToString(GameRegion: TGameRegion): string;
function GameVersionCodeStringToString(S: string): string;
function GameVersionToCodeString(GameVersion: TGameVersion; Short: Boolean = False): string;
function GameVersionToString(GameVersion: TGameVersion): string;
function PlatformVersionCodeStringToString(S: string): string;
function PlatformVersionToCodeString(PlatformVersion: TPlatformVersion): string;
function PlatformVersionToString(PlateformVersion: TPlatformVersion): string;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  SysTools;
  
function GameVersionCodeStringToString(S: string): string;
begin
  Result := GameVersionToString(CodeStringToGameVersion(S));
end;

//------------------------------------------------------------------------------

function GameRegionCodeStringToString(S: string): string;
begin
  Result := GameRegionToString(CodeStringToGameRegion(S));
end;

//------------------------------------------------------------------------------

function PlatformVersionCodeStringToString(S: string): string;
begin
  Result := PlatformVersionToString(CodeStringToPlatformVersion(S));
end;

//------------------------------------------------------------------------------

function CodeStringToGameVersion(S: string): TGameVersion;
const
  S1: array[0..3] of string = (
    'S1',     'SHENMUE1',       'SHENMUE',    'GVSHENMUE'
  );
  S2: array[0..3] of string = (
    'S2',     'SHENMUE2',       'SHENMUEII',  'GVSHENMUE2'
  );
  WH: array[0..3] of string = (
    'WH',     'WHATSSHENMUE',   'WHATS',      'GVWHATSSHENMUE'
  );
  USS: array[0..3] of string = (
    'USS',    'USSHENMUE',      'S1US',       'GVUSSHENMUE'
  );

begin
  Result := gvUndef;
  S := UpperCase(S);
  if IsInArray(S1, S) then
    Result := gvShenmue
  else if IsInArray(S2, S) then
    Result := gvShenmue2
  else if IsInArray(WH, S) then
    Result := gvWhatsShenmue
  else if IsInArray(USS, S) then
    Result := gvUSShenmue;
end;

//------------------------------------------------------------------------------

function CodeStringToGameRegion(S: string): TGameRegion;
const
  JAP: array[0..4] of string = ('J', 'JAP', 'JAPAN','NTSC-J','PRJAPAN');
  USA: array[0..3] of string = ('U', 'USA', 'NTSC-U', 'PRUSA');
  EUR: array[0..5] of string = ('E', 'EUR', 'PAL', 'P', 'EUROPE', 'PREUROPE');
  
begin
  Result := prUndef;
  S := UpperCase(S);
  if IsInArray(JAP, S) then
    Result := prJapan
  else if IsInArray(USA, S) then
    Result := prUSA
  else if IsInArray(EUR, S) then
    Result := prEurope;
end;

//------------------------------------------------------------------------------

function GameVersionToString(GameVersion: TGameVersion): string;
begin
  case GameVersion of
    gvUndef: Result := '(Unknow)';
    gvShenmue: Result := 'Shenmue';
    gvShenmue2: Result := 'Shenmue II';
    gvWhatsShenmue: Result := 'What''s Shenmue';
    gvUSShenmue: Result := 'US Shenmue';
  end;
end;

//------------------------------------------------------------------------------

function GameVersionToCodeString(GameVersion: TGameVersion; Short: Boolean = False): string;
begin
  if Short then  
    case GameVersion of
      gvUndef: Result := 'NA';
      gvShenmue: Result := 'S1';
      gvShenmue2: Result := 'S2';
      gvWhatsShenmue: Result := 'WH';
      gvUSShenmue: Result := 'US';
    end
  else
    case GameVersion of
      gvUndef: Result := 'UNKNOW';
      gvShenmue: Result := 'SHENMUE';
      gvShenmue2: Result := 'SHENMUE2';
      gvWhatsShenmue: Result := 'WHATSSHENMUE';
      gvUSShenmue: Result := 'USSHENMUE';
    end;
end;

//------------------------------------------------------------------------------

function PlatformVersionToCodeString(PlatformVersion: TPlatformVersion): string;
begin
  case PlatformVersion of
    pvUndef: Result := 'NA';
    pvDreamcast: Result := 'DC';
    pvXbox: Result := 'XB';
  end;
end;

//------------------------------------------------------------------------------

function GameRegionToString(GameRegion: TGameRegion): string;
begin
  case GameRegion of
    prUndef: Result := '(Unknow)';
    prJapan: Result := 'Japan (NTSC-J)';
    prUSA: Result := 'USA (NTSC-U)';
    prEurope: Result := 'Europe (PAL)';
  end;
end;

//------------------------------------------------------------------------------

function GameRegionToCodeString(GameRegion: TGameRegion): string;
begin
  case GameRegion of
    prUndef: Result := 'NA';
    prJapan: Result := 'JAP';
    prUSA: Result := 'USA';
    prEurope: Result := 'EUR';
  end;
end;

//------------------------------------------------------------------------------

function PlatformVersionToString(PlateformVersion: TPlatformVersion): string;
begin
  case PlateformVersion of
    pvUndef:
      Result := '(Unknow)';
    pvDreamcast:
      Result := 'Dreamcast';
    pvXbox:
      Result := 'Xbox';
  end;
end;

//------------------------------------------------------------------------------

function CodeStringToPlatformVersion(S: string): TPlatformVersion;
const
  DC: array[0..5] of string = ('DC', 'DREAMCAST', 'DREAM', 'D', 'DCAST', 'PVDREAMCAST');
  XB: array[0..4] of string = ('XB', 'XBOX', 'XBOX1', 'X', 'PVXBOX');

begin
  Result := pvUndef;
  S := UpperCase(S);
  if IsInArray(DC, S) then
    Result := pvDreamcast
  else if IsInArray(XB, S) then
    Result := pvXbox;
end;

//------------------------------------------------------------------------------

end.
