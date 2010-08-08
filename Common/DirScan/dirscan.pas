(*
  Directory Scanner Module

  This module is here to allow the directory scanning. Open the dbgscan project
  to learn how to use it.
*)
unit DirScan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, JvBaseDlg, JvBrowseFolder, Progress;

type
  TDirectoryScannerQueryWindow = class;
  TDirectoryScannerThread = class;
  TDirectoryScannerQueryDialogProperties = class;
  TDirectoryScannerProgressDialogProperties = class;
  
  // Events
  TDirectoryScannerInitializeEvent = procedure(Sender: TObject;
    MaxValue: Integer) of object;
  TDirectoryScannerFileProceed = procedure(Sender: TObject;
    FileName: TFileName; Result: Boolean) of object;
  TDirectoryScannerCompletedEvent = procedure(Sender: TObject;
    Canceled: Boolean; ValidFiles, TotalFiles: Integer) of object;

  // Main class to use (Controller)
  TDirectoryScanner = class(TObject)
  private
    fScannerThread: TDirectoryScannerThread;
    fFilter: string;
    fFileProceed: TDirectoryScannerFileProceed;
    fInitialize: TDirectoryScannerInitializeEvent;
    fCompleted: TDirectoryScannerCompletedEvent;
    fSourceDirectory: TFileName;
    fQueryProperties: TDirectoryScannerQueryDialogProperties;
    fQueryDialog: TDirectoryScannerQueryWindow;
    fProgressDialog: TProgressionDialog;
    fProgressProperties: TDirectoryScannerProgressDialogProperties;
    fActive: Boolean;
    procedure KillThread;
    function ShowQueryDialog: Boolean;
    procedure ProgressCancelRequest(Sender: TObject);
    procedure ProgressCancelResult(Sender: TObject; Canceled: Boolean);
    procedure ScannerThreadTerminate(Sender: TObject);
    property ProgressDialog: TProgressionDialog read fProgressDialog
      write fProgressDialog;
    property QueryDialog: TDirectoryScannerQueryWindow read fQueryDialog
      write fQueryDialog;
    property ScannerThread: TDirectoryScannerThread read fScannerThread;
  protected
    function IsValidFile(const FileName: TFileName): Boolean; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Abort;
    procedure Pause;
    function Execute: Boolean; overload;
    function Execute(const QuerySourceDirectory: Boolean): Boolean; overload;
    property Active: Boolean read fActive;
    property Filter: string read fFilter write fFilter;
    property ProgressProperties: TDirectoryScannerProgressDialogProperties
      read fProgressProperties write fProgressProperties;
    property QueryProperties: TDirectoryScannerQueryDialogProperties
      read fQueryProperties write fQueryProperties;
    property OnCompleted: TDirectoryScannerCompletedEvent read fCompleted
      write fCompleted;
    property OnFileProceed: TDirectoryScannerFileProceed read fFileProceed
      write fFileProceed;
    property OnInitialize: TDirectoryScannerInitializeEvent read fInitialize
      write fInitialize;
    property SourceDirectory: TFileName read fSourceDirectory
      write fSourceDirectory;  
  end;

  // Thread object (Model)
  TDirectoryScannerThread = class(TThread)
  private
    fFileName: TFileName;
    fValidFiles: Integer;
    fMaxValue: Integer;
    fUpdateText: string;
    fFileProceed: TDirectoryScannerFileProceed;
    fSourceDirectory: TFileName;
    fFilter: string;
    fInitialize: TDirectoryScannerInitializeEvent;
    fCompleted: TDirectoryScannerCompletedEvent;
    fOwner: TDirectoryScanner;
    fProgressShowDialog: Boolean;
    fProgressDialog: TProgressionDialog;
    procedure SyncProgressInitialize;
    procedure SyncProgressUpdate;
    procedure SyncProgressTerminated;
    procedure SyncValidFile;    
  protected
    procedure Execute; override;
  public
    constructor Create;
    property ACompleted: TDirectoryScannerCompletedEvent read fCompleted
      write fCompleted;
    property AFileProceed: TDirectoryScannerFileProceed read fFileProceed
      write fFileProceed;
    property AFilter: string read fFilter write fFilter;      
    property AInitialize: TDirectoryScannerInitializeEvent read fInitialize
      write fInitialize;
    property AProgressDialog: TProgressionDialog read fProgressDialog
      write fProgressDialog;
    property AProgressShowDialog: Boolean read fProgressShowDialog
      write fProgressShowDialog;
    property ASourceDirectory: TFileName read fSourceDirectory
      write fSourceDirectory;
    property AOwner: TDirectoryScanner read fOwner write fOwner;
  end;

  TDirectoryScannerProgressDialogProperties = class(TObject)
  private
    fActive: Boolean;
    fOwner: TDirectoryScanner;
    function GetTitle: TCaption;
    procedure SetTitle(const Value: TCaption);
  public
    constructor Create(AOwner: TDirectoryScanner);
    property ShowDialog: Boolean read fActive write fActive;
    property Title: TCaption read GetTitle write SetTitle;
    property Owner: TDirectoryScanner read fOwner;
  end;

  // Interface configuration
  TDirectoryScannerQueryDialogProperties = class(TObject)
  private
    fMRUDirectoriesDatabase: TFileName;
    fOwner: TDirectoryScanner;
    function GetTitle: TCaption;
    procedure SetTitle(const Value: TCaption);
    function GetCaption: TCaption;
    procedure SetCaption(const Value: TCaption);
  public
    constructor Create(AOwner: TDirectoryScanner);
    property Caption: TCaption read GetCaption write SetCaption;
    property MRUDirectoriesDatabase: TFileName read fMRUDirectoriesDatabase
      write fMRUDirectoriesDatabase;
    property Title: TCaption read GetTitle write SetTitle;
    property Owner: TDirectoryScanner read fOwner;
  end;
  
  // Interface (View)
  TDirectoryScannerQueryWindow = class(TForm)
    gbDirectory: TGroupBox;
    bBrowse: TButton;
    bOK: TButton;
    bCancel: TButton;
    bvDelimiter: TBevel;
    lInfo: TLabel;
    cbDirectory: TComboBox;
    bfd: TJvBrowseForFolderDialog;  
    procedure bBrowseClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure bOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    fOwner: TDirectoryScanner;
    function GetSelectedDirectory: TFileName;
    procedure SetSelectedDirectory(const Value: TFileName);
    procedure LoadMRUDirectories;
    procedure SaveMRUDirectories;
  public
    function MsgBox(const Text, Title: string; Flags: Integer): Integer;
    property SelectedDirectory: TFileName read GetSelectedDirectory
      write SetSelectedDirectory;
    property Owner: TDirectoryScanner read fOwner;
  end;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

