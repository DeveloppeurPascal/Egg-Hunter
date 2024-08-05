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
/// File last update : 2024-08-05T19:47:10.642+02:00
/// Signature : e2b903b25d0d28dda5d5188d1385583a0733ad3d
/// ***************************************************************************
/// </summary>

program EggHunter;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain} ,
  uDMMap in 'uDMMap.pas' {DMMap: TDataModule} ,
  uPartieEnCours in 'uPartieEnCours.pas',
  cBoutonMenu in '..\src-level-editor\cBoutonMenu.pas' {cadBoutonMenu: TFrame} ,
  cBoiteDeDialogue_370x370
    in 'cBoiteDeDialogue_370x370.pas' {cadBoiteDeDialogue_370x370: TFrame} ,
  cLabeledProgressBar
    in 'cLabeledProgressBar.pas' {cadLabeledProgressBar: TFrame} ,
  templateDialogBox in 'templateDialogBox.pas' {tplDialogBox: TFrame} ,
  cInventaireJoueur in 'cInventaireJoueur.pas' {cadInventaireJoueur: TFrame} ,
  cInventaireCouveuse
    in 'cInventaireCouveuse.pas' {cadInventaireCouveuse: TFrame} ,
  cActionJoueurCouveuse
    in 'cActionJoueurCouveuse.pas' {cadActionJoueurCouveuse: TFrame} ,
  cEcranCreditsDuJeu
    in 'cEcranCreditsDuJeu.pas' {cadEcranCreditsDuJeu: TFrame} ,
  uVersionDuProgramme in 'uVersionDuProgramme.pas',
  cEcranChargerPartieExistante
    in 'cEcranChargerPartieExistante.pas' {cadEcranChargerPartieExistante: TFrame} ,
  uMusic in 'uMusic.pas',
  uBruitages in 'uBruitages.pas',
  cEcranOptionsDuJeu
    in 'cEcranOptionsDuJeu.pas' {cadEcranOptionsDuJeu: TFrame} ,
  cCheckbox in 'cCheckbox.pas' {cadCheckbox: TFrame} ,
  uConfig in 'uConfig.pas',
  cTrackbar in 'cTrackbar.pas' {cadTrackBar: TFrame} ,
  cJoypad in 'cJoypad.pas' {cadJoypad: TFrame} ,
  cadBoutonOption in 'cadBoutonOption.pas' {cBoutonOption: TFrame} ,
  Olf.RTL.Params in '..\lib-externes\librairies\src\Olf.RTL.Params.pas',
  Gamolf.FMX.MusicLoop
    in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.MusicLoop.pas',
  Olf.FMX.TextImageFrame
    in '..\lib-externes\librairies\src\Olf.FMX.TextImageFrame.pas' {OlfFMXTextImageFrame: TFrame} ,
  udmAdobeStock_47191065orange_noir
    in '..\_PRIVATE\assets\AdobeStock\udmAdobeStock_47191065orange_noir.pas' {dmAdobeStock_47191065orange_noir: TDataModule} ,
  udmAdobeStock_460990606
    in '..\_PRIVATE\assets\AdobeStock\udmAdobeStock_460990606.pas' {dmAdobeStock_460990606: TDataModule} ,
  Gamolf.FMX.Joystick
    in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.Joystick.pas',
  Gamolf.RTL.Joystick.DirectInput.Win
    in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.DirectInput.Win.pas',
  Gamolf.RTL.Joystick.Mac
    in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.Mac.pas',
  Gamolf.RTL.Joystick
    in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.pas',
  iOSapi.GameController
    in '..\lib-externes\Delphi-Game-Engine\src\iOSapi.GameController.pas',
  Macapi.GameController
    in '..\lib-externes\Delphi-Game-Engine\src\Macapi.GameController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape,
    TFormOrientation.InvertedLandscape];
  Application.CreateForm(TdmAdobeStock_47191065orange_noir,
    dmAdobeStock_47191065orange_noir);
  Application.CreateForm(TdmAdobeStock_460990606, dmAdobeStock_460990606);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
