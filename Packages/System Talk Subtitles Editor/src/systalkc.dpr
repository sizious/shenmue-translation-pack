program SysTalkC;

{$APPTYPE CONSOLE}

{$R 'systalkc.res' 'systalkc.rc'}

uses
  SysUtils,
  scnfedit in 'engine\scnfedit.pas',
  systools in '..\..\..\Common\systools.pas',
  appver in '..\..\..\Common\appver.pas';

procedure PrintUsage;
var
  AppExe: TFileName;

begin
  AppExe := ChangeFileExt(ExtractFileName(ParamStr(0)), '');
  WriteLn(
    'Usage: ', sLineBreak,
    '  ', AppExe, ' <command[=section_id]> <systalk.bin> [target.xml]', sLineBreak,
    sLineBreak,
    'Commands:', sLineBreak,
    '  l: List all SCNF sections from <systalk.bin>', sLineBreak,
    '  e: Export from [section_id] of <systalk.bin> to [target.xml]', sLineBreak,
    '  i: Import to [section_id] of <systalk.bin> from [target.xml]', sLineBreak,
    '  x: Export all SCNF sections from <systalk.bin> to <autofiles.xml>', sLineBreak,
    '  p: Import all SCNF sections from <autofiles.xml> to <systalk.bin>', sLineBreak,
    sLineBreak,
    'Example: ', sLineBreak,
    '  ', AppExe, ' e=3 systalk.bin', sLineBreak,
    '    Export the content of the third section of systalk.bin to ****.xml where', sLineBreak,
    '    ****.xml file name is calculated from the section name.'
  );
end;

var
  CommandSwitch: Char;
  SCNFEditor: TSCNFEditor;
  InputFile, OutputFile, Path: TFileName;
  i, SectionID: Integer;

begin
  try
    WriteLn(
      'Shenmue System Talk Subtitles Editor - v', GetApplicationVersion, ' - Console Version', sLineBreak,
      'Written by [big_fury]SiZiOUS from the SHENTRAD Team', sLineBreak
    );

    if ParamCount > 1 then begin
      CommandSwitch := UpCase(ParamStr(1)[1]);
      InputFile := ExpandFileName(ParamStr(2));
      Path := IncludeTrailingPathDelimiter(ExtractFilePath(InputFile));
      
      if ParamCount > 2 then
        OutputFile := ParamStr(3)
      else
        OutputFile := '';

      SCNFEditor := TSCNFEditor.Create;
      try
        SCNFEditor.LoadFromFile(InputFile);

        case CommandSwitch of

          // List sections
          'L':
            begin
              WriteLn('Content of ', ExtractFileName(InputFile), ':');
              for i := 0 to SCNFEditor.Sections.Count - 1 do begin
                WriteLn('  #', i, ': ', SCNFEditor.Sections[i].CharID, ' (',
                  SCNFEditor.Sections[i].Subtitles.Count, ' subtitles)');
              end;
            end;

          // Extract the section id specified
          'E':
            begin
              SectionID := StrToInt(ParamStr(1)[3]);
              if OutputFile = '' then
                OutputFile := Path + IntToStr(SectionID) + '_' + SCNFEditor.Sections[SectionID].CharID + '.xml';
              Write('Exporting SCNF section #', SectionID, ' to ', OutputFile, '...');
              SCNFEditor.Sections[SectionID].Subtitles.ExportToFile(OutputFile);
              WriteLn('Done !');
            end;

          // Import the section id specified
          'I':
            begin
              SectionID := StrToInt(ParamStr(1)[3]);
              if OutputFile = '' then
                OutputFile := Path + IntToStr(SectionID) + '_' + SCNFEditor.Sections[SectionID].CharID + '.xml';
              if FileExists(OutputFile) then begin
                Write('Importing SCNF section #', SectionID, ' from ', OutputFile, '...');
                SCNFEditor.Sections[SectionID].Subtitles.ImportFromFile(OutputFile);
                SCNFEditor.Save;
                WriteLn('Done !');
              end else
                WriteLn('File not found: "', OutputFile, '"');
            end;

            // Export all sections
            'X':
              begin
                WriteLn('Exporting all SCNF sections...');
                for i := 0 to SCNFEditor.Sections.Count - 1 do begin
                  Write('  #', i, ': ', SCNFEditor.Sections[i].CharID, '...');
                  OutputFile := Path + IntToStr(i) + '_' + SCNFEditor.Sections[i].CharID + '.xml';
                  SCNFEditor.Sections[i].Subtitles.ExportToFile(OutputFile);
                  WriteLn('OK !');
                end;
                WriteLn('Done !');
              end;

            // Import all sections
            'P':
              begin
                WriteLn('Importing all SCNF sections...');
                for i := 0 to SCNFEditor.Sections.Count - 1 do begin
                  Write('  #', i, ': ', SCNFEditor.Sections[i].CharID, '...');
                  OutputFile := Path + IntToStr(i) + '_' + SCNFEditor.Sections[i].CharID + '.xml';
                  if FileExists(OutputFile) then begin
                    SCNFEditor.Sections[i].Subtitles.ImportFromFile(OutputFile);
                    WriteLn('OK !');
                  end else
                    WriteLn('FAILED !');
                end;
                SCNFEditor.Save;
                WriteLn('Done !');
              end;
        end;

      finally
        SCNFEditor.Free;
      end;

    end else
      PrintUsage;

{$IFDEF DEBUG}
    ReadLn;
{$ENDIF}
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
