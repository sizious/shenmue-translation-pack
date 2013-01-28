unit ResMan;

{$DEFINE USE_DCL}

////////////////////////////////////////////////////////////////////////////////
interface
////////////////////////////////////////////////////////////////////////////////

uses
  Windows, SysUtils, Classes, Controls, StdCtrls, ComCtrls, ExtCtrls, SysTools
{$IFDEF USE_DCL}
  , HashIdx
{$ENDIF};

const
  LISTVIEW_RELEASE_INFO_ITEM_NORMAL = 0;
  LISTVIEW_RELEASE_INFO_ITEM_WEBURL = 1;

// Resources Manager
procedure InitializeResourcesManager;
function GetStringUI(Section, Code: string): string;
function SizeUnitToString(SizeUnit: TSizeUnit): string;
procedure LoadWizardUI(Section: string);

// Resource Images Manager
function InitializeSkin: Boolean;

// Misc
procedure FillReleaseInfo;
function AppNameWizardTitle: string;
function AppNameShow: Boolean;
function GetLink(FieldName: string; LinkNumber: Integer): string;

////////////////////////////////////////////////////////////////////////////////
implementation
////////////////////////////////////////////////////////////////////////////////

uses
  Main, IniFiles, WorkDir, Common, Graphics, JvLinkLabel, UITools;

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
  ReleaseInfo: TPackageReleaseInfo;
  GameName, WebURL, StrAppNameWizardTitle: string;
  BoolAppNameShow: Boolean;
  IniUiFile: TIniFile;
  StringLocalizer: TStringLocalizer;
  IsFadingOut, AbortFadingOut: Boolean;
  JvLinkLabelHandler: TJvLinkLabelHandler;

  ColorText,
  ColorLeft,
  ColorCenter,
  ColorLinksNormal,
  ColorLinksHot,
  ColorLinksClicked,
  ColorWarningText: TColor;

  SColorWarningText: string;

  SimpleLeftImageLoaded: Boolean;

//------------------------------------------------------------------------------

function AppNameShow: Boolean;
begin
  Result := BoolAppNameShow;
end;

//------------------------------------------------------------------------------

function AppNameWizardTitle: string;
begin
  Result := StrAppNameWizardTitle;
end;

//------------------------------------------------------------------------------

procedure FillReleaseInfo;
var
  SL: TStringList;
  i: Integer;

  procedure _Add(Key: string);
  var
    Value: string;

  begin
    with frmMain.lvwInfos.Items.Add do
    begin
      Caption := GetStringUI('HomeInfosCols', Key);
      Value := ReleaseInfo.GetValueFromKey(Key);
      SubItems.Add(Value);

      // if a web url...
      Data := Pointer(LISTVIEW_RELEASE_INFO_ITEM_NORMAL);
      if (IsInString('://', Value)) or (IsInString('mailto:', Value)) then
        Data := Pointer(LISTVIEW_RELEASE_INFO_ITEM_WEBURL);

{$IFDEF DEBUG}
      WriteLn(
        ' ~ ', Key, sLineBreak,
        '    Caption: ', Caption, sLineBreak,
        '    Value  : ', Value, sLineBreak,
        '    IsURL  : ', Integer(Data) = LISTVIEW_RELEASE_INFO_ITEM_WEBURL
      );
{$ENDIF}
    end;
  end;

begin
{$IFDEF DEBUG}
  WriteLn('FillReleaseInfo: ');
{$ENDIF}
  SL := TStringList.Create;
  try
    IniUiFile.ReadSection('HomeInfosCols', SL);
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

procedure InitializeResourcesManager;
var
  KeysColSize, ValuesColSize,
  KeysColDiff: Integer;
  
