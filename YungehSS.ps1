# Yungeh SS Tool - original, local-only, read-only diagnostics
# Windows PowerShell 5.1 / Windows 10 or 11
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$script:bg = [System.Drawing.Color]::FromArgb(13,18,30)
$script:panel = [System.Drawing.Color]::FromArgb(22,30,46)
$script:accent = [System.Drawing.Color]::FromArgb(62,160,255)
$script:fg = [System.Drawing.Color]::FromArgb(233,241,250)
$script:muted = [System.Drawing.Color]::FromArgb(156,172,193)
$script:report = ''
function Font([float]$size, [bool]$bold=$false) {
  $style = [System.Drawing.FontStyle]::Regular
  if ($bold) { $style = [System.Drawing.FontStyle]::Bold }
  New-Object System.Drawing.Font('Segoe UI',$size,$style)
}
function Label($text,$x,$y,$w,$h,$size=10,$color=$script:fg,$bold=$false) {
  $l=New-Object System.Windows.Forms.Label
  $l.Text=$text; $l.Location=New-Object System.Drawing.Point($x,$y)
  $l.Size=New-Object System.Drawing.Size($w,$h)
  $l.Font=Font $size $bold; $l.ForeColor=$color
  $l.BackColor=[System.Drawing.Color]::Transparent
  return $l
}
function Button($text,$x,$y,$w,$h) {
  $b=New-Object System.Windows.Forms.Button
  $b.Text=$text; $b.Location=New-Object System.Drawing.Point($x,$y)
  $b.Size=New-Object System.Drawing.Size($w,$h)
  $b.FlatStyle='Flat'; $b.FlatAppearance.BorderSize=0
  $b.BackColor=$script:panel; $b.ForeColor=$script:fg
  $b.Font=Font 10 $true; $b.Cursor='Hand'
  return $b
}
$form=New-Object System.Windows.Forms.Form
$form.Text='Yungeh SS Tool'; $form.Size=New-Object System.Drawing.Size(1060,760)
$form.MinimumSize=New-Object System.Drawing.Size(900,700)
$form.StartPosition='CenterScreen'; $form.BackColor=$script:bg
$header=New-Object System.Windows.Forms.Panel
$header.Dock='Top'; $header.Height=76; $header.BackColor=$script:panel
$header.Controls.Add((Label 'Y  /  YUNGEH' 28 14 500 30 19 $script:accent $true))
$header.Controls.Add((Label 'SS TOOL   |   LOCAL DIAGNOSTICS' 30 47 510 19 9 $script:muted))
$form.Controls.Add($header)
$sidebar=New-Object System.Windows.Forms.Panel
$sidebar.Dock='Left'; $sidebar.Width=216; $sidebar.BackColor=$script:panel; $sidebar.AutoScroll=$true
$form.Controls.Add($sidebar)
$content=New-Object System.Windows.Forms.Panel
$content.Dock='Fill'; $content.BackColor=$script:bg
$form.Controls.Add($content); $content.BringToFront(); $sidebar.BringToFront(); $header.BringToFront()
$title=Label 'Overview' 28 24 760 40 22 $script:fg $true
$content.Controls.Add($title)
$subtitle=Label 'Choose a diagnostic category. Nothing runs until you click.' 30 69 740 25 10 $script:muted
$content.Controls.Add($subtitle)
$output=New-Object System.Windows.Forms.RichTextBox
$output.Location=New-Object System.Drawing.Point(28,111)
$output.Size=New-Object System.Drawing.Size(780,400)
$output.Anchor='Top,Bottom,Left,Right'; $output.BackColor=$script:panel
$output.ForeColor=$script:fg; $output.BorderStyle='None'; $output.Font=Font 10
$output.ReadOnly=$true; $output.WordWrap=$false
$content.Controls.Add($output)
$export=Button 'EXPORT REPORT' 28 525 170 42
$export.Anchor='Bottom,Left'; $export.BackColor=$script:accent; $export.ForeColor=$script:bg
$content.Controls.Add($export)
$status=Label 'Ready  |  Read-only  |  No uploads' 215 536 560 25 10 $script:muted
$status.Anchor='Bottom,Left'; $content.Controls.Add($status)
function Show-Report([string]$name,[scriptblock]$collect) {
  $title.Text=$name; $status.Text='Running local check...'; $form.Refresh()
  try {
    $lines=@(& $collect 2>&1 | Out-String)
    $script:report="Yungeh SS Tool - $name`r`nGenerated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n" + ($lines -join "`r`n")
    $output.Text=$script:report
    $status.Text='Finished  |  Review results before exporting'
  } catch {
    $output.Text='Unable to complete this check: '+$_.Exception.Message
    $status.Text='Check failed'
  }
}
$actions=[ordered]@{
  'OVERVIEW'={
    'Welcome to Yungeh SS Tool.'
    ''
    'This is an original, read-only Minecraft support utility.'
    'Use the menu to inspect running Minecraft/Java processes, installed mods,'
    'launcher folders, and basic PC information with the computer owner present.'
    ''
    'No remote access, hidden scanning, account tokens, or automatic uploads.'
    'Results are saved only if you click EXPORT REPORT.'
    ''
    'Important: A listed mod or process is not proof of cheating.'
  }
  'MINECRAFT'={
    'Minecraft / Java processes currently running:'
    $p=Get-CimInstance Win32_Process -ErrorAction Stop | Where-Object { $_.Name -match '^(javaw?|Minecraft.*|Lunar.*|Badlion.*|Prism.*)\.exe$' }
    if ($p) { $p | Select-Object Name,ProcessId,ExecutablePath | Format-Table -AutoSize | Out-String } else { 'No matching processes found.' }
  }
  'MODS'={
