unit UGrabitel;

interface

uses System.UITypes, System.Types, System.Generics.Collections;

type
  TGr = class
    Road: Integer;
    Pos: Integer;
    Damage: Integer;
    LSD: Integer;
    Interval : Integer;
    Point: Integer;
    Setcl: Integer;
    Up1: Boolean;
    Up2: Boolean;
    function SetDamage: Integer;
    procedure Upgrade1;
    constructor Create (APos, ARoad, ASetcl: Integer);
  end;

  TGrs = class   (TObjectList<TGr>)
    procedure NewGr (APos, ARoad, ASetcl: Integer);
  end;

implementation

{ TGr }

constructor TGr.Create(APos, Aroad, ASetcl: Integer);
begin
  Pos := APos;
  Setcl := ASetcl;
  if True then
  if Setcl=1 then
    begin
      Damage := 2;
      LSD := 20;
    end;
  if Setcl=2 then
    begin
      Damage := 1;
      LSD := 50;
    end;

  Road := ARoad;
  Interval := 0;
  Point := 0;
  Up1 := false;
  Up2 := false;
end;

function TGr.SetDamage: Integer;
begin
  Result :=0;
  if (Interval * LSD >= 100) then
    begin
      Result := Damage;
      Interval := 0;
    end
  else
    inc (Interval)

end;

procedure TGr.Upgrade1;
begin
  Damage := Damage * 2;
  Up1 := true;
  LSD := Round(LSD * 1.5);
end;

{ TGrs }
procedure TGrs.NewGr(APos, ARoad, ASetcl: Integer);
begin
  Add(TGr.Create(APos, ARoad, ASetcl));
end;

end.
