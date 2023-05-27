unit cTrackbar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, System.ImageList, FMX.ImgList;

type
{$SCOPEDENUMS ON}
  TcadTrackBarColor = (bleu, vert, rouge, jaune, gris);

  TcadTrackBar = class(TFrame)
    imgTrackBar: TImageList;
    rectBackground: TRectangle;
    rectTrack: TRectangle;
    procedure FrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FrameResize(Sender: TObject);
  private
    FMinValue: cardinal;
    FtbColor: TcadTrackBarColor;
    FValue: cardinal;
    FMaxValue: cardinal;
    procedure SetMaxValue(const Value: cardinal);
    procedure SetMinValue(const Value: cardinal);
    procedure SettbColor(const Value: TcadTrackBarColor);
    procedure SetValue(const Value: cardinal);
    { Déclarations privées }
    procedure RefreshImage;
  public
    { Déclarations publiques }
    property tbColor: TcadTrackBarColor read FtbColor write SettbColor;
    property Value: cardinal read FValue write SetValue;
    property MinValue: cardinal read FMinValue write SetMinValue;
    property MaxValue: cardinal read FMaxValue write SetMaxValue;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

constructor TcadTrackBar.Create(AOwner: TComponent);
begin
  inherited;
  FMinValue := 0;
  FMaxValue := 100;
  FValue := 0;
  tbColor := TcadTrackBarColor.vert;
end;

procedure TcadTrackBar.FrameMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  Value := round((MaxValue - MinValue) * X / width);
end;

procedure TcadTrackBar.FrameResize(Sender: TObject);
begin
  RefreshImage;
end;

procedure TcadTrackBar.RefreshImage;
var
  img: byte;
begin
  rectTrack.width := FValue * rectBackground.width / (FMaxValue - FMinValue);
  case FtbColor of
    TcadTrackBarColor.bleu:
      img := 0;
    TcadTrackBarColor.vert:
      img := 1;
    TcadTrackBarColor.rouge:
      img := 2;
    TcadTrackBarColor.jaune:
      img := 3;
    TcadTrackBarColor.gris:
      img := 4;
  else
    raise Exception.Create('TcadTrackBarColor not implemented');
  end;
  rectTrack.Fill.Bitmap.Bitmap.Assign(imgTrackBar.Bitmap(tsizef.Create(18,
    18), img));
end;

procedure TcadTrackBar.SetMaxValue(const Value: cardinal);
begin
  FMaxValue := Value;
  RefreshImage;
end;

procedure TcadTrackBar.SetMinValue(const Value: cardinal);
begin
  FMinValue := Value;
  RefreshImage;
end;

procedure TcadTrackBar.SettbColor(const Value: TcadTrackBarColor);
begin
  FtbColor := Value;
  RefreshImage;
end;

procedure TcadTrackBar.SetValue(const Value: cardinal);
begin
  FValue := Value;
  RefreshImage;
end;

end.
