unit mtedit;

interface

uses
  Windows, SysUtils, Classes;
  
type
  // The main class to use !
  TModelTexturedEditor = class;

  // Used to detect the game/file version
  TGameVersion = (gvUndef, gvShenmue, gvShenmue2);
  
  // Used to parse each section in file
  TRawSectionHeader = record
    Name: array[0..3] of Char;  // Section Name Signature (MDP7, TXT7...)
    Size: Integer;              // Section Size
  end;

  // Contains each texture recorded in the TXT section
  TTexturesList = class;

  // Contains each section contained in the file
  TSectionsList = class;

  // Texture list entry
  // Textures are PVR or DDS inside a GBIX container.
  // The GBIX format is: [GBIX_HEADER] (12 bytes) ... [TEX_DATA] (variable, in DDS/PVR format)
  TTexturesListEntry = class
  private
    fOwner: TTexturesList;
    fIndex: Integer;
    fSize: Integer;
    fOffset: Integer;
  protected
    function GetLoadedFileName: TFileName;
    function GetOutputTextureFileName: TFileName;
  public
    constructor Create(AOwner: TTexturesList);
    procedure ExportToFile; overload;
    procedure ExportToFile(const FileName: TFileName); overload;
    property Index: Integer read fIndex;
    property Offset: Integer read fOffset;
    property Size: Integer read fSize;
    property Owner: TTexturesList read fOwner;
  end;

  // Texture list
  TTexturesList = class
  private
    fSectionIndex: Integer; // Index of the TXT section in the Section array (init by ParseTexturesSection)
    fOwner: TModelTexturedEditor;
    fTexturesList: TList;
    function GetItem(Index: Integer): TTexturesListEntry;
    function GetCount: Integer;
    function GetOffset: Integer;
    function GetSize: Integer;
  protected
    procedure Add(const Offset, Size: Integer);
    procedure Clear;
    procedure ParseTexturesSection(var F: file);
  public
    constructor Create(AOwner: TModelTexturedEditor);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TTexturesListEntry read GetItem; default;
    property Offset: Integer read GetOffset;
    property Owner: TModelTexturedEditor read fOwner;
    property Size: Integer read GetSize;
  end;

  // Section list entry
  TSectionsListEntry = class
  private
    fName: string;
    fSize: Integer;
    fOffset: Integer;
  public
    property Name: string read fName;
    property Offset: Integer read fOffset;
    property Size: Integer read fSize;
  end;

  // Sections list
  TSectionsList = class
  private
    fOwner: TModelTexturedEditor;
    fSectionsList: TList;
    function GetItem(Index: Integer): TSectionsListEntry;
    function GetCount: Integer;
  protected
    procedure Add(const Name: string; const Offset, Size: Integer);
    procedure Clear;
    procedure ParseFile(var F: file);
  public
    constructor Create(AOwner: TModelTexturedEditor);
    destructor Destroy; override;
    function GetTexturesSectionIndex: Integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSectionsListEntry read GetItem; default;
    property Owner: TModelTexturedEditor read fOwner;
  end;

  // Main object
  TModelTexturedEditor = class
  private
    fGameVersion: TGameVersion;
    fLoadedFileName: TFileName;
    fSections: TSectionsList;
    fTextures: TTexturesList;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromFile(const FileName: TFileName): Boolean;
    function SaveToFile(const FileName: TFileName): Boolean;
    property GameVersion: TGameVersion read fGameVersion;
    property FileName: TFileName read fLoadedFileName;
    property Sections: TSectionsList read fSections;
    property Textures: TTexturesList read fTextures;
  end;
  
implementation

uses
  Utils;
  
const
  GAME_INTEGER_SIZE = 4;
  
{ TTexturesList }

procedure TTexturesList.Add(const Offset, Size: Integer);
var
  Item: TTexturesListEntry;
  i: Integer;
  
begin
  Item := TTexturesListEntry.Create(Self);
  Item.fOffset := Offset;
  Item.fSize := Size;
  i := fTexturesList.Add(Item);
  Item.fIndex := i;

  {$IFDEF DEBUG} WriteLn('  #', i, ': ', Item.Offset, ', ', Item.Size); {$ENDIF}
end;

procedure TTexturesList.Clear;
var
  i: Integer;

