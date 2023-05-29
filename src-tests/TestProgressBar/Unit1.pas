unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  cLabeledProgressBar, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TForm1 = class(TForm)
    cadLabeledProgressBar1: TcadLabeledProgressBar;
    cadLabeledProgressBar2: TcadLabeledProgressBar;
    cadLabeledProgressBar3: TcadLabeledProgressBar;
    cadLabeledProgressBar4: TcadLabeledProgressBar;
    Timer1: TTimer;
    btnStartStop: TButton;
    btnReset: TButton;
    GridPanelLayout1: TGridPanelLayout;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnStartStopClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btnResetClick(Sender: TObject);
begin
  cadLabeledProgressBar1.Value := 0;
  cadLabeledProgressBar2.Value := 0;
  cadLabeledProgressBar3.Value := 0;
  cadLabeledProgressBar4.Value := 0;
end;

procedure TForm1.btnStartStopClick(Sender: TObject);
begin
  Timer1.Enabled := not Timer1.Enabled;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  cadLabeledProgressBar1.Color := TcadLabeledProgressBarColor.bleu;
  cadLabeledProgressBar1.Text.Text := 'bleu';
  cadLabeledProgressBar1.ShowValueInText := false;
  cadLabeledProgressBar1.Value := 0;

  cadLabeledProgressBar2.Color := TcadLabeledProgressBarColor.vert;
  cadLabeledProgressBar2.Text.Text := 'vert';
  cadLabeledProgressBar2.Value := 0;

  cadLabeledProgressBar3.Color := TcadLabeledProgressBarColor.rouge;
  cadLabeledProgressBar3.Text.Text := 'rouge';
  cadLabeledProgressBar3.ShowValueInText := false;
  cadLabeledProgressBar3.ValueUnit := '%';
  cadLabeledProgressBar3.Value := 0;

  cadLabeledProgressBar4.Color := TcadLabeledProgressBarColor.jaune;
  cadLabeledProgressBar4.Text.Text := 'jaune';
  cadLabeledProgressBar4.ShowValueInText := true;
  cadLabeledProgressBar4.ValueUnit := '%';
  cadLabeledProgressBar4.Value := 0;

  Timer1.Enabled := false;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  cadLabeledProgressBar1.Value := cadLabeledProgressBar1.Value + random(20) + 1;
  cadLabeledProgressBar2.Value := cadLabeledProgressBar2.Value + random(20) + 1;
  cadLabeledProgressBar3.Value := cadLabeledProgressBar3.Value + random(20) + 1;
  cadLabeledProgressBar4.Value := cadLabeledProgressBar4.Value + random(20) + 1;
end;

initialization

randomize;
ReportMemoryLeaksOnShutdown := true;

end.
