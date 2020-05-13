unit uDelphiWindowsRegistry;

interface

{ This unit provides an interface for SOME Embarcadero Windows Registry data.

  The contents of this unit are specific to Delphi 10.3,
  and may be useless for future Delphi versions }

const
  sEmbarcaderoBDS_20_0 = 'Software\Embarcadero\BDS\20.0\';
  sEmbarcaderoWin32 = sEmbarcaderoBDS_20_0 + 'Library\Win32\';
  sBrowsingPathKey = 'Browsing Path';
  sBDSKey = 'RootDir';

type
  IRegistry = interface
    { Return the registry value associated with the Name }
    function Value(Name: string): string;
    { Return the current registry path }
    function Path: string;
  end;

//------------------------------------------------------------------------------
// Shared Inherited Interfaces

  ILibraryPlatform = interface(IRegistry)
    function BrowsingPath: string;
  end;
//------------------------------------------------------------------------------

  IEmbarcadero = interface;
    IBDS = interface;
      I_20_0 = interface;
        ILibrary = interface;
          IWin32 = interface;
          IWin64 = interface;

  IDelphiRegistry = interface(IRegistry)
    function Embarcadero: IEmbarcadero;
  end;

  IEmbarcadero = interface(IRegistry)
    function BDS: IBDS;
  end;
  IBDS = interface(IRegistry)
    function _20_0: I_20_0;
  end;
  I_20_0 = interface(IRegistry)
    function RootDir: string;
    function &Library: ILibrary;
  end;
  ILibrary = interface(IRegistry)
    function Win32: IWin32;
    function Win64: IWin64;
  end;
  IWin32 = interface(ILibraryPlatform)
  end;
  IWin64 = interface(ILibraryPlatform)
  end;

function DelphiWindowsRegistry: IDelphiRegistry;

implementation

type
  TRegistryAccess = class(TInterfacedObject, IRegistry)
    function Value(Name: string): string;
    function Path: string;
  end;
  TDelphiRegistry = class(TRegistryAccess, IDelphiRegistry)
    function Embarcadero: IEmbarcadero;
  end;
  TEmbarcadero = class(TRegistryAccess, IEmbarcadero)
    function BDS: IBDS;
  end;

function DelphiWindowsRegistry: IDelphiRegistry;
begin
//  Result :=
end;

{ TRegistryAccess }

function TRegistryAccess.Path: string;
begin

end;

function TRegistryAccess.Value(Name: string): string;
begin

end;

{ TEmbarcadero }

function TEmbarcadero.BDS: IBDS;
begin

end;

{ TDelphiRegistry }

function TDelphiRegistry.Embarcadero: IEmbarcadero;
begin

end;

end.
