unit cToolButtons;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  TcadToolButtons = class(TFrame)
    Background: TRectangle;
    SVG: TPath;
  private
    FisActif: boolean;
    procedure SetisActif(const Value: boolean);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property isActif: boolean read FisActif write SetisActif;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}
{ TcadToolButtons }

constructor TcadToolButtons.Create(AOwner: TComponent);
begin
  inherited;
  isActif := false;
end;

procedure TcadToolButtons.SetisActif(const Value: boolean);
begin
  FisActif := Value;
  if FisActif then
  begin
    Background.Stroke.Thickness := 5;
    Background.Stroke.Color := talphacolors.Green;
  end
  else
  begin
    Background.Stroke.Thickness := 1;
    Background.Stroke.Color := talphacolors.black;
  end;
end;

end.
