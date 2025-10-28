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
  File last update : 2025-02-09T12:07:49.678+01:00
  Signature : f8f5c08bb6086aadb9cbb0ea05afef98fdd31704
  ***************************************************************************
*)

unit fMapEdit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, cToolButtons,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.EditBox,
  FMX.SpinBox, FMX.ListBox, FMX.Objects, cSpriteButton, uDMMap;

type
  TfrmMapEdit = class(TForm)
    zoneToolBar: TLayout;
    btnSave: TcadToolButtons;
    btnQuitter: TcadToolButtons;
    btnRemplissage: TcadToolButtons;
    btnAjoutSprite: TcadToolButtons;
    btnZoomReduire: TcadToolButtons;
    btnZoomAgrandir: TcadToolButtons;
    btnDeplacementVersLeBas: TcadToolButtons;
    btnDeplacementVersLeHaut: TcadToolButtons;
    btnDeplacementVersLaDroite: TcadToolButtons;
    btnDeplacementVersLaGauche: TcadToolButtons;
    zonePalette: TLayout;
    zoneSpritesDeLaMap: TVertScrollBox;
    zoneProprietes: TLayout;
    lblSpriteSource: TLabel;
    lblSpriteType: TLabel;
    lblSpriteBloquant: TLabel;
    lblSpriteZIndex: TLabel;
    lblSpriteSourceValue: TLabel;
    edtSpriteZIndex: TSpinBox;
    swSpriteBloquant: TSwitch;
    cbSpriteType: TComboBox;
    lblSpriteID: TLabel;
    lblSpriteIDValue: TLabel;
    PaletteSplitter: TSplitter;
    imgScene: TImage;
    zoneSpritesDeLaMapContent: TFlowLayout;
    timerRefreshScene: TTimer;
    btnUndo: TcadToolButtons;
    btnRedo: TcadToolButtons;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnQuitterClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDeplacementVersLaGaucheClick(Sender: TObject);
    procedure btnDeplacementVersLaDroiteClick(Sender: TObject);
    procedure btnDeplacementVersLeHautClick(Sender: TObject);
    procedure btnDeplacementVersLeBasClick(Sender: TObject);
    procedure btnZoomAgrandirClick(Sender: TObject);
    procedure btnZoomReduireClick(Sender: TObject);
    procedure btnAjoutSpriteClick(Sender: TObject);
    procedure btnRemplissageClick(Sender: TObject);
    procedure zoneSpritesDeLaMapResize(Sender: TObject);
    procedure swSpriteBloquantSwitch(Sender: TObject);
    procedure cbSpriteTypeChange(Sender: TObject);
    procedure timerRefreshSceneTimer(Sender: TObject);
    procedure imgSceneResize(Sender: TObject);
    procedure btnRedoClick(Sender: TObject);
    procedure btnUndoClick(Sender: TObject);
    procedure imgSceneMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);
    procedure imgSceneMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure edtSpriteZIndexChangeTracking(Sender: TObject);
  private
    FModificationsEffectuees: Boolean;
    FSelectedSpriteButton: TcadSpriteButton;
    FSelectedSpriteID: integer;
    FSelectedSpriteElement: TSpriteSheetElement;
    procedure SetModificationsEffectuees(const Value: Boolean);
    procedure SetSelectedSprite(const Value: TcadSpriteButton);
  public
    /// <summary>
    /// Propriété indiquant qu'une modification du niveau a été effectué
    /// </summary>
    property ModificationsEffectuees: Boolean read FModificationsEffectuees
      write SetModificationsEffectuees;

    /// <summary>
    /// Image du sprite actuellement sélectionnée dans la liste des sprites de la map
    /// </summary>
    property SelectedSpriteButton: TcadSpriteButton read FSelectedSpriteButton
      write SetSelectedSprite;

    /// <summary>
    /// Déclenché lorsqu'on clique sur un sprite de la liste des sprites du niveau
    /// </summary>
    procedure SpriteClick(Sender: TObject);

    /// <summary>
    /// Ajoute un sprite de la map en cours dans la zone de sélection des sprites
    /// </summary>
    procedure AjouteBoutonSprite(ASpriteIndex: integer);

    /// <summary>
    /// Effectue le calcul de la hauteur de la zone contenant les boutons de sprites
    /// </summary>
    procedure RecalculeHauteurZoneSpritesDeLaMapContent;

    /// <summary>
    /// Applique le sprite sélectionné aux coordonnées x,y (pixels) de la grille du niveau
    /// </summary>
    procedure AppliqueSpriteSelectionneSurCellule(X, Y: Single);

    /// <summary>
    /// Efface le sprite sélectionné des sprites de la case en cours
    /// </summary>
    procedure AnnuleSpriteSelectionneSurCellule(X, Y: Single);
  end;

