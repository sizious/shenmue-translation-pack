//    This file is part of SPR Utils.
//
//    You should have received a copy of the GNU General Public License
//    along with SPR Utils.  If not, see <http://www.gnu.org/licenses/>.

unit USprCreation;

interface

uses
  Windows, Classes, SysUtils, Math, Forms, ShellApi, progress, USprStruct;

type
  TSprCreation = class(TThread)
  private
    { Déclarations privées }
    fOutName: TFileName;
    FileListMain: TStringList;
    SPRStructMain: TSprStruct;
    RewritePvrGBIX: Boolean;
    WriteGzip: Boolean;
    fTempName: TFileName;
    FProgressWindow: TfrmProgress;
    procedure CopyDataToFile(const Offset, Size: Integer; var F_src: File; var F_out: File);
    procedure WritePadding(var F_out: File; PaddingSize: Integer);
    function NullBytesLength(const FileCount: Integer): Integer;
    function TruncateStr(const Str: String; const StrLength: Integer): String;
    procedure WriteGzipOutput(const FileName: TFileName);
    function ExecuteFile(const ExeName: TFileName; const Parameters: String): Boolean;
    procedure UpdatePercentage;
    procedure UpdateCurrentFile;
    procedure UpdateDefaultFormValue;
    procedure SyncPercentage;
    procedure SyncCurrentFile(const FileName: TFileName);
    procedure SyncDefaultFormValue;
    procedure CancelBntClick(Sender: TObject);
    procedure CloseThread(Sender: TObject);
  protected
    procedure Execute; override;
  public
    ThreadTerminated: Boolean;
    constructor Create(const OutFileName: TFileName; var FileList: TStringList;
                      var SPRStruct: TSprStruct; const RewriteGBIX: Boolean;
                      const GzipOutput: Boolean);
  end;

const
  _SizeOf_Integer = SizeOf(Integer);
  _SizeOf_Word = SizeOf(Word);

implementation
{ TSprCreation }

constructor TSprCreation.Create(const OutFileName: TFileName; var FileList: TStringList; var SPRStruct: TSprStruct; const RewriteGBIX: Boolean; const GzipOutput: Boolean);
begin
  FreeOnTerminate := True;
  inherited Create(False);

  fOutName := OutFileName;
  FileListMain := FileList;
  SPRStructMain := SPRStruct;
  RewritePvrGBIX := RewriteGBIX;
  WriteGzip := GzipOutput;
  FProgressWindow := TfrmProgress.Create(nil);
  OnTerminate := CloseThread;
end;

procedure TSprCreation.Execute;
var
  F_spr, F_src: File;
  CurrentEntry: TSprEntry;
  i, j, intBuf: Integer;
  strBuf: String;
  newGBIX: Boolean;
