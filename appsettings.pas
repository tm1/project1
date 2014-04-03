unit AppSettings;

interface

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

uses
  Classes, SysUtils, Forms, IniFiles{, Constants};

type

  { TConfigurations }

  TConfigurations = class(TObject)
  private
    function GetResourcesPath: string;
  public
    {other settings as fields here}
    ConfigFilePath: string;
    ResourcesPath: string;
    constructor Create;
    destructor Destroy; override;
    procedure ReadFromFile(Sender: TObject);
    procedure Save(Sender: TObject);
  end;


var
  vConfigurations: TConfigurations;

implementation

{$ifdef Win32}
uses
  Windows;
{$endif}
{$ifdef Darwin}
uses
  MacOSAll;
{$endif}

const
  DefaultDirectory = '/usr/share/project1/';
  BundleResourcesDirectory = '/Contents/Resources/';

  SectionGeneral = 'General';
  SectionUnix = 'UNIX';

  IdentResourcesPath = 'ResourcesPath';

{ TConfigurations }

constructor TConfigurations.Create;
begin
{$ifdef win32}
  ConfigFilePath := ExtractFilePath(Application.EXEName) + 'project1.ini';
{$endif}
{$ifdef Unix}
  ConfigFilePath := GetAppConfigFile(False) + '.conf';
{$endif}
  ResourcesPath := GetResourcesPath();
  ReadFromFile(nil);
end;

destructor TConfigurations.Destroy;
begin
  Save(nil);
  inherited Destroy;
end;

procedure TConfigurations.Save(Sender: TObject);
var
  MyFile: TIniFile;
begin
  MyFile := TIniFile.Create(ConfigFilePath);
  try
    MyFile.WriteString(SectionUnix, IdentResourcesPath, ResourcesPath);
  finally
    MyFile.Free;
  end;
end;

procedure TConfigurations.ReadFromFile(Sender: TObject);
var
  MyFile: TIniFile;
begin
  MyFile := TIniFile.Create(ConfigFilePath);
  try
    // Here you can read other information from the config file

{$ifdef Win32}
    ResourcesPath := MyFile.ReadString(SectionUnix, IdentResourcesPath, ExtractFilePath(Application.EXEName));
{$else}
 {$ifndef darwin}
    ResourcesPath := MyFile.ReadString(SectionUnix, IdentResourcesPath, DefaultDirectory);
 {$endif}
{$endif}
  finally
    MyFile.Free;
  end;
end;

function TConfigurations.GetResourcesPath(): string;
{$ifdef Darwin}
var
  pathRef: CFURLRef;
  pathCFStr: CFStringRef;
  pathStr: shortstring;
{$endif}
begin
{$ifdef UNIX}
{$ifdef Darwin}
  pathRef := CFBundleCopyBundleURL(CFBundleGetMainBundle());
  pathCFStr := CFURLCopyFileSystemPath(pathRef, kCFURLPOSIXPathStyle);
  CFStringGetPascalString(pathCFStr, @pathStr, 255, CFStringGetSystemEncoding());
  CFRelease(pathRef);
  CFRelease(pathCFStr);

  Result := pathStr + BundleResourcesDirectory;
{$else}
  Result := DefaultDirectory;
{$endif}
{$endif}

{$ifdef Windows}
  Result := ExtractFilePath(Application.EXEName);
{$endif}
end;

initialization

  vConfigurations := TConfigurations.Create;

finalization

  FreeAndNil(vConfigurations);

end.