implementation

{$R *.fmx}

uses fMapSpriteAdd, System.TypInfo, uDMSpriteSheets;

// TODO : save/load hauteur de la zone des propriétés (pour garder le paramétrage lié au PropertySplitter
// TODO : save/load largeur de la zone de la palette (pour garder le paramétrage lié au PaletteSplitter
procedure TfrmMapEdit.AjouteBoutonSprite(ASpriteIndex: integer);
var
  btn: TcadSpriteButton;
begin
  btn := TcadSpriteButton.Create(self);
  btn.Name := '';
  btn.Parent := zoneSpritesDeLaMapContent;
  btn.SetSprite(ASpriteIndex);
  btn.OnClick := SpriteClick;
  btn.Margins.Top := 5;
  btn.Margins.right := 5;
  btn.Margins.bottom := 5;
  btn.Margins.left := 5;
  ModificationsEffectuees := true;
  RecalculeHauteurZoneSpritesDeLaMapContent;
end;

procedure TfrmMapEdit.AnnuleSpriteSelectionneSurCellule(X, Y: Single);
  procedure Effacement(Col, Lig, IDAEffacer, Zindex: integer);
  begin // TODO : à optimiser pour ne pas planter en cas d'appel récursif sur une zone trop grande (cf remplissage)
    if (Lig >= 0) and (Lig < DMMap.LevelMapRowCount) and (Col >= 0) and
      (Col < DMMap.LevelMapcolCount) and
      (DMMap.LevelMap[Col, Lig].Zindex[Zindex] = IDAEffacer) then
    begin
      DMMap.LevelMap[Col, Lig].Zindex[Zindex] := -1;
      DMMap.DessineCaseDeLaMap(Col, Lig);
      Effacement(Col + 1, Lig, IDAEffacer, Zindex);
      Effacement(Col - 1, Lig, IDAEffacer, Zindex);
      Effacement(Col, Lig + 1, IDAEffacer, Zindex);
      Effacement(Col, Lig - 1, IDAEffacer, Zindex);
    end;
  end;

var
  ColDansViewport, LigDansViewport: integer;
  ColDansMap, LigDansMap: integer;
begin
  if (FSelectedSpriteID >= 0) then
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
    // Si le sprite sélectionné est différent du sprite actuel au niveau du ZIndex, on change et on redessine la case
    if (LigDansMap >= 0) and (LigDansMap < DMMap.LevelMapRowCount) and
      (ColDansMap >= 0) and (ColDansMap < DMMap.LevelMapcolCount) and
      (DMMap.LevelMap[ColDansMap, LigDansMap].Zindex
      [FSelectedSpriteElement.Zindex] = FSelectedSpriteID) then
      if (btnRemplissage.isActif) and
        (FSelectedSpriteElement.TypeElement <> TEggHunterElementType.joueur)
      then
      begin // mode remplissage de la zone
        Effacement(ColDansMap, LigDansMap, FSelectedSpriteID,
          FSelectedSpriteElement.Zindex);
        ModificationsEffectuees := true;
        btnRemplissage.isActif := false;
      end
      else
      begin // mode changement de cellule
        DMMap.LevelMap[ColDansMap, LigDansMap].Zindex
          [FSelectedSpriteElement.Zindex] := -1;
        DMMap.DessineCaseDeLaMap(ColDansMap, LigDansMap);
        ModificationsEffectuees := true;
        if (FSelectedSpriteElement.TypeElement = TEggHunterElementType.joueur)
        then
        begin
          DMMap.JoueurCol := -1;
          DMMap.JoueurLig := -1;
        end;
      end;
  end;
end;

