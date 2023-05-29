unit uPartieEnCours;

interface

uses
  system.Classes,
  system.Generics.Collections,
  fmx.forms,
  uDMMap;

const
  /// <summary>
  /// Temps de gestation de base
  /// (sert en prérenseignement de la durée de gestation restante sur les couveuses)
  /// </summary>
  CTempsDeGestation = 1 * 60 * 1000; // 1 minute
  // TODO : à adapter en fonction du niveau du jeu ou du niveau de chaque couveuse

type
{$SCOPEDENUMS ON}
  TPartieEncours = class; // l'implémentation suit plus bas

  /// <summary>
  /// Utilisé pour les déplacements des PNJ
  /// </summary>
  TDirectionDeDeplacement = (haut, bas, gauche, droite);

  TOeuf = class
  private const
    CVersion = 1;

  var
    FPartieEnCours: TPartieEncours;
    FSpriteID: integer;
    FCol: integer;
    FLig: integer;
    procedure SetCol(const Value: integer);
    procedure SetLig(const Value: integer);
  public
    property Col: integer read FCol write SetCol;
    property Lig: integer read FLig write SetLig;
    procedure SaveToStream(AStream: TStream);
    constructor LoadFromStream(AStream: TStream;
      APartieEnCours: TPartieEncours);
    constructor Create(ACol, ALig, ASpriteID: integer;
      APartieEnCours: TPartieEncours);
    destructor Destroy; override;
  end;

  TOeufList = class(TObjectList<TOeuf>)
  private const
    CVersion = 1;

  var
    FPartieEnCours: TPartieEncours;
  public
    procedure RamasseOeuf(ACol, ALig: integer);
    procedure SaveToStream(AStream: TStream);
    procedure LoadFromStream(AStream: TStream);
  end;

  /// <summary>
  /// Description d'un canard
  /// </summary>
  TCanard = class
  private const
    CVersion = 1;

  var
    FCol: integer;
    FLig: integer;
    FSpriteID: integer;
    FDirectionDeDeplacement: TDirectionDeDeplacement;
    FDureeDeVieRestante: integer;
    FHeurePrecedente: int64;
    FPartieEnCours: TPartieEncours;
    procedure SetCol(const Value: integer);
    procedure SetLig(const Value: integer);
    procedure SetDirectionDeDeplacement(const Value: TDirectionDeDeplacement);
    procedure ChangeDeDirection;
    procedure SetDureeDeVieRestante(const Value: integer);
  public
    /// <summary>
    /// Colonne où se trouve actuellement le canard
    /// </summary>
    property Col: integer read FCol write SetCol;

    /// <summary>
    /// Ligne où se trouve actuellement le canard
    /// </summary>
    property Lig: integer read FLig write SetLig;

    /// <summary>
    /// Direction vers laquelle va le canard
    /// </summary>
    property DirectionDeDeplacement: TDirectionDeDeplacement
      read FDirectionDeDeplacement write SetDirectionDeDeplacement;

    /// <summary>
    /// Nombre de millisecondes restantes pour ce canard
    /// </summary>
    property DureeDeVieRestante: integer read FDureeDeVieRestante
      write SetDureeDeVieRestante;

    /// <summary>
    /// Positionne le canard aux nouvelles coordonnées
    /// </summary>
    procedure DeplaceEnColLig(ACol, ALig: integer);

    /// <summary>
    /// Actions effectuées par le canard lors d'un cycle de jeu
    /// </summary>
    procedure Execute;

    /// <summary>
    /// Se déclenche lorsque le canard doit disparaître
    /// </summary>
    procedure Meurt;

    /// <summary>
    /// Indique si un canard est mort
    /// </summary>
    function isDead: boolean;

    /// <summary>
    /// Le canard pond un oeuf
    /// </summary>
    procedure PondUnOeuf;

    /// <summary>
    /// Enregistre les informations du canard dans le flux
    /// </summary>
    procedure SaveToStream(AStream: TStream);
    /// <summary>
    /// Charge les informations du canard depuis le flux
    /// </summary>
    constructor LoadFromStream(AStream: TStream;
      APartieEnCours: TPartieEncours);

    constructor Create(ACol, ALig, ASpriteID: integer;
      APartieEnCours: TPartieEncours);

    destructor Destroy; override;
  end;

  /// <summary>
  /// Liste des canards actifs sur le niveau en cours (ou dans la partie en général)
  /// </summary>
  TCanardList = class(TObjectList<TCanard>)
  private const
    CVersion = 1;

  var
    FPartieEnCours: TPartieEncours;
  public
    /// <summary>
    /// Actions effectuées à chaque cycle de jeu sur la liste et sur chacun des canards individuellement
    /// </summary>
    procedure Execute;

    /// <summary>
    /// Enregistre les informations de la liste de canards dans le flux
    /// </summary>
    procedure SaveToStream(AStream: TStream);

    /// <summary>
    /// Charge les informations de la liste de canards depuis le flux
    /// </summary>
    procedure LoadFromStream(AStream: TStream);
  end;

  /// <summary>
  /// Infos et actions liées à une couveuse
  /// </summary>
  TCouveuse = class
  private const
    CVersion = 1;

  var
    FDureeAvantEclosion: integer;
    FNbOeufsEnGestation: integer;
    FNbOeufsEnGestationMax: integer;
    FCol: integer;
    FLig: integer;
    FSpriteID: integer;
    FHeurePrecedente: int64;
    FPartieEnCours: TPartieEncours;
    procedure SetCol(const Value: integer);
    procedure SetDureeAvantEclosion(const Value: integer);
    procedure SetLig(const Value: integer);
    procedure SetNbOeufsEnGestation(const Value: integer);
    procedure SetNbOeufsEnGestationMax(const Value: integer);
  public
    /// <summary>
    /// Colonne sur laquelle se trouve la couveuse dans la carte
    /// </summary>
    property Col: integer read FCol write SetCol;
    /// <summary>
    /// Ligne sur laquelle se trouve la couveuse dans la carte
    /// </summary>
    property Lig: integer read FLig write SetLig;

    /// <summary>
    /// Nombre maximal d'oeufs acceptés par cette couveuse
    /// </summary>
    property NbOeufsEnGestationMax: integer read FNbOeufsEnGestationMax
      write SetNbOeufsEnGestationMax;
    /// <summary>
    /// Nombre d'oeufs actuellement en attende de gestation/éclosion
    /// </summary>
    property NbOeufsEnGestation: integer read FNbOeufsEnGestation
      write SetNbOeufsEnGestation;

    /// <summary>
    /// Temps (en millisecondes) avant la prochaine éclosion d'un oeuf
    /// </summary>
    property DureeAvantEclosion: integer read FDureeAvantEclosion
      write SetDureeAvantEclosion;

    /// <summary>
    /// Positionne la couveuse aux nouvelles coordonnées
    /// </summary>
    procedure DeplaceEnColLig(ACol, ALig: integer);

    /// <summary>
    /// Action effectuée par la couveuse à chaque cycle de jeu
    /// </summary>
    procedure Execute;

    /// <summary>
    /// Enregistre les informations de la couveuse dans le flux
    /// </summary>
    procedure SaveToStream(AStream: TStream);

    /// <summary>
    /// Charge les informations de la couveuse depuis le flux
    /// </summary>
    constructor LoadFromStream(AStream: TStream;
      APartieEnCours: TPartieEncours);

    constructor Create(ACol, ALig, ASpriteID: integer;
      APartieEnCours: TPartieEncours);

    destructor Destroy; override;
  end;

  /// <summary>
  /// Liste des couveuses
  /// </summary>
  TCouveuseList = class(TObjectList<TCouveuse>)
  private const
    CVersion = 1;

  var
    FPartieEnCours: TPartieEncours;
  public
    /// <summary>
    /// Retourne la couveuse aux coordonnées spécifiées
    /// </summary>
    function CouveuseAt(ACol, ALig: integer): TCouveuse;

    /// <summary>
    /// Traite un cycle de jeu sur la liste des couveuses
    /// </summary>
    procedure Execute;

    /// <summary>
    /// Enregistre les informations de chaque couveuse de la liste et la liste de couveuses elle-même dans le flux
    /// </summary>
    procedure SaveToStream(AStream: TStream);

    /// <summary>
    /// Charge les informations de chaque couveuse de la liste et la liste de couveuses elle-même depuis le flux
    /// </summary>
    procedure LoadFromStream(AStream: TStream);
  end;

  /// <summary>
  /// Informations liées à la partie en cours
  /// </summary>
  TPartieEncours = class
  private const
    CVersion = 1;

  var
    FJoueurCol: integer;
    FJoueurLig: integer;
    FNbOeufsSurJoueur: cardinal;
    FCanards: TCanardList;
    FCouveuses: TCouveuseList;
    FNbOeufsSurJoueurMaxi: cardinal;
    FEcranDuJeu: Tform;
    FCurrentMap: TDMMap;
    FOeufs: TOeufList;
    FNomFichierDeLaPartieEnCours: string;
    procedure SetJoueurCol(const Value: integer);
    procedure SetJoueurLig(const Value: integer);
    procedure SetNbOeufsSurJoueur(const Value: cardinal);
    procedure SetCanards(const Value: TCanardList);
    procedure SetCouveuses(const Value: TCouveuseList);
    procedure SetNbOeufsSurJoueurMaxi(const Value: cardinal);
    function GetNbCanardsSurLaMap: integer;
    function GetNbOeufsSurLaMap: integer;
    procedure SetOeufs(const Value: TOeufList);
  protected
    FJoueurSpriteID: integer;
  public
    // TODO : gérer le joueur sous forme de classe plutôt qu'en direct
    /// <summary>
    /// Colonne sur laquelle se trouve le joueur
    /// </summary>
    property JoueurCol: integer read FJoueurCol write SetJoueurCol;
    /// <summary>
    /// Ligne sur laquelle se trouve le joueur
    /// </summary>
    property JoueurLig: integer read FJoueurLig write SetJoueurLig;
    /// <summary>
    /// Nombre d'oeufs actuellement en poche du joueur
    /// </summary>
    property NbOeufsSurJoueur: cardinal read FNbOeufsSurJoueur
      write SetNbOeufsSurJoueur;
    /// <summary>
    /// Nombre maximal d'oeufs que le joueur peut tranposter
    /// </summary>
    property NbOeufsSurJoueurMaxi: cardinal read FNbOeufsSurJoueurMaxi
      write SetNbOeufsSurJoueurMaxi;

    /// <summary>
    /// Liste des canards sur le niveau en cours
    /// </summary>
    property Canards: TCanardList read FCanards write SetCanards;

    /// <summary>
    /// Nombre de canrads actuellement dans la map
    /// </summary>
    property NbCanardsSurLaMap: integer read GetNbCanardsSurLaMap;

    /// <summary>
    /// Liste des oeufs présents sur le niveau en cours
    /// </summary>
    property Oeufs: TOeufList read FOeufs write SetOeufs;

    /// <summary>
    /// Nombre d'oeufs actuellement dans la map
    /// </summary>
    property NbOeufsSurLaMap: integer read GetNbOeufsSurLaMap;

    /// <summary>
    /// Liste des couveuses sur le niveau en cours
    /// </summary>
    property Couveuses: TCouveuseList read FCouveuses write SetCouveuses;

    /// <summary>
    /// Initialise les éléments nécessaires pour démarrer une nouvelle partie
    /// </summary>
    procedure InitialiseLaPartie;

    /// <summary>
    /// Charge une partie depuis un fichier
    /// (à faire après initialisation de la partie)
    /// </summary>
    function LoadFromFile(AFileName: string): boolean;

    /// <summary>
    /// Enregistre la partie en cours dans un fichier
    /// </summary>
    procedure SaveToFile(AFileName: string); overload;

    /// <summary>
    /// Sauvegarde la partie avec son nom actuel ou en génère un nouveau si elle n'en a pas
    /// </summary>
    procedure SaveToFile; overload;

    /// <summary>
    /// Charge une partie depuis un flux
    /// </summary>
    function LoadFromStream(AStream: TStream): boolean;

    /// <summary>
    /// Enregistre la partie en cours dans un flux
    /// </summary>
    procedure SaveToStream(AStream: TStream);

    /// <summary>
    /// Déplace le joueur sur la carte
    /// </summary>
    procedure PositionneLeJoueur(ACol, ALig: integer);

    /// <summary>
    /// Modifie l'affichage de la scene en déplaçant le viewportpar rapport à la position du joueur
    /// </summary>
    procedure CentreLaSceneSurLejoueur;

    /// <summary>
    /// Gère les actions à faire sur un cycle de jeu
    /// => actions des canards
    /// => actions des couveuses
    /// </summary>
    procedure Execute;

    /// <summary>
    /// Crée une instance de cette classe
    /// </summary>
    constructor Create(AEcranDuJeu: Tform; ACurrentMap: TDMMap);

    /// <summary>
    /// Nettoie l'instance de cette classe
    /// </summary>
    destructor Destroy;

    /// <summary>
    /// Retourne le chemin d'accès de stockage des parties par défaut
    /// </summary>
    class function GetSaveDirectoryPath: string;

    /// <summary>
    /// Retourne un nom de fichier bidon pour le stockage des infos d'une partie
    /// </summary>
    class function CreateUniqFileName: string;

    /// <summary>
    /// Retourne l'extension par défaut des fichiers de sauvegarde des parties du jeu
    /// </summary>
    class function GetSaveFileExtension: string;
  end;

