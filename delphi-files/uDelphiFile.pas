unit uDelphiFile;

interface

uses
  uFile, Generics.Collections;

type
  TUsedUnit = record
    Name: string;
    RelativePath: string;
    function IsLibraryUnit: Boolean;
  end;
  IDelphiFile = interface(IFile)
    function &Uses: TList<TUsedUnit>;
    function Name: string;
  end;

  TDelphiFile = class(TFileAccess, IDelphiFile)
    function &Uses: TList<TUsedUnit>;
    function Name: string; virtual; abstract;
  private
    function GetUsesClauses: TList<string>;
    function GetUsedUnits(UsesClause: string): TList<TUsedUnit>;
  end;

function StripComments(Delphi: string): string;

implementation

uses
  SysUtils, IOUtils, RegularExpressions;

type
  DelphiTextState = (
    dtsCode, dtsInlineComment, dtsBracesComment, dtsParenComment, dtsString);
  
  TDelphiText = class
    class function StripComments(Text: string): string;
  strict private
    class var FText: string;
    class var FKeptText: string;
    class var FChrIdx: Integer;
    class var FState: DelphiTextState;
    class procedure Init(Text: string);
    class function Next: Char;
    class function Peek: Char;
    class procedure Skip;
    class procedure Keep;
    class function Eof: Boolean;
  end;

{ TDelphiFile }

function CleanUsesItem(Item: string): string;
begin
  Result := Item.Replace('''', '').Trim;
end;

function TDelphiFile.GetUsedUnits(UsesClause: string): TList<TUsedUnit>;
begin
  UsesClause := StripComments(UsesClause);

  UsesClause := UsesClause.Replace(#10, '');
  UsesClause := UsesClause.Replace(#13, '');
  var UsesItems := UsesClause.Split([',']);

  Result := TList<TUsedUnit>.Create;
  for var UsesItem in UsesItems do begin

    var Items := UsesItem.Trim.Split([' in ']);

    var UsedUnit: TUsedUnit;
    case Length(Items) of
      1: UsedUnit.Name := CleanUsesItem(Items[0]);
      2: begin // This only occurs for .dpr files.
           UsedUnit.Name := CleanUsesItem(Items[0]);
           UsedUnit.RelativePath := CleanUsesItem(Items[1]);
         end;
    else
      raise Exception.Create('Unsupported Uses Clause Entry: ' + UsesItem);
    end;

    Result.Add(UsedUnit);
  end;
end;

function TDelphiFile.GetUsesClauses: TList<string>;
const
  sUsesPattern = '[\r\n\s]uses\s([\w\s\\,''.-]*);';
begin
  Result := TList<string>.Create;

  var CleanText := TDelphiText.StripComments(Text);

  var Matches := TRegEx.Matches(CleanText, sUsesPattern);
  for var Match in Matches do begin

    if not Match.Success then
      Continue;

    var UsesClause: string;
    var NameGroup := Match.Groups[1];
    UsesClause := NameGroup.Value;

    Result.Add(UsesClause);
  end;
end;

function TDelphiFile.&Uses: TList<TUsedUnit>;
begin
  Writeln('Processing Used Units For ', Path);
  var UsesClauses := GetUsesClauses;
  Writeln('  Uses Clauses Found: ', UsesClauses.Count);
  Result := TList<TUsedUnit>.Create;
  for var UsesClause in UsesClauses do begin
    var UsedUnits := GetUsedUnits(UsesClause);
    
    for var UsedUnit in UsedUnits do
      Writeln('    ', UsedUnit.Name);
    
    Result.AddRange(UsedUnits);
  end;
end;

{ TUsedUnit }

function TUsedUnit.IsLibraryUnit: Boolean;
begin
  Result := RelativePath.IsEmpty;
end;
            
{ TDelphiText }
  
class procedure TDelphiText.Init(Text: string);
begin
  FText := Text;
  FKeptText := '';
  FChrIdx := 0;
  FState := dtsCode;
end;

class function TDelphiText.Eof: Boolean;
begin
  Result := FChrIdx = FText.Length;
end;

class procedure TDelphiText.Keep;
begin
  FKeptText := FKeptText + FText[FChrIdx];
end;

class function TDelphiText.Next: Char;
begin
  Inc(FChrIdx);
  if FChrIdx <= FText.Length then
    Result := FText[FChrIdx]
  else
    raise Exception.Create('Eof!');
end;

class function TDelphiText.Peek: Char;
begin
  if FChrIdx < FText.Length then  
    Result := FText[FChrIdx + 1]
  else
    Result := #0;
end;

class procedure TDelphiText.Skip;
begin
  Inc(FChrIdx);
end;

class function TDelphiText.StripComments(Text: string): string;
const
  sStrStart = '''';
  sStrEnd = '''';
  sInlineCommentStart = '//';
  sInlineCommentEnd = #13#10;
  sParenCommentStart = '(*';
  sParenCommentEnd = '*)';
  sBraceCommentStart = '{';
  sBraceCommentEnd = '}';
begin
  Init(Text);

  while not Eof do begin

    var Chr := Next;
    { Will be a single Char once the end of Text is reached. }
    var NextTwoChr := Chr + Peek;
  
    if FState = dtsCode then begin

      if Chr = sStrStart then begin
        FState := dtsString;   
        Keep;
      end else if NextTwoChr = sInlineCommentStart then begin
        FState := dtsInlineComment;
        { Implicitly Skip Chr}
        Skip; { Explicitly Skip NextChr }
      end else if NextTwoChr = sParenCommentStart then begin
        FState := dtsParenComment;
        { Implicitly Skip Chr}
        Skip; { Explicitly Skip NextChr }
      end else if Chr = sBraceCommentStart then begin
        FState := dtsBracesComment;
        { Implicitly Skip Chr}
      end else begin
        Keep;
      end;
      
    end else if FState = dtsString then begin
  
      if Chr = sStrEnd then begin
        FState := dtsCode;
      end;

      { Always keep string contents, including nested "comments". }
      Keep;

    end else if FState = dtsInlineComment then begin
           
      if NextTwoChr = sInlineCommentEnd then begin
        FState := dtsCode;
        { Always keep line breaks. }
        Keep;
      end else begin
        { Implicitly ignore any characters within the comment bounds. }
      end;
      
    end else if FState = dtsBracesComment then begin
    
      if Chr = sBraceCommentEnd then begin
        FState := dtsCode;      
        { Implicitly skip comment terminating character. }
      end else begin
        { Implicitly skip any characters within the comment bounds. }
      end;

    end else if FState = dtsParenComment then begin
    
      if NextTwoChr = sParenCommentEnd then begin
        FState := dtsCode;
        { Implicitly Skip Chr}
        Skip; { Explicitly Skip NextChr}
      end;
    
    end;       
  end;    

  Result := FKeptText;
end;

{ Remove Comments from a Delphi code string.
  Leave "comments" inside of strings e.g. '// not a comment'.
 }
function StripComments(Delphi: string): string;
begin
  Result := TDelphiText.StripComments(Delphi);
end;

end.
