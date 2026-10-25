# YunehSSTool - independently written local diagnostics
# No external tools, telemetry, credential collection, or remote execution.
# Read-only local checks require the computer owner's permission.
param([string]$ScanId = '')
$ErrorActionPreference = 'Stop'
try {
 Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
 Add-Type -AssemblyName PresentationCore -ErrorAction Stop
 Add-Type -AssemblyName WindowsBase -ErrorAction Stop
} catch {
 Write-Host ("YunehSSTool could not load the Windows interface: " + $_.Exception.Message) -ForegroundColor Red
 Write-Host 'This PC may restrict PowerShell or Windows desktop components. Ask the PC owner or administrator.' -ForegroundColor Yellow
 exit 1
}

# Embedded operator-supplied MacroDetector; no network access or automatic uploads.
$script:MacroDetectorGzipBase64 = @'
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
'@
function Invoke-YunehMacroDetector {
 try {
  $compressed=[Convert]::FromBase64String(($script:MacroDetectorGzipBase64 -replace '\s',''))
  $ms=New-Object IO.MemoryStream(,$compressed)
  $gz=New-Object IO.Compression.GzipStream($ms,[IO.Compression.CompressionMode]::Decompress)
  $sr=New-Object IO.StreamReader($gz,[Text.Encoding]::UTF8)
  try { $source=$sr.ReadToEnd() } finally { $sr.Dispose(); $gz.Dispose(); $ms.Dispose() }
  & ([scriptblock]::Create($source))
 } catch { Write-Host ("Macro Detector error: " + $_.Exception.Message) -ForegroundColor Red }
}

$script:tools = @()
$local = @(
 @('Minecraft mods','Minecraft mods folder','mods'),
 @('Minecraft versions','Installed versions','versions'),
 @('Minecraft logs','Recent log filenames','logs'),
 @('Crash reports','Recent crash report filenames','crashes'),
 @('Resource packs','Resource pack filenames','packs'),
 @('Shader packs','Shader pack filenames','shaders'),
 @('Minecraft configs','Config file names','config'),
 @('Minecraft processes','Running Minecraft and launcher processes','minecraft'),
 @('Java processes','Running Java processes','java'),
 @('Macro processes','Common macro app process names','macro'),
 @('Peripheral utilities','Mouse and keyboard utility processes','peripheral'),
 @('All processes','Running process names and IDs','processes'),
 @('Startup entries','Startup entry names','startup'),
 @('Scheduled tasks','Task names and states','tasks'),
 @('System summary','Windows OS and last boot','system'),
 @('Recent downloads','Recent filenames only','downloads')
)
foreach($a in $local) {
 $script:tools += [pscustomobject]@{Category='Local checks'; Name=$a[0]; Description=$a[1]; Url=$a[2]; Kind='Local'}
}
# Dedicated staff-facing shortcuts. These are indicators, never proof of cheating.
$finder = @(
 @('Minecraft Mod Scanner','Lists installed Minecraft mods','mods'),
 @('Client / Launcher Finder','Shows running Minecraft clients and launchers','minecraft'),
 @('Macro Detector - Deep Scan','Mouse software, macro configurations and recent activity','macrodeep'),
 @('Auto Clicker Detector','Checks running autoclicker apps and selected local filenames','autoclicker'),
 @('Deleted Files - Last 10 Minutes','Shows recently recycled files with their deletion time; not permanently deleted files','recentdeleted'),
 @('Mouse & Keyboard Macros','Detailed macro configuration and activity scan','macrodeep'),
 @('JAR File Review','Finds JAR filenames in Minecraft and Downloads for manual review','jars'),
 @('Minecraft Log Review','Lists recent Minecraft log filenames','logs'),
 @('Version Review','Lists installed Minecraft versions','versions'),
 @('Java Process Check','Shows running Java processes','java'),
 @('Running Process Review','Shows running process names and IDs','processes'),
 @('Recent Downloads Review','Lists recent download filenames','downloads'),
 @('Startup Review','Lists Windows startup entry names','startup'),
 @('Scheduled Task Review','Lists scheduled tasks and states','tasks'),
 @('Crash Report Review','Lists recent Minecraft crash reports','crashes'),
 @('Minecraft Config Review','Lists Minecraft configuration files','config')
)
$script:tools += [pscustomobject]@{Category='Servers - Last 2 Weeks'; Name='Minecraft Server History'; Description='Checks connection messages in Minecraft logs from the last 14 days'; Url='serverhistory'; Kind='Local'}
foreach($a in $finder) {
 $script:tools += [pscustomobject]@{Category='Yuneh Cheat finder'; Name=$a[0]; Description=$a[1]; Url=$a[2]; Kind='Local'}
}