begin
  // Infos from UI.INI
{$IFDEF DEBUG}
  WriteLn('Init UI.INI');
{$ENDIF}
  IniUiFile := TIniFile.Create(GetWorkingTempDirectory + APPCONFIG_UI_MESSAGES);
  StringLocalizer := TStringLocalizer.Create;

  // Infos from CONFIG.INI
{$IFDEF DEBUG}
  WriteLn('Init CONFIG.INI');
{$ENDIF}
  ReleaseInfo := TPackageReleaseInfo.Create;
  ReleaseInfo.LoadFromFile(GetWorkingTempDirectory + APPCONFIG_RELEASEINFO);

  // Init UI
  with frmMain do
  begin
    // Generic
    btnAbout.Caption := GetStringUI('Buttons', 'About');
    btnCancel.Caption := GetStringUI('Buttons', 'Cancel');

    // Parameters...
    GameName := ReleaseInfo.GetValueFromKey('GameName');
    WebURL := ReleaseInfo.GetValueFromKey('WebURL');

    // Wizard title parameters...
    BoolAppNameShow := StrToBoolDef(ReleaseInfo.GetValueFromKey('ShowAppTitle'), True);
    StrAppNameWizardTitle := ReleaseInfo.GetValueFromKey('WizardTitle');
{$IFDEF DEBUG}
    WriteLn('Wizard Title Parameters:', sLineBreak,
      '   BoolAppNameShow = ', BoolAppNameShow, sLineBreak,
      '   StrAppNameWizardTitle = ', StrAppNameWizardTitle
    );
{$ENDIF}

    // BrowseForDialog for the OutputDirectory
    bfdOutput.StatusText := GetStringUI('Params', 'bfdStatusText');
    bfdOutput.Title := GetStringUI('Params', 'bfdTitle');

    // Info on the home
    lvwInfos.Columns[0].Caption := GetStringUI('HomeInfos', 'KeysCol');
    KeysColSize := lvwInfos.Columns[0].Width;
    ValuesColSize := lvwInfos.Columns[1].Width;
    lvwInfos.Columns[0].Width := IniUiFile.ReadInteger('HomeInfos', 'KeysColSize', KeysColSize);
    KeysColDiff := KeysColSize - lvwInfos.Columns[0].Width;
    lvwInfos.Columns[1].Width := ValuesColSize + KeysColDiff;
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
      WriteLn('  * PlayFadeImages: CANCEL FADEOUT!');
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
      WriteLn('  * PlayFadeImages: Start FadeOut!');
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
      WriteLn('  * PlayFadeImages: End FadeOut!');
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
        if not SimpleLeftImageLoaded and frmMain.Visible then
        begin
          Buffer.LoadFromFile(ImageFile);
          PlayFadeImages(frmMain.imgLeft, Buffer)
        end else begin
          SimpleLeftImageLoaded := False;
          frmMain.imgLeft.Picture.LoadFromFile(ImageFile);
        end;
      end else begin
        SimpleLeftImageLoaded := True;
        with Buffer do
        begin
          Height := frmMain.imgLeft.Height;
          Width := frmMain.imgLeft.Width;
          Canvas.Brush.Color := ColorLeft;
          Canvas.Brush.Style := bsSolid;
          Canvas.Pen.Style := psClear;
          Canvas.Pen.Color := clGreen;
          Canvas.FillRect(Rect(0, 0, Width, Height));
{$IFDEF DEBUG}
          SaveToFile('.\test_' + SKIN_IMAGES_LEFT_ORDER[i]);
{$ENDIF}
          frmMain.imgLeft.Picture.Bitmap.Assign(Buffer);
        end;
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
    // Loading section...
    IniUiFile.ReadSection(Section, CtrlsList);

    // Loading labels...
    for i := 0 to CtrlsList.Count - 1 do
    begin
      C := frmMain.FindComponent(CtrlsList[i]);
      S := StringLocalizer.Get(Section, CtrlsList[i]); // Store the string...

      if Assigned(C) and (S <> '') then
      begin
        CC := Copy(C.Name, 1, 3);
        if CC = 'lbl' then
          with (C as TLabel) do
          begin
            Caption := S;
            Color := ColorCenter;
            Font.Color := ColorText;
          end
        else if CC = 'grp' then
          with (C as TGroupBox) do
          begin
            Caption := ' ' + S + ' ';
            Color := ColorCenter;
            Font.Color := ColorText;
          end
        else if CC = 'btn' then
          with (C as TButton) do
          begin
            Caption := S;
          end
        else if CC = 'rbn' then
          with (C as TRadioButton) do
          begin
            Caption := S;
            Color := ColorCenter;
            Font.Color := ColorText;
          end
        else if CC = 'chk' then
          with (C as TCheckBox) do
          begin
            Caption := S;
            Color := ColorCenter;
            Font.Color := ColorText;            
          end
        else if CC = 'lkl' then
          with (C as TJvLinkLabel) do
          begin
            Caption := S;
            Color := ColorCenter;
            Font.Color := ColorText;
            LinkColor := ColorLinksNormal;
            LinkColorClicked := ColorLinksClicked;
            LinkColorHot := ColorLinksHot;
          end;
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

function InitializeSkin: Boolean;
var
  _DIR: TFileName;
  i: Integer;

  function _Load(SkinFile: TFileName; Image: TImage): Boolean;
  var
    Buffer: TBitmap;

  begin
    Result := FileExists(_DIR + SkinFile);
    if Result then
      Image.Picture.LoadFromFile(_DIR + SkinFile)
    else begin
      Buffer := TBitmap.Create;
      try
        with Buffer do
        begin
          Height := Image.Height;
          Width := Image.Width;
          Canvas.Brush.Color := ColorLeft;
          Canvas.Brush.Style := bsSolid;
          Canvas.Pen.Style := psClear;
          Canvas.FillRect(Rect(0, 0, Width, Height));
{$IFDEF DEBUG}
          SaveToFile('.\test_init_' + SkinFile);
{$ENDIF}
        end;
        Image.Picture.Bitmap.Assign(Buffer);
      finally
        Buffer.Free;
      end;
    end;
  end;
  
