# YunehSSTool - independently written local diagnostics
# No external tools, telemetry, credential collection, or remote execution.
# Read-only local checks require the computer owner's permission.
param([string]$ScanId = '')
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
$ErrorActionPreference = 'Stop'

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
 @('Macro Process Check','Looks for common running macro applications; not proof of cheating','macro'),
 @('Auto Clicker Detector','Checks running autoclicker apps and selected local filenames','autoclicker'),
 @('Deleted Files - Last 10 Minutes','Shows recently recycled files with their deletion time; not permanently deleted files','recentdeleted'),
 @('Mouse & Keyboard Macros','Shows peripheral utility processes','peripheral'),
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
function Scan-Local([string]$id) {
 $output = New-Object System.Collections.Generic.List[string]
 $base = Join-Path $env:APPDATA '.minecraft'
 switch($id) {
  'serverhistory' {
   $output.Add('MINECRAFT SERVER HISTORY - LAST 14 DAYS')
   $output.Add('Only connection lines retained in standard Minecraft logs are shown.')
   $output.Add('This is not a complete server history; logs can be rotated, absent, or stored by other launchers.')
   $output.Add('')
   $cutoff = (Get-Date).AddDays(-14)
   $folders = @((Join-Path $base 'logs'))
   $prism = Join-Path $env:APPDATA 'PrismLauncher\instances'
   if(Test-Path -LiteralPath $prism) {
    $folders += @(Get-ChildItem -LiteralPath $prism -Directory -ErrorAction SilentlyContinue | Select-Object -First 25 | ForEach-Object {Join-Path $_.FullName '.minecraft\logs'})
   }
   $files = @()
   foreach($folder in $folders) {
    if(Test-Path -LiteralPath $folder) {
     $files += @(Get-ChildItem -LiteralPath $folder -File -ErrorAction SilentlyContinue |
      Where-Object {$_.LastWriteTime -ge $cutoff -and ($_.Name -match '\.log(\.gz)?$')} |
      Sort-Object LastWriteTime -Descending | Select-Object -First 35)
    }
   }
   $count = 0
   foreach($file in @($files | Select-Object -First 75)) {
    try {
     if($file.Length -gt 15000000){continue}
     $stream = [IO.File]::OpenRead($file.FullName)
     try {
      if($file.Name -like '*.gz') {
       $gzip = New-Object IO.Compression.GzipStream($stream,[IO.Compression.CompressionMode]::Decompress)
       $reader = New-Object IO.StreamReader($gzip)
      } else {
       $reader = New-Object IO.StreamReader($stream)
      }
      try {
       $linesRead = 0
       while(-not $reader.EndOfStream -and $linesRead -lt 100000) {
        $line = $reader.ReadLine()
        $linesRead++
        if($line -match '(?i)\bconnecting to\b.{0,160}' -or $line -match '(?i)\bjoining server\b.{0,160}') {
         $display = $line.Trim()
         if($display.Length -gt 230){$display = $display.Substring(0,230)}
         $output.Add(('{0:yyyy-MM-dd} [{1}] {2}' -f $file.LastWriteTime,$file.Name,$display))
         $count++
         if($count -ge 150){break}
        }
       }
      } finally {$reader.Dispose()}
     } finally {$stream.Dispose()}
    } catch { $output.Add("Could not read: $($file.Name)") }
    if($count -ge 150){break}
   }
   if($count -eq 0){$output.Add('No server connection entries found in the available logs.')}
   $output.Add('')
   $output.Add("Connection log entries found: $count")
   $output.Add('The date shown is the log file modification date, not necessarily the exact connection date.')
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
   $mods = Join-Path $base 'mods'
   if(Test-Path $mods){
    foreach($file in @(Get-ChildItem -LiteralPath $mods -Filter '*.jar' -File -ErrorAction SilentlyContinue | Select-Object -First 100)) {
     $zip = $null
     try {
      $zip = [System.IO.Compression.ZipFile]::OpenRead($file.FullName)
      $entry = $zip.GetEntry('fabric.mod.json')
      if($null -ne $entry) {
       $stream=$entry.Open(); $reader=New-Object System.IO.StreamReader($stream)
       try {$json=$reader.ReadToEnd() | ConvertFrom-Json; $output.Add("$($file.Name) : $($json.id) / $($json.version)")}
       finally {$reader.Dispose();$stream.Dispose()}
      } else {$output.Add("$($file.Name) : no Fabric metadata")}
     } catch {$output.Add("$($file.Name) : unreadable metadata")}
     finally {if($null -ne $zip){$zip.Dispose()}}
    }
   }
   break
  }
  'hashes' {
   $mods=Join-Path $base 'mods'
   if(Test-Path $mods){Get-ChildItem -LiteralPath $mods -Filter '*.jar' -File -ErrorAction SilentlyContinue | Select-Object -First 100 | ForEach-Object {
    try {$h=Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256; $output.Add("$($_.Name) : $($h.Hash)")}catch{$output.Add("$($_.Name) : hash unavailable")}
   }}
   break
  }
  'inventory' {
   if(Test-Path $base){Get-ChildItem -LiteralPath $base -Directory -ErrorAction SilentlyContinue | Select-Object -First 100 | ForEach-Object {$output.Add($_.Name)}}
   break
  }
  'indicators' {
   $mods=Join-Path $base 'mods'
   $pattern='meteor|wurst|liquidbounce|impact|aristois|rusherhack|bleachhack|futureclient|inertia|vape|raven'
   if(Test-Path $mods){Get-ChildItem -LiteralPath $mods -Filter '*.jar' -File -ErrorAction SilentlyContinue | Where-Object {$_.Name -match $pattern} | ForEach-Object {$output.Add("Review filename: $($_.Name)")}}
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
   $folders = @((Join-Path $base 'mods'), (Join-Path $base 'versions'), (Join-Path $env:USERPROFILE 'Downloads'))
   foreach($folder in $folders) {
    if(Test-Path -LiteralPath $folder) {
     $output.Add("Folder: $folder")
     Get-ChildItem -LiteralPath $folder -Filter '*.jar' -File -Recurse -ErrorAction SilentlyContinue |
       Sort-Object LastWriteTime -Descending | Select-Object -First 75 |
       ForEach-Object { $output.Add("$($_.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))  $($_.FullName)") }
    }
   }
   break
  }
  {$_ -in @('mods','versions','logs','crashes','packs','shaders','config','downloads')} {
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
 if($output.Count -eq 0){ $output.Add('No entries found. This does not establish whether cheating occurred.') }
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
   $selectedSource.Text = 'Opens its own CMD results window'
   $open.IsEnabled = $false
   $scriptPath = $PSCommandPath
   if(-not $scriptPath) { Log-Event 'Cannot locate script file.'; return }
   $answer = [Windows.MessageBox]::Show(
    "Open a CMD window and run $($tool.Name)?`n`nOnly this selected check will run, on this computer.",
    'Yuneh Cheat Finder','YesNo','Question')
   if($answer -ne 'Yes'){return}
   try {
    $arguments = '/d /k powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File "' + $scriptPath + '" -ScanId "' + $tool.Url + '"'
    Start-Process -FilePath "$env:SystemRoot\System32\cmd.exe" -ArgumentList $arguments
    Log-Event "Opened CMD detector: $($tool.Name)"
   } catch { Log-Event "Could not open CMD: $($_.Exception.Message)" }
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
   $data = Scan-Local $script:selected.Url
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
Log-Event 'Built-in YunehSSTool checks only; review findings manually.'
& $script:Render
[void]$window.ShowDialog()
