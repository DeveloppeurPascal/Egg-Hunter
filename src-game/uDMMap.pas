(* C2PP
  ***************************************************************************

  Egg Hunter

  Copyright 2021-2025 Patrick Pr�martin under AGPL 3.0 license.

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
  File last update : 2025-02-09T12:07:49.673+01:00
  Signature : 10ae4774f4c2c8a3ef0e66f517a21ff2b4cb35a2
  ***************************************************************************
*)

unit uDMMap;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Graphics,
  System.generics.collections,
  System.SyncObjs;

const
  /// <summary>
  /// niveau sur lequel �volue le joueur (� pieds)
  /// </summary>
  CZIndexJoueur = 5;
  /// <summary>
  /// niveau sur lequel �voluent les canards
  /// </summary>
  CZIndexCanards = 5;
  /// <summary>
  /// niveau sur lequel sont pondus les oeufs
  /// </summary>
  CZIndexOeufs = 4;
  /// <summary>
  /// niveau sur lequel sont les couveuses
  /// </summary>
  CZIndexCouveuses = 5;
  /// <summary>
  /// niveau sur lequel sont les passages
  /// </summary>
  CZIndexPassages = 5;
  /// <summary>
  /// niveau sur lequel sont les OVNIs
  /// </summary>
  CZIndexOVNI = 5;
  /// <summary>
  /// niveau sur lequel se trouverait l'eau (marres aux canards...)
  /// </summary>
  CZIndexEau = 2;
  /// <summary>
  /// niveau sur lequel sont les bateaux
  /// </summary>
  CZIndexBateau = 5;
  /// <summary>
  /// niveau sur lequel sont les trains
  /// </summary>
  CZIndexTrains = 5;
  /// <summary>
  /// niveau sur lequel sont les rails
  /// </summary>
  CZIndexRails = 3;

type
{$SCOPEDENUMS ON}
  /// <summary>
  /// Types d'�l�ments pr�sents sur la carte du niveau de jeu
  /// </summary>
  TEggHunterElementType = (Decor, Oeuf, Joueur, Canard, Passage, Couveuse, OVNI,
    Eau, Bateau, Train, Rail);

  /// <summary>
  /// Modes d'affichage de la zone de jeu
  /// => plan : affiche la carte en planisph�re, avec un vide au del� des rebords
  /// => sphere : affiche la carte en mode sph�re, pas de rebords, on affiche l'autre c�t� de la carte quand on d�borde
  /// </summary>
  TMapDisplayType = (plan, sphere);

const
  /// <summary>
  /// Version en cours du fichier de description des �l�ments de la spritesheet du niveau en cours
  /// </summary>
  CSpriteSheetDataFileVersion = 1;

type
  /// <summary>
  /// Description d'un �l�ment (= case) de la spritesheet, utilis�s aussi au niveau de la map
  /// </summary>
  TSpriteSheetElement = class
  public
    /// <summary>
    /// Indice de cet �l�ment dans sa spritesheet source
    /// </summary>
    SourceImageIndex: integer;
    /// <summary>
    /// Indice de la spritesheet dans l'�diteur de map, li� � l'�num�ration uDMSpriteSheets.TSpritesheetList
    /// </summary>
    SourceSpritesheetID: integer;
    /// <summary>
    /// Profondeur d'affichage de cet �l�ment sur la map
    /// 0..4 => �l�ments de d�cor sur lequel peuvent �voluer les personnages
    /// 5 => niveau li� aux personnages
    /// 6..10 => �l�ment de d�cor derri�re lequel s'affichent les autres �l�ments
    /// </summary>
    Zindex: byte;
    /// <summary>
    /// Indique qu'un personnage ne peut pas se positionner sur cette case.
    /// </summary>
    Bloquant: boolean;
    /// <summary>
    /// Type d'�l�ment permettant de savoir s'il est ramasble, destructible ou vraiment bloquant
    /// </summary>
    TypeElement: TEggHunterElementType;

    procedure LoadFromStream(AVersionStockage: integer; AStream: tstream);
    procedure SaveToStream(AStream: tstream);
  end;

  /// <summary>
  /// Liste des �l�ments (= cases) d'une spritesheet utilis�e dans le jeu
  /// </summary>
  TSpriteSheetElements = TObjectList<TSpriteSheetElement>;

  /// <summary>
  /// Liste index�e de bitmaps (pour g�rer les sprites de fa�on ind�pendante de leur spritesheet)
  /// </summary>
  TSprites = TObjectList<TBitmap>;

  /// <summary>
  /// Coordonn�es li�es � la map (en col,lig de la grille)
  /// </summary>
  TCoord = class
  public
    Col, Lig: integer;
    SpriteID: integer;
  end;

  /// <summary>
  /// Liste de coordonn�es
  /// </summary>
  TCoordList = TObjectList<TCoord>;

const
  /// <summary>
  /// Profondeur de chaque case du jeu dans la version en cours
  /// </summary>
  CNbZIndex = 10;

const
  /// <summary>
  /// Version en cours du fichier de la grille du niveau en cours
  /// </summary>
  CEggHunterMapFileVersion = 0;

type
  // TDMMap = class(TDataModule); // TODO : forward class declaration

  /// <summary>
  /// Element de la carte du niveau de jeu
  /// </summary>
  TEggHunterMapCell = class
    /// <summary>
    /// Stocke le num�ro du sprite pr�sent � chaque niveau de cette case de la carte
    /// </summary>
    Zindex: array [0 .. CNbZIndex] of integer;

    procedure LoadFromStream(AStream: tstream; ACol, ALig: integer;
      AMap: TDataModule);
    procedure SaveToStream(AStream: tstream);
  end;

const
  /// <summary>
  /// Nombre de colonnes (position.X) de la grille de jeu
  /// </summary>
  CEggHunterMapColCount = 1000;

  /// <summary>
  /// Nombre de lignes (position.Y) de la grille de jeu
  /// </summary>
  CEggHunterMapRowCount = 1000;

