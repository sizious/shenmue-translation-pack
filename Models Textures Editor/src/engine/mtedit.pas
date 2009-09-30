unit mtedit;

interface

uses
  Windows, SysUtils, Classes;

const
  SHENMUE2_MT7_TEXTURE_SECTION = 'TXT7';
  SHENMUE1_MT6_TEXTURE_SECTION = 'TEXD';
  SHENMUE1_SECTION_IGNORE      = 'TEXN'; // because it's written with the TEXD section
  TEXN_SECTION_SIZE            = 16;

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

  // Entry of the TSectionsList
  TSectionsListEntry = class;

  // Texture list entry
  // Textures are PVR or DDS inside a GBIX container.
  // The GBIX format is: [GBIX_HEADER] (12 bytes) ... [TEX_DATA] (variable, in DDS/PVR format)
  TTexturesListEntry = class(TObject)
  private
    fImportFileName: TFileName;
    fMTEditorOwner: TModelTexturedEditor;
    fOwner: TTexturesList;
    fIndex: Integer;
    fIsFileSection: Boolean;
    fSectionIndex: Integer;
    fSize: Integer;
    fOffset: Integer;
    fUpdated: Boolean;
    function GetTexturesSection: TSectionsListEntry;
  protected
    function GetLoadedFileName: TFileName;
    property MTEditorOwner: TModelTexturedEditor read fMTEditorOwner;
  public
    constructor Create(AOwner: TTexturesList);

    procedure CancelImport;
    function ImportFromFile(const FileName: TFileName): Boolean;
    procedure ExportToFile(const FileName: TFileName);
    function ExportToFolder(const Folder: TFileName): TFileName;
    function GetOutputTextureFileName: TFileName;
    function IsFileSection: Boolean;

    property Index: Integer read fIndex;  // give this item index in the TexturesList
    property ImportFileName: TFileName read fImportFileName;
    property Offset: Integer read fOffset;
    property Section: TSectionsListEntry read GetTexturesSection;
    property Size: Integer read fSize;
    property Owner: TTexturesList read fOwner;
    property Updated: Boolean read fUpdated;
  end;

  // Texture list
  // This is a Section item but with Textures specifics properties
  // TEXD: Shenmue 1
  // TXT7: Shenmue 2
  TTexturesList = class(TObject)
  private
    fTexturesSectionIndex: Integer; // Index of the TXT section in the Section array (init by ParseTexturesSection)
    fOwner: TModelTexturedEditor;
    fTexturesList: TList;
    function GetItem(Index: Integer): TTexturesListEntry;
    function GetCount: Integer;
    function GetTexturesSectionEntry: TSectionsListEntry;
  protected
    procedure Add(const Index, Offset, Size: Integer; IsFileSection: Boolean;
      SectionIndex: Integer);
    procedure Clear;
    procedure ParseTexturesSection_Shenmue2_MT7(var F: file);
    procedure ParseTexturesSection_Shenmue_MT5_MT6(var F: file);
    procedure WriteTexturesSection_Shenmue2_MT7(var InStream, OutStream: TFileStream);
    procedure WriteTexturesSection_Shenmue_MT5_MT6(var InStream, OutStream: TFileStream);
  public
    constructor Create(AOwner: TModelTexturedEditor);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TTexturesListEntry read GetItem; default;
    property Owner: TModelTexturedEditor read fOwner;
    property GraphicSection: TSectionsListEntry read GetTexturesSectionEntry; // TXT7 (Shenmue 2) or TEXD (Shenmue 1)
  end;

  // Section list entry
  TSectionsListEntry = class(TObject)
  private
    fOwner: TSectionsList;
    fName: string;
    fSize: Integer;
    fOffset: Integer;
    fIsTextures: Boolean;
    fIgnore: Boolean;
    function GetModelTexturedEditor: TModelTexturedEditor;
  protected
    property MTEditor: TModelTexturedEditor read GetModelTexturedEditor;
  public
    constructor Create(Owner: TSectionsList);
    procedure SaveToFile(const FileName: TFileName);
    property Ignored: Boolean read fIgnore;
    property IsTextures: Boolean read fIsTextures;
    property Name: string read fName;
    property Offset: Integer read fOffset;
    property Owner: TSectionsList read fOwner;
    property Size: Integer read fSize;
  end;

  // Sections list
  TSectionsList = class(TObject)
  private
    fOwner: TModelTexturedEditor;
    fSectionsList: TList;
    function GetItem(Index: Integer): TSectionsListEntry;
    function GetCount: Integer;
  protected
    function Add(const Name: string; const Offset, Size: Integer): Integer;
    procedure Clear;
    function ParseFile(var F: file): TGameVersion;
  public
    constructor Create(AOwner: TModelTexturedEditor);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSectionsListEntry read GetItem; default;
    property Owner: TModelTexturedEditor read fOwner;
 end;

  // Main object
  TModelTexturedEditor = class(TObject)
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
    property SourceFileName: TFileName read fLoadedFileName;
    property Sections: TSectionsList read fSections;
    property Textures: TTexturesList read fTextures;
  end;
  
