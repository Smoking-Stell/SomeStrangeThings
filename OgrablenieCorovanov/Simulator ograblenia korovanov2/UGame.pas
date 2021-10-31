unit UGame;

interface

uses
  Ugrabitel, UKorovan, FMX.Forms, System.UITypes, FMX.Graphics, System.Types,
  FMX.Controls.Presentation, FMX.Objects, FMX.Types, FMX.Controls, FMX.StdCtrls,
  System.Classes, FMX.Dialogs, System.SysUtils, UKyst;

type
  TFrGame = class(TFrame)
    TimMain: TTimer;
    Text1: TText;
    SBPause: TSpeedButton;
    PBox: TPaintBox;
    SBPlay: TSpeedButton;
    SBBack: TSpeedButton;
    Text2: TText;
    LGrabitel: TButton;
    LUbica: TButton;
    procedure PBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure TimMainTimer(Sender: TObject);
    procedure PBoxPaint(Sender: TObject; Canvas: TCanvas);
    procedure SBBackClick(Sender: TObject);
    procedure SBPauseClick(Sender: TObject);
    procedure SBPlayClick(Sender: TObject);
    procedure LGrabitelClick(Sender: TObject);
    procedure LUbicaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Korovans: TKorovans;
    Grs: TGrs;
    Kysts: TKysts;
    Wave: Integer;
    Yobi: Integer;
    ToWave: Integer;
    HP: Integer;
    Poligon: Integer;
    Price: Integer;
    Schet: Integer;
    Chose: Integer;
    Road1: Integer;
    Road2: Integer;
    Road3: Integer;
    Road4: Integer;
    BitPicture: array of TBitmap;
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Procedure NewWawe;
  end;

implementation

uses UMain, UMenu;

{$R *.fmx}

procedure TFrGame.SBBackClick(Sender: TObject);
begin
  SetFrame (TFrMenu);
end;


procedure TFrGame.TimMainTimer(Sender: TObject);
  var LKorovan: TKorovan;
      LGr: TGr;
      LKyst: TKyst;
      i: integer;
begin

  PBox.Repaint;


  if Assigned(Korovans) then
  begin
    if Schet <= (Wave + 20)*21 then
      begin
        Korovans.NewKorovan(Wave);
        Schet := Schet + 1;
      end;
    for LKorovan in Korovans do
    begin
      LKorovan.Move;
      if LKorovan.CheckOut (RectF (0,0,PBox.Width,PBox.Height)) then
        begin
          Korovans.Delete (Korovans.IndexOf (LKorovan));
          HP := HP - 1;
          ToWave := ToWave + 1;
          if (HP <= 0) then
            begin
              ShowMessage ('You lose!');
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
                LGr.Point := 1;
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

  if ToWave>= Wave + 20 then
    begin
      NewWawe;
      ToWave := 0;
    end;
  if Wave >= 16 then
    begin
      ShowMessage ('Gonrutilation! You win!');
      TimMain.Enabled := False;
    end;

end;

procedure TFrGame.LGrabitelClick(Sender: TObject);
begin
  Chose := 1;
  Price := 25 + Wave*5;

end;

procedure TFrGame.LUbicaClick(Sender: TObject);
begin
  Chose := 2;
  Price := 35 + Wave*5;
end;

constructor TFrGame.Create(AOwner: TComponent);
  var LStream: TResourceStream;
      I: Integer;
begin
  inherited;

  if not Assigned(Grs) then
    Grs := TGrs.Create;

  if not Assigned(Kysts) then
    Kysts := TKysts.Create;

  SetLength(BitPicture,5);
  for I := Low(BitPicture) to High(BitPicture) do
    BitPicture[I] := TBitmap.Create;

  LStream := TResourceStream.Create(HInstance,'Doroga', RT_RCDATA);
  BitPicture[0].LoadFromStream(LStream);
  LStream.Free;

  LStream := TResourceStream.Create(HInstance,'Korovan', RT_RCDATA);
  BitPicture[1].LoadFromStream(LStream);
  LStream.Free;

  LStream := TResourceStream.Create(HInstance,'Bandit', RT_RCDATA);
  BitPicture[2].LoadFromStream(LStream);
  LStream.Free;

  LStream := TResourceStream.Create(HInstance,'Ubica', RT_RCDATA);
  BitPicture[3].LoadFromStream(LStream);
  LStream.Free;

  LStream := TResourceStream.Create(HInstance,'kyst', RT_RCDATA);
  BitPicture[4].LoadFromStream(LStream);

  LStream.Free;
  ToWave := 0;
  Wave := 0;
  Yobi := 370;
  HP := 10;
  Price := 25;
  if Assigned(Kysts) then
    for i := 1 to 2000 do
      begin
        if (i mod 200 = 0) then
          begin
            Kysts.NewKyst(i, 1);
            Kysts.NewKyst(i, 2);
            Kysts.NewKyst(i, 3);
            Kysts.NewKyst(i, 4);
          end;

      end;
  NewWawe;