implementation

{ TPartieEnCours }

uses
  system.Diagnostics,
  system.SysUtils,
  cActionJoueurCouveuse,
  system.IOUtils,
  system.DateUtils,
  uBruitages,
  fmain;

Var
  Compteur: TStopwatch;

procedure TPartieEncours.CentreLaSceneSurLejoueur;
begin
  FCurrentMap.ChangeViewportColLig
    (FJoueurCol - (FCurrentMap.ViewportNbCol div 2),
    FJoueurLig - (FCurrentMap.ViewportNblig div 2));
end;

constructor TPartieEncours.Create(AEcranDuJeu: Tform; ACurrentMap: TDMMap);
begin
  FEcranDuJeu := AEcranDuJeu;
  FCurrentMap := ACurrentMap;

  FNomFichierDeLaPartieEnCours := '';

  // Initialise les données du joueur
  FJoueurCol := -1;
  FJoueurLig := -1;

  // Initialise la liste des couveuses
  FOeufs := TOeufList.Create;
  FOeufs.FPartieEnCours := self;

  // Initialise la liste des carands
  FCanards := TCanardList.Create;
  FCanards.FPartieEnCours := self;

  // Initialise la liste des couveuses
  FCouveuses := TCouveuseList.Create;
  FCouveuses.FPartieEnCours := self;
