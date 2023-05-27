unit cSpriteButton;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, uDMSpriteSheets;

type
  TcadSpriteButton = class(TFrame)
    SpriteImage: TRectangle;
  private
    FSelected: boolean;
    procedure SetSelected(const Value: boolean);
    { Déclarations privées }
  public
    /// <summary>
    /// Permet de modifier et interroger l'état de sélection du bouton
    /// </summary>
    property Selected: boolean read FSelected write SetSelected;

    /// <summary>
    /// Défini les infos de ce sprite par rapport à la liste des sprites de la map
    /// </summary>
    procedure SetSprite(AImageIndex: integer); overload;

    /// <summary>
    /// Défini les infos de ce sprite par rapport à une sprite sheet liée à l'éditeur de map
    /// </summary>
    procedure SetSprite(ASpriteSheetName: TSpriteSheetName;
      AImageIndex: integer); overload;

    /// <summary>
    /// Défini les infos de ce sprite par rapport à une sprite sheet liée à l'éditeur de map
    /// </summary>
    procedure SetSprite(ASpriteSheetName: TSpriteSheetName;
      ASpriteSheetBitmap: tbitmap; AImageIndex: integer); overload;

    /// <summary>
    /// Change l'affichage pour marquer la sélection de cet élément
    /// </summary>
    procedure Select;

    /// <summary>
    /// Change l'affichage pour marquer la désélection de cet élément
    /// </summary>
    procedure UnSelect;
  end;

implementation

{$R *.fmx}

uses uDMMap;

{ TcadSpriteButton }

procedure TcadSpriteButton.SetSprite(AImageIndex: integer);
var
  bmp: tbitmap;
begin
  tag := AImageIndex;
  bmp := dmmap.getImageFromSpriteSheetRef(AImageIndex);
  if bmp <> nil then
    SpriteImage.Fill.Bitmap.Bitmap.assign(bmp);
  UnSelect;
end;

procedure TcadSpriteButton.Select;
begin
  SpriteImage.Stroke.Thickness := 5;
  SpriteImage.Stroke.Color := talphacolors.Green;
  FSelected := true;
end;

procedure TcadSpriteButton.SetSelected(const Value: boolean);
begin
  if Value then
    Select
  else
    UnSelect;
end;

procedure TcadSpriteButton.SetSprite(ASpriteSheetName: TSpriteSheetName;
  ASpriteSheetBitmap: tbitmap; AImageIndex: integer);
var
  bmp: tbitmap;
begin
  tag := AImageIndex;
  if (ASpriteSheetBitmap <> nil) then
    bmp := DMSpriteSheets.getImageFromSpriteSheet(ASpriteSheetName,
      ASpriteSheetBitmap, AImageIndex)
  else
    bmp := DMSpriteSheets.getImageFromSpriteSheet(ASpriteSheetName,
      AImageIndex);
  if bmp <> nil then
    try
      // SpriteImage.Fill.Bitmap.Bitmap.setsize(bmp.Width, bmp.Height);
      // SpriteImage.Fill.Bitmap.Bitmap.copyfrombitmap(bmp);
      SpriteImage.Fill.Bitmap.Bitmap.assign(bmp);
    finally
      bmp.Free;
    end;
  UnSelect;
end;

procedure TcadSpriteButton.SetSprite(ASpriteSheetName: TSpriteSheetName;
  AImageIndex: integer);
begin
  SetSprite(ASpriteSheetName, nil, AImageIndex);
end;

procedure TcadSpriteButton.UnSelect;
begin
  SpriteImage.Stroke.Thickness := 1;
  SpriteImage.Stroke.Color := talphacolors.black;
  FSelected := false;
end;

end.
