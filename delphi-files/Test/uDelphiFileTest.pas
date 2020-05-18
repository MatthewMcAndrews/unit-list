unit uDelphiFileTest;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TDelphiFileTest = class
  public
    [Test]
    procedure strip_full_single_line_comment;
    [Test]
    procedure strip_partial_single_line_comment;
    [Test]
    procedure dont_strip_comments_in_strings;
    [Test]
    procedure strip_full_single_line_braces_comment;
    [Test]
    procedure strip_partial_single_line_braces_comment;
    [Test]
    procedure strip_full_single_line_paren_comment;
    [Test]
    procedure strip_partial_single_line_paren_comment;
    [Test]
    [TestCase('JustAComment', ',{ first line '#13#10'second line }')]
    [TestCase('CommentSurroundedWithCode',
      'Code;  Code;,Code; { first line '#13#10'second line } Code;')]
    [TestCase('CommentContainsOtherCommentChars',
      'Code;  Code;,Code; { first line '#13#10'second line *)(* (**) { } Code;')]
    procedure strip_multiline_braces_comment(Expected, Input: string);
    [Test]
    [TestCase('JustAComment', ',(* first line '#13#10'second line *)')]
    [TestCase('CommentSurroundedWithCode',
      'Code;  Code;,Code; (* first line '#13#10'second line *) Code;')]
    [TestCase('CommentContainsOtherCommentChars',
      'Code;  Code;,Code; (* first line '#13#10'second line {} ( * * ) }{ {} *) Code;')]
    procedure strip_multiline_paren_comment(Expected, Input: string);
    [Test]
    [TestCase('', '''valid//valid'',''valid//valid''')]
    [TestCase('', '''valid{valid}'',''valid{valid}''')]
    [TestCase('', '''valid(*valid*)'',''valid(*valid*)''')]
    procedure leave_strings_with_nested_comments(Expected, Input: string);
  end;

implementation

uses
  uDelphiFile;

{ TDelphiFileTest }

procedure TDelphiFileTest.dont_strip_comments_in_strings;
begin
  var Text := '''//not a comment''';
  Assert.AreEqual(Text, StripComments(Text));
end;

procedure TDelphiFileTest.leave_strings_with_nested_comments(
  Expected, Input: string);
begin
  Assert.AreEqual(Expected, StripComments(Input));
end;

procedure TDelphiFileTest.strip_full_single_line_braces_comment;
begin
  Assert.AreEqual('', StripComments('{ just a single line comment. }'));
end;

procedure TDelphiFileTest.strip_full_single_line_comment;
begin
  Assert.AreEqual('', StripComments('// just a single line comment.'));
end;

procedure TDelphiFileTest.strip_partial_single_line_braces_comment;
begin
  Assert.AreEqual('Not a Comment; ', StripComments('Not a Comment; { just a single line comment.}'));
end;

procedure TDelphiFileTest.strip_partial_single_line_comment;
begin
  Assert.AreEqual('Not a Comment; ',
    StripComments('Not a Comment; // just a single line comment.'));
end;

procedure TDelphiFileTest.strip_full_single_line_paren_comment;
begin
  Assert.AreEqual('', StripComments('(* just a single line comment. *)'));
end;

procedure TDelphiFileTest.strip_multiline_braces_comment(Expected, Input: string);
begin
  Assert.AreEqual(Expected, StripComments(Input));
end;

procedure TDelphiFileTest.strip_multiline_paren_comment(Expected,
  Input: string);
begin
  Assert.AreEqual(Expected, StripComments(Input));
end;

procedure TDelphiFileTest.strip_partial_single_line_paren_comment;
begin
  Assert.AreEqual('Not a Comment; ', StripComments('Not a Comment; (* just a single line comment. *)'));
end;

initialization
  TDUnitX.RegisterTestFixture(TDelphiFileTest);

end.