implementation

uses
  Utils;
  
const
  GAME_INTEGER_SIZE = 4;
  
{ TTexturesList }

procedure TTexturesList.Add(const Index, Offset, Size: Integer;
  IsFileSection: Boolean; SectionIndex: Integer);
var
  Item: TTexturesListEntry;

begin
  Item := TTexturesListEntry.Create(Self);
  Item.fOffset := Offset;
  Item.fSize := Size;
  Item.fIndex := Index;
  Item.fIsFileSection := IsFileSection;
  Item.fSectionIndex := SectionIndex;
  fTexturesList.Add(Item);
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
  fTexturesSectionIndex  := -1;
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

function TTexturesList.GetTexturesSectionEntry: TSectionsListEntry;
begin
  Result := Owner.Sections[fTexturesSectionIndex];
end;

procedure TTexturesList.ParseTexturesSection_Shenmue2_MT7(var F: file);
var
  i, TexturesSectionOffset, TexturesCount, CalcSize, TextureOffset: Integer;
  TexturesSectionItem: TSectionsListEntry;
  TempTexItem: TTexturesListEntry;

begin
//  TextObjIndex := Owner.Sections.GetTexturesSectionIndex;

  if fTexturesSectionIndex <> -1 then begin
                  
{$IFDEF DEBUG}
    WriteLn('*** MT7 PARSING TEXTURES SECTION: ');
{$ENDIF}

    TexturesSectionItem := GraphicSection;

    // Positionning on the Section Count offset inside the Textures section (TXT7)
    TexturesSectionOffset := TexturesSectionItem.Offset + SizeOf(TRawSectionHeader);  // 8 for section name [4] + section size [4]
    Seek(F, TexturesSectionOffset);
    BlockRead(F, TexturesCount, GAME_INTEGER_SIZE);

    // Positionning at the end of the textures table inside the Textures section
    Seek(F, (TexturesSectionOffset + GAME_INTEGER_SIZE) + (TexturesCount * GAME_INTEGER_SIZE));
    CalcSize := TexturesSectionItem.Size;

    // Reading all textures offset info from the back <- to the start
    for i := TexturesCount - 1 downto 0 do begin
      // reading current texture entry
      Seek(F, FilePos(F) - GAME_INTEGER_SIZE);
      BlockRead(F, TextureOffset, GAME_INTEGER_SIZE);
      Seek(F, FilePos(F) - GAME_INTEGER_SIZE); // Because we are reading entries from the BACK!!! (one loop optimization)

      // Computing the texture GBIX size
      CalcSize := CalcSize - TextureOffset;

      // Adding the new texture entry
      Add(i, TextureOffset, CalcSize, False, -1);

      // The old texture offset becomes the new CalcSize to compute the next texture size
      CalcSize := TextureOffset;
    end;

    // Sorting TexturesList
    for i := 0 to Count - 1 do begin
      TempTexItem := fTexturesList.Items[Items[i].Index];
      fTexturesList.Items[Items[i].Index] := fTexturesList.Items[i];
      fTexturesList.Items[TempTexItem.Index] := TempTexItem;
    end;
  end;
end;

procedure TTexturesList.ParseTexturesSection_Shenmue_MT5_MT6(var F: file);
const
  TEXD_SIGN_SIZE = 8;

var
  i, TexturesCount,
  Size, SectionIndex: Integer;
  SectionItem: TSectionsListEntry;

begin
{$IFDEF DEBUG}
    WriteLn('*** MT5/MT6 PARSING TEXTURES SECTION: ');
{$ENDIF}

  // Get TEXD infos
  if fTexturesSectionIndex <> -1 then begin
    // Read the textures TEXN count in the TEXD section
    Seek(F, Owner.Sections[fTexturesSectionIndex].Offset + TEXD_SIGN_SIZE); // skip "TEXD" sign + "TEXD" size
    BlockRead(F, TexturesCount, GAME_INTEGER_SIZE);

    for i := 0 to TexturesCount - 1 do begin
      SectionIndex := fTexturesSectionIndex + 1 + i;
      SectionItem := Owner.Sections[SectionIndex]; // get "TEXN" section

      // Get the GBIX PVR size
      Seek(F, SectionItem.Offset + 4);
      BlockRead(F, Size, GAME_INTEGER_SIZE);
      Dec(Size, TEXN_SECTION_SIZE); // 16 is the "TEXN" section header
      Add(i, SectionItem.Offset + TEXN_SECTION_SIZE, Size, True, SectionIndex); // 16 to skip "TEXN" header
    end;
  end;
