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
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="YunehSSTool | Utility Library" Width="1130" Height="735" MinWidth="900" MinHeight="570" WindowStartupLocation="CenterScreen" Background="#090F19" FontFamily="Segoe UI">
<Window.Resources>
<Style x:Key="DarkButton" TargetType="Button">
 <Setter Property="Foreground" Value="#F5FAFF"/><Setter Property="Background" Value="#142C45"/><Setter Property="BorderBrush" Value="#305C82"/><Setter Property="BorderThickness" Value="1"/><Setter Property="Padding" Value="11,9"/><Setter Property="Cursor" Value="Hand"/>
 <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button"><Border x:Name="bg" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6"><ContentPresenter HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" VerticalAlignment="Center" Margin="5,0"/></Border><ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="bg" Property="Background" Value="#225A88"/><Setter Property="Foreground" Value="White"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter>
</Style>
</Window.Resources>
<Grid>
 <Grid.ColumnDefinitions><ColumnDefinition Width="225"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
 <Border Background="#0D1D2D" BorderBrush="#284B6D" BorderThickness="0,0,1,0"><DockPanel Margin="12">
 <StackPanel DockPanel.Dock="Top" Margin="8,14,8,16"><TextBlock Text="Y." FontSize="43" FontWeight="Bold" Foreground="#70CAFF"/><TextBlock Text="YUNEH SS TOOL" FontSize="18" FontWeight="Bold" Foreground="White"/><TextBlock Text="UTILITY LIBRARY" Foreground="#7FBCE8" FontSize="10" Margin="0,5,0,0"/><Separator Margin="0,14,0,0" Background="#325778"/></StackPanel>
 <StackPanel DockPanel.Dock="Bottom" Margin="6,12"><TextBlock Text="Consent-based diagnostics" Foreground="#91C6E9" FontSize="11"/><TextBlock Text="Click to launch an installed tool. Downloads require permission. Verified executable files can be launched after confirmation." TextWrapping="Wrap" Foreground="#91A7BA" FontSize="10" Margin="0,6,0,0"/></StackPanel>
 <ScrollViewer VerticalScrollBarVisibility="Auto"><StackPanel x:Name="Sidebar"/></ScrollViewer>
 </DockPanel></Border>
 <Grid Grid.Column="1" Margin="20,17,20,16">
 <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="150"/></Grid.RowDefinitions>
 <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="260"/></Grid.ColumnDefinitions>
 <StackPanel><TextBlock x:Name="Heading" Text="All utilities" Foreground="White" FontSize="27" FontWeight="Bold"/><TextBlock x:Name="CountText" Text="" Foreground="#9ABAD2" Margin="0,5,0,14"/></StackPanel>
 <TextBox x:Name="Search" Grid.Column="1" Height="35" VerticalAlignment="Top" Background="#14283C" Foreground="White" BorderBrush="#38678A" Padding="9,7" ToolTip="Type a tool name to search"/>
 </Grid>
 <Border Grid.Row="1" Background="#101D2B" BorderBrush="#2A4A65" BorderThickness="1" CornerRadius="8" Padding="12" Margin="0,0,0,12">
 <ScrollViewer VerticalScrollBarVisibility="Auto"><WrapPanel x:Name="ToolPanel" ItemWidth="235" Orientation="Horizontal"/></ScrollViewer>
 </Border>
 <Border Grid.Row="2" Background="#070E18" BorderBrush="#2A4A65" BorderThickness="1" CornerRadius="8" Padding="12">
 <DockPanel><StackPanel DockPanel.Dock="Top" Orientation="Horizontal"><TextBlock Text="ACTIVITY CONSOLE" Foreground="#72C8FF" FontSize="11" FontWeight="Bold"/><Button x:Name="Clear" Content="Clear" Style="{StaticResource DarkButton}" Margin="18,0,0,6" Padding="8,2"/></StackPanel>
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
function Show-Tools {
 $panel.Children.Clear()
 $heading.Text = $script:category
 $q = $search.Text.Trim()
 $matches = @($tools | Where-Object {($script:category -eq 'All utilities' -or $_.Category -eq $script:category) -and ($q.Length -eq 0 -or $_.Name.IndexOf($q,[StringComparison]::OrdinalIgnoreCase) -ge 0)})
 $count.Text = "$($matches.Count) tools | Download and launch with permission"
 foreach($tool in $matches) {
  $b = New-Object Windows.Controls.Button
  $b.Style = $window.FindResource('DarkButton')
  $b.Content = $tool.Name
  $b.HorizontalContentAlignment = 'Left'
  $b.Width = 222
  $b.MinHeight = 48
  $b.Margin = '0,0,10,10'
  $b.Tag = $tool
  $b.ToolTip = "$($tool.Category) | $($tool.Url)"
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
      $choice = [Windows.MessageBox]::Show("No downloadable executable or ZIP could be located for $($t.Name).`n`nOpen the developer page to review installation options?",'YunehSSTool','YesNo','Question')
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
Write-Activity 'Tools download to AppData. Running files always requires confirmation.'
Show-Tools
[void]$window.ShowDialog()
