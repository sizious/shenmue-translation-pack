program dbgcrypt;

{$APPTYPE CONSOLE}


uses
  SysUtils,
  Classes,
  libcamellia in '..\..\..\Common\Crypto\libcamellia\libcamellia.pas',
  cam_base in '..\..\..\Common\Crypto\libcamellia\src\cam_base.pas',
  libpc1 in '..\..\..\Common\Crypto\libpc1\libpc1.pas';

const
  PC1_PASSWORD = 'rage_against_the_machine';
  CAM_PASSWORD = 'nirvana_come_as_you_are';
var
  encFS, decFS: TFileStream;
  Memory: TMemoryStream;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    decFS := TFileStream.Create('input.txt', fmOpenRead);
    encFS := TFileStream.Create('outcrypt.bin', fmCreate);
    Memory := TMemoryStream.Create;
    try
      // Encrypt PC1
//      PC1Encrypt(pmAdvanced, PC1_PASSWORD, decFS, Memory);
//      Memory.SaveToFile('outenc.pc1');

      // Encrypt Camellia
      CamelliaEncrypt(CAM_PASSWORD, decFS, encFS);
    finally
      decFS.Free;
      encFS.Free;
      Memory.Free;
    end;

    encFS := TFileStream.Create('outcrypt.bin', fmOpenRead);
    decFS := TFileStream.Create('output.txt', fmCreate);
    Memory := TMemoryStream.Create;
    try
      // Decrypt Camellia
      CamelliaDecrypt(CAM_PASSWORD, encFS, decFS);
//      Memory.SaveToFile('outdec.cam');

      // Decrypt PC1
//      PC1Decrypt(pmAdvanced, PC1_PASSWORD, Memory, decFS);
    finally
      encFS.Free;
      decFS.Free;
      Memory.Free;
    end;

  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