{$R *.dfm}

{ TDirectoryScanner }

procedure TDirectoryScanner.Abort;
begin
  if Active then begin
    // Restart the thread if paused
    Execute;

    // Stop the thread execution
    ScannerThread.Terminate;
  end;
end;

constructor TDirectoryScanner.Create;
begin
  // Init the Progress Dialog
  fProgressDialog := TProgressionDialog.Create;  
  fProgressProperties := TDirectoryScannerProgressDialogProperties.Create(Self);
  with ProgressDialog do begin
    OnCancelRequest := ProgressCancelRequest;
    OnCancelResult := ProgressCancelResult;
  end;

  // Init the Query Dialog
  fQueryDialog := TDirectoryScannerQueryWindow.Create(nil);
  fQueryProperties := TDirectoryScannerQueryDialogProperties.Create(Self);
  fQueryDialog.fOwner := Self;

  // Init the properties
  fFilter := '*.*';
  fScannerThread := nil;
end;

destructor TDirectoryScanner.Destroy;
begin
  KillThread;
  QueryProperties.Free;
  ProgressProperties.Free;
  QueryDialog.Free;
  ProgressDialog.Free;
  inherited;
end;

function TDirectoryScanner.IsValidFile(const FileName: TFileName): Boolean;
begin
  // To override...
  Result := True;
end;

procedure TDirectoryScanner.KillThread;
begin
  if Active then begin
    Abort;
    
    // Waiting for the thread end
    ScannerThread.WaitFor;
  end;
  ScannerThread.Free;
end;

procedure TDirectoryScanner.Pause;
begin
  try
    if Active then
      ScannerThread.Suspend;
  except
{$IFDEF DEBUG}
    WriteLn('Unable to pause the Directory Scanner Thread');
{$ENDIF}
  end;
end;

procedure TDirectoryScanner.ProgressCancelRequest(Sender: TObject);
begin
  Pause;
end;

procedure TDirectoryScanner.ProgressCancelResult(Sender: TObject;
  Canceled: Boolean);
begin
  Execute;
  if Canceled then
    Abort;
end;

procedure TDirectoryScanner.ScannerThreadTerminate(Sender: TObject);
begin
  // Destroying the thread
  fActive := False;
end;

function TDirectoryScanner.ShowQueryDialog: Boolean;
begin
  // Initializing dialog
  with QueryDialog do begin
    SelectedDirectory := SourceDirectory;

    // Showing dialog
    ShowModal;

    // Getting result
    Result := ModalResult = mrOk;
    if Result then
      SourceDirectory := SelectedDirectory;
  end;
end;

function TDirectoryScanner.Execute(const QuerySourceDirectory: Boolean): Boolean;
var
  StartAllowed: Boolean;