procedure Remplissage(Col, Lig, IDARemplacer, NouvelID, Zindex: integer);
begin // TODO : à mettre en methode privée si on conserve la mise en file d'attente
  if (Lig >= 0) and (Lig < DMMap.LevelMapRowCount) and (Col >= 0) and
    (Col < DMMap.LevelMapcolCount) and
    (DMMap.LevelMap[Col, Lig].Zindex[Zindex] = IDARemplacer) then
  begin
    DMMap.LevelMap[Col, Lig].Zindex[Zindex] := NouvelID;
    DMMap.DessineCaseDeLaMap(Col, Lig);
    tthread.ForceQueue(nil,
      procedure
      begin
        Remplissage(Col - 1, Lig, IDARemplacer, NouvelID, Zindex);
      end);
    tthread.ForceQueue(nil,
      procedure
      begin
        Remplissage(Col + 1, Lig, IDARemplacer, NouvelID, Zindex);
      end);
    tthread.ForceQueue(nil,
      procedure
      begin
        Remplissage(Col, Lig - 1, IDARemplacer, NouvelID, Zindex);
      end);
    tthread.ForceQueue(nil,
      procedure
      begin
        Remplissage(Col, Lig + 1, IDARemplacer, NouvelID, Zindex);
      end);
  end;
end;

procedure TfrmMapEdit.AppliqueSpriteSelectionneSurCellule(X, Y: Single);
var
  ColDansViewport, LigDansViewport: integer;
  ColDansMap, LigDansMap: integer;
begin
  if (FSelectedSpriteID >= 0) then
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
    // Si le sprite sélectionné est différent du sprite actuel au niveau du ZIndex, on change et on redessine la case
    if (LigDansMap >= 0) and (LigDansMap < DMMap.LevelMapRowCount) and
      (ColDansMap >= 0) and (ColDansMap < DMMap.LevelMapcolCount) and
      (DMMap.LevelMap[ColDansMap, LigDansMap].Zindex
      [FSelectedSpriteElement.Zindex] <> FSelectedSpriteID) then
      if (btnRemplissage.isActif) and
        (FSelectedSpriteElement.TypeElement <> TEggHunterElementType.joueur)
      then
      begin // mode remplissage de la zone
        Remplissage(ColDansMap, LigDansMap, DMMap.LevelMap[ColDansMap,
          LigDansMap].Zindex[FSelectedSpriteElement.Zindex], FSelectedSpriteID,
          FSelectedSpriteElement.Zindex);
        ModificationsEffectuees := true;
        btnRemplissage.isActif := false;
      end
      else
      begin // mode changement de cellule
        if (FSelectedSpriteElement.TypeElement = TEggHunterElementType.joueur)
        then
        begin
          // TODO : vérifier que la position choisie est valide (ZIndex 1 ok, pas d'élément bloquant sur place)
          // si pas ok, ne pas placer l'élément sur la case
          DMMap.JoueurCol := ColDansMap;
          DMMap.JoueurLig := LigDansMap;
          DMMap.LevelMap[ColDansMap, LigDansMap].Zindex
            [FSelectedSpriteElement.Zindex] := FSelectedSpriteID;
          DMMap.DessineCaseDeLaMap(ColDansMap, LigDansMap);
          ModificationsEffectuees := true;
        end
        else
        begin
          DMMap.LevelMap[ColDansMap, LigDansMap].Zindex
            [FSelectedSpriteElement.Zindex] := FSelectedSpriteID;
          DMMap.DessineCaseDeLaMap(ColDansMap, LigDansMap);
          ModificationsEffectuees := true;
        end;
      end;
  end;
end;

procedure TfrmMapEdit.btnAjoutSpriteClick(Sender: TObject);
var
  f: TfrmMapSpriteAdd;
begin
  f := TfrmMapSpriteAdd.Create(owner, self);
{$IF Defined(IOS) and Defined(ANDROID)}
  f.Show;
{$ELSE}
  f.ShowModal;
{$ENDIF}
end;

procedure TfrmMapEdit.btnDeplacementVersLaDroiteClick(Sender: TObject);
begin
  DMMap.ViewportCol := DMMap.ViewportCol + 1;
  ModificationsEffectuees := true;
end;

