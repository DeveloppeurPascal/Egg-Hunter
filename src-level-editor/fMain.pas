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
