unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, cBoutonMenu,
  FMX.Objects, cBoiteDeDialogue_370x370, templateDialogBox, uDMMap;

type
  TfrmMain = class(TForm)
    Menu: TcadBoiteDeDialogue_370x370;
    btnCreditsDuJeu: TcadBoutonMenu;
    btnFermer: TcadBoutonMenu;
    btnLancerUnePartie: TcadBoutonMenu;
    btnReglages: TcadBoutonMenu;
    btnReprendreUnePartie: TcadBoutonMenu;
    imgBackground: TImage;
    Text1: TText;
    TimerLancePartieReprise: TTimer;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnFermerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLancerUnePartieClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgBackgroundResize(Sender: TObject);
    procedure btnCreditsDuJeuClick(Sender: TObject);
    procedure btnReprendreUnePartieClick(Sender: TObject);
    procedure btnReglagesClick(Sender: TObject);
    procedure TimerLancePartieRepriseTimer(Sender: TObject);
  private
    { D�clarations priv�es }
    FBoiteDeDialogue: TtplDialogBox;
    DemoMap: TDMMap;
    FNomDeFichierDePartieACharger: string;
    procedure RefreshBackground;
    procedure SetBoiteDeDialogue(const Value: TtplDialogBox);
    procedure ChargePartieExistante(NomDuFichier: string);
    procedure SetNomDeFichierDePartieACharger(const Value: string);
    property     NomDeFichierDePartieACharger: string read FNomDeFichierDePartieACharger write SetNomDeFichierDePartieACharger;
  public
    { D�clarations publiques }
    property BoiteDeDialogue: TtplDialogBox read FBoiteDeDialogue
      write SetBoiteDeDialogue;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses fEcranDuJeu, cEcranCreditsDuJeu, cEcranChargerPartieExistante, uMusic,
  cEcranOptionsDuJeu, uConfig;

procedure TfrmMain.btnCreditsDuJeuClick(Sender: TObject);
var
  f: TcadEcranCreditsDuJeu;
begin
  f := TcadEcranCreditsDuJeu.Create(self);
  f.parent := self;
  FBoiteDeDialogue := f;
  f.CloseCallBackProc := procedure
    begin
      FBoiteDeDialogue := nil;
    end;
end;

procedure TfrmMain.btnFermerClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.btnLancerUnePartieClick(Sender: TObject);
var
  f: TfrmEcranDuJeu;
begin
  f := TfrmEcranDuJeu.Create(self);

  // Chargement de la partie en attente de lancement
  if not FNomDeFichierDePartieACharger.isempty then
  begin
    f.PartieEnCours.LoadFromFile(FNomDeFichierDePartieACharger);
    dmmap.RefreshSceneBuffer;
    NomDeFichierDePartieACharger := '';
  end;

  // Affichage de l'�cran du jeu
{$IF Defined(IOS) or Defined(ANDROID)}
  f.Show;
{$ELSE}
  f.ShowModal;
{$ENDIF}
end;

procedure TfrmMain.btnReglagesClick(Sender: TObject);
var
  f: TcadEcranOptionsDuJeu;
begin
  f := TcadEcranOptionsDuJeu.Create(self);
  f.parent := self;
  FBoiteDeDialogue := f;
  f.CloseCallBackProc := procedure
    begin
      FBoiteDeDialogue := nil;
    end;
end;

procedure TfrmMain.btnReprendreUnePartieClick(Sender: TObject);
var
  f: TcadEcranChargerPartieExistante;
begin
  f := TcadEcranChargerPartieExistante.Create(self);
  f.parent := self;
  FBoiteDeDialogue := f;
  f.CloseCallBackProc := procedure
    begin
      FBoiteDeDialogue := nil;
    end;
  f.onPartieChoisieEvent := ChargePartieExistante;
end;