end;

class function TPartieEncours.CreateUniqFileName: string;
var
  dateheure: tdatetime;
begin
  dateheure := now;
  result := 'Egghunter-' + dateheure.Format('yyyymmdd') + '-' +
    dateheure.Format('hhnnss') + GetSaveFileExtension;
end;

procedure TPartieEncours.Execute;
begin
  // Traite la liste des canards
  if assigned(Canards) then
    Canards.Execute;

  // Traite la liste des couveuses
  if assigned(Couveuses) then
    Couveuses.Execute;
end;

function TPartieEncours.GetNbCanardsSurLaMap: integer;
begin
  result := FCanards.Count;
end;

function TPartieEncours.GetNbOeufsSurLaMap: integer;
begin
  result := FOeufs.Count;
end;

class function TPartieEncours.GetSaveDirectoryPath: string;
begin
{$IF Defined(DEBUG)}
  result := tpath.Combine(tpath.Combine(tpath.GetDocumentsPath,
    'EggHunter-debug'), 'Games');
{$ELSEIF Defined(ANDROID)}
  result := tpath.Combine(tpath.Combine(tpath.GetDocumentsPath,
    'EggHunter'), 'Games');
{$ELSE}
  result := tpath.Combine(tpath.Combine(tpath.GetHomePath,
    'EggHunter'), 'Games');
{$ENDIF}
  if not TDirectory.Exists(result) then
    TDirectory.CreateDirectory(result);
end;

class function TPartieEncours.GetSaveFileExtension: string;
begin
  result := '.ehg';
end;

destructor TPartieEncours.Destroy;
begin
  // Libère la mémoire de la liste de canards
  FOeufs.Free;
  FCanards.Free;
  FCouveuses.Free;
end;

procedure TPartieEncours.InitialiseLaPartie;
var
  Coord: TCoord;
begin
  // Affichage en mode sphère (monde sans rebord) pour le jeu
  FCurrentMap.DisplayType := TMapDisplayType.sphere;

  // Récupère les coordonnées du joueur
  FJoueurCol := FCurrentMap.JoueurCol;
  FJoueurLig := FCurrentMap.JoueurLig;
  FJoueurSpriteID := FCurrentMap.LevelMap[FJoueurCol, FJoueurLig].Zindex
    [CZIndexJoueur];

  // Initialise les informations d'inventaire du joueur
  FNbOeufsSurJoueur := 0;
  FNbOeufsSurJoueurMaxi := 100;
  // TODO : à basculer en constante dépendant du niveau du joueur

  // Charger la liste des canards de la partie depuis la liste des canards de la map
  FOeufs.Clear;
  if (FCurrentMap.ListeOeufs.Count > 0) then
    for Coord in FCurrentMap.ListeOeufs do
      FOeufs.Add(TOeuf.Create(Coord.Col, Coord.Lig, Coord.SpriteID, self));

  // Charger la liste des canards de la partie depuis la liste des canards de la map
  FCanards.Clear;
  if (FCurrentMap.ListeCanards.Count > 0) then
    for Coord in FCurrentMap.ListeCanards do
      FCanards.Add(TCanard.Create(Coord.Col, Coord.Lig, Coord.SpriteID, self));

  // Charger la liste des couveuses de la partie depuis la liste des couveuses de la map
  FCouveuses.Clear;
  if (FCurrentMap.ListeCouveuses.Count > 0) then
    for Coord in FCurrentMap.ListeCouveuses do
      FCouveuses.Add(TCouveuse.Create(Coord.Col, Coord.Lig,
        Coord.SpriteID, self));
end;

function TPartieEncours.LoadFromFile(AFileName: string): boolean;
var
  fs: tfilestream;
begin
  if (not AFileName.IsEmpty) and tfile.Exists(AFileName) then
  begin
    fs := tfilestream.Create(AFileName, fmOpenRead);
    try
      LoadFromStream(fs);
    finally
      fs.Free;
      FNomFichierDeLaPartieEnCours := AFileName;
    end;
  end;
end;

function TPartieEncours.LoadFromStream(AStream: TStream): boolean;
var
  VersionNum: integer;
  c, l: integer;
begin
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    VersionNum := -1; // pas d'info de version, fichier de sauvegarde foireux
  // TODO : à modifier lorsque le joueur se sera transformé en classe
  if not((VersionNum >= 0) and (sizeof(c) = AStream.read(c, sizeof(c)))) then
    c := -1;
  if not((VersionNum >= 0) and (sizeof(l) = AStream.read(l, sizeof(l)))) then
    l := -1;
  if not((VersionNum >= 0) and (sizeof(FJoueurSpriteID) = AStream.
    read(FJoueurSpriteID, sizeof(FJoueurSpriteID)))) then
    FJoueurSpriteID := -1;
  // TODO : voir s'il n'y a pas un ID par défaut à récupérer
  PositionneLeJoueur(c, l);
  if not((VersionNum >= 0) and (sizeof(FNbOeufsSurJoueur) = AStream.
    read(FNbOeufsSurJoueur, sizeof(FNbOeufsSurJoueur)))) then
    FNbOeufsSurJoueur := 0;
  if not((VersionNum >= 0) and (sizeof(FNbOeufsSurJoueurMaxi) = AStream.
    read(FNbOeufsSurJoueurMaxi, sizeof(FNbOeufsSurJoueurMaxi)))) then
    FNbOeufsSurJoueurMaxi := 100;
  // TODO : à basculer en constante dépendante du niveau du joueur
  Canards.LoadFromStream(AStream);
  Oeufs.LoadFromStream(AStream);
  Couveuses.LoadFromStream(AStream);
end;

procedure TPartieEncours.PositionneLeJoueur(ACol, ALig: integer);
var
  SpriteIDBloquant: integer;
