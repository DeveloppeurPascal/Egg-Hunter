/// <summary>
/// ***************************************************************************
///
/// Egg Hunter
///
/// Copyright 2021-2024 Patrick Prémartin under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// Egg Hunter is an RPG sprinkled with duck breeding.
///
/// You have to harvest their eggs, incubate them until they hatch, and
/// explode production quotas (just for fun).
///
/// This repository contains the game source and its level editor.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://egghunter.gamolf.fr/
///
/// Project site :
/// https://github.com/DeveloppeurPascal/Egg-Hunter
///
/// ***************************************************************************
/// File last update : 2024-08-05T19:36:12.403+02:00
/// Signature : d8b21838c80c0d41620a937a2b1130789b62fd0d
/// ***************************************************************************
/// </summary>

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
