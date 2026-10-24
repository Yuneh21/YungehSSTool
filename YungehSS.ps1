# Yungeh SS Tool - original, read-only diagnostics GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$script:report = New-Object System.Collections.Generic.List[string]
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Yungeh SS Tool'
$form.Size = New-Object System.Drawing.Size(920,620)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::FromArgb(16,22,36)
$form.ForeColor = [System.Drawing.Color]::White
$form.Font = New-Object System.Drawing.Font('Segoe UI',10)

$header = New-Object System.Windows.Forms.Label
$header.Text = 'YUNGEH  /  SS TOOL'
$header.Location = New-Object System.Drawing.Point(24,20)
$header.Size = New-Object System.Drawing.Size(550,45)
$header.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]::Bold)
$header.ForeColor = [System.Drawing.Color]::FromArgb(89,181,255)
$form.Controls.Add($header)

$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = 'Local, read-only Minecraft diagnostics - use with the computer owner''s permission'
$subtitle.Location = New-Object System.Drawing.Point(28,70)
$subtitle.Size = New-Object System.Drawing.Size(840,28)
$subtitle.ForeColor = [System.Drawing.Color]::LightGray
$form.Controls.Add($subtitle)

$output = New-Object System.Windows.Forms.TextBox
$output.Multiline = $true
$output.ReadOnly = $true
$output.ScrollBars = 'Vertical'
$output.BackColor = [System.Drawing.Color]::FromArgb(24,33,51)
$output.ForeColor = [System.Drawing.Color]::White
$output.Font = New-Object System.Drawing.Font('Consolas',10)
$output.Location = New-Object System.Drawing.Point(225,115)
$output.Size = New-Object System.Drawing.Size(650,420)
$output.Anchor = 'Top,Bottom,Left,Right'
$form.Controls.Add($output)

$buttons = @(
  @('Client Checker',15),
  @('Macro Detector',65),
  @('Minecraft Mods',115),
  @('System Info',165),
  @('Export Report',215)
)
foreach ($item in $buttons) {
  $button = New-Object System.Windows.Forms.Button
  $button.Text = $item[0]
  $button.Location = New-Object System.Drawing.Point(24,(115 + [int]$item[1]))
  $button.Size = New-Object System.Drawing.Size(185,40)
  $button.FlatStyle = 'Flat'
  $button.BackColor = [System.Drawing.Color]::FromArgb(34,91,158)
  $button.ForeColor = [System.Drawing.Color]::White
  $button.Tag = $item[0]
  $button.Add_Click({
    $choice = [string]$this.Tag
    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add('Yungeh SS Tool - ' + $choice)
    $lines.Add('Run at: ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
    $lines.Add('These findings are informational, not proof of cheating.')
    $lines.Add('')
    try {
      switch ($choice) {
        'Client Checker' {
          $names = @('java','javaw','Minecraft','MinecraftLauncher','lunarclient','badlionclient','feather')
          $found = @(Get-Process -ErrorAction SilentlyContinue | Where-Object { $names -contains $_.ProcessName } | Sort-Object ProcessName -Unique)
          if ($found.Count -eq 0) { $lines.Add('No matching Minecraft-related processes found.') }
          foreach ($p in $found) { $lines.Add(('Process: {0} (PID {1})' -f $p.ProcessName,$p.Id)) }
        }
        'Macro Detector' {
          $patterns = @('AutoHotkey','AutoIt','Pulover','MacroRecorder','TinyTask')
          $found = @(Get-Process -ErrorAction SilentlyContinue | Where-Object {
            $n = $_.ProcessName
            @($patterns | Where-Object { $n -like ('*' + $_ + '*') }).Count -gt 0
          })
          if ($found.Count -eq 0) { $lines.Add('No common macro utility processes found.') }
          foreach ($p in $found) { $lines.Add(('Possible macro utility: {0} (PID {1})' -f $p.ProcessName,$p.Id)) }
          $lines.Add('A running macro utility does not establish misuse.')
        }
        'Minecraft Mods' {
          $dir = Join-Path $env:APPDATA '.minecraft\mods'
          $lines.Add('Folder: ' + $dir)
          if (Test-Path $dir) {
            $mods = @(Get-ChildItem -LiteralPath $dir -File -ErrorAction Stop | Select-Object -ExpandProperty Name)
            if ($mods.Count -eq 0) { $lines.Add('No files in mods folder.') }
            foreach ($m in $mods) { $lines.Add($m) }
          } else { $lines.Add('Folder not found.') }
        }
        'System Info' {
          $lines.Add('Computer: ' + $env:COMPUTERNAME)
          $lines.Add('Windows: ' + [System.Environment]::OSVersion.VersionString)
          $lines.Add('PowerShell: ' + $PSVersionTable.PSVersion.ToString())
        }
        'Export Report' {
          $dialog = New-Object System.Windows.Forms.SaveFileDialog
          $dialog.Filter = 'Text files (*.txt)|*.txt'
          $dialog.FileName = 'YungehSS_Report.txt'
          if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            [System.IO.File]::WriteAllText($dialog.FileName,$output.Text)
            $lines.Add('Report saved to: ' + $dialog.FileName)
          } else { $lines.Add('Export cancelled.') }
        }
      }
    } catch { $lines.Add('Check failed: ' + $_.Exception.Message) }
    $output.Text = $lines -join [Environment]::NewLine
  })
  $form.Controls.Add($button)
}

$consent = [System.Windows.Forms.MessageBox]::Show(
  'Only run these checks on a computer with its owner''s permission. Results stay local unless you explicitly export them. Continue?',
  'Yungeh SS Tool - Permission',
  [System.Windows.Forms.MessageBoxButtons]::YesNo,
  [System.Windows.Forms.MessageBoxIcon]::Question
)
if ($consent -eq [System.Windows.Forms.DialogResult]::Yes) {
  $output.Text = 'Welcome to Yungeh SS Tool.' + [Environment]::NewLine + 'Select a check on the left to begin.'
  [void]$form.ShowDialog()
}
$form.Dispose()