begin
  // Si le joueur n'est pas encore sur la grille du niveau
  if (FJoueurCol < 0) or (FJoueurCol >= FCurrentMap.LevelMapcolCount) or
    (FJoueurLig < 0) or (FJoueurLig >= FCurrentMap.LevelMapRowCount) then
    exit;

  // en affichage du mode sphère, on peut déborder sur les rebords de la map
  if (FCurrentMap.DisplayType = TMapDisplayType.sphere) then
  begin
    if (ACol < 0) then
      ACol := FCurrentMap.LevelMapcolCount + ACol
    else if (ACol >= FCurrentMap.LevelMapcolCount) then
      ACol := FCurrentMap.LevelMapcolCount - ACol;
    if (ALig < 0) then
      ALig := FCurrentMap.LevelMapcolCount + ALig
    else if (ALig >= FCurrentMap.LevelMapRowCount) then
      ALig := FCurrentMap.LevelMapRowCount - ALig;
  end;

  // Si les nouvelles coordonnées sont dans la grille du niveau
  if (ACol >= 0) and (ACol < FCurrentMap.LevelMapcolCount) and (ALig >= 0) and
    (ALig < FCurrentMap.LevelMapRowCount) then
  begin
    // Si colonne ou ligne modifiée
    // Si élément disponible en Z-Index 1 (donc élément de décor sur lequel on peut se déplacer)
    if ((FJoueurCol <> ACol) or (FJoueurLig <> ALig)) and
      (FCurrentMap.LevelMap[ACol, ALig].Zindex[1] > -1) then
    begin
      // Traite collision
      SpriteIDBloquant := FCurrentMap.GetSpriteIDBloquantSurCase(ACol, ALig);
      if (SpriteIDBloquant > -1) then
        case FCurrentMap.SpriteSheetElements[SpriteIDBloquant].TypeElement of
          TEggHunterElementType.oeuf:
            begin
              if (FNbOeufsSurJoueur < FNbOeufsSurJoueurMaxi) then
              begin
                // On ramasse l'oeuf
                NbOeufsSurJoueur := NbOeufsSurJoueur + 1;
                // On retire l'oeuf de la map
                Oeufs.RamasseOeuf(ACol, ALig);
              end;
              // On indique qu'on peut accepter le déplacement
              SpriteIDBloquant := -1;
            end;
          TEggHunterElementType.passage:
            begin
              // TODO : collision avec "passage" à compléter
            end;
          TEggHunterElementType.couveuse:
            begin
              if assigned(FEcranDuJeu) and (FEcranDuJeu is TfrmMain) then
                (FEcranDuJeu as TfrmMain).BoiteDeDialogue :=
                  TcadActionJoueurCouveuse.Execute((FEcranDuJeu as TfrmMain),
                  self, Couveuses.CouveuseAt(ACol, ALig));
            end;
          TEggHunterElementType.ovni:
            begin
              // TODO : collision avec "ovni" à compléter
            end;
          TEggHunterElementType.bateau:
            begin
              // TODO : collision avec "bateau" à compléter
            end;
          TEggHunterElementType.train:
            begin
              // TODO : collision avec "train" à compléter
            end;
        end;

      // Si rien de bloquant après traitement de collision,
      // on accepte le déplacement sur la nouvelle case
      if (SpriteIDBloquant = -1) then
      begin
        FCurrentMap.BeginUpdate;
        try
          FCurrentMap.LevelMap[FJoueurCol, FJoueurLig].Zindex
            [CZIndexJoueur] := -1;
          FCurrentMap.DessineCaseDeLaMap(FJoueurCol, FJoueurLig, false);
          FJoueurCol := ACol;
          FJoueurLig := ALig;
          FCurrentMap.LevelMap[FJoueurCol, FJoueurLig].Zindex[CZIndexJoueur] :=
            FJoueurSpriteID;
          FCurrentMap.DessineCaseDeLaMap(FJoueurCol, FJoueurLig, false);
        finally
          FCurrentMap.EndUpdate;
        end;
        CentreLaSceneSurLejoueur;
      end;
    end;
  end;
end;

procedure TPartieEncours.SaveToFile(AFileName: string);
var
  folder: string;
  fs: tfilestream;
begin
  if not AFileName.IsEmpty then
  begin
    folder := tpath.GetDirectoryName(AFileName);
    if (not folder.IsEmpty) then
    begin
      if not TDirectory.Exists(folder) then
        TDirectory.CreateDirectory(folder);
      fs := tfilestream.Create(AFileName, fmcreate + fmOpenWrite);
      try
        SaveToStream(fs);
      finally
        fs.Free;
        FNomFichierDeLaPartieEnCours := AFileName;
      end;
    end;
  end;
end;

procedure TPartieEncours.SaveToFile;
begin
  if FNomFichierDeLaPartieEnCours.IsEmpty then
    FNomFichierDeLaPartieEnCours := tpath.Combine(GetSaveDirectoryPath,
      CreateUniqFileName);
  if not FNomFichierDeLaPartieEnCours.IsEmpty then
    SaveToFile(FNomFichierDeLaPartieEnCours);
end;

procedure TPartieEncours.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  AStream.Write(FJoueurCol, sizeof(FJoueurCol));
  AStream.Write(FJoueurLig, sizeof(FJoueurLig));
  AStream.Write(FJoueurSpriteID, sizeof(FJoueurSpriteID));
  AStream.Write(FNbOeufsSurJoueur, sizeof(FNbOeufsSurJoueur));
  AStream.Write(FNbOeufsSurJoueurMaxi, sizeof(FNbOeufsSurJoueurMaxi));
  // TODO : stocker le nom ou l'identifiant de la carte sur laquelle on joue
  Canards.SaveToStream(AStream);
  Oeufs.SaveToStream(AStream);
  Couveuses.SaveToStream(AStream);
end;

procedure TPartieEncours.SetCanards(const Value: TCanardList);
begin
  FCanards := Value;
end;

procedure TPartieEncours.SetCouveuses(const Value: TCouveuseList);
begin
  FCouveuses := Value;
end;

procedure TPartieEncours.SetJoueurCol(const Value: integer);
begin
  PositionneLeJoueur(Value, FJoueurLig);
end;

procedure TPartieEncours.SetJoueurLig(const Value: integer);
begin
  PositionneLeJoueur(FJoueurCol, Value);
end;

procedure TPartieEncours.SetNbOeufsSurJoueur(const Value: cardinal);
begin
  if (Value >= 0) then
  begin
    FNbOeufsSurJoueur := Value;
    // TODO : vérifier que le nombre d'oeufs est inférieur au maxi
    // TODO : afficher le nombre d'oeufs sur l'écran (si nécessaire dans l'interface utilisateur du jeu)
  end;
end;

procedure TPartieEncours.SetNbOeufsSurJoueurMaxi(const Value: cardinal);
begin
  if (Value >= 0) then
  begin
    FNbOeufsSurJoueurMaxi := Value;
    // TODO : vérifier que le nombre d'oeufs transportés actuel est bien dans l'intervale
    // TODO : mettre à jour inventaire si affiché à l'écran
  end;
end;

