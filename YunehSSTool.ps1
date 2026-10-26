# YunehSSTool - redesigned independent catalogue inspired by CheesySSTool
# Downloads only after user chooses a save location. No background scans, uploads or remote script execution.
# External utilities remain the work of their respective authors.
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms
$ErrorActionPreference = 'Stop'
$tools = @(
    [pscustomobject]@{Category='Orbdiff'; Name='PrefetchView'; Url='https://github.com/Orbdiff/PrefetchView'}
    [pscustomobject]@{Category='Orbdiff'; Name='BAMReveal'; Url='https://github.com/Orbdiff/BAMReveal'}
    [pscustomobject]@{Category='Orbdiff'; Name='StringsParser'; Url='https://github.com/Orbdiff/StringsParser'}
    [pscustomobject]@{Category='Orbdiff'; Name='Fileless'; Url='https://github.com/Orbdiff/Fileless'}
    [pscustomobject]@{Category='Orbdiff'; Name='DPS-Analyzer'; Url='https://github.com/Orbdiff/DPS-Analyzer'}
    [pscustomobject]@{Category='Orbdiff'; Name='UserAssistView'; Url='https://github.com/Orbdiff/UserAssistView'}
    [pscustomobject]@{Category='Orbdiff'; Name='JournalParser'; Url='https://github.com/Orbdiff/JournalParser'}
    [pscustomobject]@{Category='Orbdiff'; Name='InjGen'; Url='https://github.com/Orbdiff/InjGen'}
    [pscustomobject]@{Category='Orbdiff'; Name='USBDetector'; Url='https://github.com/Orbdiff/USBDetector'}
    [pscustomobject]@{Category='Orbdiff'; Name='PFTrace'; Url='https://github.com/Orbdiff/PFTrace'}
    [pscustomobject]@{Category='Orbdiff'; Name='CheckDeletedUSN'; Url='https://github.com/Orbdiff/CheckDeletedUSN'}
    [pscustomobject]@{Category='Orbdiff'; Name='JARParser'; Url='https://github.com/Orbdiff/JARParser'}
    [pscustomobject]@{Category='Spokwn'; Name='BAM-parser'; Url='https://github.com/spokwn/BAM-parser'}
    [pscustomobject]@{Category='Spokwn'; Name='PathsParser'; Url='https://github.com/spokwn/PathsParser'}
    [pscustomobject]@{Category='Spokwn'; Name='JournalTrace'; Url='https://github.com/spokwn/JournalTrace'}
    [pscustomobject]@{Category='Spokwn'; Name='KernelLiveDumpTool'; Url='https://github.com/spokwn/KernelLiveDumpTool'}
    [pscustomobject]@{Category='Spokwn'; Name='BamDeletedKeys'; Url='https://github.com/spokwn/BamDeletedKeys'}
    [pscustomobject]@{Category='Spokwn'; Name='Tool'; Url='https://github.com/spokwn/Tool'}
    [pscustomobject]@{Category='Spokwn'; Name='pcasvc-executed'; Url='https://github.com/spokwn/pcasvc-executed'}
    [pscustomobject]@{Category='Spokwn'; Name='process-parser'; Url='https://github.com/spokwn/process-parser'}
    [pscustomobject]@{Category='Spokwn'; Name='prefetch-parser'; Url='https://github.com/spokwn/prefetch-parser'}
    [pscustomobject]@{Category='Spokwn'; Name='ActivitiesCache-execution'; Url='https://github.com/spokwn/ActivitiesCache-execution'}
    [pscustomobject]@{Category='Tonynoh'; Name='MeowDoomsdayFucker'; Url='https://github.com/MeowTonynoh/MeowDoomsdayFucker'}
    [pscustomobject]@{Category='Tonynoh'; Name='MeowModAnalyzer'; Url='https://github.com/MeowTonynoh/MeowModAnalyzer'}
    [pscustomobject]@{Category='Tonynoh'; Name='MeowResolver'; Url='https://github.com/MeowTonynoh/MeowResolver'}
    [pscustomobject]@{Category='Tonynoh'; Name='MeowNovowareFucker'; Url='https://github.com/MeowTonynoh/MeowNovowareFucker'}
    [pscustomobject]@{Category='Tonynoh'; Name='MeowImportsChecker'; Url='https://github.com/MeowTonynoh/MeowImportsChecker'}
    [pscustomobject]@{Category='Tonynoh'; Name='MeowClientFucker'; Url='https://github.com/MeowTonynoh/MeowClientFucker'}
    [pscustomobject]@{Category='Praiselily'; Name='PSHunter'; Url='https://github.com/praiselily/PSHunter'}
    [pscustomobject]@{Category='Praiselily'; Name='AltDetector'; Url='https://github.com/praiselily/AltDetector'}
    [pscustomobject]@{Category='Praiselily'; Name='WeHateFakers'; Url='https://github.com/praiselily/WeHateFakers'}
    [pscustomobject]@{Category='Praiselily'; Name='CommonDirectories'; Url='https://github.com/praiselily/lilith-ps'}
    [pscustomobject]@{Category='Praiselily'; Name='HarddiskConverter'; Url='https://github.com/praiselily/lilith-ps'}
    [pscustomobject]@{Category='Praiselily'; Name='Services'; Url='https://github.com/praiselily/lilith-ps'}
    [pscustomobject]@{Category='Praiselily'; Name='Signed-Scheduled-Tasks'; Url='https://github.com/praiselily/lilith-ps'}
    [pscustomobject]@{Category='RedLotus'; Name='RedLotus-Mod-Analyzer'; Url='https://github.com/ItzIceHere/RedLotus-Mod-Analyzer'}
    [pscustomobject]@{Category='RedLotus'; Name='RedLotus-Task-Sentinel'; Url='https://github.com/ItzIceHere/RedLotus-Task-Sentinel'}
    [pscustomobject]@{Category='RedLotus'; Name='RedLotusAltChecker'; Url='https://github.com/ItzIceHere/RedLotusAltChecker'}
    [pscustomobject]@{Category='Others'; Name='Jarabel'; Url='https://github.com/nay-cat/Jarabel'}
    [pscustomobject]@{Category='Others'; Name='Luyten'; Url='https://github.com/deathmarine/Luyten'}
    [pscustomobject]@{Category='Others'; Name='VMAware'; Url='https://github.com/kernelwernel/VMAware'}
    [pscustomobject]@{Category='Others'; Name='Velociraptor'; Url='https://github.com/Velocidex/velociraptor'}
    [pscustomobject]@{Category='Others'; Name='NTFS Parser'; Url='https://github.com/thewhiteninja/ntfstool'}
    [pscustomobject]@{Category='Others'; Name='Hayabusa'; Url='https://github.com/Yamato-Security/hayabusa'}
    [pscustomobject]@{Category='Others'; Name='DIE-engine'; Url='https://github.com/horsicq/DIE-engine'}
    [pscustomobject]@{Category='Others'; Name='MacroDetector'; Url='https://github.com/NiccBlahh/MacroDetector'}
    [pscustomobject]@{Category='Others'; Name='ComputerActivityView'; Url='https://www.nirsoft.net/utils/computer_activity_view.html'}
    [pscustomobject]@{Category='Others'; Name='SystemInformer'; Url='https://www.systeminformer.com/canary'}
    [pscustomobject]@{Category='Others'; Name='Everything'; Url='https://www.voidtools.com/downloads/'}
    [pscustomobject]@{Category='Others'; Name='HxD'; Url='https://mh-nexus.de/en/hxd/'}
    [pscustomobject]@{Category='Zimmerman'; Name='AmcacheParser'; Url='https://download.ericzimmermanstools.com/net9/AmcacheParser.zip'}
    [pscustomobject]@{Category='Zimmerman'; Name='bstrings'; Url='https://download.ericzimmermanstools.com/net9/bstrings.zip'}
    [pscustomobject]@{Category='Zimmerman'; Name='JLECmd'; Url='https://download.ericzimmermanstools.com/net9/JLECmd.zip'}
    [pscustomobject]@{Category='Zimmerman'; Name='JumpListExplorer'; Url='https://download.ericzimmermanstools.com/net9/JumpListExplorer.zip'}
    [pscustomobject]@{Category='Zimmerman'; Name='MFTECmd'; Url='https://download.ericzimmermanstools.com/net9/MFTECmd.zip'}
    [pscustomobject]@{Category='Zimmerman'; Name='PECmd'; Url='https://download.ericzimmermanstools.com/net9/PECmd.zip'}
    [pscustomobject]@{Category='Zimmerman'; Name='RecentFileCacheParser'; Url='https://download.ericzimmermanstools.com/net9/RecentFileCacheParser.zip'}
    [pscustomobject]@{Category='Zimmerman'; Name='RegistryExplorer'; Url='https://download.ericzimmermanstools.com/net9/RegistryExplorer.zip'}
    [pscustomobject]@{Category='Zimmerman'; Name='ShellBagsExplorer'; Url='https://download.ericzimmermanstools.com/net9/ShellBagsExplorer.zip'}
    [pscustomobject]@{Category='Zimmerman'; Name='SrumECmd'; Url='https://download.ericzimmermanstools.com/net9/SrumECmd.zip'}
    [pscustomobject]@{Category='Zimmerman'; Name='TimelineExplorer'; Url='https://download.ericzimmermanstools.com/net9/TimelineExplorer.zip'}
    [pscustomobject]@{Category='NirSoft'; Name='FullEventLogView'; Url='https://www.nirsoft.net/utils/fulleventlogview.zip'}
    [pscustomobject]@{Category='NirSoft'; Name='NetworkUsageView'; Url='https://www.nirsoft.net/utils/networkusageview.zip'}
    [pscustomobject]@{Category='NirSoft'; Name='BrowserDownloadsView'; Url='https://www.nirsoft.net/utils/browserdownloadsview.zip'}
    [pscustomobject]@{Category='NirSoft'; Name='AlternateStreamView'; Url='https://www.nirsoft.net/utils/alternatestreamview.zip'}
    [pscustomobject]@{Category='NirSoft'; Name='USBDeview'; Url='https://www.nirsoft.net/utils/usbdeview.zip'}
    [pscustomobject]@{Category='NirSoft'; Name='OpenSaveFilesView'; Url='https://www.nirsoft.net/utils/opensavefilesview.zip'}
    [pscustomobject]@{Category='NirSoft'; Name='ExecutedProgramsList'; Url='https://www.nirsoft.net/utils/executedprogramslist.zip'}
    [pscustomobject]@{Category='NirSoft'; Name='TaskSchedulerView'; Url='https://www.nirsoft.net/utils/taskschedulerview.zip'}
    [pscustomobject]@{Category='NirSoft'; Name='JumpListsView'; Url='https://www.nirsoft.net/utils/jumplistsview.zip'}
    [pscustomobject]@{Category='NirSoft'; Name='WinPrefetchView'; Url='https://www.nirsoft.net/utils/winprefetchview.zip'}
    [pscustomobject]@{Category='NirSoft'; Name='RegScanner'; Url='https://www.nirsoft.net/utils/regscanner.zip'}
    [pscustomobject]@{Category='NirSoft'; Name='ShellBagsView'; Url='https://www.nirsoft.net/utils/shellbagsview.zip'}
    [pscustomobject]@{Category='Dependencies'; Name='.NET downloads'; Url='https://dotnet.microsoft.com/en-us/download/dotnet'}
    [pscustomobject]@{Category='Dependencies'; Name='Visual C++ Redistributable'; Url='https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist'}
)
$toolDescriptions = @{
  'PrefetchView' = 'Shows records of programs Windows may have run.'
  'BAMReveal' = 'Checks Windows records of recently run programs.'
  'StringsParser' = 'Finds readable text inside selected files.'
  'Fileless' = 'Examines traces of activity that may not leave a normal file.'
  'DPS-Analyzer' = 'Helps inspect Windows diagnostic service records.'
  'UserAssistView' = 'Shows app-launch history saved by Windows.'
  'JournalParser' = 'Reads file-system change records when available.'
  'InjGen' = 'Specialised inspection utility; review its documentation first.'
  'USBDetector' = 'Shows traces of USB devices connected to Windows.'
  'PFTrace' = 'Examines Windows Prefetch activity records.'
  'CheckDeletedUSN' = 'Checks file-system records for deleted-file activity.'
  'JARParser' = 'Examines Java JAR files and their contents.'
  'BAM-parser' = 'Reads Windows records of program execution.'
  'PathsParser' = 'Helps examine file paths found in system records.'
  'JournalTrace' = 'Checks file-system activity records.'
  'KernelLiveDumpTool' = 'Advanced Windows memory diagnostics; may need admin access.'
  'BamDeletedKeys' = 'Checks Windows execution records for removed entries.'
  'Tool' = 'General diagnostic utility; read the developer instructions.'
  'pcasvc-executed' = 'Looks for app-execution traces in Windows records.'
  'process-parser' = 'Helps examine information about processes.'
  'prefetch-parser' = 'Reads Windows Prefetch files for program activity.'
  'ActivitiesCache-execution' = 'Checks activity history stored by Windows.'
  'MeowDoomsdayFucker' = 'Specialised Minecraft client check; review the tool before use.'
  'MeowModAnalyzer' = 'Examines Minecraft mod files for possible client modifications.'
  'MeowResolver' = 'Minecraft-related investigation helper; check its instructions.'
  'MeowNovowareFucker' = 'Specialised Minecraft client check; review before use.'
  'MeowImportsChecker' = 'Checks imported components in files for clues.'
  'MeowClientFucker' = 'Checks for signs linked to Minecraft clients; not proof alone.'
  'PSHunter' = 'Helps inspect PowerShell-related activity.'
  'AltDetector' = 'Helps look for signs of alternate accounts.'
  'WeHateFakers' = 'Checks hotspot or network-related records.'
  'CommonDirectories' = 'Opens or checks common Windows folders.'
  'HarddiskConverter' = 'Disk information helper; check the instructions first.'
  'Services' = 'Shows or checks Windows background services.'
  'Signed-Scheduled-Tasks' = 'Checks scheduled tasks and their signatures.'
  'RedLotus-Mod-Analyzer' = 'Examines Minecraft mods for suspicious modifications.'
  'RedLotus-Task-Sentinel' = 'Helps review Windows scheduled tasks.'
  'RedLotusAltChecker' = 'Helps investigate signs of alternate accounts.'
  'Jarabel' = 'Helps examine Java JAR files.'
  'Luyten' = 'Lets you inspect compiled Java code in JAR files.'
  'VMAware' = 'Checks whether Windows appears to run in a virtual machine.'
  'Velociraptor' = 'Advanced computer investigation and diagnostics platform.'
  'NTFS Parser' = 'Reads information stored in the Windows file system.'
  'Hayabusa' = 'Searches Windows event logs for notable activity.'
  'DIE-engine' = 'Identifies file types and executable formats.'
  'MacroDetector' = 'Looks for possible macro-related activity.'
  'ComputerActivityView' = 'Shows a timeline of activity recorded by Windows.'
  'SystemInformer' = 'Shows detailed information about running programs.'
  'Everything' = 'Quickly searches for files and folders on the PC.'
  'HxD' = 'Lets you inspect file contents as hexadecimal data.'
  'AmcacheParser' = 'Reads Windows records of installed or run programs.'
  'bstrings' = 'Finds readable text inside files.'
  'JLECmd' = 'Reads Windows Jump List history.'
  'JumpListExplorer' = 'Lets you browse Windows Jump List history.'
  'MFTECmd' = 'Reads file-system metadata and file history.'
  'PECmd' = 'Reads Windows Prefetch program-launch records.'
  'RecentFileCacheParser' = 'Reads an older Windows recent-file record format.'
  'RegistryExplorer' = 'Lets you browse Windows Registry data.'
  'ShellBagsExplorer' = 'Shows Windows folder-browsing history.'
  'SrumECmd' = 'Reads Windows resource and network-usage records.'
  'TimelineExplorer' = 'Helps browse timelines exported by other tools.'
  'FullEventLogView' = 'Shows Windows event logs in one searchable list.'
  'NetworkUsageView' = 'Shows network usage recorded by Windows.'
  'BrowserDownloadsView' = 'Shows download history saved by web browsers.'
  'AlternateStreamView' = 'Lists hidden extra data streams attached to files.'
  'USBDeview' = 'Shows USB devices Windows remembers.'
  'OpenSaveFilesView' = 'Shows files opened or saved through Windows dialogs.'
  'ExecutedProgramsList' = 'Shows traces of programs previously run.'
  'TaskSchedulerView' = 'Lists Windows scheduled tasks.'
  'JumpListsView' = 'Shows recent files recorded in Jump Lists.'
  'WinPrefetchView' = 'Shows program launch information from Prefetch.'
  'RegScanner' = 'Searches the Windows Registry for matching entries.'
  'ShellBagsView' = 'Shows folder access traces saved by Windows.'
  '.NET downloads' = 'Opens Microsoft downloads for required .NET components.'
  'Visual C++ Redistributable' = 'Opens Microsoft downloads for required app libraries.'
}
# Direct script sources identified from CheesySSTool; these require explicit review and confirmation.
$scriptSources = @{
  'MeowModAnalyzer' = 'https://raw.githubusercontent.com/MeowTonynoh/MeowModAnalyzer/main/MeowModAnalyzer.ps1'
  'WeHateFakers' = 'https://raw.githubusercontent.com/praiselily/WeHateFakers/main/HotspotLogs.ps1'
  'CommonDirectories' = 'https://raw.githubusercontent.com/praiselily/lilith-ps/main/CommonDirectories.ps1'
  'HarddiskConverter' = 'https://raw.githubusercontent.com/praiselily/lilith-ps/main/HarddiskConverter.ps1'
  'Services' = 'https://raw.githubusercontent.com/praiselily/lilith-ps/main/Services.ps1'
  'Signed-Scheduled-Tasks' = 'https://raw.githubusercontent.com/praiselily/lilith-ps/main/Signed-Scheduled-Tasks.ps1'
  'MacroDetector' = 'https://raw.githubusercontent.com/NiccBlahh/MacroDetector/main/MacroDetector.ps1'
}
[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="YunehSSTool | Utility Library" Width="1130" Height="735" MinWidth="900" MinHeight="570" WindowStartupLocation="CenterScreen" Background="#070B16" FontFamily="Segoe UI">
<Window.Resources>
<Style x:Key="DarkButton" TargetType="Button">
 <Setter Property="Foreground" Value="#F5FAFF"/><Setter Property="Background" Value="#142E4D"/><Setter Property="BorderBrush" Value="#3B79A6"/><Setter Property="BorderThickness" Value="1"/><Setter Property="Padding" Value="11,9"/><Setter Property="Cursor" Value="Hand"/>
 <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button"><Border x:Name="bg" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="10" SnapsToDevicePixels="True"><ContentPresenter HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" VerticalAlignment="Center" Margin="5,0"/></Border><ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="bg" Property="Background" Value="#1976B7"/><Setter Property="Foreground" Value="White"/></Trigger><Trigger Property="IsPressed" Value="True"><Setter TargetName="bg" Property="Background" Value="#0D456F"/></Trigger><Trigger Property="IsEnabled" Value="False"><Setter Property="Opacity" Value="0.55"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter>
</Style>
</Window.Resources>
<Grid>
 <Grid.ColumnDefinitions><ColumnDefinition Width="225"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
 <Border BorderBrush="#2B6594" BorderThickness="0,0,1,0"><Border.Background><LinearGradientBrush StartPoint="0,0" EndPoint="1,1"><GradientStop Color="#0A1226" Offset="0"/><GradientStop Color="#102A4A" Offset="1"/></LinearGradientBrush></Border.Background><DockPanel Margin="12">
 <StackPanel DockPanel.Dock="Top" Margin="8,14,8,16"><Border Width="66" Height="66" HorizontalAlignment="Left" CornerRadius="18" BorderBrush="#63C9FF" BorderThickness="1" Margin="0,0,0,12"><Border.Background><LinearGradientBrush StartPoint="0,0" EndPoint="1,1"><GradientStop Color="#18588B" Offset="0"/><GradientStop Color="#0C2544" Offset="1"/></LinearGradientBrush></Border.Background><TextBlock Text="Y." FontSize="38" FontWeight="Bold" Foreground="#A3E7FF" HorizontalAlignment="Center" VerticalAlignment="Center"/></Border><TextBlock Text="YUNEH SS TOOL" FontSize="18" FontWeight="Bold" Foreground="White"/><TextBlock Text="UTILITY LIBRARY" Foreground="#89CFFF" FontSize="10" Margin="0,5,0,0"/><Separator Margin="0,14,0,0" Background="#325778"/></StackPanel>
 <StackPanel DockPanel.Dock="Bottom" Margin="6,12"><TextBlock Text="Consent-based diagnostics" Foreground="#A3D8FF" FontSize="11"/><TextBlock Text="Click to launch an installed tool. Downloads require permission. Verified executable files can be launched after confirmation." TextWrapping="Wrap" Foreground="#91A7BA" FontSize="10" Margin="0,6,0,0"/></StackPanel>
 <ScrollViewer VerticalScrollBarVisibility="Auto"><StackPanel x:Name="Sidebar"/></ScrollViewer>
 </DockPanel></Border>
 <Grid Grid.Column="1" Margin="20,17,20,16">
 <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="150"/></Grid.RowDefinitions>
 <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="260"/></Grid.ColumnDefinitions>
 <StackPanel><TextBlock x:Name="Heading" Text="All utilities" Foreground="White" FontSize="27" FontWeight="Bold"/><TextBlock x:Name="CountText" Text="" Foreground="#9ABAD2" Margin="0,5,0,14"/></StackPanel>
 <TextBox x:Name="Search" Grid.Column="1" Height="35" VerticalAlignment="Top" Background="#132B49" Foreground="White" BorderBrush="#55A7DD" Padding="9,7" ToolTip="Type a tool name to search"/>
 </Grid>
 <Border Grid.Row="1" Background="#0D1A30" BorderBrush="#28628D" BorderThickness="1" CornerRadius="14" Padding="12" Margin="0,0,0,12">
 <ScrollViewer VerticalScrollBarVisibility="Auto"><WrapPanel x:Name="ToolPanel" ItemWidth="245" Orientation="Horizontal"/></ScrollViewer>
 </Border>
 <Border Grid.Row="2" Background="#091326" BorderBrush="#28628D" BorderThickness="1" CornerRadius="14" Padding="12">
 <DockPanel><StackPanel DockPanel.Dock="Top" Orientation="Horizontal"><TextBlock Text="ACTIVITY CONSOLE" Foreground="#80D9FF" FontSize="11" FontWeight="Bold"/><Button x:Name="Clear" Content="Clear" Style="{StaticResource DarkButton}" Margin="18,0,0,6" Padding="8,2"/></StackPanel>
 <TextBox x:Name="Console" Background="Transparent" Foreground="#B4E4FF" BorderThickness="0" FontFamily="Consolas" FontSize="11" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto"/></DockPanel>
 </Border>
 </Grid>
</Grid>
</Window>
'@
$reader = New-Object System.Xml.XmlNodeReader($xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
$sidebar = $window.FindName('Sidebar')
$panel = $window.FindName('ToolPanel')
$search = $window.FindName('Search')
$heading = $window.FindName('Heading')
$count = $window.FindName('CountText')
$console = $window.FindName('Console')
$script:category = 'All utilities'
function Write-Activity([string]$message) {
 $console.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $message`r`n")
 $console.ScrollToEnd()
}
function Test-ScriptLaunchAllowed([string]$path) {
 # Respect the target PC's execution policy; do not silently bypass it.
 $policy = Get-ExecutionPolicy
 $signature = Get-AuthenticodeSignature -LiteralPath $path
 if($policy -in @('Restricted','AllSigned')) {
   if($policy -eq 'Restricted' -or $signature.Status -ne 'Valid') {
     $reason = if($policy -eq 'Restricted') { 'PowerShell scripts are disabled on this computer.' } else { 'This script does not have a valid trusted signature.' }
     Write-Activity "Blocked by Windows policy: $([IO.Path]::GetFileName($path)) ($policy)"
     [void][Windows.MessageBox]::Show("$reason`n`nUtility: $([IO.Path]::GetFileName($path))`nPolicy: $policy`n`nYunehSSTool will not change Windows security settings. Ask the utility developer for a signed or standalone version.", 'YunehSSTool - Script Blocked', 'OK', 'Warning')
     return $false
   }
 }
 if($policy -eq 'RemoteSigned') {
   try {
     $zone = Get-Item -LiteralPath $path -Stream Zone.Identifier -ErrorAction SilentlyContinue
     if($zone -and $signature.Status -ne 'Valid') {
       Write-Activity "Script needs trusted signature: $([IO.Path]::GetFileName($path))"
       [void][Windows.MessageBox]::Show('Windows requires this downloaded script to be signed. Ask its developer for a signed or standalone release.', 'YunehSSTool - Script Blocked', 'OK', 'Warning')
       return $false
     }
   } catch {}
 }
 return $true
}
function Show-Tools {
 $panel.Children.Clear()
 $heading.Text = $script:category
 $q = $search.Text.Trim()
 $matches = @($tools | Where-Object {($script:category -eq 'All utilities' -or $_.Category -eq $script:category) -and ($q.Length -eq 0 -or $_.Name.IndexOf($q,[StringComparison]::OrdinalIgnoreCase) -ge 0)})
 $count.Text = "$($matches.Count) utilities available"
 foreach($tool in $matches) {
  $b = New-Object Windows.Controls.Button
  $b.Style = $window.FindResource('DarkButton')
  $info = $toolDescriptions[$tool.Name]
  if (-not $info) { $info = 'Open this utility to learn what it checks.' }
  $labelStack = New-Object Windows.Controls.StackPanel
  $nameLabel = New-Object Windows.Controls.TextBlock
  $nameLabel.Text = $tool.Name
  $nameLabel.FontWeight = 'SemiBold'
  $nameLabel.Foreground = [Windows.Media.Brushes]::White
  $nameLabel.TextWrapping = 'Wrap'
  [void]$labelStack.Children.Add($nameLabel)
  $detailLabel = New-Object Windows.Controls.TextBlock
  $detailLabel.Text = $info
  $detailLabel.Foreground = [Windows.Media.BrushConverter]::new().ConvertFromString('#CDEBFF')
  $detailLabel.FontSize = 11
  $detailLabel.TextWrapping = 'Wrap'
  $detailLabel.Margin = [Windows.Thickness]::new(0,5,0,0)
  [void]$labelStack.Children.Add($detailLabel)
  $b.Content = $labelStack
  $b.HorizontalContentAlignment = 'Left'
  $b.Width = 232
  $b.MinHeight = 108
  $b.Margin = '0,0,10,10'
  $b.Tag = $tool
  $b.ToolTip = "$info`nSource: $($tool.Url)"
  $b.Add_Click({ param($sender,$e)
   $t = $sender.Tag
   try {
    $uri = [Uri]$t.Url
    if($uri.Scheme -ne 'https'){ throw 'Only HTTPS links are permitted.' }
    $base = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'YunehSSTool\Utilities'
    $folder = Join-Path $base ([regex]::Replace($t.Name,'[^a-zA-Z0-9_-]','_'))
    $executables = @()
    if(Test-Path -LiteralPath $folder) {
      $executables = @(Get-ChildItem -LiteralPath $folder -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in @('.exe','.bat','.cmd','.ps1') })
    }
    if($executables.Count -gt 0) {
      $selected = $executables | Where-Object { $_.BaseName -eq $t.Name } | Select-Object -First 1
      if(-not $selected -and $executables.Count -eq 1) { $selected = $executables[0] }
      if(-not $selected) {
        $names = ($executables | Select-Object -First 12 | ForEach-Object {$_.Name}) -join "`n"
        Write-Activity "Multiple executables found for $($t.Name); opening folder for selection."
        Start-Process explorer.exe -ArgumentList ('"' + $folder + '"')
        [void][Windows.MessageBox]::Show("Several files found. Please review and run the correct file manually:`n`n$names",'YunehSSTool','OK','Information')
        return
      }
      $answer = [Windows.MessageBox]::Show("Launch $($selected.Name)?`n`n$($selected.FullName)`n`nOnly run utilities you trust and have permission to use.",'YunehSSTool','YesNo','Question')
      if($answer -ne 'Yes') { Write-Activity "Launch cancelled: $($t.Name)"; return }
      if($selected.Extension -eq '.ps1') {
        if(-not (Test-ScriptLaunchAllowed $selected.FullName)) { return }
        Start-Process powershell.exe -ArgumentList @('-NoProfile','-STA','-NoExit','-File',('"' + $selected.FullName + '"'))
      } elseif($selected.Extension -in @('.cmd','.bat')) {
        Start-Process cmd.exe -ArgumentList @('/k',('"' + $selected.FullName + '"'))
      } else { Start-Process -FilePath $selected.FullName -WorkingDirectory $selected.DirectoryName }
      Write-Activity "Launched $($selected.Name)"
      return
    }
    # Resolve release assets and repository-hosted binaries without assuming every repo has releases.
    $downloadUrl = $null
    $downloadName = $null
    if($scriptSources.ContainsKey([string]$t.Name)) {
      $downloadUrl = $scriptSources[[string]$t.Name]
      $downloadName = [IO.Path]::GetFileName(([Uri]$downloadUrl).AbsolutePath)
    } elseif($uri.AbsolutePath -match '(?i)\.(zip|exe)$') {
      $downloadUrl = $t.Url
      $downloadName = [IO.Path]::GetFileName($uri.AbsolutePath)
    } elseif($uri.Host -eq 'github.com' -and $uri.AbsolutePath -match '^/([^/]+)/([^/]+)/?$') {
      $owner = $Matches[1]; $repo = $Matches[2]
      $headers = @{'User-Agent'='YunehSSTool'; 'Accept'='application/vnd.github+json'}
      try {
        $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repo/releases/latest" -Headers $headers -TimeoutSec 15
        $asset = @($release.assets | Where-Object { $_.name -match '(?i)\.(zip|exe)$' -and $_.name -notmatch '(?i)(source|src|debug|symbols)' } | Sort-Object @{Expression={if($_.name -match '(?i)\.exe$'){0}else{1}}}) | Select-Object -First 1
        if($asset) { $downloadUrl = [string]$asset.browser_download_url; $downloadName = [string]$asset.name }
      } catch { Write-Activity "No GitHub release asset for $($t.Name); checking repository files." }
      if(-not $downloadUrl) {
        try {
          $repoInfo = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repo" -Headers $headers -TimeoutSec 15
          $tree = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repo/git/trees/$($repoInfo.default_branch)?recursive=1" -Headers $headers -TimeoutSec 15
          $file = @($tree.tree | Where-Object { $_.type -eq 'blob' -and $_.path -match '(?i)\.(zip|exe)$' -and $_.path -notmatch '(?i)(debug|symbols|test|sample)' } | Sort-Object @{Expression={if([IO.Path]::GetFileNameWithoutExtension($_.path) -eq $t.Name){0}else{1}}}) | Select-Object -First 1
          if($file) {
            $encodedPath = ($file.path -split '/' | ForEach-Object { [Uri]::EscapeDataString($_) }) -join '/'
            $downloadUrl = "https://raw.githubusercontent.com/$owner/$repo/$($repoInfo.default_branch)/$encodedPath"
            $downloadName = [IO.Path]::GetFileName($file.path)
          }
        } catch { Write-Activity "Could not resolve repository binaries: $($_.Exception.Message)" }
      }
    }
    if(-not $downloadUrl) {
      Write-Activity "No supported downloadable release found for $($t.Name)"
      $choice = [Windows.MessageBox]::Show("No ready-to-run download was found for $($t.Name). The project might contain source code only, require installation, or have no release.`n`nOpen its official page for instructions?",'YunehSSTool','YesNo','Question')
      if($choice -eq 'Yes') { Start-Process -FilePath $t.Url }
      return
    }
    $choice = [Windows.MessageBox]::Show("Download $downloadName for $($t.Name)?`n`nSource: $downloadUrl`n`nAfter downloading, you can choose to open the downloaded EXE.",'YunehSSTool','YesNo','Question')
    if($choice -ne 'Yes') { Write-Activity "Download cancelled: $($t.Name)"; return }
    [IO.Directory]::CreateDirectory($folder) | Out-Null
    $downloadPath = Join-Path $folder $downloadName
    if(Test-Path -LiteralPath $downloadPath) { Remove-Item -LiteralPath $downloadPath -Force }
    Write-Activity "Downloading $downloadName..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath -UseBasicParsing -TimeoutSec 120 -ErrorAction Stop
    if((Get-Item -LiteralPath $downloadPath).Length -lt 100) { throw 'Downloaded file is unexpectedly small.' }
    if($downloadName -match '(?i)\.zip$') {
      Add-Type -AssemblyName System.IO.Compression.FileSystem
      $z = [IO.Compression.ZipFile]::OpenRead($downloadPath)
      try {
        foreach($entry in $z.Entries) {
          $target = [IO.Path]::GetFullPath((Join-Path $folder $entry.FullName))
          $prefix = [IO.Path]::GetFullPath($folder).TrimEnd('\') + '\'
          if(-not $target.StartsWith($prefix,[StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe ZIP entry path.' }
        }
      } finally { $z.Dispose() }
      # Extract to a dedicated subdirectory to avoid collisions on repeat downloads.
      $extractFolder = Join-Path $folder 'extracted'
      if(Test-Path -LiteralPath $extractFolder) { Remove-Item -LiteralPath $extractFolder -Recurse -Force }
      [IO.Directory]::CreateDirectory($extractFolder) | Out-Null
      [IO.Compression.ZipFile]::ExtractToDirectory($downloadPath,$extractFolder)
    }
    $hash = (Get-FileHash -LiteralPath $downloadPath -Algorithm SHA256).Hash
    Write-Activity "Saved $downloadName | SHA256: $hash"
    # Never execute scripts or arbitrary first-file guesses from downloaded archives.
    # For a single EXE, offer an immediate, explicit launch choice.
    $candidates = @()
    if($downloadName -match '(?i)\.exe$') {
      $candidates = @(Get-Item -LiteralPath $downloadPath)
    } elseif($downloadName -match '(?i)\.zip$') {
      $candidates = @(Get-ChildItem -LiteralPath $folder -Recurse -File -Filter '*.exe' -ErrorAction SilentlyContinue)
    }
    if($downloadName -match '(?i)\.ps1$') {
      $scriptHash = (Get-FileHash -LiteralPath $downloadPath -Algorithm SHA256).Hash
      $runScript = [Windows.MessageBox]::Show("PowerShell script downloaded: $downloadName`nSHA256: $scriptHash`n`nThis script may access local files. Review its contents before running. Launch in a separate PowerShell window?",'YunehSSTool','YesNo','Warning')
      if($runScript -eq 'Yes') {
        if(-not (Test-ScriptLaunchAllowed $downloadPath)) { return }
        Start-Process powershell.exe -ArgumentList @('-NoProfile','-NoExit','-File',('"' + $downloadPath + '"')) -ErrorAction Stop
        Write-Activity "Opened script: $downloadName"
      } else { Write-Activity "Saved script for review: $downloadName" }
      return
    }
    if($candidates.Count -eq 1) {
      $exe = $candidates[0]
      $exeHash = (Get-FileHash -LiteralPath $exe.FullName -Algorithm SHA256).Hash
      $sig = Get-AuthenticodeSignature -LiteralPath $exe.FullName
      $publisher = if($sig.Status -eq 'Valid') { $sig.SignerCertificate.Subject } else { 'Unsigned or unverified' }
      Write-Activity "Downloaded $downloadName | SHA256: $hash"
      $run = [Windows.MessageBox]::Show("Download complete: $($t.Name)`n`nExecutable: $($exe.Name)`nPublisher: $publisher`nSHA256: $exeHash`n`nOpen this executable now? Only choose Yes if you trust its source.",'YunehSSTool','YesNo','Question')
      if($run -eq 'Yes') {
        Start-Process -FilePath $exe.FullName -WorkingDirectory $exe.DirectoryName -ErrorAction Stop
        Write-Activity "Opened $($exe.Name)"
      } else { Write-Activity "Saved $downloadName without launching" }
    } else {
      Write-Activity "Downloaded $downloadName | SHA256: $hash"
      [void][Windows.MessageBox]::Show("Download saved. Found $($candidates.Count) EXE files.`n`nFor safety, select the correct program manually in the download folder.",'YunehSSTool','OK','Information')
      Start-Process explorer.exe -ArgumentList ('"' + $folder + '"')
    }

   } catch {
    Write-Activity "ERROR with $($t.Name): $($_.Exception.Message)"
    [void][Windows.MessageBox]::Show("$($t.Name) failed:`n$($_.Exception.Message)", 'YunehSSTool Error', 'OK', 'Error')
   }
  })
  [void]$panel.Children.Add($b)
 }
}
foreach($cat in @('All utilities') + @($tools.Category | Sort-Object -Unique)) {
 $b = New-Object Windows.Controls.Button
 $b.Style = $window.FindResource('DarkButton')
 $b.Content = $cat
 $b.Tag = $cat
 $b.HorizontalContentAlignment = 'Left'
 $b.Margin = '0,0,0,6'
 $b.Add_Click({param($sender,$e) $script:category = [string]$sender.Tag; Show-Tools})
 [void]$sidebar.Children.Add($b)
}
$search.Add_TextChanged({Show-Tools})
$window.FindName('Clear').Add_Click({$console.Clear();Write-Activity 'Console cleared'})
Write-Activity "YunehSSTool ready: $($tools.Count) utility entries."
Write-Activity 'Choose a utility to view its available download and launch options.'
Write-Activity 'No automatic security bypass. Downloads and launches require approval.'
# Startup-only consent dialog. No scans or downloads begin before approval.
$consentXaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="YunehSSTool | Welcome" Width="560" Height="490"
        WindowStartupLocation="CenterScreen" ResizeMode="NoResize"
        Background="#090F21" Foreground="White" FontFamily="Segoe UI"
        ShowInTaskbar="True">
  <Border Padding="28" BorderBrush="#3388C0" BorderThickness="2" CornerRadius="12">
    <Grid>
      <Grid.RowDefinitions>
        <RowDefinition Height="Auto"/>
        <RowDefinition Height="*"/>
        <RowDefinition Height="Auto"/>
        <RowDefinition Height="Auto"/>
      </Grid.RowDefinitions>
      <StackPanel Grid.Row="0" Margin="0,0,0,18">
        <TextBlock Text="YUNEH SS TOOL" FontSize="27" FontWeight="Bold" Foreground="#A3E7FF"/>
        <TextBlock Text="Screenshare consent" FontSize="16" Margin="0,7,0,0"/>
      </StackPanel>
      <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
        <TextBlock TextWrapping="Wrap" FontSize="13" Foreground="#DFEAF5" LineHeight="21">
          This tool is intended for a voluntary Minecraft screenshare check.&#10;&#10;
          By continuing, you agree that the person conducting the check may ask you to run diagnostic utilities that inspect Minecraft logs, local files, and information about running programs. Some utilities are made by third parties.&#10;&#10;
          No scan or download starts just by accepting this screen. Individual downloads and launches may ask for separate permission.&#10;&#10;
          You can decline now or stop the check at any time. Do not turn off antivirus or Windows security settings.&#10;&#10;
          This agreement does not waive your legal rights or remove anyone's responsibility for harm.
        </TextBlock>
      </ScrollViewer>
      <CheckBox Grid.Row="2" Name="AgreeBox" Margin="0,14,0,16"
                Foreground="White" Content="I understand and voluntarily agree to continue."/>
      <Grid Grid.Row="3">
        <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="12"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
        <Button Grid.Column="0" Name="DeclineButton" Content="Decline" Height="39"
                Background="#22364F" Foreground="White" BorderBrush="#52708D"/>
        <Button Grid.Column="2" Name="AcceptButton" Content="Accept &amp; Continue" Height="39"
                Background="#1685C7" Foreground="White" BorderBrush="#6DD3FF" FontWeight="SemiBold" IsEnabled="False"/>
      </Grid>
    </Grid>
  </Border>
</Window>
'@
$consentReader = New-Object System.Xml.XmlNodeReader ([xml]$consentXaml)
$consentWindow = [Windows.Markup.XamlReader]::Load($consentReader)
$agreeBox = $consentWindow.FindName('AgreeBox')
$acceptButton = $consentWindow.FindName('AcceptButton')
$declineButton = $consentWindow.FindName('DeclineButton')
$agreeBox.Add_Checked({ $acceptButton.IsEnabled = $true })
$agreeBox.Add_Unchecked({ $acceptButton.IsEnabled = $false })
$acceptButton.Add_Click({ $consentWindow.DialogResult = $true; $consentWindow.Close() })
$declineButton.Add_Click({ $consentWindow.DialogResult = $false; $consentWindow.Close() })
$consentAccepted = $consentWindow.ShowDialog()
if($consentAccepted -ne $true) { return }

Show-Tools
[void]$window.ShowDialog()
