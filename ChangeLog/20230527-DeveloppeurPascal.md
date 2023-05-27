# 20230527 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* open sourced "Egg Hunter" game project
* added original source files in the [Delphi Projects Template](https://github.com/DeveloppeurPascal/Delphi-Projects-Template) structure
* updated the git files filter list (to hide assets/ and _PRIVE/ folders)
* updated the README FR/EN files from the template to this game project
* updated the game icons (PNG) and added the JPEG images
* added level editor icons
* changed the default level map for DEBUG+WINDOWS release
* added icons to Level Editor project options
* added icons to Egg Hunter project options
* removed iOS simulator platform from Level Editor project
* added Linux x64 platform to Level Editor project
* activation par défaut des contrôles tactiles à l'écran, si l'appareil est tactile, puis iOS/Android
* affichage des infos de version sur l'accueil + suppression de l'écran de jeu

* ajout dépendance avec [DeveloppeurPascal/librairies](https://github.com/DeveloppeurPascal/librairies)
* ajout dépendance avec [DeveloppeurPascal/Delphi-Game-Engine](https://github.com/DeveloppeurPascal/Delphi-Game-Engine)

* remplacement de uParam.pas par la version à jour (Olf.RTL.Params.pas) provenant de [DeveloppeurPascal/librairies](https://github.com/DeveloppeurPascal/librairies)
* remplacement de uMusicLoop.pas copié depuis [DeveloppeurPascal/Delphi-FMX-Game-Snippets](https://github.com/DeveloppeurPascal/Delphi-FMX-Game-Snippets) par la version à jour (Olf.FMX.MusicLoop.pas) provenant de [DeveloppeurPascal/Delphi-Game-Engine](https://github.com/DeveloppeurPascal/Delphi-Game-Engine)

* correction d'une violation d'accès qui se produisait parfois lors d'une nouvelle partie ou en sortie d'une partie sur Mac
* correction : passage en full screen inopérant sur la fenêtre du jeu mais ok sur la principale (sur Mac)
* removed showHint on main and game forms

* changer format d'affichage des nombres d'oeufs et de canard en cours de partie (mettre le texte en forme et en images)

* mise à jour de la TODO liste du jeu
* mise à jour de la TODO liste de l'éditeur de niveaux