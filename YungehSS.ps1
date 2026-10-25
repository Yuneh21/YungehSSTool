# Yungy SS Tool - local, read-only diagnostics. Run only with the computer owner's permission.
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$script:checks = @(
 [pscustomobject]@{Name='Minecraft Mods';Category='Minecraft';Description='List Minecraft mod JAR filenames';Id='mods'},
 [pscustomobject]@{Name='Outside Mods';Category='Minecraft';Description='List JAR filenames on Desktop and Downloads';Id='outside'},
 [pscustomobject]@{Name='Minecraft Versions';Category='Minecraft';Description='List installed Minecraft versions';Id='versions'},
 [pscustomobject]@{Name='Minecraft Logs';Category='Minecraft';Description='List recent log filenames';Id='logs'},
 [pscustomobject]@{Name='Minecraft Processes';Category='Minecraft';Description='List running Minecraft and launcher processes';Id='minecraftprocess'},
 [pscustomobject]@{Name='Macro Processes';Category='Macro';Description='Find running applications with common macro names';Id='macro'},
 [pscustomobject]@{Name='Peripheral Software';Category='Macro';Description='Find running mouse and keyboard utilities';Id='peripheral'},
 [pscustomobject]@{Name='Java Processes';Category='Macro';Description='List running Java processes';Id='java'},
 [pscustomobject]@{Name='Running Processes';Category='Windows';Description='List process names and IDs';Id='processes'},
 [pscustomobject]@{Name='Recent Downloads';Category='Windows';Description='List recent filenames in Downloads';Id='downloads'},
 [pscustomobject]@{Name='Startup Entries';Category='Windows';Description='List startup entry names';Id='startup'},
 [pscustomobject]@{Name='System Summary';Category='Windows';Description='Show Windows version and boot time';Id='system'}
)

function Get-ScanLines([string]$id) {
 $lines = New-Object 'System.Collections.Generic.List[string]'
 try {
  switch ($id) {
   'mods' {
    $dir = Join-Path $env:APPDATA '.minecraft\mods'
    if (Test-Path -LiteralPath $dir) {
     foreach ($f in @(Get-ChildItem -LiteralPath $dir -File -Filter '*.jar' -ErrorAction SilentlyContinue | Select-Object -First 200)) { $lines.Add($f.Name) }
    } else { $lines.Add('Minecraft mods folder not found.') }
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
    if (Test-Path -LiteralPath $dir) { foreach ($f in @(Get-ChildItem -LiteralPath $dir -Directory -ErrorAction SilentlyContinue)) { $lines.Add($f.Name) } }
    else { $lines.Add('Versions folder not found.') }
   }
   'logs' {
    $dir = Join-Path $env:APPDATA '.minecraft\logs'
    if (Test-Path -LiteralPath $dir) { foreach ($f in @(Get-ChildItem -LiteralPath $dir -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 30)) { $lines.Add("$($f.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))  $($f.Name)") } }
    else { $lines.Add('Logs folder not found.') }
   }
   'minecraftprocess' {
    foreach ($p in @(Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match 'minecraft|javaw|java|lunar|badlion|prismlauncher|multimc' } | Sort-Object ProcessName)) { $lines.Add("$($p.ProcessName)  PID $($p.Id)") }
   }
   'macro' {
    foreach ($p in @(Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match 'autohotkey|autoit|macro|pulover|tinytask' } | Sort-Object ProcessName)) { $lines.Add("$($p.ProcessName)  PID $($p.Id)") }
   }
   'peripheral' {
    foreach ($p in @(Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match 'ghub|lghub|razer|synapse|icue|steelseries|roccat|logitech' } | Sort-Object ProcessName)) { $lines.Add("$($p.ProcessName)  PID $($p.Id)") }
   }
   'java' {
    foreach ($p in @(Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match '^javaw?$' })) { $lines.Add("$($p.ProcessName)  PID $($p.Id)") }
   }
   'processes' {
    foreach ($p in @(Get-Process -ErrorAction SilentlyContinue | Sort-Object ProcessName | Select-Object -First 200)) { $lines.Add("$($p.ProcessName)  PID $($p.Id)") }
   }
   'downloads' {
    $dir = Join-Path $env:USERPROFILE 'Downloads'
    if (Test-Path -LiteralPath $dir) { foreach ($f in @(Get-ChildItem -LiteralPath $dir -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 40)) { $lines.Add("$($f.LastWriteTime.ToString('yyyy-MM-dd'))  $($f.Name)") } }
    else { $lines.Add('Downloads folder not found.') }
   }
   'startup' {
    foreach ($entry in @(Get-CimInstance Win32_StartupCommand -ErrorAction SilentlyContinue | Select-Object -First 100)) { $lines.Add($entry.Name) }
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
 if ($lines.Count -eq 0) { $lines.Add('No matching entries found. This does not prove that software was never used.') }
 return $lines.ToArray()
}