begin
  Result := False;
  if not Active then begin

    // Creating thread
    KillThread;
    fScannerThread := TDirectoryScannerThread.Create;

    // Show the UI if needed
    StartAllowed := (QuerySourceDirectory and ShowQueryDialog) or (not QuerySourceDirectory);    

    // Starting the process
    if StartAllowed then begin

      // Initializing parameters
      with ScannerThread do begin
        OnTerminate := ScannerThreadTerminate;
        AOwner := Self;
        ASourceDirectory := SourceDirectory;
        AFilter := Filter;
        AInitialize := OnInitialize;
        AFileProceed := OnFileProceed;
        ACompleted := OnCompleted;
        AProgressShowDialog := ProgressProperties.ShowDialog;
        AProgressDialog := ProgressDialog;
      end;

      // Running thread
      fActive := True;
      ScannerThread.Resume;

      // Showing Progress
      if ProgressProperties.ShowDialog then
        ProgressDialog.Execute;

      // Setting result to OK
      Result := True;
    end;
    
  end else begin
    // if paused then resume
    if ScannerThread.Suspended then begin
      ScannerThread.Resume;
      Result := True;
    end;
  end;
end;

function TDirectoryScanner.Execute: Boolean;
begin
  Result := Execute(False);
end;

{ TDirectoryScannerThread }

constructor TDirectoryScannerThread.Create;
begin
  inherited Create(True);
//  FreeOnTerminate := True;  // don't use here because we want to monitor the thread
//  fOwner := AOwner;
end;

procedure TDirectoryScannerThread.Execute;
var
  SR: TSearchRec;
  i: Integer;
  SL: TStringList;
  Done: Boolean;

begin
{$IFDEF DEBUG}
  WriteLn('*** DIRECTORY SCANNER STARTS ***', sLineBreak);
{$ENDIF}

  // Init thread
  ASourceDirectory := IncludeTrailingPathDelimiter(ASourceDirectory);
  if not DirectoryExists(ASourceDirectory) then Exit;
  fValidFiles := 0;
  
{$IFDEF DEBUG}
  WriteLn('SourceDirectory: "', ASourceDirectory, '"');
{$ENDIF}

  SL := TStringList.Create;
  try
    if FindFirst(ASourceDirectory + AFilter, faAnyFile, SR) = 0 then
    begin
      // Scanning the whole directory
      repeat
        if ((SR.Attr and faDirectory) = 0) then
          SL.Add(ASourceDirectory + SR.Name);
      until Terminated or (FindNext(SR) <> 0);
      FindClose(SR); // Must free up resources used by these successful finds
    end;
    fMaxValue := SL.Count;

    // Sort files list
    SL.Sort;

{$IFDEF DEBUG}
  WriteLn('Files count: ', fMaxValue);
{$ENDIF}

    // Scanning all found files
    if Assigned(fInitialize) then
      fInitialize(AOwner, fMaxValue);

    // Initialize the progress window
    if AProgressShowDialog then
      Synchronize(SyncProgressInitialize);

    // checking each file
    Done := (SL.Count = 0) or Terminated;
    i := 0;
    while not Done do begin
      // Sending event for checking if the file is valid
      fFileName := SL[i];
      Synchronize(SyncValidFile);

      // Updating progress window
      if AProgressShowDialog then begin
        fUpdateText := 'Scanning "' + ExtractFileName(fFileName) + '"...';
        Synchronize(SyncProgressUpdate);
      end;

      // Manage the loop
      Inc(i);
      Done := Terminated or (i >= fMaxValue);
    end;

    // End event
    if Assigned(fCompleted) then
      fCompleted(AOwner, Terminated, fValidFiles, fMaxValue);

    // Closing progress window
    if AProgressShowDialog then
      Synchronize(SyncProgressTerminated);

{$IFDEF DEBUG}
    WriteLn('DirScan End Process (Canceled=', Terminated, ')');
{$ENDIF}

  finally
    SL.Free;
  end;
end;

procedure TDirectoryScannerThread.SyncProgressInitialize;
begin
  AProgressDialog.Initialize(fMaxValue);
end;

procedure TDirectoryScannerThread.SyncProgressTerminated;
begin
  AProgressDialog.Terminate;
end;

procedure TDirectoryScannerThread.SyncProgressUpdate;
begin
  AProgressDialog.Update(fUpdateText);
end;

procedure TDirectoryScannerThread.SyncValidFile;
var
  FileValid: Boolean;

begin
  // AOwner.IsValidFile must be synchronized!!
  FileValid := AOwner.IsValidFile(fFileName);
  if FileValid then
    Inc(fValidFiles);
    
  if Assigned(AFileProceed) then
    AFileProceed(AOwner, fFileName, FileValid);
end;

