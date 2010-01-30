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
unit dbinlay;

interface

uses
  Windows, SysUtils, Classes, CharsLst;

type
  TSubtitlesContainer = class;

  TSubtitleItem = class(TObject)
  private
    fCode: string;
    fText: string;
    fOwner: TSubtitlesContainer;
    function GetText: string;
  public
    constructor Create(Owner: TSubtitlesContainer);
    property Code: string read fCode;
    property Text: string read GetText;
    property RawText: string read fText;
    property Owner: TSubtitlesContainer read fOwner;
  end;

  TSubtitlesContainer = class(TObject)
  private
    fSubtitlesList: TList;
    fCharsList: TSubsCharsList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TSubtitleItem;
  protected
    function Add(const Code, Text: string): Integer;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadNPCSubtitlesFile(ShortVoiceID, CharID: string;
      XMLInputFile: TFileName): Boolean;
    property CharsList: TSubsCharsList read fCharsList;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSubtitleItem read GetItem; default;
  end;
  
implementation

uses
  SysTools, XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, TextDB;
  
{ TSubtitlesContainer }

function TSubtitlesContainer.Add(const Code, Text: string): Integer;
var
  Item: TSubtitleItem;

begin
  Item := TSubtitleItem.Create(Self);
  Item.fCode := Code;
  Item.fText := Text;
  Result := fSubtitlesList.Add(Item);
end;

procedure TSubtitlesContainer.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    TSubtitleItem(fSubtitlesList[i]).Free;
  fSubtitlesList.Clear;
end;

constructor TSubtitlesContainer.Create;
begin
  fSubtitlesList := TList.Create;
  fCharsList := TSubsCharsList.Create;  
end;

destructor TSubtitlesContainer.Destroy;
begin
  Clear;
  fSubtitlesList.Free;
  fCharsList.Free;
  inherited;
end;

function TSubtitlesContainer.GetCount: Integer;
begin
  Result := fSubtitlesList.Count;
end;

function TSubtitlesContainer.GetItem(Index: Integer): TSubtitleItem;
begin
  Result := TSubtitleItem(fSubtitlesList[Index]);
end;

function TSubtitlesContainer.LoadNPCSubtitlesFile(ShortVoiceID, CharID: string;
  XMLInputFile: TFileName): Boolean;
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
      XMLSubtitlesDatabase.LoadFromFile(XMLInputFile);
      XMLSubtitlesDatabase.Active := True;

      if XMLSubtitlesDatabase.DocumentElement.NodeName = 'TextCorrectorDatabase' then begin
        FileNamesRootNode := XMLSubtitlesDatabase.DocumentElement.ChildNodes.FindNode('FileNames');
        FileEntryNode := FileNamesRootNode.ChildNodes.FindNode(ShortVoiceID + '_' + CharID);
        SubtitlesNode := FileEntryNode.ChildNodes.FindNode('Subtitles');

        // Adding subtitles
        for i := 0 to SubtitlesNode.Attributes['Count'] - 1 do begin
          SubtitleEntryNode := SubtitlesNode.ChildNodes[i];
          Add(SubtitleEntryNode.Attributes['Code'], SubtitleEntryNode.NodeValue);
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

constructor TSubtitleItem.Create;
begin
  fOwner := Owner;
end;

function TSubtitleItem.GetText: string;
begin
  Result := Owner.CharsList.DecodeSubtitle(RawText);
end;

end.
