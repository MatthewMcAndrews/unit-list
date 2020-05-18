unit uUnitList;

interface

procedure WriteUnitList(ProjectFileName: string);

implementation

uses
  SysUtils, IOUtils, Variants, Generics.Collections,
  uFile, uDelphiSourceFiles, uDpr, uPas, PathAbsRel;

{ FileNames with slashes are definately not delphi system files.
  There was an issue passing these through the TryFindSourceFile routine.
  It may be better to positively identify these as the ones in the .dpr as
    <name> in '<relative_path>'}
function IsNotSourceFile(FileName: string): Boolean;
begin
  Result := FileName.Contains('\');
end;

function GetDprUsedUnits(DprPath: string): TDictionary<string, string>;
begin
  var ProjectName := ExtractFileNameOnly(DprPath);
  var ProjectFilePath := ExtractFilePath(DprPath);

  Result := TDictionary<string, string>.Create;
  Result.Add(ProjectName, DprPath);

  var Dpr := NewDpr(DprPath);
  var UsedUnits := Dpr.&Uses;
  for var UsedUnit in UsedUnits do begin

    var UnitFilePath: string;

    if UsedUnit.IsLibraryUnit then begin
      if not TryFindSourceFile(UsedUnit.Name, UnitFilePath) then begin
        raise Exception.Create('Library Unit Not Found: ' + UsedUnit.Name);
      end;
    end else begin
      UnitFilePath := RelToAbs(UsedUnit.RelativePath, ProjectFilePath);
    end;

    Result.Add(UsedUnit.Name, UnitFilePath);
  end;
end;

procedure WriteUnitList(ProjectFileName: string);
begin
  // TODO: validate input is .dpr

  { Get absolute paths of all files referenced in the .dpr
      This should include all units used by the project except for
      library/browsed units only used by .pas files. }
  var KnownUnits := GetDprUsedUnits(ProjectFileName);

  { Get the absolute paths of any library/browsed units that are used only by
    .pas files. }
  var UnprocessedUnitPaths := TList<string>.Create;
  for var Value in KnownUnits.Values do
    UnprocessedUnitPaths.Add(Value);
  var MissingFiles := TDictionary<string, Variant>.Create;
  while UnprocessedUnitPaths.Count > 0 do begin

    var UnitToProcess := UnprocessedUnitPaths.First;
    var &Unit := NewPas(UnitToProcess);
    var UsedUnits := &Unit.&Uses;
    for var UsedUnit in UsedUnits do begin

      { Add any newly encountered library/browsed units
          to the list of known units and
          to the list of units to be processed. }
      if not KnownUnits.ContainsKey(UsedUnit.Name) then begin

        var UnitFilePath: string;
        if TryFindSourceFile(UsedUnit.Name, UnitFilePath) then begin
          KnownUnits.Add(UsedUnit.Name, UnitFilePath);
          UnprocessedUnitPaths.Add(UnitFilePath);
        end else begin
          Writeln('----File not found: ' + UsedUnit.Name);
          MissingFiles.AddOrSetValue(UsedUnit.Name, Null);
        end;
      end;
    end;

    { Mark the current unit as processed. }
    UnprocessedUnitPaths.Remove(UnitToProcess);
  end;

  var UnitPaths := TList<string>.Create;
  for var Value in KnownUnits.Values do
    UnitPaths.Add(Value);

  Writeln('');
  Writeln('All Units Used By Project:');
  UnitPaths.Sort;
  for var UnitPath in UnitPaths do
    Writeln('  ', UnitPath);

  var MissingUnitPaths := TList<string>.Create;
  MissingUnitPaths.AddRange(MissingFiles.Keys);

  Writeln('');
  Writeln('Units Used By Project, But Not Found:');
  Writeln('*The Paths To These Units May Need To Be Added To Your Library/Browsing Paths.');
  MissingUnitPaths.Sort;
  for var UnitPath in MissingUnitPaths do
    Writeln('  ', UnitPath);

end;

end.