procedure TfrmMapEdit.btnDeplacementVersLaGaucheClick(Sender: TObject);
begin
  DMMap.ViewportCol := DMMap.ViewportCol - 1;
  ModificationsEffectuees := true;
end;

procedure TfrmMapEdit.btnDeplacementVersLeBasClick(Sender: TObject);
begin
  DMMap.ViewportLig := DMMap.ViewportLig + 1;
  ModificationsEffectuees := true;
end;

procedure TfrmMapEdit.btnDeplacementVersLeHautClick(Sender: TObject);
begin
  DMMap.ViewportLig := DMMap.ViewportLig - 1;
  ModificationsEffectuees := true;
end;

procedure TfrmMapEdit.btnQuitterClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMapEdit.btnRedoClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TfrmMapEdit.btnRemplissageClick(Sender: TObject);
begin
  btnRemplissage.isActif := not btnRemplissage.isActif;
end;

procedure TfrmMapEdit.btnSaveClick(Sender: TObject);
begin
  ModificationsEffectuees := FModificationsEffectuees and
    (not DMMap.SaveToFile);
  showmessage('Sauvegarde effectuée');
  // TODO : mettre une info signalant que la sauvegarde est faite
end;

procedure TfrmMapEdit.btnUndoClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TfrmMapEdit.btnZoomAgrandirClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TfrmMapEdit.btnZoomReduireClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TfrmMapEdit.cbSpriteTypeChange(Sender: TObject);
begin
  if (FSelectedSpriteID >= 0) and (cbSpriteType.Selected <> nil) then
  begin
    DMMap.SpriteSheetElements[FSelectedSpriteID].TypeElement :=
      TEggHunterElementType(cbSpriteType.Selected.Tag);
    ModificationsEffectuees := true;
  end;
end;

procedure TfrmMapEdit.edtSpriteZIndexChangeTracking(Sender: TObject);
begin
  if (FSelectedSpriteID >= 0) then
  begin
    DMMap.SpriteSheetElements[FSelectedSpriteID].Zindex :=
      trunc(edtSpriteZIndex.Value);
    ModificationsEffectuees := true;
  end;
end;

procedure TfrmMapEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tthread.ForceQueue(nil,
    procedure
    begin
      self.Free;
    end);
end;

procedure TfrmMapEdit.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FModificationsEffectuees then
  begin
    // TODO : refuser la sortie si des modifications ont été faites depuis la dernière sauvegarde
  end;
end;

procedure TfrmMapEdit.FormCreate(Sender: TObject);
var
  i, nb: integer;
  idx: integer;
