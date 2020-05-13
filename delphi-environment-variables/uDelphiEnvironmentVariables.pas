unit uDelphiEnvironmentVariables;

interface

{ Return the value of the $(BDS*) delphi environment variables }
function BDS: string;
function BDSBIN: string;

implementation

uses
  uWindowsRegistry,
  uDelphiWindowsRegistry;

function BDS: string;
begin
  Result := WindowsRegistry.Computer.HKEY_CURRENT_USER.Software(Embarcadero.BDS._20_0.RootDir);
end;

function BDSBIN: string;
begin
  Result := BDS + 'bin\';
end;

end.