type
  /// <summary>
  /// Grille contenant les �l�ments du niveau de jeu en cours
  /// </summary>
  TEggHunterMap = array [0 .. CEggHunterMapColCount - 1,
    0 .. CEggHunterMapRowCount - 1] of TEggHunterMapCell;

  /// <summary>
  /// G�re la carte en cours et les �l�ments du jeu
  /// </summary>
  TDMMap = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FSpriteHeight: integer;
    FSpriteWidth: integer;
    FSpriteSheetBitmap: TBitmap;
    FSpriteSheetElements: TSpriteSheetElements;
    FLevelMap: TEggHunterMap;
    FLevelMapColCount: integer;
    FLevelMapRowCount: integer;
    FMapFileName: string;
    FViewportCol: integer;
    FViewportLig: integer;
    FSceneBitmapScale: Single;
    FViewportNbCol: integer;
    FViewportNbLig: integer;
    FSceneZoom: Single;
    /// <summary>
    /// Indique si la sc�ne a �t� initialis�e ou pas
    /// Si False, ne rien faire sur le buffer (car pas de taille de sprite ni d'�cran connues)
    /// </summary>
    FSceneInitialisee: boolean;
    /// <summary>
    /// Mutex permettant de verrouiller l'acc�s au buffer de dessin d'�cran
    /// </summary>
    FSceneMutex: TMutex;
    /// <summary>
    /// Buffer sur lequel on dessine les �crans et qui est retourn� � l'�cran quand il le demande
    /// </summary>
    FSceneBuffer: TBitmap;
    /// <summary>
    /// Stockage des sprites de l'�cran
    /// </summary>
    FSpritesListe: TSprites;
    FisSceneBufferChanged: boolean;
    FJoueurCol: integer;
    FJoueurLig: integer;
    FListeCanards: TCoordList;
    FDisplayType: TMapDisplayType;
    FListeCouveuses: TCoordList;
    FListeOeufs: TCoordList;
    procedure setLevelMapColCount(const Value: integer);
    procedure setLevelMapRowCount(const Value: integer);
    procedure SetMapFileName(const Value: string);
    function getSceneBuffer: TBitmap;
    procedure SetSceneBitmapScale(const Value: Single);
    procedure SetSceneZoom(const Value: Single);
    procedure SetViewportNbCol(const Value: integer);
    procedure SetViewportNbLig(const Value: integer);
    procedure SetViewportCol(const Value: integer);
    procedure SetViewportLig(const Value: integer);
    procedure SetJoueurCol(const Value: integer);
    procedure SetJoueurLig(const Value: integer);
    procedure SetListeCanards(const Value: TCoordList);
    procedure SetDisplayType(const Value: TMapDisplayType);
    procedure SetListeCouveuses(const Value: TCoordList);
    procedure SetListeOeufs(const Value: TCoordList);
  public
    /// <summary>
    /// Largeur d'une image dans la spritesheet
    /// </summary>
    property SpriteWidth: integer read FSpriteWidth;
    /// <summary>
    /// Hauteur d'une image dans la spritesheet
    /// </summary>
    property SpriteHeight: integer read FSpriteHeight;
    /// <summary>
    /// Bitmap contenant la spritesheet
    /// </summary>
    property SpriteSheetBitmap: TBitmap read FSpriteSheetBitmap;
    /// <summary>
    /// Liste contenant les �l�ments li�s � la spritesheet
    /// </summary>
    property SpriteSheetElements: TSpriteSheetElements
      read FSpriteSheetElements;

    /// <summary>
    /// Nombre de colonnes de la grille du niveau actuel
    /// </summary>
    property LevelMapColCount: integer read FLevelMapColCount
      write setLevelMapColCount;

    /// <summary>
    /// Nombre de lignes de la grille du niveau actuel
    /// </summary>
    property LevelMapRowCount: integer read FLevelMapRowCount
      write setLevelMapRowCount;

    /// <summary>
    /// Grille du niveau de jeu actuel
    /// </summary>
    property LevelMap: TEggHunterMap read FLevelMap;

    /// <summary>
    /// Nom et chemin d'acc�s au fichier stockant la map
    /// </summary>
    property MapFileName: string read FMapFileName write SetMapFileName;

    /// <summary>
    /// Image de la scene en cours = dessin de l'�cran
    /// </summary>
    property SceneBuffer: TBitmap read getSceneBuffer;

    /// <summary>
    /// Indique si l'image du buffer de la sc�ne a �t� modifi�e depuis le dernier appel � getSceneBuffer (= getter de SceneBuffer)
    /// </summary>
    property isSceneBufferChanged: boolean read FisSceneBufferChanged
      write FisSceneBufferChanged;

    /// <summary>
    /// Num�ro de la colonne affich�e en haut � gauche de notre scene
    /// Quand on est dans l'�diteur, c'est enregistr� avec la map
    /// Quand on est dans un jeu, on centre l'affichage par rapport au joueur au d�marrage de la partie
    /// </summary>
    property ViewportCol: integer read FViewportCol write SetViewportCol;

    /// <summary>
    /// Num�ro de la ligne affich�e en haut � gauche de notre scene
    /// Quand on est dans l'�diteur, c'est enregistr� avec la map
    /// Quand on est dans un jeu, on centre l'affichage par rapport au joueur au d�marrage de la partie
    /// </summary>
    property ViewportLig: integer read FViewportLig write SetViewportLig;

    /// <summary>
    /// Nombre de lignes affich�es dans la scene
    /// Calcul� en fonction de la taille de l'�cran et de la taille des sprites
    /// </summary>
    property ViewportNbCol: integer read FViewportNbCol write SetViewportNbCol;

    /// <summary>
    /// Nombre de lignes affich�es dans la scene
    /// Calcul� en fonction de la taille de l'�cran et de la taille des sprites
    /// </summary>
    property ViewportNbLig: integer read FViewportNbLig write SetViewportNbLig;

    /// <summary>
    /// Niveau de zoom appliqu� � l'affichage par l'utilisateur
    /// Quand on est dans l'�diteur, c'est enregistr� avec la map
    /// Quand on est dans un jeu, c'est archiv� au niveau de la partie
    /// </summary>
    property SceneZoom: Single read FSceneZoom write SetSceneZoom;

    /// <summary>
    /// R�solution de l'�cran (nb de pixels physiques pour 1 pixel logique)
    /// </summary>
    property SceneBitmapScale: Single read FSceneBitmapScale
      write SetSceneBitmapScale;

    /// <summary>
    /// Type d'affichage de la map, impacte les tests et calculs sur coordonn�es et viewport
    /// </summary>
    property DisplayType: TMapDisplayType read FDisplayType
      write SetDisplayType;

    /// <summary>
    /// Colonne de la cellule sur laquelle est positionn� le joueur en d�marrage de jeu
    /// (initialis� lors du chargement d'un niveau ou du positionnement d'un sprite de type joueur)
    /// </summary>
    property JoueurCol: integer read FJoueurCol write SetJoueurCol;
    /// <summary>
    /// Ligne de la cellule sur laquelle est positionn� le joueur en d�marrage de jeu
    /// (initialis� lors du chargement d'un niveau ou du positionnement d'un sprite de type joueur)
    /// </summary>
    property JoueurLig: integer read FJoueurLig write SetJoueurLig;

    /// <summary>
    /// Liste des oeufs pr�sents sur la map au moment de son chargmeent
    /// (utilis� pour initialiser les oeufs pr�sents lorsqu'on lance une partie)
    /// </summary>
    property ListeOeufs: TCoordList read FListeOeufs write SetListeOeufs;

    /// <summary>
    /// Liste des canards renseign�e au chargement du niveau de jeu
    /// (utilis� pour initialiser et animer les canards pr�sents lorsqu'on lance une partie)
    /// </summary>
    property ListeCanards: TCoordList read FListeCanards write SetListeCanards;

    /// <summary>
    /// Liste des couveuses renseign�e au chargement du niveau de jeu
    /// (utilis� pour initialiser les couveuses pr�sentes lorsqu'on lance une partie)
    /// </summary>
    property ListeCouveuses: TCoordList read FListeCouveuses
      write SetListeCouveuses;

    /// <summary>
    /// Renvoie le bitmap associ� � l'indice demand�
    /// </summary>
    function getImageFromSpriteSheetRef(AImageIndex: integer): TBitmap;

    /// <summary>
    /// Initialise une copie des sprites (en images ind�pendantes) pour acc�l�rer l'affichage de la map
    /// </summary>
    procedure ChargeListeDesImagesDeSpritesEnCache;

    /// <summary>
    /// Charge un niveau (carte + spritesheet + d�finition des �l�ments)
    /// Retourne True si le chargement s'est bien pass�, False dans le cas contraire
    /// </summary>
    function LoadFromFile(AFileName: string): boolean;

    /// <summary>
    /// Sauve un niveau (carte + spritesheet + d�finition des �l�ments)
    /// Retourne True si la sauvegarde s'est bien pass�e, False dans le cas contraire
    /// </summary>
    function SaveToFile(AFileName: string): boolean; overload;

    /// <summary>
    /// Sauvegarde le niveau en utilisant son chemin+nom actuel (FMapFileName)
    /// </summary>
    function SaveToFile: boolean; overload;

    /// <summary>
    /// Pr�pare les �lements n�cessaires au fonctionnement de cette classe
    /// </summary>
    procedure InitialiseLaMap;

    /// <summary>
    /// Nettoie les �l�ments de la classe
    /// </summary>
    procedure FinaliseLaMap;

    /// <summary>
    /// Permet l'initialisation de la sc�ne et des infos d'affichage dans le buffer
    /// </summary>
    procedure InitialiseScene(AScreenWidth, AScreenHeight: Single;
      ABitmapScale: Single);

    /// <summary>
    /// Dessine la zone actuelle du viewport sur le buffer de la sc�ne
    /// </summary>
    procedure RefreshSceneBuffer(AAccesRestreint: boolean = true);

    /// <summary>
    /// Dessine une case de la grille dans le buffer en fonction du viewport
    /// </summary>
    procedure DessineCaseDeLaMap(ACol, ALig: integer;
      AAccesRestreint: boolean = true);

    /// <summary>
    /// R�initialise le contenu de la map
    /// </summary>
    procedure VideLaMap;

    /// <summary>
    /// Ajoute un �l�ment � la sprite sheet de la map
    /// </summary>
    procedure AddSpriteSheetElement(ABitmap: TBitmap;
      AElement: TSpriteSheetElement);

    /// <summary>
    /// Retourne le chemin d'acc�s au fichier de stockage du niveau sp�cifi� en ajoutant le dossier et son extension au nom pass� en param�tre
    /// </summary>
    function getMapExtendedFileName(AFileNameWithoutExtension: string): string;

    /// <summary>
    /// Retourne le dossier de stockage des maps
    /// </summary>
    function getMapFilePath: string;

    /// <summary>
    /// Retourne l'extension utilis�e pour les fichiers de niveaux de ce jeu
    /// </summary>
    function getMapFileExtension: string;

    /// <summary>
    /// Retourne le nombre d'�l�ments pr�sents dans la spritesheet de la map en cours
    /// </summary>
    function getNbSprite: integer;

    /// <summary>
    /// V�rifie si le sprite indiqu� existe d�j� dans la liste de sprites de la map
    /// Retourne true s'il existe
    /// Retourne false s'il n'existe pas
    /// </summary>
    function SpriteExists(ASourceSpritesheetID: integer;
      ASourceImageIndex: integer): boolean;

    /// <summary>
    /// Bloque la map le temps d'arriver sur le EndUpdate (�vite un refresh en cours de modification)
    /// Utilise le MUTEX FSpriteScene
    /// </summary>
    procedure BeginUpdate;

    /// <summary>
    /// D�bloque la map
    /// Utilise le MUTEX FSpriteScene
    /// </summary>
    procedure EndUpdate;

    /// <summary>
    /// D�place le Viewport en X,Y
    /// </summary>
    procedure ChangeViewportColLig(AViewportCol, AViewportLig: integer);

    /// <summary>
    /// Retourne l'ID de l'�l�ment bloquant (ou du plus bas en Z-Index) aux coordonn�es (ACol, ALig)
    /// </summary>
    function GetSpriteIDBloquantSurCase(ACol: integer; ALig: integer): integer;
  end;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

