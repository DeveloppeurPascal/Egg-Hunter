unit cJoypad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Effects;

type
  TcadJoypad = class(TFrame)
    btnVersLaGauche: TRectangle;
    btnVersLaDroite: TRectangle;
    btnVersLeHaut: TRectangle;
    btnVersLeBas: TRectangle;
    btnVersLaDroiteBevelEffect: TBevelEffect;
    btnVersLaGaucheBevelEffect: TBevelEffect;
    btnVersLeBasBevelEffect: TBevelEffect;
    btnVersLeHautBevelEffect: TBevelEffect;
    procedure btnVersLeHautMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnVersLeHautMouseLeave(Sender: TObject);
    procedure btnVersLeHautMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnVersLaDroiteMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnVersLaDroiteMouseLeave(Sender: TObject);
    procedure btnVersLaDroiteMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnVersLaGaucheMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnVersLaGaucheMouseLeave(Sender: TObject);
    procedure btnVersLaGaucheMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnVersLeBasMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnVersLeBasMouseLeave(Sender: TObject);
    procedure btnVersLeBasMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.fmx}

procedure TcadJoypad.btnVersLaDroiteMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  btnVersLaDroiteBevelEffect.Enabled := false;
end;

procedure TcadJoypad.btnVersLaDroiteMouseLeave(Sender: TObject);
begin
  btnVersLaDroiteBevelEffect.Enabled := true;
end;

procedure TcadJoypad.btnVersLaDroiteMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  btnVersLaDroiteBevelEffect.Enabled := true;
end;

procedure TcadJoypad.btnVersLaGaucheMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  btnVersLaGaucheBevelEffect.Enabled := false;
end;

procedure TcadJoypad.btnVersLaGaucheMouseLeave(Sender: TObject);
begin
  btnVersLaGaucheBevelEffect.Enabled := true;
end;

procedure TcadJoypad.btnVersLaGaucheMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  btnVersLaGaucheBevelEffect.Enabled := true;
end;

procedure TcadJoypad.btnVersLeBasMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  btnVersLeBasBevelEffect.Enabled := false;
end;

procedure TcadJoypad.btnVersLeBasMouseLeave(Sender: TObject);
begin
  btnVersLeBasBevelEffect.Enabled := true;
end;

procedure TcadJoypad.btnVersLeBasMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  btnVersLeBasBevelEffect.Enabled := true;
end;

procedure TcadJoypad.btnVersLeHautMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  btnVersLeHautBevelEffect.Enabled := false;
end;

procedure TcadJoypad.btnVersLeHautMouseLeave(Sender: TObject);
begin
  btnVersLeHautBevelEffect.Enabled := true;
end;

procedure TcadJoypad.btnVersLeHautMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  btnVersLeHautBevelEffect.Enabled := true;
end;

end.
