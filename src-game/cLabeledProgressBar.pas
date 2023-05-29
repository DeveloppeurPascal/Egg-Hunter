unit cLabeledProgressBar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, System.ImageList, FMX.ImgList;

type
{$SCOPEDENUMS ON}
  TcadLabeledProgressBarColor = (bleu, vert, rouge, jaune);

  TcadLabeledProgressBar = class(TFrame)
    Background: TRectangle;
    Text: TText;
    ProgressBarBackground: TLayout;
    ProgressBar: TLayout;
    pbbLeft: TRectangle;
    pbbRight: TRectangle;
    pbbMiddle: TRectangle;
    pbLeft: TRectangle;
    pbMiddle: TRectangle;
    pbRight: TRectangle;
    imgListeCouleurs: TImageList;
    procedure ProgressBarBackgroundResize(Sender: TObject);
  private
    FMinValue: integer;
    FValue: integer;
    FMaxValue: integer;
    FColor: TcadLabeledProgressBarColor;
    FShowValueInText: boolean;
    FValueUnit: string;
    procedure SetMaxValue(const Value: integer);
    procedure SetMinValue(const Value: integer);
    procedure SetValue(const Value: integer);
    procedure SetColor(const Value: TcadLabeledProgressBarColor);
    procedure SetShowValueInText(const Value: boolean);
    procedure SetValueUnit(const Value: string);
  protected
    FTextAffiche: string;
    procedure RefreshMiddle;
  public
    /// <summary>
    /// Valeur minimale de la progress bar (par défaut 0)
    /// </summary>
    property MinValue: integer read FMinValue write SetMinValue;
    /// <summary>
    /// Valeur maximale de la progress bar (par défaut 100)
    /// </summary>
    property MaxValue: integer read FMaxValue write SetMaxValue;
    /// <summary>
    /// Valeur actuelle (par défaut 0)
    /// </summary>
    property Value: integer read FValue write SetValue;
    /// <summary>
    /// Couleur de la barre de progression (par défaut vert)
    /// </summary>
    property Color: TcadLabeledProgressBarColor read FColor write SetColor;
    /// <summary>
    /// Add the current value after default text
    /// </summary>
    property ShowValueInText: boolean read FShowValueInText
      write SetShowValueInText;
    /// <summary>
    /// Add a unit (like '%') after the value if it's shown
    /// </summary>
    property ValueUnit: string read FValueUnit write SetValueUnit;

    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}
{ TcadLabeledProgressBar }

constructor TcadLabeledProgressBar.Create(AOwner: TComponent);
begin
  inherited;
  FMinValue := 0;
  FMaxValue := 100;
  FValue := 0;
  FTextAffiche := '';
  FColor := TcadLabeledProgressBarColor.vert;
  FShowValueInText := true;
  FValueUnit := '';
  RefreshMiddle;
end;

procedure TcadLabeledProgressBar.ProgressBarBackgroundResize(Sender: TObject);
begin
  RefreshMiddle;
end;

procedure TcadLabeledProgressBar.RefreshMiddle;
var
  TotalWidth: single;
  DisplayWidth: single;
  CornerWidth: single;
begin
  TotalWidth := ProgressBar.Width;
  DisplayWidth := TotalWidth * FValue / (FMaxValue - FMinValue);

  pbLeft.Width := pbbLeft.Width * DisplayWidth / TotalWidth;
  pbMiddle.Width := pbbMiddle.Width * DisplayWidth / TotalWidth;
  pbRight.Width := pbbRight.Width * DisplayWidth / TotalWidth;
end;

procedure TcadLabeledProgressBar.SetColor(const Value
  : TcadLabeledProgressBarColor);
var
  idxGauche, idxMilieu, idxDroite: integer;
begin
  if (FColor <> Value) then
  begin
    FColor := Value;
    case FColor of
      TcadLabeledProgressBarColor.bleu:
        begin
          idxGauche := 9;
          idxMilieu := 10;
          idxDroite := 11;
        end;
      TcadLabeledProgressBarColor.rouge:
        begin
          idxGauche := 0;
          idxMilieu := 1;
          idxDroite := 2;
        end;
      TcadLabeledProgressBarColor.jaune:
        begin
          idxGauche := 3;
          idxMilieu := 4;
          idxDroite := 5;
        end;
    else // Vert par défaut
      idxGauche := 6;
      idxMilieu := 7;
      idxDroite := 8;
    end;
    pbLeft.fill.Bitmap.Bitmap.CopyFromBitmap
      (imgListeCouleurs.Bitmap(tsizef.Create(pbLeft.fill.Bitmap.Bitmap.Width,
      pbLeft.fill.Bitmap.Bitmap.height), idxGauche));
    pbMiddle.fill.Bitmap.Bitmap.CopyFromBitmap
      (imgListeCouleurs.Bitmap(tsizef.Create(pbMiddle.fill.Bitmap.Bitmap.Width,
      pbMiddle.fill.Bitmap.Bitmap.height), idxMilieu));
    pbRight.fill.Bitmap.Bitmap.CopyFromBitmap
      (imgListeCouleurs.Bitmap(tsizef.Create(pbRight.fill.Bitmap.Bitmap.Width,
      pbRight.fill.Bitmap.Bitmap.height), idxDroite));
  end;
end;

procedure TcadLabeledProgressBar.SetMaxValue(const Value: integer);
begin
  FMaxValue := Value;
  RefreshMiddle;
end;

procedure TcadLabeledProgressBar.SetMinValue(const Value: integer);
begin
  FMinValue := Value;
  RefreshMiddle;
end;

procedure TcadLabeledProgressBar.SetShowValueInText(const Value: boolean);
begin
  FShowValueInText := Value;
end;

procedure TcadLabeledProgressBar.SetValue(const Value: integer);
begin
  if (FTextAffiche.IsEmpty) then
    FTextAffiche := Text.Text;

  if Value > FMaxValue then
    FValue := FMaxValue
  else
    FValue := Value;
  if FShowValueInText then
    Text.Text := FTextAffiche + ' (' + FValue.ToString + FValueUnit + ')'
  else
    Text.Text := FTextAffiche;
  RefreshMiddle;
end;

procedure TcadLabeledProgressBar.SetValueUnit(const Value: string);
begin
  FValueUnit := Value;
end;

end.
