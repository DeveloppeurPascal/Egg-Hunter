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
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

implementation

{$R *.fmx}

uses uDMMap, System.IOUtils, fMapEdit;

procedure TfrmMapLoad.btnEditerLeNiveauClick(Sender: TObject);
var
  MapFileName: string;
  f: TfrmMapEdit;
begin
  // v�rifier qu'un fichier est s�lectionn�
  if (lstFichierDeNiveau.ItemIndex < 0) then
  begin
    lstFichierDeNiveau.SetFocus;
    raise exception.Create('No level selected.');
  end;

  // v�rifier que le fichier existe
  MapFileName := dmmap.getMapExtendedFileName
    (lstFichierDeNiveau.Items[lstFichierDeNiveau.ItemIndex]);
  if not tfile.Exists(MapFileName) then
  begin
    lstFichierDeNiveau.SetFocus;
    raise exception.Create('This file doesn''t exist.');
  end;

  // initialiser la map
  dmmap.LoadFromFile(MapFileName);

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
  // TODO : g�rer la touche ENTREE pour activer par d�faut le passage en �dition
end;

end.