begin
  // Initialisation des icones des boutons d'interface (chemin du TPath non stocké dans le .FMX lorsqu'il provient d'une TFrame)
  // https://quality.embarcadero.com/browse/RSP-36037
  btnSave.SVG.Data.Data :=
    'M15,9H5V5H15M12,19A3,3 0 0,1 9,16A3,3 0 0,1 12,13A3,3 ' +
    '0 0,1 15,16A3,3 0 0,1 12,19M17,3H5C3.89,3 3,3.9 3,5V19A2,2 0 0,0 5,21H19A2,'
    + '2 0 0,0 21,19V7L17,3Z';
  btnQuitter.SVG.Data.Data :=
    'M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,' +
    '17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z';
  btnRemplissage.SVG.Data.Data :=
    'M19,11.5C19,11.5 17,13.67 17,15A2,2 0 0,0 19,17' +
    'A2,2 0 0,0 21,15C21,13.67 19,11.5 19,11.5M5.21,10L10,5.21L14.79,10M16.56,8.'
    + '94L7.62,0L6.21,1.41L8.59,3.79L3.44,8.94C2.85,9.5 2.85,10.47 3.44,11.06L8.'
    + '94,16.56C9.23,16.85 9.62,17 10,17C10.38,17 10.77,16.85 11.06,16.56L16.56,'
    + '11.06C17.15,10.47 17.15,9.5 16.56,8.94Z';
  btnAjoutSprite.SVG.Data.Data :=
    'M7 19L12 14L13.88 15.88C13.33 16.79 13 17.86 13' +
    ' 19H7M10 10.5C10 9.67 9.33 9 8.5 9S7 9.67 7 10.5 7.67 12 8.5 12 10 11.33 10'
    + ' 10.5M13.09 20H6V4H13V9H18V13.09C18.33 13.04 18.66 13 19 13C19.34 13 19.6'
    + '7 13.04 20 13.09V8L14 2H6C4.89 2 4 2.9 4 4V20C4 21.11 4.89 22 6 22H13.81C'
    + '13.46 21.39 13.21 20.72 13.09 20M18 15V18H15V20H18V23H20V20H23V18H20V15H18Z';
  btnZoomReduire.SVG.Data.Data :=
    'M15.5,14H14.71L14.43,13.73C15.41,12.59 16,11.11' +
    ' 16,9.5A6.5,6.5 0 0,0 9.5,3A6.5,6.5 0 0,0 3,9.5A6.5,6.5 0 0,0 9.5,16C11.11,'
    + '16 12.59,15.41 13.73,14.43L14,14.71V15.5L19,20.5L20.5,19L15.5,14M9.5,14C7'
    + ',14 5,12 5,9.5C5,7 7,5 9.5,5C12,5 14,7 14,9.5C14,12 12,14 9.5,14M7,9H12V1'
    + '0H7V9Z';
  btnZoomAgrandir.SVG.Data.Data :=
    'M15.5,14L20.5,19L19,20.5L14,15.5V14.71L13.73,1' +
    '4.43C12.59,15.41 11.11,16 9.5,16A6.5,6.5 0 0,1 3,9.5A6.5,6.5 0 0,1 9.5,3A6.'
    + '5,6.5 0 0,1 16,9.5C16,11.11 15.41,12.59 14.43,13.73L14.71,14H15.5M9.5,14C'
    + '12,14 14,12 14,9.5C14,7 12,5 9.5,5C7,5 5,7 5,9.5C5,12 7,14 9.5,14M12,10H1'
    + '0V12H9V10H7V9H9V7H10V9H12V10Z';
  btnDeplacementVersLeBas.SVG.Data.Data :=
    'M11,4H13V16L18.5,10.5L19.92,11.92L12,19.84L4.08,11.92L5.5,10.5L11,16V4Z';
  btnDeplacementVersLeHaut.SVG.Data.Data :=
    'M13,20H11V8L5.5,13.5L4.08,12.08L12,4.16L19.92,12.08L18.5,13.5L13,8V20Z';
  btnDeplacementVersLaDroite.SVG.Data.Data :=
    'M4,11V13H16L10.5,18.5L11.92,19.92L19.84,12L11.92,4.08L10.5,5.5L16,11H4Z';
  btnDeplacementVersLaGauche.SVG.Data.Data :=
    'M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z';
  btnUndo.SVG.Data.Data :=
    'M12.5,8C9.85,8 7.45,9 5.6,10.6L2,7V16H11L7.38,12.38C8.77,11.22 10.54,10.5 1'
    + '2.5,10.5C16.04,10.5 19.05,12.81 20.1,16L22.47,15.22C21.08,11.03 17.15,8 1'
    + '2.5,8Z';
  btnRedo.SVG.Data.Data :=
    'M18.4,10.6C16.55,9 14.15,8 11.5,8C6.85,8 2.92,11.03 1.54,15.22L3.9,16C4.95,'
    + '12.81 7.95,10.5 11.5,10.5C13.45,10.5 15.23,11.22 16.62,12.38L13,16H22V7L1'
    + '8.4,10.6Z';

  // Pas de modif
  ModificationsEffectuees := false;

  // Pas de sprite sélectionné
  SelectedSpriteButton := nil;

  // Affichage de la liste des sprites de la spritesheet
  nb := DMMap.getNbSprite;
  for i := 0 to nb - 1 do
    AjouteBoutonSprite(i);

  // Initialisation liste des types d'éléments
  cbSpriteType.Items.Clear;
  for var ehet := low(TEggHunterElementType) to high(TEggHunterElementType) do
  begin
    idx := cbSpriteType.Items.Add(GetEnumName(typeinfo(TEggHunterElementType),
      ord(ehet)));
    cbSpriteType.ListItems[idx].Tag := ord(ehet);
  end;

  // TODO : Affichage de la map après s'être positionné dessus et avoir réglé le zoom à 0