end;

procedure TTexturesList.WriteTexturesSection_Shenmue2_MT7(var InStream,
  OutStream: TFileStream);
begin
  
end;

procedure TTexturesList.WriteTexturesSection_Shenmue_MT5_MT6(var InStream,
  OutStream: TFileStream);
var
  i: Integer;

begin
  // Saving the "TEXD" section
  InStream.Seek(GraphicSection.Offset, soFromBeginning);
  OutStream.CopyFrom(InStream, GraphicSection.Size);

  // Saving "TEXN" sections
  for i := 0 to Count - 1 do begin
    // Write the texture section header "TEXN"
    InStream.Seek(Items[i].Section.Offset, soFromBeginning);
    OutStream.CopyFrom(InStream, TEXN_SECTION_SIZE); // 16 is the size of the TEXN header section

    // Write the texture
    InStream.Seek(Items[i].Offset, soFromBeginning);
    OutStream.CopyFrom(InStream, Items[i].Size);
  end;
end;

{ TSectionsList }

function TSectionsList.Add(const Name: string; const Offset, Size: Integer): Integer;
var
  Item: TSectionsListEntry;
  
begin
  Item := TSectionsListEntry.Create(Self);
  Item.fName := Name;
  Item.fOffset := Offset;
  Item.fSize := Size;
  Result := fSectionsList.Add(Item);
  {$IFDEF DEBUG} WriteLn('  ', Item.fName, ': Offset: ', Item.fOffset, ', Size: ', Item.fSize); {$ENDIF}
end;

procedure TSectionsList.Clear;
var
  i: Integer;

begin
  for i := 0 to fSectionsList.Count - 1 do
    TSectionsListEntry(fSectionsList[i]).Free;
  fSectionsList.Clear;
  Owner.Textures.fTexturesSectionIndex  := -1;
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

function TSectionsList.ParseFile(var F: file): TGameVersion;
var
  RawEntry: TRawSectionHeader;
  Offset, SectionIndex: Integer;
  Done: Boolean;

begin
  Result := gvUndef;
  
{$IFDEF DEBUG}
  WriteLn('*** PARSING SECTIONS ***');
{$ENDIF}

  Done := False;
  
  while not Done do begin
    Offset := FilePos(F);
    BlockRead(F, RawEntry, SizeOf(TRawSectionHeader));

    if (RawEntry.Size < FileSize(F)) then begin
      SectionIndex := Add(RawEntry.Name, Offset, RawEntry.Size);

      // Detecting the Textures section & Game version
      if RawEntry.Name = SHENMUE1_MT6_TEXTURE_SECTION then begin
        Result := gvShenmue;
        Items[SectionIndex].fIsTextures := True;
        Owner.Textures.fTexturesSectionIndex := SectionIndex;
      end else if RawEntry.Name = SHENMUE2_MT7_TEXTURE_SECTION then begin
        Result := gvShenmue2;
        Items[SectionIndex].fIsTextures := True;
        Owner.Textures.fTexturesSectionIndex := SectionIndex;
      end;

      if RawEntry.Name = SHENMUE1_SECTION_IGNORE then
        Items[SectionIndex].fIgnore := True;

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
{$IFDEF DEBUG}
  i: Integer;
{$ENDIF}

begin
  Result := False;
  if not FileExists(FileName) then Exit;
  
  Result := True;
  fLoadedFileName := ExpandFileName(FileName);

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
      fGameVersion := Sections.ParseFile(F);

{$IFDEF DEBUG}
      WriteLn('');
{$ENDIF}

      // Parse the texture section
      case GameVersion of
        gvShenmue:
          Textures.ParseTexturesSection_Shenmue_MT5_MT6(F);
        gvShenmue2:
          Textures.ParseTexturesSection_Shenmue2_MT7(F);
      end;

{$IFDEF DEBUG}
    // Showing Textures List
    if Textures.Count > 0 then begin
      for i := 0 to Textures.Count - 1 do
        WriteLn('  #', i, ': ', Textures.Items[i].Offset, ', ', Textures.Items[i].Size);
    end else
      WriteLn('  (empty)');
    WriteLn('');
{$ENDIF}
        
    except
      Result := False;
    end;

  finally
    CloseFile(F);
  end;

