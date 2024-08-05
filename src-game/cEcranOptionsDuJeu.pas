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
/// File last update : 2024-08-05T19:36:12.387+02:00
/// Signature : 3e03296c22bba2568a2083f2810e94dbf8b4c6cf
/// ***************************************************************************
/// </summary>

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
  Olf.RTL.Params,
  Gamolf.FMX.MusicLoop;

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
    if (not tmusicloop.Current.IsPlaying) then
      tmusicloop.Current.play;
  end
  else
    tmusicloop.Current.stop;
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
  TSoundList.Current.Volume := tconfig.BruitagesVolume;
  JouerBruitage(TTypeBruitage.Beep);
end;

procedure TcadEcranOptionsDuJeu.tbVolumeMusiqueClick(Sender: TObject);
begin
  tconfig.MusiqueDAmbianceVolume := tbVolumeMusique.Value;
  tmusicloop.Current.Volume := tconfig.MusiqueDAmbianceVolume;
  JouerBruitage(TTypeBruitage.Beep);
end;

end.