$extra = @(
 @('Minecraft','Launcher installations','Detects common launcher folders (names only)','launchers'),
 @('Minecraft','Mod metadata review','Reads mod IDs from fabric.mod.json in local JARs','metadata'),
 @('Minecraft','Mod SHA256 fingerprints','Computes local mod hashes for comparison','hashes'),
 @('Minecraft','Game directory inventory','Lists Minecraft folders and sizes','inventory'),
 @('Minecraft','Client filename indicators','Highlights known client names in local mods; verify manually','indicators'),
 @('Windows','Prefetch file inventory','Lists Windows Prefetch filenames when accessible','prefetch'),
 @('Windows','Windows recent shortcuts','Lists recent shortcut filenames','recent'),
 @('Windows','Java runtime inventory','Lists installed Java commands and versions','javaruntime'),
 @('Windows','Unsigned running executables','Checks signatures of accessible running executable paths','signatures'),
 @('Windows','Running services','Lists service names and states','services'),
 @('Windows','USB device names','Lists connected USB device names','usb'),
 @('Windows','Macro script filenames','Finds AHK and AutoIt scripts in selected folders','scripts'),
 @('Yuneh Cheat finder','Mod Metadata Analyzer','Shows Fabric mod identifiers where available','metadata'),
 @('Yuneh Cheat finder','Known Client Name Review','Filename-based indicators, not proof','indicators'),
 @('Yuneh Cheat finder','Macro Script Finder','Checks script filenames, not their content','scripts'),
 @('Yuneh Cheat finder','Launcher Folder Finder','Lists common launcher folders','launchers'),
 @('Yuneh Cheat finder','Mod Hash Viewer','Lists mod SHA256 hashes','hashes'),
 @('Yuneh Cheat finder','Prefetch Viewer','Lists available Prefetch filenames','prefetch')
)
foreach($a in $extra) {
 $script:tools += [pscustomobject]@{Category=$a[0]; Name=$a[1]; Description=$a[2]; Url=$a[3]; Kind='Local'}
}
function Get-YunehModFolders {
 $roots = @(
  (Join-Path $env:APPDATA '.minecraft'),
  (Join-Path $env:USERPROFILE '.lunarclient'),
  (Join-Path $env:APPDATA '.lunarclient'),
  (Join-Path $env:APPDATA 'PrismLauncher\\instances'),
  (Join-Path $env:APPDATA 'MultiMC\\instances'),
  (Join-Path $env:APPDATA 'ATLauncher\\instances'),
  (Join-Path $env:APPDATA 'ModrinthApp\\profiles'),
  (Join-Path $env:APPDATA 'com.modrinth.theseus\\profiles'),
  (Join-Path $env:APPDATA 'Feather Client'),
  (Join-Path $env:APPDATA 'Badlion Client'),
  (Join-Path $env:USERPROFILE 'curseforge\\minecraft\\Instances')
 )
 $found = @{}
 foreach($root in $roots) {
  if(-not (Test-Path -LiteralPath $root -PathType Container)){continue}
  $candidates = @((Join-Path $root 'mods'),(Join-Path $root '.minecraft\\mods'),(Join-Path $root 'minecraft\\mods'))
  # Inspect instance directories only one level deep; do not scan the entire drive.
  foreach($sub in @(Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue | Select-Object -First 70)) {
   $candidates += (Join-Path $sub.FullName 'mods')
   $candidates += (Join-Path $sub.FullName '.minecraft\\mods')
   $candidates += (Join-Path $sub.FullName 'minecraft\\mods')
  }
  foreach($folder in $candidates) {
   if((Test-Path -LiteralPath $folder -PathType Container) -and -not $found.ContainsKey($folder)){$found[$folder]=$true}
  }
 }
 return @($found.Keys | Sort-Object)
}
function Get-YunehModFiles {
 $files = @()
 foreach($folder in @(Get-YunehModFolders)) {
  $files += @(Get-ChildItem -LiteralPath $folder -File -ErrorAction SilentlyContinue |
   Where-Object {$_.Extension -in @('.jar','.zip')} | Select-Object -First 200)
 }
 return @($files | Sort-Object FullName -Unique)
}

# Optional third-party executable supplied by the operator. Never downloaded or run automatically.
# Its source and safety have not been independently verified.
$script:tools += [pscustomobject]@{
 Category='Yuneh Cheat finder'; Name='Client Checker - External Utility';
 Description='Choose the provided MeowClientFucker.exe and review before running';
 Url='external-client-checker'; Kind='External executable'
}

