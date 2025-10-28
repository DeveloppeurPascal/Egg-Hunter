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
  File last update : 2025-02-09T12:07:49.666+01:00
  Signature : 8fc70000332318356812040b88b5705a5a3b4a05
  ***************************************************************************
*)

unit templateDialogBox;

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
  FMX.Objects,
  cBoiteDeDialogue_370x370,
  cBoutonMenu,
  FMX.Ani;

type
  TtplDialogBox = class(TFrame)
    Background: TRectangle;
    Dialog: TcadBoiteDeDialogue_370x370;
    animAffichage: TFloatAnimation;
    animMasquage: TFloatAnimation;
    procedure btnFermerClick(Sender: TObject);
    procedure animMasquageFinish(Sender: TObject);
    procedure animAffichageFinish(Sender: TObject);
  private
  protected
    FAfficheBoutonFermer: boolean;
  public
    /// <summary>
    /// Appelé lors du destroy (utile pour virer des références à cette classe)
    /// </summary>
    CloseCallBackProc: TProc;

    /// <summary>
    /// Appelé lors du clic sur btnFermer ou depuis ESC/HardwareBack de l'écran de jeu
    /// </summary>
    procedure Close;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ClicSurBoutonParDefautOuRETURN; virtual;
    procedure ClicSurBoutonCancelOuESCAPE; virtual;
  end;

implementation

{$R *.fmx}

uses
  fMain,
  uBruitages;

{ TtplDialogBox }

procedure TtplDialogBox.animAffichageFinish(Sender: TObject);
begin
  animAffichage.Enabled := false;
end;

procedure TtplDialogBox.animMasquageFinish(Sender: TObject);
begin
  animMasquage.Enabled := false;

  tthread.forcequeue(nil,
    procedure
    begin
      self.Free;
    end);
end;

procedure TtplDialogBox.btnFermerClick(Sender: TObject);
begin
  Close;
end;

procedure TtplDialogBox.ClicSurBoutonCancelOuESCAPE;
begin
  Close;
end;

procedure TtplDialogBox.ClicSurBoutonParDefautOuRETURN;
begin
  Close;
end;

procedure TtplDialogBox.Close;
begin
  JouerBruitage(TTypeBruitage.DialogBoxClose);

  if (owner is TfrmMain) then
    (owner as TfrmMain).BoiteDeDialogue := nil;

  animMasquage.Start;
end;

constructor TtplDialogBox.Create(AOwner: TComponent);
begin
  inherited;
  FAfficheBoutonFermer := true;
  animAffichage.Start;
  tthread.forcequeue(nil,
    procedure
    var
      btnFermer: TcadBoutonMenu;
    begin
      Dialog.Contenu.Align := talignlayout.Client;
      if FAfficheBoutonFermer then
      begin
        btnFermer := TcadBoutonMenu.Create(self);
        btnFermer.Parent := Dialog;
        btnFermer.Align := talignlayout.bottom;
        btnFermer.Margins.Top := 5;
        btnFermer.Margins.bottom := 5;
        btnFermer.Margins.right := 5;
        btnFermer.Margins.left := 5;
        btnFermer.OnClick := btnFermerClick;
        btnFermer.Text.Text := 'Fermer'; // TODO : traduire texte
      end;
      // TODO : éventuellement retailler la hauteur de la boite de dialogue selon son contenu
    end);
  JouerBruitage(TTypeBruitage.DialogBoxOpen);
end;

destructor TtplDialogBox.Destroy;
begin
  if assigned(CloseCallBackProc) then
    CloseCallBackProc;
  inherited;
end;

end.
