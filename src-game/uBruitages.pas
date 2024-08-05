unit uBruitages;

interface

type
{$SCOPEDENUMS ON}
  TTypeBruitage = (CanardMort, OeufPonte, OeufRamassage, OeufEclosion,
    DialogBoxOpen, DialogBoxClose, Beep);

procedure JouerBruitage(TypeBruitage: TTypeBruitage);
procedure CouperLesBruitages;

implementation

uses
  system.IOutils,
  system.SysUtils,
  system.Threading,
  system.Generics.Collections,
  uConfig,
  Gamolf.FMX.MusicLoop;

procedure Prechargement;
var
  TypeBruitage: TTypeBruitage;
  Chemin: string;
  NomFichier: string;
begin
{$IF defined(ANDROID)}
  // deploy in .\assets\internal\
  Chemin := tpath.GetDocumentsPath;
{$ELSEIF defined(MSWINDOWS)}
  // deploy in ;\
{$IFDEF DEBUG}
  Chemin := '..\..\..\_PRIVATE\assets\TheGameCreators\SoundMatter';
{$ELSE}
  Chemin := extractfilepath(paramstr(0));
{$ENDIF}
{$ELSEIF defined(IOS)}
  // deploy in .\
  Chemin := extractfilepath(paramstr(0));
{$ELSEIF defined(MACOS)}
  // deploy in Contents\MacOS
  Chemin := extractfilepath(paramstr(0));
{$ELSEIF Defined(LINUX)}
  Chemin := extractfilepath(paramstr(0));
{$ELSE}
{$MESSAGE FATAL 'OS non supporté'}
{$ENDIF}
  for TypeBruitage := low(TTypeBruitage) to high(TTypeBruitage) do
  begin
    case TypeBruitage of
      TTypeBruitage.CanardMort:
        NomFichier := 'DuckyOuch.wav';
      TTypeBruitage.OeufPonte:
        NomFichier := 'CaveDrip.wav';
      TTypeBruitage.OeufRamassage:
        NomFichier := 'PutDown.wav';
      TTypeBruitage.OeufEclosion:
        NomFichier := 'HarpChordUp.wav';
      TTypeBruitage.DialogBoxOpen:
        NomFichier := 'SwapTiles.wav';
      TTypeBruitage.DialogBoxClose:
        NomFichier := 'SwapTiles.wav';
      TTypeBruitage.Beep:
        NomFichier := 'BleepTelephone.wav';
    else
      exit;
    end;
    TSoundList.Current.add(ord(TypeBruitage),
      tpath.combine(Chemin, NomFichier));
  end;
  TSoundList.Current.Volume := tconfig.BruitagesVolume;
end;

procedure JouerBruitage(TypeBruitage: TTypeBruitage);
begin
  if tconfig.BruitagesOnOff then
    TSoundList.Current.Play(ord(TypeBruitage));
end;

procedure CouperLesBruitages;
begin
  TSoundList.Current.MuteAll;
end;

initialization

Prechargement;

end.
