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
/// Signature : 0c50ca299bb625eef2437fffc7c0abf86010f70b
/// ***************************************************************************
/// </summary>

unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, cBoutonMenu,
  cBoiteDeDialogue_370x370;

type
  TfrmMain = class(TForm)
    Menu: TcadBoiteDeDialogue_370x370;
    btnChargerNiveau: TcadBoutonMenu;
    btnNouveauNiveau: TcadBoutonMenu;
    btnQuitterLeProgramme: TcadBoutonMenu;
    procedure btnQuitterLeProgrammeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNouveauNiveauClick(Sender: TObject);
    procedure btnChargerNiveauClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses fMapAdd, fMapLoad;

procedure TfrmMain.btnChargerNiveauClick(Sender: TObject);
var
  f: TfrmMapLoad;
begin
  f := TfrmMapLoad.Create(Self);
{$IF Defined(IOS) and Defined(ANDROID)}
  f.Show;
{$ELSE}
  f.ShowModal;
{$ENDIF}
end;

procedure TfrmMain.btnNouveauNiveauClick(Sender: TObject);
var
  f: TfrmMapAdd;
begin
  f := TfrmMapAdd.Create(Self);
{$IF Defined(IOS) and Defined(ANDROID)}
  f.Show;
{$ELSE}
  f.ShowModal;
{$ENDIF}
end;

procedure TfrmMain.btnQuitterLeProgrammeClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
{$IF Defined(IOS) or Defined(ANDROID)}
  btnQuitterLeProgramme.Visible := false;
  zoneBoutons.Height := zoneBoutons.Height - btnQuitterLeProgramme.margins.top -
    btnQuitterLeProgramme.Height - btnQuitterLeProgramme.margins.bottom;
{$ENDIF}
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key in [vkEscape, vkHardwareBack] then
  begin
    Key := 0;
    keychar := #0;
    btnQuitterLeProgrammeClick(btnQuitterLeProgramme);
  end;
end;

initialization

randomize;
{$IFDEF DEBUG}
ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
