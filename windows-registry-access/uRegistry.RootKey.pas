unit uRegistry.RootKey;

interface

uses
  WinApi.Windows;

function RootKey(RootKeyName: string): HKEY;

implementation

uses
  System.SysUtils;

function RootKey(RootKeyName: string): HKEY;
begin
  if SameText(RootKeyName, 'HKEY_CLASSES_ROOT') then
    Result := HKEY_CLASSES_ROOT
  else if SameText(RootKeyName, 'HKEY_CURRENT_USER') then
    Result := HKEY_CURRENT_USER
  else if SameText(RootKeyName, 'HKEY_LOCAL_MACHINE') then
    Result := HKEY_LOCAL_MACHINE
  else if SameText(RootKeyName, 'HKEY_USERS') then
    Result := HKEY_USERS
  else if SameText(RootKeyName, 'HKEY_PERFORMANCE_DATA') then
    Result := HKEY_PERFORMANCE_DATA
  else if SameText(RootKeyName, 'HKEY_CURRENT_CONFIG') then
    Result := HKEY_CURRENT_CONFIG
  else if SameText(RootKeyName, 'HKEY_DYN_DATA') then
    Result := HKEY_DYN_DATA
  else
    raise Exception.Create('Unknown Root Key Name: ' + RootKeyName);
end;

end.
