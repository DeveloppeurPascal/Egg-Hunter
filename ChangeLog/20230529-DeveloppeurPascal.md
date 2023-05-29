# 20230529 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* test de l'éditeur de niveaux et du jeu suite à une reprise du projet depuis Github pour s'assurer que tout y est

* fusion de l'écran de jeu avec l'écran principal pour une meilleure fluidité lors de l'affichage et le masquage de la fenêtre de jeu sur Mac (qui colle une animation dont on ne veut pas au niveau de l'OS)

* updated Android SDK&JAR dependencies (for Delphi 11.3 Alexandria)

* activer les contrôleurs de jeu dans l'info.plist iOS
* activer les contrôleurs de jeu dans l'info.plist macOS

* updated version number for current release : v7-20230529

* force game or main scene display on top of the current map image
* fixed clic coordinates for macOS on game elements (probably a problem of image position, not X,Y)

* fixed on screen DPad visibility first time we enable them during a game session

* updated progress bar component to hide the value or add a unit in the text
* masquage du temps restant (en texte) de la progress bar dans l'inventaire sur la couveuse

* ajout d'un programme de test pour faire des essais et adapter les progress bar
* blocage de la valeur d'affichage des progress bar à leur valeur maximale
* la barre de progression jaune a été corrigée (elle s'affichait en vert)
* correction du remplissage de la progress bar à 100% (n'affichait pas la totalité de la zone)
* ajout du verrouillage des éléments des cadres utilisés comme progress bar (Locked=true)
* suppression du HitTest des éléments des progress bar pour éviter l'interception des clics dessus
* modification de l'image affichée pour les petites valeurs (les côtés de la progress bar étant aussi adaptés), plus  rien ne s'affiche avec la valeur minimale

* changed colors order in progression bar for duck hatching

* added events on TCouveuse class to update NbOeufsEnGestation and DureeAvantEclosion on screen
* mise à jour en direct de la durée de gestation restante et du nombre d'oeufs en attente au niveau d'une couveuse

* mise à jour des informations de version sur le projet du jeu
* mise à jour des paramètres de compilation macOS ARM+x64 et AAB (32+64 bits) sur le projet du jeu

* déploiement pour Android 32 bits
* déploiement pour Android 64 bits
* déploiement pour macOS ARM
* déploiement pour Windows 32 bits
* déploiement pour Windows 64 bits
* mise à jour du projet sur itch.io et diffusion des binaires de la version 1.7 - 20230529

* mise à jour de la TODO list

* création de la release 1.7 sur GitHub
