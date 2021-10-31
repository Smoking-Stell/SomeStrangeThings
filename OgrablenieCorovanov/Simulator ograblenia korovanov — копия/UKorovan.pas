unit UKorovan;

interface

  uses System.UITypes, System.Types, System.Generics.Collections;

  type

    TKorovan = class
      Health: Integer;
      Weight: Integer;
      Speed: Integer;
      Road: Integer;
      Pos: Integer;
      Length: Integer;
      Constructor Create (AWave: Integer);
      Procedure Move;
      Procedure SetRoad;
      Function
    end;

    TKorovans = class (TObjectList<TKorovan>)
       Interval: Integer;
       procedure NewKorovan (LWave: Integer);
    end;
    const
      TBD = 100;
implementation

{ TKorovan }

constructor TKorovan.Create(AWave: Integer);
begin
  Health := AWave;
  Speed := AWave + 2;
  Weight := AWave + 3;
end;

procedure TKorovan.Move;
begin
  Pos := Pos + Speed;
end;


procedure TKorovan.SetRoad;
begin
  Road := Random(4)+ 1;
end;

{ TKorovans }

procedure TKorovans.NewKorovan(LWave: Integer);
  var CountStep: Integer;
begin
   CountStep := TBD * Interval;
   if CountStep >= 1000 then
    begin
      Add(TKorovan.Create(LWave));
      Interval := 0;
    end
   else
    inc(Interval);
end;

end.