begin
  Result := True;
  try
    // Load the pictures
    _DIR := GetWorkingTempDirectory;
    with frmMain do
    begin
      // Colors of the UI
      ColorLeft := StringToColor(ReleaseInfo.GetValueFromKey('ColorLeft'));
      ColorCenter := StringToColor(ReleaseInfo.GetValueFromKey('ColorCenter'));
      pnlTop.Color := StringToColor(ReleaseInfo.GetValueFromKey('ColorTop'));
      pcWizard.Brush.Color := ColorCenter;
      pnlBottom.Color := StringToColor(ReleaseInfo.GetValueFromKey('ColorBottom'));
      pnlLeft.Color := ColorLeft;

      // Load the images
      _Load(SKIN_IMAGE_TOP, imgTop);
      _Load(SKIN_IMAGE_BOTTOM, imgBottom);
      SimpleLeftImageLoaded := not _Load(SKIN_IMAGE_LEFT_HOME, imgLeft);

      // Center
      for i := 0 to pcWizard.PageCount - 1 do
        TTabSheet(pcWizard.Pages[i]).Color := ColorCenter;

      // Colors of the text
      ColorText := StringToColor(ReleaseInfo.GetValueFromKey('ColorText'));
      with lblUnpackProgress do
      begin
        Font.Color := ColorText;
        Color := ColorCenter;
      end;

      ColorLinksNormal := StringToColor(ReleaseInfo.GetValueFromKey('ColorLinksNormal'));
      ColorLinksClicked := StringToColor(ReleaseInfo.GetValueFromKey('ColorLinksClicked'));
      ColorLinksHot := StringToColor(ReleaseInfo.GetValueFromKey('ColorLinksHot'));
      SColorWarningText := ReleaseInfo.GetValueFromKey('ColorWarningText');
      ColorWarningText := StringToColor(SColorWarningText);
    end;

  except
    on E:Exception do
    begin
{$IFDEF DEBUG}
      if E is EConvertError then
        raise EUserInterface.Create('This EConvertError is shown because you ' +
          'must inject a resource package in this binary!');
{$ENDIF}
      Result := False;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TJvLinkLabelHandler                                                        //
////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////
// TStringLocalizer                                                           //
////////////////////////////////////////////////////////////////////////////////

function TStringLocalizer.Add;
const
  LINK_TAG = '<#link=';

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

    // Tags replacement
    fText := StringReplace(AText, '\n', '<br>', [rfReplaceAll, rfIgnoreCase]);
    fText := StringReplace(fText, '\t', '      ', [rfReplaceAll, rfIgnoreCase]);
    fText := StringReplace(fText, '</#Link>', '</link>', [rfReplaceAll, rfIgnoreCase]);

    // Dynamic Tags remplacement
    fText := StringReplace(fText, '<#GameName>', GameName, [rfReplaceAll, rfIgnoreCase]);
    fText := StringReplace(fText, '<#WebURL>', WebURL, [rfReplaceAll, rfIgnoreCase]);

    // Warning Color...
    fText := StringReplace(fText, '<#WarningColor>', '<color=' + SColorWarningText + '>',
      [rfReplaceAll, rfIgnoreCase]);
    fText := StringReplace(fText, '</#WarningColor>', '</color>', [rfReplaceAll, rfIgnoreCase]);

    // Scanning for links
    Temp := LowerCase(fText);
    LinksCount := GetSubStrCount(LINK_TAG, Temp);
    i := 0;
    while i < LinksCount do
    begin
      Inc(i);

      // Parsing and getting the URL
      URL := Left('>', LeftNRight(LINK_TAG, Temp, i));
      JvLinkLabelHandler.Add(ACode, URL);

      // Cleaning the link tag
      fText := StringReplace(fText, URL, '', []); // only the 1st occurence!
      // by cleaning only the 1st occurence, we eliminates the 'proceeded' tag,
      // so the same tag can be in the string after and it will proceeded as well.
    end;

    // Stripping every "<#link=" tags.
    fText := StringReplace(fText, LINK_TAG, '<link', [rfReplaceAll, rfIgnoreCase]);

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

//******************************************************************************

procedure TStringLocalizer.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fList.Clear;
end;

//******************************************************************************

constructor TStringLocalizer.Create;
begin
  fList := TList.Create;
{$IFDEF USE_DCL}
  fHashIdx := THashIndexOptimizer.Create;
{$ENDIF}
end;

//******************************************************************************

destructor TStringLocalizer.Destroy;
begin
  Clear;
  fList.Free;
{$IFDEF USE_DCL}
  fHashIdx.Free;
{$ENDIF}
  inherited;
end;

//******************************************************************************

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

//******************************************************************************

function TStringLocalizer.GetCount;
begin
  Result := fList.Count;
end;

//******************************************************************************

function TStringLocalizer.GetItem;
begin
  Result := TStringLocalizerItem(fList[Index]);
end;

////////////////////////////////////////////////////////////////////////////////

initialization
  StrAppNameWizardTitle := '';
  BoolAppNameShow := True;
  JvLinkLabelHandler := TJvLinkLabelHandler.Create;
  IsFadingOut := False;
  AbortFadingOut := False;

finalization
  ReleaseInfo.Free;
  IniUiFile.Free;
  StringLocalizer.Free;
  JvLinkLabelHandler.Free;

end.
