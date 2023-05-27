unit fEcranDuJeu;

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
  FMX.Objects,
  uPartieEnCours,
  templateDialogBox,
  FMX.Layouts,
  cJoypad,
  cadBoutonOption;

type
  TfrmEcranDuJeu = class(TForm)
    imgScene: TImage;
    timerRefreshScene: TTimer;
    timerCyceDeJeu: TTimer;
    txtNbCanards: TText;
    txtNbOeufs: TText;
    zoneHeader: TLayout;
    ZoneFooter: TLayout;
    JoypadDeDroite: TcadJoypad;
    btnEffetsSonoresOnOff: TcBoutonOption;
    btnPauseDuJeu: TcBoutonOption;
    btnMusiqueOnOff: TcBoutonOption;
    JoypadDeGauche: TcadJoypad;
    procedure FormCreate(Sender: TObject);
    procedure timerRefreshSceneTimer(Sender: TObject);
    procedure imgSceneResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure timerCyceDeJeuTimer(Sender: TObject);
    procedure imgSceneMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormSaveState(Sender: TObject);
    procedure cadJoypad1btnVersLaDroiteClick(Sender: TObject);
    procedure cadJoypad1btnVersLaGaucheClick(Sender: TObject);
    procedure cadJoypad1btnVersLeBasClick(Sender: TObject);
    procedure cadJoypad1btnVersLeHautClick(Sender: TObject);
    procedure btnMusiqueOnOffClick(Sender: TObject);
    procedure btnEffetsSonoresOnOffClick(Sender: TObject);
    procedure btnPauseDuJeuClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FBoiteDeDialogueActive: TtplDialogBox;
    fNbCanards: integer;
    fNbOeufs: integer;
    procedure SetBoiteDeDialogueActive(const Value: TtplDialogBox);
    { Déclarations privées }
    procedure VersLaGauche;
    procedure VersLaDroite;
    procedure VersLeHaut;
    procedure VersLeBas;
    procedure ClicSurCarte(X, Y: Single);
  public
    { Déclarations publiques }
    PartieEnCours: TPartieEnCours;
    property BoiteDeDialogueActive: TtplDialogBox read FBoiteDeDialogueActive
      write SetBoiteDeDialogueActive;
  end;

implementation

{$R *.fmx}

uses
  uDMMap,
  cInventaireCouveuse,
  cInventaireJoueur,
  uMusic,
  uBruitages,
  uConfig,
  Olf.RTL.Params;

procedure TfrmEcranDuJeu.btnEffetsSonoresOnOffClick(Sender: TObject);
begin
  btnEffetsSonoresOnOff.isActif := not btnEffetsSonoresOnOff.isActif;

  TConfig.BruitagesOnOff := btnEffetsSonoresOnOff.isActif;
  tparams.save;

  if not btnEffetsSonoresOnOff.isActif then
    CouperLesBruitages;
end;

procedure TfrmEcranDuJeu.btnMusiqueOnOffClick(Sender: TObject);
begin
  btnMusiqueOnOff.isActif := not btnMusiqueOnOff.isActif;

  TConfig.MusiqueDAmbianceOnOff := btnMusiqueOnOff.isActif;
  tparams.save;

  if btnMusiqueOnOff.isActif then
    TMusiques.Ambiance.play
  else
    TMusiques.Ambiance.Stop;
end;

procedure TfrmEcranDuJeu.btnPauseDuJeuClick(Sender: TObject);
begin
  close;
end;

procedure TfrmEcranDuJeu.cadJoypad1btnVersLaDroiteClick(Sender: TObject);
begin
  VersLaDroite;
end;

procedure TfrmEcranDuJeu.cadJoypad1btnVersLaGaucheClick(Sender: TObject);
begin
  VersLaGauche;
end;

procedure TfrmEcranDuJeu.cadJoypad1btnVersLeBasClick(Sender: TObject);
begin
  VersLeBas;
end;

procedure TfrmEcranDuJeu.cadJoypad1btnVersLeHautClick(Sender: TObject);
begin
  VersLeHaut;
end;

procedure TfrmEcranDuJeu.ClicSurCarte(X, Y: Single);
var
  ColDansViewport, LigDansViewport: integer;
  ColDansMap, LigDansMap: integer;
  ZIndex: integer;
