unit PathAbsRel;

interface

{ e.g. RelToAbs('..\Shared\somefile.pas', 'C:\Projects\Project1\')
    -> 'C:\Projects\Shared\somefile.pas' }
function RelToAbs(const RelPath, BasePath: string): string;

{ To go the other way, use SysUtils.ExtractRelativePath
    e.g. ExtractRelativePath('c:\foo\', 'c:\bar\')
      -> '..\bar\'

  Note that without a terminating backslash, the last item is considered a file
    e.g. ExtractRelativePath('c:\foo\', 'c:\bar')
      -> '..'
}

implementation

uses
  SysUtils, Windows, ShLwApi;

function RelToAbs(const RelPath, BasePath: string): string;
var
  Dst: array[0..MAX_PATH-1] of char;
begin
  PathCanonicalize(@Dst[0], PChar(IncludeTrailingBackslash(BasePath) + RelPath));
  Result := Dst;
end;

end.