[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="Yungy SS Tool" Width="1130" Height="730" MinWidth="890" MinHeight="570" WindowStartupLocation="CenterScreen" Background="#080D17" FontFamily="Segoe UI">
 <Window.Resources>
  <Style x:Key="Nav" TargetType="Button"><Setter Property="Background" Value="Transparent"/><Setter Property="Foreground" Value="#B6CBE6"/><Setter Property="BorderThickness" Value="0"/><Setter Property="Height" Value="46"/><Setter Property="HorizontalContentAlignment" Value="Left"/><Setter Property="Padding" Value="17,0"/><Setter Property="Margin" Value="0,3"/><Setter Property="Cursor" Value="Hand"/><Style.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter Property="Background" Value="#183456"/></Trigger></Style.Triggers></Style>
  <Style x:Key="Tile" TargetType="Button"><Setter Property="Background" Value="#12233A"/><Setter Property="Foreground" Value="White"/><Setter Property="BorderBrush" Value="#294B71"/><Setter Property="BorderThickness" Value="1"/><Setter Property="Padding" Value="15"/><Setter Property="Width" Value="253"/><Setter Property="Height" Value="108"/><Setter Property="Margin" Value="7"/><Setter Property="Cursor" Value="Hand"/><Style.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter Property="Background" Value="#1C3858"/><Setter Property="BorderBrush" Value="#39A3FF"/></Trigger></Style.Triggers></Style>
 </Window.Resources>
 <Grid>
  <Grid.ColumnDefinitions><ColumnDefinition Width="218"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
  <Border Grid.Column="0" Background="#101A2B" BorderBrush="#294260" BorderThickness="0,0,1,0">
   <DockPanel Margin="13">
    <StackPanel DockPanel.Dock="Top" Margin="5,16,5,22"><TextBlock Text="Y / YUNGY" Foreground="#3CA6FF" FontSize="26" FontWeight="Bold"/><TextBlock Text="SS TOOL  /  DETECTORS" Foreground="#8AA8C9" FontSize="10" Margin="1,5,0,0"/><Border Height="2" Background="#238FFF" Margin="0,18,0,0"/></StackPanel>
    <StackPanel DockPanel.Dock="Bottom" Margin="8,10"><TextBlock Text="LOCAL SCANS" Foreground="#4CAFFF" FontWeight="Bold" FontSize="11"/><TextBlock Text="Read-only. Owner permission required." Foreground="#8DA7C6" TextWrapping="Wrap" FontSize="11" Margin="0,5,0,0"/></StackPanel>
    <StackPanel x:Name="NavItems"/>
   </DockPanel>
  </Border>
  <Grid Grid.Column="1" Margin="24,20,24,20">
   <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
   <TextBlock x:Name="PageTitle" Text="Minecraft Detectors" FontSize="27" FontWeight="Bold" Foreground="White"/>
   <TextBlock Grid.Row="1" Text="Choose a detector. Results stay on this computer and are not uploaded." Foreground="#91AAC8" Margin="0,7,0,16" TextWrapping="Wrap"/>
   <Grid Grid.Row="2">
    <Grid.RowDefinitions><RowDefinition Height="*"/><RowDefinition Height="200"/></Grid.RowDefinitions>
    <ScrollViewer VerticalScrollBarVisibility="Auto"><WrapPanel x:Name="Tiles"/></ScrollViewer>
    <Border Grid.Row="1" Background="#0D192B" BorderBrush="#2A4A6E" BorderThickness="1" CornerRadius="7" Padding="12" Margin="0,12,0,0">
     <DockPanel>
      <TextBlock x:Name="ResultHeading" DockPanel.Dock="Top" Text="Scan results" Foreground="#5CB5FF" FontWeight="Bold" FontSize="15" Margin="0,0,0,9"/>
      <TextBox x:Name="Results" Background="Transparent" Foreground="#E1EAF7" BorderThickness="0" FontFamily="Consolas" FontSize="12" IsReadOnly="True" TextWrapping="NoWrap" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Auto" Text="Choose a detector to begin."/>
     </DockPanel>
    </Border>
   </Grid>
   <TextBlock Grid.Row="3" Text="Results are informational. A process name or JAR filename alone is not proof of cheating." Foreground="#8198B5" Margin="0,13,0,0" TextWrapping="Wrap"/>
  </Grid>
 </Grid>
</Window>
'@

$reader = New-Object System.Xml.XmlNodeReader($xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
$nav = $window.FindName('NavItems')
$tiles = $window.FindName('Tiles')
$title = $window.FindName('PageTitle')
$results = $window.FindName('Results')
$heading = $window.FindName('ResultHeading')

$script:ShowCategory = {
 param([string]$category)
 $title.Text = "$category Detectors"
 $tiles.Children.Clear()
 foreach ($check in @($script:checks | Where-Object { $_.Category -eq $category })) {
  $button = New-Object System.Windows.Controls.Button
  $button.Style = $window.FindResource('Tile')
  $button.Tag = $check.Id
  $panel = New-Object System.Windows.Controls.StackPanel
  $name = New-Object System.Windows.Controls.TextBlock
  $name.Text = $check.Name
  $name.FontSize = 15
  $name.FontWeight = 'Bold'
  $name.TextWrapping = 'Wrap'
  $desc = New-Object System.Windows.Controls.TextBlock
  $desc.Text = $check.Description
  $desc.Foreground = [Windows.Media.Brushes]::LightSteelBlue
  $desc.FontSize = 11
  $desc.Margin = '0,7,0,0'
  $desc.TextWrapping = 'Wrap'
  [void]$panel.Children.Add($name)
  [void]$panel.Children.Add($desc)
  $button.Content = $panel
  $button.Add_Click({
   param($sender, $eventArgs)
   $id = [string]$sender.Tag
   $selected = $script:checks | Where-Object { $_.Id -eq $id } | Select-Object -First 1
   $heading.Text = $selected.Name
   $results.Text = 'Scanning...'
   try { $results.Text = (Get-ScanLines $id) -join [Environment]::NewLine }
   catch { $results.Text = "Scan error: $($_.Exception.Message)" }
  })
  [void]$tiles.Children.Add($button)
 }
}

foreach ($category in @('Minecraft','Macro','Windows')) {
 $button = New-Object System.Windows.Controls.Button
 $button.Style = $window.FindResource('Nav')
 $button.Content = "  $category"
 $button.Tag = $category
 $button.Add_Click({ param($sender, $eventArgs) & $script:ShowCategory ([string]$sender.Tag) })
 [void]$nav.Children.Add($button)
}
& $script:ShowCategory 'Minecraft'
[void]$window.ShowDialog()
