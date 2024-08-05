/// <summary>
/// ***************************************************************************
///
/// Egg Hunter
///
/// Copyright 2021-2024 Patrick Prémartin under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// Egg Hunter is an RPG sprinkled with duck breeding.
///
/// You have to harvest their eggs, incubate them until they hatch, and
/// explode production quotas (just for fun).
///
/// This repository contains the game source and its level editor.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://egghunter.gamolf.fr/
///
/// Project site :
/// https://github.com/DeveloppeurPascal/Egg-Hunter
///
/// ***************************************************************************
/// File last update : 2024-08-05T19:36:12.372+02:00
/// Signature : d2bd5ff14332dfdc5270e84ecc0039470034f7f7
/// ***************************************************************************
/// </summary>

unit cEcranChargerPartieExistante;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  templateDialogBox,
  FMX.Ani,
  cBoiteDeDialogue_370x370,
  FMX.Objects;

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

uses
  System.IOUtils,
  uPartieEnCours,
  cBoutonMenu,
  uDMMap;

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
