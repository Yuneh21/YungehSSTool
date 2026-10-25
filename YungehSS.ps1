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
  <Grid Grid.Column="1" Margin="22,19,22,16"><Grid.RowDefinitions><RowDefinition Height="79"/><RowDefinition Height="*"/><RowDefinition Height="12"/><RowDefinition Height="135"/></Grid.RowDefinitions>
   <Grid Grid.Row="0"><StackPanel><TextBlock x:Name="Heading" Text="All Detectors" FontSize="26" FontWeight="SemiBold" Foreground="White"/><TextBlock x:Name="Subtitle" Text="Choose a detector to start a local scan" FontSize="12" Foreground="#91ABC8" Margin="0,6,0,0"/></StackPanel><TextBox x:Name="SearchBox" HorizontalAlignment="Right" VerticalAlignment="Top" Width="205" Height="33" Background="#172B43" Foreground="White" BorderBrush="#315779" Padding="8,5" ToolTip="Search detectors"/></Grid>
   <Border Grid.Row="1" Background="#0E1B2C" BorderBrush="#24405D" BorderThickness="1" CornerRadius="8"><ScrollViewer VerticalScrollBarVisibility="Auto"><WrapPanel x:Name="Cards" Margin="10"/></ScrollViewer></Border>
   <Border Grid.Row="3" Background="#080F1B" BorderBrush="#24405D" BorderThickness="1" CornerRadius="8" Padding="12"><DockPanel><TextBlock DockPanel.Dock="Top" Text="ACTIVITY CONSOLE" Foreground="#46A8FF" FontWeight="Bold" FontSize="11" Margin="0,0,0,8"/><TextBox x:Name="Activity" IsReadOnly="True" BorderThickness="0" Background="Transparent" Foreground="#B4D9FF" FontFamily="Consolas" FontSize="11" VerticalScrollBarVisibility="Auto"/></DockPanel></Border>
  </Grid>
 </Grid>
