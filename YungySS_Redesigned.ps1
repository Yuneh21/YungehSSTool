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
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="Yungy SS Tool | Diagnostics" Width="1220" Height="760" MinWidth="980" MinHeight="610" WindowStartupLocation="CenterScreen" Background="#080E19" FontFamily="Segoe UI">
 <Window.Resources>
  <Style x:Key="Nav" TargetType="Button">
   <Setter Property="Background" Value="Transparent"/><Setter Property="Foreground" Value="#9BB5D1"/>
   <Setter Property="BorderThickness" Value="0"/><Setter Property="Height" Value="46"/>
   <Setter Property="Padding" Value="17,0"/><Setter Property="Margin" Value="0,3"/>
   <Setter Property="HorizontalContentAlignment" Value="Left"/><Setter Property="Cursor" Value="Hand"/>
   <Style.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter Property="Background" Value="#183657"/><Setter Property="Foreground" Value="White"/></Trigger></Style.Triggers>
  </Style>
  <Style x:Key="ScanTile" TargetType="Button">
   <Setter Property="Background" Value="#111F32"/><Setter Property="Foreground" Value="#EDF6FF"/>
   <Setter Property="BorderBrush" Value="#25425F"/><Setter Property="BorderThickness" Value="1"/>
   <Setter Property="Padding" Value="16"/><Setter Property="Margin" Value="0,0,0,9"/>
   <Setter Property="HorizontalContentAlignment" Value="Stretch"/><Setter Property="Cursor" Value="Hand"/>
   <Style.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter Property="Background" Value="#1A3553"/><Setter Property="BorderBrush" Value="#38A7FF"/></Trigger></Style.Triggers>
  </Style>
  <Style x:Key="Action" TargetType="Button">
   <Setter Property="Background" Value="#1765A7"/><Setter Property="Foreground" Value="White"/>
   <Setter Property="BorderThickness" Value="0"/><Setter Property="Padding" Value="14,9"/>
   <Setter Property="Cursor" Value="Hand"/><Setter Property="FontWeight" Value="SemiBold"/>
  </Style>
 </Window.Resources>
 <Grid>
  <Grid.ColumnDefinitions><ColumnDefinition Width="230"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
  <Border Grid.Column="0" Background="#0C182A" BorderBrush="#25435F" BorderThickness="0,0,1,0">
   <DockPanel Margin="14">
    <StackPanel DockPanel.Dock="Top" Margin="5,22,5,24">
     <Border Background="#153B63" Width="50" Height="50" CornerRadius="13" HorizontalAlignment="Left"><TextBlock Text="Y." FontSize="30" FontWeight="Bold" Foreground="#63C2FF" HorizontalAlignment="Center" VerticalAlignment="Center"/></Border>
     <TextBlock Text="YUNGY" FontSize="26" FontWeight="Bold" Foreground="White" Margin="0,15,0,0"/>
     <TextBlock Text="SS TOOL  /  DIAGNOSTICS" FontSize="10" Foreground="#5DB9FC" Margin="0,3,0,0"/>
     <Border Background="#244362" Height="1" Margin="0,20,0,0"/>
    </StackPanel>
    <StackPanel DockPanel.Dock="Bottom" Margin="6,10,6,12">
     <Border Background="#10253B" Padding="12" CornerRadius="7">
      <StackPanel><TextBlock Text="●  LOCAL MODE" Foreground="#60D4B0" FontWeight="Bold" FontSize="11"/>
       <TextBlock Text="Read-only checks. Only scan with the computer owner's permission." Foreground="#9BB5D1" FontSize="11" TextWrapping="Wrap" Margin="0,8,0,0"/>
      </StackPanel>
     </Border>
    </StackPanel>
    <StackPanel>
     <TextBlock Text="WORKSPACE" Foreground="#6485A8" FontWeight="Bold" FontSize="10" Margin="12,0,0,10"/>
     <StackPanel x:Name="NavItems"/>
    </StackPanel>
   </DockPanel>
  </Border>
  <Grid Grid.Column="1" Margin="26,23,26,21">
   <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
   <Grid Grid.Row="0">
    <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
    <StackPanel>
     <TextBlock Text="DIAGNOSTIC WORKSPACE" FontSize="11" FontWeight="Bold" Foreground="#48B5FF"/>
     <TextBlock x:Name="PageTitle" Text="Minecraft checks" FontSize="30" FontWeight="Bold" Foreground="#F5FAFF" Margin="0,5,0,0"/>
     <TextBlock x:Name="PageSubtitle" Text="Choose a check to view results." Foreground="#92ACC9" FontSize="12" Margin="0,7,0,0"/>
    </StackPanel>
    <Border Grid.Column="1" Background="#10273E" CornerRadius="9" Padding="14,10" VerticalAlignment="Top">
     <StackPanel><TextBlock Text="AVAILABLE CHECKS" Foreground="#81A8CC" FontSize="10" FontWeight="Bold"/><TextBlock x:Name="CheckCount" Text="12" Foreground="#63C2FF" FontSize="24" FontWeight="Bold"/></StackPanel>
    </Border>
   </Grid>
   <Border Grid.Row="1" Height="1" Background="#25415E" Margin="0,19,0,20"/>
   <Grid Grid.Row="2">
    <Grid.ColumnDefinitions><ColumnDefinition Width="1.05*"/><ColumnDefinition Width="0.95*"/></Grid.ColumnDefinitions>
    <Border Grid.Column="0" Background="#0D1929" BorderBrush="#1E3753" BorderThickness="1" CornerRadius="10" Margin="0,0,11,0" Padding="16">
     <DockPanel>
      <StackPanel DockPanel.Dock="Top" Margin="0,0,0,14">
       <TextBlock Text="DETECTORS" Foreground="#60BFFF" FontWeight="Bold" FontSize="12"/>
       <TextBlock Text="Select one to run a local check" Foreground="#819DBA" FontSize="11" Margin="0,4,0,0"/>
      </StackPanel>
      <ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled"><StackPanel x:Name="Tiles"/></ScrollViewer>
     </DockPanel>
    </Border>
    <Border Grid.Column="1" Background="#0D1929" BorderBrush="#1E3753" BorderThickness="1" CornerRadius="10" Margin="11,0,0,0" Padding="16">
     <DockPanel>
      <StackPanel DockPanel.Dock="Top" Margin="0,0,0,12">
       <TextBlock Text="SCAN OUTPUT" Foreground="#60BFFF" FontWeight="Bold" FontSize="12"/>
       <TextBlock x:Name="ResultHeading" Text="No check selected" Foreground="White" FontWeight="SemiBold" FontSize="17" Margin="0,10,0,4" TextWrapping="Wrap"/>
       <TextBlock x:Name="ResultStatus" Text="READY  •  LOCAL ONLY" Foreground="#61D4AE" FontSize="10" FontWeight="Bold"/>
       <StackPanel Orientation="Horizontal" Margin="0,14,0,0">
        <Button x:Name="CopyResults" Content="Copy results" Style="{StaticResource Action}" Margin="0,0,8,0"/>
        <Button x:Name="ClearResults" Content="Clear" Background="#243E5A" Foreground="White" BorderThickness="0" Padding="14,9" Cursor="Hand"/>
       </StackPanel>
      </StackPanel>
      <TextBox x:Name="Results" Background="#091320" Foreground="#DDEEFF" BorderBrush="#27445F" BorderThickness="1" Padding="12" FontFamily="Consolas" FontSize="12" IsReadOnly="True" TextWrapping="NoWrap" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Auto" Text="Select a detector on the left to begin."/>
     </DockPanel>
    </Border>
   </Grid>
   <TextBlock Grid.Row="3" Text="Results are informational. A process or file name alone does not prove cheating. Nothing is uploaded." Foreground="#839BB6" FontSize="11" TextWrapping="Wrap" Margin="0,14,0,0"/>
  </Grid>
 </Grid>
