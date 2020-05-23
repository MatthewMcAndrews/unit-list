program pUnitList;

uses
  SysUtils,
  uUnitList in 'uUnitList.pas',
  uDelphiEnvironmentVariables in 'delphi-environment-variables\uDelphiEnvironmentVariables.pas',
  uRegistry in 'windows-registry-access\uRegistry.pas',
  uDelphiSourceFiles in 'delphi-source-files\uDelphiSourceFiles.pas',
  uDelphiWindowsRegistry in 'delphi-windows-registry\uDelphiWindowsRegistry.pas',
  uWindowsRegistry in 'windows-registry-access\uWindowsRegistry.pas',
  uRegistry.RootKey in 'windows-registry-access\uRegistry.RootKey.pas',
  uDelphiLibraryBrowsingPath in 'delphi-source-files\uDelphiLibraryBrowsingPath.pas',
  uDpr in 'delphi-files\uDpr.pas',
  PathAbsRel in 'cmd\PathAbsRel.pas',
  uDelphiFile in 'delphi-files\uDelphiFile.pas',
  uPas in 'delphi-files\uPas.pas',
  uFile in 'delphi.file.lib\uFile.pas';

procedure PrintHelp;
begin
  var FullAppPath := ParamStr(0);
  var AppName := ExtractFileName(FullAppPath).Replace(ExtractFileExt(FullAppPath), '');
  Writeln('Usages:');
  Writeln('  ', AppName, ' -h');
  Writeln('  ', AppName, ' -help');
  Writeln('  ', AppName, ' -f <delphi project file name (.dpr)>');
  Writeln('  ', AppName, ' -file <delphi project file name (.dpr)>');
  Writeln('Options:');
  Writeln('  -h, -help: Display this help message.');
  Writeln('  -f, -filename: The full file path of the delphi project file to analyze.')
end;

begin
  try            
    var ProjectPath: string;
    
    if FindCmdLineSwitch('h')
    or FindCmdLineSwitch('help')
    then begin
      PrintHelp;
    end else if FindCmdLineSwitch('f', ProjectPath)
    or FindCmdLineSwitch('file', ProjectPath) then begin
      WriteUnitList(ProjectPath);
    end else begin
      Writeln('Unsupported Command Line Usage.');
      PrintHelp;
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Readln;
end.
