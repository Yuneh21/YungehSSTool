# YunehSSTool - third-party utility catalogue
# Consent-based tool directory; never silently downloads or executes programs.
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
$source = 'https://raw.githubusercontent.com/cheesecatlol/CheesySSTool/main/CheesySSTool.ps1'
try {
    $raw = (Invoke-WebRequest -Uri $source -UseBasicParsing -TimeoutSec 20 -ErrorAction Stop).Content
} catch {
    [System.Windows.MessageBox]::Show("Could not retrieve tool catalogue: $($_.Exception.Message)", 'YunehSSTool') | Out-Null
    return
}
$entries = New-Object System.Collections.Generic.List[object]
foreach ($line in ($raw -split "`r?`n")) {
    if ($line -match '@\{\s*Name="([^"]+)";\s*Desc="([^"]*)";\s*Category="([^"]+)";\s*Type="([^"]+)";\s*URL="(https?://[^"]+)"') {
        $entries.Add([pscustomobject]@{Name=$matches[1]; Description=$matches[2]; Category=$matches[3]; Type=$matches[4]; URL=$matches[5]})
    } elseif ($line -match '@\{\s*Name="([^"]+)";\s*Desc="([^"]*)";\s*Category="([^"]+)";\s*Type="([^"]+)";\s*Command="([^"]+)"') {
        $entries.Add([pscustomobject]@{Name=$matches[1]; Description=$matches[2]; Category=$matches[3]; Type=$matches[4]; URL='';})
    }
}
$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Title="YunehSSTool | Tool Library" Height="740" Width="1000" MinHeight="450" MinWidth="650" Background="#090E19" WindowStartupLocation="CenterScreen">
<Window.Resources>
<Style TargetType="Button"><Setter Property="Background" Value="#132D4A"/><Setter Property="Foreground" Value="White"/><Setter Property="BorderBrush" Value="#2788D9"/><Setter Property="BorderThickness" Value="1"/><Setter Property="Padding" Value="12,7"/><Setter Property="Margin" Value="5"/><Setter Property="Cursor" Value="Hand"/><Style.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter Property="Background" Value="#1765A0"/><Setter Property="Foreground" Value="White"/><Setter Property="BorderBrush" Value="#67D6FF"/></Trigger></Style.Triggers></Style>
</Window.Resources>
<DockPanel Margin="22">
<StackPanel DockPanel.Dock="Top"><TextBlock Text="YUNEH SS TOOL" FontSize="29" FontWeight="Bold" Foreground="#64D8FF"/><TextBlock Text="THIRD-PARTY TOOL LIBRARY  •  Review before downloading" FontSize="12" Foreground="#A6BBD0" Margin="0,4,0,16"/><TextBox Name="Search" Height="35" Padding="9" Background="#17283D" Foreground="White" BorderBrush="#2884C7" ToolTip="Search by name, description or category"/><TextBlock Name="Count" Foreground="#B3C5D7" Margin="0,10,0,12"/></StackPanel>
<ScrollViewer VerticalScrollBarVisibility="Auto"><StackPanel Name="Items"/></ScrollViewer>
</DockPanel>
</Window>
'@
$window = [Windows.Markup.XamlReader]::Parse($xaml)
$items = $window.FindName('Items'); $search = $window.FindName('Search'); $count = $window.FindName('Count')
function Render-Tools {
    $items.Children.Clear()
    $term = $search.Text.Trim()
    $shown = 0
    foreach ($entry in $entries) {
        if ($term -and ("$($entry.Name) $($entry.Description) $($entry.Category)" -notlike "*$term*")) { continue }
        $shown++
        $panel = New-Object System.Windows.Controls.Border
        $panel.Background = '#101C2D'; $panel.BorderBrush = '#243C56'; $panel.BorderThickness = '1'; $panel.CornerRadius = '7'; $panel.Margin = '0,0,0,9'; $panel.Padding = '11'
        $grid = New-Object System.Windows.Controls.Grid
        $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))
        $right = New-Object System.Windows.Controls.ColumnDefinition; $right.Width = 'Auto'; $grid.ColumnDefinitions.Add($right)
        $stack = New-Object System.Windows.Controls.StackPanel
        $heading = New-Object System.Windows.Controls.TextBlock; $heading.Text = "$($entry.Name)  |  $($entry.Category)"; $heading.Foreground = '#7DD9FF'; $heading.FontWeight = 'Bold'; $heading.FontSize = 15
        $desc = New-Object System.Windows.Controls.TextBlock; $desc.Text = $entry.Description; $desc.Foreground = '#C4D3E1'; $desc.TextWrapping = 'Wrap'; $desc.Margin = '0,5,10,0'
        [void]$stack.Children.Add($heading); [void]$stack.Children.Add($desc); [void]$grid.Children.Add($stack)
        $btn = New-Object System.Windows.Controls.Button
        $btn.Content = $(if ($entry.URL) { 'Open source / download' } else { 'Source details' })
        $btn.Tag = $entry
        $btn.Add_Click({
            $tool = $this.Tag
            if (-not $tool.URL) { [System.Windows.MessageBox]::Show('This entry runs a command rather than linking to a download. Review its original source before use.', $tool.Name) | Out-Null; return }
            if ($tool.URL -notmatch '^https://') { return }
            $ok = [System.Windows.MessageBox]::Show("Open this third-party page in your browser?`n`n$($tool.Name)`n$($tool.URL)`n`nOnly run software you trust, with the PC owner's permission.", 'Confirm external link', 'YesNo', 'Question')
            if ($ok -eq 'Yes') { Start-Process $tool.URL }
        }.GetNewClosure())
        [System.Windows.Controls.Grid]::SetColumn($btn,1); [void]$grid.Children.Add($btn)
        $panel.Child = $grid; [void]$items.Children.Add($panel)
    }
    $count.Text = "$shown tools displayed / $($entries.Count) entries found"
}
$search.Add_TextChanged({ Render-Tools })
Render-Tools
[void]$window.ShowDialog()
