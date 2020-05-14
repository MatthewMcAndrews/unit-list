unit uAnalyzeFile;

interface

uses
  Generics.Collections;

procedure WriteUnitList(ProjectPath: string);
function PasFile(Line: string): string;

implementation

uses
  SysUtils,
  uDelphiSourceFiles;

function CleanUsesItem(Item: string): string;
begin
  Result := Item.Replace('''', '').Trim;
end;

function PasFile(Line: string): string;
begin
  { possible values of <unit>

      <unit> = <unit_name>
             = <qualified_unit_name>
             = <unit_name> in '<relative_unit_Path>\<qualified_unit_name>.pas'

    possible lines ignoring whitespace variance

      uses <unit>, <...>, <unit>;
      uses <unit>, <...>, <unit>,
      uses <unit>, <...>, <unit>
      <unit>, <...>, <unit>,
      <unit>, <...>, <unit>
      <unit>, <...>, <unit>;

  }



  // Remove trailing commas e.g. <unit_name>, -> <unit_name>
  Line := Line.Trim([',']);
  { <unit_name> in '<unit_path>\<unit_name>.pas'
      -> [<unit_name>, <unit_path><unit_name>] }
  var Items := Line.Trim.Split([' in ']); // This only occurs in .dpr files

  case Length(Items) of
    1: Result := CleanUsesItem(Items[0]);
    2: Result := CleanUsesItem(Items[1]);
  else
    raise Exception.Create('Unsupported Uses Clause Entry: ' + Line);
  end;

end;

procedure WriteUnitList(ProjectPath: string);
begin
  // open project file
  var PFile: TextFile;
  Assign(PFile, ProjectPath);
  Reset(PFile);

  // add proj to unprocessed used units
  // for each unprocesed used unit
    // get used units
    // ignore processed ones
    // add unprocessed ones to unprocessed used units

  // read all uses rows
  var IsUsesLine := False;
  var PasFiles := TList<string>.Create;
  while not Eof(PFile) do begin

    var Line: string;
    Readln(PFile, Line);

    Line := Line.Trim;

    if IsUsesLine and not Line.IsEmpty then
      PasFiles.Add(PasFile(Line));

    if SameText(Line, 'uses') then
      IsUsesLine := True;

    if Line.Contains(';') then
      IsUsesLine := False;

  end;

  // write files
  for var PasFile in PasFiles do begin
    Writeln(PasFile);
  end;
end;

end.
