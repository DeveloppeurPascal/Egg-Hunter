unit fMapSpriteAdd;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, uDMSpriteSheets, cBoutonMenu, fMapEdit;

type
  TfrmMapSpriteAdd = class(TForm)
    cbListeSpriteSheetsDisponibles: TComboBox;
    VertScrollBox1: TVertScrollBox;
    zoneSpritesDisponibles: TFlowLayout;
    GridPanelLayout1: TGridPanelLayout;
    btnAjoutSpritesSelectionnes: TcadBoutonMenu;
    btnFermer: TcadBoutonMenu;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnFermerClick(Sender: TObject);
    procedure btnAjoutSpritesSelectionnesClick(Sender: TObject);
    procedure cbListeSpriteSheetsDisponiblesChange(Sender: TObject);
    procedure VertScrollBox1Resize(Sender: TObject);
  private
    { D�clarations priv�es }
    FfrmMapEdit: TfrmMapEdit;
    FSpriteSheetDisplayed: TSpriteSheetName;
    procedure SpriteClick(Sender: TObject);
    procedure RecalculeLaZoneDesSpritesDisponibles;
  public
    constructor Create(AOwner: TComponent; AfrmMapEdit: TfrmMapEdit);
  end;

var
  frmMapSpriteAdd: TfrmMapSpriteAdd;

implementation

{$R *.fmx}

uses uDMMap, cSpriteButton, System.TypInfo;

procedure TfrmMapSpriteAdd.btnAjoutSpritesSelectionnesClick(Sender: TObject);
var
  btn: TcadSpriteButton;
  item: TSpriteSheetElement;
  SpriteSheetRef: tbitmap;
begin
  SpriteSheetRef := nil;
  // Parcourrir la liste des boutons / sprites de l'�cran
  if (zoneSpritesDisponibles.ChildrenCount > 0) then
    for var c in zoneSpritesDisponibles.Children do
      if (c is TcadSpriteButton) then
      begin
        btn := (c as TcadSpriteButton);
        // On ne s'int�resse qu'aux boutons "actifs"
        if btn.Selected then
        begin
          // On v�rifie si on l'a d�j� dans la map
          if not dmmap.SpriteExists(ord(FSpriteSheetDisplayed), btn.tag) then
          begin
            // R�cup�re l'image de la spritesheet sur laquelle on travaille (pour �viter de le faire � chaque ajout)
            if (SpriteSheetRef = nil) then
              SpriteSheetRef := DMSpriteSheets.getSpriteSheetRef
                (FSpriteSheetDisplayed);
            // Renseignement des propri�t�s du sprite � ajouter
            item := TSpriteSheetElement.Create;
            item.SourceSpritesheetID := ord(FSpriteSheetDisplayed);
            item.SourceImageIndex := btn.tag;
            item.Zindex := 0;
            item.Bloquant := false;
            item.TypeElement := TEggHunterElementType.decor;
            // On l'ajoute � la map
            dmmap.AddSpriteSheetElement(DMSpriteSheets.getImageFromSpriteSheet
              (FSpriteSheetDisplayed, SpriteSheetRef, btn.tag), item);
            // On l'ajoute � la palette de l'�cran d'�dition
            FfrmMapEdit.AjouteBoutonSprite(dmmap.SpriteSheetElements.Count - 1);
            // TODO : modifier calcul index en prenant la r�ponse lors de l'ajout � la liste des sprites de la map
          end;
          // D�selectionner le bouton sprite ajout�
          btn.UnSelect;
        end;
      end;
end;

procedure TfrmMapSpriteAdd.btnFermerClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMapSpriteAdd.cbListeSpriteSheetsDisponiblesChange
  (Sender: TObject);
var
  nb: integer;
  i: integer;
  btn: TcadSpriteButton;
  SpriteSheetRef: tbitmap;
