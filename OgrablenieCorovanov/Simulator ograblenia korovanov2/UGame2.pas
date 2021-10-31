unit UGame2;

interface

uses
  Ugrabitel, UKorovan, FMX.Forms, System.UITypes, FMX.Graphics, System.Types,
  FMX.Controls.Presentation, FMX.Objects, FMX.Types, FMX.Controls, FMX.StdCtrls,
  System.Classes, FMX.Dialogs, System.SysUtils;

type
  TFrGame2 = class(TFrame)
    PBox: TPaintBox;
    Text1: TText;
    TimMain: TTimer;
    procedure PBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure TimMainTimer(Sender: TObject);
    procedure PBoxPaint(Sender: TObject; Canvas: TCanvas);
    procedure SBBackClick(Sender: TObject);
    procedure SBPauseClick(Sender: TObject);
    procedure SBPlayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Korovans: TKorovans;
    Grs: TGrs;
    Wave: Integer;
    Yobi: Integer;
    ToWave: Integer;
    HP: Integer;
    Poligon: Integer;
    Price: Integer;
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Procedure NewWawe;
  end;

implementation

uses UMain, UMenu;

{$R *.fmx}

procedure TFrGame2.SBBackClick(Sender: TObject);
begin
  SetFrame (TFrMenu);
end;


procedure TFrGame2.TimMainTimer(Sender: TObject);
  var LKorovan: TKorovan;
      LGr: TGr;
begin

  PBox.Repaint;

  if Assigned(Korovans) then
  begin
    Korovans.NewKorovan(Wave);
    for LKorovan in Korovans do
    begin
      LKorovan.Move;
      if LKorovan.CheckOut (RectF (0,0,PBox.Width,PBox.Height)) then
        begin
          Korovans.Delete (Korovans.IndexOf (LKorovan));
          HP := HP -1;
          if (HP <= 0) then
            begin
              ShowMessage ('You are lose!');
              TimMain.Enabled := False;
            end;
          Continue;
        end;
      for LGr in Grs do
        begin
          if (LKorovan.Road = LGr.Road) and
             (LKorovan.Pos  <= LGr.Pos) and
             (LKorovan.Pos + LKorovan.Length >=  LGr.Pos) then
             begin
                LKorovan.Health := LKorovan.Health - LGr.SetDamage;
               if (LKorovan.CheckDie(LGr.SetDamage)) then
                  begin
                    Yobi := Yobi + LKorovan.Weight;
                    Korovans.Delete (Korovans.IndexOf (LKorovan));
                    ToWave := ToWave + 1;
                  end;
             end;
        end;
    end;
  end;

  if Poligon > 0 then dec(Poligon);

  if ToWave div (20 + Wave) > Wave then NewWawe;

end;

constructor TFrGame2.Create(AOwner: TComponent);
begin
  inherited;

  if not Assigned(Grs) then
    Grs := TGrs.Create;
  ToWave := 0;
  Wave := 0;

  Yobi := 70;
  HP := 10;
  Price := 25;
  NewWawe;
end;

destructor TFrGame2.Destroy;
begin
  if Assigned(Korovans) then
    begin
      Korovans.Free;
      Korovans := nil;
    end;
  if Assigned(Grs) then
    begin
      Grs.Free;
      Grs := nil;
    end;
  inherited;
end;

procedure TFrGame2.NewWawe;
begin
  if not Assigned(Korovans) then
    Korovans := TKorovans.Create;
  Korovans.Clear;
  Inc(Wave);
  Price := Price + 5;
  Poligon := 100;
end;

procedure TFrGame2.SBPauseClick(Sender: TObject);
begin
  TimMain.Enabled := False;
end;

procedure TFrGame2.PBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  //
  if (Yobi-Price >=0) then
    begin
      if Assigned(Grs) then
        begin
          if ((Y<=150) and (Y>=100)) then
             begin
              Grs.NewGr(round(X), 1);
            end;
          if ((Y<=250) and (Y>=200)) then
             begin
              Grs.NewGr(round(X), 2);
            end;
          if ((Y<=350) and (Y>=300)) then
             begin
              Grs.NewGr(round(X), 3);
            end;
          if ((Y<=450) and (Y>=400)) then
             begin
              Grs.NewGr(round(X), 4);
            end;
        end;
      Yobi := Yobi- Price;
    end;
end;


