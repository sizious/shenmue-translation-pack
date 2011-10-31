program dbgdchk;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  Classes,
  drivechk in 'drivechk.pas',
  drvutils in '..\..\..\Release Unlocker\src\engine\drvutils.pas';

type
  TObj = class
  public
    procedure DriveUnitTrackRead(S: TObject; R, T: Int64);
    procedure DriveUnitTrackReadEnd(S: TObject);
  end;

var
  srcFS, encFS, decFS: TFileStream;
  DriveUnit: TDriveUnitController;
  Obj: TObj;
  m: pbyte;

procedure TObj.DriveUnitTrackRead(S: TObject; R, T: Int64);
begin
  Write(R, '/', T, #13);
end;

procedure TObj.DriveUnitTrackReadEnd(S: TObject);
begin
  WriteLn('');
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
//    GetDiscInfo('F');
//    GetMediaHashKey('F');

    Obj := TObj.Create;
    srcFS := TFileStream.Create('OUT.BIN', fmCreate);
    encFS := TFileStream.Create('OUT2.BIN', fmCreate);
    DriveUnit := TDriveUnitController.Create;
    try
      if DriveUnit.Open('E') then begin
        WriteLn('SERIAL = ', DriveUnit.SerialNumber);
        DriveUnit.OnTrackRead := Obj.DriveUnitTrackRead;
        DriveUnit.OnTrackReadEnd := Obj.DriveUnitTrackReadEnd;

        DriveUnit.Tracks[1].Read(encFS);
        //m := VirtualAlloc ( nil, 4096, MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE );
        
        DriveUnit.Tracks[0].Read(srcFS);

        DriveUnit.Tracks[1].Read(encFS);

        //VirtualFree (m, 0, MEM_RELEASE);

        WriteLn(DriveUnit.Eject);
        WriteLn(DriveUnit.Inject);
        WriteLn(DriveUnit.Ready);
      end;
    finally
      DriveUnit.Free;
      srcFS.Free;
      Obj.Free;
      encFS.Free;
    end;

    WriteLn('END!');
    ReadLn;
  except
    on E:Exception do begin
      Writeln(E.Classname, ': ', E.Message);
      ReadLn;
    end;
  end;
end.
