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
  DefaultShareDir: string;
  DefaultConfigFilePath: string;
  DefaultResourcesDir: string;

implementation

// {$ifdef Win32}
// uses
//   Windows;
// {$endif}
{$ifdef Darwin}
uses
  MacOSAll;
{$endif}

const
  // DefaultDirectory = '/usr/share/project1/';
{$ifdef Unix}
  DefaultDirectoryPrefix = '/usr/share/';
    {$ifdef Darwin}
  BundleResourcesDirectory = '/Contents/Resources/';
    {$endif}
{$endif}
  ResourcesSubDirectory = 'Resources';

  SectionGeneral = 'General';
{$ifdef Win32}
  SectionWindows = 'Windows';
{$else}
  {$ifdef Unix}
    {$ifdef Darwin}
  SectionDarwin = 'Darwin';
    {$else}
  SectionUnix = 'Unix';
    {$endif}
  {$else}
  SectionOtherOS = 'OtherOS';
  {$endif}
{$endif}

  IdentResourcesPath = 'ResourcesPath';

{ TConfigurations }

constructor TConfigurations.Create;
begin
  ConfigFilePath := DefaultConfigFilePath;
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
  try
    if not DirectoryExists(ExtractFilePath(ConfigFilePath)) then
      if not CreateDir(ExtractFilePath(ConfigFilePath)) then exit;
  except
    // CreateDir problem
    exit;
  end;
  MyFile := TIniFile.Create(ConfigFilePath);
  try
{$ifdef Win32}
    MyFile.WriteString(SectionWindows, IdentResourcesPath, ResourcesPath);
{$else}
  {$ifdef Unix}
    {$ifdef Darwin}
    MyFile.WriteString(SectionDarwin, IdentResourcesPath, ResourcesPath);
    {$else}
    MyFile.WriteString(SectionUnix, IdentResourcesPath, ResourcesPath);
    {$endif}
  {$else}
    MyFile.WriteString(SectionOtherOS, IdentResourcesPath, ResourcesPath);
  {$endif}
{$endif}
  finally
    MyFile.Free;
  end;
  try
    if not DirectoryExists(ResourcesPath) then
      if not CreateDir(ResourcesPath) then exit;
  except
    // CreateDir problem
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
    ResourcesPath := MyFile.ReadString(SectionWindows, IdentResourcesPath, DefaultResourcesDir);
{$else}
  {$ifdef Unix}
    {$ifdef Darwin}
    ResourcesPath := MyFile.ReadString(SectionDarwin, IdentResourcesPath, DefaultResourcesDir);
    {$else}
    ResourcesPath := MyFile.ReadString(SectionUnix, IdentResourcesPath, DefaultResourcesDir);
    {$endif}
  {$else}
    ResourcesPath := MyFile.ReadString(SectionOtherOS, IdentResourcesPath, DefaultResourcesDir);
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
{$ifdef Win32}
  Result := DefaultResourcesDir;
{$else}
  {$ifdef Unix}
    {$ifdef Darwin}
  pathRef := CFBundleCopyBundleURL(CFBundleGetMainBundle());
  pathCFStr := CFURLCopyFileSystemPath(pathRef, kCFURLPOSIXPathStyle);
  CFStringGetPascalString(pathCFStr, @pathStr, 255, CFStringGetSystemEncoding());
  CFRelease(pathRef);
  CFRelease(pathCFStr);

  Result := pathStr + BundleResourcesDirectory;
    {$else}
  Result := DefaultResourcesDir;
    {$endif}
  {$else}
  Result := DefaultResourcesDir;
  {$endif}
{$endif}
end;

initialization

  DefaultConfigFilePath := GetAppConfigFile(False);
{$ifdef Win32}
  // DefaultShareDir = 'C:\Users\username\AppData\Local\project1\';
  DefaultShareDir := GetAppConfigDir(False);
{$else}
  // DefaultShareDir = '/usr/share/project1/';
  DefaultShareDir := DefaultDirectoryPrefix + ApplicationName + DirectorySeparator;
{$endif}
  // DefaultResourcesDir = 'C:\Users\username\AppData\Local\project1\Resources\';
  // DefaultResourcesDir = '/usr/share/project1/Resources/';
  DefaultResourcesDir := DefaultShareDir + ResourcesSubDirectory + DirectorySeparator;
  vConfigurations := TConfigurations.Create;

finalization

  FreeAndNil(vConfigurations);

end.