begin
  for i := 0 to fTexturesList.Count - 1 do
    TTexturesListEntry(fTexturesList[i]).Free;
  fTexturesList.Clear;
end;

constructor TTexturesList.Create;
begin
  fOwner := AOwner;
  fTexturesList := TList.Create;
end;

destructor TTexturesList.Destroy;
begin
  Clear;
  fTexturesList.Free;
  inherited;
end;

function TTexturesList.GetCount: Integer;
begin
  Result := fTexturesList.Count;
end;

function TTexturesList.GetItem(Index: Integer): TTexturesListEntry;
begin
  Result := TTexturesListEntry(fTexturesList[Index]);
end;

function TTexturesList.GetOffset: Integer;
begin
  Result := Owner.Sections[fSectionIndex].Offset;
end;

function TTexturesList.GetSize: Integer;
begin
  Result := Owner.Sections[fSectionIndex].Size;
end;

// ParseTexturesSection
// !!! A REFAIRE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

procedure TTexturesList.ParseTexturesSection(var F: file);
var
  i, TextObjIndex, TexturesSectionOffset, TexturesCount, CalcSize: Integer;
  TexturesSectionItem: TSectionsListEntry;

begin
  TextObjIndex := Owner.Sections.GetTexturesSectionIndex;

  if TextObjIndex <> -1 then begin
    fSectionIndex := TextObjIndex;
    
    {$IFDEF DEBUG} WriteLn('PARSING TEXTURES SECTION'); {$ENDIF}

    TexturesSectionItem := Owner.Sections[TextObjIndex];

    // Positionning on the Section Count offset inside the Textures section (TXT7)
    TexturesSectionOffset := TexturesSectionItem.Offset + SizeOf(TRawSectionHeader);  // 8 for section name [4] + section size [4]
    Seek(F, TexturesSectionOffset);
    BlockRead(F, TexturesCount, GAME_INTEGER_SIZE);

    // Positionning at the end of the textures table inside the Textures section
    Seek(F, (TexturesSectionOffset + GAME_INTEGER_SIZE) + (TexturesCount * GAME_INTEGER_SIZE));
    CalcSize := TexturesSectionItem.Size;

    // Reading all textures offset info from the back <- to the start
    for i := 0 to TexturesCount - 1 do begin
      // reading current texture entry
      Seek(F, FilePos(F) - GAME_INTEGER_SIZE);
      BlockRead(F, TextObjIndex, GAME_INTEGER_SIZE);
      Seek(F, FilePos(F) - GAME_INTEGER_SIZE); // Because we are reading entries from the BACK!!! (one loop optimization)

      // Computing the texture GBIX size
      CalcSize := CalcSize - TextObjIndex;

      // Adding the new texture entry
      Self.Add(TextObjIndex, CalcSize);

      // The old texture offset becomes the new CalcSize to compute the next texture size
      CalcSize := TextObjIndex;
    end;

  end;
end;

{ TSectionsList }

procedure TSectionsList.Add(const Name: string; const Offset, Size: Integer);
var
  Item: TSectionsListEntry;
  
begin
  Item := TSectionsListEntry.Create;
  Item.fName := Name;
  Item.fOffset := Offset;
  Item.fSize := Size;
  fSectionsList.Add(Item);
  {$IFDEF DEBUG} WriteLn('  ', Item.fName, ': Offset: ', Item.fOffset, ', Size: ', Item.fSize); {$ENDIF}
end;

procedure TSectionsList.Clear;
var
  i: Integer;

begin
  for i := 0 to fSectionsList.Count - 1 do
    TSectionsListEntry(fSectionsList[i]).Free;
  fSectionsList.Clear;
end;

constructor TSectionsList.Create(AOwner: TModelTexturedEditor);
begin
  fOwner := AOwner;
  fSectionsList := TList.Create;
end;

destructor TSectionsList.Destroy;
begin
  Clear;
  fSectionsList.Free;
  inherited;
end;

function TSectionsList.GetCount: Integer;
begin
  Result := fSectionsList.Count
end;

function TSectionsList.GetItem(Index: Integer): TSectionsListEntry;
begin
  Result := TSectionsListEntry(fSectionsList[Index]);
end;

function TSectionsList.GetTexturesSectionIndex: Integer;
var
  i: Integer;
  SearchedSection: string;