</Window>
'@

$reader = New-Object System.Xml.XmlNodeReader($xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
$nav = $window.FindName('NavItems')
$tiles = $window.FindName('Tiles')
$title = $window.FindName('PageTitle')
$subtitle = $window.FindName('PageSubtitle')
$count = $window.FindName('CheckCount')
$results = $window.FindName('Results')
$heading = $window.FindName('ResultHeading')
$status = $window.FindName('ResultStatus')
$copy = $window.FindName('CopyResults')
$clear = $window.FindName('ClearResults')

$copy.Add_Click({
 if (-not [string]::IsNullOrWhiteSpace($results.Text)) {
  [System.Windows.Clipboard]::SetText($results.Text)
  $status.Text = 'COPIED TO CLIPBOARD'
 }
})
$clear.Add_Click({
 $results.Text = 'Select a detector on the left to begin.'
 $heading.Text = 'No check selected'
 $status.Text = 'READY  -  LOCAL ONLY'
})

$script:ShowCategory = {
 param([string]$category)
 $title.Text = "$category checks"
 $subtitle.Text = "Choose a $category detector to inspect local information."
 $tiles.Children.Clear()
 $items = @($script:checks | Where-Object { $_.Category -eq $category })
 $count.Text = [string]$items.Count
 foreach ($check in $items) {
  $button = New-Object System.Windows.Controls.Button
  $button.Style = $window.FindResource('ScanTile')
  $button.Tag = $check.Id
  $panel = New-Object System.Windows.Controls.StackPanel
  $name = New-Object System.Windows.Controls.TextBlock
  $name.Text = $check.Name
  $name.FontSize = 15
  $name.FontWeight = 'SemiBold'
  $name.TextWrapping = 'Wrap'
  $desc = New-Object System.Windows.Controls.TextBlock
  $desc.Text = $check.Description
  $desc.Foreground = [Windows.Media.Brushes]::LightSteelBlue
  $desc.FontSize = 11
  $desc.Margin = '0,6,0,0'
  $desc.TextWrapping = 'Wrap'
  [void]$panel.Children.Add($name)
  [void]$panel.Children.Add($desc)
  $button.Content = $panel
  $button.Add_Click({
   param($sender, $eventArgs)
   $id = [string]$sender.Tag
   $selected = $script:checks | Where-Object { $_.Id -eq $id } | Select-Object -First 1
   $heading.Text = $selected.Name
   $status.Text = 'SCANNING'
   try {
    $results.Text = (Get-ScanLines $id) -join [Environment]::NewLine
    $status.Text = 'COMPLETE  -  LOCAL ONLY'
   } catch {
    $results.Text = "Scan error: $($_.Exception.Message)"
    $status.Text = 'SCAN ERROR'
   }
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
