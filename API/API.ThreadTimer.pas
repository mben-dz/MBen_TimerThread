unit API.ThreadTimer;

interface

uses
 API.Logger
;

type
  TTaskEvent = procedure of object;

  I_TimerThread = interface ['{D8A6E462-A4E3-4FF7-AAE4-DC868B50E82E}']

    function Init: I_TimerThread;
    function Tag: Integer; overload;
    function Tag(const aValue: Integer): I_TimerThread; overload;
    function IncTag(aStep: Integer = 1): I_TimerThread;
    function OnTask(const aValue: TTaskEvent): I_TimerThread;
    function Enabled(const aValue: Boolean): I_TimerThread;
    function Interval(const aValue: Cardinal): I_TimerThread;
  end;

function Create_TimerThread(aExceptionLog: I_Log = nil): I_TimerThread;

implementation

uses
  System.SysUtils    // Used for []
, System.Classes     // Used for [TThread]
, System.Threading   // Used for [ITask]
, System.SyncObjs    // Used for [TCriticalSection]

;

type
  TTimerThread = class(TInterfacedObject, I_TimerThread)
  strict private
    fTask: ITask;
    fOnTask: TTaskEvent;
    fEnabled: Boolean;
    fInterval: Cardinal;
    fTag: Integer;
    fStopTask: Boolean;
    fLock: TCriticalSection;
    fException: Exception;
    fExceptLog: I_Log;

  private
    procedure Start;
    procedure Stop;
    procedure Execute;
    procedure HandleException;

    function Init: I_TimerThread;
    function Tag: Integer; overload;
    function Tag(const aValue: Integer): I_TimerThread; overload;
    function IncTag(aStep: Integer = 1): I_TimerThread;
    function OnTask(const aValue: TTaskEvent): I_TimerThread;
    function Enabled(const aValue: Boolean): I_TimerThread;
    function Interval(const aValue: Cardinal): I_TimerThread;
  public
    constructor Create(aExceptionLog: I_Log = nil);
    destructor Destroy; override;
  end;

function Create_TimerThread(aExceptionLog: I_Log): I_TimerThread;
begin
  Result := TTimerThread.Create(aExceptionLog);
end;

{ TTimerThread }
//  TTaskStatus = (Created, WaitingToRun, Running, Completed, WaitingForChildren, Canceled, Exception);

// TTaskStatus.Created => fTask := TTask.Create(Execute); // TTaskStatus.Created ..(not running yet!!)
// TTaskStatus.WaitingToRun if there is a [TEvent] from syncOBJ that fTask must wait for complete to run
// TTaskStatus.Running => fTask.Start (here the fTask is running)..
// TTaskStatus.Completed => in our case the fTask never meet this Status
//          where is running inside a while loop and stopped either by [Canceled or Exception] status !!
// TTaskStatus.WaitingForChildren this case also not implemented here because we didn't use ExecuteWork
// or our fTask is an array of ITask ..

constructor TTimerThread.Create(aExceptionLog: I_Log);
begin
  fEnabled   := False;
  fInterval  := 1000; // Default interval 1000 ms (1 second)
  fStopTask  := False;
  fTask      := nil;
  fLock      := TCriticalSection.Create;
  fException := nil;
  fExceptLog := aExceptionLog;

end;

destructor TTimerThread.Destroy;
begin
  Stop;
  fLock.Free;

  inherited Destroy;
end;

procedure TTimerThread.Execute;
begin
  while not fStopTask do begin

    if fEnabled then begin
      fLock.Enter;
      try
        fTask.Wait(fInterval); // pause thread by [Interval millisec] then Restart call again After every Sleep complete ..

        if Assigned(fOnTask)and fEnabled and (fTask.Status = TTaskStatus.Running) then begin
          TTask.Run(procedure begin
            try
              fOnTask
            except on Ex: Exception do begin
                fException := Ex;
                TThread.Synchronize(nil, HandleException);
              end;
            end;
          end);
        end else Exit;
      finally
        fLock.Leave;
      end;
    end;

  end;
end;

procedure TTimerThread.HandleException;
begin
  if Assigned(fException) then begin

    fExceptLog.Log('Exception in thread: ' + fException.Message);
    fException := nil;
  end;
end;

function TTimerThread.Init: I_TimerThread;
begin
  Result := Self;

  if not Assigned(fTask) then
    fTask := TTask.Create(Execute); // TTaskStatus.Created ..(not running yet!!)

end;

procedure TTimerThread.Start;
begin
  if Assigned(fTask) then begin
    if not (fTask.Status in
                 [TTaskStatus.Running]) then
    try
      fStopTask := False;
      fTask.Start;
    except on Ex: Exception do
      raise Exception.Create('Error: ' +Ex.Message);
    end;
  end else begin
    Init;
    try
      fStopTask := False;
      fTask.Start;
    except on Ex: Exception do
      raise Exception.Create('Error: ' +Ex.Message);
    end;
  end;

end;

procedure TTimerThread.Stop;
begin
  fEnabled  := False;
  fStopTask := True;
  fTag      := 0;

  if Assigned(fTask) then
  try
//    if (fTask.Status in
//                 [TTaskStatus.Running]) then
    fTask.Cancel;
  finally
    fTask := nil;
  end;

end;

function TTimerThread.Tag(const aValue: Integer): I_TimerThread;
begin
  Result := Self;

  if Assigned(fTask) then
    fTag := aValue;
end;

function TTimerThread.Tag: Integer;
begin
  Result := fTag;
end;

function TTimerThread.OnTask(const aValue: TTaskEvent): I_TimerThread;
begin
  Result  := Self;

  fOnTask := aValue;
end;

function TTimerThread.Enabled(const aValue: Boolean): I_TimerThread;
begin
  Result   := Self;

  fEnabled := aValue;

  if aValue then
    Start
  else
    Stop;
end;

function TTimerThread.IncTag(aStep: Integer = 1): I_TimerThread;
begin
  Result := Self;

  if Assigned(fTask) and
  (fTask.Status in [TTaskStatus.Running]) then // this called only when fTask is Running ..
    inc(fTag, aStep);
end;

function TTimerThread.Interval(const aValue: Cardinal): I_TimerThread;
begin
  Result    := Self;
  if Assigned(fTask) then
    fInterval := aValue;
end;

end.