</Window>
'@
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)
$nav=$window.FindName('NavItems'); $cards=$window.FindName('Cards'); $activity=$window.FindName('Activity'); $heading=$window.FindName('Heading'); $subtitle=$window.FindName('Subtitle'); $search=$window.FindName('SearchBox')
function Write-Activity([string]$msg) { $activity.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $msg`r`n"); $activity.ScrollToEnd() }
function Open-Detector($entry) {
 $permission = [Windows.MessageBox]::Show("Run the read-only '$($entry.Name)' scan on this computer?`n`nOnly scan devices you own or have permission to inspect.", 'Permission required', 'YesNo', 'Question')
 if ($permission -ne 'Yes') { return }
 $popup = New-Object System.Windows.Window
 $popup.Title=$entry.Name; $popup.Width=740; $popup.Height=510; $popup.MinWidth=520; $popup.MinHeight=340; $popup.WindowStartupLocation='CenterOwner'; $popup.Owner=$window
 $popup.Background=[Windows.Media.BrushConverter]::new().ConvertFromString('#0B1422')
 $panel = New-Object System.Windows.Controls.Grid
 $panel.Margin='20'
 foreach ($h in @('Auto','Auto','*','Auto')) { $r=New-Object System.Windows.Controls.RowDefinition; $r.Height= if ($h -eq '*') { [Windows.GridLength]::new(1,[Windows.GridUnitType]::Star) } else { [Windows.GridLength]::Auto }; [void]$panel.RowDefinitions.Add($r) }
 $header=New-Object System.Windows.Controls.TextBlock; $header.Text=$entry.Name; $header.FontSize=22; $header.FontWeight='SemiBold'; $header.Foreground=[Windows.Media.Brushes]::White; $header.Margin='0,0,0,15'; [Windows.Controls.Grid]::SetRow($header,0); [void]$panel.Children.Add($header)
 $bar=New-Object System.Windows.Controls.ProgressBar; $bar.Height=6; $bar.Minimum=0; $bar.Maximum=100; $bar.Value=0; $bar.Foreground=[Windows.Media.BrushConverter]::new().ConvertFromString('#289EFF'); $bar.Margin='0,0,0,15'; [Windows.Controls.Grid]::SetRow($bar,1); [void]$panel.Children.Add($bar)
 $output=New-Object System.Windows.Controls.TextBox; $output.IsReadOnly=$true; $output.AcceptsReturn=$true; $output.VerticalScrollBarVisibility='Auto'; $output.TextWrapping='NoWrap'; $output.Background=[Windows.Media.BrushConverter]::new().ConvertFromString('#101F32'); $output.Foreground=[Windows.Media.BrushConverter]::new().ConvertFromString('#B8DEFF'); $output.BorderThickness='0'; $output.FontFamily='Consolas'; $output.FontSize=12; $output.Padding='12'; [Windows.Controls.Grid]::SetRow($output,2); [void]$panel.Children.Add($output)
 $save=New-Object System.Windows.Controls.Button; $save.Content='Save Results'; $save.Width=130; $save.Height=34; $save.HorizontalAlignment='Right'; $save.Margin='0,14,0,0'; $save.Background=[Windows.Media.BrushConverter]::new().ConvertFromString('#147BD1'); $save.Foreground=[Windows.Media.Brushes]::White; $save.BorderThickness='0'; [Windows.Controls.Grid]::SetRow($save,3); [void]$panel.Children.Add($save)
 $save.Add_Click({ $dialog=New-Object Microsoft.Win32.SaveFileDialog; $dialog.Filter='Text files (*.txt)|*.txt'; $dialog.FileName='YungyScan.txt'; if ($dialog.ShowDialog($popup)) { [IO.File]::WriteAllText($dialog.FileName,$output.Text,[Text.Encoding]::UTF8) } }.GetNewClosure())
 $popup.Content=$panel
 $popup.Tag=$entry
 $output.Text="Scanning $($entry.Name)...`r`n`r`n"
 $popup.Add_ContentRendered({
  try { $scanEntry = $popup.Tag; $result = @(Get-ScanLines $scanEntry.Id); $output.Text = "YUNGY SS TOOL - $($scanEntry.Name)`r`nRead-only results; matches are not proof of wrongdoing.`r`n`r`n" + ($result -join "`r`n"); $bar.Value=100; Write-Activity "Completed: $($scanEntry.Name) ($($result.Count) lines)" }
  catch { $output.Text="Error: $($_.Exception.Message)"; Write-Activity "Scan failed: $($entry.Name)" }
 }.GetNewClosure())
 Write-Activity "Started: $($entry.Name)"
 [void]$popup.ShowDialog()
}
function Show-Page([string]$category) {
 $cards.Children.Clear(); $heading.Text=$category
 $term=$search.Text
 $matches=@($script:checks | Where-Object { ($category -eq 'All Detectors' -or $_.Category -eq $category) -and ([string]::IsNullOrWhiteSpace($term) -or $_.Name.IndexOf($term,[StringComparison]::OrdinalIgnoreCase) -ge 0 -or $_.Description.IndexOf($term,[StringComparison]::OrdinalIgnoreCase) -ge 0) })
 $subtitle.Text="$($matches.Count) local detectors | Click a card to scan"
 foreach ($entry in $matches) {
  $button=New-Object System.Windows.Controls.Button; $button.Style=$window.FindResource('Tile'); $button.Tag=$entry
  $stack=New-Object System.Windows.Controls.StackPanel
  $name=New-Object System.Windows.Controls.TextBlock; $name.Text=$entry.Name; $name.FontWeight='SemiBold'; $name.FontSize=14; $name.TextTrimming='CharacterEllipsis'
  $desc=New-Object System.Windows.Controls.TextBlock; $desc.Text=$entry.Description; $desc.Foreground=[Windows.Media.Brushes]::LightSteelBlue; $desc.FontSize=11; $desc.TextWrapping='Wrap'; $desc.Margin='0,8,0,0'
  [void]$stack.Children.Add($name); [void]$stack.Children.Add($desc); $button.Content=$stack
  $button.Add_Click({ Open-Detector $this.Tag }.GetNewClosure()); [void]$cards.Children.Add($button)
 }
}
foreach ($cat in @('All Detectors','Minecraft','Macro','Windows')) {
 $button=New-Object System.Windows.Controls.Button; $button.Content="  $cat"; $button.Style=$window.FindResource('Nav'); $button.Tag=$cat
 $button.Add_Click({ $script:current=[string]$this.Tag; Show-Page $script:current }.GetNewClosure()); [void]$nav.Children.Add($button)
}
$script:current='All Detectors'
$search.Add_TextChanged({ Show-Page $script:current })
Write-Activity 'Ready. All detectors are local; no catalogue download.'
Show-Page 'All Detectors'
[void]$window.ShowDialog()
