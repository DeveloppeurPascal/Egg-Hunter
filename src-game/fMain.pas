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
/// Signature : b10e29d71bd3819f85fd19ded0db99bc0af07568
/// ***************************************************************************
/// </summary>

unit fMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  cBoutonMenu,
  FMX.Objects,
  cBoiteDeDialogue_370x370,
  templateDialogBox,
  uDMMap,
  FMX.Effects,
  cadBoutonOption,
  cJoypad,
  uPartieEnCours,
  Olf.FMX.TextImageFrame;

type
  TfrmMain = class(TForm)
    Menu: TcadBoiteDeDialogue_370x370;
    btnCreditsDuJeu: TcadBoutonMenu;
    btnFermer: TcadBoutonMenu;
    btnLancerUnePartie: TcadBoutonMenu;
    btnReglages: TcadBoutonMenu;
    btnReprendreUnePartie: TcadBoutonMenu;
    MainTimerLancePartieReprise: TTimer;
    ZoneFooter: TLayout;
    txtVersionDuProgramme: TText;
    ZIndexMenu: TLayout;
    GlowEffect1: TGlowEffect;
    ZoneTitle: TLayout;
    TitleEffect: TGlowEffect;
    MainScene: TLayout;
    GameScene: TLayout;
    zoneHeader: TLayout;
    btnEffetsSonoresOnOff: TcBoutonOption;
    btnPauseDuJeu: TcBoutonOption;
    btnMusiqueOnOff: TcBoutonOption;
    ZoneNbCanards: TLayout;
    BackgroundNbCanards: TRectangle;
    NbCanardsPicto: TPath;
    ZoneNbOeufs: TLayout;
    BackgroundNbOeufs: TRectangle;
    NbOeufsPicto: TPath;
    JoypadDeDroite: TcadJoypad;
    JoypadDeGauche: TcadJoypad;
    GameTimerCyceDeJeu: TTimer;
    TimerRefreshMap: TTimer;
    imgCurrentMap: TImage;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnFermerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLancerUnePartieClick(Sender: TObject);
    procedure btnCreditsDuJeuClick(Sender: TObject);
    procedure btnReprendreUnePartieClick(Sender: TObject);
    procedure btnReglagesClick(Sender: TObject);
    procedure MainTimerLancePartieRepriseTimer(Sender: TObject);
    procedure TimerRefreshMapTimer(Sender: TObject);
    procedure GameTimerCyceDeJeuTimer(Sender: TObject);
    procedure btnEffetsSonoresOnOffClick(Sender: TObject);
    procedure btnMusiqueOnOffClick(Sender: TObject);
    procedure btnPauseDuJeuClick(Sender: TObject);
    procedure FormSaveState(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure imgCurrentMapResized(Sender: TObject);
    procedure imgCurrentMapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    { Déclarations privées }
    FBoiteDeDialogue: TtplDialogBox;
    FNomDeFichierDePartieACharger: string;
    FNbOeufsOnMap: integer;
    FNbCanardsOnMap: integer;
    FKeyDPad: Word;
    procedure SetBoiteDeDialogue(const Value: TtplDialogBox);
    procedure ChargePartieExistante(NomDuFichier: string);
    procedure SetNomDeFichierDePartieACharger(const Value: string);
    procedure SetKeyDPad(const Value: Word);
    procedure SetNbCanardsOnMap(const Value: integer);
    procedure SetNbOeufsOnMap(const Value: integer);
    property NomDeFichierDePartieACharger: string
      read FNomDeFichierDePartieACharger write SetNomDeFichierDePartieACharger;
    procedure DisplayMainScene;
    procedure DisplayGameScene;
    procedure DisplayNothing;
  protected
    NbCanardsText: TOlfFMXTextImageFrame;
    NbOeufsText: TOlfFMXTextImageFrame;

    property NbCanardsOnMap: integer read FNbCanardsOnMap
      write SetNbCanardsOnMap;
    property NbOeufsOnMap: integer read FNbOeufsOnMap write SetNbOeufsOnMap;
    property KeyDPad: Word read FKeyDPad write SetKeyDPad;
    procedure VersLaGauche;
    procedure VersLaDroite;
    procedure VersLeHaut;
    procedure VersLeBas;
    procedure ClicSurCarte(X, Y: Single);
    function GetNumberNameForAdobeStock47191065Font
      (Sender: TOlfFMXTextImageFrame; AChar: Char): integer;
    procedure MoveWithDPadangle(dpad: Word);
    procedure GamePause;
    function isGameSceneDisplayed: boolean;
  public
    CurrentMap: TDMMap;
    PartieEnCours: TPartieEnCours;
    property BoiteDeDialogue: TtplDialogBox read FBoiteDeDialogue
      write SetBoiteDeDialogue;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  cEcranCreditsDuJeu,
  cEcranChargerPartieExistante,
  uMusic,
  cEcranOptionsDuJeu,
  uConfig,
  uVersionDuProgramme,
  udmAdobeStock_460990606,
  Gamolf.FMX.MusicLoop,
  cInventaireCouveuse,
  cInventaireJoueur,
  uBruitages,
  Olf.RTL.Params,
  udmAdobeStock_47191065orange_noir,
  Gamolf.RTL.Joystick,
  FMX.Platform;

procedure TfrmMain.btnCreditsDuJeuClick(Sender: TObject);
var
  f: TcadEcranCreditsDuJeu;
begin
  f := TcadEcranCreditsDuJeu.Create(self);
  f.parent := self;
  FBoiteDeDialogue := f;
  f.CloseCallBackProc := procedure
    begin
      FBoiteDeDialogue := nil;
    end;
end;

procedure TfrmMain.btnEffetsSonoresOnOffClick(Sender: TObject);
begin
  btnEffetsSonoresOnOff.isActif := not btnEffetsSonoresOnOff.isActif;

  TConfig.BruitagesOnOff := btnEffetsSonoresOnOff.isActif;
  tparams.save;

  if not btnEffetsSonoresOnOff.isActif then
    CouperLesBruitages;
end;

procedure TfrmMain.btnFermerClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.btnLancerUnePartieClick(Sender: TObject);
begin
  DisplayGameScene;
end;

procedure TfrmMain.btnMusiqueOnOffClick(Sender: TObject);
begin
  btnMusiqueOnOff.isActif := not btnMusiqueOnOff.isActif;

  TConfig.MusiqueDAmbianceOnOff := btnMusiqueOnOff.isActif;
  tparams.save;

  if btnMusiqueOnOff.isActif then
    tmusicloop.Current.play
  else
    tmusicloop.Current.Stop;
end;

procedure TfrmMain.btnPauseDuJeuClick(Sender: TObject);
begin
  GamePause;
end;

procedure TfrmMain.btnReglagesClick(Sender: TObject);
var
  f: TcadEcranOptionsDuJeu;
begin
  f := TcadEcranOptionsDuJeu.Create(self);
  f.parent := self;
  FBoiteDeDialogue := f;
  f.CloseCallBackProc := procedure
    begin
      FBoiteDeDialogue := nil;
    end;
end;

procedure TfrmMain.btnReprendreUnePartieClick(Sender: TObject);
var
  f: TcadEcranChargerPartieExistante;
begin
  f := TcadEcranChargerPartieExistante.Create(self);
  f.parent := self;
  FBoiteDeDialogue := f;
  f.CloseCallBackProc := procedure
    begin
      FBoiteDeDialogue := nil;
    end;
  f.onPartieChoisieEvent := ChargePartieExistante;
end;

procedure TfrmMain.ChargePartieExistante(NomDuFichier: string);
begin
  NomDeFichierDePartieACharger := NomDuFichier;
end;

procedure TfrmMain.ClicSurCarte(X, Y: Single);
var
  ColDansViewport, LigDansViewport: integer;
  ColDansMap, LigDansMap: integer;
  ZIndex: integer;
begin
  if not isGameSceneDisplayed then
    exit;

  // Conversion X,Y (pixels) en colonne/ligne sur le viewport
  ColDansViewport := trunc(X) div CurrentMap.SpriteWidth;
  // TODO : gérer niveau de zoom et bitmapscale
  ColDansMap := (ColDansViewport + CurrentMap.ViewportCol)
    mod CurrentMap.LevelMapcolCount;
  LigDansViewport := trunc(Y) div CurrentMap.SpriteHeight;
  // TODO : gérer niveau de zoom et bitmapscale
  LigDansMap := (LigDansViewport + CurrentMap.ViewportLig)
    mod CurrentMap.LevelMapRowCount;

  // Si on est dans la grille de la map
  if (LigDansMap >= 0) and (LigDansMap < CurrentMap.LevelMapRowCount) and
    (ColDansMap >= 0) and (ColDansMap < CurrentMap.LevelMapcolCount) then
    for ZIndex := 0 to CNbZIndex do
      if (CurrentMap.LevelMap[ColDansMap, LigDansMap].ZIndex[ZIndex] <> -1) then
        case CurrentMap.SpriteSheetElements
          [CurrentMap.LevelMap[ColDansMap, LigDansMap].ZIndex[ZIndex]]
          .TypeElement of
          TEggHunterElementType.Couveuse:
            FBoiteDeDialogue := TcadInventaireCouveuse.Execute(self,
              PartieEnCours.Couveuses.CouveuseAt(ColDansMap, LigDansMap));
          TEggHunterElementType.joueur:
            FBoiteDeDialogue := TcadInventaireJoueur.Execute(self,
              PartieEnCours);
        end;
end;

procedure TfrmMain.DisplayGameScene;
begin
  DisplayNothing;

  // remove previous game datas if any
  PartieEnCours.Free;

  // Nb Ducks initialization (number in game and displayed on screen)
  FNbCanardsOnMap := -1;
  if not assigned(NbCanardsText) then
  begin
    NbCanardsText := TOlfFMXTextImageFrame.Create(self);
    NbCanardsText.parent := ZoneNbCanards;
    NbCanardsText.align := talignlayout.Right;
    NbCanardsText.font := dmAdobeStock_47191065orange_noir.imagelist;
    NbCanardsText.LetterSpacing := 5;
    NbCanardsText.OnGetImageIndexOfUnknowChar :=
      GetNumberNameForAdobeStock47191065Font;
  end
  else
    NbCanardsText.text := '0';

  // Nb Eggs initialization (number in game and displayed on screen)
  FNbOeufsOnMap := -1;
  if not assigned(NbOeufsText) then
  begin
    NbOeufsText := TOlfFMXTextImageFrame.Create(self);
    NbOeufsText.parent := ZoneNbOeufs;
    NbOeufsText.align := talignlayout.Right;
    NbOeufsText.font := dmAdobeStock_47191065orange_noir.imagelist;
    NbOeufsText.LetterSpacing := 5;
    NbOeufsText.OnGetImageIndexOfUnknowChar :=
      GetNumberNameForAdobeStock47191065Font;
  end
  else
    NbOeufsText.text := '0';

  // Left pad
  JoypadDeGauche.Position.X := 10;
  JoypadDeGauche.Position.Y := gamescene.Height - JoypadDeGauche.height - 10;
  JoypadDeGauche.Anchors := [TAnchorKind.akBottom, TAnchorKind.akleft];
  JoypadDeGauche.Visible := TConfig.InterfaceTactileOnOff;

  // Right pad
  JoypadDeDroite.Position.X := gamescene.Width - JoypadDeDroite.Width - 10;
  JoypadDeDroite.Position.Y := gamescene.Height - JoypadDeDroite.height - 10;
  JoypadDeDroite.Anchors := [TAnchorKind.akBottom, TAnchorKind.akRight];
  JoypadDeDroite.Visible := TConfig.InterfaceTactileOnOff;

  btnEffetsSonoresOnOff.isActif := TConfig.BruitagesOnOff;
  btnMusiqueOnOff.isActif := TConfig.MusiqueDAmbianceOnOff;

  KeyDPad := ord(TJoystickDPad.center);

  if not CurrentMap.LoadFromFile(CurrentMap.getMapExtendedFileName('Niveau00'))
  then
  begin
    showmessage('Map file not found');
    DisplayMainScene;
    exit;
  end;

  PartieEnCours := TPartieEnCours.Create(self, CurrentMap);
  PartieEnCours.InitialiseLaPartie;

  // Chargement de la partie en attente de lancement
  if not FNomDeFichierDePartieACharger.isempty then
  begin
    PartieEnCours.LoadFromFile(FNomDeFichierDePartieACharger);
    CurrentMap.RefreshSceneBuffer;
    NomDeFichierDePartieACharger := '';
  end;

  CurrentMap.DisplayType := TMapDisplayType.sphere;
  CurrentMap.InitialiseScene(imgCurrentMap.Width, imgCurrentMap.height,
    imgCurrentMap.Bitmap.BitmapScale);

  PartieEnCours.CentreLaSceneSurLejoueur;

  GameScene.Visible := true;
  GameScene.BringToFront;
  TimerRefreshMap.Enabled := true;

  GameTimerCyceDeJeu.Enabled := true;
end;

procedure TfrmMain.DisplayMainScene;
begin
  DisplayNothing;

  if not CurrentMap.LoadFromFile(CurrentMap.getMapExtendedFileName('Intro'))
  then
  begin
    showmessage('Map file not found');
    close;
    exit;
  end;

  CurrentMap.DisplayType := TMapDisplayType.sphere;
  CurrentMap.InitialiseScene(imgCurrentMap.Width, imgCurrentMap.height,
    imgCurrentMap.Bitmap.BitmapScale);

  MainScene.Visible := true;
  MainScene.BringToFront;
  TimerRefreshMap.Enabled := true;

  tthread.ForceQueue(nil,
    procedure
    begin
      ZoneTitle.margins.top := (Menu.Position.Y - ZoneTitle.height) / 2;
    end);
end;

procedure TfrmMain.DisplayNothing;
begin
  TimerRefreshMap.Enabled := false;
  MainScene.Visible := false;
  MainTimerLancePartieReprise.Enabled := false;
  GameScene.Visible := false;
  GameTimerCyceDeJeu.Enabled := false;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  TimerRefreshMap.Enabled := false;
  CurrentMap := TDMMap.Create(self);

  PartieEnCours := nil;
  NbCanardsText := nil;
  NbOeufsText := nil;

  txtVersionDuProgramme.text := 'Version : ' + cversion.ToString + '-' +
    cversiondate.ToString;

  with TOlfFMXTextImageFrame.Create(self) do
  begin
    parent := ZoneTitle;
    font := dmAdobeStock_460990606.imagelist;
    LetterSpacing := 5;
    align := talignlayout.center;
    height := ZoneTitle.height;
    text := 'EGG HUNTER';
  end;

  NomDeFichierDePartieACharger := '';
  FBoiteDeDialogue := nil;
{$IF Defined(IOS) or Defined(ANDROID)}
  btnFermer.Visible := false;
  Menu.Contenu.height := Menu.Contenu.height - btnFermer.margins.top -
    btnFermer.height - btnFermer.margins.bottom;
{$ENDIF}

  // TODO : n'afficher "reprendre la partie" que s'il y a des fichiers de parties stockés

  tmusicloop.Current.Volume := TConfig.MusiqueDAmbianceVolume;
  if TConfig.MusiqueDAmbianceOnOff then
    tmusicloop.Current.play;

  DisplayMainScene;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if Key in [vkEscape, vkHardwareBack] then
  begin
    Key := 0;
    KeyChar := #0;
    if assigned(FBoiteDeDialogue) then
      FBoiteDeDialogue.ClicSurBoutonCancelOuESCAPE
    else if isGameSceneDisplayed then
      btnPauseDuJeuClick(btnPauseDuJeu)
    else
      btnFermerClick(btnFermer);
  end
  else if Key in [vkReturn] then
  begin
    Key := 0;
    KeyChar := #0;
    if assigned(FBoiteDeDialogue) then
      FBoiteDeDialogue.ClicSurBoutonParDefautOuRETURN
    else if isGameSceneDisplayed then
      // TODO : need to do something with RETURN in game mode ?
    else if assigned(btnReprendreUnePartie.onclick) then
      btnReprendreUnePartie.onclick(btnReprendreUnePartie)
    else if assigned(btnLancerUnePartie.onclick) then
      btnLancerUnePartie.onclick(btnLancerUnePartie);
  end
  else if Key = vkLeft then
  begin
    Key := 0;
    KeyChar := #0;
    KeyDPad := ord(TJoystickDPad.Left);
  end
  else if Key = vkright then
  begin
    Key := 0;
    KeyChar := #0;
    KeyDPad := ord(TJoystickDPad.Right);
  end
  else if Key = vkup then
  begin
    Key := 0;
    KeyChar := #0;
    KeyDPad := ord(TJoystickDPad.top);
  end
  else if Key = vkdown then
  begin
    Key := 0;
    KeyChar := #0;
    KeyDPad := ord(TJoystickDPad.bottom);
  end;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
Shift: TShiftState);
begin
  if Key in [vkup, vkright, vkdown, vkLeft] then
  begin
    KeyDPad := ord(TJoystickDPad.center);
    Key := 0;
    KeyChar := #0;
  end;
