unit cEcranChargerPartieExistante;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  templateDialogBox, FMX.Ani, cBoiteDeDialogue_370x370, FMX.Objects;

type
  TonPartieChoisieEvent = procedure(NomDuFichier: string) of object;

  TcadEcranChargerPartieExistante = class(TtplDialogBox)
  private
    FonPartieChoisieEvent: TonPartieChoisieEvent;
    procedure SetonPartieChoisieEvent(const Value: TonPartieChoisieEvent);
    { Déclarations privées }
  public
    property onPartieChoisieEvent: TonPartieChoisieEvent
      read FonPartieChoisieEvent write SetonPartieChoisieEvent;
    procedure btnLoadFileClick(ASender: TObject);
    constructor Create(AOwner: TComponent); override;
    procedure ChargeListePartiesExistantes;
  end;

var
  cadEcranChargerPartieExistante: TcadEcranChargerPartieExistante;

implementation

{$R *.fmx}

uses System.IOUtils, uPartieEnCours, cBoutonMenu, fEcranDuJeu, uDMMap;

{ TcadEcranChargerPartieExistante }

procedure TcadEcranChargerPartieExistante.btnLoadFileClick(ASender: TObject);
var
  btn: TcadBoutonMenu;
  FileToLoad: string;
begin
  if (ASender is TcadBoutonMenu) then
  begin
    btn := ASender as TcadBoutonMenu;
    FileToLoad := btn.TagString;
    if (not FileToLoad.IsEmpty) and tfile.Exists(FileToLoad) and
      assigned(FonPartieChoisieEvent) then
      FonPartieChoisieEvent(FileToLoad);
  end;
  close;
end;

procedure TcadEcranChargerPartieExistante.ChargeListePartiesExistantes;
var
  Folder: string;
  Extension: string;
  fichiers: tstringdynarray;
  fichier: string;
  i: integer;
  btn: TcadBoutonMenu;
begin
  Folder := TPartieEncours.GetSaveDirectoryPath;
  Extension := TPartieEncours.GetSaveFileExtension;
  fichiers := tdirectory.GetFiles(Folder);
  for i := 0 to length(fichiers) - 1 do
  begin
    fichier := fichiers[i];
    if fichier.EndsWith(Extension) then
    begin
      btn := TcadBoutonMenu.Create(self);
      btn.Parent := dialog.Contenu;
      btn.Align := talignlayout.top;
      btn.Margins.top := 5;
      btn.Margins.bottom := 5;
      btn.Margins.right := 5;
      btn.Margins.left := 5;
      btn.OnClick := btnLoadFileClick;
      btn.Text.Text := tpath.GetFileNameWithoutExtension(fichier);
      btn.TagString := fichier;
    end;
  end;
end;

constructor TcadEcranChargerPartieExistante.Create(AOwner: TComponent);
begin
  inherited;
  tthread.ForceQueue(nil,
    procedure
    begin
      ChargeListePartiesExistantes;
    end);
end;

procedure TcadEcranChargerPartieExistante.SetonPartieChoisieEvent
  (const Value: TonPartieChoisieEvent);
begin
  FonPartieChoisieEvent := Value;
end;

end.
