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
/// File last update : 2024-08-05T19:47:10.656+02:00
/// Signature : a5a89ff37500c81d549cc43066dc1ae9368a7c85
/// ***************************************************************************
/// </summary>

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