{ TDirectoryScannerQueryWindow }

procedure TDirectoryScannerQueryWindow.bBrowseClick(Sender: TObject);
begin
  with bfd do begin
    if DirectoryExists(SelectedDirectory) then
      Directory := SelectedDirectory;
    if Execute then begin
      SelectedDirectory := Directory;
      cbDirectory.SelectAll;
      cbDirectory.SetFocus;
    end;
  end;
end;

procedure TDirectoryScannerQueryWindow.bOKClick(Sender: TObject);
begin
  if not DirectoryExists(SelectedDirectory) then begin
    MsgBox('Specified directory doesn''t exists.', 'Error', MB_ICONWARNING);
    ModalResult := mrNone;
  end else begin
    // Adding to the list
    if cbDirectory.Items.IndexOf(SelectedDirectory) = -1 then
      cbDirectory.Items.Add(SelectedDirectory);
  end;
end;

procedure TDirectoryScannerQueryWindow.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveMRUDirectories;
end;

procedure TDirectoryScannerQueryWindow.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

procedure TDirectoryScannerQueryWindow.FormShow(Sender: TObject);
begin
  LoadMRUDirectories;

  if SelectedDirectory = '' then  
    SelectedDirectory := IncludeTrailingPathDelimiter(ExpandFileName(GetCurrentDir));
  cbDirectory.SelectAll;
  cbDirectory.SetFocus;
end;

function TDirectoryScannerQueryWindow.GetSelectedDirectory: TFileName;
begin
  if cbDirectory.Text <> '' then
    Result := IncludeTrailingPathDelimiter(cbDirectory.Text);
end;

procedure TDirectoryScannerQueryWindow.LoadMRUDirectories;
var
  i: Integer;
  SL: TStringList;

begin
  if FileExists(Owner.QueryProperties.MRUDirectoriesDatabase) then begin
    cbDirectory.Items.Clear;

    SL := TStringList.Create;
    try
      SL.LoadFromFile(Owner.QueryProperties.MRUDirectoriesDatabase);
      for i := 0 to SL.Count - 2 do // the last is used to select the previous path from list
        if DirectoryExists(SL[i]) then
          cbDirectory.Items.Add(SL[i]);

      // Select the lastest path
      cbDirectory.ItemIndex := StrToInt(SL[SL.Count - 1]);
    finally
      SL.Free;
    end;
  end;
end;

function TDirectoryScannerQueryWindow.MsgBox(const Text, Title: string;
  Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Title), Flags);
end;

procedure TDirectoryScannerQueryWindow.SaveMRUDirectories;
var
  SL: TStringList;

begin
  SL := TStringList.Create;
  try
    SL.Assign(cbDirectory.Items);
    SL.Add(IntToStr(cbDirectory.Items.IndexOf(cbDirectory.Text)));
    SL.SaveToFile(Owner.QueryProperties.MRUDirectoriesDatabase);
  finally
    SL.Free;
  end;
end;

procedure TDirectoryScannerQueryWindow.SetSelectedDirectory(const Value: TFileName);
begin
  if Value <> '' then  
    cbDirectory.Text := IncludeTrailingPathDelimiter(Value);
end;

{ TDirectoryScannerInterfaceProperties }

constructor TDirectoryScannerQueryDialogProperties.Create(
  AOwner: TDirectoryScanner);
begin
  fOwner := AOwner;
  MRUDirectoriesDatabase := 'dirscan.mru';
  Caption := 'Directory Scanner';
  Title := 'Please select the directory to open.';
end;

function TDirectoryScannerQueryDialogProperties.GetCaption: TCaption;
begin
  Result := Owner.QueryDialog.Caption;
end;

function TDirectoryScannerQueryDialogProperties.GetTitle: TCaption;
begin
  Result := Owner.QueryDialog.lInfo.Caption;
end;

procedure TDirectoryScannerQueryDialogProperties.SetCaption(
  const Value: TCaption);
begin
  Owner.QueryDialog.Caption := Value;
end;

procedure TDirectoryScannerQueryDialogProperties.SetTitle(
  const Value: TCaption);
begin
  Owner.QueryDialog.lInfo.Caption := Value;
end;

{ TDirectoryScannerProgressDialogProperties }

constructor TDirectoryScannerProgressDialogProperties.Create(
  AOwner: TDirectoryScanner);
begin
  fActive := True;
  fOwner := AOwner;
  Title := 'Scanning directory...';
end;

function TDirectoryScannerProgressDialogProperties.GetTitle: TCaption;
begin
  Result := Owner.ProgressDialog.Title;
end;

procedure TDirectoryScannerProgressDialogProperties.SetTitle(
  const Value: TCaption);
begin
  Owner.ProgressDialog.Title := Value;
end;

end.
