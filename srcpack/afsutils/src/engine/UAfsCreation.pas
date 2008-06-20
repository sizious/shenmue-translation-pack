unit UAfsCreation;

interface

uses
  Windows, ActiveX, Classes, Forms, Math, SysUtils, UIntList, progress;

type
  TAfsCreation = class(TThread)
  private
    { Déclarations privées }
    strBuf: String;
    FProgressWindow: TfrmProgress;
    procedure CopyDataToFile(var F_in: File; var F_out: File; FileSize:Integer);
    procedure WriteHeader(var F_out: File);
    procedure WriteEndList(var F_out: File);
    procedure WritePadding(var F_out: File; PaddingSize: Integer);
    function FindOffsetValue(FileOffset, FileSize: Integer): Integer;
    procedure GetFileDate(FileName: TFileName);
    procedure UpdatePercentage;
    procedure UpdateCurrentFile;
    procedure UpdateDefaultFormValue;
    procedure SyncPercentage;
    procedure SyncCurrentFile(const FileName: TFileName);
    procedure SyncDefaultFormValue;
    procedure CancelButtonClick(Sender: TObject);
    procedure CloseThread(Sender: TObject);
  protected
    procedure Execute; override;
  public
    ThreadTerminated: Boolean;
    constructor Create;
  end;

var
  _SizeOf_Integer: Integer;
  _SizeOf_Word: Word;
  fDates: TStringList;
  fSizes: TIntList;

implementation
uses afscreate, charsutil;

{ Important : les méthodes et propriétés des objets de la VCL peuvent uniquement
  être utilisés dans une méthode appelée en utilisant Synchronize, comme :

      Synchronize(UpdateCaption);

  où UpdateCaption serait de la forme 

    procedure TAfsCreation.UpdateCaption;
    begin
      Form1.Caption := 'Mis à jour dans un thread';
    end; }

{ TAfsCreation }

constructor TAfsCreation.Create;
begin
  FreeOnTerminate := True;
  inherited Create(False);

  ThreadTerminated := False;

  //Misc vars
  _SizeOf_Integer := SizeOf(Integer);
  _SizeOf_Word := SizeOf(Word);
  fDates := TStringList.Create;
  fSizes := TIntList.Create;

  FProgressWindow := TfrmProgress.Create(nil);
  OnTerminate := CloseThread;
end;

procedure TAfsCreation.Execute;
var
  F_src, F_afs: File;
  i, j, intBuf: Integer;
  minNextOffset, fOffset: Integer;
begin
  //Assigning output
  AssignFile(F_afs, createMainList.OutputFile);
  FileMode := fmOpenWrite;
  ReWrite(F_afs, 1);

  SyncDefaultFormValue;

  WriteHeader(F_afs); //AFS Header
  WritePadding(F_afs, 8*createMainList.GetCount); //Offset & Size list will be there
  fOffset := FileSize(F_afs);

  //Offset 512 (0x8000) Padding, if activated
  if fPadding then begin
    intBuf := (512*1024)-FileSize(F_afs);
    WritePadding(F_afs, intBuf);
  end
  else begin
    //Padding before first file
    if fEndList then begin
      j := 8;
    end
    else begin
      j := 0;
    end;
    {minNextOffset := fOffset + j;}
    intBuf := FindOffsetValue(8, (createMainList.GetCount*8)+j);
    WritePadding(F_afs, intBuf-fOffset);
  end;

  //Writing file data
  for i := 0 to createMainList.GetCount - 1 do begin
    if not Terminated then begin
      fOffset := FileSize(F_afs);

      //Opening file for reading
      AssignFile(F_src, createMainList.GetFileName(i));
      FileMode := fmOpenRead;
      {$I-}Reset(F_src, 1);{$I+}

      fSizes.Add(FileSize(F_src));
      SyncCurrentFile(ExtractFileName(createMainList.GetFileName(i)));

      //Writing offset & size in the list
      intBuf := FileSize(F_src);
      Seek(F_afs, 8+(8*i));
      BlockWrite(F_afs, fOffset, _SizeOf_Integer);
      BlockWrite(F_afs, intBuf, _SizeOf_Integer);

      //Writing data to AFS
      Seek(F_afs, FileSize(F_afs));
      CopyDataToFile(F_src, F_afs, intBuf);

      //Finding offset for the next file & writing padding
      minNextOffset := fOffset + FileSize(F_src);
      intBuf := FindOffsetValue(fOffset, FileSize(F_src));
      WritePadding(F_afs, intBuf - minNextOffset);

      CloseFile(F_src);
      SyncPercentage;

      //Getting file date & time
      if fEndList then begin
        GetFileDate(createMainList.GetFileName(i));
      end;
    end
    else
    begin
      Break;
    end;
  end;

  //Writing files list at the end
  if fEndList then begin
    WriteEndList(F_afs);
  end;

  //Creation finished!
  CloseFile(F_afs);
end;

procedure TAfsCreation.CopyDataToFile(var F_in: File; var F_out: File; FileSize:Integer);
const
  WORK_BUFFER_SIZE = 16384;
var
  Buf: array[0..WORK_BUFFER_SIZE-1] of Byte;
  i, j, BufSize: Integer;
  _Last_BufSize_Entry: Integer;
begin
  Seek(F_in, 0); //Seeking to the beginning

  //Calculating...
  BufSize := SizeOf(Buf);
  _Last_BufSize_Entry := FileSize mod BufSize;
  j := FileSize div BufSize;

  //Copying data
  for i := 0 to j - 1 do begin
    BlockRead(F_in, Buf, SizeOf(Buf), BufSize);
    BlockWrite(F_out, Buf, BufSize);
  end;
  BlockRead(F_in, Buf, _Last_BufSize_Entry, BufSize);
  BlockWrite(F_out, Buf, BufSize);
