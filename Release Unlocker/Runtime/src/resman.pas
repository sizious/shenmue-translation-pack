unit ResMan;

{$DEFINE USE_DCL}

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
function GetLink(FieldName: string; LinkNumber: Integer): string;

implementation

uses
  Main, IniFiles, WorkDir, Common, Graphics, JvLinkLabel;

type
  //
  // JvLinkLabel Link handlers
  //
  TJvLinkLabelHandler = class(TObject)
  private
    fLinksList: TList;
    fFieldNamesList: TStringList;
    procedure Add(FieldName, Link: string);
    procedure Clear;
    function GetItem(Index: string): TStringList;
    function GetCount: Integer;
    function GetIndexByString(FieldName: string): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: string]: TStringList read GetItem;
  end;

  //
  // StringLocalizer
  //
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
  INVALID_STRING = '(%INVALID%)';

var
  GameName, WebURL: string;
  IniUiFile: TIniFile;
  StringLocalizer: TStringLocalizer;
  IsFadingOut, AbortFadingOut: Boolean;
  JvLinkLabelHandler: TJvLinkLabelHandler;

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
    WebURL := GetStringUI('General', 'WebURL');

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

// Thanks to JCA
// http://jca.developpez.com/fondu.php
procedure PlayFadeImages(ImageContainer: TImage; NewBitmapImage: TBitmap);
var
  L1, L2, L3: PByteArray;
  i, x, y, px: Integer;
  BitmapBuffer: TBitmap;

begin
  // Cancel the fading !
  if IsFadingOut then
    begin
{$IFDEF DEBUG}
      WriteLn('PlayFadeImages: CANCEL FADEOUT!');
{$ENDIF}
      AbortFadingOut := True;
      ImageContainer.Picture.Bitmap.Assign(NewBitmapImage);
    end
  else
    // Fading !
    if (ImageContainer.Picture.Bitmap.HandleAllocated) then
    begin
      BitmapBuffer := TBitmap.Create;
      try
{$IFDEF DEBUG}
      WriteLn('PlayFadeImages: Start FadeOut!');
{$ENDIF}
        IsFadingOut := True;
        BitmapBuffer.Assign(ImageContainer.Picture.Bitmap);
        i := 0;
        while (i < 100) and (not AbortFadingOut) do
        begin
          for y := 0 to ImageContainer.Height - 1 do begin
            l1 := BitmapBuffer.ScanLine[y];
            l2 := NewBitmapImage.ScanLine[y];
            l3 := ImageContainer.Picture.Bitmap.ScanLine[y];
            for x := 0 to ImageContainer.width - 1 do begin
              px := x * 3;
              // Blue
              l3[px] := muldiv (l2[px], i, 100) + muldiv(l1[px], 100-i, 100);
              // Green
              l3[px+1] := muldiv (l2[px+1], i, 100) + muldiv(l1[px+1], 100-i, 100);
              // Red
              l3[px+2] := muldiv (l2[px+2], i, 100) + muldiv(l1[px+2], 100-i, 100);
            end;
          end;
          Delay(20);
          ImageContainer.Repaint;
          i := i + 8;
        end;
      finally
{$IFDEF DEBUG}
      WriteLn('PlayFadeImages: End FadeOut!');
{$ENDIF}
        BitmapBuffer.Free;
        IsFadingOut := False;
        AbortFadingOut := False;
      end;
    end;
end;

//------------------------------------------------------------------------------

procedure DrawLeftImage;
var
  i: Integer;
  Buffer: TBitmap;
  ImageFile: TFileName;

begin
  Buffer := TBitmap.Create;
  try
    try
      i := frmMain.pcWizard.ActivePageIndex;
      ImageFile := GetWorkingTempDirectory + SKIN_IMAGES_LEFT_ORDER[i];
      if FileExists(ImageFile) then
      begin
        Buffer.LoadFromFile(ImageFile);
        PlayFadeImages(frmMain.imgLeft, Buffer);
      end;
    except
    end;
  finally
    Buffer.Free;
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
  DrawLeftImage;

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
        else if CC = 'rbn' then (C as TRadioButton).Caption := S
        else if CC = 'chk' then (C as TCheckBox).Caption := S
        else if CC = 'lkl' then (C as TJvLinkLabel).Caption := S;            
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
  i, LinksCount: Integer;
  Temp, URL: string;

