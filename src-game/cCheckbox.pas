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
  File last update : 2025-02-09T12:07:49.651+01:00
  Signature : d945e5f04d7438db12e9dfe5797b87996257499b
  ***************************************************************************
*)

unit cCheckbox;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ImgList, System.ImageList;

type
{$SCOPEDENUMS ON}
  TcadCheckboxType = (coche, croix);
  TcadCheckboxColor = (bleu, vert, rouge, jaune, gris);

  TcadCheckbox = class(TFrame)
    imgCheckbox: TImageList;
    CheckBox: TGlyph;
    procedure FrameClick(Sender: TObject);
  private
    FcbType: TcadCheckboxType;
    FisChecked: boolean;
    FcbColor: TcadCheckboxColor;
    procedure SetcbColor(const Value: TcadCheckboxColor);
    procedure SetcbType(const Value: TcadCheckboxType);
    procedure SetisChecked(const Value: boolean);
    { Déclarations privées }
    procedure RefreshImage;
  public
    { Déclarations publiques }
    property cbType: TcadCheckboxType read FcbType write SetcbType;
    property isChecked: boolean read FisChecked write SetisChecked;
    property cbColor: TcadCheckboxColor read FcbColor write SetcbColor;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses uBruitages;

constructor TcadCheckbox.Create(AOwner: TComponent);
begin
  inherited;
  isChecked := false;
  cbType := TcadCheckboxType.coche;
  cbColor := TcadCheckboxColor.vert;
end;

procedure TcadCheckbox.FrameClick(Sender: TObject);
begin
  isChecked := not isChecked;
end;

procedure TcadCheckbox.RefreshImage;
var
  img: integer;
begin
  if not FisChecked then
    CheckBox.ImageIndex := 0
  else
  begin
    img := 0;
    case FcbType of
      TcadCheckboxType.coche:
        img := 1; // bleu
      TcadCheckboxType.croix:
        img := 6; // bleu
    else
      raise Exception.Create('TcadCheckboxType not implemented');
    end;
    case FcbColor of
      TcadCheckboxColor.bleu:
        ;
      TcadCheckboxColor.vert:
        img := img + 1;
      TcadCheckboxColor.rouge:
        img := img + 2;
      TcadCheckboxColor.jaune:
        img := img + 3;
      TcadCheckboxColor.gris:
        img := img + 4;
    else
      raise Exception.Create('TcadCheckboxColor not implemented');
    end;
    CheckBox.ImageIndex := img;
  end;
end;

procedure TcadCheckbox.SetcbColor(const Value: TcadCheckboxColor);
begin
  FcbColor := Value;
  RefreshImage;
end;

procedure TcadCheckbox.SetcbType(const Value: TcadCheckboxType);
begin
  FcbType := Value;
  RefreshImage;
end;

procedure TcadCheckbox.SetisChecked(const Value: boolean);
begin
  if (FisChecked <> Value) then
  begin
    FisChecked := Value;
    JouerBruitage(TTypeBruitage.Beep);
  end;
  RefreshImage;
end;

end.