procedure TPartieEncours.SetOeufs(const Value: TOeufList);
begin
  FOeufs := Value;
end;

{ TCanard }

constructor TCanard.Create(ACol, ALig, ASpriteID: integer;
  APartieEnCours: TPartieEncours);
begin
  FCol := ACol;
  FLig := ALig;
  FSpriteID := ASpriteID;
  FPartieEnCours := APartieEnCours;

  // TODO : remplacer la durée maxi des canards par des constantes
  FDureeDeVieRestante := 1000 * (random(5 * 60) + 30);
  // FDureeDeVieRestante:= random(10000)+5000;
  // 5 minutes et 30 secondes maxi
  // TODO : voir si c'est le bon moment ou si ça leur fait perdre du temps de vie avant affichage et démarrage de la partie
  FHeurePrecedente := Compteur.ElapsedMilliseconds;

  ChangeDeDirection;
end;

procedure TCanard.ChangeDeDirection;
begin
  case random(4) of
    0:
      FDirectionDeDeplacement := TDirectionDeDeplacement.haut;
    1:
      FDirectionDeDeplacement := TDirectionDeDeplacement.bas;
    2:
      FDirectionDeDeplacement := TDirectionDeDeplacement.gauche;
  else
    FDirectionDeDeplacement := TDirectionDeDeplacement.droite;
  end;
end;

procedure TCanard.Execute;
var
  HeureActuelle: int64;
begin
  // Gère la durée de vie du canard
  HeureActuelle := Compteur.ElapsedMilliseconds;
  DureeDeVieRestante := DureeDeVieRestante + FHeurePrecedente - HeureActuelle;
  FHeurePrecedente := HeureActuelle;

  if isDead then
    exit;

  // Pond éventuellement un oeuf
  if ((FPartieEnCours.NbOeufsSurLaMap > 5) and (random(1000) < 5)) or
  // 0.5% de chances de pondre un oeuf s'il y en a déjà au moins 5
    ((FPartieEnCours.NbOeufsSurLaMap <= 5) and (random(100) < 5)) then
    // 5% de chances de pondre un oeuf dans le cas contraire
    PondUnOeuf;

  // Déplace le canard
  case FDirectionDeDeplacement of
    TDirectionDeDeplacement.haut:
      DeplaceEnColLig(FCol, FLig - 1);
    TDirectionDeDeplacement.bas:
      DeplaceEnColLig(FCol, FLig + 1);
    TDirectionDeDeplacement.gauche:
      DeplaceEnColLig(FCol - 1, FLig);
    TDirectionDeDeplacement.droite:
      DeplaceEnColLig(FCol + 1, FLig);
  end;

  // Changement aléatoire de direction du canard pour casser le rythme des déplacements
  if (random(1000) < 5) then
    // 0.5% de chance de se détourner en cours de déplacement
    ChangeDeDirection;
end;

function TCanard.isDead: boolean;
begin
  result := FDureeDeVieRestante < 0;
end;

procedure TCanard.DeplaceEnColLig(ACol, ALig: integer);
var
  SpriteIDBloquant: integer;
  CanardSpriteID: integer;
begin
  // Si le canard n'est pas dans la grille on plante
  if (FCol < 0) or (FCol >= FPartieEnCours.FCurrentMap.LevelMapcolCount) or
    (FLig < 0) and (FLig >= FPartieEnCours.FCurrentMap.LevelMapRowCount) then
    raise exception.Create('Duck out of map');

  // en affichage du mode sphère, on peut déborder sur les rebords de la map
  if (FPartieEnCours.FCurrentMap.DisplayType = TMapDisplayType.sphere) then
  begin
    if (ACol < 0) then
      ACol := FPartieEnCours.FCurrentMap.LevelMapcolCount + ACol
    else if (ACol >= FPartieEnCours.FCurrentMap.LevelMapcolCount) then
      ACol := FPartieEnCours.FCurrentMap.LevelMapcolCount - ACol;
    if (ALig < 0) then
      ALig := FPartieEnCours.FCurrentMap.LevelMapcolCount + ALig
    else if (ALig >= FPartieEnCours.FCurrentMap.LevelMapRowCount) then
      ALig := FPartieEnCours.FCurrentMap.LevelMapRowCount - ALig;
  end;

  // Si le déplacement est toujours dans la grille
  if (ACol >= 0) and (ACol < FPartieEnCours.FCurrentMap.LevelMapcolCount) and
    (ALig >= 0) and (ALig < FPartieEnCours.FCurrentMap.LevelMapRowCount) then
  begin
    // Si colonne ou ligne modifiée
    // Si élément disponible en Z-Index 1 à 4 (Z-Index du canard -1)
    if ((FCol <> ACol) or (FLig <> ALig)) and
      ((FPartieEnCours.FCurrentMap.LevelMap[ACol, ALig].Zindex[1] > -1) or
      (FPartieEnCours.FCurrentMap.LevelMap[ACol, ALig].Zindex[2] > -1) or
      (FPartieEnCours.FCurrentMap.LevelMap[ACol, ALig].Zindex[3] > -1) or
      (FPartieEnCours.FCurrentMap.LevelMap[ACol, ALig].Zindex[4] > -1)) then
    begin
      // Traite collision
      SpriteIDBloquant := FPartieEnCours.FCurrentMap.GetSpriteIDBloquantSurCase
        (ACol, ALig);
      if (SpriteIDBloquant > -1) then
        case FPartieEnCours.FCurrentMap.SpriteSheetElements[SpriteIDBloquant]
          .TypeElement of
          TEggHunterElementType.eau, TEggHunterElementType.oeuf:
            SpriteIDBloquant := -1;
        end;

      // Si rien de bloquant après traitement de collision,
      // on accepte le déplacement sur la nouvelle case
      if (SpriteIDBloquant = -1) then
      begin
        FPartieEnCours.FCurrentMap.BeginUpdate;
        try
          FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig].Zindex
            [CZIndexCanards] := -1;
          FPartieEnCours.FCurrentMap.DessineCaseDeLaMap(FCol, FLig, false);
          FCol := ACol;
          FLig := ALig;
          FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig].Zindex[CZIndexCanards]
            := FSpriteID;
          FPartieEnCours.FCurrentMap.DessineCaseDeLaMap(FCol, FLig, false);
        finally
          FPartieEnCours.FCurrentMap.EndUpdate;
        end;
      end
      else
        ChangeDeDirection;
    end
    else
      ChangeDeDirection;
  end
  else
    ChangeDeDirection;
end;

destructor TCanard.Destroy;
begin
  if assigned(FPartieEnCours.FCurrentMap) and (FCol >= 0) and
    (FCol < FPartieEnCours.FCurrentMap.LevelMapcolCount) and (FLig >= 0) and
    (FLig < FPartieEnCours.FCurrentMap.LevelMapRowCount) and (FSpriteID >= 0)
    and (FSpriteID < FPartieEnCours.FCurrentMap.SpriteSheetElements.Count) then
  begin
    FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig].Zindex
      [FPartieEnCours.FCurrentMap.SpriteSheetElements[FSpriteID].Zindex] := -1;
    FPartieEnCours.FCurrentMap.DessineCaseDeLaMap(FCol, FLig);
  end;
  inherited;
