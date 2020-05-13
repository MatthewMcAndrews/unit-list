unit uDelphiWindowsRegistryTest;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TDelphiWindowsRegistryTest = class
  public
    [Test]
    procedure embarcadero_path;
    [Test]
    procedure embarcadero_bds_path;
    [Test]
    procedure embarcadero_bds_20_0_path;
    [Test]
    procedure embarcadero_bds_20_0_library_path;
    [Test]
    procedure embarcadero_bds_20_0_library_win32_path;
    [Test]
    procedure embarcadero_bds_20_0_library_win64_path;

    [Test]
    procedure embarcadero_bds_20_0_rootdir;
  end;

implementation

uses
  uDelphiWindowsRegistry;

procedure TDelphiWindowsRegistryTest.embarcadero_bds_20_0_library_win32_path;
begin
  Assert.AreEqual('Embarcadero\BDS\20.0\Library\Win32\', Embarcadero.BDS._20_0.&Library.Win32.Path);
end;

procedure TDelphiWindowsRegistryTest.embarcadero_bds_20_0_library_win64_path;
begin
  Assert.AreEqual('Embarcadero\BDS\20.0\Library\Win64\', Embarcadero.BDS._20_0.&Library.Win64.Path);
end;

procedure TDelphiWindowsRegistryTest.embarcadero_bds_20_0_library_path;
begin
  Assert.AreEqual('Embarcadero\BDS\20.0\Library\', Embarcadero.BDS._20_0.&Library.Path);
end;

procedure TDelphiWindowsRegistryTest.embarcadero_bds_20_0_path;
begin
  Assert.AreEqual('Embarcadero\BDS\20.0\', Embarcadero.BDS._20_0.Path);
end;

procedure TDelphiWindowsRegistryTest.embarcadero_bds_path;
begin
  Assert.AreEqual('Embarcadero\BDS\', Embarcadero.BDS.Path);
end;

procedure TDelphiWindowsRegistryTest.embarcadero_path;
begin
  Assert.AreEqual('Embarcadero\', Embarcadero.Path);
end;

procedure TDelphiWindowsRegistryTest.embarcadero_bds_20_0_rootdir;
begin
  Assert.AreEqual('Embarcadero\BDS\20.0\RootDir', Embarcadero.BDS._20_0.RootDir);
end;

initialization
  TDUnitX.RegisterTestFixture(TDelphiWindowsRegistryTest);

end.