begin
  Item := TStringLocalizerItem.Create;
  with Item do
  begin
    fCode := ACode;
    fSection := ASection;
    fText := StringReplace(AText, '\n', '<br>', [rfReplaceAll, rfIgnoreCase]);
    fText := StringReplace(fText, '\t', '      ', [rfReplaceAll, rfIgnoreCase]);
    fText := StringReplace(fText, '<%GAMENAME>', GameName, [rfReplaceAll, rfIgnoreCase]);
    fText := StringReplace(fText, '<%WEBURL>', WebURL, [rfReplaceAll, rfIgnoreCase]);

    // Scanning for links
    Temp := LowerCase(fText);
    LinksCount := GetSubStrCount('<%link=', Temp);
    i := 0;
    while i < LinksCount do
    begin
      Inc(i);

      // Parsing and getting the URL
      URL := Left('>', LeftNRight('<%link=', Temp, i));
      JvLinkLabelHandler.Add(ACode, URL);

      // Cleaning the link tag
      fText := StringReplace(fText, URL, '', []); // only the 1st occurence!
      // by cleaning only the 1st occurence, we eliminates the 'proceeded' tag,
      // so the same tag can be in the string after and it will proceeded as well.
    end;

    // Stripping every <%link= tags.
    fText := StringReplace(fText, '<%link=', '<link', [rfReplaceAll, rfIgnoreCase]);

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

{ TJvLinkLabelHandler }

procedure TJvLinkLabelHandler.Add(FieldName, Link: string);
var
  i: Integer;

begin
  // Retrieve the Link List for the FieldName
  i := GetIndexByString(FieldName);
  if i = -1 then
  begin
    // Create the list
    i := fFieldNamesList.Add(FieldName);
    fLinksList.Add(TStringList.Create);
  end;

  // Adding the link...
  TStringList(fLinksList[i]).Add(Link);
end;

procedure TJvLinkLabelHandler.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    TStringList(fLinksList[i]).Free;
  fLinksList.Clear;
  fFieldNamesList.Clear;
end;

constructor TJvLinkLabelHandler.Create;
begin
  fLinksList := TList.Create;
  fFieldNamesList := TStringList.Create;
end;

destructor TJvLinkLabelHandler.Destroy;
begin
  Clear;
  fLinksList.Free;
  fFieldNamesList.Free;
  inherited;
end;

function TJvLinkLabelHandler.GetCount: Integer;
begin
  Result := fLinksList.Count;
end;

function TJvLinkLabelHandler.GetIndexByString;
var
  i: Integer;

begin
  FieldName := UpperCase(FieldName);
  Result := -1;
  for i := 0 to fFieldNamesList.Count - 1 do
    if UpperCase(fFieldNamesList[i]) = FieldName then
      Result := i;
end;

function TJvLinkLabelHandler.GetItem;
var
  i: Integer;

begin
  Result := nil;
  i := GetIndexByString(Index);
  if i <> -1 then
    Result := TStringList(fLinksList[i]);
end;

//------------------------------------------------------------------------------

function GetLink(FieldName: string; LinkNumber: Integer): string;
var
  Item: TStringList;

begin
  Result := '';
  Item := JvLinkLabelHandler.Items[FieldName];
  if Assigned(Item) then
    Result := Item[LinkNumber];
end;

//------------------------------------------------------------------------------

initialization
  JvLinkLabelHandler := TJvLinkLabelHandler.Create;
  IsFadingOut := False;
  AbortFadingOut := False;

finalization
  IniUiFile.Free;
  StringLocalizer.Free;
  JvLinkLabelHandler.Free;

end.