uses
  System.Types,
  System.Zip,
  System.IOUtils,
  System.Math,
  System.Threading,
  System.UITypes,
  FMX.Types;

procedure TDMMap.AddSpriteSheetElement(ABitmap: TBitmap;
  AElement: TSpriteSheetElement);
var
  largeur: integer;
  bmp: TBitmap;
begin
  FSpriteWidth := ABitmap.Width;
  FSpriteHeight := ABitmap.height;
  largeur := FSpriteSheetBitmap.Width;
  // Cr�ation de la nouvelle spritesheet
  bmp := TBitmap.Create;
  try
    // On agrandit la nouvelle par rapport � l'existante de la taille d'un sprite
    bmp.SetSize(largeur + SpriteWidth, SpriteHeight);
    // Copie de la spritesheet existante vers la nouvelle (apr�s changement de taille)
    bmp.CopyFromBitmap(FSpriteSheetBitmap, Rect(0, 0, FSpriteSheetBitmap.Width,
      FSpriteSheetBitmap.height), 0, 0);
    // Ajout du nouveau sprite dans la spritesheet
    bmp.CopyFromBitmap(ABitmap, Rect(0, 0, FSpriteWidth, FSpriteHeight),
      largeur, 0);
    // On repointe sur la nouvelle spritesheet pour la suite
    FSpriteSheetBitmap.assign(bmp);
    // On ajoute le sprite � la liste de sprites utilis�e pour dessiner l'�cran
    FSpritesListe.Add(ABitmap);
    // On ajoute les propri�t�s du sprite � la liste des propri�t�s des sprites de la map
    FSpriteSheetElements.Add(AElement);
  finally
    bmp.Free;
  end;
  // TODO : modifier cette proc�dure pour retourner l'indice de l'�l�ment ajout� (� priori le compteur -1 de la liste)
