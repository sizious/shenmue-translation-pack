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
function GameRegionToCodeString(GameRegion: TGameRegion): string;
function GameRegionToString(GameRegion: TGameRegion): string;
function GameVersionToCodeString(GameVersion: TGameVersion; Short: Boolean = False): string;
function GameVersionToString(GameVersion: TGameVersion): string;
function PlatformVersionToCodeString(PlatformVersion: TPlatformVersion): string;
function PlatformVersionToString(PlateformVersion: TPlatformVersion): string;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

function CodeStringToGameVersion(S: string): TGameVersion;
begin
  Result := gvUndef;
  S := UpperCase(S);
  if ((S = 'S1') or (S = 'SHENMUE1') or (S = 'SHENMUE')) then
    Result := gvShenmue
  else if ((S = 'S2') or (S = 'SHENMUE2') or (S = 'SHENMUEII')) then
    Result := gvShenmue2
  else if ((S = 'WH') or (S = 'WHATSSHENMUE') or (S = 'WHATS')) then
    Result := gvWhatsShenmue;
end;

//------------------------------------------------------------------------------

function CodeStringToGameRegion(S: string): TGameRegion;
begin
  Result := prUndef;
  S := UpperCase(S);
  if ((S = 'J') or (S = 'JAP') or (S = 'JAPAN') or (S = 'NTSC-J')) then
    Result := prJapan
  else if ((S = 'U') or (S = 'USA') or (S = 'NTSC-U')) then
    Result := prUSA
  else if ((S = 'E') or (S = 'EUR') or (S = 'PAL') or (S = 'EUROPE')) then
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
begin
  Result := pvUndef;
  S := UpperCase(S);
  if (S = 'DC') or (S = 'DREAMCAST') then
    Result := pvDreamcast
  else if (S = 'XB') or (S = 'XBOX') then
    Result := pvXbox;
end;

//------------------------------------------------------------------------------

end.
