unit uDelphiEnvironmentVariablesTest;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TDelphiEnvironmentVariablesTest = class
  public
    [Test]
    procedure bds_value;
    [Test]
    procedure bdsbin_value;
  end;

implementation

uses
  uDelphiEnvironmentVariables;

{ TDelphiEnvironmentVariablesTest }

procedure TDelphiEnvironmentVariablesTest.bdsbin_value;
begin
  Assert.AreEqual('C:\Program Files (x86)\Embarcadero\Studio\20.0\bin\', BDSBIN);
end;

procedure TDelphiEnvironmentVariablesTest.bds_value;
begin
  Assert.AreEqual('C:\Program Files (x86)\Embarcadero\Studio\20.0\', BDS);
end;

initialization
  TDUnitX.RegisterTestFixture(TDelphiEnvironmentVariablesTest);

end.
