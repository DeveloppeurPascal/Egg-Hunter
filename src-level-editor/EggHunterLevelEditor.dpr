program EggHunterLevelEditor;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uDMSpriteSheets in 'uDMSpriteSheets.pas' {DMSpriteSheets: TDataModule},
  uDMMap in '..\src-game\uDMMap.pas' {DMMap: TDataModule},
  fMapLoad in 'fMapLoad.pas' {frmMapLoad},
  fMapEdit in 'fMapEdit.pas' {frmMapEdit},
  fMapAdd in 'fMapAdd.pas' {frmMapAdd},
  cBoutonMenu in 'cBoutonMenu.pas' {cadBoutonMenu: TFrame},
  cToolButtons in 'cToolButtons.pas' {cadToolButtons: TFrame},
  cSpriteButton in 'cSpriteButton.pas' {cadSpriteButton: TFrame},
  fMapSpriteAdd in 'fMapSpriteAdd.pas' {frmMapSpriteAdd},
  cBoiteDeDialogue_370x370 in '..\src-game\cBoiteDeDialogue_370x370.pas' {cadBoiteDeDialogue_370x370: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDMSpriteSheets, DMSpriteSheets);
  Application.CreateForm(TDMMap, DMMap);
  Application.Run;
end.
