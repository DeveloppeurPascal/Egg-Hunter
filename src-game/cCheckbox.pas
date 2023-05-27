unit cCheckbox;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ImgList, System.ImageList;

type
{$SCOPEDENUMS ON}
  TcadCheckboxType = (coche, croix);
  TcadCheckboxColor = (bleu, vert, rouge, jaune, gris);

  TcadCheckbox = class(TFrame)
    imgCheckbox: TImageList;
    CheckBox: TGlyph;
    procedure FrameClick(Sender: TObject);
  private
    FcbType: TcadCheckboxType;
    FisChecked: boolean;
    FcbColor: TcadCheckboxColor;
    procedure SetcbColor(const Value: TcadCheckboxColor);
    procedure SetcbType(const Value: TcadCheckboxType);
    procedure SetisChecked(const Value: boolean);
    { Déclarations privées }
    procedure RefreshImage;
  public
    { Déclarations publiques }
    property cbType: TcadCheckboxType read FcbType write SetcbType;
    property isChecked: boolean read FisChecked write SetisChecked;
    property cbColor: TcadCheckboxColor read FcbColor write SetcbColor;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses uBruitages;

constructor TcadCheckbox.Create(AOwner: TComponent);
begin
  inherited;
  isChecked := false;
  cbType := TcadCheckboxType.coche;
  cbColor := TcadCheckboxColor.vert;
end;

procedure TcadCheckbox.FrameClick(Sender: TObject);
begin
  isChecked := not isChecked;
end;

procedure TcadCheckbox.RefreshImage;
var
  img: integer;
begin
  if not FisChecked then
    CheckBox.ImageIndex := 0
  else
  begin
    img := 0;
    case FcbType of
      TcadCheckboxType.coche:
        img := 1; // bleu
      TcadCheckboxType.croix:
        img := 6; // bleu
    else
      raise Exception.Create('TcadCheckboxType not implemented');
    end;
    case FcbColor of
      TcadCheckboxColor.bleu:
        ;
      TcadCheckboxColor.vert:
        img := img + 1;
      TcadCheckboxColor.rouge:
        img := img + 2;
      TcadCheckboxColor.jaune:
        img := img + 3;
      TcadCheckboxColor.gris:
        img := img + 4;
    else
      raise Exception.Create('TcadCheckboxColor not implemented');
    end;
    CheckBox.ImageIndex := img;
  end;
end;

procedure TcadCheckbox.SetcbColor(const Value: TcadCheckboxColor);
begin
  FcbColor := Value;
  RefreshImage;
end;

procedure TcadCheckbox.SetcbType(const Value: TcadCheckboxType);
begin
  FcbType := Value;
  RefreshImage;
end;

procedure TcadCheckbox.SetisChecked(const Value: boolean);
begin
  if (FisChecked <> Value) then
  begin
    FisChecked := Value;
    JouerBruitage(TTypeBruitage.Beep);
  end;
  RefreshImage;
end;

end.
