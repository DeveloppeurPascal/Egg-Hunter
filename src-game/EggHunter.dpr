program EggHunter;
uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uDMMap in 'uDMMap.pas' {DMMap: TDataModule},
  fEcranDuJeu in 'fEcranDuJeu.pas' {frmEcranDuJeu},
  uPartieEnCours in 'uPartieEnCours.pas',
  cBoutonMenu in '..\src-level-editor\cBoutonMenu.pas' {cadBoutonMenu: TFrame},
  cBoiteDeDialogue_370x370 in 'cBoiteDeDialogue_370x370.pas' {cadBoiteDeDialogue_370x370: TFrame},
  cLabeledProgressBar in 'cLabeledProgressBar.pas' {cadLabeledProgressBar: TFrame},
  templateDialogBox in 'templateDialogBox.pas' {tplDialogBox: TFrame},
  cInventaireJoueur in 'cInventaireJoueur.pas' {cadInventaireJoueur: TFrame},
  cInventaireCouveuse in 'cInventaireCouveuse.pas' {cadInventaireCouveuse: TFrame},
  cActionJoueurCouveuse in 'cActionJoueurCouveuse.pas' {cadActionJoueurCouveuse: TFrame},
  cEcranCreditsDuJeu in 'cEcranCreditsDuJeu.pas' {cadEcranCreditsDuJeu: TFrame},
  uVersionDuProgramme in 'uVersionDuProgramme.pas',
  cEcranChargerPartieExistante in 'cEcranChargerPartieExistante.pas' {cadEcranChargerPartieExistante: TFrame},
  uMusic in 'uMusic.pas',
  uBruitages in 'uBruitages.pas',
  cEcranOptionsDuJeu in 'cEcranOptionsDuJeu.pas' {cadEcranOptionsDuJeu: TFrame},
  cCheckbox in 'cCheckbox.pas' {cadCheckbox: TFrame},
  uConfig in 'uConfig.pas',
  cTrackbar in 'cTrackbar.pas' {cadTrackBar: TFrame},
  cJoypad in 'cJoypad.pas' {cadJoypad: TFrame},
  cadBoutonOption in 'cadBoutonOption.pas' {cBoutonOption: TFrame},
  Olf.RTL.Params in '..\lib-externes\librairies\Olf.RTL.Params.pas',
  Gamolf.FMX.MusicLoop in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.MusicLoop.pas',
  Olf.FMX.TextImageFrame in '..\lib-externes\librairies\Olf.FMX.TextImageFrame.pas' {OlfFMXTextImageFrame: TFrame},
  udmAdobeStock_47191065orange_gris in '..\assets\AdobeStock\udmAdobeStock_47191065orange_gris.pas' {dmAdobeStock_47191065orange_gris: TDataModule};

{$R *.res}
begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDMMap, DMMap);
  Application.CreateForm(TdmAdobeStock_47191065orange_gris, dmAdobeStock_47191065orange_gris);
  Application.Run;
end.
