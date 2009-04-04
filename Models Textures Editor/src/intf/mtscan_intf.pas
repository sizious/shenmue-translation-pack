unit mtscan_intf;

interface

uses
  Windows, SysUtils, Classes, Forms;

procedure ScanDirectory(const Directory: TFileName);

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  Main, MTScan, Progress;

type
  // This class is here to respect the MVC model...
  // Check the procedure ScanDirectory to understand...
  TMTScanDirectoryThreadListener = class(TObject)
  private
    fMTScanDirectoryThread: TMTScanDirectoryThread; // Working Thread
  public
    constructor Create(const Directory: TFileName);
    destructor Destroy; override;

    // Procedures
    procedure Start; // starting the thread + updating the progress form...

    // Implementing events to update the progress form
    procedure OnInitGettingFilesList(Sender: TObject);
    procedure OnStart(Sender: TObject; FilesCount: Integer);
    procedure OnFileFound(Sender: TObject; FileName: TFileName);
    procedure OnFileScanned(Sender: TObject; FileName: TFileName; FileValid: Boolean);
    procedure OnTerminate(Sender: TObject);
  end;

//------------------------------------------------------------------------------

procedure ScanDirectory(const Directory: TFileName);
var
  MTScanListener: TMTScanDirectoryThreadListener;
  
begin
  // We create a 'listener' (check the class in the beginning of this file)
  MTScanListener := TMTScanDirectoryThreadListener.Create(Directory);
  try
    MTScanListener.Start; // we start the thread + progress form
  finally
    MTScanListener.Free; // releasing form and returning to main form
  end;
end;

//------------------------------------------------------------------------------
{ TMTScanListener }
//------------------------------------------------------------------------------

constructor TMTScanDirectoryThreadListener.Create(const Directory: TFileName);
begin
  // Creating the working thread (file 'engine/mtscan.pas')
  fMTScanDirectoryThread := TMTScanDirectoryThread.Create(Directory);

  // Setting events
  fMTScanDirectoryThread.OnInitGettingFilesList := Self.OnInitGettingFilesList;
  fMTScanDirectoryThread.OnStart := Self.OnStart;
  fMTScanDirectoryThread.OnFileFound := Self.OnFileFound;
  fMTScanDirectoryThread.OnFileScanned := Self.OnFileScanned;
  fMTScanDirectoryThread.OnTerminate := Self.OnTerminate;

  // Setting progress form (file 'progress.pas')
  frmProgress := TfrmProgress.Create(frmMain);
  frmProgress.SetWindowTitle('Scanning directory...');
  frmProgress.WorkThread := fMTScanDirectoryThread; // this is for controlling the thread thought the abort button
end;

//------------------------------------------------------------------------------

destructor TMTScanDirectoryThreadListener.Destroy;
begin
  // destroying form
  if Assigned(frmProgress) then begin
    frmProgress.Release;
    if (not frmMain.Active) then frmMain.SetFocus;
  end;

  // don't need to destroy the thread, it have been destroyed automatically (FreeOnTerminate)

  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TMTScanDirectoryThreadListener.OnFileFound(Sender: TObject; FileName: TFileName);
begin
  frmProgress.SetProgressEvent('Scanning "' + ExtractFileName(FileName) + '"...');
end;

//------------------------------------------------------------------------------

procedure TMTScanDirectoryThreadListener.OnFileScanned(Sender: TObject; FileName: TFileName;
  FileValid: Boolean);
begin
  if FileValid then begin
    frmMain.FilesList.Add(FileName);
    frmMain.lbFilesList.Items.Add(ExtractFileName(FileName));
    frmMain.eFilesCount.Text := IntToStr(frmMain.FilesList.Count);
  end;

  frmProgress.UpdateProgressBar;
end;

//------------------------------------------------------------------------------

procedure TMTScanDirectoryThreadListener.OnInitGettingFilesList(
  Sender: TObject);
begin
  frmProgress.SetProgressEvent('Retrieving files list... Please wait.');
end;

//------------------------------------------------------------------------------

procedure TMTScanDirectoryThreadListener.OnStart(Sender: TObject; FilesCount: Integer);
begin
  frmProgress.InitProgressBar(FilesCount);
end;

//------------------------------------------------------------------------------

procedure TMTScanDirectoryThreadListener.OnTerminate(Sender: TObject);
begin
  // The thread is over, so we can close the progress form.
  if Assigned(frmProgress) then begin
    frmProgress.Terminated := True;  // notify the form that the thread is over so it can close
    frmProgress.Close;
  end;
end;

//------------------------------------------------------------------------------

procedure TMTScanDirectoryThreadListener.Start;
begin
  Assert(
    Assigned(fMTScanDirectoryThread) and Assigned(frmProgress),
    'TMTScanListener.Start: Thread and/or Progress form not assigned ?!'
  );

  // running the thread
  fMTScanDirectoryThread.Resume;

  // showing progress bar
  frmProgress.ShowModal;
end;

//------------------------------------------------------------------------------

end.