end;

procedure TDMMap.BeginUpdate;
begin
  FSceneMutex.Acquire;
end;

procedure TDMMap.ChangeViewportColLig(AViewportCol, AViewportLig: integer);
begin
  case FDisplayType of
    TMapDisplayType.plan:
      begin
        if (AViewportCol < 0) then
          AViewportCol := 0
        else if (AViewportCol >= FLevelMapColCount) then
          AViewportCol := FLevelMapColCount - 1;

        if (AViewportLig < 0) then
          AViewportLig := 0
        else if (AViewportLig >= FLevelMapRowCount) then
          AViewportLig := FLevelMapRowCount - 1;
      end;
    TMapDisplayType.sphere:
      begin
        if (AViewportCol < 0) then
          AViewportCol := FLevelMapColCount + AViewportCol
          // Col < 0 donc + -Col
        else if (AViewportCol >= FLevelMapColCount) then
          AViewportCol := AViewportCol - FLevelMapColCount;

        if (AViewportLig < 0) then
          AViewportLig := FLevelMapRowCount + AViewportLig
          // Lig < 0 donc + -Lig
        else if (AViewportLig >= FLevelMapRowCount) then
          AViewportLig := AViewportLig - FLevelMapRowCount;
      end;
  else
    raise exception.Create('Map display type not managed.');
  end;
  if (FViewportCol <> AViewportCol) or (FViewportLig <> AViewportLig) then
  begin
    FViewportCol := AViewportCol;
    FViewportLig := AViewportLig;
    RefreshSceneBuffer;
  end;
end;

procedure TDMMap.ChargeListeDesImagesDeSpritesEnCache;
var
  ColCount: integer;
  NumSprite: integer;
  bmp: TBitmap;
  x, y: integer;
begin
  FSpritesListe.Clear;
  if (FSpriteSheetBitmap <> nil) then
  begin
    if FSpriteWidth > 0 then
      ColCount := (FSpriteSheetBitmap.Width + 1) div (FSpriteWidth);
    for NumSprite := 0 to getNbSprite - 1 do
    begin
      x := (NumSprite mod ColCount) * FSpriteWidth;
      y := (NumSprite div ColCount) * FSpriteHeight;
      if (x < FSpriteSheetBitmap.Width) and (y < FSpriteSheetBitmap.height) then
      begin
        bmp := TBitmap.Create;
        bmp.SetSize(FSpriteWidth, FSpriteHeight);
        bmp.CopyFromBitmap(FSpriteSheetBitmap,
          trect.Create(x, y, x + FSpriteWidth, y + FSpriteHeight), 0, 0);
        FSpritesListe.Add(bmp);
      end;
    end;
  end;
end;

procedure TDMMap.DataModuleCreate(Sender: TObject);
begin
  FSceneInitialisee := false;
  FSceneMutex := TMutex.Create;
  FSceneBuffer := TBitmap.Create;
  FSpriteSheetBitmap := TBitmap.Create;
  FSpriteSheetElements := TSpriteSheetElements.Create;
  FSpritesListe := TSprites.Create;
  FListeOeufs := TCoordList.Create;
  FListeCanards := TCoordList.Create;
  FListeCouveuses := TCoordList.Create;
  InitialiseLaMap;
end;

procedure TDMMap.DataModuleDestroy(Sender: TObject);
var
  i, j: integer;