begin
  // Conversion X,Y (pixels) en colonne/ligne sur le viewport
  ColDansViewport := trunc(X) div DMMap.SpriteWidth;
  // TODO : gérer niveau de zoom et bitmapscale
  ColDansMap := (ColDansViewport + DMMap.ViewportCol)
    mod DMMap.LevelMapcolCount;
  LigDansViewport := trunc(Y) div DMMap.SpriteHeight;
  // TODO : gérer niveau de zoom et bitmapscale
  LigDansMap := (LigDansViewport + DMMap.ViewportLig)
    mod DMMap.LevelMapRowCount;

  // Si on est dans la grille de la map
  if (LigDansMap >= 0) and (LigDansMap < DMMap.LevelMapRowCount) and
    (ColDansMap >= 0) and (ColDansMap < DMMap.LevelMapcolCount) then
    for ZIndex := 0 to CNbZIndex do
      if (DMMap.LevelMap[ColDansMap, LigDansMap].ZIndex[ZIndex] <> -1) then
        case DMMap.SpriteSheetElements[DMMap.LevelMap[ColDansMap, LigDansMap]
          .ZIndex[ZIndex]].TypeElement of
          TEggHunterElementType.Couveuse:
            FBoiteDeDialogueActive := TcadInventaireCouveuse.Execute(Self,
              PartieEnCours.Couveuses.CouveuseAt(ColDansMap, LigDansMap));
          TEggHunterElementType.joueur:
            FBoiteDeDialogueActive := TcadInventaireJoueur.Execute(Self,
              PartieEnCours);
        end;
end;

procedure TfrmEcranDuJeu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if assigned(PartieEnCours) then
    PartieEnCours.SaveToFile;
  tthread.ForceQueue(nil,
    procedure
    begin
      Self.Free;
    end);
end;

procedure TfrmEcranDuJeu.FormCreate(Sender: TObject);
var
  NiveauACharger: string;
begin
  FBoiteDeDialogueActive := nil;

  // Initialisation des textes à l'écran
  fNbCanards := -1;
  txtNbCanards.Text := '';
  fNbOeufs := -1;
  txtNbOeufs.Text := '';

  // Choix du niveau à charger
{$IF Defined(DEBUG) and Defined(MSWINDOWS)}
  NiveauACharger := 'Niveau00';
{$ELSE}
  NiveauACharger := 'Niveau00';
{$ENDIF}
  // Chargement de la map et lancement d'une partie
  if not DMMap.LoadFromFile(DMMap.getMapExtendedFileName(NiveauACharger)) then
  begin
    showmessage('Map file not found');
    close;
  end
  else
  begin
    PartieEnCours := TPartieEnCours.Create(Self);
    PartieEnCours.InitialiseLaPartie;
  end;

  JoypadDeGauche.Position.X := 10;
  JoypadDeGauche.Position.Y := ClientHeight - JoypadDeGauche.height - 10;
  JoypadDeGauche.Anchors := [TAnchorKind.akBottom, TAnchorKind.akleft];
  JoypadDeGauche.Visible := TConfig.InterfaceTactileOnOff;

  JoypadDeDroite.Position.X := ClientWidth - JoypadDeDroite.Width - 10;
  JoypadDeDroite.Position.Y := ClientHeight - JoypadDeDroite.height - 10;
  JoypadDeDroite.Anchors := [TAnchorKind.akBottom, TAnchorKind.akRight];
  JoypadDeDroite.Visible := TConfig.InterfaceTactileOnOff;

  btnEffetsSonoresOnOff.isActif := TConfig.BruitagesOnOff;
  btnMusiqueOnOff.isActif := TConfig.MusiqueDAmbianceOnOff;
end;

procedure TfrmEcranDuJeu.FormDestroy(Sender: TObject);
begin
  PartieEnCours.Free;
end;

procedure TfrmEcranDuJeu.FormKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if assigned(FBoiteDeDialogueActive) then
  begin
    if Key in [vkEscape, vkHardwareBack] then
    begin
      Key := 0;
      KeyChar := #0;
      FBoiteDeDialogueActive.ClicSurBoutonCancelOuESCAPE;
    end
    else if Key in [vkReturn] then
    begin
      Key := 0;
      KeyChar := #0;
      FBoiteDeDialogueActive.ClicSurBoutonParDefautOuRETURN;
    end;
  end
  else
  begin
    if Key in [vkEscape, vkHardwareBack] then
    begin
      Key := 0;
      KeyChar := #0;
      close;
    end
    else if Key = vkLeft then
    begin
      Key := 0;
      KeyChar := #0;
      VersLaGauche;
    end
    else if Key = vkright then
    begin
      Key := 0;
      KeyChar := #0;
      VersLaDroite;
    end
    else if Key = vkup then
    begin
      Key := 0;
      KeyChar := #0;
      VersLeHaut;
    end
    else if Key = vkdown then
    begin
      Key := 0;
      KeyChar := #0;
      VersLeBas;
    end;
  end;
