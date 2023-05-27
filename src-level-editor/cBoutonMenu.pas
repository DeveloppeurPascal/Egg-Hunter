unit cBoutonMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  TcadBoutonMenu = class(TFrame)
    Background: TRectangle;
    Text: TText;
    Background_On: TRectangle;
    Text_On: TText;
    procedure FrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FrameMouseLeave(Sender: TObject);
    procedure FrameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
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
{ TcadBoutonMenu }

constructor TcadBoutonMenu.Create(AOwner: TComponent);
begin
  inherited;
  name := '';
  // On exécute le paramétrage des éléments après la création et le chargement du .DFM/.FMX
  tthread.ForceQueue(nil,
    procedure
    begin
      isActif := false;
      if assigned(onclick) then
        opacity := 1
      else
        opacity := 0.2;
    end);
end;

procedure TcadBoutonMenu.FrameMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Single);
begin
  isActif := true;
end;

procedure TcadBoutonMenu.FrameMouseLeave(Sender: TObject);
begin
  isActif := false;
end;

procedure TcadBoutonMenu.FrameMouseUp(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Single);
begin
  isActif := false;
end;

procedure TcadBoutonMenu.SetisActif(

  const Value: boolean);
begin
  FisActif := Value;
  Background.visible := not FisActif;
  Text_On.Text := Text.Text;
  Background_On.visible := FisActif;
end;

end.
