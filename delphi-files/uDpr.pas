unit uDpr;

interface

uses
  uDelphiFile;

type
  IDpr = interface(IDelphiFile)
    function &Program: string;
    function Name: string;
    function Main: string;
  end;

function NewDpr(FilePath: string): IDpr;

implementation

uses
  SysUtils, IOUtils, RegularExpressions;

type
  TDpr = class(TDelphiFile, IDpr)
    function &Program: string;
    function Name: string;
    function Main: string;
  end;

function NewDpr(FilePath: string): IDpr;
begin
  Result := TDpr.Create(FilePath);
end;

{ TDpr }

function TDpr.Main: string;
begin
  raise Exception.Create('Not yet implemented.');
end;

function TDpr.Name: string;
begin
  Result := &Program;
end;

function TDpr.&Program: string;
const
  sProgramPattern = 'program\s*(\w+)\s*;';
begin
  var FilePath := TPath.GetFullPath(Path);
  var Text := TFile.ReadAllText(FilePath);

  var Match := TRegEx.Match(Text, sProgramPattern);
  if Match.Success then begin
    var NameGroup := Match.Groups[1];
    Result := NameGroup.Value;
  end else begin
    raise Exception.Create('No program line found in file: ' + FilePath);
  end;
end;

end.