//  end {$IFNDEF DEBUG}; {$ELSE} else WriteLn('UNDEFINED FILE FORMAT !!'); {$ENDIF}
end;

function TModelTexturedEditor.SaveToFile(const FileName: TFileName): Boolean;
var
  i: Integer;
  InStream, OutStream: TFileStream;

begin
  Result := False;
  if not FileExists(SourceFileName) then Exit;

{$IFDEF DEBUG}
  WriteLn('*** SAVING AND PATCHING FILE ***');
{$ENDIF}

  InStream := TFileStream.Create(SourceFileName, fmOpenRead);
  OutStream := TFileStream.Create(FileName, fmCreate);
  try

    for i := 0 to Sections.Count - 1 do begin

{$IFDEF DEBUG}
      Write('  ', Sections[i].Name, ', offset: ', Sections[i].Offset,
        ', size: ', Sections[i].Size);
{$ENDIF}

      if Sections[i].IsTextures then begin
{$IFDEF DEBUG}
        Write(', (Textures Section)');
{$ENDIF}
        case GameVersion of
{$IFDEF DEBUG}
          gvUndef:
            WriteLn('UNDEFINED GAME VERSION ?!!');
{$ENDIF}
          gvShenmue:
            Textures.WriteTexturesSection_Shenmue_MT5_MT6(InStream, OutStream);
            
          gvShenmue2:
            Textures.WriteTexturesSection_Shenmue2_MT7(InStream, OutStream);
        end;

      end else begin
        if not Sections[i].Ignored then begin
          InStream.Seek(Sections[i].Offset, soFromBeginning);
          OutStream.CopyFrom(InStream, Sections[i].Size);
        end;
      end;

{$IFDEF DEBUG}
      WriteLn('');
{$ENDIF}
    end;

  finally
    InStream.Free;
    OutStream.Free;
  end;
end;

{ TTexturesListEntry }

procedure TTexturesListEntry.CancelImport;
begin
  fUpdated := False;
end;

constructor TTexturesListEntry.Create(AOwner: TTexturesList);
begin
  fOwner := AOwner;
  fMTEditorOwner := Owner.Owner;
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

  case MTEditorOwner.GameVersion of
    gvShenmue:
      CopyFileBlock(F_src, F_dest, Offset, Size); // not a container in TEXN sections (Shenmue 1)
    gvShenmue2:
      CopyFileBlock(F_src, F_dest, (Owner.GraphicSection.Offset + Offset), Size); // relative offset ('TXT7' is a container with several sections)
  end;

  CloseFile(F_src);
  CloseFile(F_dest);
end;

function TTexturesListEntry.ExportToFolder(const Folder: TFileName): TFileName;
begin
  Result := IncludeTrailingPathDelimiter(Folder) + GetOutputTextureFileName;
  ExportToFile(Result);
end;

function TTexturesListEntry.GetLoadedFileName: TFileName;
begin
  Result := Owner.Owner.SourceFileName
end;

function TTexturesListEntry.GetOutputTextureFileName: TFileName;
begin
  Result := ExtractFileName(GetLoadedFileName) + '_PVR#' + Format('%2.2d', [Index + 1]) + '.pvr';
end;

function TTexturesListEntry.GetTexturesSection: TSectionsListEntry;
begin
  if fSectionIndex = -1 then
    raise Exception.Create('Please use the IsFileSection method before calling this!');
  Result := MTEditorOwner.Sections[fSectionIndex];
end;

function TTexturesListEntry.ImportFromFile(const FileName: TFileName): Boolean;
begin
  Result := FileExists(FileName);
  if not Result then Exit;
  fImportFileName := FileName;
end;

function TTexturesListEntry.IsFileSection: Boolean;
begin
  Result := fIsFileSection;
end;

{ TSectionsListEntry }

constructor TSectionsListEntry.Create(Owner: TSectionsList);
begin
  fOwner := Owner;
  fIsTextures := False;
  fIgnore := False;
end;

function TSectionsListEntry.GetModelTexturedEditor: TModelTexturedEditor;
begin
  Result := Owner.Owner;
end;

procedure TSectionsListEntry.SaveToFile(const FileName: TFileName);
var
  InStream, OutStream: TFileStream;

begin
  InStream := TFileStream.Create(MTEditor.SourceFileName, fmOpenRead);
  OutStream := TFileStream.Create(FileName, fmCreate);
  try
    InStream.Seek(Offset, soFromBeginning);
    OutStream.CopyFrom(InStream, Size);
  finally
    InStream.Free;
    OutStream.Free;
  end;
end;

end.
