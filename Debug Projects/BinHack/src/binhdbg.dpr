program binhdbg;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  systools in '..\..\..\Common\systools.pas',
  hashidx in '..\..\..\Common\hashidx.pas',
  binhack in '..\..\..\Common\binhack.pas';

var
  BinaryHacker: TBinaryHacker;

procedure BinHack1;
begin
  BinaryHacker := TBinaryHacker.Create;
  try

    try

      with BinaryHacker.PlaceHolders do
      begin
        Add(640, 24);
        Add(672, 13);
        Add(693, 10);
        Add(711,  9);
        Add(152, 80);
      end;

      with BinaryHacker.Strings do
      begin
        Add( 32, 'SiZ #3');
        Add( 20, 'Another ultimate test #2 by SiZ!');
        Add(  4, 'This is the ultimate test #1');
        Add(320, '0123456789');
        Add(324, 'Erick Sermon');
        Add(328, 'This is EPMD, Motha Fucka!');
        Add(332, '9876543210');
        Add(336, 'Eminem_ABCD');
        Add(340, '_KAT_');
        Add(344, 'BLAH!');
        Add(348, 'WAREZ');
        Add(352, 'OK');
        Add(356, 'NO');
        Add(360, 'JaRulez');
      end;

      BinaryHacker.PlaceHolders.GrowMethod := gmDesigned;
      BinaryHacker.PlaceHolders.GrowOffset := 1024;

      BinaryHacker.MakeBackup := False;
      WriteLn('ExtraSize: ', BinaryHacker.Execute('BINHACK1.BIN'));

      BinaryHacker.PlaceHolders.DebugPrint;
      BinaryHacker.Strings.DebugPrint;
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;

  finally
    BinaryHacker.Free;
  end;
end;

procedure BinHackNBIK;
const
  SL = #$81#$9C#$90#$C2;
  BR = #$81#$95;

begin
  BinaryHacker := TBinaryHacker.Create;
  try

    try

      BinaryHacker.PlaceHolders.Add(9512, 600);

      with BinaryHacker.Strings do
      begin
        Add($03A8, SL + 'Like a dream I once saw,' + BR + 'it passes by as it touches my cheek.');
        Add($03C3, SL + 'This street leading to the ocean' + BR + 'carries the smell of sea.');
        Add($03D9, SL + 'Before love makes me tell a white lie.');
        Add($03EE, SL + 'This loneliness...' + BR + 'I want you to hold it in your arms now.');
        Add($0403, SL + 'If you will always be by my side,');
        Add($0418, SL + 'there''ll be no sorrow or tears in my eyes.');
        Add($042E, SL + 'Can''t live without you.' + BR + 'Why did you have to decide?');
        Add($0443, SL + 'You won''t be aware of my pains and lies.');
        Add($0458, SL + 'Don''t leave me alone, stay with me.');
        Add($046D, SL + 'I don''t know if you''ll ever look back.');
        Add($0482, SL + 'I''ll remember you forever.');
      end;

      BinaryHacker.MakeBackup := False;
      WriteLn('ExtraSize: ', BinaryHacker.Execute('NBIK03USA.SCN'));

      BinaryHacker.PlaceHolders.DebugPrint;
      BinaryHacker.Strings.DebugPrint;
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;

  finally
    BinaryHacker.Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;

  // BinHack1;
  BinHackNBIK;

  WriteLn('>>> END');
  ReadLn;
end.