procedure TfrmMain.ChargePartieExistante(NomDuFichier: string);
begin
  NomDeFichierDePartieACharger := NomDuFichier;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  NomDeFichierDePartieACharger := '';
  FBoiteDeDialogue := nil;
{$IF Defined(IOS) or Defined(ANDROID)}
  btnFermer.Visible := false;
  Menu.Contenu.Height := Menu.Contenu.Height - btnFermer.margins.top -
    btnFermer.Height - btnFermer.margins.bottom;
{$ENDIF}
  DemoMap := TDMMap.Create(self);
  // TODO : n'afficher "reprendre la partie" que s'il y a des fichiers de parties stock�s

  TMusiques.Ambiance.Volume := TConfig.MusiqueDAmbianceVolume;
  if TConfig.MusiqueDAmbianceOnOff then
    TMusiques.Ambiance.Play;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if assigned(FBoiteDeDialogue) then
  begin
    if Key in [vkEscape, vkHardwareBack] then
    begin
      Key := 0;
      KeyChar := #0;
      FBoiteDeDialogue.close;
      FBoiteDeDialogue := nil;
    end;
  end
  else // pas de boite de dialogue, donc boutons du menu
  begin
    if Key in [vkEscape, vkHardwareBack] then
    begin
      Key := 0;
      KeyChar := #0;
      btnFermerClick(btnFermer);
    end
    else if Key in [vkReturn] then
    begin
      Key := 0;
      KeyChar := #0;
      if assigned(btnReprendreUnePartie.onclick) then
        btnReprendreUnePartie.onclick(btnReprendreUnePartie)
      else if assigned(btnLancerUnePartie.onclick) then
        btnLancerUnePartie.onclick(btnLancerUnePartie);
    end;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  NiveauACharger: string;
begin
{$IF Defined(DEBUG) and Defined(MSWINDOWS)}
  NiveauACharger := 'Intro';
{$ELSE}
  NiveauACharger := 'Intro';
{$ENDIF}
  if not DemoMap.LoadFromFile(DemoMap.getMapExtendedFileName(NiveauACharger))
  then
  begin
    showmessage('Map file not found');
    close;
  end;
  DemoMap.DisplayType := TMapDisplayType.sphere;
  DemoMap.InitialiseScene(imgBackground.Width, imgBackground.Height,
    imgBackground.Bitmap.BitmapScale);
  RefreshBackground;
end;

procedure TfrmMain.imgBackgroundResize(Sender: TObject);
begin
  if assigned(DemoMap) and assigned(imgBackground.Bitmap) then
  begin
    if (imgBackground.Bitmap.BitmapScale = 1) then
      imgBackground.WrapMode := timagewrapmode.Original
    else
      imgBackground.WrapMode := timagewrapmode.stretch;
    DemoMap.InitialiseScene(imgBackground.Width, imgBackground.Height,
      imgBackground.Bitmap.BitmapScale);
    RefreshBackground;
  end;
end;

procedure TfrmMain.RefreshBackground;
var
  buffer: tbitmap;
begin
  buffer := DemoMap.SceneBuffer;
  if (buffer <> nil) then
  begin
    // Text1.Text := imgBackground.Bitmap.Width.ToString + ',' +
    // imgBackground.Bitmap.Height.ToString + ',' +
    // imgBackground.Bitmap.BitmapScale.ToString + ' ' + buffer.Width.ToString +
    // ',' + buffer.Height.ToString + ',' + buffer.BitmapScale.ToString;
    if (imgBackground.Bitmap.Width <> buffer.Width) or
      (imgBackground.Bitmap.Height <> buffer.Height) then
      imgBackground.Bitmap.SetSize(buffer.Width, buffer.Height);
    imgBackground.Bitmap.CopyFromBitmap(buffer);
  end;
end;

procedure TfrmMain.SetBoiteDeDialogue(const Value: TtplDialogBox);
begin
  FBoiteDeDialogue := Value;
end;

procedure TfrmMain.SetNomDeFichierDePartieACharger(const Value: string);
begin
  FNomDeFichierDePartieACharger := Value;
  TimerLancePartieReprise.Enabled:=not value.IsEmpty;
end;

procedure TfrmMain.TimerLancePartieRepriseTimer(Sender: TObject);
begin
  if not FNomDeFichierDePartieACharger.isempty then begin
    btnLancerUnePartieClick(btnLancerUnePartie);
    TimerLancePartieReprise.Enabled:=false;
  end;
end;

initialization
{$IF Defined(MACOS)}
// globalusemetal:=true;
// METAL is slower than without METAL
// https://quality.embarcadero.com/browse/RSP-41315
{$ENDIF}
end.
