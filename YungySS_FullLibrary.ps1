# Yungy SS Tool - independent staff workspace inspired by CheesySSTool
# Reference: https://github.com/cheesecatlol/CheesySSTool
# External tools are credited and linked, not bundled, downloaded, or auto-executed.
# Read-only local checks require the computer owner's permission.
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
$ErrorActionPreference = 'Stop'

$catalogText = @'
Orbdiff|PrefetchView|Prefetch analysis|https://github.com/Orbdiff/PrefetchView/releases/latest
Orbdiff|BAMReveal|BAM forensic artifacts|https://github.com/Orbdiff/BAMReveal/releases/latest
Orbdiff|StringsParser|Strings and signatures|https://github.com/Orbdiff/StringsParser/releases/latest
Orbdiff|Fileless|Event and memory analysis|https://github.com/Orbdiff/Fileless/releases/latest
Orbdiff|DPS-Analyzer|DPS memory analysis|https://github.com/Orbdiff/DPS-Analyzer/releases/latest
Orbdiff|UserAssistView|UserAssist history|https://github.com/Orbdiff/UserAssistView/releases/latest
Orbdiff|JournalParser|NTFS journal analysis|https://github.com/Orbdiff/JournalParser/releases/latest
Orbdiff|InjGen|JNI/JVMTI investigation|https://github.com/Orbdiff/InjGen/releases/latest
Orbdiff|USBDetector|USB device history|https://github.com/Orbdiff/USBDetector/releases/latest
Orbdiff|PFTrace|Prefetch traces|https://github.com/Orbdiff/PFTrace/releases/latest
Orbdiff|CheckDeletedUSN|USN timeline review|https://github.com/Orbdiff/CheckDeletedUSN/releases/latest
Orbdiff|JARParser|JAR traces|https://github.com/Orbdiff/JARParser/releases/latest
Spokwn|BAM-parser|BAM parsing|https://github.com/spokwn/BAM-parser/releases/latest
Spokwn|PathsParser|Executable paths|https://github.com/spokwn/PathsParser/releases/latest
Spokwn|JournalTrace|File activity|https://github.com/spokwn/JournalTrace/releases/latest
Spokwn|BamDeletedKeys|BAM keys|https://github.com/spokwn/BamDeletedKeys/releases/latest
Spokwn|Espouken Tool|SS toolkit|https://github.com/spokwn/Tool/releases/latest
Spokwn|pcasvc-executed|PCA execution records|https://github.com/spokwn/pcasvc-executed/releases/latest
Spokwn|process-parser|Process artifacts|https://github.com/spokwn/process-parser/releases/latest
Spokwn|prefetch-parser|Prefetch parser|https://github.com/spokwn/prefetch-parser/releases/latest
Spokwn|ActivitiesCache|Activity history|https://github.com/spokwn/ActivitiesCache-execution/releases/latest
Praiselily|PSHunter|PowerShell activity|https://github.com/praiselily/PSHunter/releases/latest
Praiselily|AltDetector|Account artifacts|https://github.com/praiselily/AltDetector/releases/latest
RedLotus|RL ModAnalyzer|Mod analysis|https://github.com/ItzIceHere/RedLotus-Mod-Analyzer/releases/latest
RedLotus|RL TaskSentinel|Scheduled tasks|https://github.com/ItzIceHere/RedLotus-Task-Sentinel/releases/latest
RedLotus|RL AltChecker|Account indicators|https://github.com/ItzIceHere/RedLotusAltChecker/releases/latest
Others|ComputerActivityView|Activity timeline|https://www.nirsoft.net/utils/computer_activity_view.html
Others|SystemInformer|Process inspection|https://www.systeminformer.com/canary
Others|DIE-engine|File type inspection|https://github.com/horsicq/DIE-engine/releases
Others|Jarabel|JAR file checks|https://github.com/nay-cat/Jarabel/releases/latest
Others|Luyten|Java decompiler|https://github.com/deathmarine/Luyten/releases/latest
Others|VMAware|Virtual machine detection|https://github.com/kernelwernel/VMAware/releases/latest
Others|Velociraptor|Endpoint forensics|https://github.com/Velocidex/velociraptor/releases/latest
Others|NTFS Parser|NTFS artifacts|https://github.com/thewhiteninja/ntfstool/releases/latest
Others|Hayabusa|Event timeline|https://github.com/Yamato-Security/hayabusa/releases/latest
Others|Everything|Filename search|https://www.voidtools.com/downloads/
Others|HxD|Hex editor|https://mh-nexus.de/en/hxd/
Zimmerman|bstrings|String analysis|https://download.ericzimmermanstools.com/net9/bstrings.zip
Zimmerman|JLECmd|Jump lists|https://download.ericzimmermanstools.com/net9/JLECmd.zip
Zimmerman|JumpListExplorer|Jump list viewer|https://download.ericzimmermanstools.com/net9/JumpListExplorer.zip
Zimmerman|MFTECmd|MFT and USN parsing|https://download.ericzimmermanstools.com/net9/MFTECmd.zip
Zimmerman|PECmd|Prefetch parsing|https://download.ericzimmermanstools.com/net9/PECmd.zip
Zimmerman|RecentFileCacheParser|File cache parsing|https://download.ericzimmermanstools.com/net9/RecentFileCacheParser.zip
Zimmerman|RegistryExplorer|Registry viewer|https://download.ericzimmermanstools.com/net9/RegistryExplorer.zip
Zimmerman|ShellBagsExplorer|ShellBags viewer|https://download.ericzimmermanstools.com/net9/ShellBagsExplorer.zip
Zimmerman|SrumECmd|SRUM parsing|https://download.ericzimmermanstools.com/net9/SrumECmd.zip
Zimmerman|TimelineExplorer|Timeline CSV viewer|https://download.ericzimmermanstools.com/net9/TimelineExplorer.zip
NirSoft|FullEventLogView|Windows event logs|https://www.nirsoft.net/utils/fulleventlogview.zip
NirSoft|NetworkUsageView|Network usage|https://www.nirsoft.net/utils/networkusageview.zip
NirSoft|BrowserDownloadsView|Browser downloads|https://www.nirsoft.net/utils/browserdownloadsview.zip
NirSoft|AlternateStreamView|NTFS streams|https://www.nirsoft.net/utils/alternatestreamview.zip
NirSoft|USBDeview|USB history|https://www.nirsoft.net/utils/usbdeview.zip
NirSoft|OpenSaveFilesView|Open and save dialogs|https://www.nirsoft.net/utils/opensavefilesview.zip
NirSoft|ExecutedProgramsList|Execution history|https://www.nirsoft.net/utils/executedprogramslist.zip
NirSoft|TaskSchedulerView|Scheduled tasks|https://www.nirsoft.net/utils/taskschedulerview.zip
NirSoft|JumpListsView|Jump lists|https://www.nirsoft.net/utils/jumplistsview.zip
NirSoft|WinPrefetchView|Prefetch viewer|https://www.nirsoft.net/utils/winprefetchview.zip
NirSoft|RegScanner|Registry search|https://www.nirsoft.net/utils/regscanner.zip
NirSoft|ShellBagsView|ShellBags history|https://www.nirsoft.net/utils/shellbagsview.zip
Dependencies|Visual C++ Redistributable|Microsoft VC++ runtime|https://aka.ms/vs/17/release/vc_redist.x64.exe
'@
$script:tools = @($catalogText -split "`r?`n" | Where-Object { $_.Trim() } | ForEach-Object {
 $parts = $_ -split '\|',4
 [pscustomobject]@{ Category=$parts[0]; Name=$parts[1]; Description=$parts[2]; Url=$parts[3]; Kind='External' }
})
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
function Scan-Local([string]$id) {
 $output = New-Object System.Collections.Generic.List[string]
 $base = Join-Path $env:APPDATA '.minecraft'
 switch($id) {
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

[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="Yungy SS Tool | Staff Workspace" Width="1240" Height="780" MinWidth="950" MinHeight="600" Background="#080D18" WindowStartupLocation="CenterScreen" FontFamily="Segoe UI">
<Grid>
<Grid.ColumnDefinitions><ColumnDefinition Width="230"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
<Border Background="#0E1B2E" BorderBrush="#294A6B" BorderThickness="0,0,1,0">
<DockPanel Margin="14">
<StackPanel DockPanel.Dock="Top" Margin="6,18,6,22">
<Border Width="58" Height="58" CornerRadius="14" Background="#154675" HorizontalAlignment="Left"><TextBlock Text="Y." Foreground="#70C9FF" FontSize="34" FontWeight="Bold" HorizontalAlignment="Center" VerticalAlignment="Center"/></Border>
<TextBlock Text="YUNGY" Foreground="White" FontSize="27" FontWeight="Bold" Margin="0,12,0,0"/>
<TextBlock Text="SS TOOL / STAFF EDITION" Foreground="#69BBF3" FontSize="10"/>
<Border Background="#285073" Height="1" Margin="0,20,0,0"/>
</StackPanel>
<StackPanel DockPanel.Dock="Bottom" Margin="5,10,5,10"><TextBlock Text="LOCAL • CONSENT REQUIRED" Foreground="#6BDDB8" FontSize="10" FontWeight="Bold"/><TextBlock Text="External utilities open official pages only. No automatic downloads or execution." TextWrapping="Wrap" Foreground="#9BB3CD" FontSize="11" Margin="0,8,0,0"/></StackPanel>
<ScrollViewer VerticalScrollBarVisibility="Auto"><StackPanel x:Name="NavPanel"/></ScrollViewer>
</DockPanel>
</Border>
<Grid Grid.Column="1" Margin="23,20,23,18">
<Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="160"/></Grid.RowDefinitions>
<Grid Grid.Row="0">
<Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="250"/></Grid.ColumnDefinitions>
<StackPanel><TextBlock Text="YUNGY / INVESTIGATION WORKSPACE" Foreground="#4BB8FF" FontSize="11" FontWeight="Bold"/><TextBlock x:Name="TitleText" Text="Tool Library" Foreground="White" FontSize="30" FontWeight="Bold" Margin="0,5,0,0"/><TextBlock x:Name="SubtitleText" Text="Choose a category or search the toolkit" Foreground="#94ABC7" FontSize="12" Margin="0,5,0,0"/></StackPanel>
<TextBox Grid.Column="1" x:Name="SearchBox" Height="36" VerticalAlignment="Center" Background="#12233A" Foreground="White" BorderBrush="#315579" Padding="9,7" ToolTip="Search tool names and descriptions"/>
</Grid>
<Border Grid.Row="1" Background="#24415D" Height="1" Margin="0,18,0,16"/>
<Grid Grid.Row="2">
<Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="260"/></Grid.ColumnDefinitions>
<Border Background="#0E192B" BorderBrush="#25425F" BorderThickness="1" CornerRadius="9" Margin="0,0,10,10" Padding="13">
<DockPanel>
<TextBlock DockPanel.Dock="Top" Text="TOOLS &amp; DETECTORS" Foreground="#63C1FF" FontSize="11" FontWeight="Bold" Margin="0,0,0,12"/>
<ScrollViewer VerticalScrollBarVisibility="Auto"><StackPanel x:Name="ItemsPanel"/></ScrollViewer>
</DockPanel>
</Border>
<Border Grid.Column="1" Background="#0E192B" BorderBrush="#25425F" BorderThickness="1" CornerRadius="9" Margin="0,0,0,10" Padding="14">
<StackPanel>
<TextBlock Text="TOOL DETAILS" Foreground="#63C1FF" FontSize="11" FontWeight="Bold"/>
<TextBlock x:Name="SelectedName" Text="Select a tool" Foreground="White" FontSize="20" FontWeight="Bold" TextWrapping="Wrap" Margin="0,17,0,8"/>
<TextBlock x:Name="SelectedDesc" Text="Choose a tool to see its purpose." Foreground="#A4BDD6" TextWrapping="Wrap" FontSize="12"/>
<TextBlock x:Name="SelectedSource" Text="" Foreground="#6BBEFF" FontSize="11" TextWrapping="Wrap" Margin="0,16,0,0"/>
<Button x:Name="OpenButton" Content="Open official page" Background="#1974BC" Foreground="White" FontWeight="Bold" BorderThickness="0" Height="40" Margin="0,22,0,0" IsEnabled="False" Cursor="Hand"/>
<TextBlock Text="Third-party names and attribution remain unchanged. Inspect downloads before running them." TextWrapping="Wrap" Foreground="#849CB7" FontSize="11" Margin="0,18,0,0"/>
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
$script:category = 'Local checks'
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
  $btn.Background = [Windows.Media.BrushConverter]::new().ConvertFromString('#13263E')
  $btn.Foreground = [Windows.Media.Brushes]::White
  $btn.BorderBrush = [Windows.Media.BrushConverter]::new().ConvertFromString('#315779')
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
   $script:selected = $sender.Tag
   $selectedName.Text = $script:selected.Name
   $selectedDesc.Text = $script:selected.Description
   if($script:selected.Kind -eq 'Local') {
    $selectedSource.Text = 'Built-in local, read-only check'
    $open.Content = 'Run local check'
   } else {
    $selectedSource.Text = "Source: $($script:selected.Category)"
    $open.Content = 'Open official page'
   }
   $open.IsEnabled = $true
   Log-Event "Selected: $($script:selected.Name)"
  })
  [void]$items.Children.Add($btn)
 }
}
foreach($cat in @('Local checks','All tools','Orbdiff','Spokwn','Praiselily','RedLotus','Others','Zimmerman','NirSoft','Dependencies')) {
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
  $answer = [Windows.MessageBox]::Show('Only run this check on a computer with its owner''s permission. Continue?','Yungy SS Tool','YesNo','Question')
  if($answer -ne 'Yes'){Log-Event 'Check cancelled';return}
  try {
   $data = Scan-Local $script:selected.Url
   $log.AppendText("=== $($script:selected.Name) ===`r`n$data`r`n")
   $log.ScrollToEnd()
   Log-Event 'Read-only check finished'
  } catch { Log-Event "Check error: $($_.Exception.Message)" }
 } else {
  $uri = [uri]$script:selected.Url
  if($uri.Scheme -ne 'https'){Log-Event 'Blocked non-HTTPS link';return}
  try { Start-Process $uri.AbsoluteUri; Log-Event "Opened source page: $($script:selected.Name)" }
  catch { Log-Event "Cannot open page: $($_.Exception.Message)" }
 }
})
$window.FindName('CopyLog').Add_Click({[Windows.Clipboard]::SetText($log.Text); Log-Event 'Console copied'})
$window.FindName('ClearLog').Add_Click({$log.Clear();Log-Event 'Console cleared'})
Log-Event 'Yungy SS Tool ready. No automatic downloads or remote script execution.'
Log-Event 'Reference: CheesySSTool by cheese cat; third-party tool authors retain credit.'
& $script:Render
[void]$window.ShowDialog()