end;

procedure TfrmMain.FormSaveState(Sender: TObject);
begin
  if isGameSceneDisplayed then
  begin
    // TODO : conditionner SaveState en fonction de l'état du programme
    // if assigned(PartieEnCours) then
    // PartieEnCours.SaveToFile;
    btnPauseDuJeuClick(Sender);
  end;
end;

procedure TfrmMain.GamePause;
var
  i: integer;
begin
  if not isGameSceneDisplayed then
    exit;

  if assigned(PartieEnCours) then
    PartieEnCours.SaveToFile;

  GameTimerCyceDeJeu.Enabled := false;

  DisplayMainScene;
end;

procedure TfrmMain.GameTimerCyceDeJeuTimer(Sender: TObject);
var
  GameController: IGamolfJoystickService;
  GCInfos: TJoystickInfo;
begin
  if not isGameSceneDisplayed then
    exit;

  // Player life or UI movements
  if assigned(FBoiteDeDialogue) then
  begin
    // TODO : change focus control with arrow keys or controller movements
  end
  else
  begin
    // Game Controllers
    if TPlatformServices.Current.SupportsPlatformService(IGamolfJoystickService,
      GameController) then
      GameController.ForEachConnectedDevice(GCInfos,
        procedure(JoystickID: TJoystickID; var JoystickInfo: TJoystickInfo)
        var
          X, Y: integer;
        begin
          X := PartieEnCours.JoueurCol;
          Y := PartieEnCours.JoueurLig;

          // DPAD / POV
          if GameController.hasDPad(JoystickID) then
            MoveWithDPadangle(JoystickInfo.dpad);

          // Left Joystick (axes X,Y)
          if (X = PartieEnCours.JoueurCol) and (Y = PartieEnCours.JoueurLig)
          then
            MoveWithDPadangle(GameController.getDPadFromXY(JoystickInfo.Axes[0],
              JoystickInfo.Axes[1]));

          // Right Joystick
          if (X = PartieEnCours.JoueurCol) and (Y = PartieEnCours.JoueurLig)
          then
            MoveWithDPadangle(GameController.getDPadFromXY(JoystickInfo.Axes[2],
              JoystickInfo.Axes[3]));
        end);

    // onScreen Joypad
    if TConfig.InterfaceTactileOnOff then
    begin
      MoveWithDPadangle(JoypadDeGauche.dpad);
      MoveWithDPadangle(JoypadDeDroite.dpad);
    end;

    // Keyboard move (arrows)
    MoveWithDPadangle(KeyDPad);
  end;

  // Other elements life
  PartieEnCours.Execute;

  if (NbCanardsOnMap <> PartieEnCours.NbCanardsSurLaMap) then
    NbCanardsOnMap := PartieEnCours.NbCanardsSurLaMap;

  if (NbOeufsOnMap <> PartieEnCours.NbOeufsSurLaMap) then
    NbOeufsOnMap := PartieEnCours.NbOeufsSurLaMap;