end;

procedure TfrmMapEdit.FormKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if Key in [vkEscape, vkHardwareBack] then
  begin
    Key := 0;
    KeyChar := #0;
    btnQuitterClick(btnQuitter);
  end
  else if Key = vkLeft then
  begin
    Key := 0;
    KeyChar := #0;
    btnDeplacementVersLaGaucheClick(btnDeplacementVersLaGauche);
  end
  else if Key = vkright then
  begin
    Key := 0;
    KeyChar := #0;
    btnDeplacementVersLaDroiteClick(btnDeplacementVersLaDroite);
  end
  else if Key = vkup then
  begin
    Key := 0;
    KeyChar := #0;
    btnDeplacementVersLeHautClick(btnDeplacementVersLeHaut);
  end
  else if Key = vkdown then
  begin
    Key := 0;
    KeyChar := #0;
    btnDeplacementVersLeBasClick(btnDeplacementVersLeBas);
  end
  else if (Key = vkControl) and (CharInSet(KeyChar, ['s', 'S'])) then
  begin // TODO : ne fonctionne pas
    Key := 0;
    KeyChar := #0;
    btnSaveClick(btnSave);
  end
  else if (Key = vkControl) and (CharInSet(KeyChar, ['r', 'R'])) then
  begin // TODO : ne fonctionne pas
    Key := 0;
    KeyChar := #0;
    btnRemplissageClick(btnRemplissage);
  end;
end;

procedure TfrmMapEdit.imgSceneMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Single);
begin
  // Désactive le contrôle qui a le focus pour pouvoir intercepter les racourcis
  // clavier (notamment flèches pour déplacer la map)
  if Focused <> nil then
    Focused := nil;
  // clic gauche + sprite sélectionné => ajout du sprite
  if (ssleft in Shift) and (FSelectedSpriteID >= 0) then
    AppliqueSpriteSelectionneSurCellule(X, Y)
  else
    // clic droit + sprite sélectionné => retrait du sprite
    if (ssright in Shift) and (FSelectedSpriteID >= 0) then
      AnnuleSpriteSelectionneSurCellule(X, Y);
end;

procedure TfrmMapEdit.imgSceneMouseMove(Sender: TObject; Shift: TShiftState;
X, Y: Single);
begin
{$IFDEF DEBUG}
  lblSpriteSource.Text := X.ToString + ',' + Y.ToString;
  if ssleft in Shift then
    lblSpriteSource.Text := lblSpriteSource.Text + ' ssLeft';
  // TODO : tester si ssLeft actif sur iPad/Android avec évenement tactile ou si ssTouch est actif
  if ssTouch in Shift then
    lblSpriteSource.Text := lblSpriteSource.Text + ' ssTouch';
  // TODO : tester si ssLeft actif sur iPad/Android avec évenement liés à un crayon ou si ssPen est actif
  if ssPen in Shift then
    lblSpriteSource.Text := lblSpriteSource.Text + ' ssPen';
{$ENDIF}

  // TODO : mode déplacement image avec clic gauche de la souris si pas de sprite sélectionné

  // clic gauche + sprite sélectionné => ajout du sprite
  if (ssleft in Shift) and (FSelectedSpriteID >= 0) then
    AppliqueSpriteSelectionneSurCellule(X, Y)
  else
    // clic droit + sprite sélectionné => retrait du sprite
    if (ssright in Shift) and (FSelectedSpriteID >= 0) then
      AnnuleSpriteSelectionneSurCellule(X, Y);
end;

procedure TfrmMapEdit.imgSceneResize(Sender: TObject);
begin
  DMMap.InitialiseScene(imgScene.Width, imgScene.Height,
    imgScene.Bitmap.BitmapScale);
end;

procedure TfrmMapEdit.RecalculeHauteurZoneSpritesDeLaMapContent;
var
  NewHeight: Single;
  ctrl: tcontrol;