end;

destructor TFrGame.Destroy;
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
  if Assigned(Kysts) then
    begin
      Kysts.Free;
      Kysts := nil;
    end;
  inherited;
end;

procedure TFrGame.NewWawe;
begin
  if not Assigned(Korovans) then
    Korovans := TKorovans.Create;
  Korovans.Clear;
  Inc(Wave);
  Schet := 0;
  Price := Price + 5;
  Poligon := 100;
  Chose := 1;
  TimMain.Enabled := False;
end;

procedure TFrGame.SBPauseClick(Sender: TObject);
begin
  TimMain.Enabled := False;
end;

procedure TFrGame.PBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
  var line: Integer;
      fl: Boolean;
      LGr: TGr;
begin
  fl := false;
  if (Yobi-Price >=0) then
    begin
      if Assigned(Grs) then
        begin
          if ((Y<=PBox.Height / 11 *2) and (Y>=PBox.Height / 11)) then
            begin
              line := 1;
              fl := true;
            end;
          if ((Y<=PBox.Height / 11 *4) and (Y>=PBox.Height / 11 * 3)) then
            begin
              line := 2;
              fl := true;
            end;
          if ((Y<=PBox.Height / 11 *6) and (Y>=PBox.Height / 11 * 5)) then
            begin
              line := 3;
              fl := true;
            end;
          if ((Y<=PBox.Height / 11 *8) and (Y>=PBox.Height / 11 * 7)) then
            begin
              line := 4;
              fl := true;
            end;
        end;
      if Assigned(Grs) and fl = true then
        for LGr in Grs do
            if (LGr.Pos >= Round(X)-20) and (LGr.Pos <= Round(X) + 40)
            and (LGr.Road = line)  then
              begin
                fl := false;
              end;
      if fl = true then
        begin
          Grs.NewGr(round(X), line, Chose);
          Yobi := Yobi- Price;
        end
    end;
end;


procedure TFrGame.PBoxPaint(Sender: TObject; Canvas: TCanvas);
  var
    LKorovan:TKorovan;
    LGr: TGr;
    LBitmap: Tbitmap;
    LRectSource, LRectDest, LRectSource2: TRectF;
    LKol: Single;
    LKolit, i: Integer;
    LKyst: TKyst;
