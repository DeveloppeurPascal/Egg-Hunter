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
  File last update : 2025-02-09T12:07:49.664+01:00
  Signature : fa999b31191f8ea5fd0819280c3353d332804b88
  ***************************************************************************
*)

unit cInventaireJoueur;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  templateDialogBox,
  cBoiteDeDialogue_370x370,
  FMX.Objects,
  uPartieEnCours,
  cLabeledProgressBar,
  cBoutonMenu,
  FMX.Ani,
  fMain;

type
  TcadInventaireJoueur = class(TtplDialogBox)
    pbOeufs: TcadLabeledProgressBar;
  private
    FPartieEnCours: TPartieEnCours;
    procedure SetPartieEnCours(const Value: TPartieEnCours);
    { Déclarations privées }
  public
    { Déclarations publiques }
    // TODO : à changer en joueur lorsque le joueur sera une classe plutôt que des propriétés de la partie
    property PartieEnCours: TPartieEnCours read FPartieEnCours
      write SetPartieEnCours;

    /// <summary>
    /// Met à jour la progress bar du nombre d'oeufs
    /// </summary>
    procedure RefreshNbOeufs(ANbOeufs, ANboeufsMax: integer);

    /// <summary>
    /// gère l'affichage de la fenêtre et de son contenu
    /// </summary>
    class function Execute(AParent: TfrmMain; APartieEnCours: TPartieEnCours)
      : TcadInventaireJoueur;
  end;

var
  cadInventaireJoueur: TcadInventaireJoueur;

implementation

{$R *.fmx}
{ TcadInventaireJoueur }

class function TcadInventaireJoueur.Execute(AParent: TfrmMain;
  APartieEnCours: TPartieEnCours): TcadInventaireJoueur;
begin
  result := nil;
  if assigned(AParent) and assigned(APartieEnCours) then
  begin
    result := TcadInventaireJoueur.Create(AParent);
    try
      result.Parent := AParent;
      result.PartieEnCours := APartieEnCours;
    except
      result.free;
      result := nil;
    end;
  end;
end;

procedure TcadInventaireJoueur.RefreshNbOeufs(ANbOeufs, ANboeufsMax: integer);
var
  pourcent: integer;
begin
  if (ANboeufsMax < 1) then
    ANboeufsMax := 1;
  if (ANbOeufs < 0) then
    ANbOeufs := 0;

  pbOeufs.MaxValue := ANboeufsMax;
  pbOeufs.Value := ANbOeufs;

  pourcent := (ANbOeufs * 100) div ANboeufsMax;
  case pourcent of
    0 .. 59:
      pbOeufs.Color := TcadLabeledProgressBarColor.vert;
    60 .. 80:
      pbOeufs.Color := TcadLabeledProgressBarColor.jaune;
  else
    pbOeufs.Color := TcadLabeledProgressBarColor.rouge;
  end;
end;

procedure TcadInventaireJoueur.SetPartieEnCours(const Value: TPartieEnCours);
begin
  FPartieEnCours := Value;
  if (FPartieEnCours <> nil) then
  begin
    RefreshNbOeufs(FPartieEnCours.NbOeufsSurJoueur,
      FPartieEnCours.NbOeufsSurJoueurMaxi);
  end;
end;

end.
