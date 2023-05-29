# TODO List

* faire quelques captures d'écran pour mettre à jour la fiche de l'éditeur de niveaux sur itch.io

## Editeur de niveaux

* traiter les TODO dans les fichiers sources

* traduire les textes de l'éditeur de niveau
* ajouter les autres sprite sheets provenant de David Gervais
* mettre les sprite sheets de départ sur un serveur et pouvoir les rapatrier sans les avoir encodées dans le programme
* pouvoir envoyer les tableaux mis à jour sur le serveur et les rapatrier en lecture
* Ajouter animation lors des opérations longues (load, save, fill)
* Gérer déplacement de la carte avec le mouse wheel si ça passe avec la Magic Mouse d’Apple 
* gérer niveau de zoom
* gérer BitmapScale de l'image à l'écran => affichage ok, mais zone de clic mal calculée
* ajouter des raccourcis clavier pour les boutons de la toolbar et la sélection / déselection des sprites

* Ajouter Ctrl+Z pour UNDO
* Ajouter Maj+Ctrl+Z pour REDO

* corriger raccourci Ctrl+S
* corriger raccourci Ctrl+R

* ajouter filtrage des tuiles par ZIndex dans la liste des sprites du niveau

* de temps en temps les déplacements de la carte ne sont pas actifs, même avec les boutons de la barre d'outils (à priori un problème de mutex qui boque)

* afficher les coordonnées du viewport ou une vue réduite de la map quelque part pour s'y retrouver

* pouvoir afficher les différentes couches de la map et éventuellement celles qui sont dessus par transparence (opacity)

* ajouter une possibilité de travailler sur une copie d'une map (copier/coller ou renommage une fois chargée)

* le nom de la map doit être converti en nom de fichier valide avant enregistrement du fichier

* stocker le nom de la map dans ses paramètres

* Gérer un affichage «infini» en plus de l’affichage «carte» qui permettrait de ne pas voir les bords du terrain. => ajouter le bouton de passage de l'un à l'autre
* Indiquer si la map est valide (joueur, couveuse et canard positionnés)
* Afficher les coordonnées du viewport
 
