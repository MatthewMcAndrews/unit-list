unit uDelphiLibraryBrowsingPath;

interface

function DelphiBrowsingPaths: TArray<string>;

implementation

uses
  System.SysUtils,
  uWindowsRegistry,
  uDelphiWindowsRegistry;

function DelphiBrowsingPaths: TArray<string>;
begin
  var BrowsingPath := WindowsRegistry.Computer.HKEY_CURRENT_USER.Software(
    Embarcadero.BDS._20_0.&Library.Win32.BrowsingPath);

  Result := BrowsingPath.Split([PathSep]);
end;

end.
