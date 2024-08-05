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
/// Signature : 12b5fb081042e0788df5aa9dd9e2fb7a65ba5ac7
/// ***************************************************************************
/// </summary>

unit uConfig;

interface

Uses
  Gamolf.FMX.MusicLoop;

type
  TConfig = class
  private
    class procedure SetBruitagesOnOff(const Value: boolean); static;
    class procedure SetInterfaceTactileOnOff(const Value: boolean); static;
    class procedure SetMusiqueDAmbianceOnOff(const Value: boolean); static;
    class function getBruitagesOnOff: boolean; static;
    class function getInterfaceTactileOnOff: boolean; static;
    class function getMusiqueDAmbianceOnOff: boolean; static;
    class procedure SetBruitagesVolume(const Value: TVolumeSonore); static;
    class procedure SetMusiqueDAmbianceVolume(const Value
      : TVolumeSonore); static;
    class function getBruitagesVolume: TVolumeSonore; static;
    class function getMusiqueDAmbianceVolume: TVolumeSonore; static;
  public
    class property InterfaceTactileOnOff: boolean read getInterfaceTactileOnOff
      write SetInterfaceTactileOnOff;
    class property BruitagesOnOff: boolean read getBruitagesOnOff
      write SetBruitagesOnOff;
    class property BruitagesVolume: TVolumeSonore read getBruitagesVolume
      write SetBruitagesVolume;
    class property MusiqueDAmbianceOnOff: boolean read getMusiqueDAmbianceOnOff
      write SetMusiqueDAmbianceOnOff;
    class property MusiqueDAmbianceVolume: TVolumeSonore
      read getMusiqueDAmbianceVolume write SetMusiqueDAmbianceVolume;
  end;

implementation

uses
  system.sysutils,
  system.IOUtils,
  FMX.Platform,
  Olf.RTL.Params;

const
  CBruitagesOnOff = 'BruitagesOnOff';
  CBruitagesVolume = 'BruitagesVolume';
  CMusiqueAmbianceOnOff = 'MusiqueAmbianceOnOff';
  CMusiqueAmbianceVolume = 'MusiqueAmbianceVolume';
  CInterfaceTactileOnOff = 'InterfaceTactileOnOff';
  CEffetsVisuelsOnOff = 'EffetsVisuelsOnOff';
  CCheminPartageCapturesEcran = 'CheminPartageCapturesEcran';

  { TConfig }

class function TConfig.getBruitagesOnOff: boolean;
begin
  result := tParams.getValue(CBruitagesOnOff, true);
end;

class function TConfig.getBruitagesVolume: TVolumeSonore;
begin
  result := tParams.getValue(CBruitagesVolume, 100);
end;

class function TConfig.getInterfaceTactileOnOff: boolean;
var
  ValeurParDefaut: boolean;
  DeviceService: IFMXDeviceService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXDeviceService,
    DeviceService) then
    ValeurParDefaut := tdevicefeature.HasTouchScreen
      in DeviceService.GetFeatures
  else
{$IF Defined(iOS) or Defined(ANDROID)}
    ValeurParDefaut := true;
{$ELSE}
    ValeurParDefaut := false;
{$ENDIF}
  result := tParams.getValue(CInterfaceTactileOnOff, ValeurParDefaut);
end;

class function TConfig.getMusiqueDAmbianceOnOff: boolean;
begin
  result := tParams.getValue(CMusiqueAmbianceOnOff, true);
end;

class function TConfig.getMusiqueDAmbianceVolume: TVolumeSonore;
begin
  result := tParams.getValue(CMusiqueAmbianceVolume, 100);
end;

class procedure TConfig.SetBruitagesOnOff(const Value: boolean);
begin
  tParams.setValue(CBruitagesOnOff, Value);
end;

class procedure TConfig.SetBruitagesVolume(const Value: TVolumeSonore);
begin
  tParams.setValue(CBruitagesVolume, Value);
end;

class procedure TConfig.SetInterfaceTactileOnOff(const Value: boolean);
begin
  tParams.setValue(CInterfaceTactileOnOff, Value);
end;

class procedure TConfig.SetMusiqueDAmbianceOnOff(const Value: boolean);
begin
  tParams.setValue(CMusiqueAmbianceOnOff, Value);
end;

class procedure TConfig.SetMusiqueDAmbianceVolume(const Value: TVolumeSonore);
begin
  tParams.setValue(CMusiqueAmbianceVolume, Value);
end;

end.