end;

procedure TfrmMain.TimerRefreshMapTimer(Sender: TObject);
var
  buffer: tbitmap;
begin
  if TimerRefreshMap.Enabled and assigned(CurrentMap) and CurrentMap.isSceneBufferChanged
  then
  begin
    buffer := CurrentMap.SceneBuffer;
    // TODO : bloquer l'accès au buffer le temps de la copie vers l'écran sinon ça peut générer un accès concurrentiels lorsque les threads seront activés
    if (buffer <> nil) then
    begin
      if (imgCurrentMap.Bitmap.Width <> buffer.Width) or
        (imgCurrentMap.Bitmap.height <> buffer.height) then
        imgCurrentMap.Bitmap.SetSize(buffer.Width, buffer.height);
      // imgCurrentMap.Bitmap.BitmapScale := 1;
      imgCurrentMap.Bitmap.CopyFromBitmap(buffer);
    end;
    // TODO : gérer le niveau de zoom
    // TODO : gérer le BitmapScale de l'image
  end;
end;

function TfrmMain.GetNumberNameForAdobeStock47191065Font
  (Sender: TOlfFMXTextImageFrame; AChar: Char): integer;
begin
  // orange_0	0
  // orange_1	1
  // orange_2	2
  // orange_3	3
  // orange_4	4
  // orange_5	5
  // orange_6	6
  // orange_7	7
  // orange_8	8
  // orange_9	9
  result := ord(AChar) - ord('0');
