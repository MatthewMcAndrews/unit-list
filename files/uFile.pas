unit uFile;

interface

type
  IFile = interface
    function Drive: string;
    function Path: string;
    function FileName: string;
    function Ext: string;
    function Text: string;
  end;

function NewFile(FilePath: string): IFile;

type
  TFileAccess = class(TInterfacedObject, IFile)
    function Drive: string;
    function Path: string;
    function Ext: string;
    function FileName: string;
    function Path_Relative: string;
    function Path_Absolute: string;
    function Text: string;
    function Lines: TArray<string>;
    constructor Create(FileName: string);
  private
    FFullFilePath: string;
  end;

//------------------------------------------------------------------------------

function ExtractFileNameOnly(FileName: string): string;

implementation

uses
  SysUtils, IOUtils;

function NewFile(FilePath: string): IFile;
begin
  Result := TFileAccess.Create(FilePath);
end;

{ TFileAccess }

function TFileAccess.Text: string;
begin
  Result := TFile.ReadAllText(FFullFilePath);
end;

function TFileAccess.Lines: TArray<string>;
begin
  Result := TFile.ReadAllLines(FFullFilePath);
end;

constructor TFileAccess.Create(FileName: string);
begin
  if TFile.Exists(FileName) then
    FFullFilePath := FileName
  else
    raise Exception.Create('TFileAccess: File Does Not Exist: ' + FileName);
end;

function TFileAccess.Drive: string;
begin
  Result := ExtractFileDrive(FFullFilePath);
end;

function TFileAccess.Ext: string;
begin
  Result := ExtractFileExt(FFullFilePath);
end;

function TFileAccess.FileName: string;
begin
  Result := ExtractFileName(FFullFilePath);
end;

function TFileAccess.Path_Absolute: string;
begin
  Result := FFullFilePath;
end;

function TFileAccess.Path_Relative: string;
begin
  Result := FFullFilePath;
end;

function TFileAccess.Path: string;
begin
  Result := FFullFilePath;
end;

//------------------------------------------------------------------------------

function ExtractFileNameOnly(FileName: string): string;
begin
  Result := ExtractFileName(ChangeFileExt(FileName, ''));
end;

end.
