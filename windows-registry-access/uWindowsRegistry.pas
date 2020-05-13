unit uWindowsRegistry;

interface

{ This unit provides an interface for SOME Windows Registry data.

  Usage:
    WindowsRegistry.Computer.HKEY_CURRENT_USER.Software.Path
      -> 'Computer\HKEY_CURRENT_USER\Software'
    WindowsRegistry.Computer.HKEY_CURRENT_USER.Software('Embarcadero\BDS\20.0\RootDir')
      -> 'C:\Program Files (x86)\Embarcadero\Studio\20.0\'
}

type
  TRegistryPath = class
  protected
    var FPath: string;
  public
    function Path: string;
  end;

  TRegistryAccess = class(TRegistryPath)
    function Value(KeyName: string): string;
    function TryValue(KeyName: string; out Value: string): Boolean;
  end;

  TSoftware = class(TRegistryAccess)
  private
    constructor Create(ParentPath: string);
  end;
  THkeyCurrentUser = class(TRegistryPath)
    function Software: TSoftware; overload;
    function Software(KeyName: string): string; overload;
  private
    constructor Create(ParentPath: string);
  end;
  TComputer = class(TRegistryPath)
    function HKEY_CURRENT_USER: THkeyCurrentUser;
  private
    constructor Create;
  end;

  TWindowsRegistry = class
    function Computer: TComputer;
  end;

function WindowsRegistry: TWindowsRegistry;

implementation

uses
  uRegistry;

function WindowsRegistry: TWindowsRegistry;
begin
  Result := TWindowsRegistry.Create;
end;

{ TWindowsRegistry }

function TWindowsRegistry.Computer: TComputer;
begin
  Result := TComputer.Create;
end;

{ TComputer }

constructor TComputer.Create;
begin
  FPath := 'Computer';
end;

function TComputer.HKEY_CURRENT_USER: THkeyCurrentUser;
begin
  Result := THkeyCurrentUser.Create(Path);
end;

{ TRegistryPath }

function TRegistryPath.Path: string;
begin
  Result := FPath;
end;

{ TRegistryAccess }

function TRegistryAccess.TryValue(KeyName: string; out Value: string): Boolean;
begin
  Result := uRegistry.TryValue(Path + '\' + KeyName, Value);
end;

function TRegistryAccess.Value(KeyName: string): string;
begin
  uRegistry.Value(Path + '\' + KeyName);
end;

{ THkeyCurrentUser }

constructor THkeyCurrentUser.Create(ParentPath: string);
begin
  FPath := ParentPath + '\HKEY_CURRENT_USER';
end;

function THkeyCurrentUser.Software: TSoftware;
begin
  Result := TSoftware.Create(Path);
end;

function THkeyCurrentUser.Software(KeyName: string): string;
begin
  Result := Value(Software.Path + '\' + KeyName);
end;

{ TSoftware }

constructor TSoftware.Create(ParentPath: string);
begin
  FPath := ParentPath + '\Software';
end;

end.
