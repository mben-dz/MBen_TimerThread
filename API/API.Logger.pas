unit API.Logger;

interface

uses
  Vcl.Controls;

type
  I_Log = interface
    ['{5B62F6B9-1B2B-4D4A-8A7C-5A3C56576B47}']
    procedure Log(const aMsg: string);
  end;

function Create_Log(aControl: TControl): I_Log;

implementation

uses
  System.SysUtils
, System.Classes

, API.Controls.Hack;

type
  TLogger = class(TInterfacedObject, I_Log)
  private
    fControl: TControl;
    procedure Log(const aMsg: string);
  public
    constructor Create(aControl: TControl);
  end;

constructor TLogger.Create(aControl: TControl);
begin
  fControl := aControl;
end;

procedure TLogger.Log(const aMsg: string);
var
  L_FormattedMsg: string;
begin
  if Assigned(fControl) then begin

    L_FormattedMsg := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + sLineBreak +
                         '--------------------------------------------------' + sLineBreak +
                         aMsg + sLineBreak +
                         '--------------------------------------------------' + sLineBreak;
    TThread.Synchronize(nil,
      procedure
      begin
        THackControl(fControl).LText := THackControl(fControl).LText + sLineBreak + L_FormattedMsg;
      end);
  end;
end;

function Create_Log(aControl: TControl): I_Log;
begin
  Result := TLogger.Create(aControl);
end;

end.