end;

constructor TCanard.LoadFromStream(AStream: TStream;
  APartieEnCours: TPartieEncours);
var
  VersionNum: integer;
begin
  Create(-1, -1, -1, APartieEnCours);
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    VersionNum := -1;
  if not((VersionNum >= 0) and (sizeof(FCol) = AStream.read(FCol, sizeof(FCol))))
  then
    FCol := -1;
  if not((VersionNum >= 0) and (sizeof(FLig) = AStream.read(FLig, sizeof(FLig))))
  then
    FLig := -1;
  if not((VersionNum >= 0) and (sizeof(FSpriteID) = AStream.read(FSpriteID,
    sizeof(FSpriteID)))) then
    FSpriteID := -1;
  if not((VersionNum >= 0) and (sizeof(FDureeDeVieRestante) = AStream.
    read(FDureeDeVieRestante, sizeof(FDureeDeVieRestante)))) then
    FDureeDeVieRestante := 1;
  if (FCol <> -1) and (FLig <> -1) and (FSpriteID <> -1) then
    FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig].Zindex[CZIndexCanards] :=
      FSpriteID;
end;

procedure TCanard.Meurt;
begin
  // TODO : faire une animation ou autre pour effacer le canard en beauté

  JouerBruitage(TTypeBruitage.CanardMort);

  // Supprime le canard de la liste des canards (avant le tour suivant)
  tthread.ForceQueue(nil,
    procedure
    begin
      FPartieEnCours.Canards.Remove(self);
    end);
end;

procedure TCanard.PondUnOeuf;

  function GetOeufID: integer;
  var // TODO : déplacer cette fonction dans la map
    i: integer;
  begin
    result := -1;
    for i := 0 to FPartieEnCours.FCurrentMap.SpriteSheetElements.Count - 1 do
      if (FPartieEnCours.FCurrentMap.SpriteSheetElements[i]
        .TypeElement = TEggHunterElementType.oeuf) then
      begin
        result := i;
        if (random(100) > 50) then
          break;
      end;
  end;

var
  IDSpriteBloquant: integer;
begin
  // On ne pond un oeuf que si le joueur est susceptible de le ramasser par
  // rapport à son maxi pour ne pas saturer la map au fil du temps
  if (FPartieEnCours.NbOeufsSurLaMap >= FPartieEnCours.FNbOeufsSurJoueurMaxi)
  then
    exit;

  // Si la case n'est pas bloquante (hors canard)
  IDSpriteBloquant := FPartieEnCours.FCurrentMap.GetSpriteIDBloquantSurCase
    (FCol, FLig);
  if (IDSpriteBloquant = -1) or
    (FPartieEnCours.FCurrentMap.SpriteSheetElements[IDSpriteBloquant]
    .TypeElement = TEggHunterElementType.Canard) then
  begin
    FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig].Zindex[CZIndexOeufs] :=
      GetOeufID;
    FPartieEnCours.FCurrentMap.DessineCaseDeLaMap(FCol, FLig);
    FPartieEnCours.Oeufs.Add(TOeuf.Create(FCol, FLig,
      FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig].Zindex[CZIndexOeufs],
      FPartieEnCours));

    JouerBruitage(TTypeBruitage.OeufPonte);
  end;
end;

procedure TCanard.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  AStream.Write(FCol, sizeof(FCol));
  AStream.Write(FLig, sizeof(FLig));
  AStream.Write(FSpriteID, sizeof(FSpriteID));
  AStream.Write(FDureeDeVieRestante, sizeof(FDureeDeVieRestante));
end;

procedure TCanard.SetCol(const Value: integer);
begin
  DeplaceEnColLig(Value, FLig);
end;

procedure TCanard.SetDirectionDeDeplacement(const Value
  : TDirectionDeDeplacement);
begin
  FDirectionDeDeplacement := Value;
end;

procedure TCanard.SetDureeDeVieRestante(const Value: integer);
begin
  FDureeDeVieRestante := Value;
  if (FDureeDeVieRestante <= 0) then
    Meurt;
end;

procedure TCanard.SetLig(const Value: integer);
begin
  DeplaceEnColLig(FCol, Value);
end;

{ TCouveuse }

constructor TCouveuse.Create(ACol, ALig, ASpriteID: integer;
APartieEnCours: TPartieEncours);
begin
  FCol := ACol;
  FLig := ALig;
  FSpriteID := ASpriteID;
  FPartieEnCours := APartieEnCours;
  FDureeAvantEclosion := 0;
  FNbOeufsEnGestation := 0;
  FNbOeufsEnGestationMax := 100;
  // TODO : à transformer en constante et gérer selon le niveau de la couveuse
  FHeurePrecedente := Compteur.ElapsedMilliseconds;
end;

procedure TCouveuse.DeplaceEnColLig(ACol, ALig: integer);
var
  SpriteIDBloquant: integer;
  CouveuseSpriteID: integer;
begin
  // Si la couveuse n'est pas dans la grille, on plante
  if (FCol < 0) or (FCol >= FPartieEnCours.FCurrentMap.LevelMapcolCount) or
    (FLig < 0) and (FLig >= FPartieEnCours.FCurrentMap.LevelMapRowCount) then
    raise exception.Create('Matrix out of map');
  // TODO : "matrix" => "couveuse"         (traduction)

  // en affichage du mode sphère, on peut déborder sur les rebords de la map
  if (FPartieEnCours.FCurrentMap.DisplayType = TMapDisplayType.sphere) then
  begin
    if (ACol < 0) then
      ACol := FPartieEnCours.FCurrentMap.LevelMapcolCount + ACol
    else if (ACol >= FPartieEnCours.FCurrentMap.LevelMapcolCount) then
      ACol := FPartieEnCours.FCurrentMap.LevelMapcolCount - ACol;
    if (ALig < 0) then
      ALig := FPartieEnCours.FCurrentMap.LevelMapcolCount + ALig
    else if (ALig >= FPartieEnCours.FCurrentMap.LevelMapRowCount) then
      ALig := FPartieEnCours.FCurrentMap.LevelMapRowCount - ALig;
  end;

  // Si le déplacement est toujours dans la grille
  if (ACol >= 0) and (ACol < FPartieEnCours.FCurrentMap.LevelMapcolCount) and
    (ALig >= 0) and (ALig < FPartieEnCours.FCurrentMap.LevelMapRowCount) then
  begin
    // Si colonne ou ligne modifiée
    // Si élément disponible en Z-Index 1 à 4 (Z-Index de la couveuse -1)
    if ((FCol <> ACol) or (FLig <> ALig)) and
      ((FPartieEnCours.FCurrentMap.LevelMap[ACol, ALig].Zindex[1] > -1) or
      (FPartieEnCours.FCurrentMap.LevelMap[ACol, ALig].Zindex[2] > -1) or
      (FPartieEnCours.FCurrentMap.LevelMap[ACol, ALig].Zindex[3] > -1) or
      (FPartieEnCours.FCurrentMap.LevelMap[ACol, ALig].Zindex[4] > -1)) then
    begin
      // Traite collision
      SpriteIDBloquant := FPartieEnCours.FCurrentMap.GetSpriteIDBloquantSurCase
        (ACol, ALig);
      if (SpriteIDBloquant > -1) then
        case FPartieEnCours.FCurrentMap.SpriteSheetElements[SpriteIDBloquant]
          .TypeElement of
          TEggHunterElementType.couveuse:
            // TODO : écrasement de couveuse par une couveuse, pertinent ?
            SpriteIDBloquant := -1;
        end;

      // Si rien de bloquant après traitement de collision,
      // on accepte le déplacement sur la nouvelle case
      if (SpriteIDBloquant = -1) then
      begin
        CouveuseSpriteID := FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig]
          .Zindex[CZIndexCouveuses];
        FPartieEnCours.FCurrentMap.BeginUpdate;
        try
          FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig].Zindex
            [CZIndexCouveuses] := -1;
          FPartieEnCours.FCurrentMap.DessineCaseDeLaMap(FCol, FLig, false);
          FCol := ACol;
          FLig := ALig;
          FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig].Zindex
            [CZIndexCouveuses] := CouveuseSpriteID;
          FPartieEnCours.FCurrentMap.DessineCaseDeLaMap(FCol, FLig, false);
        finally
          FPartieEnCours.FCurrentMap.EndUpdate;
        end;
      end;
    end;
  end;
