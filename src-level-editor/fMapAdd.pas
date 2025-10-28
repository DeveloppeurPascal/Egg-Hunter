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
  Signature : 55d37b5492f9d15615817f3d9674a2fe3a19ccf9
  ***************************************************************************
*)

unit fMapAdd;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, cBoutonMenu, FMX.EditBox, FMX.SpinBox, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmMapAdd = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    btnRetourAuMenu: TcadBoutonMenu;
    lblLevelFileName: TLabel;
    lblLevelHeight: TLabel;
    lblLevelWidth: TLabel;
    edtLevelFileName: TEdit;
    edtLevelHeight: TSpinBox;
    edtLevelWidth: TSpinBox;
    btnEditerLeNiveau: TcadBoutonMenu;
    procedure btnRetourAuMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnEditerLeNiveauClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.fmx}

uses uDMMap, System.IOUtils, fMapEdit;

procedure TfrmMapAdd.btnEditerLeNiveauClick(Sender: TObject);
var
  MapFileName: string;
  f: TfrmMapEdit;
begin
  // vérifier les valeurs saisies
  MapFileName := edtLevelFileName.Text.Trim;
  if MapFileName.IsEmpty then
  begin
    edtLevelFileName.SetFocus;
    raise exception.Create('Please fill the file name');
  end;
  MapFileName := dmmap.getMapExtendedFileName(MapFileName);
  if tfile.Exists(MapFileName) then
  begin
    edtLevelFileName.SetFocus;
    raise exception.Create('This file already exists.');
  end;

  // initialiser la map
  dmmap.VideLaMap;
  dmmap.LevelMapColCount := trunc(edtLevelWidth.Value);
  dmmap.LevelMapRowCount := trunc(edtLevelHeight.Value);
  dmmap.MapFileName := MapFileName;

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

procedure TfrmMapAdd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tthread.forcequeue(nil,
    procedure
    begin
      Self.Free;
    end);
end;

procedure TfrmMapAdd.FormCreate(Sender: TObject);
begin
  edtLevelFileName.Text := '';
  edtLevelFileName.SetFocus;
  edtLevelWidth.Min := 5;
  edtLevelWidth.Max := CEggHunterMapColCount;
  edtLevelWidth.Value := CEggHunterMapColCount;
  edtLevelHeight.Min := 5;
  edtLevelHeight.Max := CEggHunterMapRowCount;
  edtLevelHeight.Value := CEggHunterMapRowCount;
end;

procedure TfrmMapAdd.FormKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if Key in [vkEscape, vkHardwareBack] then
  begin
    Key := 0;
    btnRetourAuMenuClick(btnRetourAuMenu);
  end;
  // TODO : gérer la touche ENTREE pour activer par défaut le passage en édition
end;

procedure TfrmMapAdd.btnRetourAuMenuClick(Sender: TObject);
begin
  close;
end;

end.