begin
  NewHeight := 0;
  if (zoneSpritesDeLaMapContent.Childrencount > 0) then
    for var c in zoneSpritesDeLaMapContent.Children do
      if c is tcontrol then
      begin
        ctrl := c as tcontrol;
        if ctrl.Position.Y + ctrl.Margins.Top + ctrl.Height +
          ctrl.Margins.bottom > NewHeight then
          NewHeight := ctrl.Position.Y + ctrl.Margins.Top + ctrl.Height +
            ctrl.Margins.bottom;
      end;
  zoneSpritesDeLaMapContent.Height := zoneSpritesDeLaMapContent.padding.Top +
    NewHeight + zoneSpritesDeLaMapContent.padding.bottom;
end;

procedure TfrmMapEdit.SetModificationsEffectuees(const Value: Boolean);
begin
  if (FModificationsEffectuees <> Value) then
  begin
    FModificationsEffectuees := Value;
    btnSave.Enabled := FModificationsEffectuees;
  end;
end;

procedure TfrmMapEdit.SetSelectedSprite(const Value: TcadSpriteButton);
begin
  // Déselection du sprite actuel s'il y en a un
  if (FSelectedSpriteButton <> nil) then
  begin
    // Changement visuel de l'affichage du sprite
    FSelectedSpriteButton.UnSelect;
    FSelectedSpriteID := -1;
  end;

  // Sélection du nouveau sprite s'il y en a un
  FSelectedSpriteButton := Value;

  if (FSelectedSpriteButton <> nil) then
  begin
    // Changement visuel de l'affichage du sprite
    FSelectedSpriteButton.Select;
    FSelectedSpriteID := FSelectedSpriteButton.Tag;
    FSelectedSpriteElement := DMMap.SpriteSheetElements[FSelectedSpriteID];

    // Gestion de l'affichage de la zone de propriétés
    zoneProprietes.Visible := true;

    // ID dans spritesheet du niveau de jeu
    lblSpriteIDValue.Text := FSelectedSpriteID.ToString;
    // ID et libellé liés à la spritesheet d'origine de l'image
    lblSpriteSourceValue.Text := GetEnumName(typeinfo(TSpritesheetname),
      ord(FSelectedSpriteElement.SourceSpritesheetID)) + ' (' +
      FSelectedSpriteElement.SourceImageIndex.ToString + ')';
    // Z-Index pour l'affichage
    edtSpriteZIndex.Value := FSelectedSpriteElement.Zindex;
    // Element bloquant ou pas par rapport aux mouvements des joueurs+PNJ
    swSpriteBloquant.IsChecked := FSelectedSpriteElement.Bloquant;
    // Type d'élément, utilisé lors des collisions
    cbSpriteType.ItemIndex := ord(FSelectedSpriteElement.TypeElement);
  end
  else
  begin
    zoneProprietes.Visible := false;
    FSelectedSpriteID := -1;
    FSelectedSpriteElement := nil;
  end;
end;

procedure TfrmMapEdit.SpriteClick(Sender: TObject);
begin
  if (Sender is TcadSpriteButton) then
  begin
    btnRemplissage.isActif := false;
    if (SelectedSpriteButton = (Sender as TcadSpriteButton)) then
      SelectedSpriteButton := nil
    else
      SelectedSpriteButton := (Sender as TcadSpriteButton);
  end;
end;

procedure TfrmMapEdit.swSpriteBloquantSwitch(Sender: TObject);
begin
  if (FSelectedSpriteID >= 0) then
  begin
    DMMap.SpriteSheetElements[FSelectedSpriteID].Bloquant :=
      swSpriteBloquant.IsChecked;
    ModificationsEffectuees := true;
  end;
end;

procedure TfrmMapEdit.timerRefreshSceneTimer(Sender: TObject);
var
  buffer: tbitmap;
begin
  if DMMap.isSceneBufferChanged then
  begin
    buffer := DMMap.SceneBuffer;
    if (buffer <> nil) then
    begin
      if (imgScene.Bitmap.Width <> buffer.Width) or
        (imgScene.Bitmap.Height <> buffer.Height) then
        imgScene.Bitmap.SetSize(buffer.Width, buffer.Height);
      imgScene.Bitmap.CopyFromBitmap(buffer);
    end;
    // TODO : gérer le niveau de zoom
    // TODO : gérer le BitmapScale de l'image
  end;
end;

procedure TfrmMapEdit.zoneSpritesDeLaMapResize(Sender: TObject);
begin
  RecalculeHauteurZoneSpritesDeLaMapContent;
end;

end.