end;

procedure TfrmMain.imgCurrentMapMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Single);
begin
  if isGameSceneDisplayed then
    ClicSurCarte(X, Y);
end;

procedure TfrmMain.imgCurrentMapResized(Sender: TObject);
begin
  if assigned(CurrentMap) and assigned(imgCurrentMap.Bitmap) then
  begin
    if (imgCurrentMap.Bitmap.BitmapScale = 1) then
      imgCurrentMap.WrapMode := timagewrapmode.Original
    else
      imgCurrentMap.WrapMode := timagewrapmode.Fit;

    CurrentMap.InitialiseScene(imgCurrentMap.Width, imgCurrentMap.height,
      imgCurrentMap.Bitmap.BitmapScale);

    // Modifie le viewport pour se positionner autour du joueur
    if assigned(PartieEnCours) and isGameSceneDisplayed then
      PartieEnCours.CentreLaSceneSurLejoueur;
  end;
end;

function TfrmMain.isGameSceneDisplayed: boolean;
begin
  result := GameScene.Visible;
end;

procedure TfrmMain.SetBoiteDeDialogue(const Value: TtplDialogBox);
begin
  FBoiteDeDialogue := Value;
end;

procedure TfrmMain.SetKeyDPad(const Value: Word);
begin
  FKeyDPad := Value;
