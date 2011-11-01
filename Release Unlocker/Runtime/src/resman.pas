unit ResMan;

interface

uses
  Windows, SysUtils, Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, SysTools,
  HashIdx;

// Resource Strings Manager
procedure InitializeStringUI;
function GetStringUI(Section, Code: string): string;
function SizeUnitToString(SizeUnit: TSizeUnit): string;
procedure LoadWizardUI(Section: string);

// Resource Images Manager
function InitializeSkin: Boolean;

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
    fHashIdx: THashIndexOptimizer;
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

function GetStringUI(Section, Code: string): string;
begin
  Result := StringLocalizer.Get(Section, Code);
end;

//------------------------------------------------------------------------------

procedure InitializeStringUI;
begin
  IniUiFile := TIniFile.Create(GetWorkingTempDirectory + APPCONFIG_UI_MESSAGES);
  StringLocalizer := TStringLocalizer.Create;

  // Generic
  frmMain.btnAbout.Caption := GetStringUI('Buttons', 'About');
  frmMain.btnCancel.Caption := GetStringUI('Buttons', 'Cancel');
  GameName := GetStringUI('General', 'GameName');

  // BrowseForDialog for the OutputDirectory
  frmMain.bfdOutput.StatusText := GetStringUI('Params', 'bfdStatusText');
  frmMain.bfdOutput.Title := GetStringUI('Params', 'bfdTitle');  
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
  i := frmMain.pcWizard.ActivePageIndex;
  if FileExists(GetWorkingTempDirectory + SKIN_IMAGES_LEFT_ORDER[i]) then
    frmMain.imgLeft.Picture.LoadFromFile(GetWorkingTempDirectory
      + SKIN_IMAGES_LEFT_ORDER[i]);

  // Load strings...
  CtrlsList := TStringList.Create;
  try
    IniUiFile.ReadSection(Section, CtrlsList);
    for i := 0 to CtrlsList.Count - 1 do
    begin
      C := frmMain.FindComponent(CtrlsList[i]);
      
      // Store the string...
      S := StringLocalizer.Get(Section, CtrlsList[i]);

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
  fHashIdx.Add(ASection + ACode, fList.Add(Item));
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
  fHashIdx := THashIndexOptimizer.Create;
end;

destructor TStringLocalizer.Destroy;
begin
  Clear;
  fList.Free;
  fHashIdx.Free;
  inherited;
end;

function TStringLocalizer.Get;
var
  i: Integer;

begin
  Result := '';
  i := fHashIdx.IndexOf(ASection + ACode);
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
