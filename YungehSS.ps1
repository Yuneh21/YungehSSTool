# Yungy SS Tool - offline, consent-based read-only diagnostic dashboard
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$script:checks = @(
 [pscustomobject]@{Name='Yungy Minecraft Mods';Category='Minecraft';Description='List mod JAR names in the Minecraft mods folder';Id='mods'},
 [pscustomobject]@{Name='Yungy Outside Mods';Category='Minecraft';Description='List Minecraft-related JARs in Downloads and Desktop';Id='outside'},
 [pscustomobject]@{Name='Yungy Minecraft Versions';Category='Minecraft';Description='List locally installed Minecraft versions';Id='versions'},
 [pscustomobject]@{Name='Yungy Minecraft Logs';Category='Minecraft';Description='List recent Minecraft log files (names only)';Id='logs'},
 [pscustomobject]@{Name='Yungy Minecraft Processes';Category='Minecraft';Description='Show running Minecraft and launcher processes';Id='minecraftprocess'},
 [pscustomobject]@{Name='Yungy Macro Processes';Category='Macro';Description='Check for commonly named macro applications';Id='macro'},
 [pscustomobject]@{Name='Yungy Peripheral Software';Category='Macro';Description='Check for running mouse and keyboard utilities';Id='peripheral'},
 [pscustomobject]@{Name='Yungy Java Processes';Category='Macro';Description='List running Java processes';Id='java'},
 [pscustomobject]@{Name='Yungy Running Processes';Category='Windows';Description='Show process names and IDs';Id='processes'},
 [pscustomobject]@{Name='Yungy Recent Downloads';Category='Windows';Description='List recent download file names';Id='downloads'},
 [pscustomobject]@{Name='Yungy Startup Entries';Category='Windows';Description='List startup entry names (no registry values)';Id='startup'},
 [pscustomobject]@{Name='Yungy System Summary';Category='Windows';Description='Show OS version, computer name and uptime';Id='system'}
)

function Get-ScanLines([string]$id) {
 $lines = New-Object 'System.Collections.Generic.List[string]'
 try {
  switch ($id) {
   'mods' {
    $dir = Join-Path $env:APPDATA '.minecraft\mods'
    if (!(Test-Path -LiteralPath $dir)) { $lines.Add('Minecraft mods folder not found.'); break }
    $files = @(Get-ChildItem -LiteralPath $dir -File -Filter '*.jar' -ErrorAction SilentlyContinue)
    foreach ($f in $files) { $lines.Add($f.Name) }
    if ($files.Count -eq 0) { $lines.Add('No JAR files found.') }
   }
   'outside' {
    foreach ($folder in @('Downloads','Desktop')) {
     $dir = Join-Path $env:USERPROFILE $folder
     $lines.Add("--- $folder ---")
     if (Test-Path -LiteralPath $dir) {
      $files = @(Get-ChildItem -LiteralPath $dir -File -Filter '*.jar' -ErrorAction SilentlyContinue | Select-Object -First 100)
      foreach ($f in $files) { $lines.Add($f.Name) }
      if ($files.Count -eq 0) { $lines.Add('No JAR files found.') }
     } else { $lines.Add('Folder not found.') }
    }
   }
   'versions' {
    $dir = Join-Path $env:APPDATA '.minecraft\versions'
    if (Test-Path -LiteralPath $dir) { foreach ($f in (Get-ChildItem -LiteralPath $dir -Directory -ErrorAction SilentlyContinue)) { $lines.Add($f.Name) } }
    else { $lines.Add('Versions folder not found.') }
   }
   'logs' {
    $dir = Join-Path $env:APPDATA '.minecraft\logs'
    if (Test-Path -LiteralPath $dir) { foreach ($f in (Get-ChildItem -LiteralPath $dir -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 30)) { $lines.Add("$($f.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))  $($f.Name)") } }
    else { $lines.Add('Logs folder not found.') }
   }
   'minecraftprocess' {
    foreach ($proc in (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match 'minecraft|javaw|java|lunar|badlion|prismlauncher|multimc' } | Sort-Object ProcessName)) { $lines.Add("$($proc.ProcessName)  PID $($proc.Id)") }
   }
   'macro' {
    foreach ($proc in (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match 'autohotkey|autoit|macro|pulover|tinytask' } | Sort-Object ProcessName)) { $lines.Add("$($proc.ProcessName)  PID $($proc.Id)") }
   }
   'peripheral' {
    foreach ($proc in (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match 'ghub|lghub|razer|synapse|icue|steelseries|roccat|logitech' } | Sort-Object ProcessName)) { $lines.Add("$($proc.ProcessName)  PID $($proc.Id)") }
   }
   'java' {
    foreach ($proc in (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match '^javaw?$' })) { $lines.Add("$($proc.ProcessName)  PID $($proc.Id)") }
   }
   'processes' {
    foreach ($proc in (Get-Process -ErrorAction SilentlyContinue | Sort-Object ProcessName | Select-Object -First 200)) { $lines.Add("$($proc.ProcessName)  PID $($proc.Id)") }
   }
   'downloads' {
    $dir = Join-Path $env:USERPROFILE 'Downloads'
    if (Test-Path -LiteralPath $dir) { foreach ($f in (Get-ChildItem -LiteralPath $dir -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 40)) { $lines.Add("$($f.LastWriteTime.ToString('yyyy-MM-dd'))  $($f.Name)") } }
   }
   'startup' {
    foreach ($entry in (Get-CimInstance Win32_StartupCommand -ErrorAction SilentlyContinue | Select-Object -First 100)) { $lines.Add($entry.Name) }
   }
   'system' {
    $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
    $lines.Add("Computer: $env:COMPUTERNAME")
    $lines.Add("OS: $($os.Caption)")
    $lines.Add("Version: $($os.Version)")
    $lines.Add("Last boot: $($os.LastBootUpTime)")
   }
   default { $lines.Add('Unknown detector.') }
  }
 } catch { $lines.Add("Scan error: $($_.Exception.Message)") }
 if ($lines.Count -eq 0) { $lines.Add('No matching entries found. This does not prove anything about software use.') }
 return $lines.ToArray()
}