begin


    Canvas.Fill.Kind := TBrushKind.Solid;
    Canvas.Font.Family := 'Arial';
    Canvas.Font.Size := 14;
    Canvas.Font.Style := [TFontStyle.fsBold];
    Canvas.BeginScene();


    {LStream := TResourceStream.Create(HInstance,'Desert', RT_RCDATA);
    LBitmap := TBitmap.Create;
    LBitmap.LoadFromStream(LStream);
    LRectSource := LBitmap.BoundsF;
    LStream.Free;
    LRectDest := RectF(0, 0, PBox.Width, PBox.Height);
    Canvas.DrawBitmap(LBitmap, LRectSource, LRectDest, 1);
    LBitmap.Free;
    }

    Canvas.Stroke.Kind := TBrushKind.Solid;
    Canvas.Stroke.Color := TAlphaColors.Black;
    Canvas.Stroke.Thickness :=5;
    Canvas.DrawRect (RectF(0, PBox.Height / 11 , PBox.Width, Pbox.Height / 11 * 2),  0, 0, [], 1);
    Canvas.DrawRect (RectF(0, PBox.Height / 11 * 3, PBox.Width, Pbox.Height / 11 * 4),  0, 0, [], 1);
    Canvas.DrawRect (RectF(0, PBox.Height / 11 * 5, PBox.Width, Pbox.Height / 11 * 6),  0, 0, [], 1);
    Canvas.DrawRect (RectF(0, PBox.Height / 11 * 7, PBox.Width, Pbox.Height / 11 * 8),  0, 0, [], 1);

    LRectSource := BitPicture[0].BoundsF;
    LKolit := 41;
    for i:=1 to LKolit do
      begin
        LRectDest := RectF(i * 50 - 50, PBox.Height / 11 , i * 50, Pbox.Height / 11 * 2);
        Canvas.DrawBitmap(BitPicture[0], LRectSource, LRectDest, 1);
        LRectDest := RectF(i * 50 - 50, PBox.Height / 11 * 3, i * 50, Pbox.Height / 11 * 4);
        Canvas.DrawBitmap(BitPicture[0], LRectSource, LRectDest, 1);
        LRectDest := RectF(i * 50 - 50, PBox.Height / 11 *5, i * 50, Pbox.Height / 11 * 6);
        Canvas.DrawBitmap(BitPicture[0], LRectSource, LRectDest, 1);
        LRectDest := RectF(i * 50 - 50, PBox.Height / 11 *7, i * 50, Pbox.Height / 11 * 8);
        Canvas.DrawBitmap(BitPicture[0], LRectSource, LRectDest, 1);
      end;
    LBitmap.Free;

    Canvas.Fill.Color := TAlphaColors.Black;
    Canvas.FillText(RectF(0, 0, 70, 30),'Wave: ' + Wave.ToString,
    False, 1, [], TTextAlign.Trailing);
    Canvas.FillText(RectF(90, 0, 160,30),'Yobi: ' + Yobi.ToString,
    False, 1, [], TTextAlign.Center);
    Canvas.FillText(RectF(180, 0, 270,30),'Your Hp: ' + HP.ToString,
    False, 1, [], TTextAlign.Center);

     LRectSource := BitPicture[2].BoundsF;
     LRectSource2 := BitPicture[3].BoundsF;
     if Assigned(Grs) then
     for LGr in Grs do
        begin
          if LGr.Setcl = 1 then
            begin
              LRectDest := RectF(LGr.Pos-10, PBox.Height / 11 *(LGr.Road*2-1) - PBox.Height / 15,
              LGr.Pos+ 20, PBox.Height / 11 *(LGr.Road*2)-PBox.Height / 15);
              Canvas.DrawBitmap(BitPicture[2], LRectSource, LRectDest, 1);
            end;
          if LGr.Setcl = 2 then
            begin
              LRectDest := RectF(LGr.Pos-20, PBox.Height / 11 *(LGr.Road*2-1) - PBox.Height / 15,
              LGr.Pos + 20, PBox.Height / 11 *(LGr.Road*2) - PBox.Height / 15);
              Canvas.DrawBitmap(BitPicture[3], LRectSource2, LRectDest, 1);
            end;
        end;
     LRectDest := RectF(30, PBox.Height / 11 * 9 + PBox.Height / 50, 60, PBox.Height / 11 *10 + PBox.Height / 50);
     Canvas.DrawBitmap(BitPicture[2], LRectSource, LRectDest, 1);
     LRectDest := RectF(100, PBox.Height / 11 * 9 + PBox.Height / 50, 140, PBox.Height / 11 * 10 + PBox.Height / 50);
     Canvas.DrawBitmap(BitPicture[3], LRectSource2, LRectDest, 1);

    LRectSource := BitPicture[4].BoundsF;
     if Assigned(Kysts) then
     for LKyst in Kysts do
        begin
          LRectDest := RectF(LKyst.Pos, PBox.Height / 11 *(LKyst.Road*2-1) - PBox.Height / 20,
            LKyst.PosK, PBox.Height / 11 *(LKyst.Road*2) - PBox.Height / 15);
          Canvas.DrawBitmap(BitPicture[4], LRectSource, LRectDest, 1);
        end;


     LRectSource := BitPicture[1].BoundsF;
     if Assigned(Korovans) then
     for LKorovan in Korovans do
        begin
          LRectDest := RectF(LKorovan.Pos - PBox.Width / 30, PBox.Height / 11 *(LKorovan.Road*2-1),
            LKorovan.Pos + PBox.Width / 30, PBox.Height / 11 *(LKorovan.Road*2));
          Canvas.DrawBitmap(BitPicture[1], LRectSource, LRectDest, 1);
        end;
    Canvas.Fill.Color := TAlphaColors.Black;
    if Poligon > 0 then
      begin
        Canvas.Font.Family := 'Arial';
        Canvas.Font.Size := 50;
        Canvas.Font.Style := [TFontStyle.fsBold];
        Canvas.FillText(RectF(0, 0, PBox.Width,PBox.Height),'New Wave: ' + Wave.ToString,
        False, 1, [], TTextAlign.Center);
      end;

    Canvas.EndScene;
end;

procedure TFrGame.SBPlayClick(Sender: TObject);
begin
  TimMain.Enabled := True;
end;

end.
