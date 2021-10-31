unit UMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, UMain, FMX.Objects;

type
  TFrMenu = class(TFrame)
    Play: TButton;
    Exit: TButton;
    PaintBox1: TPaintBox;
    Text1: TText;
    procedure ExitClick(Sender: TObject);
    procedure PlayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses UGame;

{$R *.fmx}

procedure TFrMenu.ExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrMenu.PlayClick(Sender: TObject);
begin
  SetFrame (TFrGame);
end;

end.
