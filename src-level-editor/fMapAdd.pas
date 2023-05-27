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
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

implementation

{$R *.fmx}

uses uDMMap, System.IOUtils, fMapEdit;

procedure TfrmMapAdd.btnEditerLeNiveauClick(Sender: TObject);
var
  MapFileName: string;
  f: TfrmMapEdit;
begin
  // v�rifier les valeurs saisies
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

  // afficher l'�cran d'�dition
  f := TfrmMapEdit.Create(owner);
{$IF Defined(IOS) and Defined(ANDROID)}
  f.Show;
{$ELSE}
  f.ShowModal;
{$ENDIF}
  // fermer cet �cran
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
  // TODO : g�rer la touche ENTREE pour activer par d�faut le passage en �dition
end;

procedure TfrmMapAdd.btnRetourAuMenuClick(Sender: TObject);
begin
  close;
end;

end.
