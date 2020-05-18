unit uDelphiSourceFiles;

interface

function TryFindSourceFile(FileName: string; out FilePath: string): Boolean;

implementation

uses
  SysUtils, IOUtils, StrUtils,
  uDelphiLibraryBrowsingPath;

function TryFileSearch(FileMask: string; out FilePath: string): Boolean;
begin
  var Files: TArray<string>;
  var PathsToSearch := DelphiBrowsingPathsResolved;

  for var SearchPath in PathsToSearch do begin
    if DirectoryExists(SearchPath) then begin
      Files := Files + TDirectory.GetFiles(
        SearchPath,
        FileMask,
        TSearchOption.soAllDirectories);
    end else begin
      { Ignore Invalid Browsing Paths. }
    end;
  end;

  Result := False;
  if Length(Files) = 1 then begin
    Result := True;
    FilePath := Files[0];
  end else if Length(Files) > 1 then begin
    var FileNames := '';
    for var Item in Files do begin
      FileNames := FileNames + #13#10 + Item;
    end;

    Exception.Create('Multiple Files Found for ' + FileMask + ': ' + FileNames);
  end;
end;

function TryFindSourceFile(FileName: string; out FilePath: string): Boolean;
begin
  var FileMask := FileName;
  if not EndsText('.pas', FileMask) then
    FileMask := FileMask + '.pas';

  { Search for plain file name. }
  if not TryFileSearch(FileMask, FilePath) then begin

    { Search for namespaced file name.
        e.g. SysUtils.pas -> System.SysUtils.pas

      Appending just a wildcard is inadequate since it failed to differentiate
      between *StrUtils.pas -> System.StrUtils.pas, System.WideStrUtils.pas
    }
    FileMask := '*.' + FileMask;
    TryFileSearch(FileMask, FilePath);
  end;

  Result := not FilePath.IsEmpty;
end;

end.
