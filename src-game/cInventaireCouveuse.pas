unit cInventaireCouveuse;

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
  FMX.Ani,
  fMain;

type
  TcadInventaireCouveuse = class(TtplDialogBox)
    pbNbOeufsDansLaCouveuse: TcadLabeledProgressBar;
    pbGestation: TcadLabeledProgressBar;
  private
    FCouveuse: TCouveuse;
    procedure SetCouveuse(const Value: TCouveuse);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property Couveuse: TCouveuse read FCouveuse write SetCouveuse;

    /// <summary>
    /// Met à jour la progress bar du nombre d'oeufs
    /// </summary>
    procedure RefreshNbOeufs(ANbOeufs, ANboeufsMax: integer);

    /// <summary>
    /// Met à jour le temps de gestation en cours
    /// </summary>
    procedure RefreshDureeGestation(ATempsRestant, ATempsMax: integer);

    /// <summary>
    /// gère l'affichage de la fenêtre et de son contenu
    /// </summary>
    class function Execute(AParent: TfrmMain; ACouveuse: TCouveuse)
      : TcadInventaireCouveuse;

    procedure OnCouveuseNbOeufsChange(Couveuse: TCouveuse);
    procedure OnCouveuseDureeAvantEclosionChange(Couveuse: TCouveuse);
    destructor Destroy; override;
  end;

var
  cadInventaireCouveuse: TcadInventaireCouveuse;

implementation

{$R *.fmx}
{ TcadInventaireCouveuse }

destructor TcadInventaireCouveuse.Destroy;
begin
  if assigned(Couveuse) then
  begin
    Couveuse.OnCouveuseNbOeufsChange := nil;
    Couveuse.OnCouveuseDureeAvantEclosionChange := nil;
  end;

  inherited;
end;

class function TcadInventaireCouveuse.Execute(AParent: TfrmMain;
  ACouveuse: TCouveuse): TcadInventaireCouveuse;
begin
  result := nil;
  if assigned(AParent) and assigned(ACouveuse) then
  begin
    result := TcadInventaireCouveuse.Create(AParent);
    try
      result.Parent := AParent;
      result.Couveuse := ACouveuse;
      result.Couveuse.OnCouveuseNbOeufsChange := result.OnCouveuseNbOeufsChange;
      result.Couveuse.OnCouveuseDureeAvantEclosionChange :=
        result.OnCouveuseDureeAvantEclosionChange;
    except
      result.free;
      result := nil;
    end;
  end;
end;

procedure TcadInventaireCouveuse.OnCouveuseDureeAvantEclosionChange
  (Couveuse: TCouveuse);
begin
  RefreshDureeGestation(Couveuse.DureeAvantEclosion, CTempsDeGestation);
end;

procedure TcadInventaireCouveuse.OnCouveuseNbOeufsChange(Couveuse: TCouveuse);
begin
  RefreshNbOeufs(Couveuse.NbOeufsEnGestation, Couveuse.NbOeufsEnGestationMax);
end;

procedure TcadInventaireCouveuse.RefreshDureeGestation(ATempsRestant,
  ATempsMax: integer);
var
  pourcent: integer;
begin
  if (ATempsMax < 1) then
    ATempsMax := 1;
  if (ATempsRestant < 0) then
    ATempsRestant := 0;

  pbGestation.ShowValueInText := false;

  pbGestation.MaxValue := ATempsMax;
  ATempsRestant := ATempsMax - ATempsRestant;
  pbGestation.Value := ATempsRestant;

  pourcent := (ATempsRestant * 100) div ATempsMax;
  case pourcent of
    0 .. 49:
      pbGestation.Color := TcadLabeledProgressBarColor.rouge;
    50 .. 74:
      pbGestation.Color := TcadLabeledProgressBarColor.jaune;
  else
    pbGestation.Color := TcadLabeledProgressBarColor.vert;
  end;
end;

procedure TcadInventaireCouveuse.RefreshNbOeufs(ANbOeufs, ANboeufsMax: integer);
var
  pourcent: integer;
begin
  if (ANboeufsMax < 1) then
    ANboeufsMax := 1;
  if (ANbOeufs < 0) then
    ANbOeufs := 0;

  pbNbOeufsDansLaCouveuse.MaxValue := ANboeufsMax;
  pbNbOeufsDansLaCouveuse.Value := ANbOeufs;

  pourcent := (ANbOeufs * 100) div ANboeufsMax;
  case pourcent of
    0 .. 59:
      pbNbOeufsDansLaCouveuse.Color := TcadLabeledProgressBarColor.vert;
    60 .. 80:
      pbNbOeufsDansLaCouveuse.Color := TcadLabeledProgressBarColor.jaune;
  else
    pbNbOeufsDansLaCouveuse.Color := TcadLabeledProgressBarColor.rouge;
  end;

  // N'affiche la progression de la gestation en cours que s'il y a un oeuf en gestation
  pbGestation.Visible := FCouveuse.NbOeufsEnGestation > 0;
end;

procedure TcadInventaireCouveuse.SetCouveuse(const Value: TCouveuse);
begin
  FCouveuse := Value;
  if (FCouveuse <> nil) then
  begin
    RefreshNbOeufs(FCouveuse.NbOeufsEnGestation,
      FCouveuse.NbOeufsEnGestationMax);
    RefreshDureeGestation(FCouveuse.DureeAvantEclosion, CTempsDeGestation);
  end;
end;

end.
