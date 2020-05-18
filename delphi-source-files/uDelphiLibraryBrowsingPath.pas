unit uDelphiLibraryBrowsingPath;

interface

function DelphiBrowsingPaths: TArray<string>;
function DelphiBrowsingPathsResolved: TArray<string>;

implementation

uses
  System.SysUtils,
  uWindowsRegistry,
  uDelphiWindowsRegistry, uDelphiEnvironmentVariables;

function DelphiBrowsingPaths: TArray<string>;
begin
  var BrowsingPath := WindowsRegistry.Computer.HKEY_CURRENT_USER.Software(
    Embarcadero.BDS._20_0.&Library.Win32.BrowsingPath);

  Result := BrowsingPath.Split([PathSep]);
end;

function DelphiBrowsingPathsResolved: TArray<string>;
begin
  var BdsVal := BDS;

  Result := [];
  for var Path in DelphiBrowsingPaths do begin
    var ResolvedPath := Path.Replace('$(BDS)\', BdsVal);

    Result := Result + [ResolvedPath];
  end;

  { Spike in some known libraries that may be absent from the browsing path.
    These may be excluded from compiling/linking by conditional compiler defines. }
  Result := Result + [BdsVal + 'source\rtl\posix'];
  Result := Result + [BdsVal + 'source\rtl\osx'];
//  Result := Result + [BdsVal + 'source\rtl\osx'];
end;

end.
