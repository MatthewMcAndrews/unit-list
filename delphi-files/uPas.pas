unit uPas;

interface

uses
  uDelphiFile;

type
  IPas = interface(IDelphiFile)
    function Name: string;
  end;

function NewPas(UnitRelativePath: string): IPas;

implementation

uses
  SysUtils, IOUtils, RegularExpressions;

type
  TPas = class(TDelphiFile, IPas)
    function Name: string;
  end;

function NewPas(UnitRelativePath: string): IPas;
begin
  Result := TPas.Create(UnitRelativePath);
end;

{ TPas }

function TPas.Name: string;
const
  sUnitPattern = 'unit\s*(\w+)\s*;';
begin
  var FilePath := TPath.GetFullPath(Path);
  var Text := TFile.ReadAllText(FilePath);

  var Match := TRegEx.Match(Text, sUnitPattern);
  if Match.Success then begin
    var NameGroup := Match.Groups[1];
    Result := NameGroup.Value;
  end else begin
    raise Exception.Create('No "unit" line found in file: ' + FilePath);
  end;
end;

end.
