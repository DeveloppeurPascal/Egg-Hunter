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
  File last update : 2025-10-28T17:49:46.000+01:00
  Signature : 4b9d2cfde49b40cfc38e440ae88acfa01dec14c3
  ***************************************************************************
*)

program EggHunterLevelEditor;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uDMSpriteSheets in 'uDMSpriteSheets.pas' {DMSpriteSheets: TDataModule},
  uDMMap in '..\src\uDMMap.pas' {DMMap: TDataModule},
  fMapLoad in 'fMapLoad.pas' {frmMapLoad},
  fMapEdit in 'fMapEdit.pas' {frmMapEdit},
  fMapAdd in 'fMapAdd.pas' {frmMapAdd},
  cBoutonMenu in 'cBoutonMenu.pas' {cadBoutonMenu: TFrame},
  cToolButtons in 'cToolButtons.pas' {cadToolButtons: TFrame},
  cSpriteButton in 'cSpriteButton.pas' {cadSpriteButton: TFrame},
  fMapSpriteAdd in 'fMapSpriteAdd.pas' {frmMapSpriteAdd},
  cBoiteDeDialogue_370x370 in '..\src\cBoiteDeDialogue_370x370.pas' {cadBoiteDeDialogue_370x370: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDMSpriteSheets, DMSpriteSheets);
  Application.CreateForm(TDMMap, DMMap);
  Application.Run;
end.