begin
  FinaliseLaMap;
  for i := 0 to CEggHunterMapColCount - 1 do
    for j := 0 to CEggHunterMapRowCount - 1 do
      FLevelMap[i, j].Free;
  FListeCouveuses.Free;
  FListeCanards.Free;
  FListeOeufs.Free;
  FSpritesListe.Free;
  FSpriteSheetElements.Free;
  FSpriteSheetBitmap.Free;
  FSceneBuffer.Free;
  FSceneMutex.Free;
end;

procedure TDMMap.DessineCaseDeLaMap(ACol, ALig: integer;
  AAccesRestreint: boolean);
var
  x, y: integer;
  Zindex: integer;
  bmp: TBitmap;
begin
  if AAccesRestreint then
    FSceneMutex.Acquire;
  try
    FisSceneBufferChanged := true;
    case FDisplayType of
      TMapDisplayType.plan:
        begin
          x := (ACol - FViewportCol) * FSpriteWidth;
          y := (ALig - FViewportLig) * FSpriteHeight;
        end;
      TMapDisplayType.sphere:
        begin
          if (ACol >= FViewportCol) then
            x := (ACol - FViewportCol) * FSpriteWidth
          else
            x := (ACol + FLevelMapColCount - FViewportCol) * FSpriteWidth;
          if (ALig >= FViewportLig) then
            y := (ALig - FViewportLig) * FSpriteHeight
          else
            y := (ALig + FLevelMapRowCount - FViewportLig) * FSpriteHeight;
          ACol := ACol mod FLevelMapColCount;
          ALig := ALig mod FLevelMapRowCount;
        end;
    else
      raise exception.Create('MapDisplayType not managed.');
    end;
    if (ACol >= 0) and (ACol < FLevelMapColCount) and (ALig >= 0) and
      (ALig < FLevelMapRowCount) then
    begin
      // On met un fond de couleur � chaque cellule
      FSceneBuffer.Canvas.BeginScene;
      try
        FSceneBuffer.Canvas.Fill.Kind := tbrushkind.Solid;
        FSceneBuffer.Canvas.Fill.Color := talphacolors.Coral;
        FSceneBuffer.Canvas.FillRect(Rectf(x, y, x + FSpriteWidth,
          y + FSpriteHeight), 1);
        // On dessine les sprites associ�s � la cellule
        for Zindex := 0 to CNbZIndex do
        begin
          bmp := getImageFromSpriteSheetRef
            (FLevelMap[ACol, ALig].Zindex[Zindex]);
          if (bmp <> nil) then
          begin
            FSceneBuffer.Canvas.DrawBitmap(bmp,
              Rectf(0, 0, bmp.Width, bmp.height), Rectf(x, y, x + bmp.Width,
              y + bmp.height), 1);
            // log.d('BitmapScale:' + bmp.bitmapscale.tostring);
          end;
        end;
      finally
        FSceneBuffer.Canvas.endScene;
      end;
    end
    else
    begin
      // Si on est en dehors de la map, on dessine une case noire
      FSceneBuffer.Canvas.BeginScene;
      try
        FSceneBuffer.Canvas.Fill.Kind := tbrushkind.Solid;
        FSceneBuffer.Canvas.Fill.Color := talphacolors.black;
        FSceneBuffer.Canvas.FillRect(Rectf(x, y, x + FSpriteWidth,
          y + FSpriteHeight), 1);
      finally
        FSceneBuffer.Canvas.endScene;
      end;
    end;
  finally
    if AAccesRestreint then
      FSceneMutex.Release;
  end;
end;

procedure TDMMap.EndUpdate;
begin
  FSceneMutex.Release;
end;

procedure TDMMap.FinaliseLaMap;
begin
  // rien � faire de particulier en sortie de map
end;

function TDMMap.getImageFromSpriteSheetRef(AImageIndex: integer): TBitmap;
begin
  if (AImageIndex >= 0) and (AImageIndex < FSpritesListe.Count) then
    result := FSpritesListe[AImageIndex]
  else
    result := nil;
end;

function TDMMap.getMapExtendedFileName(AFileNameWithoutExtension
  : string): string;
var
  FileName: string;
begin
  FileName := AFileNameWithoutExtension.Trim;
  if FileName.IsEmpty then
    raise exception.Create('Empty file name');
  FileName := tpath.Combine(getMapFilePath,
    FileName + '.' + getMapFileExtension);
  result := FileName;
end;

function TDMMap.getMapFileExtension: string;
begin
  result := 'ehm';
end;

function TDMMap.getMapFilePath: string;
var
  chemin: string;
begin
{$IF Defined(DEBUG) and Defined(MSWINDOWS)}
  chemin := tpath.Combine('..' (* Debug *) ,
    tpath.Combine('..' (* Win32/Win64 *) , tpath.Combine('..' (* src *) ,
    'NiveauxDuJeu')));
{$ELSEIF Defined(ANDROID)}
  chemin := tpath.GetDocumentsPath;
  // TODO : � changer quand les fichiers seront t�l�charg�s depuis le serveur de niveaux
{$ELSE}
  // result := tpath.Combine(tpath.Combine(tpath.GetHomePath, 'EggHunter'),    'Levels');
  chemin := extractfilepath(paramstr(0)); // TODO : chemin en RELEASE � changer
{$ENDIF}
  result := chemin;
  if not TDirectory.Exists(result) then
    TDirectory.CreateDirectory(result);
end;

function TDMMap.getNbSprite: integer;
begin
  result := SpriteSheetElements.Count;
end;

function TDMMap.getSceneBuffer: TBitmap;
begin
  FSceneMutex.Acquire;
  try
    result := FSceneBuffer;
    FisSceneBufferChanged := false;
  finally
    FSceneMutex.Release;
  end;
end;

function TDMMap.GetSpriteIDBloquantSurCase(ACol, ALig: integer): integer;
var
  i: integer;
begin
  i := 1;
  result := -1;
  while (i <= CNbZIndex) and (result = -1) do
  begin
    if (LevelMap[ACol, ALig].Zindex[i] > -1) and
      (SpriteSheetElements[LevelMap[ACol, ALig].Zindex[i]].Bloquant) then
      result := LevelMap[ACol, ALig].Zindex[i];
    inc(i);
  end;
