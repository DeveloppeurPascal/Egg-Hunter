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
/// Signature : fd86bc395b958557fd96aa2e3fc9566310dd9a55
/// ***************************************************************************
/// </summary>

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