end;

procedure TfrmEcranDuJeu.FormSaveState(Sender: TObject);
begin
  // TODO : conditionner SaveState en fonction de l'état du programme
  // if assigned(PartieEnCours) then
  // PartieEnCours.SaveToFile;
end;

procedure TfrmEcranDuJeu.FormShow(Sender: TObject);
begin
  if not timerRefreshScene.Enabled then
    timerRefreshScene.Enabled := true;
  if not timerCyceDeJeu.Enabled then
    timerCyceDeJeu.Enabled := true;
end;

procedure TfrmEcranDuJeu.imgSceneMouseDown(Sender: TObject;
Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  ClicSurCarte(X, Y);
end;

procedure TfrmEcranDuJeu.imgSceneResize(Sender: TObject);
begin
  if (imgScene.Bitmap.BitmapScale = 1) then
    imgScene.WrapMode := timagewrapmode.Original
  else
    imgScene.WrapMode := timagewrapmode.stretch;

  DMMap.InitialiseScene(imgScene.Width, imgScene.height,
    imgScene.Bitmap.BitmapScale);

  // Modifie le viewport pour se positionner autour du joueur
  if assigned(PartieEnCours) then
    PartieEnCours.CentreLaSceneSurLejoueur;
end;

procedure TfrmEcranDuJeu.SetBoiteDeDialogueActive(const Value: TtplDialogBox);
begin
  FBoiteDeDialogueActive := Value;
end;

procedure TfrmEcranDuJeu.timerCyceDeJeuTimer(Sender: TObject);
begin
  PartieEnCours.Execute;
  // TODO : Transformer fNbCanards en propriété pour adapter l'affichage automatiquement
  if (fNbCanards <> PartieEnCours.NbCanardsSurLaMap) then
  begin
    fNbCanards := PartieEnCours.NbCanardsSurLaMap;
    txtNbCanards.Text := 'Canards :' + fNbCanards.ToString;
  end;
  // TODO : Transformer fNbOeufs en propriété pour adapter l'affichage automatiquement
  if (fNbOeufs <> PartieEnCours.NbOeufsSurLaMap) then
  begin
    fNbOeufs := PartieEnCours.NbOeufsSurLaMap;
    txtNbOeufs.Text := 'Oeufs à ramasser : ' + fNbOeufs.ToString;
  end;
end;

procedure TfrmEcranDuJeu.timerRefreshSceneTimer(Sender: TObject);
var
  buffer: tbitmap;
begin
  if DMMap.isSceneBufferChanged then
  begin
    buffer := DMMap.SceneBuffer;
    // TODO : bloquer l'accès au buffer le temps de la copie vers l'écran sinon ça peut générer un accès concurrentiels lorsque les threads seront activés
    if (buffer <> nil) then
    begin
      // txtVersionDuProgramme.Text := imgScene.Bitmap.Width.ToString + ',' +
      // imgScene.Bitmap.Height.ToString + ',' +
      // imgScene.Bitmap.BitmapScale.ToString + ' ' + buffer.Width.ToString + ','
      // + buffer.Height.ToString + ',' + buffer.BitmapScale.ToString;
      if (imgScene.Bitmap.Width <> buffer.Width) or
        (imgScene.Bitmap.height <> buffer.height) then
        imgScene.Bitmap.SetSize(buffer.Width, buffer.height);
      // imgScene.Bitmap.BitmapScale := 1;
      imgScene.Bitmap.CopyFromBitmap(buffer);
    end;
    // TODO : gérer le niveau de zoom
    // TODO : gérer le BitmapScale de l'image
  end;
end;

procedure TfrmEcranDuJeu.VersLaDroite;
begin
  PartieEnCours.JoueurCol := PartieEnCours.JoueurCol + 1;
end;

procedure TfrmEcranDuJeu.VersLaGauche;
begin
  PartieEnCours.JoueurCol := PartieEnCours.JoueurCol - 1;
end;

procedure TfrmEcranDuJeu.VersLeBas;
begin
  PartieEnCours.JoueurLig := PartieEnCours.JoueurLig + 1;
end;

procedure TfrmEcranDuJeu.VersLeHaut;
begin
  PartieEnCours.JoueurLig := PartieEnCours.JoueurLig - 1;
end;

end.