end;

procedure TDMMap.InitialiseLaMap;
var
  i, j, k: integer;
begin
  FListeOeufs.Clear;
  FListeCanards.Clear;
  FListeCouveuses.Clear;
  FSpritesListe.Clear;
  FSpriteSheetElements.Clear;
  FSpriteSheetBitmap.SetSize(0, 0);
  FSpriteHeight := -1;
  FSpriteWidth := -1;
  FLevelMapColCount := CEggHunterMapColCount;
  FLevelMapRowCount := CEggHunterMapRowCount;
  FMapFileName := '';
  FViewportCol := 0;
  FViewportLig := 0;
  FSceneZoom := 1;
  FJoueurCol := -1;
  FJoueurLig := -1;
  FDisplayType := TMapDisplayType.plan;
  // initialisation de la grille n�cessaire uniquement pour l'�diteur de niveau, pas dans le programme du jeu
  for i := 0 to FLevelMapColCount - 1 do
    for j := 0 to FLevelMapRowCount - 1 do
      for k := 0 to CNbZIndex do
      begin
        if (FLevelMap[i, j] = nil) then
          FLevelMap[i, j] := TEggHunterMapCell.Create;
        FLevelMap[i, j].Zindex[k] := -1;
      end;
end;

procedure TDMMap.InitialiseScene(AScreenWidth, AScreenHeight: Single;
  ABitmapScale: Single);
begin
  FSceneMutex.Acquire;
  try
    ViewportNbCol := ceil(AScreenWidth / FSpriteWidth);
    ViewportNbLig := ceil(AScreenHeight / FSpriteHeight);
    FSceneBitmapScale := ABitmapScale;
    FSceneBuffer.SetSize(FViewportNbCol * FSpriteWidth,
      FViewportNbLig * FSpriteHeight);
    // TODO : ne faire le refresh que si des infos ont chang� par rapport � l'appel pr�c�dent
    FSceneInitialisee := true;
    RefreshSceneBuffer(false);
    // TODO : g�rer bitmapscale
  finally
    FSceneMutex.Release;
  end;
end;

function TDMMap.LoadFromFile(AFileName: string): boolean;
var
  Zip: TZipFile;
  Fichier: tstream;
  FichierSize: integer;
  ZIPHeader: TZIPHeader;
  Version: byte;
  e: TSpriteSheetElement;
  i, j: integer;
  bmp: TBitmap;
begin
  result := false;
  if tfile.Exists(AFileName) then
  begin
    VideLaMap;
    // Chargement du ZIP
    Zip := TZipFile.Create;
    try
      Zip.Open(AFileName, tzipmode.zmRead);
      try
        // R�cup�ration de la spritesheet (image)
        try
          Zip.Read('spritesheet.png', Fichier, ZIPHeader);
        except
          // retourne une exception si le fichier n'existe pas
          Fichier := nil;
        end;
        try
          FichierSize := Zip.FileInfo[Zip.IndexOf('spritesheet.png')
            ].UncompressedSize64;
          if (Fichier = nil) or (FichierSize < 1) then
            raise exception.Create('Spritesheet not found.');
          Fichier.Position := 0;
          FSpriteSheetBitmap.LoadFromStream(Fichier);
        finally
          Fichier.Free;
        end;

        // TODO : si la taille du stream est trop grande (ou trop petite), une des boucles ne sort pas (� tester en remettant "spritesheet.png" comme nom de fichier sur le calcul des tailles

        // R�cup�ration de la description des �l�ments de la spritesheet
        try
          Zip.Read('spritesheet.dat', Fichier, ZIPHeader);
        except
          // retourne une exception si le fichier n'existe pas
          Fichier := nil;
        end;
        try
          FichierSize := Zip.FileInfo[Zip.IndexOf('spritesheet.dat')
            ].UncompressedSize64;
          if (Fichier = nil) or (FichierSize < 1) then
            raise exception.Create('Spritesheet details not found.');
          Fichier.Position := 0;
          Fichier.Read(Version, sizeof(Version));
          if (Version >= 0) then
          begin
            Fichier.Read(FSpriteWidth, sizeof(FSpriteWidth));
            Fichier.Read(FSpriteHeight, sizeof(FSpriteHeight));
          end
          else
          begin
            FSpriteWidth := 16;
            FSpriteHeight := 16;
          end;
          while (Fichier.Position < FichierSize) do
          begin
            e := TSpriteSheetElement.Create;
            e.LoadFromStream(Version, Fichier);
            FSpriteSheetElements.Add(e);
          end;
        finally
          Fichier.Free;
        end;

        // Initialisation de la liste des images des sprites utilis�e lors de l'affichage des �crans
        ChargeListeDesImagesDeSpritesEnCache;

        // R�cup�ration de la map du niveau
        try
          Zip.Read('map.dat', Fichier, ZIPHeader);
        except
          // retourne une exception si le fichier n'existe pas
          Fichier := nil;
        end;
        try
          FichierSize := Zip.FileInfo[Zip.IndexOf('map.dat')
            ].UncompressedSize64;
          // ZIP.Size est � �viter car d�compresse le flux et perd la position
          if (Fichier = nil) or (FichierSize < 1) then
            raise exception.Create('Level map not found.');
          Fichier.Position := 0;
          Fichier.Read(Version, sizeof(Version));
          if (Version >= 0) then
          begin
            Fichier.Read(FLevelMapColCount, sizeof(FLevelMapColCount));
            if (FLevelMapColCount > CEggHunterMapColCount) then
              raise exception.Create('Too many columns in the map.');
            Fichier.Read(FLevelMapRowCount, sizeof(FLevelMapRowCount));
            if (FLevelMapRowCount > CEggHunterMapRowCount) then
              raise exception.Create('Too many rows in the map.');
          end
          else
            raise exception.Create('Map version unknown.');
          // TODO : voir si optimisation de cette partie possible
          for i := 0 to FLevelMapColCount - 1 do
            for j := 0 to FLevelMapRowCount - 1 do
            begin
              if (Fichier.Position >= FichierSize) then
                raise exception.Create('Map in file is lower than expected.');
              if (FLevelMap[i, j] = nil) then
                FLevelMap[i, j] := TEggHunterMapCell.Create;
              FLevelMap[i, j].LoadFromStream(Fichier, i, j, self);
            end;
        finally
          Fichier.Free;
        end;

        // R�cup�ration des param�tres de l'�diteur de niveau
        try
          Zip.Read('leveleditor.dat', Fichier, ZIPHeader);
        except
          // retourne une exception si le fichier n'existe pas
          Fichier := nil;
        end;
        try
          if (Fichier = nil) then
          begin
            FViewportCol := 0;
            FViewportLig := 0;
            FSceneZoom := 1;
          end
          else
          begin
            if (sizeof(FViewportCol) <> Fichier.Read(FViewportCol,
              sizeof(FViewportCol))) then
              FViewportCol := 0;
            if (sizeof(FViewportLig) <> Fichier.Read(FViewportLig,
              sizeof(FViewportLig))) then
              FViewportLig := 0;
            if (sizeof(FSceneZoom) <> Fichier.Read(FSceneZoom,
              sizeof(FSceneZoom))) then
              FSceneZoom := 0;
          end;
        finally
          Fichier.Free;
        end;
        // Fin du traitement du fichier de sauvegarde => OK
        FMapFileName := AFileName;
        result := true;
      finally
        Zip.Close;
      end;
    finally
      Zip.Free;
    end;
  end;
