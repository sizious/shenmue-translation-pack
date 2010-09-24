(*
  T E X T D B  M O D U L E
  This file is part of the TextDB Module, the Text Correction Database.

  The Text Correction Database is a module made to store EVERY original subtitles
  in order for you to correct the subtitles.

  This file is here to load TCD files, which are compilated ORIGINAL subtitles
  from a specific NPC (identified by VoiceID & CharID). When the TCD file is
  loaded which proper VoiceID and CharID, you can get the subtitles by using the
  Subtitles properties of the TSubtitlesContainer object.
*)
unit DBInlay;

interface

uses
  Windows, SysUtils, Classes;

type
  TTextDatabaseSubtitlesContainer = class;

  TTextDatabaseSubtitleItem = class(TObject)
  private
    fCode: string;
    fText: string;
    fOwner: TTextDatabaseSubtitlesContainer;
  public
    constructor Create(Owner: TTextDatabaseSubtitlesContainer);
    property Code: string read fCode;
    property Text: string read fText;
    property Owner: TTextDatabaseSubtitlesContainer read fOwner;
  end;

  TTextDatabaseSubtitlesContainer = class(TObject)
  private
    fSubtitlesList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TTextDatabaseSubtitleItem;
  protected
    function Add(const Code, Text: string): Integer;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadSubtitlesFile(const HashKey: string;
      XMLInputFile: TFileName): Boolean;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TTextDatabaseSubtitleItem read GetItem; default;
  end;
  
implementation

uses
  SysTools, XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Variants, TextDB;
  
{ TSubtitlesContainer }

function TTextDatabaseSubtitlesContainer.Add(const Code, Text: string): Integer;
var
  Item: TTextDatabaseSubtitleItem;

begin
  Item := TTextDatabaseSubtitleItem.Create(Self);
  Item.fCode := Code;
  Item.fText := Text;
  Result := fSubtitlesList.Add(Item);

  if Item.Code = '' then
    Item.fCode := IntToStr(Result);
end;

procedure TTextDatabaseSubtitlesContainer.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    TTextDatabaseSubtitleItem(fSubtitlesList[i]).Free;
  fSubtitlesList.Clear;
end;

constructor TTextDatabaseSubtitlesContainer.Create;
begin
  fSubtitlesList := TList.Create;
end;

destructor TTextDatabaseSubtitlesContainer.Destroy;
begin
  Clear;
  fSubtitlesList.Free;
  inherited;
end;

function TTextDatabaseSubtitlesContainer.GetCount: Integer;
begin
  Result := fSubtitlesList.Count;
end;

function TTextDatabaseSubtitlesContainer.GetItem(Index: Integer): TTextDatabaseSubtitleItem;
begin
  Result := TTextDatabaseSubtitleItem(fSubtitlesList[Index]);
end;

function TTextDatabaseSubtitlesContainer.LoadSubtitlesFile(
  const HashKey: string; XMLInputFile: TFileName): Boolean;
var
  XMLSubtitlesDatabase: IXMLDocument;
  FileNamesRootNode,
  FileEntryNode,
  SubtitlesNode,
  SubtitleEntryNode: IXMLNode;
  i: Integer;
  
begin
  Result := False;
  if not FileExists(XMLInputFile) then Exit;
  Clear;
  
  XMLSubtitlesDatabase := TXMLDocument.Create(nil);
  try

    try
      with XMLSubtitlesDatabase do begin
        LoadFromFile(XMLInputFile);
        Active := True;

        if DocumentElement.NodeName = 'TextCorrectorDatabase' then begin
          FileNamesRootNode := DocumentElement.ChildNodes.FindNode('FileNames');
          FileEntryNode := FileNamesRootNode.ChildNodes.FindNode(HashKey);
          SubtitlesNode := FileEntryNode.ChildNodes.FindNode('Subtitles');

          // Adding subtitles
          for i := 0 to SubtitlesNode.Attributes['Count'] - 1 do begin
            SubtitleEntryNode := SubtitlesNode.ChildNodes[i];
            with SubtitleEntryNode do
              Add(VariantToString(Attributes['Code']), VariantToString(NodeValue));
          end;
        end;
      end;

      Result := True;
    except
      Result := False;
    end;

  finally
    XMLSubtitlesDatabase.Active := False;
    XMLSubtitlesDatabase := nil;
  end;
end;

{ TSubtitleItem }

constructor TTextDatabaseSubtitleItem.Create;
begin
  fOwner := Owner;
end;

end.