begin
  // On vide la liste des sprites disponibles
  while zoneSpritesDisponibles.ChildrenCount > 0 do
    zoneSpritesDisponibles.RemoveObject(0);
  // Si nom de spritesheet s�lectionn� dans le combo, on charge les images
  if (cbListeSpriteSheetsDisponibles.Selected <> nil) then
  begin
    // R�cup�re l'ID de la spritesheet � traiter depuis son �num�ration
    FSpriteSheetDisplayed := TSpriteSheetName
      (cbListeSpriteSheetsDisponibles.Selected.tag);
    // On r�cup�re l'image de la spritesheet (pour ne pas le faire sur chaque �l�ment)
    SpriteSheetRef := DMSpriteSheets.getSpriteSheetRef(FSpriteSheetDisplayed);
    if (SpriteSheetRef <> nil) then
    begin
      nb := DMSpriteSheets.getNbSprite(FSpriteSheetDisplayed, SpriteSheetRef);
      // ajout des boutons li�s � chaque image de la spritesheet
      for i := 0 to nb - 1 do
      begin
        btn := TcadSpriteButton.Create(self);
        btn.Name := '';
        btn.Parent := zoneSpritesDisponibles;
        btn.SetSprite(FSpriteSheetDisplayed, SpriteSheetRef, i);
        btn.OnClick := SpriteClick;
        btn.Margins.Top := 5;
        btn.Margins.right := 5;
        btn.Margins.bottom := 5;
        btn.Margins.left := 5;
      end;
    end;
  end;
  RecalculeLaZoneDesSpritesDisponibles;
end;

constructor TfrmMapSpriteAdd.Create(AOwner: TComponent;
  AfrmMapEdit: TfrmMapEdit);
begin
  inherited Create(AOwner);
  FfrmMapEdit := AfrmMapEdit;
end;

procedure TfrmMapSpriteAdd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tthread.forcequeue(nil,
    procedure
    begin
      self.free;
    end);
end;

procedure TfrmMapSpriteAdd.FormCreate(Sender: TObject);
var
  idx: integer;
begin
  cbListeSpriteSheetsDisponibles.Items.Clear;
  for var ssn := low(TSpriteSheetName) to high(TSpriteSheetName) do
  begin
    idx := cbListeSpriteSheetsDisponibles.Items.Add
      (GetEnumName(typeinfo(TSpriteSheetName), ord(ssn)));
    cbListeSpriteSheetsDisponibles.ListItems[idx].tag := ord(ssn);
  end;
end;

procedure TfrmMapSpriteAdd.FormKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if Key in [vkEscape, vkHardwareBack] then
  begin
    Key := 0;
    btnFermerClick(btnFermer);
  end;
end;

procedure TfrmMapSpriteAdd.RecalculeLaZoneDesSpritesDisponibles;
var
  NewHeight: single;
  ctrl: tcontrol;
begin
  NewHeight := 0;
  if (zoneSpritesDisponibles.ChildrenCount > 0) then
    for var c in zoneSpritesDisponibles.Children do
      if (c is tcontrol) then
      begin
        ctrl := c as tcontrol;
        if ctrl.Position.Y + ctrl.Margins.Top + ctrl.Height +
          ctrl.Margins.bottom > NewHeight then
          NewHeight := ctrl.Position.Y + ctrl.Margins.Top + ctrl.Height +
            ctrl.Margins.bottom;
      end;
  zoneSpritesDisponibles.Height := zoneSpritesDisponibles.padding.Top +
    NewHeight + zoneSpritesDisponibles.padding.bottom;
end;

procedure TfrmMapSpriteAdd.SpriteClick(Sender: TObject);
begin
  if (Sender is TcadSpriteButton) then
    (Sender as TcadSpriteButton).Selected :=
      not(Sender as TcadSpriteButton).Selected;
end;

procedure TfrmMapSpriteAdd.VertScrollBox1Resize(Sender: TObject);
begin
  RecalculeLaZoneDesSpritesDisponibles;
end;

end.
