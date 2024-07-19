unit API.Controls.Hack;

interface
uses
  Vcl.Controls
  ;

type
  TControl = class(Vcl.Controls.TControl)  // To Access Protected TControl Text Property..
  private
    function Get_Text: TCaption;
    procedure Set_Text(const aValue: TCaption);
  public
    property LText: TCaption read Get_Text write Set_Text;
  end;

implementation

{ TControl }

function TControl.Get_Text: TCaption;
begin
  Result := Text;
end;

procedure TControl.Set_Text(const aValue: TCaption);
begin
  Text := aValue;
end;

end.
