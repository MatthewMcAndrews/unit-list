unit uCmd;

interface

type
  ICmd = interface
    function cd: string; overload;
    function cd(arg: string): string; overload;
  end;

function NewCommandPrompt(AbsolutePath: string): ICmd;

implementation

uses
  SysUtils, IOUtils, Generics.Collections, Classes;

type
  TCmd = class(TInterfacedObject, ICmd)
    function Cd: string; overload;
    function cd(Arg: string): string; overload;
    constructor Create(WorkingDirectory: string);
  private
    FWorkingDirectory: string;
    FDrive: Char;
    function BuildPath(PathTokens: TList<string>): string;
  end;

function NewCommandPrompt(AbsolutePath: string): ICmd;
begin
  Result := TCmd.Create(AbsolutePath);
end;

{ TCmd }

function TCmd.cd: string;
begin
  Result := FWorkingDirectory;
end;

function TCmd.BuildPath(PathTokens: TList<string>): string;
begin
  Result := '';
  for var Token in PathTokens do begin
    Result := Result + Token + '\';
  end;

  Result := Result.Trim(['\']);
  Result := FDrive + ':\' + Result;
end;

function TCmd.cd(Arg: string): string;

  function GetPathTokens: TList<string>;
  begin
    var PathOnly := FWorkingDirectory.Replace(FDrive + ':\', '');
    var PathTokensArr := PathOnly.Split(['\']);

    Result := TList<string>.Create;
    for var Token in PathTokensArr do begin
      if not Token.IsEmpty then begin
        Result.Add(Token);
      end;
    end;
  end;

const
  sBack = '..';
begin
  var PathTokens := GetPathTokens;

  var ArgTokens := Arg.Split(['\']);
  for var Token in ArgTokens do begin

    if Token.IsEmpty then
      Continue;

    if SameText(Token, sBack) then begin
      if (PathTokens.Count > 0) then
        PathTokens.Delete(PathTokens.Count - 1);
    end else
      PathTokens.Add(Token);

    var Path := BuildPath(PathTokens);

    if not DirectoryExists(Path) then
      raise Exception.Create('Directory Does Not Exist: ' + Path);

  end;

  Result := BuildPath(PathTokens);

  FWorkingDirectory := Result;
end;

constructor TCmd.Create(WorkingDirectory: string);
const
  sHelp = '. Absolute Path Required.';
begin
  if TPath.IsRelativePath(WorkingDirectory) then begin
    raise Exception.Create(
      'Input Path Is Not An Absolute Path: ' + WorkingDirectory + sHelp);
  end;

  if not TPath.IsPathRooted(WorkingDirectory) then begin
    raise Exception.Create(
      'Input Path Is Not Rooted: ' + WorkingDirectory + sHelp);
  end;

  if not DirectoryExists(WorkingDirectory) then begin
    raise Exception.Create(
      'Directory Does Not Exist: ' + WorkingDirectory + sHelp);
  end;

  if not TPath.DriveExists(WorkingDirectory) then begin
    raise Exception.Create(
      'Drive Does Not Exist: ' + WorkingDirectory + sHelp);
  end;

  FWorkingDirectory := WorkingDirectory;
  FDrive := WorkingDirectory[1];
end;

end.
