unit uRegistry;

interface

uses
  Winapi.Windows;

{ Value: Return the registry value assiciated with the given Root/Key/Name.
  Raise an exception if Value does not exist. }
{ TryValue: Return True if the registry Root/Key/Name exists;
  Populate Value if the registry Root/Key/Name exists. }

{ Value('Computer\<RootKeyName>\<Key>\<Name>')
  Value('Computer\HKEY_CURRENT_USER\Software\Embarcadero\BDS\20.0\RootDir') -> 'C:\Program Files (x86)\Embarcadero\Studio\20.0\'}
function Value(FullPath: string): string; overload;
function TryValue(FullPath: string; out Value: string): Boolean; overload;

{ Value(<RootKey>, '<Key>/<Name>')
  Value(HKEY_CURRENT_USER, 'Software\Embarcadero\BDS\20.0\RootDir') -> 'C:\Program Files (x86)\Embarcadero\Studio\20.0\'}
function Value(RootKey: HKEY; PathFromRoot: string): string; overload;
function TryValue(RootKey: HKEY; PathFromRoot: string; out Value: string): Boolean; overload;

{ Value(<RootKey>, <Key>, <Name>)
  Value(HKEY_CURRENT_USER, 'Software\Embarcadero\BDS\20.0\', 'RootDir') -> 'C:\Program Files (x86)\Embarcadero\Studio\20.0\'}
function Value(RootKey: HKEY; Key, Name: string): string; overload;
function TryValue(RootKey: HKEY; Key, Name: string; out Value: string): Boolean; overload;

implementation

uses
  System.SysUtils,
  System.Win.Registry,
  uRegistry.RootKey;

const
  sRegistryRoot = 'Computer';
  cPathSep = '\';

type
  TPathInclude = (piRoot, piRootKey, piKey, piName);
  TPathIncludeSet = set of TPathInclude;
const
  AllPathIncludes = [piRoot, piRootKey, piKey, piName];

//------------------------------------------------------------------------------
// Helper Routines

  function GetKey(
    PathTokens: TArray<string>;
    PathIncludes: TPathIncludeSet = AllPathIncludes): string;
  begin
    Result := '';

    var FirstKeyTokenIndex := 0;
    if (piRoot in PathIncludes) then
      FirstKeyTokenIndex := FirstKeyTokenIndex + 1;
    if (piRootKey in PathIncludes) then
      FirstKeyTokenIndex := FirstKeyTokenIndex + 1;

    var LastKeyTokenIndex := Length(PathTokens) - 1;
    if (piKey in PathIncludes) then
      LastKeyTokenIndex := LastKeyTokenIndex - 1;

    for var i := FirstKeyTokenIndex to LastKeyTokenIndex do begin
      if Result.IsEmpty then
        Result := PathTokens[i]
      else
        Result := Result + cPathSep + PathTokens[i];
    end;
  end;

  function GetName(PathTokens: TArray<string>): string;
  begin
    var NameIndex := Length(PathTokens) - 1;
    Result := PathTokens[NameIndex];
  end;

//------------------------------------------------------------------------------

function Value(RootKey: HKEY; Key, Name: string): string; overload;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := RootKey;

    Registry.OpenKey(Key, False);

    Result := Registry.ReadString(Name);

    if not Registry.ValueExists(Name) then
      raise Exception.Create('Registry Value Is Empty: ' + Key + '\' + Name);

  finally
    Registry.Free;
  end;
end;

function TryValue(RootKey: HKEY; Key, Name: string; out Value: string): Boolean; overload;
begin
  Result := True;
  try
    Value := uRegistry.Value(RootKey, Key, Name);
  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

function Value(RootKey: HKEY; PathFromRoot: string): string;
begin
  var Tokens := PathFromRoot.Split([cPathSep]);
  var Key := GetKey(Tokens, [piKey, piName]);
  var Name := GetName(Tokens);

  Result := uRegistry.Value(RootKey, Key, Name);
end;

function TryValue(RootKey: HKEY; PathFromRoot: string; out Value: string): Boolean;
begin
  Result := True;
  try
    Value := uRegistry.Value(RootKey, PathFromRoot);
  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

{ Value(<RootKeyName>, <Key>, <Name>)
  Value('HKEY_CURRENT_USER', 'Software\Embarcadero\BDS\20.0\', 'RootDir') -> 'C:\Program Files (x86)\Embarcadero\Studio\20.0\'}
function Value(RootKeyName, Key, Name: string): string; overload;
begin
  Result := Value(
    RootKey(RootKeyName),
    Key,
    Name);
end;

function TryValue(RootKeyName, Key, Name: string; out Value: string): Boolean; overload;
begin
  Result := True;
  try
    Value := uRegistry.Value(RootKeyName, Key, Name);
  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

function Value(FullPath: string): string;

  procedure ValidateRegistryRoot(RegistryRootName: string);
  begin
    if not SameText(RegistryRootName, sRegistryRoot) then begin
      raise Exception.CreateFmt(
        'Unknown Registry Root Name: %s. %s Expected.',
        [RegistryRootName, sRegistryRoot]);
    end;
  end;

begin
  var Tokens := FullPath.Split([cPathSep]);

  ValidateRegistryRoot(Tokens[0]);

  var RootKeyName := Tokens[1];
  var Key := GetKey(Tokens);
  var Name := GetName(Tokens);

  Result := Value(RootKeyName, Key, Name);
end;

function TryValue(FullPath: string; out Value: string): Boolean;
begin
  Result := True;
  try
    Value := uRegistry.Value(FullPath);
  except
    Result := False;
  end;
end;

end.