end;

destructor TCouveuse.Destroy;
begin
  if assigned(FPartieEnCours.FCurrentMap) and (FCol >= 0) and
    (FCol < FPartieEnCours.FCurrentMap.LevelMapcolCount) and (FLig >= 0) and
    (FLig < FPartieEnCours.FCurrentMap.LevelMapRowCount) and (FSpriteID >= 0)
    and (FSpriteID < FPartieEnCours.FCurrentMap.SpriteSheetElements.Count) then
  begin
    FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig].Zindex
      [FPartieEnCours.FCurrentMap.SpriteSheetElements[FSpriteID].Zindex] := -1;
    FPartieEnCours.FCurrentMap.DessineCaseDeLaMap(FCol, FLig);
  end;
  inherited;
end;

procedure TCouveuse.Execute;
var
  HeureActuelle: int64;
begin
  // gère le délai de gestation
  HeureActuelle := Compteur.ElapsedMilliseconds;
  DureeAvantEclosion := DureeAvantEclosion + FHeurePrecedente - HeureActuelle;
  FHeurePrecedente := HeureActuelle;
end;

constructor TCouveuse.LoadFromStream(AStream: TStream;
APartieEnCours: TPartieEncours);
var
  VersionNum: integer;
begin
  Create(-1, -1, -1, APartieEnCours);
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    VersionNum := -1;
  if not((VersionNum >= 0) and (sizeof(FCol) = AStream.read(FCol, sizeof(FCol))))
  then
    FCol := -1;
  if not((VersionNum >= 0) and (sizeof(FLig) = AStream.read(FLig, sizeof(FLig))))
  then
    FLig := -1;
  if not((VersionNum >= 0) and (sizeof(FSpriteID) = AStream.read(FSpriteID,
    sizeof(FSpriteID)))) then
    FSpriteID := -1;
  if not((VersionNum >= 0) and (sizeof(FNbOeufsEnGestation) = AStream.
    read(FNbOeufsEnGestation, sizeof(FNbOeufsEnGestation)))) then
    FNbOeufsEnGestation := 0;
  if not((VersionNum >= 0) and (sizeof(FNbOeufsEnGestationMax) = AStream.
    read(FNbOeufsEnGestationMax, sizeof(FNbOeufsEnGestationMax)))) then
    FNbOeufsEnGestationMax := 100; // TODO : à transformer en constante
  if not((VersionNum >= 0) and (sizeof(FDureeAvantEclosion) = AStream.
    read(FDureeAvantEclosion, sizeof(FDureeAvantEclosion)))) then
    FDureeAvantEclosion := 0;
  if (FCol <> -1) and (FLig <> -1) and (FSpriteID <> -1) then
    FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig].Zindex[CZIndexCouveuses] :=
      FSpriteID;
end;

procedure TCouveuse.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  AStream.Write(FCol, sizeof(FCol));
  AStream.Write(FLig, sizeof(FLig));
  AStream.Write(FSpriteID, sizeof(FSpriteID));
  AStream.Write(FNbOeufsEnGestation, sizeof(FNbOeufsEnGestation));
  AStream.Write(FNbOeufsEnGestationMax, sizeof(FNbOeufsEnGestationMax));
  AStream.Write(FDureeAvantEclosion, sizeof(FDureeAvantEclosion));
end;

procedure TCouveuse.SetCol(const Value: integer);
begin
  if (FCol <> Value) then
  begin
    FCol := Value;
    DeplaceEnColLig(FCol, FLig);
  end;
end;

procedure TCouveuse.SetDureeAvantEclosion(const Value: integer);
  function GetCanardID: integer;
  var // TODO : déplacer cette fonction dans la map
    i: integer;
  begin
    result := -1;
    for i := 0 to FPartieEnCours.FCurrentMap.SpriteSheetElements.Count - 1 do
      if (FPartieEnCours.FCurrentMap.SpriteSheetElements[i]
        .TypeElement = TEggHunterElementType.Canard) then
      begin
        result := i;
        if (random(100) < 10) then // 10% de chance pour chaque canard
          break;
      end;
  end;

begin
  FDureeAvantEclosion := Value;
  // Si la durée passe sous 1 milliseconde (= fin de gestation d'un oeuf)
  // Si on a des oeufs en attente de gestation
  // Si la ligne en dessous de la couveuse est bien dans la grille
  if (FDureeAvantEclosion < 1) and (NbOeufsEnGestation > 0) and
    (FLig + 1 < FPartieEnCours.FCurrentMap.LevelMapRowCount) then
  begin
    // On transforme un oeuf en canard et on le libère
    NbOeufsEnGestation := NbOeufsEnGestation - 1;
    FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig + 1].Zindex[CZIndexCanards]
      := GetCanardID;
    FPartieEnCours.FCurrentMap.DessineCaseDeLaMap(FCol, FLig + 1);
    FPartieEnCours.Canards.Add(TCanard.Create(FCol, FLig + 1,
      FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig + 1].Zindex
      [CZIndexCanards], FPartieEnCours));
    JouerBruitage(TTypeBruitage.OeufEclosion);

    if (NbOeufsEnGestation > 0) then
      DureeAvantEclosion := CTempsDeGestation;
  end;
  // TODO : gérer affichage barre de progression si boite de dialogue des infos de la couveuse affichée