end;

procedure TAfsCreation.WriteHeader(var F_out: File);
var
  strBuf: String;
  intBuf: Integer;
  Buf: Byte;
begin
  //AFS Signature
  strBuf := 'AFS';
  BlockWrite(F_out, Pointer(strBuf)^, Length(strBuf));

  //Zero
  Buf := 0;
  BlockWrite(F_out, Buf, SizeOf(Buf));

  //Total file count
  intBuf := createMainList.GetCount;
  BlockWrite(F_out, intBuf, _SizeOf_Integer);
end;

procedure TAfsCreation.WriteEndList(var F_out: File);
var
  wordBuf: array[0..5] of Word;
  i, j, fOffset, intBuf: Integer;
  strBuf: String;
begin
  fOffset := FileSize(F_out);

  //Finding first file offset and seeking to it
  Seek(F_out, 8);
  BlockRead(F_out, intBuf, _SizeOf_Integer);
  Seek(F_out, intBuf-8);

  //Writing end list offset & size
  intBuf := FileSize(F_out);
  BlockWrite(F_out, intBuf, _SizeOf_Integer);
  intBuf := 48 * createMainList.GetCount;
  BlockWrite(F_out, intBuf, _SizeOf_Integer);

  //Seeking to file end and writing list
  Seek(F_out, FileSize(F_out));
  for i := 0 to createMainList.GetCount - 1 do begin
    //File name & padding
    strBuf := ExtractFileName(createMainList.GetFileName(i));
    intBuf := 32 - Length(strBuf);
    BlockWrite(F_out, Pointer(strBuf)^, Length(strBuf));
    WritePadding(F_out, intBuf);

    //File date and time
    for j := 0 to Length(wordBuf)-1 do begin
      strBuf := ParseSection(' ', fDates[i], j);
      wordBuf[j] := StrToInt(strBuf);
      BlockWrite(F_out, wordBuf[j], _SizeOf_Word);
    end;

    //File size
    intBuf := fSizes[i];
    BlockWrite(F_out, intBuf, _SizeOf_Integer);
  end;

  //Padding
  j := fOffset + (48*createMainList.GetCount);
  intBuf := FindOffsetValue(fOffset, (48*createMainList.GetCount));
  WritePadding(F_out, intBuf-j);
end;

procedure TAfsCreation.WritePadding(var F_out: File; PaddingSize: Integer);
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

function TAfsCreation.FindOffsetValue(FileOffset, FileSize: Integer): Integer;
var
  multiplier, minNextOffset, finalValue: Integer;
begin
  multiplier := Round(FileOffset/blockSize)+1;
  minNextOffset := FileOffset + FileSize;
  finalValue := blockSize * multiplier;
  while finalValue < minNextOffset do begin
    Inc(multiplier);
    finalValue := blockSize * multiplier;
  end;
  Result := finalValue;
end;

procedure TAfsCreation.GetFileDate(FileName: TFileName);
var
  strBuf: String;
  fHandle, FAge: Integer;
  FDate: TDateTime;
begin
    fHandle := FileOpen(FileName, fmOpenRead);
    FAge := FileGetDate(fHandle);
    FDate := FileDateToDateTime(FAge);
    DateTimeToString(strBuf, 'yyyy m d h n s', FDate);
    fDates.Add(strBuf);
    FileClose(fHandle);
end;

procedure TAfsCreation.UpdatePercentage;
var
  i: Integer;
  floatBuf: Real;
begin
  i := FProgressWindow.ProgressBar1.Position;
  FProgressWindow.ProgressBar1.Position := i+1;
  floatBuf := SimpleRoundTo((100*(i+1))/createMainList.GetCount, -2);
  FProgressWindow.Panel1.Caption := FloatToStr(floatBuf)+'%';
  Application.ProcessMessages;
end;

procedure TAfsCreation.UpdateCurrentFile;
begin
  FProgressWindow.lblCurrentTask.Caption := 'Current file: '+strBuf;
end;

procedure TAfsCreation.UpdateDefaultFormValue;
var
  outFileName: String;
begin
  outFileName := ExtractFileName(createMainList.OutputFile);
  FProgressWindow.Caption := 'Creation in progress... '+ExtractFileName(outFileName);
  FProgressWindow.lblCurrentTask.Caption := 'Current file:';
  FProgressWindow.Position := poScreenCenter;
  FProgressWindow.ProgressBar1.Max := createMainList.GetCount;
  FProgressWindow.btCancel.OnClick := Self.CancelButtonClick;
  FProgressWindow.Panel1.Caption := '0%';
  FProgressWindow.Show;
end;

procedure TAfsCreation.SyncPercentage;
begin
  Synchronize(UpdatePercentage);
end;

procedure TAfsCreation.SyncCurrentFile(const FileName: TFileName);
begin
  strBuf := FileName;
  Synchronize(UpdateCurrentFile);
end;

procedure TAfsCreation.SyncDefaultFormValue;
begin
  Synchronize(UpdateDefaultFormValue);
end;

procedure TAfsCreation.CancelButtonClick(Sender: TObject);
begin
  Terminate;
end;

procedure TAfsCreation.CloseThread(Sender: TObject);
begin
  if Assigned(FProgressWindow) then begin
    FProgressWindow.Release;
  end;
  fDates.Free;
  fSizes.Free;
  ThreadTerminated := True;
end;

end.
