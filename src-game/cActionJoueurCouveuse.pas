unit cActionJoueurCouveuse;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  templateDialogBox, cBoiteDeDialogue_370x370, FMX.Objects, fEcranDuJeu,
  uPartieEnCours, FMX.Layouts, cBoutonMenu, FMX.Ani;

type
  TcadActionJoueurCouveuse = class(TtplDialogBox)
    zoneDeTexte: TRectangle;
    Text1: TText;
    GridPanelLayout1: TGridPanelLayout;
    btnOui: TcadBoutonMenu;
    btnNon: TcadBoutonMenu;
    procedure btnNonClick(Sender: TObject);
    procedure btnOuiClick(Sender: TObject);
  private
    FPartieEnCours: TPartieEnCours;
    FCouveuse: TCouveuse;
    procedure SetCouveuse(const Value: TCouveuse);
    procedure SetPartieEnCours(const Value: TPartieEnCours);
    { D�clarations priv�es }
  public
    { D�clarations publiques }
    property Couveuse: TCouveuse read FCouveuse write SetCouveuse;
    property PartieEnCours: TPartieEnCours read FPartieEnCours
      write SetPartieEnCours;

    procedure ClicSurBoutonParDefautOuRETURN; override;
    procedure ClicSurBoutonCancelOuESCAPE; override;

    class function Execute(AParent: TfrmEcranDuJeu;
      APartieEnCours: TPartieEnCours; ACouveuse: TCouveuse)
      : TcadActionJoueurCouveuse;

    constructor Create(AOwner: TComponent); override;
  end;

var
  cadActionJoueurCouveuse: TcadActionJoueurCouveuse;

implementation

{$R *.fmx}

uses cInventaireCouveuse;
{ TcadActionJoueurCouveuse }

procedure TcadActionJoueurCouveuse.btnNonClick(Sender: TObject);
begin
  close;
end;

procedure TcadActionJoueurCouveuse.btnOuiClick(Sender: TObject);
var
  NbPlacesDisposDansCouveuse: integer;
  NbOeufsTransferes: integer;
begin
  // On cherche combien d'oeufs peuvent passer du joueur � la couveuse
  NbPlacesDisposDansCouveuse := FCouveuse.NbOeufsEnGestationMax -
    FCouveuse.NbOeufsEnGestation;
  if (NbPlacesDisposDansCouveuse < FPartieEnCours.NbOeufsSurJoueur) then
    NbOeufsTransferes := NbPlacesDisposDansCouveuse
  else
    NbOeufsTransferes := FPartieEnCours.NbOeufsSurJoueur;

  // On bascule les oeufs de l'un vers l'autre
  FPartieEnCours.NbOeufsSurJoueur := FPartieEnCours.NbOeufsSurJoueur -
    NbOeufsTransferes;
  FCouveuse.NbOeufsEnGestation := FCouveuse.NbOeufsEnGestation +
    NbOeufsTransferes;

  // On ferme la boite de dialogue
  close;

  // TODO : une fois le transfert des oeufs effectu�s entre le joueur et la couveuse, afficher l'inventaire de la couveuse ou une animation ou autre chose
end;

procedure TcadActionJoueurCouveuse.ClicSurBoutonCancelOuESCAPE;
begin
  btnNonClick(btnNon);
end;

procedure TcadActionJoueurCouveuse.ClicSurBoutonParDefautOuRETURN;
begin
  btnOuiClick(btnOui);
end;

constructor TcadActionJoueurCouveuse.Create(AOwner: TComponent);
begin
  inherited;
  FAfficheBoutonFermer := false;
end;

class function TcadActionJoueurCouveuse.Execute(AParent: TfrmEcranDuJeu;
  APartieEnCours: TPartieEnCours; ACouveuse: TCouveuse)
  : TcadActionJoueurCouveuse;
begin
  result := nil;
  if assigned(AParent) and assigned(APartieEnCours) and assigned(ACouveuse) then
  begin
    result := TcadActionJoueurCouveuse.Create(AParent);
    try
      result.Parent := AParent;
      result.Couveuse := ACouveuse;
      result.PartieEnCours := APartieEnCours;
    except
      result.free;
      result := nil;
    end;
  end;
end;

procedure TcadActionJoueurCouveuse.SetCouveuse(const Value: TCouveuse);
begin
  FCouveuse := Value;
end;

procedure TcadActionJoueurCouveuse.SetPartieEnCours
  (const Value: TPartieEnCours);
begin
  FPartieEnCours := Value;
end;

end.
