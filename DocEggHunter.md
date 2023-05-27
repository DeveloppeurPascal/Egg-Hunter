# Egg Hunter

## Format de stockage d'une map

### grille du terrain

#### élément de background (Z-Index 0 à 3)

Sol sur lequel on se déplace, avec des éléments potentiellement bloquants, les personnages et objets inanimés se placent dessus.

#### élément mouvants (Z-Index 4 et 5)

Contient les éléments bloquants, les personnages, le(s) joueur(s), éléments à ramasser ou détruire, les passages vers d'autres niveaux...

#### élément de foreground (Z-Index 6 à 8)

Eléments par dessus le décor, derrière lesquels on peut afficher les personnages et autres éléments bloquants.

#### élément de foreground (Z-Index 9 et 10)

Eléments en vol au dessus de la map

### spritesheet utilisée sur le niveau

* images des différents éléments affichables sur le niveau
=> PNG avec transparence

* grille de correspondance entre les éléments utilisés et leur spritesheet d'origine
=> tableau avec indice des éléments dans la spritesheet du jeu + indice de l'élément dans sa spritesheet source et ID de la spritesheet

- version (byte) du stockage
- largeur / hauteur (integer) des éléments de la spritesheet
- Liste des éléments de la grille de jeu
	- (integer) ID SpriteSheet source
	- (integer) ID dans la SpriteSheet source
	- (byte) Z-Index de l'élément (0, 1 ou 2)
	- (boolean) Bloquant ? => si false, personnage sur case autorisé, si true personnage ne peut pas passer
	- (enum) Type d'élément => TEggHunterElementType

## Egg Hunter Level Editor

### Ecrans du jeu

* Menu de l'accueil (fMain.pas)
=> Création d'un niveau de jeu
=> Chargement d'un niveau de jeu
=> Sortie du programme (Windows, MacOS, Linux)

* Création d'un niveau (fMapAdd.pas)
=> Choix de la taille du terrain de jeu = nbCol, nbLig de la grille
=> Nom du fichier de stockage
=> Passage en édition
=> Retour au menu

* Chargement d'un niveau de jeu (fMapLoad.pas)
=> Choix du fichier stockant le niveau
=> Passage en édition
=> Retour au menu

* Ecran de dessin du dessin (fMapEdit.pas)
=> Sauvegarder les données
=> Choisir les différents spritesheets disponibles pour en utiliser les éléments
=> Définir les propriétés des éléments utilisés dans l'écran (z-index, bloquants, type, ...)
=> Poser les éléments sur la map
=> Déplacer la vue de la map
=> Zoomer / dézoomer la vue sur la map
=> Retour au menu

* Extensions
=> suppression d'une map
=> choix de la map par défaut pour le jeu
=> activation / désactivation des maps (mise en ligne ou pas)
=> ...

### Raccourcis clavier dans l'éditeur de niveau

* flèches pour déplacer la vue sur la carte
* ESC / HardwareBack pour sortir
* Ctrl+S pour sauvegarder
* Ctrl+R pour activer/désactiver le Fill sur une zone avec le sprite en cours

Clic gauche sur la map pose un sprite activé (éventuellement avec mouvement ou remplissage de zone)
Clic droit sur la map retire le sprite activé (éventuellement avec mouvement ou remplissage de zone)

## Egg Hunter

### Règles de déplacement et collisions générales

Le Z-Index 0 de la map n'est utilisé que comme background pour l'affichage des autres éléments.
Le statut bloquant de ce sprite n'est pas pris en compte.

Si un élément de Z-Index > 0 est bloquant, on traite les collisions.

### Déplacements du joueur "à pieds"

Le joueur est en Z-Index 5.
Se déplace uniquement si un élément est disponible en Z-Index 1.
Gère les collisions si un élément de la case est bloquant.
Si c'est un oeuf, on le ramasse et on se positionne dessus.
Si c'est l'ovni, on demande à l'utilisateur s'il veut décoler.
Si c'est une couveuse, on  demande à l'utilisateur sil veut y déposer des oeufs.
Dans les autres cas le déplacement sur la case est refusé.

### Déplacements du joueur "en vol"

L'OVNI est en Z-Index 5 lorsqu'il est au sol.
L'OVNI est en Z-Index 10 lorsqu'il vole.
Au sol, il ne peut être que sur des cases ayant un élément en Z-Index 1 et n'ayant aucun sprite bloquant.
En vol, il ne traite aucune collision et peut passer partout.

### Déplacements du joueur "en mer"

=> extension possible du jeu : placer des bâteaux et pouvoir les piloter pour passer d'une ile à l'autre sans utiliser son ovni.

### Déplacements du joueur "en train"

=> extension possible du jeu : placer des voies férées et des wagonets dans lesquels le joueur peut monter pour se déplacer rapidement au sol

### Déplacements des canards

Les canards évoluent en Z-Index 5.
Ils ne peuvent se positionner que si un élément est présent en Z-Index 1 à 4 et si aucun élément n'est bloquant sur la case.
Les canards peuvent aller dans l’eau mais pas en mer. => gérer un type d'élément "eau"
En cas de collision ils prennent une direction au hasard jusqu'à se débloquer.
Leur nombre est indéfini.
Au démarrage du jeu ils viennent de la map.
En cours de jeu ils sont créés autour des couveuses.
Pendant leur temps de vie les canards peuvent pondre des oeufs. Les oeufs sont en Z-Index 4.
Les canards peuvent passer par dessus les oeufs sans traiter les collisions éventuelles.
