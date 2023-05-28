# TODO List

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
* publication du jeu pour Android
* publication du jeu pour iOS
* publication du jeu pour Linux
* soumettre le jeu à Microsoft Store pour Windows
* mettre à jour le jeu sur itch.io pour Windows
* mettre à jour le jeu sur itch.io pour Android
* mettre à jour le jeu sur itch.io pour macOS

* ajouter une fenêtre d'explications sur le fonctionnement du jeu au démarrage d'une partie
* modifier la map utilisée comme écran d'accueil et la fenêtre principale pour afficher le titre en entier (ou pouvoir l'animer un peu)

* ajouter le nom du jeu sur l'écran d'accueil (fonte graphique plutôt que sous forme d'élement de la map utilisée en démo)

* une fois le transfert des oeufs effectués entre le joueur et la couveuse, afficher l'inventaire de la couveuse ou une animation ou autre chose (genre un nombre d'oeufs sous forme d'infobulle)

* sur inventaire couveuse, masquer la valeur du temps restant ou mettre un pourcentage => adapter la progress bar et gérer plusieurs types d'affichage
* sur la fenêtre de livraison d'oeufs à la couveuse, afficher le nombre d'oeufs de la couveuse et celui du joueur. Faire une animation de l'une vers l'autre si on effectue le livraison d'oeufs.

* sous Windows, vérifier calcul coordonnées de clic lorsqu'on change le % d'affichage dans les options d'accessibilité

* dans les options pouvoir choisir si le joypad est à gauche, à droite ou des deux côtés (par défaut les deux)
* dans les options, pouvoir choisir si le joypad est découpé en deux (gauche droite / haut bas)
* gérer la position du joypad en fonction des clics du joueur sur le terrain pour éviter d'avoir à paramétrer sa position (ou pouvoir le déplacer par drag and drop depuis son centre)

* changer le son associé au ramassage des oeufs

* bogue : zone de clic déconne lorsque BitmapScale <> 1 (exemple sur Mac en 4K, décalage d'une demi-case)

* modification progress bar pour modifier l'affichage de la valeur : valeur brute, pourcentage, valeur brute + maxi, ne rien afficher
* modification fenêtre d'infos de la couveuse pour mettre la durée en pourcentage et changer la couleur (passage du rouge au vert)
* Correction : si la valeur de la progress bar est à 0, ne rien mettre, actuellement les extrémités apparaissent quand même
* Correction : si la valeur de la progress bar est au max, remplir réellement la totalité de la zone, actuellement il y a toujours un peu de marge
=> probablement un trunc() au lieu d'un round()

* extension : gérer la musique d'ambiance en fonction de la zone dans laquelle se trouve le joueur

* revoir fonctionnement du onSaveState de l'écran de jeu (selon le type d'action l'entrainant, faire un backup ou rien, surtout si le onClose a déjà été appellé)

* affichage nb oeufs et nb canards : tenter un texte en blanc et ajouter un visuel sur chaque
* affichage nb oeufs et nb canards : recalculer la largeur de la zone d'affichage

## TODO autres
* faire quelques captures d'écran pour mettre à jour la fiche sur itch.io

* bogue : sur progress bar, le jaune apparaît en vert

* bogue : affichage KO sur smartphone Ulefone U7

* bogue : fuite mémoire en fermeture de partie les listes d'oeufs, couveuses et canards ne sont pas libérées

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
