program MakeDB;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  XMLDom,
  XMLIntf,
  MSXMLDom,
  XMLDoc,
  ActiveX;

//==============================================================================

const
  SRF_SCRIPT_DB = 'srfscript.xml';
  MAX_DIRECTORIES_COUNT = 25;
  FILE_EXTENSION = 'bin';
  
//==============================================================================

var
  XMLDoc: IXMLDocument;
  SR_SRF, SR_STR: TSearchRec;
  VoiceID, SubtitleID, ReadVoiceID: string;
  AudioFilter, InputDirectory: TFileName;
  DiscNumber, DirNumber: Integer;

//------------------------------------------------------------------------------

procedure InitDB;
begin
  CoInitialize(nil);
  
  with XMLDoc do begin
    Options := [doNodeAutoCreate, doAttrNull];
    ParseOptions:= [];
    Active := True;
    Version := '1.0';
    Encoding := 'utf-8';
  end;

  // Loading the DBIOutputFile
  if not FileExists(SRF_SCRIPT_DB) then begin
    // Creating the root
    XMLDoc.DocumentElement := XMLDoc.CreateNode('CinematicsScriptDatabase');

  end else begin
    XMLDoc.LoadFromFile(SRF_SCRIPT_DB);

(*    ContainerDiscsRootNode := DBI_XMLDoc.DocumentElement.ChildNodes.FindNode('Entries');
    if not Assigned(ContainerDiscsRootNode) then
      ContainerDiscsRootNode := DBI_XMLDoc.DocumentElement.AddChild('Entries'); *)
  end;
end;

//------------------------------------------------------------------------------

procedure AddEntry(const VoiceID, SubtitleID: string);
var
  RootNode, Node: IXMLNode;
  i: Integer;
  
begin
  try
    // VoiceID node
    RootNode := XMLDoc.DocumentElement.ChildNodes.FindNode(VoiceID);
    if not Assigned(RootNode) then
      RootNode := XMLDoc.DocumentElement.AddChild(VoiceID);

    // SubtitleID node
    Node := RootNode.ChildNodes.FindNode(SubtitleID);
    if not Assigned(Node) then begin
      Node := RootNode.AddChild(SubtitleID);
      for i := 1 to 3 do
        Node.Attributes['d' + IntToStr(i)] := False;
    end;

    Node.Attributes['d' + IntToStr(DiscNumber)] := True;

  except
    on E:Exception do
      WriteLn('AddEntryToDatabase: Exception - ', E.Message);
  end;
end;

//------------------------------------------------------------------------------

begin
  InputDirectory := IncludeTrailingPathDelimiter(ParamStr(1));

  if ParamCount < 2 then begin
    WriteLn('usage: makedb <input_dir> <disc_number>');
    Exit;
  end;

  if not DirectoryExists(InputDirectory) then begin
    WriteLn('input dir not exists "' + InputDirectory, '"');
    Exit;
  end;

  DiscNumber := StrToIntDef(ParamStr(2), -1);
  if (DiscNumber < 1) and (DiscNumber > 3) then begin
    WriteLn('disc must be 1 to 3');
    Exit;
  end;

  // Start!
  XMLDoc := TXMLDocument.Create(nil);
  try
    try
      InitDB;
      
      // Searching the selected directory
      if FindFirst(InputDirectory + '*.SRF', faAnyFile, SR_SRF) = 0 then begin
        repeat
          VoiceID := ChangeFileExt(SR_SRF.Name, '');
          WriteLn('VoiceID: ', VoiceID);
          
          // Searching each STR files for this SRF
          for DirNumber := 1 to MAX_DIRECTORIES_COUNT do begin
            AudioFilter := InputDirectory + 'DIR' + IntToStr(DirNumber) + '\'
              + VoiceID + '????.' + FILE_EXTENSION;
            if FindFirst(AudioFilter, faAnyFile, SR_STR) = 0 then begin
              repeat
                // VERIFICATION DE BUG DU WINDOWS!!! (PUREE!!)
                ReadVoiceID := Copy(SR_STR.Name, 1, Length(VoiceID));
                if ReadVoiceID <> VoiceID then begin
                  WriteLn('BUG: ', ReadVoiceID, ' ', VoiceID);
                  ReadLn;
                end;

                SubtitleID := ChangeFileExt(SR_STR.Name, '');
                SubtitleID := Copy( SubtitleID,
                                    Length(VoiceID) + 1,
                                    Length(SR_STR.Name) - Length(SubtitleID)
                                  );
                WriteLn(SubtitleID);

                // Add the entry
                AddEntry(VoiceID, SubtitleID);

              until FindNext(SR_STR) <> 0;
              FindClose(SR_STR);
            end;
          end;

        until FindNext(SR_SRF) <> 0;
        FindClose(SR_SRF);
      end;

      XMLDoc.SaveToFile(SRF_SCRIPT_DB);
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;

  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end.
