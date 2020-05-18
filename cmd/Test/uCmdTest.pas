unit uCmdTest;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TCmdTest = class
  public
//    [Test]
    procedure cmd_create_missing_drive_exception;
    [Test]
    procedure cmd_cd;
    [Test]
    procedure cmd_cd_forward;
    [Test]
    procedure cmd_cd_backward;
//    [Test]
    procedure cmd_cd_forward_invalid;
    [Test]
    procedure cmd_cd_backward_invalid;
  end;

implementation

uses
  SysUtils,
  uCmd;

{ TCmdTest }

const
  sC = 'C:\';
  sProgFiles = 'Program Files (x86)';
  sC_ProgFiles = sC + sProgFiles;

procedure TCmdTest.cmd_cd;
begin
  var Cmd := NewCommandPrompt(sC_ProgFiles);
  Assert.AreEqual(sC_ProgFiles, Cmd.Cd);
end;

procedure TCmdTest.cmd_cd_backward;
begin
  var Cmd := NewCommandPrompt(sC_ProgFiles);
  Assert.AreEqual(sC, Cmd.cd('..'));
end;

procedure TCmdTest.cmd_cd_backward_invalid;
begin
  var Cmd := NewCommandPrompt(sC);
  Assert.AreEqual(sC, Cmd.cd('..'));
end;

procedure TCmdTest.cmd_cd_forward;
begin
  var Cmd := NewCommandPrompt(sC);
  Assert.AreEqual(sC_ProgFiles, Cmd.cd(sProgFiles));
end;

procedure TCmdTest.cmd_cd_forward_invalid;
begin
  var Cmd := NewCommandPrompt(sC);
  Assert.WillRaise(
    procedure
    begin
      Cmd.cd('invalid folder');
    end,
    Exception);
end;

procedure TCmdTest.cmd_create_missing_drive_exception;
begin
  Assert.WillRaise(
    procedure
    begin
      NewCommandPrompt('\projects\delphi\unit-list');
    end,
    Exception);
end;

initialization
  TDUnitX.RegisterTestFixture(TCmdTest);

end.