* Pouvoir saisir les coordonnées du viewport pour se positionner plus vite 
* Pouvoir se positionner sur les éléments autres que le décor (recherche du joueur, recherche des canards, recherche des oeufs, recherche de l'ovni, recherche des couveuses, ...) => faire liste de coordonnées d'objets sur lesquels on veut se positionner ou retrouver directement

* savoir si un canard est à l'écran
* savoir si une couveuse est à l'écran
* savoir si un joueur est à l'écran

* bug sur saisie ZIndex : tracking avec flèches ok, valeur saisie non prise en compte

* en édition de sprites, si on choisit un type d'élément "joueur", forcer son Z-Index à la valeur de la constante, faire de même pour les autres éléments placés en dur sur un niveau

* ajouter le nom du jeu sur l'écran d'accueil

* vérifier coordonnées de clic en monde SPHERE car on sort de la map si on n'est pas en viewport dedans

* modifier les boutons de toolbar pour utiliser un background lié à l'environnement graphique du jeu
* pouvoir remplacer le bitmap d'un sprite par un autre
* pouvoir faire des modifications d'un sprite au niveau des pixels
* ajouter un éditeur de sprites (en mode dessin par pixels)
* faire un .bak à chaque enregistrement du niveau
* faire un écran d'options permettant de paramétrer l'éditeur de niveaux et notamment le nombre de .bak archives
* rendre possible un refresh de la sprite sheet d'un niveau à partir de ses différentes sources
* bouton switchant l'affichage du mode map à sphère et inversement

* sous Windows, vérifier calcul coordonnées de clic lorsqu'on change le % d'affichage dans les options d'accessibilité

* ajouter un bouton "about" pour afficher des infos sur l'éditeur de niveaux

## Jeu vidéo

* traiter les TODO dans les fichiers sources

* traduire les textes du jeu
* télécharger les maps depuis le serveur web au fur et à mesure de l'avancée du jour
* gérer déplacements du joueur "en vol"
* gérer déplacements du joueur "en bateau"
* gérer déplacements du joueur "en train"
* gérer collision joueur / ovni
* gérer collision joueur / bateau, train, passage, ...

* ajouter mode démo pour l'écran d'accueil (suppression du joueur, viewport centré sur un canard, refresh de l'écran en automatique)

* bogue : canard sur case joueur ou joueur sur case canard, problème de chevauchement et le canard chope la forme du joueur qui disparait

* dans liste des parties existantes, permettre la suppression d'archives
* dans liste des parties existantes, permettre le renommage ("Date - heure", n'étant pas hyper user friendly)

* pouvoir modifier les touches utilisées pour les déplacements dans les options du jeu (WASD au lieu des flèches)

* ajouter une fenêtre d'explications sur le fonctionnement du jeu au démarrage d'une partie

* une fois le transfert des oeufs effectués entre le joueur et la couveuse, afficher l'inventaire de la couveuse ou une animation ou autre chose (genre un nombre d'oeufs sous forme d'infobulle)

* sur la fenêtre de livraison d'oeufs à la couveuse, afficher le nombre d'oeufs de la couveuse et celui du joueur. Faire une animation de l'une vers l'autre si on effectue le livraison d'oeufs.

* changer le son associé au ramassage des oeufs

* extension : gérer la musique d'ambiance en fonction de la zone ou la map dans laquelle se trouve le joueur

* revoir/tester fonctionnement du onSaveState de l'écran de jeu (selon le type d'action l'entrainant, faire un backup ou rien, surtout si le onClose a déjà été appellé)

* selon la taille de l'écran et sa résolution : des bordures (gauche / droite) peuvent apparaître, ajouter une colonne sur la zone d'affichage

* retirer HitTest sur les frames d'éléments visuels ne nécessitant pas de clic (vérifier sur boites de dialogue, boutons, etc), fait pour progress bar
* activer Locked sur les éléments internes des frames (vérifier sur boites de dialogus, boutons, etc), fait pour progress bar

* mode démo sur écran d'accueil (suivre un canard avec une durée de vie infinie ou mettre un joueur bidon avec des mouvements aléatoires ou du path finding vers les oeufs disponibles)

* bogue : fuite mémoire en fermeture de partie les listes d'oeufs, couveuses et canards ne sont pas libérées

* progress bar : revoir fonctionnement de l'affichage sur les petites valeurs (s'affiche en rectangle avant le début de l'arrondi du fond, ça fait moche)

* gérer l'interface utilisateur (boutons de menus et de boites de dialogue) avec les contrôleurs de jeu (DPad/Joystick, boutons) ou le clavier (flèches, ENTREE/ESPACE)

* traiter les WARNING de construction

* parcourir les permissions Android pour tout désactiver
* parcourir les droits sur macOS pour tout désactiver
* parcourir les droits sur iOS pour tout désactiver

## TODO extensions du jeu
* gérer un niveau d'expérience permettant d'augmenter le niveau de certains éléments du jeu (place dans l'ovni, sur le joueur, les couveuses, ...)
* ajouter des oiseaux qui peuvent survoler les map (non bloquants, en Z-Index 8)
* ajouter des nuages qui peuvent survoler les map (non bloquants, en Z-Index 9)
* ajouter des poissons qui peuvent nager dans la mer (non bloquants, en Z-Index 3)
* mode bateau pour les déplacements du joueur en mer
* mode train pour déplacements du joueur sur chemin de fer

* points de vie sur joueur qui doit manger les canards une fois morts pour se donner de l'énergie

* possibilité de semer des plantes (depuis l'ovni), mangées par les canards pour qu'ils vivent et pondent plus longtemps

* Tester la librairie SKIA pour voir s'il y a un impact sur les défauts visuels constatés et la vitesse : https://github.com/skia4delphi/skia4delphi

-----

- tester sur Windows (32 bits)
- tester sur Windows (64 bits)
- tester sur Mac ARM
- tester sur Mac Intel
- tester sur Android
- tester sur iPad