end;

procedure TfrmMain.SetNbCanardsOnMap(const Value: integer);
begin
  FNbCanardsOnMap := Value;
  NbCanardsText.text := FNbCanardsOnMap.ToString;
  ZoneNbCanards.Width := ZoneNbCanards.padding.Left +
    NbCanardsPicto.margins.Left + NbCanardsPicto.Width +
    NbCanardsPicto.margins.Right + NbCanardsText.Width +
    ZoneNbCanards.padding.Right;
end;

procedure TfrmMain.SetNbOeufsOnMap(const Value: integer);
begin
  FNbOeufsOnMap := Value;
  NbOeufsText.text := FNbOeufsOnMap.ToString;
  ZoneNbOeufs.Width := ZoneNbOeufs.padding.Left + NbOeufsPicto.margins.Left +
    NbOeufsPicto.Width + NbOeufsPicto.margins.Right + NbOeufsText.Width +
    ZoneNbOeufs.padding.Right;
end;

procedure TfrmMain.SetNomDeFichierDePartieACharger(const Value: string);
begin
  FNomDeFichierDePartieACharger := Value;
  MainTimerLancePartieReprise.Enabled := not Value.isempty;
end;

procedure TfrmMain.VersLaDroite;
begin
  PartieEnCours.JoueurCol := PartieEnCours.JoueurCol + 1;
