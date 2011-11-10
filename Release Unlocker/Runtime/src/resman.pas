unit ResMan;

//{$DEFINE USE_DCL}

interface

uses
  Windows, SysUtils, Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, SysTools
{$IFDEF USE_DCL}
  , HashIdx
{$ENDIF};

// Resource Strings Manager
procedure InitializeStringUI;
function GetStringUI(Section, Code: string): string;
function SizeUnitToString(SizeUnit: TSizeUnit): string;
procedure LoadWizardUI(Section: string);

// Resource Images Manager
function InitializeSkin: Boolean;

// Misc
procedure FillReleaseInfo;
function ShowAppName: Boolean;

implementation

uses
  Main, IniFiles, WorkDir, Common;

type
  TStringLocalizerItem = class(TObject)
  private
    fCode: string;
    fSection: string;
    fText: string;
  public
    property Section: string read fSection;
    property Code: string read fCode;
    property Text: string read fText;
  end;

  TStringLocalizer = class(TObject)
  private
{$IFDEF USE_DCL}
    fHashIdx: THashIndexOptimizer;
{$ENDIF}
    fList: TList;
    procedure Clear;
    function GetCount: Integer;
    function GetItem(Index: Integer): TStringLocalizerItem;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(ASection, ACode, AText: string): string;
    function Get(ASection, ACode: string): string;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TStringLocalizerItem read GetItem;
  end;

const
  INVALID_STRING = '<%INVALID%>';

var
  GameName: string;
  IniUiFile: TIniFile;
  StringLocalizer: TStringLocalizer;

//------------------------------------------------------------------------------

function ShowAppName: Boolean;
begin
  Result := IniUiFile.ReadBool('Title', 'ShowAppName', True);
end;

//------------------------------------------------------------------------------

procedure FillReleaseInfo;
var
  SL: TStringList;
  i: Integer;

  procedure _Add(Key: string);
  begin
    with frmMain.lvwInfos.Items.Add do
    begin
      Caption := GetStringUI('HomeInfos', Key);
      SubItems.Add(GetStringUI('General', Key));
    end;
  end;

begin
  SL := TStringList.Create;
  try
    IniUiFile.ReadSection('General', SL);
    for i := 0 to SL.Count - 1 do
      _Add(SL[i]);
  finally
    SL.Free;
  end;
end;

//------------------------------------------------------------------------------

function GetStringUI(Section, Code: string): string;
begin
  Result := StringLocalizer.Get(Section, Code);
end;

//------------------------------------------------------------------------------

procedure InitializeStringUI;
var
  DefSize: Integer;
  
begin
  IniUiFile := TIniFile.Create(GetWorkingTempDirectory + APPCONFIG_UI_MESSAGES);
  StringLocalizer := TStringLocalizer.Create;

  with frmMain do
  begin
    // Generic
    btnAbout.Caption := GetStringUI('Buttons', 'About');
    btnCancel.Caption := GetStringUI('Buttons', 'Cancel');
    GameName := GetStringUI('General', 'GameName');

    // BrowseForDialog for the OutputDirectory
    bfdOutput.StatusText := GetStringUI('Params', 'bfdStatusText');
    bfdOutput.Title := GetStringUI('Params', 'bfdTitle');

    // Info on the home
    lvwInfos.Columns[0].Caption := GetStringUI('HomeInfos', 'KeysCol');
    DefSize := lvwInfos.Columns[0].Width;
    lvwInfos.Columns[0].Width := IniUiFile.ReadInteger('HomeInfos', 'KeysColSize', DefSize);
    lvwInfos.Columns[1].Caption := GetStringUI('HomeInfos', 'ValuesCol');
  end;
end;                                             

//------------------------------------------------------------------------------

procedure LoadWizardUI(Section: string);
var
  i: Integer;
  CtrlsList: TStringList;
  C: TComponent;
  S, CC: string;