procedure TFrGame2.PBoxPaint(Sender: TObject; Canvas: TCanvas);
  var
    LKorovan:TKorovan;
    LGr: TGr;
begin
  Canvas.Fill.Kind := TBrushKind.Solid;
    Canvas.Font.Family := 'Arial';
    Canvas.Font.Size := 20;
    Canvas.Font.Style := [TFontStyle.fsBold];
    Canvas.BeginScene();

     Canvas.Fill.Color := TAlphaColors.Red;
     Canvas.Fill.Kind := TBRushKind.Solid;
     Canvas.Stroke.Kind := TBrushKind.Solid;
     Canvas.Stroke.Color := TAlphaColors.Green;
     Canvas.Stroke.Thickness :=5;
     Canvas.FillRect (RectF(0, 100, PBox.Width, 150), 0, 0, [], 1);
     Canvas.DrawRect (RectF(0, 100, PBox.Width, 150),  0, 0, [], 1);

     Canvas.Fill.Color := TAlphaColors.green;
     Canvas.Fill.Kind := TBRushKind.Solid;
     Canvas.Stroke.Kind := TBrushKind.Solid;
     Canvas.Stroke.Color := TAlphaColors.Blue;
     Canvas.Stroke.Thickness :=5;
     Canvas.FillRect (RectF(0, 200, PBox.Width, 250), 0, 0, [], 1);
     Canvas.DrawRect (RectF(0, 200, PBox.Width, 250),  0, 0, [], 1);

     Canvas.Fill.Color := TAlphaColors.Blue;
     Canvas.Fill.Kind := TBRushKind.Solid;
     Canvas.Stroke.Kind := TBrushKind.Solid;
     Canvas.Stroke.Color := TAlphaColors.Yellow;
     Canvas.Stroke.Thickness :=5;
     Canvas.FillRect (RectF(0, 300, PBox.Width, 350), 0, 0, [], 1);
     Canvas.DrawRect (RectF(0, 300, PBox.Width, 350),  0, 0, [], 1);

     Canvas.Fill.Color := TAlphaColors.Yellow;
     Canvas.Fill.Kind := TBRushKind.Solid;
     Canvas.Stroke.Kind := TBrushKind.Solid;
     Canvas.Stroke.Color := TAlphaColors.Red;
     Canvas.Stroke.Thickness :=5;
     Canvas.FillRect (RectF(0, 400, PBox.Width, 450), 0, 0, [], 1);
     Canvas.DrawRect (RectF(0, 400, PBox.Width, 450),  0, 0, [], 1);
     Canvas.Fill.Color := TAlphaColors.Black;
    Canvas.FillText(RectF(20, 30, 120, 50),'Wave: ' + Wave.ToString,
    False, 1, [], TTextAlign.Trailing);
    Canvas.FillText(RectF(170, 30, 270,50),'Yobi: ' + Yobi.ToString,
    False, 1, [], TTextAlign.Center);
    Canvas.FillText(RectF(320, 30, 570,50),'Your Hp: ' + HP.ToString,
    False, 1, [], TTextAlign.Center);

    if Poligon > 0 then
      begin
        Canvas.Font.Family := 'Arial';
        Canvas.Font.Size := 50;
        Canvas.Font.Style := [TFontStyle.fsBold];
        Canvas.FillText(RectF(0, 0, PBox.Width,PBox.Height),'New Wave: ' + Wave.ToString
                                          + LineFeed + 'Price for Gr: ' + Price.ToString,
        False, 1, [], TTextAlign.Center);
      end;

     if Assigned(Korovans) then
     for LKorovan in Korovans do
        begin
          Canvas.Fill.Color := TAlphaColors.Orange;
          Canvas.FillRect(RectF(LKorovan.Pos, LKorovan.Road * 100 + 10,
            LKorovan.Pos + LKorovan.Length, LKorovan.Road * 100 + 40),
            0, 0, [], 1);
        end;
     if Assigned(Grs) then
     for LGr in Grs do
        begin
          Canvas.Fill.Color := TAlphaColors.Black;
          Canvas.FillEllipse(RectF(LGr.Pos - 10, LGr.Road * 100,
            LGr.Pos + 20, LGr.Road * 100 + 20), 1);
        end;
    Canvas.EndScene;

end;

procedure TFrGame2.SBPlayClick(Sender: TObject);
begin
  TimMain.Enabled := True;
end;

end.
