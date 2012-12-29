program binhdbg;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  systools in '..\..\..\Common\systools.pas',
  hashidx in '..\..\..\Common\hashidx.pas',
  binhack in '..\..\..\Common\binhack.pas';

var
  BinaryHacker: TBinaryHacker;

begin
  ReportMemoryLeaksOnShutdown := True;
  
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

  WriteLn('>>> END');
  ReadLn;
end.