[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="Yungy SS Tool" Width="1130" Height="730" MinWidth="890" MinHeight="570" WindowStartupLocation="CenterScreen" Background="#080D17" FontFamily="Segoe UI">
 <Window.Resources>
  <Style x:Key="Nav" TargetType="Button"><Setter Property="Background" Value="Transparent"/><Setter Property="Foreground" Value="#B6CBE6"/><Setter Property="BorderThickness" Value="0"/><Setter Property="Height" Value="46"/><Setter Property="HorizontalContentAlignment" Value="Left"/><Setter Property="Padding" Value="17,0"/><Setter Property="Margin" Value="0,3"/><Setter Property="Cursor" Value="Hand"/><Style.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter Property="Background" Value="#183456"/></Trigger></Style.Triggers></Style>
  <Style x:Key="Tile" TargetType="Button"><Setter Property="Background" Value="#12233A"/><Setter Property="Foreground" Value="White"/><Setter Property="BorderBrush" Value="#294B71"/><Setter Property="BorderThickness" Value="1"/><Setter Property="Padding" Value="15"/><Setter Property="Width" Value="253"/><Setter Property="Height" Value="108"/><Setter Property="Margin" Value="7"/><Setter Property="Cursor" Value="Hand"/><Style.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter Property="Background" Value="#1C3858"/><Setter Property="BorderBrush" Value="#39A3FF"/></Trigger></Style.Triggers></Style>
 </Window.Resources>
 <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="218"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
  <Border Background="#101A2B" BorderBrush="#294260" BorderThickness="0,0,1,0"><DockPanel Margin="13"><StackPanel DockPanel.Dock="Top" Margin="5,16,5,22"><TextBlock Text="Y / YUNGY" Foreground="#3CA6FF" FontSize="26" FontWeight="Bold"/><TextBlock Text="SS TOOL  /  DETECTORS" Foreground="#8AA8C9" FontSize="10" Margin="1,5,0,0"/><Border Height="2" Background="#238FFF" Margin="0,18,0,0"/></StackPanel><StackPanel DockPanel.Dock="Bottom" Margin="8,10"><TextBlock Text="LOCAL SCANS" Foreground="#4CAFFF" FontWeight="Bold" FontSize="11"/><TextBlock Text="Read-only. Owner permission required." Foreground="#8DA7C6" TextWrapping="Wrap" FontSize="11" Margin="0,5,0,0"/></StackPanel><StackPanel x:Name="NavItems"/></DockPanel></Border>
