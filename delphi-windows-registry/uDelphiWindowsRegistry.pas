unit uDelphiWindowsRegistry;

interface

{ This unit provides an interface for SOME Embarcadero Windows Registry paths.
  This is meant to be a path string builder which builds registry paths
    corresponding to the Delphi Windows Registry paths which are currently
    located in "Computer\HKEY_CURRENT_USER\Software\".

  The contents of this unit are specific to Delphi 10.3,
    and may be useless for future Delphi versions

  Usage:
    Embarcadero.BDS._20_0.RootDir -> 'Embarcadero\BDS\20.0\RootDir'
}

uses
  uWindowsRegistry;

type
  TDelphiPlatformRegistry = class(TRegistryPath)
    function BrowsingPath: string;
  end;

  TWin32 = class(TDelphiPlatformRegistry)
  private
    constructor Create(ParentPath: string);
  end;
  TWin64 = class(TDelphiPlatformRegistry)
  private
    constructor Create(ParentPath: string);
  end;
  TLibrary = class(TRegistryPath)
    function Win32: TWin32;
    function Win64: TWin64;
  private
    constructor Create(ParentPath: string);
  end;
  T_20_0 = class(TRegistryPath)
    function RootDir: string;
    function &Library: TLibrary;
  private
    constructor Create(ParentPath: string);
  end;
  TBDS = class(TRegistryPath)
    function _20_0: T_20_0;
  private
    constructor Create(ParentPath: string);
  end;
  TEmbarcadero = class(TRegistryPath)
    function BDS: TBDS;
  private
    constructor Create;
  end;

function Embarcadero: TEmbarcadero;

implementation

function Embarcadero: TEmbarcadero;
begin
  Result := TEmbarcadero.Create;
end;

{ TEmbarcadero }

function TEmbarcadero.BDS: TBDS;
begin
  Result := TBDS.Create(Path);
end;

constructor TEmbarcadero.Create;
begin
  FPath := 'Embarcadero\';
end;

{ TBDS }

constructor TBDS.Create(ParentPath: string);
begin
  FPath := ParentPath + 'BDS\';
end;

function TBDS._20_0: T_20_0;
begin
  Result := T_20_0.Create(Path);
end;

{ T_20_0 }

constructor T_20_0.Create(ParentPath: string);
begin
  FPath := ParentPath + '20.0\';
end;

function T_20_0.&Library: TLibrary;
begin
  Result := TLibrary.Create(Path);
end;

function T_20_0.RootDir: string;
begin
  Result := Path + 'RootDir';
end;

{ TLibrary }

constructor TLibrary.Create(ParentPath: string);
begin
  FPath := ParentPath + 'Library\';
end;

function TLibrary.Win32: TWin32;
begin
  Result := TWin32.Create(Path);
end;

function TLibrary.Win64: TWin64;
begin
  Result := TWin64.Create(Path);
end;

{ TWin32 }

constructor TWin32.Create(ParentPath: string);
begin
  FPath := ParentPath + 'Win32\';
end;

{ TWin64 }

constructor TWin64.Create(ParentPath: string);
begin
  FPath := ParentPath + 'Win64\';
end;

{ TDelphiPlatformRegistry }

function TDelphiPlatformRegistry.BrowsingPath: string;
begin
  Result := Path + 'Browsing Path';
end;

end.
