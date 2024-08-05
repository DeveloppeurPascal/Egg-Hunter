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
/// File last update : 2024-08-05T19:36:12.403+02:00
/// Signature : 03503767d4ee690365a74bd9a07b7b985f88033b
/// ***************************************************************************
/// </summary>

unit fMapLoad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  cBoutonMenu, FMX.ListBox;

type
  TfrmMapLoad = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    btnRetourAuMenu: TcadBoutonMenu;
    lstFichierDeNiveau: TListBox;
    btnEditerLeNiveau: TcadBoutonMenu;
    procedure btnRetourAuMenuClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnEditerLeNiveauClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.fmx}

uses uDMMap, System.IOUtils, fMapEdit;

procedure TfrmMapLoad.btnEditerLeNiveauClick(Sender: TObject);
var
  MapFileName: string;
  f: TfrmMapEdit;
begin
  // vérifier qu'un fichier est sélectionné
  if (lstFichierDeNiveau.ItemIndex < 0) then
  begin
    lstFichierDeNiveau.SetFocus;
    raise exception.Create('No level selected.');
  end;

  // vérifier que le fichier existe
  MapFileName := dmmap.getMapExtendedFileName
    (lstFichierDeNiveau.Items[lstFichierDeNiveau.ItemIndex]);
  if not tfile.Exists(MapFileName) then
  begin
    lstFichierDeNiveau.SetFocus;
    raise exception.Create('This file doesn''t exist.');
  end;

  // initialiser la map
  dmmap.LoadFromFile(MapFileName);

  // afficher l'écran d'édition
  f := TfrmMapEdit.Create(owner);
{$IF Defined(IOS) and Defined(ANDROID)}
  f.Show;
{$ELSE}
  f.ShowModal;
{$ENDIF}
  // fermer cet écran
  close;
end;

procedure TfrmMapLoad.btnRetourAuMenuClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMapLoad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tthread.forcequeue(nil,
    procedure
    begin
      Self.Free;
    end);
end;

procedure TfrmMapLoad.FormCreate(Sender: TObject);
var
  lst: tstringdynarray;
  i: integer;
begin
  lstFichierDeNiveau.Items.Clear;
  lst := tdirectory.GetFiles(dmmap.getMapFilePath,
    '*.' + dmmap.getMapFileExtension);
  for i := 0 to length(lst) - 1 do
    lstFichierDeNiveau.Items.Add(tpath.GetFileNameWithoutExtension(lst[i]));
end;

procedure TfrmMapLoad.FormKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if Key in [vkEscape, vkHardwareBack] then
  begin
    Key := 0;
    btnRetourAuMenuClick(btnRetourAuMenu);
  end;
  // TODO : gérer la touche ENTREE pour activer par défaut le passage en édition
end;

end.