begin
  Result := -1;
  SearchedSection := '';

  case Owner.GameVersion of
    gvShenmue2: SearchedSection := 'TXT7';
    //gvShenmue : SearchedSection := 'TEXN';
  end;

  for i := 0 to Count - 1 do
    if (Items[i].Name = SearchedSection) then begin
      Result := i;
      Break;
    end;
end;

procedure TSectionsList.ParseFile(var F: file);
var
  RawEntry: TRawSectionHeader;
  Offset: Integer;
  Done: Boolean;

begin
  {$IFDEF DEBUG}
  case Owner.GameVersion of
    gvUndef     : WriteLn('UNDEFINED FILE FORMAT ?!');
    gvShenmue2  : WriteLn('MT7 SECTIONS ENTRIES:');
  end;
  {$ENDIF}
  
  Done := False;
  while not Done do begin
    Offset := FilePos(F);
    BlockRead(F, RawEntry, SizeOf(TRawSectionHeader));

    if (RawEntry.Size < FileSize(F)) then begin
      Add(RawEntry.Name, Offset, RawEntry.Size);
      Seek(F, Offset + RawEntry.Size); // seeking to next section
    end;

    Done := EOF(F) and (Offset + SizeOf(TRawSectionHeader) < FileSize(F));
  end;
end;

{ TModelTexturedEditor }

constructor TModelTexturedEditor.Create;
begin
  fGameVersion := gvUndef;
  fSections := TSectionsList.Create(Self);
  fTextures := TTexturesList.Create(Self);
end;

destructor TModelTexturedEditor.Destroy;
begin
  fSections.Free;
  fTextures.Free;
  inherited;
end;

function TModelTexturedEditor.LoadFromFile(const FileName: TFileName): Boolean;
var
  F: file;
  Buf: string;

begin
  Result := False;
  fLoadedFileName := FileName;
  
  // Set game version
  fGameVersion := gvUndef;
  Buf := UpperCase(ExtractFileExt(FileName));
  if (Buf = '.MT7') then
    fGameVersion := gvShenmue2
  else
    if ((Buf = '.MT6') or (Buf = '.MT5')) then
      fGameVersion := gvShenmue;

  // Parse the loaded file if recognized
  if (GameVersion <> gvUndef) then begin
    Result := True;

    Textures.Clear;
    Sections.Clear;
    
    // Opening the file
    AssignFile(F, FileName);
    FileMode := fmOpenRead;
    {$I-}Reset(F, 1);{$I+}
    if IOResult <> 0 then Exit;

    try

      try
        // Retrieve file sections
        Sections.ParseFile(F);
        {$IFDEF DEBUG} WriteLn(''); {$ENDIF}
        
        // Parse the texture section
        Textures.ParseTexturesSection(F);
        {$IFDEF DEBUG} WriteLn(''); {$ENDIF}
        
      except
        Result := False;
      end;

    finally
      CloseFile(F);
    end;
  end {$IFNDEF DEBUG}; {$ELSE} else WriteLn('UNDEFINED FILE FORMAT !!'); {$ENDIF}
end;

function TModelTexturedEditor.SaveToFile(const FileName: TFileName): Boolean;
begin

end;

{ TTexturesListEntry }

constructor TTexturesListEntry.Create(AOwner: TTexturesList);
begin
  fOwner := AOwner;
end;

procedure TTexturesListEntry.ExportToFile;
begin
  ExportToFile(GetOutputTextureFileName);
end;

procedure TTexturesListEntry.ExportToFile(const FileName: TFileName);
var
  F_src, F_dest: file;

begin

  // Opening the file
  AssignFile(F_src, GetLoadedFileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F_src, 1);{$I+}
  if IOResult <> 0 then Exit;

  AssignFile(F_dest, FileName);
  FileMode := fmOpenWrite;
  {$I-}ReWrite(F_dest, 1);{$I+}
  if IOResult <> 0 then Exit;

  CopyFileBlock(F_src, F_dest, (Owner.Offset + Offset), Size);

  CloseFile(F_src);
  CloseFile(F_dest);
end;

function TTexturesListEntry.GetLoadedFileName: TFileName;
begin
  Result := Owner.Owner.FileName;
end;

function TTexturesListEntry.GetOutputTextureFileName: TFileName;
begin
  Result := ExtractFileName(GetLoadedFileName) + '_PVR#' + Format('%02d', [Index + 1]) + '.pvr';
end;

end.
