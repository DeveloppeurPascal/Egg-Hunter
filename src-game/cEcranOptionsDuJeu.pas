unit cEcranOptionsDuJeu;

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
  FMX.Ani,
  cBoiteDeDialogue_370x370,
  FMX.Objects,
  cCheckbox,
  FMX.Layouts,
  cTrackbar;

type
  TcadEcranOptionsDuJeu = class(TtplDialogBox)
    paramMusique: TLayout;
    txtMusique: TText;
    cbMusique: TcadCheckbox;
    paramBruitages: TLayout;
    txtBruitages: TText;
    cbBruitages: TcadCheckbox;
    tbVolumeMusique: TcadTrackBar;
    tbVolumeBruitages: TcadTrackBar;
    paramControlesTactiles: TLayout;
    txtControlesTactiles: TText;
    cbControlesTactiles: TcadCheckbox;
    procedure cbMusiqueClick(Sender: TObject);
    procedure cbBruitagesClick(Sender: TObject);
    procedure tbVolumeMusiqueClick(Sender: TObject);
    procedure tbVolumeBruitagesClick(Sender: TObject);
    procedure cbControlesTactilesClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  cadEcranOptionsDuJeu: TcadEcranOptionsDuJeu;

implementation

{$R *.fmx}

uses
  uConfig,
  uBruitages,
  uMusic,
  Olf.RTL.Params;

procedure TcadEcranOptionsDuJeu.cbBruitagesClick(Sender: TObject);
begin
  cbBruitages.FrameClick(Sender);
  tconfig.BruitagesOnOff := cbBruitages.isChecked;
  if not cbBruitages.isChecked then
    CouperLesBruitages;
end;

procedure TcadEcranOptionsDuJeu.cbControlesTactilesClick(Sender: TObject);
begin
  cbControlesTactiles.FrameClick(Sender);
  tconfig.InterfaceTactileOnOff := cbControlesTactiles.isChecked;
end;

procedure TcadEcranOptionsDuJeu.cbMusiqueClick(Sender: TObject);
begin
  cbMusique.FrameClick(Sender);
  tconfig.MusiqueDAmbianceOnOff := cbMusique.isChecked;
  if cbMusique.isChecked then
  begin
    if (not TMusiques.Ambiance.IsPlaying) then
      TMusiques.Ambiance.play;
  end
  else
    TMusiques.Ambiance.stop;
end;

constructor TcadEcranOptionsDuJeu.Create(AOwner: TComponent);
begin
  inherited;
  cbMusique.isChecked := tconfig.MusiqueDAmbianceOnOff;
  tbVolumeMusique.Value := tconfig.MusiqueDAmbianceVolume;
  cbBruitages.isChecked := tconfig.BruitagesOnOff;
  tbVolumeBruitages.Value := tconfig.BruitagesVolume;
  cbControlesTactiles.isChecked := tconfig.InterfaceTactileOnOff;
end;

destructor TcadEcranOptionsDuJeu.Destroy;
begin
  tParams.save;
  inherited;
end;

procedure TcadEcranOptionsDuJeu.tbVolumeBruitagesClick(Sender: TObject);
begin
  tconfig.BruitagesVolume := tbVolumeBruitages.Value;
  JouerBruitage(TTypeBruitage.Beep);
end;

procedure TcadEcranOptionsDuJeu.tbVolumeMusiqueClick(Sender: TObject);
begin
  tconfig.MusiqueDAmbianceVolume := tbVolumeMusique.Value;
  TMusiques.Ambiance.Volume := tbVolumeMusique.Value;
  JouerBruitage(TTypeBruitage.Beep);
end;

end.
