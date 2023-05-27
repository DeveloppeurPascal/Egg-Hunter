unit uMusic;

interface

uses
  Gamolf.FMX.MusicLoop;

type
  TMusiques = class
  private
    class function getAmbiance: tmusicloop; static;
  protected
    class var fAmbiance: tmusicloop;
  public
    class property Ambiance: tmusicloop read getAmbiance;
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils;

{ TMusiques }

class function TMusiques.getAmbiance: tmusicloop;
var
  NomFichier: string;
begin
  if not assigned(fAmbiance) then
  begin
    fAmbiance := tmusicloop.Create;
{$IF defined(ANDROID)}
    // deploy in .\assets\internal\
    NomFichier := tpath.GetDocumentsPath;
{$ELSEIF defined(MSWINDOWS)}
    // deploy in ;\
{$IFDEF DEBUG}
    NomFichier := '..\..\..\assets\PLRAudios_com';
{$ELSE}
    NomFichier := extractfilepath(paramstr(0));
{$ENDIF}
{$ELSEIF defined(IOS)}
    // deploy in .\
    NomFichier := extractfilepath(paramstr(0));
{$ELSEIF defined(MACOS)}
    // deploy in Contents\MacOS
    NomFichier := extractfilepath(paramstr(0));
{$ELSEIF Defined(LINUX)}
    NomFichier := extractfilepath(paramstr(0));
{$ELSE}
{$MESSAGE FATAL 'OS non supporté'}
{$ENDIF}
    NomFichier := tpath.combine(NomFichier, 'DreamCatcher.mp3');
    fAmbiance.Load(NomFichier);
    // TODO :     fambiance.Volume := tconfig.MusiqueDAmbianceVolume;
  end;
  result := fAmbiance;
end;

initialization

TMusiques.fAmbiance := nil;

finalization

TMusiques.fAmbiance.Free;

end.
