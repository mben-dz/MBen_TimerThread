unit API.Helpers;

interface

uses
  System.Classes  // Used For [TComponent]
, System.SysUtils // Used For [TProc]
, System.SyncObjs // Used For [TCriticalSection]

, Vcl.Controls
;

type

  TCaseTag = class
  private
    fSender: TObject;
    fComp: TControl;
    fNextTag: Cardinal;
    fLock: TCriticalSection; // To ensure thread safety

  public
    constructor &For(aSender: TObject);
    destructor Destroy; override;

    function CaseOfProc(const aCaseTag, aNextTag: Cardinal; aDoSomething: TProc; aCaption: string = ''): TCaseTag;
    function CaseOfEvent(const aCaseTag, aNextTag: Cardinal; aDoSomething: TNotifyEvent; aCaption: string = ''): TCaseTag;
    procedure &End;
  end;

implementation

uses
  API.Controls.Hack

;

{ TCaseTag }

constructor TCaseTag.&For(aSender: TObject);
begin
  if (aSender is Vcl.Controls.TControl) then begin
    fSender := aSender;
    fComp   := vcl.Controls.TControl(aSender);
    fLock   := TCriticalSection.Create;

  end else raise Exception.Create('Error: Only Controls Accepted !!');
end;

destructor TCaseTag.Destroy;
begin
  fLock.Free;

  inherited Destroy;
end;

function TCaseTag.CaseOfProc(const aCaseTag, aNextTag: Cardinal;
  aDoSomething: TProc; aCaption: string = ''): TCaseTag;
begin
  Result := Self;

  fLock.Acquire;
  try
    if fComp.Tag = aCaseTag then
    begin
      aDoSomething;
      fNextTag := aNextTag;
      if not aCaption.IsEmpty then
        THackControl(fSender).LText := aCaption;
    end;
  finally
    fLock.Release;
  end;
end;

function TCaseTag.CaseOfEvent(const aCaseTag, aNextTag: Cardinal;
  aDoSomething: TNotifyEvent; aCaption: string = ''): TCaseTag;
begin
  Result := Self;

  fLock.Acquire;
  try
    if fComp.Tag = aCaseTag then
    begin
      aDoSomething(fSender);
      fNextTag := aNextTag;
      if not aCaption.IsEmpty then
        THackControl(fSender).LText := aCaption;
    end;
  finally
    fLock.Release;
  end;
end;

procedure TCaseTag.&End;
begin
  fComp.Tag := fNextTag;
  Free;
end;

end.
