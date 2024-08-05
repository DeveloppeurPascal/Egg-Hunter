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
/// File last update : 2024-08-05T19:36:12.387+02:00
/// Signature : b38b6a87a0b0e00cc93db0aa35701c3688b8b35e
/// ***************************************************************************
/// </summary>

unit cEcranCreditsDuJeu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  templateDialogBox, FMX.Objects, cBoiteDeDialogue_370x370, FMX.Ani;

type
  TcadEcranCreditsDuJeu = class(TtplDialogBox)
    Text1: TText;
  private
    { Déclarations privées }
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  cadEcranCreditsDuJeu: TcadEcranCreditsDuJeu;

implementation

{$R *.fmx}

uses
  System.IOUtils;

{ TcadEcranCreditsDuJeu }

constructor TcadEcranCreditsDuJeu.Create(AOwner: TComponent);
var
  FichierDesCredits: string;
begin
  inherited;
{$IF Defined(DEBUG) and Defined(MSWINDOWS)}
  FichierDesCredits := tpath.Combine(tpath.Combine(ExtractFilePath(paramstr(0)),
    '..\..\..'), 'CREDITS.md');
{$ELSEIF Defined(ANDROID)}
  FichierDesCredits := tpath.Combine(tpath.getDocumentsPath, 'CREDITS.md');
  // TODO : à changer plus tard (mettre le texte des crédits du jeu en ressource dans l'exe)
{$ELSE}
  FichierDesCredits := tpath.Combine(ExtractFilePath(paramstr(0)),
    'CREDITS.md');
{$ENDIF}
  Text1.AutoSize := false;
  Text1.VertTextAlign := TTextAlign.Leading;
  if tfile.Exists(FichierDesCredits) then
    Text1.Text := tfile.ReadAllText(FichierDesCredits, tencoding.UTF8)
  else
    Text1.Text := 'Egg Hunter (c) 2021-2023 Patrick Prémartin';
{$IFDEF LINUX}
  Text1.Height := 800;
{$ELSE}
  Text1.AutoSize := true;
{$ENDIF}
end;

end.