end;

procedure TDMMap.RefreshSceneBuffer(AAccesRestreint: boolean);
var
  i, j: integer;
begin
  if AAccesRestreint then
    FSceneMutex.Acquire;
  try
    for i := 0 to FViewportNbCol - 1 do
      for j := 0 to FViewportNbLig - 1 do
        DessineCaseDeLaMap(i + FViewportCol, j + FViewportLig, false);
  finally
    if AAccesRestreint then
      FSceneMutex.Release;
  end;
end;

function TDMMap.SaveToFile: boolean;
begin
  result := SaveToFile(MapFileName);
end;

procedure TDMMap.SetDisplayType(const Value: TMapDisplayType);
begin
  FDisplayType := Value;
end;

procedure TDMMap.SetJoueurCol(const Value: integer);
begin
  if (FJoueurCol <> Value) and (FJoueurCol > -1) and (FJoueurLig > -1) then
  begin
    FLevelMap[FJoueurCol, FJoueurLig].Zindex[CZIndexJoueur] := -1;
    DessineCaseDeLaMap(FJoueurCol, FJoueurLig);
  end;
  FJoueurCol := Value;
end;

procedure TDMMap.SetJoueurLig(const Value: integer);
begin
  if (FJoueurLig <> Value) and (FJoueurCol > -1) and (FJoueurLig > -1) then
  begin
    FLevelMap[FJoueurCol, FJoueurLig].Zindex[CZIndexJoueur] := -1;
    DessineCaseDeLaMap(FJoueurCol, FJoueurLig);
  end;
  FJoueurLig := Value;
end;

function TDMMap.SaveToFile(AFileName: string): boolean;
var
  Zip: TZipFile;
  Fichier: TMemoryStream;
  i, j: integer;
  Version: byte;
begin
  result := false;
  Zip := TZipFile.Create;
  try
    Zip.Open(AFileName, tzipmode.zmwrite);
    try
      // Enregistrement de la spritesheet (image)
      Fichier := TMemoryStream.Create;
      try
        FSpriteSheetBitmap.SaveToStream(Fichier);
        Fichier.Position := 0;
        Zip.Add(Fichier, 'spritesheet.png');
      finally
        Fichier.Free;
      end;

      // Enregistrement de la description des �l�ments de la spritesheet
      Fichier := TMemoryStream.Create;
      try
        Version := CSpriteSheetDataFileVersion;
        Fichier.Write(Version, sizeof(Version));
        Fichier.Write(FSpriteWidth, sizeof(FSpriteWidth));
        Fichier.Write(FSpriteHeight, sizeof(FSpriteHeight));
        for i := 0 to FSpriteSheetElements.Count - 1 do
          FSpriteSheetElements[i].SaveToStream(Fichier);
        Fichier.Position := 0;
        Zip.Add(Fichier, 'spritesheet.dat');
      finally
        Fichier.Free;
      end;

      // Enregistrement de la grille du jeu
      Fichier := TMemoryStream.Create;
      try
        Version := CEggHunterMapFileVersion;
        Fichier.Write(Version, sizeof(Version));
        Fichier.Write(FLevelMapColCount, sizeof(FLevelMapColCount));
        Fichier.Write(FLevelMapRowCount, sizeof(FLevelMapRowCount));
        for i := 0 to FLevelMapColCount - 1 do
          for j := 0 to FLevelMapRowCount - 1 do
            FLevelMap[i, j].SaveToStream(Fichier);
        Fichier.Position := 0;
        Zip.Add(Fichier, 'map.dat');
      finally
        Fichier.Free;
      end;

      // Enregistrement des param�tres de l'�diteur de niveaux
      Fichier := TMemoryStream.Create;
      try
        Fichier.Write(FViewportCol, sizeof(FViewportCol));
        Fichier.Write(FViewportLig, sizeof(FViewportLig));
        Fichier.Write(FSceneZoom, sizeof(FSceneZoom));
        Fichier.Position := 0;
        Zip.Add(Fichier, 'leveleditor.dat');
      finally
        Fichier.Free;
      end;
      // Fin du stockage des donn�es de la map
      FMapFileName := AFileName;
      result := true;
    finally
      Zip.Close;
    end;
  finally
    Zip.Free;
  end;
end;

procedure TDMMap.setLevelMapColCount(const Value: integer);
begin
  if (Value > 0) and (Value < CEggHunterMapColCount) then
    FLevelMapColCount := Value;
