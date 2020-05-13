unit uRegistryTest;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TRegistryTest = class
  public
//    [Test]
    procedure non_existant_key_name_will_raise_exception;
    [Test]
    procedure valid_key_name;
    [Test]
    procedure valid_root_key_name;
    [Test]
    procedure valid_root_key_path;
  end;

implementation

uses
  SysUtils,
  WinApi.Windows,
  uRegistry;

procedure TRegistryTest.non_existant_key_name_will_raise_exception;
begin
  Assert.WillRaise(
    procedure begin uRegistry.Value('probably an invalid registry path') end,
    Exception);
end;

procedure TRegistryTest.valid_key_name;
begin
  Assert.AreEqual(
    'C:\Program Files (x86)\Embarcadero\Studio\20.0\',
    uRegistry.Value('Computer\HKEY_CURRENT_USER\Software\Embarcadero\BDS\20.0\RootDir'));
end;

procedure TRegistryTest.valid_root_key_name;
begin
  Assert.AreEqual(
    'C:\Program Files (x86)\Embarcadero\Studio\20.0\',
    uRegistry.Value(HKEY_CURRENT_USER, 'Software\Embarcadero\BDS\20.0\', 'RootDir'));
end;

procedure TRegistryTest.valid_root_key_path;
begin
  Assert.AreEqual(
    'C:\Program Files (x86)\Embarcadero\Studio\20.0\',
    uRegistry.Value(HKEY_CURRENT_USER, 'Software\Embarcadero\BDS\20.0\RootDir'));
end;

initialization
  TDUnitX.RegisterTestFixture(TRegistryTest);

end.