begin
{$IFDEF DEBUG}
  WriteLn('Loading Wizard UI : ', Section);
{$ENDIF}

  // Load image
  try
    i := frmMain.pcWizard.ActivePageIndex;
    if FileExists(GetWorkingTempDirectory + SKIN_IMAGES_LEFT_ORDER[i]) then
      frmMain.imgLeft.Picture.LoadFromFile(GetWorkingTempDirectory
        + SKIN_IMAGES_LEFT_ORDER[i]);
  except
  end;
  
  // Load strings...
  CtrlsList := TStringList.Create;
  try
    IniUiFile.ReadSection(Section, CtrlsList);
    for i := 0 to CtrlsList.Count - 1 do
    begin
      C := frmMain.FindComponent(CtrlsList[i]);
      S := StringLocalizer.Get(Section, CtrlsList[i]); // Store the string...

      if Assigned(C) and (S <> '') then
      begin
        CC := Copy(C.Name, 1, 3);
        if CC = 'lbl' then (C as TLabel).Caption := S
        else if CC = 'grp' then (C as TGroupBox).Caption := ' ' + S + ' '
        else if CC = 'btn' then (C as TButton).Caption := S
        else if CC = 'rbn' then (C as TRadioButton).Caption := S;
      end;
    end;
  finally
    CtrlsList.Free;
  end;
end;

//------------------------------------------------------------------------------

function SizeUnitToString(SizeUnit: TSizeUnit): string;
begin
  case SizeUnit of
    suByte:     Result := StringLocalizer.Get('SizeUnits', 'Byte');
    suKiloByte: Result := StringLocalizer.Get('SizeUnits', 'KiloByte');
    suMegaByte: Result := StringLocalizer.Get('SizeUnits', 'MegaByte');
    suGigaByte: Result := StringLocalizer.Get('SizeUnits', 'GigaByte');
  end;
end;

//------------------------------------------------------------------------------

{ TStringLocalizer }

function TStringLocalizer.Add;
var
  Item: TStringLocalizerItem;
{$IFDEF USE_DCL}
  i: Integer;
{$ENDIF}

begin
  Item := TStringLocalizerItem.Create;
  with Item do
  begin
    fCode := ACode;
    fSection := ASection;
    fText := StringReplace(AText, '\n', sLineBreak, [rfReplaceAll]);
    fText := StringReplace(fText, '\t', '      ', [rfReplaceAll]);
    fText := StringReplace(fText, '<%GAMENAME%>', GameName, [rfReplaceAll]);
    Result := fText;
  end;
{$IFDEF USE_DCL}
  i :=
{$ENDIF}
  fList.Add(Item);
{$IFDEF USE_DCL}
  fHashIdx.Add(ASection + ACode, i);
{$ENDIF}
end;

procedure TStringLocalizer.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fList.Clear;
end;

constructor TStringLocalizer.Create;
begin
  fList := TList.Create;
{$IFDEF USE_DCL}
  fHashIdx := THashIndexOptimizer.Create;
{$ENDIF}
end;

destructor TStringLocalizer.Destroy;
begin
  Clear;
  fList.Free;
{$IFDEF USE_DCL}
  fHashIdx.Free;
{$ENDIF}
  inherited;
end;

function TStringLocalizer.Get;
var
  i: Integer;
{$IFNDEF USE_DCL}
  Max: Integer;
  Done: Boolean;
{$ENDIF}

begin
  Result := '';

{$IFDEF USE_DCL}
  i := fHashIdx.IndexOf(ASection + ACode);
{$ELSE}
  i := -1;    
  Done := False;
  Max := Count - 1;
  while (not Done) and (i < Max) do
  begin
    Inc(i);
    Done := (Items[i].Section = ASection) and (Items[i].Code = ACode);
  end;
  if not Done then
    i := -1;  
{$ENDIF}

  if i <> -1 then
    Result := Items[i].Text
  else begin
    Result := IniUiFile.ReadString(ASection, ACode, INVALID_STRING);
    if Result <> INVALID_STRING then
      Result := StringLocalizer.Add(ASection, ACode, Result);
  end;
end;

function TStringLocalizer.GetCount;
begin
  Result := fList.Count;
end;

function TStringLocalizer.GetItem;
begin
  Result := TStringLocalizerItem(fList[Index]);
end;

//------------------------------------------------------------------------------

function InitializeSkin: Boolean;
var
  _DIR: TFileName;

  procedure _Load(SkinFile: TFileName; Image: TImage);
  begin
    Result := Result and FileExists(_DIR + SkinFile);
    if Result then
      Image.Picture.LoadFromFile(_DIR + SkinFile);
  end;
  
begin
  Result := True;
  try
    _DIR := GetWorkingTempDirectory;
    with frmMain do
    begin
      _Load(SKIN_IMAGE_TOP, imgTop);
      _Load(SKIN_IMAGE_BOTTOM, imgBottom);      
      _Load(SKIN_IMAGE_LEFT_HOME, imgLeft);
    end;
  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

initialization

finalization
  IniUiFile.Free;
  StringLocalizer.Free;

end.