end;

procedure TDMMap.setLevelMapRowCount(const Value: integer);
begin
  if (Value > 0) and (Value < CEggHunterMapRowCount) then
    FLevelMapRowCount := Value;
end;

procedure TDMMap.SetListeCanards(const Value: TCoordList);
begin
  FListeCanards := Value;
end;

procedure TDMMap.SetListeCouveuses(const Value: TCoordList);
begin
  FListeCouveuses := Value;
end;

procedure TDMMap.SetListeOeufs(const Value: TCoordList);
begin
  FListeOeufs := Value;
end;

procedure TDMMap.SetMapFileName(const Value: string);
begin
  FMapFileName := Value;
end;

procedure TDMMap.SetSceneBitmapScale(const Value: Single);
begin
  FSceneBitmapScale := Value;
end;

procedure TDMMap.SetSceneZoom(const Value: Single);
begin
  FSceneZoom := Value;
end;

procedure TDMMap.SetViewportNbCol(const Value: integer);
begin
  FViewportNbCol := Value;
end;

procedure TDMMap.SetViewportNbLig(const Value: integer);
begin
  FViewportNbLig := Value;
end;

procedure TDMMap.SetViewportCol(const Value: integer);
begin
  ChangeViewportColLig(Value, FViewportLig);
end;

procedure TDMMap.SetViewportLig(const Value: integer);
begin
  ChangeViewportColLig(FViewportCol, Value);
end;

function TDMMap.SpriteExists(ASourceSpritesheetID, ASourceImageIndex
  : integer): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to SpriteSheetElements.Count - 1 do
    if (SpriteSheetElements[i].SourceSpritesheetID = ASourceSpritesheetID) and
      (SpriteSheetElements[i].SourceImageIndex = ASourceImageIndex) then
    begin
      result := true;
      break;
    end;
end;

procedure TDMMap.VideLaMap;
begin
  FinaliseLaMap;
  InitialiseLaMap;
end;

{ TSpriteSheetElement }

procedure TSpriteSheetElement.LoadFromStream(AVersionStockage: integer;
  AStream: tstream);
begin
  if (AVersionStockage > CSpriteSheetDataFileVersion) then
    raise exception.Create('Data file version too recent.');

  if (AVersionStockage >= 0) then
    AStream.Read(SourceImageIndex, sizeof(SourceImageIndex))
  else
    SourceImageIndex := -1;
  if (AVersionStockage >= 0) then
    AStream.Read(SourceSpritesheetID, sizeof(SourceSpritesheetID))
  else
    SourceSpritesheetID := -1;
  if (AVersionStockage >= 0) then
    AStream.Read(Zindex, sizeof(Zindex))
  else
    Zindex := 0;
  if (AVersionStockage >= 0) then
    AStream.Read(Bloquant, sizeof(Bloquant))
  else
    Bloquant := false;
  if (AVersionStockage >= 1) then
    AStream.Read(TypeElement, sizeof(TypeElement))
  else
    TypeElement := TEggHunterElementType.Decor;
end;

procedure TSpriteSheetElement.SaveToStream(AStream: tstream);
begin
  AStream.Write(SourceImageIndex, sizeof(SourceImageIndex));
  AStream.Write(SourceSpritesheetID, sizeof(SourceSpritesheetID));
  AStream.Write(Zindex, sizeof(Zindex));
  AStream.Write(Bloquant, sizeof(Bloquant));
  AStream.Write(TypeElement, sizeof(TypeElement));
end;

{ TEggHunterMapCell }

procedure TEggHunterMapCell.LoadFromStream(AStream: tstream;
  ACol, ALig: integer; AMap: TDataModule); // TODO : TDataModule => TDDMMap
var
  k: integer;
  Coordonnees: TCoord;
  Map: TDMMap;
begin
  if (AMap is TDMMap) then
    Map := AMap as TDMMap
  else
    exit;

  for k := 0 to CNbZIndex do
  begin
    // R�cup�re la valeur de la case en cours dans le flux
    if (sizeof(Zindex[k]) <> AStream.Read(Zindex[k], sizeof(Zindex[k]))) then
      Zindex[k] := -1;
    // Traite la valeur de la case en cours selon son type
    if (Zindex[k] > -1) then
      case (Map.FSpriteSheetElements[Zindex[k]].TypeElement) of
        TEggHunterElementType.Joueur:
          begin // C'est un joueur, on stocke ses coordonn�es
            Map.FJoueurCol := ACol;
            Map.FJoueurLig := ALig;
          end;
        TEggHunterElementType.Canard:
          begin // C'est un canard, on l'ajoute � la liste pour que le jeu puisse les animer
            Coordonnees := TCoord.Create;
            Coordonnees.Col := ACol;
            Coordonnees.Lig := ALig;
            Coordonnees.SpriteID := Zindex[k];
            Map.ListeCanards.Add(Coordonnees);
          end;
        TEggHunterElementType.Couveuse:
          begin // C'est une couveuse, on l'ajoute � la liste pour que le jeu puisse les animer
            Coordonnees := TCoord.Create;
            Coordonnees.Col := ACol;
            Coordonnees.Lig := ALig;
            Coordonnees.SpriteID := Zindex[k];
            Map.ListeCouveuses.Add(Coordonnees);
          end;
        TEggHunterElementType.Oeuf:
          begin // C'est un oeuf, on l'ajoute � la liste pour que le jeu puisse les traiter
            Coordonnees := TCoord.Create;
            Coordonnees.Col := ACol;
            Coordonnees.Lig := ALig;
            Coordonnees.SpriteID := Zindex[k];
            Map.ListeOeufs.Add(Coordonnees);
          end;
      end;
  end;
end;

procedure TEggHunterMapCell.SaveToStream(AStream: tstream);
var
  k: integer;
begin
  for k := 0 to CNbZIndex do
    AStream.Write(Zindex[k], sizeof(Zindex[k]));
end;

end.