end;

procedure TCouveuse.SetLig(const Value: integer);
begin
  if (FLig <> Value) then
  begin
    FLig := Value;
    DeplaceEnColLig(FCol, FLig);
  end;
end;

procedure TCouveuse.SetNbOeufsEnGestation(const Value: integer);
begin
  if (Value >= 0) then
  begin
    // TODO : vérifier que le nombre d'oeufs actuels est toujours dans l'interval
    if (FNbOeufsEnGestation = 0) then
      DureeAvantEclosion := CTempsDeGestation;
    FNbOeufsEnGestation := Value;
    // TODO : rafraichir l'écran d'inventaire de cette couveuse s'il est affiché
  end;
end;

procedure TCouveuse.SetNbOeufsEnGestationMax(const Value: integer);
begin
  if (Value >= 0) then
  begin
    FNbOeufsEnGestationMax := Value;
    // TODO : vérifier que le nombre d'oeufs actuels est toujours dans l'interval
    // TODO : rafraichir l'écran d'inventaire de cette couveuse s'il est affiché
  end;
end;

{ TCanardList }

procedure TCanardList.Execute;
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
    if (not items[i].isDead) then
      items[i].Execute;
end;

procedure TCanardList.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
  NbElem: integer;
  Canard: TCanard;
begin
  Clear;
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    VersionNum := -1;
  if not((VersionNum >= 0) and (sizeof(NbElem) = AStream.read(NbElem,
    sizeof(NbElem)))) then
    NbElem := 0;
  while ((VersionNum >= 0) and (NbElem > 0)) do
    try
      Canard := TCanard.LoadFromStream(AStream, FPartieEnCours);
    finally
      if assigned(Canard) then
        Add(Canard);
      dec(NbElem);
    end;
end;

procedure TCanardList.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
  NbElem: integer;
  i: integer;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  NbElem := Count;
  AStream.Write(NbElem, sizeof(NbElem));
  for i := 0 to Count - 1 do
    items[i].SaveToStream(AStream);
end;

{ TCouveuseList }

function TCouveuseList.CouveuseAt(ACol, ALig: integer): TCouveuse;
var
  i: integer;
begin
  result := nil;
  for i := 0 to Count - 1 do
    if (items[i].FCol = ACol) and (items[i].FLig = ALig) then
    begin
      result := items[i];
      break;
    end;
end;

procedure TCouveuseList.Execute;
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
    items[i].Execute;
end;

procedure TCouveuseList.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
  NbElem: integer;
  couveuse: TCouveuse;
begin
  Clear;
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    VersionNum := -1;
  if not((VersionNum >= 0) and (sizeof(NbElem) = AStream.read(NbElem,
    sizeof(NbElem)))) then
    NbElem := 0;
  while ((VersionNum >= 0) and (NbElem > 0)) do
    try
      couveuse := TCouveuse.LoadFromStream(AStream, FPartieEnCours);
    finally
      if assigned(couveuse) then
        Add(couveuse);
      dec(NbElem);
    end;
end;

procedure TCouveuseList.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
  NbElem: integer;
  i: integer;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  NbElem := Count;
  AStream.Write(NbElem, sizeof(NbElem));
  for i := 0 to Count - 1 do
    items[i].SaveToStream(AStream);
end;

{ TOeuf }

constructor TOeuf.Create(ACol, ALig, ASpriteID: integer;
APartieEnCours: TPartieEncours);
begin
  FCol := ACol;
  FLig := ALig;
  FSpriteID := ASpriteID;
  FPartieEnCours := APartieEnCours;
end;

destructor TOeuf.Destroy;
begin
  if assigned(FPartieEnCours.FCurrentMap) and (FCol >= 0) and
    (FCol < FPartieEnCours.FCurrentMap.LevelMapcolCount) and (FLig >= 0) and
    (FLig < FPartieEnCours.FCurrentMap.LevelMapRowCount) and (FSpriteID >= 0)
    and (FSpriteID < FPartieEnCours.FCurrentMap.SpriteSheetElements.Count) then
  begin
    FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig].Zindex
      [FPartieEnCours.FCurrentMap.SpriteSheetElements[FSpriteID].Zindex] := -1;
    FPartieEnCours.FCurrentMap.DessineCaseDeLaMap(FCol, FLig);
  end;
  inherited;
end;

constructor TOeuf.LoadFromStream(AStream: TStream;
APartieEnCours: TPartieEncours);
var
  VersionNum: integer;
begin
  Create(-1, -1, -1, APartieEnCours);
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    VersionNum := -1;
  if not((VersionNum >= 0) and (sizeof(FCol) = AStream.read(FCol, sizeof(FCol))))
  then
    FCol := -1;
  if not((VersionNum >= 0) and (sizeof(FLig) = AStream.read(FLig, sizeof(FLig))))
  then
    FLig := -1;
  if not((VersionNum >= 0) and (sizeof(FSpriteID) = AStream.read(FSpriteID,
    sizeof(FSpriteID)))) then
    FSpriteID := -1;
  if (FCol <> -1) and (FLig <> -1) and (FSpriteID <> -1) then
    FPartieEnCours.FCurrentMap.LevelMap[FCol, FLig].Zindex[CZIndexOeufs] :=
      FSpriteID;
end;

procedure TOeuf.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  AStream.Write(FCol, sizeof(FCol));
  AStream.Write(FLig, sizeof(FLig));
  AStream.Write(FSpriteID, sizeof(FSpriteID));
end;

procedure TOeuf.SetCol(const Value: integer);
begin
  FCol := Value;
end;

procedure TOeuf.SetLig(const Value: integer);
begin
  FLig := Value;
end;

{ TOeufList }

procedure TOeufList.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
  NbElem: integer;
  oeuf: TOeuf;
begin
  Clear;
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    VersionNum := -1;
  if not((VersionNum >= 0) and (sizeof(NbElem) = AStream.read(NbElem,
    sizeof(NbElem)))) then
    NbElem := 0;
  while ((VersionNum >= 0) and (NbElem > 0)) do
    try
      oeuf := TOeuf.LoadFromStream(AStream, FPartieEnCours);
    finally
      if assigned(oeuf) then
        Add(oeuf);
      dec(NbElem);
    end;
end;

procedure TOeufList.RamasseOeuf(ACol, ALig: integer);
begin
  for var oeuf in self do
    if (oeuf.Col = ACol) and (oeuf.Lig = ALig) then
    begin
      JouerBruitage(TTypeBruitage.OeufRamassage);
      Remove(oeuf);
      break;
    end;
end;

procedure TOeufList.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
  NbElem: integer;
  i: integer;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  NbElem := Count;
  AStream.Write(NbElem, sizeof(NbElem));
  for i := 0 to Count - 1 do
    items[i].SaveToStream(AStream);
end;

initialization

randomize;

Compteur := TStopwatch.StartNew;

end.
