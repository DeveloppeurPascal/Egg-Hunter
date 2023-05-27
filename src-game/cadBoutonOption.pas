unit cadBoutonOption;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Filter.Effects, FMX.Objects;

type
  TcBoutonOption = class(TFrame)
    btnImage: TRectangle;
    btnImageUpDown: TBevelEffect;
    OnOff: TSepiaEffect;
    procedure FrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FrameMouseLeave(Sender: TObject);
    procedure FrameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    procedure SetisActif(const Value: boolean);
    function GetisActif: boolean;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property isActif: boolean read GetisActif write SetisActif;
  end;

implementation

{$R *.fmx}

procedure TcBoutonOption.FrameMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  btnImageUpDown.Enabled := false;
end;

procedure TcBoutonOption.FrameMouseLeave(Sender: TObject);
begin
  btnImageUpDown.Enabled := true;
end;

procedure TcBoutonOption.FrameMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  btnImageUpDown.Enabled := true;
end;

function TcBoutonOption.GetisActif: boolean;
begin
  result := not OnOff.Enabled;
end;

procedure TcBoutonOption.SetisActif(const Value: boolean);
begin
  OnOff.Enabled := not Value;
end;

end.
