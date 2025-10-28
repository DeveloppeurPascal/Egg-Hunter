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
  File last update : 2025-02-09T12:07:49.666+01:00
  Signature : 20c67315435f3e4801ca3d12de18bf838d5cbcd8
  ***************************************************************************
*)

unit cadBoutonOption;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Filter.Effects, FMX.Objects;

type
  TcBoutonOption = class(TFrame)
    btnImage: TRectangle;
    btnImageUpDown: TBevelEffect;
    OnOff: TSepiaEffect;
    procedure FrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FrameMouseLeave(Sender: TObject);
    procedure FrameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    procedure SetisActif(const Value: boolean);
    function GetisActif: boolean;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property isActif: boolean read GetisActif write SetisActif;
  end;

implementation

{$R *.fmx}

procedure TcBoutonOption.FrameMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  btnImageUpDown.Enabled := false;
end;

procedure TcBoutonOption.FrameMouseLeave(Sender: TObject);
begin
  btnImageUpDown.Enabled := true;
end;

procedure TcBoutonOption.FrameMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  btnImageUpDown.Enabled := true;
end;

function TcBoutonOption.GetisActif: boolean;
begin
  result := not OnOff.Enabled;
end;

procedure TcBoutonOption.SetisActif(const Value: boolean);
begin
  OnOff.Enabled := not Value;
end;

end.
