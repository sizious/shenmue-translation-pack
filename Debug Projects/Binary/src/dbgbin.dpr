program dbgbin;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  binedit in '..\..\..\Shenmue Binary Translator\Editor\src\engine\binedit.pas',
  systools in '..\..\..\Common\systools.pas',
  filespec in '..\..\..\Common\filespec.pas';

var
  BinaryEditor: TBinaryScriptEditor;
  i, j, k: Integer;

begin
  ReportMemoryLeaksOnShutdown := True;
  BinaryEditor := TBinaryScriptEditor.Create;
  try
    try

      BinaryEditor.LoadFromFile('s2paldc.xml');

      for i := 0 to BinaryEditor.Sections.Count - 1 do begin
        WriteLn('Section Name: ', BinaryEditor.Sections[i].Name);

        for j := 0 to BinaryEditor.Sections[i].Table.Count - 1 do begin

          WriteLn('  ', BinaryEditor.Sections[i].Table[j].Text);

          for k := 0 to BinaryEditor.Sections[i].Table[j].Addresses.Count - 1 do begin

            WriteLn('    0x', IntToHex(BinaryEditor.Sections[i].Table[j].Addresses[k], 8));

          end;

        end;

      end;

      WriteLn('*** RESERVED STRINGS ***');
      
      for i := 0 to BinaryEditor.Constants.Count - 1 do begin

        WriteLn(BinaryEditor.Constants[i].Text);

        for j := 0 to BinaryEditor.Constants[i].Addresses.Count - 1 do
          WriteLn('   0x', IntToHex(BinaryEditor.Constants[i].Addresses[j], 8));

      end;

      WriteLn('*** POINTERS ***');

      for i := 0 to BinaryEditor.Pointers.Count - 1 do begin

        WriteLn(BinaryEditor.Pointers[i].Offset);

        for j := 0 to BinaryEditor.Pointers[i].Addresses.Count - 1 do
          WriteLn('   0x', IntToHex(BinaryEditor.Pointers[i].Addresses[j], 8));

      end;

      WriteLn('*** ALLOCATION TABLE ***');

      for i := 0 to BinaryEditor.Allocations.Count - 1 do
        WriteLn(' ', BinaryEditor.Allocations[i].Offset, ' ', BinaryEditor.Allocations[i].Size);

      BinaryEditor.SaveToFile('TEST.xml');

      ReadLn;
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;
  finally
    BinaryEditor.Free;
  end;
end.