end;

procedure TfrmMain.VersLaGauche;
begin
  PartieEnCours.JoueurCol := PartieEnCours.JoueurCol - 1;
end;

procedure TfrmMain.VersLeBas;
begin
  PartieEnCours.JoueurLig := PartieEnCours.JoueurLig + 1;
end;

procedure TfrmMain.VersLeHaut;
begin
  PartieEnCours.JoueurLig := PartieEnCours.JoueurLig - 1;
end;

procedure TfrmMain.MainTimerLancePartieRepriseTimer(Sender: TObject);
begin
  if not FNomDeFichierDePartieACharger.isempty then
  begin
    btnLancerUnePartieClick(btnLancerUnePartie);
    MainTimerLancePartieReprise.Enabled := false;
  end;
end;

procedure TfrmMain.MoveWithDPadangle(dpad: Word);
begin
  if not isGameSceneDisplayed then
    exit;

  if dpad = ord(TJoystickDPad.top) then
    VersLeHaut
  else if dpad = ord(TJoystickDPad.Right) then
    VersLaDroite
  else if dpad = ord(TJoystickDPad.bottom) then
    VersLeBas
  else if dpad = ord(TJoystickDPad.Left) then
    VersLaGauche;
end;

initialization

{$IF Defined(MACOS)}
// globalusemetal:=true;
// METAL is slower than without METAL
// https://quality.embarcadero.com/browse/RSP-41315
{$ENDIF}
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