begin
  //Assigning output
  AssignFile(F_spr, fOutName);
  FileMode := fmOpenWrite;
  ReWrite(F_spr, 1);

  SyncDefaultFormValue;

  for i := 0 to SPRStructMain.Count - 1 do begin
    if Terminated then begin
      Break;
    end;

    CurrentEntry := SPRStructMain.Items[i];
    SyncCurrentFile(ExtractFileName(FileListMain[i]));

    //Opening image file
    AssignFile(F_src, FileListMain[i]);
    FileMode := fmOpenRead;
    {$I-}Reset(F_src, 1);{$I+}
    if IOResult <> 0 then Terminate;


    //Writing header
    j := FilePos(F_spr); //Keeping header offset, can be useful
    strBuf := 'TEXN';
    BlockWrite(F_spr, Pointer(strBuf)^, Length(strBuf));
    WritePadding(F_spr, 4); //Placeholder for total section size...
    strBuf := TruncateStr(CurrentEntry.TextureName, 8);
    BlockWrite(F_spr, Pointer(strBuf)^, Length(strBuf));
    WritePadding(F_spr, 8-Length(strBuf));

    //Writing GBIX
    newGBIX := True;
    if (CurrentEntry.Format = 'PVR') then begin
      if (CurrentEntry.Offset > 0) and (not RewritePvrGBIX) then begin
        CopyDataToFile(0, CurrentEntry.Offset, F_src, F_spr);
        newGBIX := False;
      end;
    end;
    if newGBIX then begin
      strBuf := 'GBIX';
      BlockWrite(F_spr, Pointer(strBuf)^, Length(strBuf));
      intBuf := 4;
      BlockWrite(F_spr, intBuf, _SizeOf_Integer);
      WritePadding(F_spr, 4);
    end;

    //Writing section total size
    if CurrentEntry.Format = 'DDS' then begin
      intBuf := CurrentEntry.Size + (FilePos(F_spr)-j) + 16;
    end
    else if CurrentEntry.Format = 'PVR' then begin
      intBuf := CurrentEntry.Size + (FilePos(F_spr)-j);
    end;
    Seek(F_spr, j+4);
    BlockWrite(F_spr, intBuf, _SizeOf_Integer);
    Seek(F_spr, FileSize(F_spr));

    //Writing PVRT
    strBuf := 'PVRT';
    BlockWrite(F_spr, Pointer(strBuf)^, Length(strBuf));
    if CurrentEntry.Format = 'DDS' then begin
      j := intBuf - 164;
    end
    else if CurrentEntry.Format = 'PVR' then begin
      j := intBuf - 36;
    end;
    BlockWrite(F_spr, j, _SizeOf_Integer);
    BlockWrite(F_spr, CurrentEntry.FormatCode, _SizeOf_Integer);
    BlockWrite(F_spr, CurrentEntry.Width, _SizeOf_Word);
    BlockWrite(F_spr, CurrentEntry.Height, _SizeOf_Word);

    //Copying image file to SPR
    if CurrentEntry.Format = 'PVR' then begin
      CopyDataToFile(CurrentEntry.Offset+16, CurrentEntry.Size-16, F_src, F_spr);
    end
    else begin
      CopyDataToFile(CurrentEntry.Offset, CurrentEntry.Size, F_src, F_spr);
    end;

    CloseFile(F_src);
    SyncPercentage;
  end;

  //End file padding
  if SPRStructMain.Items[0].Format = 'DDS' then begin
    intBuf := NullBytesLength(SPRStructMain.Count);
  end
  else if SPRStructMain.Items[0].Format = 'PVR' then begin
    intBuf := 4;
  end;
  WritePadding(F_spr, intBuf);

  //Closing file
  CloseFile(F_spr);

  //Gzip output, if option activated
  if WriteGzip then begin
    WriteGzipOutput(fOutName);
  end;
end;

procedure TSprCreation.CopyDataToFile(const Offset, Size: Integer; var F_src: File; var F_out: File);
const
  WORK_BUFFER_SIZE = 16384;
var
  Buf: array[0..WORK_BUFFER_SIZE-1] of Byte;
  i, j, BufSize: Integer;
  _Last_BufSize_Entry: Integer;
begin
  //Seeking to file data
  Seek(F_src, Offset);

  //Calculating...
  BufSize := SizeOf(Buf);
  _Last_BufSize_Entry := Size mod BufSize;
  j := Size div BufSize;

  //Copying data
  for i := 0 to j - 1 do
  begin
    BlockRead(F_src, Buf, SizeOf(Buf), BufSize);
    BlockWrite(F_out, Buf, BufSize);
  end;
  BlockRead(F_src, Buf, _Last_BufSize_Entry, BufSize);
  BlockWrite(F_out, Buf, BufSize);
end;

procedure TSprCreation.WritePadding(var F_out: File; PaddingSize: Integer);
const
  WORK_BUFFER_SIZE = 16384;
var
  Buf: array[0..WORK_BUFFER_SIZE-1] of Byte;
  i, j, BufSize: Integer;
  _Last_BufSize_Entry: Integer;
begin

  ZeroMemory(@Buf, Length(Buf));
  BufSize := SizeOf(Buf);
  _Last_BufSize_Entry := PaddingSize mod BufSize;
  j := PaddingSize div BufSize;
  for i := 0 to j - 1 do begin
    BlockWrite(F_out, Buf, SizeOf(Buf), BufSize);
  end;
  BlockWrite(F_out, Buf, _Last_BufSize_Entry);
