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
    Text1.Text :=
      'Egg Hunter (c) 2021 Patrick Prémartin / Olf Software / Gamolf';
{$IFDEF LINUX}
  Text1.Height := 800;
{$ELSE}
  Text1.AutoSize := true;
{$ENDIF}
end;

end.
