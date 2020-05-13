unit uDelphiSourceFiles;

interface

function TryFindSourceFile(FileName: string; out FilePath: string): Boolean;

implementation

uses
  SysUtils, IOUtils,
  uDelphiEnvironmentVariables, uDelphiLibraryBrowsingPath;

function TryFindSourceFile(FileName: string; out FilePath: string): Boolean;
begin
  var BdsVal := BDS;
  var Files: TArray<string>;
  for var Path in DelphiBrowsingPaths do begin

    SearchPath := Path.Replace('$(BDS)\', BdsVal);

    try
      Files := Files + TDirectory.GetFiles(
        SearchPath,
        FileName,
        TSearchOption.soAllDirectories);
    except
      Writeln('File Path Not Found: ', SearchPath);
    end;
  end;

  if Length(Files) = 1 then
    FilePath := Files[0]
  else
    raise Exception.Create('Multiple Files Found!');
end;

end.
