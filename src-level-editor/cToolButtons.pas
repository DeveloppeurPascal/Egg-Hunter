(* C2PP
  ***************************************************************************

  Egg Hunter

  Copyright 2021-2025 Patrick Prémartin under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Egg Hunter is an RPG sprinkled with duck breeding.

  You have to harvest their eggs, incubate them until they hatch, and
  explode production quotas (just for fun).

  This repository contains the game source and its level editor.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://egghunter.gamolf.fr/

  Project site :
  https://github.com/DeveloppeurPascal/Egg-Hunter

  ***************************************************************************
  File last update : 2025-02-09T12:07:49.678+01:00
  Signature : 8da04af8db377ad05a0873a65f5403bcd54e02a8
  ***************************************************************************
*)

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
