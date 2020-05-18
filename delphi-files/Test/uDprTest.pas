unit uDprTest;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TDprTest = class
  public
    [Test]
    procedure dpr_program_name;
  end;

implementation

uses
  uDpr;

{ TDprTest }

procedure TDprTest.dpr_program_name;
begin
  Assert.AreEqual('pUnitList', NewDpr('..\..\..\pUnitList.dpr').&Program);
  var Test := NewDpr('..\..\..\pUnitList.dpr').&Uses;
end;

initialization
  TDUnitX.RegisterTestFixture(TDprTest);

end.
