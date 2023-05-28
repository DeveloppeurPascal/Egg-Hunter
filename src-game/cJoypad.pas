unit cJoypad;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Effects;

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
    FDPad: word;
    procedure SetDPad(const Value: word);
    procedure VersLeHaut;
    procedure VersLeBas;
    procedure VersLaGauche;
    procedure VersLaDroite;
    procedure Immobile;
  public
    property DPad: word read FDPad write SetDPad;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses
  Gamolf.RTL.Joystick;

procedure TcadJoypad.btnVersLaDroiteMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  btnVersLaDroiteBevelEffect.Enabled := false;
  VersLaDroite;
end;

procedure TcadJoypad.btnVersLaDroiteMouseLeave(Sender: TObject);
begin
  btnVersLaDroiteBevelEffect.Enabled := true;
  Immobile;
end;

procedure TcadJoypad.btnVersLaDroiteMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  btnVersLaDroiteBevelEffect.Enabled := true;
  Immobile;
end;

procedure TcadJoypad.btnVersLaGaucheMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  btnVersLaGaucheBevelEffect.Enabled := false;
  VersLaGauche;
end;

procedure TcadJoypad.btnVersLaGaucheMouseLeave(Sender: TObject);
begin
  btnVersLaGaucheBevelEffect.Enabled := true;
  Immobile;
end;

procedure TcadJoypad.btnVersLaGaucheMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  btnVersLaGaucheBevelEffect.Enabled := true;
  Immobile;
end;

procedure TcadJoypad.btnVersLeBasMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  btnVersLeBasBevelEffect.Enabled := false;
  VersLeBas;
end;

procedure TcadJoypad.btnVersLeBasMouseLeave(Sender: TObject);
begin
  btnVersLeBasBevelEffect.Enabled := true;
  Immobile;
end;

procedure TcadJoypad.btnVersLeBasMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  btnVersLeBasBevelEffect.Enabled := true;
  Immobile;
end;

procedure TcadJoypad.btnVersLeHautMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  btnVersLeHautBevelEffect.Enabled := false;
  VersLeHaut;
end;

procedure TcadJoypad.btnVersLeHautMouseLeave(Sender: TObject);
begin
  btnVersLeHautBevelEffect.Enabled := true;
  Immobile;
end;

procedure TcadJoypad.btnVersLeHautMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  btnVersLeHautBevelEffect.Enabled := true;
  Immobile;
end;

constructor TcadJoypad.Create(AOwner: TComponent);
begin
  inherited;
  FDPad := ord(TJoystickDPad.Center);
end;

procedure TcadJoypad.Immobile;
begin
  DPad := ord(TJoystickDPad.Center);
end;

procedure TcadJoypad.SetDPad(const Value: word);
begin
  FDPad := Value;
end;

procedure TcadJoypad.VersLaDroite;
begin
  DPad := ord(TJoystickDPad.right);
end;

procedure TcadJoypad.VersLaGauche;
begin
  DPad := ord(TJoystickDPad.left);
end;

procedure TcadJoypad.VersLeBas;
begin
  DPad := ord(TJoystickDPad.bottom);
end;

procedure TcadJoypad.VersLeHaut;
begin
  DPad := ord(TJoystickDPad.top);
end;

end.