end;

function TSprCreation.NullBytesLength(const FileCount: Integer): Integer;
var
  currNum, totalByte: Integer;
begin
  currNum := 1;
  totalByte := 4;

  while currNum <> FileCount do begin
    case totalByte of
      16 : totalByte := 4;
      else Inc(totalByte, 4);
    end;
    Inc(currNum);
  end;

  Result := totalByte;
end;

function TSprCreation.TruncateStr(const Str: string; const StrLength: Integer): String;
var
  strBuf: String;
begin
  if Length(Str) <= StrLength then begin
    Result := Str;
  end
  else begin
    strBuf := Str;
    Delete(strBuf, StrLength+1, Length(strBuf)-StrLength);
    Result := strBuf;
  end;
end;

procedure TSprCreation.WriteGzipOutput(const FileName: TFileName);
var
  fOutGzip: TFileName;
  exeFile, paramExe: String;
begin
  //Changing file extension
  fOutGzip := ChangeFileExt(FileName, '.GZ');

  exeFile := ExtractFilePath(Application.ExeName)+'gzip.exe';
  paramExe := '"'+FileName+'"';

  if ExecuteFile(exeFile, paramExe) then begin
    RenameFile(FileName+'.GZ', fOutGzip);
  end;
end;

function TSprCreation.ExecuteFile(const ExeName: TFileName; const Parameters: string): Boolean;
var
  seInfo: TShellExecuteInfo;
  exitCode: DWord;
begin
  //Preparing the ShellExecute
  FillChar(seInfo, SizeOf(seInfo), 0);
  seInfo.cbSize := SizeOf(TShellExecuteInfo);
  with seInfo do begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpFile := PChar(ExeName);
    lpParameters := PChar(Parameters);
    nShow := SW_HIDE;
  end;

  //Executing command
  if ShellExecuteEx(@seInfo) then begin
    repeat
      Application.ProcessMessages;
      GetExitCodeProcess(seInfo.hProcess, exitCode);
    until (exitCode <> STILL_ACTIVE) or Application.Terminated;
    Result := True;
  end
  else begin
    Result := False;
  end;
end;

procedure TSprCreation.UpdatePercentage;
var
  i: Integer;
  floatBuf: Real;
begin
  with FProgressWindow do begin
    i := ProgressBar1.Position;
    ProgressBar1.Position := i + 1;
    floatBuf := SimpleRoundTo((100*(i+1))/ProgressBar1.Max, -2);
    Panel1.Caption := FloatToStr(floatBuf)+'%';
    Application.ProcessMessages;
  end;
end;

procedure TSprCreation.UpdateCurrentFile;
begin
  FProgressWindow.lblCurrentTask.Caption := 'Current file: ' + fTempName;
end;

procedure TSprCreation.UpdateDefaultFormValue;
var
  srcFileName: TFileName;
begin
  with FProgressWindow do begin
    srcFileName := fOutName;
    Position := poMainFormCenter;
    Caption := 'Extraction in progress... ' + ExtractFileName(srcFileName);
    ProgressBar1.Max := SPRStructMain.Count;
    Panel1.Caption := '0%';
    btCancel.OnClick := CancelBntClick;
    Show;
  end;
end;

procedure TSprCreation.SyncPercentage;
begin
  Synchronize(UpdatePercentage);
end;

procedure TSprCreation.SyncCurrentFile(const FileName: TFileName);
begin
  fTempName := FileName;
  Synchronize(UpdateCurrentFile);
end;

procedure TSprCreation.SyncDefaultFormValue;
begin
  Synchronize(UpdateDefaultFormValue);
end;

procedure TSprCreation.CancelBntClick(Sender: TObject);
begin
  Terminate;
end;

procedure TSprCreation.CloseThread(Sender: TObject);
begin
  if Assigned(FProgressWindow) then begin
    FProgressWindow.Release;
  end;
  ThreadTerminated := True;
end;

end.
