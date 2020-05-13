unit uWindowsRegistryTest;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TWindowsRegistryTest = class
  public
    [Test]
    procedure windows_registry_computer_path;
    [Test]
    procedure windows_registry_computer_hkey_current_user_path;
    [Test]
    procedure windows_registry_computer_hkey_current_user_software_path;
    [Test]
    procedure windows_registry_computer_hkey_current_user_software_key;
    [Test]
    procedure windows_registry_computer_hkey_current_user_software_slash_key;
  end;

implementation

uses
  uWindowsRegistry;

{ TWindowsRegistryTest }

procedure TWindowsRegistryTest.windows_registry_computer_hkey_current_user_path;
begin
  Assert.AreEqual('Computer\HKEY_CURRENT_USER',
    WindowsRegistry.Computer.HKEY_CURRENT_USER.Path);
end;

procedure TWindowsRegistryTest.windows_registry_computer_hkey_current_user_software_path;
begin
  Assert.AreEqual('Computer\HKEY_CURRENT_USER\Software',
    WindowsRegistry.Computer.HKEY_CURRENT_USER.Software.Path);
end;

procedure TWindowsRegistryTest.windows_registry_computer_hkey_current_user_software_key;
begin
  Assert.AreEqual('C:\Program Files (x86)\Embarcadero\Studio\20.0\',
    WindowsRegistry.Computer.HKEY_CURRENT_USER.Software('Embarcadero\BDS\20.0\RootDir'));
end;

procedure TWindowsRegistryTest.windows_registry_computer_hkey_current_user_software_slash_key;
begin
  Assert.AreEqual('C:\Program Files (x86)\Embarcadero\Studio\20.0\',
    WindowsRegistry.Computer.HKEY_CURRENT_USER.Software('\Embarcadero\BDS\20.0\RootDir'));
end;

procedure TWindowsRegistryTest.windows_registry_computer_path;
begin
  Assert.AreEqual('Computer',
    WindowsRegistry.Computer.Path);
end;

initialization
  TDUnitX.RegisterTestFixture(TWindowsRegistryTest);

end.
