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