function Scan-Local([string]$id) {
 $output = New-Object System.Collections.Generic.List[string]
 $base = Join-Path $env:APPDATA '.minecraft'
 switch($id) {
  'serverhistory' {
   $output.Add('==========================================================================')
   $output.Add('  YUNEH SS TOOL  |  LAST PLAYED MINECRAFT SERVERS')
   $output.Add('  Local logs only  |  14-day rolling window  |  Read-only')`n   $output.Add(('  Scan started: {0:dd/MM/yyyy HH:mm:ss}' -f (Get-Date)))
   $output.Add('==========================================================================')
   $cutoff = (Get-Date).AddDays(-14)
   $roots = @(
    (Join-Path $env:APPDATA '.minecraft'),
    (Join-Path $env:USERPROFILE '.lunarclient'),
    (Join-Path $env:APPDATA '.lunarclient'),
    (Join-Path $env:APPDATA '.feather'),
    (Join-Path $env:APPDATA 'Feather Client'),
    (Join-Path $env:APPDATA 'Badlion Client'),
    (Join-Path $env:APPDATA 'PrismLauncher\instances'),
    (Join-Path $env:APPDATA 'MultiMC\instances'),
    (Join-Path $env:APPDATA 'ATLauncher\instances'),
    (Join-Path $env:APPDATA 'ModrinthApp\profiles'),
    (Join-Path $env:APPDATA 'com.modrinth.theseus\profiles'),
    (Join-Path $env:USERPROFILE 'curseforge\minecraft\Instances')
   )
   $logFiles = New-Object System.Collections.Generic.List[object]`n   $scanStarted = Get-Date
   $seen = @{}
   foreach($root in $roots) {
    if(-not (Test-Path -LiteralPath $root -PathType Container)){continue}
    # Common launcher layouts; avoid arbitrary full-drive scanning.
    $dirs = @($root)
    $dirs += @(Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue | Select-Object -First 100 | ForEach-Object FullName)
    foreach($dir in $dirs) {
     foreach($folder in @((Join-Path $dir 'logs'),(Join-Path $dir '.minecraft\logs'),(Join-Path $dir 'minecraft\logs'),(Join-Path $dir 'game\logs'))) {
      if(-not (Test-Path -LiteralPath $folder -PathType Container)){continue}
      foreach($file in @(Get-ChildItem -LiteralPath $folder -File -ErrorAction SilentlyContinue | Where-Object {
       ($_.LastWriteTime -ge $cutoff -or $_.Name -match '^\d{4}-\d{2}-\d{2}') -and $_.Name -match '(?i)\.(log|log\.gz|txt)$'
      } | Select-Object -First 60)) {
       if(-not $seen.ContainsKey($file.FullName)){$seen[$file.FullName]=$true;$logFiles.Add($file)}
      }
     }
    }
   }
   $results = New-Object System.Collections.Generic.List[object]
   foreach($file in @($logFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 200)) {
    if($file.Length -gt 20000000){continue}
    try {
     $stream=[IO.File]::OpenRead($file.FullName)
     try {
      if($file.Name -match '\.gz$') {
       $gz=New-Object IO.Compression.GzipStream($stream,[IO.Compression.CompressionMode]::Decompress)
       $reader=New-Object IO.StreamReader($gz)
      } else {$reader=New-Object IO.StreamReader($stream)}
      try {
       $lineNumber=0
       while(-not $reader.EndOfStream -and $lineNumber -lt 150000) {
        $line=$reader.ReadLine(); $lineNumber++
        # Only connection events, not arbitrary URLs, server lists or chat text.
        if($line -notmatch '(?i)\b(connecting to|joining server|connected to server|multiplayer\.connect|joining multiplayer)\b'){continue}
        if($line -match '(?i)(authserver\.mojang\.com|sessionserver\.mojang\.com)'){continue}
        $detail=$line -replace '(?i)^.*?\b(connecting to|joining server|connected to server|multiplayer\.connect|joining multiplayer)\b\s*[:=-]?\s*',''
        $server='Not recorded'
        if($detail -match '(?i)(?<![a-z0-9_.-])((?:[a-z0-9-]+\.)+[a-z]{2,}|(?:\d{1,3}\.){3}\d{1,3})(?::\d{1,5})?(?![a-z0-9_.-])'){$server=$Matches[0]}
        $stamp=$null; $quality='Unknown'
        if($line -match '(\d{4}-\d{2}-\d{2})[ T](\d{2}:\d{2}:\d{2})') {
         $parsed=[datetime]::MinValue
         if([datetime]::TryParseExact(($Matches[1]+' '+$Matches[2]),'yyyy-MM-dd HH:mm:ss',[Globalization.CultureInfo]::InvariantCulture,[Globalization.DateTimeStyles]::None,[ref]$parsed)){$stamp=$parsed;$quality='Log timestamp'}
        } elseif($line -match '^\[(\d{2}:\d{2}:\d{2})(?:\.\d+)?\]') {
         $clock=$Matches[1]
         # Rotated Minecraft log filenames often contain a date: 2026-10-24-1.log.gz.
         if($file.Name -match '^(\d{4}-\d{2}-\d{2})(?:-|\.)') {
          $datePart=$Matches[1];$parsed=[datetime]::MinValue
          if([datetime]::TryParseExact(($datePart+' '+$clock),'yyyy-MM-dd HH:mm:ss',[Globalization.CultureInfo]::InvariantCulture,[Globalization.DateTimeStyles]::None,[ref]$parsed)){$stamp=$parsed;$quality='Filename date + log time'}
         } else {$quality='Time only: '+$clock}
        }
        if($stamp -and ($stamp -lt $cutoff -or $stamp -gt $scanStarted.AddMinutes(2))){continue}
        if($server -eq 'Not recorded'){continue}`n        $results.Add([pscustomobject]@{Stamp=$stamp;Server=$server;Quality=$quality;Source=$file.Name;Path=$file.FullName})
        if($results.Count -ge 500){break}
       }
      } finally {$reader.Dispose()}
     } finally {$stream.Dispose()}
    } catch {$output.Add('Unreadable log: '+$file.Name)}
    if($results.Count -ge 500){break}
   }
   $datedCount = @($results | Where-Object { $null -ne $_.Stamp }).Count
   $undatedCount = $results.Count - $datedCount
   $output.Add(('Log files inspected: {0}  |  Confirmed last-14-day events: {1}  |  Unverified dates: {2}' -f $logFiles.Count,$datedCount,$undatedCount))
   $output.Add('')
   $output.Add(('{0,-12} {1,-9} {2,-29} {3}' -f 'DATE','TIME','SERVER IP / ADDRESS','SOURCE'))
   $output.Add(('=' * 85))
   foreach($item in @($results | Where-Object { $null -ne $_.Stamp } | Sort-Object -Property @{Expression='Stamp';Descending=$true} | Select-Object -First 200)) {
    $date='Unknown';$time='Unknown'
    if($item.Stamp){$date=$item.Stamp.ToString('dd/MM/yyyy');$time=$item.Stamp.ToString('HH:mm:ss')}
    elseif($item.Quality -like 'Time only:*'){$time=$item.Quality.Substring(11)}
    $output.Add(('{0,-12} {1,-9} {2,-29} {3}' -f $date,$time,$item.Server,$item.Source))
    if($item.Quality -ne 'Log timestamp'){$output.Add('  Timestamp basis: '+$item.Quality)}
   }
   if($datedCount -eq 0){$output.Add('No date-confirmed Minecraft server connections found for the last 14 days.')}`n   if($undatedCount -gt 0){`n    $output.Add('')`n    $output.Add(('UNVERIFIED: {0} log event(s) had no reliable date and are excluded from the 14-day table.' -f $undatedCount))`n    foreach($item in @($results | Where-Object { $null -eq $_.Stamp } | Select-Object -First 10)){`n     $output.Add(('  {0}  |  {1}  |  {2}' -f $item.Server,$item.Quality,$item.Source))`n    }`n   }
   $output.Add('')
   $output.Add('NOTE: This is NOT a complete history. Missing/rotated logs and launchers')
   $output.Add('may omit connections. Entries without a confirmed date are marked Unknown,')
   $output.Add('and are excluded from confirmed last-14-day results.')
   $output.Add('All results remain on this computer; nothing is uploaded.')
   break
  }
  'recentdeleted' {
   $output.Add('RECYCLE BIN - ITEMS DELETED IN THE LAST 10 MINUTES')
   $output.Add('Only files still in the Recycle Bin are visible. Permanent deletions, emptied items and many app deletions cannot be shown.')
   $output.Add('Results are not proof of cheating or concealment.')
   $output.Add('')
   $cutoff = (Get-Date).AddMinutes(-10)
   $count = 0
   $seen = @{}
   $sid = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
   foreach($drive in @(Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' -ErrorAction SilentlyContinue)) {
    $root = Join-Path ($drive.DeviceID + '\') ('$Recycle.Bin\' + $sid)
    if(-not (Test-Path -LiteralPath $root)){ continue }
    foreach($entry in @(Get-ChildItem -LiteralPath $root -Filter '$I*' -Force -File -ErrorAction SilentlyContinue)) {
     try {
      $bytes = [IO.File]::ReadAllBytes($entry.FullName)
      if($bytes.Length -lt 24){continue}
      $version = [BitConverter]::ToInt64($bytes,0)
      $deleted = [DateTime]::FromFileTimeUtc([BitConverter]::ToInt64($bytes,16)).ToLocalTime()
      if($deleted -lt $cutoff -or $deleted -gt (Get-Date).AddMinutes(1)){continue}
      $offset = if($version -eq 2){28}else{24}
      if($bytes.Length -le $offset){continue}
      $path = [Text.Encoding]::Unicode.GetString($bytes,$offset,$bytes.Length-$offset).Split([char]0)[0]
      if([string]::IsNullOrWhiteSpace($path)){ $path='(original path unavailable)' }
      $key = $entry.FullName
      if(-not $seen.ContainsKey($key)){
       $seen[$key]=$true
       $output.Add(('{0:yyyy-MM-dd HH:mm:ss}  {1}' -f $deleted,$path))
       $count++
      }
     } catch { continue }
    }
   }
   if($count -eq 0){$output.Add('No matching Recycle Bin records found (or access was restricted).')}
   $output.Add('')
   $output.Add("Found $count recently recycled item(s).")
   break
  }
  'autoclicker' {
   $output.Add('AUTO CLICKER DETECTOR - manual review only')
   $output.Add('A matching name does not prove the app was used in Minecraft.')
   $output.Add('')
   $pattern = '(?i)auto.?click|op.?auto.?click|gs.?auto.?click|speed.?auto.?click|free.?auto.?click|tiny.?task|auto.?hotkey|autoit|macro.?recorder|pulover|x.?mouse.?button'
   $output.Add('--- Running processes (name matches) ---')
   $matches = @(Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match $pattern } | Sort-Object ProcessName)
   if($matches.Count -eq 0) { $output.Add('No matching running process names found.') }
   foreach($proc in $matches) { $output.Add("$($proc.ProcessName)  PID $($proc.Id)") }
   $output.Add('')
   $output.Add('--- Relevant filenames (Desktop and Downloads; first 75) ---')
   $folders = @((Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'Downloads'))
   $fileCount = 0
   foreach($folder in $folders) {
    if(-not (Test-Path -LiteralPath $folder)) { continue }
    Get-ChildItem -LiteralPath $folder -File -ErrorAction SilentlyContinue | Where-Object {
     $_.Name -match $pattern -or $_.Extension -in @('.ahk','.au3')
    } | Select-Object -First (75 - $fileCount) | ForEach-Object {
     $output.Add("$($_.Name)  [$folder]")
     $fileCount++
    }
    if($fileCount -ge 75) { break }
   }
   if($fileCount -eq 0) { $output.Add('No matching filenames found in these folders.') }
   $output.Add('')
   $output.Add('This is not a behavioural click-rate test and cannot rule out an autoclicker.')
   break
  }


  'launchers' {
   $paths = @(
    (Join-Path $env:APPDATA '.minecraft'),(Join-Path $env:APPDATA 'PrismLauncher'),
    (Join-Path $env:APPDATA 'MultiMC'),(Join-Path $env:APPDATA 'lunarclient'),
    (Join-Path $env:APPDATA '.feather'),(Join-Path $env:LOCALAPPDATA 'ModrinthApp'),
    (Join-Path $env:LOCALAPPDATA 'Programs\Modrinth App'),(Join-Path $env:APPDATA 'ATLauncher'),
    (Join-Path $env:APPDATA 'gdlauncher_next'),(Join-Path $env:APPDATA '.tlauncher')
   )
   foreach($p in $paths){ if(Test-Path -LiteralPath $p){$output.Add("Found folder: $p")} }
   break
  }
  'metadata' {
   Add-Type -AssemblyName System.IO.Compression
   $files = @(Get-YunehModFiles)
   $output.Add("Mod files found across launcher folders: $($files.Count)")
   foreach($file in @($files | Select-Object -First 250)) {
    $zip=$null
    try {
     $zip=[IO.Compression.ZipFile]::OpenRead($file.FullName)
     $entry=$zip.GetEntry('fabric.mod.json')
     if($null -ne $entry) {
      $reader=New-Object IO.StreamReader($entry.Open())
      try {$meta=$reader.ReadToEnd() | ConvertFrom-Json; $output.Add("$($file.FullName) : $($meta.id) / $($meta.version)")}
      finally {$reader.Dispose()}
     } else {$output.Add("$($file.FullName) : Fabric metadata not present")}
    } catch {$output.Add("$($file.FullName) : cannot read archive")}
    finally {if($zip){$zip.Dispose()}}
   }
   break
  }
  'hashes' {
   $files=@(Get-YunehModFiles)
   $output.Add("Mod files found across launcher folders: $($files.Count)")
   foreach($file in @($files | Select-Object -First 250)) {
    try {$hash=Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256; $output.Add("$($file.FullName) : $($hash.Hash)")}
    catch {$output.Add("Cannot hash: $($file.FullName)")}
   }
   break
  }
  'inventory' {
   foreach($folder in @(Get-YunehModFolders)) {$output.Add("Mods directory: $folder")}
   break
  }
  'indicators' {
   $pattern='(?i)meteor|wurst|liquidbounce|impact|aristois|rusherhack|bleachhack|futureclient|inertia|vape|raven|baritone|client'
   $files=@(Get-YunehModFiles)
   $output.Add("Mod files reviewed: $($files.Count)")
   $matches=@($files | Where-Object {$_.Name -match $pattern})
   foreach($file in $matches) {$output.Add("Filename indicator (verify manually): $($file.FullName)")}
   if($matches.Count -eq 0){$output.Add('No filename indicators matched. This does not rule out a renamed or external client.')}
   break
  }
  'prefetch' {
   $dir=Join-Path $env:SystemRoot 'Prefetch'
   if(Test-Path $dir){Get-ChildItem -LiteralPath $dir -Filter '*.pf' -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 100 | ForEach-Object {$output.Add("$($_.LastWriteTime)  $($_.Name)")}}
   break
  }
  'recent' {
   $dir=Join-Path $env:APPDATA 'Microsoft\Windows\Recent'
   if(Test-Path $dir){Get-ChildItem -LiteralPath $dir -Filter '*.lnk' -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 100 | ForEach-Object {$output.Add($_.Name)}}
   break
  }
  'javaruntime' {
   Get-Command java,javaw -All -ErrorAction SilentlyContinue | ForEach-Object {$output.Add("$($_.Name) : $($_.Source)")}
   break
  }
  'signatures' {
   $paths=Get-Process -ErrorAction SilentlyContinue | ForEach-Object {try{$_.Path}catch{$null}} | Where-Object {$_} | Sort-Object -Unique | Select-Object -First 80
   foreach($path in $paths){try{$sig=Get-AuthenticodeSignature -LiteralPath $path -ErrorAction Stop; if($sig.Status -ne 'Valid'){$output.Add("$($sig.Status) : $path")}}catch{}}
   break
  }
  'services' {Get-Service -ErrorAction SilentlyContinue | Select-Object -First 160 | ForEach-Object {$output.Add("$($_.Status)  $($_.Name)")};break}
  'usb' {Get-CimInstance Win32_PnPEntity -ErrorAction SilentlyContinue | Where-Object {$_.PNPDeviceID -like 'USB*'} | Select-Object -First 80 | ForEach-Object {$output.Add($_.Name)};break}
  'scripts' {
   foreach($folder in @((Join-Path $env:USERPROFILE 'Downloads'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup'))) {
    if(Test-Path $folder){Get-ChildItem -LiteralPath $folder -File -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Extension -in @('.ahk','.au3')} | Select-Object -First 50 | ForEach-Object {$output.Add($_.FullName)}}
   }
   break
  }

  'jars' {
   $files=@(Get-YunehModFiles)
   $output.Add("Minecraft mod archives found: $($files.Count)")
   foreach($file in @($files | Select-Object -First 250)) {$output.Add("$($file.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))  $($file.FullName)")}
   $downloads=Join-Path $env:USERPROFILE 'Downloads'
   if(Test-Path -LiteralPath $downloads) {
    $output.Add('--- Recent JAR files in Downloads ---')
    Get-ChildItem -LiteralPath $downloads -Filter '*.jar' -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 60 | ForEach-Object {$output.Add($_.FullName)}
   }
   break
  }
  'mods' {
   $folders=@(Get-YunehModFolders)
   $output.Add("Accessible Minecraft mod folders: $($folders.Count)")
   foreach($folder in $folders) {
    $output.Add("--- $folder ---")
    $files=@(Get-ChildItem -LiteralPath $folder -File -ErrorAction SilentlyContinue | Select-Object -First 200)
    if($files.Count -eq 0){$output.Add('No files in this folder')}
    foreach($file in $files){$output.Add("$($file.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))  $($file.Name)")}
   }
   if($folders.Count -eq 0){$output.Add('No supported mod folders accessible. This does NOT mean no mods or cheats exist.')}
   break
  }
  {$_ -in @('versions','logs','crashes','packs','shaders','config','downloads')} {
   $relative = @{mods='mods';versions='versions';logs='logs';crashes='crash-reports';packs='resourcepacks';shaders='shaderpacks';config='config'}
   $folder = if($id -eq 'downloads') { Join-Path $env:USERPROFILE 'Downloads' } else { Join-Path $base $relative[$id] }
   if(Test-Path -LiteralPath $folder) {
    Get-ChildItem -LiteralPath $folder -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 100 | ForEach-Object { $output.Add("$($_.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))  $($_.Name)") }
   } else { $output.Add('Folder not found.') }
   break
  }
  {$_ -in @('minecraft','java','macro','peripheral','processes')} {
   $pattern = @{minecraft='minecraft|javaw|lunar|badlion|prism|multimc';java='^javaw?$';macro='autohotkey|autoit|macro|tinytask|pulover';peripheral='lghub|ghub|razer|synapse|icue|steelseries|roccat'}
   $procs = @(Get-Process -ErrorAction SilentlyContinue | Sort-Object ProcessName)
   if($id -ne 'processes') { $procs = @($procs | Where-Object { $_.ProcessName -match $pattern[$id] }) }
   $procs | Select-Object -First 200 | ForEach-Object { $output.Add("$($_.ProcessName)  PID $($_.Id)") }
   break
  }
  'startup' { Get-CimInstance Win32_StartupCommand -ErrorAction SilentlyContinue | Select-Object -First 100 | ForEach-Object { $output.Add($_.Name) }; break }
  'tasks' { Get-ScheduledTask -ErrorAction SilentlyContinue | Select-Object -First 100 | ForEach-Object { $output.Add("$($_.TaskName) [$($_.State)]") }; break }
  'system' { $os=Get-CimInstance Win32_OperatingSystem; $output.Add("OS: $($os.Caption)"); $output.Add("Version: $($os.Version)"); $output.Add("Last boot: $($os.LastBootUpTime)"); break }
 }
 if($output.Count -eq 0){ $output.Add('No entries found in the checked locations. This does NOT establish that the PC is clean.') }
 return ($output -join [Environment]::NewLine)
}

# Command-line mode: a single explicitly selected detector.
if($ScanId) {
 $chosen = @($script:tools | Where-Object { $_.Url -eq $ScanId -and $_.Kind -eq 'Local' } | Select-Object -First 1)
 if($chosen.Count -ne 1) { Write-Host 'Unknown detector.' -ForegroundColor Red; exit 2 }
 Write-Host ''
 Write-Host '===============================================' -ForegroundColor Cyan
 Write-Host ' YUNEH CHEAT FINDER' -ForegroundColor Cyan
 Write-Host '===============================================' -ForegroundColor Cyan
 Write-Host ("Detector: " + $chosen[0].Name)
 Write-Host 'Read-only scan. Results are indicators, not proof.' -ForegroundColor Yellow
 Write-Host ''
 if($ScanId -eq 'macrodeep') { Invoke-YunehMacroDetector; exit }
 try { Write-Host (Scan-Local $ScanId) }
 catch { Write-Host ("Scan error: " + $_.Exception.Message) -ForegroundColor Red }
 Write-Host ''
 Write-Host 'Scan complete. Close this CMD window when finished.' -ForegroundColor Green
 exit
}

[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="YunehSSTool | Original Staff Workspace" Width="1240" Height="780" MinWidth="950" MinHeight="600" Background="#080D18" WindowStartupLocation="CenterScreen" FontFamily="Segoe UI">
<Grid>
<Grid.ColumnDefinitions><ColumnDefinition Width="230"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
<Border Background="#0E1B2E" BorderBrush="#294A6B" BorderThickness="0,0,1,0">
<DockPanel Margin="14">
<StackPanel DockPanel.Dock="Top" Margin="6,18,6,22">
<Border Width="58" Height="58" CornerRadius="14" Background="#154675" HorizontalAlignment="Left"><TextBlock Text="Y." Foreground="#70C9FF" FontSize="34" FontWeight="Bold" HorizontalAlignment="Center" VerticalAlignment="Center"/></Border>
<TextBlock Text="YUNEH" Foreground="White" FontSize="27" FontWeight="Bold" Margin="0,12,0,0"/>
<TextBlock Text="SS TOOL / STAFF EDITION" Foreground="#69BBF3" FontSize="10"/>
<Border Background="#285073" Height="1" Margin="0,20,0,0"/>
</StackPanel>
<StackPanel DockPanel.Dock="Bottom" Margin="5,10,5,10"><TextBlock Text="LOCAL • CONSENT REQUIRED" Foreground="#6BDDB8" FontSize="10" FontWeight="Bold"/><TextBlock Text="Built-in, local, read-only checks. Nothing is uploaded." TextWrapping="Wrap" Foreground="#9BB3CD" FontSize="11" Margin="0,8,0,0"/></StackPanel>
<StackPanel DockPanel.Dock="Bottom" Margin="0,12,0,0">
<Button x:Name="SelfDeleteButton" Content="Self Delete / Remove Tool" Background="#253F5D" Foreground="White" BorderBrush="#47719A" BorderThickness="1" Padding="10,10" Cursor="Hand"/>
<TextBlock Text="Deletes only this temporary launcher after closing." Foreground="#8DA6C0" FontSize="10" TextWrapping="Wrap" Margin="2,6,2,0"/>
</StackPanel>
<ScrollViewer VerticalScrollBarVisibility="Auto"><StackPanel x:Name="NavPanel"/></ScrollViewer>
</DockPanel>
</Border>
<Grid Grid.Column="1" Margin="23,20,23,18">
<Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="210"/></Grid.RowDefinitions>
<Grid Grid.Row="0">
<Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="250"/></Grid.ColumnDefinitions>
<StackPanel><TextBlock Text="YUNEH / INVESTIGATION WORKSPACE" Foreground="#4BB8FF" FontSize="11" FontWeight="Bold"/><TextBlock x:Name="TitleText" Text="Tool Library" Foreground="White" FontSize="30" FontWeight="Bold" Margin="0,5,0,0"/><TextBlock x:Name="SubtitleText" Text="Choose a category or search the toolkit" Foreground="#94ABC7" FontSize="12" Margin="0,5,0,0"/></StackPanel>
<TextBox Grid.Column="1" x:Name="SearchBox" Height="36" VerticalAlignment="Center" Background="#12233A" Foreground="White" BorderBrush="#315579" Padding="9,7" ToolTip="Search tool names and descriptions"/>
</Grid>
<Border Grid.Row="1" Background="#24415D" Height="1" Margin="0,18,0,16"/>
<Grid Grid.Row="2">
<Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="260"/></Grid.ColumnDefinitions>
<Border Background="#0E192B" BorderBrush="#25425F" BorderThickness="1" CornerRadius="9" Margin="0,0,10,10" Padding="13">
<DockPanel>
<TextBlock DockPanel.Dock="Top" Text="TOOLS &amp; DETECTORS" Foreground="#63C1FF" FontSize="11" FontWeight="Bold" Margin="0,0,0,12"/>
<Grid ClipToBounds="True">
<TextBlock Text="Y." FontSize="270" FontWeight="Bold" Foreground="#2379BE" Opacity="0.58" HorizontalAlignment="Center" VerticalAlignment="Center" IsHitTestVisible="False"/>
<ScrollViewer VerticalScrollBarVisibility="Auto" Background="Transparent"><StackPanel x:Name="ItemsPanel"/></ScrollViewer>
</Grid>
</DockPanel>
</Border>
<Border Grid.Column="1" Background="#0E192B" BorderBrush="#25425F" BorderThickness="1" CornerRadius="9" Margin="0,0,0,10" Padding="14">
<StackPanel>
<TextBlock Text="TOOL DETAILS" Foreground="#63C1FF" FontSize="11" FontWeight="Bold"/>
<TextBlock x:Name="SelectedName" Text="Select a tool" Foreground="White" FontSize="20" FontWeight="Bold" TextWrapping="Wrap" Margin="0,17,0,8"/>
<TextBlock x:Name="SelectedDesc" Text="Choose a tool to see its purpose." Foreground="#A4BDD6" TextWrapping="Wrap" FontSize="12"/>
<TextBlock x:Name="SelectedSource" Text="" Foreground="#6BBEFF" FontSize="11" TextWrapping="Wrap" Margin="0,16,0,0"/>
<Button x:Name="OpenButton" Content="Open official page" Background="#1974BC" Foreground="White" FontWeight="Bold" BorderThickness="0" Height="40" Margin="0,22,0,0" IsEnabled="False" Cursor="Hand"/>
<TextBlock Text="Results are indicators, not proof. Review with the computer owner." TextWrapping="Wrap" Foreground="#849CB7" FontSize="11" Margin="0,18,0,0"/>
</StackPanel>
</Border>
</Grid>
<Border Grid.Row="3" Background="#07111F" BorderBrush="#25425F" BorderThickness="1" CornerRadius="9" Padding="12">
<DockPanel>
<StackPanel DockPanel.Dock="Top" Orientation="Horizontal" Margin="0,0,0,8"><TextBlock Text="ACTIVITY CONSOLE" Foreground="#6BC4FF" FontSize="11" FontWeight="Bold"/><Button x:Name="CopyLog" Content="Copy" Background="#244563" Foreground="White" BorderThickness="0" Margin="18,0,0,0" Padding="10,3" Cursor="Hand"/><Button x:Name="ClearLog" Content="Clear" Background="#244563" Foreground="White" BorderThickness="0" Margin="8,0,0,0" Padding="10,3" Cursor="Hand"/></StackPanel>
<TextBox x:Name="LogBox" Background="Transparent" Foreground="#8ED3FF" BorderThickness="0" FontFamily="Consolas" FontSize="11" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto"/>
</DockPanel>
</Border>
</Grid>
</Grid>
</Window>
'@
$reader = New-Object System.Xml.XmlNodeReader($xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
$nav = $window.FindName('NavPanel')
$items = $window.FindName('ItemsPanel')
$title = $window.FindName('TitleText')
$subtitle = $window.FindName('SubtitleText')
$search = $window.FindName('SearchBox')
$selectedName = $window.FindName('SelectedName')
$selectedDesc = $window.FindName('SelectedDesc')
$selectedSource = $window.FindName('SelectedSource')
$open = $window.FindName('OpenButton')
$log = $window.FindName('LogBox')
$script:category = 'Yuneh Cheat finder'
$script:selected = $null
function Log-Event([string]$message) {
 $log.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $message`r`n")
 $log.ScrollToEnd()
}
$script:Render = {
 $items.Children.Clear()
 $title.Text = if($script:category -eq 'All tools') {'Full Tool Library'} else {$script:category}
 $query = $search.Text.Trim()
 $found = @($script:tools | Where-Object {
  ($script:category -eq 'All tools' -or $_.Category -eq $script:category) -and
  (!$query -or $_.Name -like "*$query*" -or $_.Description -like "*$query*")
 })
 $subtitle.Text = "$($found.Count) tools available in this view"
 foreach($tool in $found) {
  $btn = New-Object Windows.Controls.Button
  $btn.Background = (New-Object Windows.Media.BrushConverter).ConvertFromString('#13263E')
  $btn.Foreground = [Windows.Media.Brushes]::White
  $btn.BorderBrush = (New-Object Windows.Media.BrushConverter).ConvertFromString('#315779')
  $btn.BorderThickness = '1'
  $btn.Padding = '12'
  $btn.Margin = '0,0,0,8'
  $btn.HorizontalContentAlignment = 'Stretch'
  $btn.Cursor = 'Hand'
  $btn.Tag = $tool
  $stack = New-Object Windows.Controls.StackPanel
  $head = New-Object Windows.Controls.TextBlock
  $head.Text = $tool.Name
  $head.FontWeight = 'SemiBold'
  $head.FontSize = 14
  $head.TextWrapping = 'Wrap'
  $desc = New-Object Windows.Controls.TextBlock
  $desc.Text = "$($tool.Description)   /   $($tool.Kind)"
  $desc.Foreground = [Windows.Media.Brushes]::LightSteelBlue
  $desc.FontSize = 11
  $desc.TextWrapping = 'Wrap'
  $desc.Margin = '0,6,0,0'
  [void]$stack.Children.Add($head)
  [void]$stack.Children.Add($desc)
  $btn.Content = $stack
  $btn.Add_Click({
   param($sender,$args)
   $tool = $sender.Tag
   $script:selected = $tool
   $selectedName.Text = $tool.Name
   $selectedDesc.Text = $tool.Description
   $selectedSource.Text = if($tool.Kind -eq 'External executable') {'Third-party executable - manual selection and confirmation'} else {'Opens its own CMD results window'}
   $open.IsEnabled = $false
   if($tool.Kind -eq 'External executable') {
    $dialog = New-Object Microsoft.Win32.OpenFileDialog
    $dialog.Title = 'Select MeowClientFucker.exe (third-party utility)'
    $dialog.Filter = 'Executable files (*.exe)|*.exe'
    $dialog.FileName = 'MeowClientFucker.exe'
    if($dialog.ShowDialog($window) -ne $true){return}
    $exePath = $dialog.FileName
    if([IO.Path]::GetFileName($exePath) -ine 'MeowClientFucker.exe') {
     [Windows.MessageBox]::Show('Select the supplied MeowClientFucker.exe file.','YunehSSTool') | Out-Null
     return
    }
    $hash = (Get-FileHash -LiteralPath $exePath -Algorithm SHA256).Hash
    $answer = [Windows.MessageBox]::Show(
     "This is an unverified third-party executable. Only run it with the computer owner's permission and after checking its source.`n`nFile: $exePath`nSHA256: $hash`n`nLaunch it visibly now?",
     'External Client Checker','YesNo','Warning')
    if($answer -ne 'Yes'){return}
    try {
     Start-Process -FilePath $exePath -WorkingDirectory (Split-Path -Parent $exePath)
     Log-Event 'Launched user-selected third-party client checker.'
    } catch { Log-Event "Could not launch client checker: $($_.Exception.Message)" }
    return
   }
   if($tool.Kind -eq 'External link') {
    $answer = [Windows.MessageBox]::Show("Open the original developer page for $($tool.Name)? No software will be installed automatically.",'External utility','YesNo','Question')
    if($answer -eq 'Yes'){Start-Process -FilePath $tool.Url; Log-Event "Opened developer page: $($tool.Name)"}
    return
   }
   # Each built-in scanner opens a separate, visible CMD window.
   # The tool may be launched from GitHub with iex, so $PSCommandPath may be empty.
   $answer = [Windows.MessageBox]::Show(
    "Open a separate CMD window for $($tool.Name)?`n`nThe scan is read-only and requires the computer owner's permission.",
    'Yuneh Cheat Finder','YesNo','Question')
   if($answer -ne 'Yes'){return}
   try {
    $scanId = [string]$tool.Url
    if(-not (@($script:tools | Where-Object { $_.Kind -eq 'Local' -and $_.Url -eq $scanId }).Count)) {
     throw 'This scanner is not a built-in local check.'
    }
    $cache = Join-Path $env:TEMP 'YunehSSTool-Scanner.ps1'
    if($PSCommandPath -and (Test-Path -LiteralPath $PSCommandPath)) {
     $source = [IO.File]::ReadAllText($PSCommandPath)
    } else {
     $url = 'https://raw.githubusercontent.com/Yuneh21/YungehSSTool/main/YunehSSTool.ps1'
     $source = [string](Invoke-RestMethod -Uri $url -ErrorAction Stop)
    }
    $source = $source.TrimStart([char]0xFEFF)
    $null = [scriptblock]::Create($source) # Check source syntax before opening CMD.
    [IO.File]::WriteAllText($cache,$source,(New-Object Text.UTF8Encoding($false)))
    $safeId = $scanId.Replace("'","''")
    $child = @"
try {
  `$ErrorActionPreference = 'Stop'
  `$code = [IO.File]::ReadAllText('$($cache.Replace("'","''"))').TrimStart([char]0xFEFF)
  & ([scriptblock]::Create(`$code)) -ScanId '$safeId'
} catch {
  Write-Host ('Scanner failed: ' + `$_.Exception.Message) -ForegroundColor Red
}
"@
    $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($child))
    $arguments = '/d /k powershell.exe -NoProfile -STA -EncodedCommand ' + $encoded
    Start-Process -FilePath (Join-Path $env:SystemRoot 'System32\cmd.exe') -ArgumentList $arguments | Out-Null
    Log-Event "Opened CMD scanner: $($tool.Name)"
   } catch {
    Log-Event "Could not open scanner: $($_.Exception.Message)"
   }
  })
  [void]$items.Children.Add($btn)
 }
}
foreach($cat in @('Yuneh Cheat finder','Servers - Last 2 Weeks','Minecraft','Windows','Local checks','All tools')) {
 $btn = New-Object Windows.Controls.Button
 $btn.Content = "   $cat"
 $btn.Tag = $cat
 $btn.Background = [Windows.Media.Brushes]::Transparent
 $btn.Foreground = [Windows.Media.Brushes]::LightSteelBlue
 $btn.BorderThickness = '0'
 $btn.Height = 38
 $btn.HorizontalContentAlignment = 'Left'
 $btn.Cursor = 'Hand'
 $btn.Add_Click({param($sender,$args) $script:category=[string]$sender.Tag; & $script:Render})
 [void]$nav.Children.Add($btn)
}
$search.Add_TextChanged({ & $script:Render })
$open.Add_Click({
 if($null -eq $script:selected){return}
 if($script:selected.Kind -eq 'Local') {
  $answer = [Windows.MessageBox]::Show('Only run this check on a computer with its owner''s permission. Continue?','YunehSSTool','YesNo','Question')
  if($answer -ne 'Yes'){Log-Event 'Check cancelled';return}
  try {
   $data = if($script:selected.Url -eq 'macrodeep') { 'Use the detector button to open the full macro report in CMD.' } else { Scan-Local $script:selected.Url }
   $log.AppendText("=== $($script:selected.Name) ===`r`n$data`r`n")
   $log.ScrollToEnd()
   Log-Event 'Read-only check finished'
  } catch { Log-Event "Check error: $($_.Exception.Message)" }

 }
})
$window.FindName('CopyLog').Add_Click({[Windows.Clipboard]::SetText($log.Text); Log-Event 'Console copied'})
$window.FindName('ClearLog').Add_Click({$log.Clear();Log-Event 'Console cleared'})
# Explicit cleanup: only the currently executing launcher in the user's TEMP directory.
$script:deleteOnClose = $false
$script:cleanupPath = $PSCommandPath
$window.FindName('SelfDeleteButton').Add_Click({
 $path = $script:cleanupPath
 $tempRoot = [IO.Path]::GetFullPath($env:TEMP).TrimEnd('\') + '\'
 if([string]::IsNullOrWhiteSpace($path) -or
    -not ([IO.Path]::GetFullPath($path).StartsWith($tempRoot,[StringComparison]::OrdinalIgnoreCase))) {
  [Windows.MessageBox]::Show('This tool was not launched from your temporary folder. Close it and manually remove the script you downloaded. No files have been deleted.','YunehSSTool') | Out-Null
  return
 }
 $confirm = [Windows.MessageBox]::Show(
  "Close YunehSSTool and remove this temporary script?`n`n$path`n`nNo other files, logs or Windows history will be deleted.",
  'YunehSSTool - Self Delete','YesNo','Question')
 if($confirm -ne 'Yes'){return}
 $script:deleteOnClose = $true
 $window.Close()
})
$window.Add_Closed({
 if(-not $script:deleteOnClose){return}
 try {
  $path = $script:cleanupPath
  # cmd runs only after the GUI closes; the script file is still in use until PowerShell exits.
  $quoted = '"' + $path + '"'
  $args = '/d /c timeout /t 3 /nobreak >nul & del /f /q ' + $quoted
  Start-Process -FilePath "$env:SystemRoot\System32\cmd.exe" -ArgumentList $args | Out-Null
 } catch {
  [Windows.MessageBox]::Show("Automatic cleanup could not start. Delete this file manually:`n$($script:cleanupPath)",'YunehSSTool') | Out-Null
 }
})
Log-Event 'YunehSSTool ready. No downloads, uploads or remote script execution.'
Log-Event 'Built-in checks plus optional manually selected third-party utility. Review findings manually.'
& $script:Render
[void]$window.ShowDialog()
