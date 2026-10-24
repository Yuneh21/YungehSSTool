# Yungeh SS Tool - original, read-only diagnostic GUI
# Requires Windows PowerShell 5.1 and Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Yungeh SS Tool'
$form.Size = New-Object System.Drawing.Size(920,600)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::FromArgb(15,20,33)
$form.ForeColor = [System.Drawing.Color]::White
$form.Font = New-Object System.Drawing.Font('Segoe UI',10)

$header = New-Object System.Windows.Forms.Label
$header.Text = 'YUNGEH  /  SS TOOL'
$header.Location = New-Object System.Drawing.Point(24,18)
$header.Size = New-Object System.Drawing.Size(600,40)
$header.Font = New-Object System.Drawing.Font('Segoe UI',19,[System.Drawing.FontStyle]::Bold)
$header.ForeColor = [System.Drawing.Color]::FromArgb(105,185,255)
$form.Controls.Add($header)

$sub = New-Object System.Windows.Forms.Label
$sub.Text = 'Read-only checks. Run only with the computer owner''s permission.'
$sub.Location = New-Object System.Drawing.Point(27,61)
$sub.Size = New-Object System.Drawing.Size(830,25)
$sub.ForeColor = [System.Drawing.Color]::Silver
$form.Controls.Add($sub)

$output = New-Object System.Windows.Forms.TextBox
$output.Multiline = $true
$output.ReadOnly = $true
$output.ScrollBars = 'Vertical'
$output.Location = New-Object System.Drawing.Point(235,105)
$output.Size = New-Object System.Drawing.Size(640,400)
$output.BackColor = [System.Drawing.Color]::FromArgb(23,31,49)
$output.ForeColor = [System.Drawing.Color]::White
$output.Font = New-Object System.Drawing.Font('Consolas',10)
$output.Text = "Welcome to Yungeh SS Tool.`r`nSelect a check on the left."
$form.Controls.Add($output)

$script:report = ''
function Show-Report([string]$title,[string[]]$lines) {
    $body = @($title, ('=' * 55), '') + $lines
    $script:report = $body -join "`r`n"
    $output.Text = $script:report
}
function New-MenuButton([string]$label,[int]$top,[scriptblock]$action) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $label
    $btn.Location = New-Object System.Drawing.Point(25,$top)
    $btn.Size = New-Object System.Drawing.Size(190,48)
    $btn.FlatStyle = 'Flat'
    $btn.FlatAppearance.BorderSize = 0
    $btn.BackColor = [System.Drawing.Color]::FromArgb(35,75,128)
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.Cursor = 'Hand'
    $btn.Add_Click($action)
    $form.Controls.Add($btn)
}

New-MenuButton 'Client Checker' 105 {
    $names = @('java','javaw','Minecraft','MinecraftLauncher','Lunar Client','Badlion Client','PrismLauncher','MultiMC')
    $running = @(Get-Process -ErrorAction SilentlyContinue | Where-Object { $names -contains $_.ProcessName } | Sort-Object ProcessName -Unique | Select-Object -ExpandProperty ProcessName)
    if ($running.Count -eq 0) { $running = @('No matching Minecraft/launcher processes found.') }
    Show-Report 'Minecraft / launcher processes' $running
}
New-MenuButton 'Macro Detector' 163 {
    $known = @('AutoHotkey','AutoHotkey64','AutoHotkey32','PuloversMacroCreator','TinyTask','MacroRecorder')
    $found = @(Get-Process -ErrorAction SilentlyContinue | Where-Object { $known -contains $_.ProcessName } | Sort-Object ProcessName -Unique | Select-Object -ExpandProperty ProcessName)
    if ($found.Count -eq 0) { $found = @('No common macro-tool processes found.') }
    Show-Report 'Common macro-tool processes (not proof of cheating)' $found
}
New-MenuButton 'Minecraft Mods' 221 {
    $dirs = @("$env:APPDATA\.minecraft\mods", "$env:APPDATA\.minecraft\versions")
    $lines = @()
    foreach ($dir in $dirs) {
        $lines += "Folder: $dir"
        if (Test-Path -LiteralPath $dir) {
            $files = @(Get-ChildItem -LiteralPath $dir -File -ErrorAction SilentlyContinue | Select-Object -First 100 -ExpandProperty Name)
            if ($files.Count -eq 0) { $lines += '  (No files at top level)' } else { $lines += ($files | ForEach-Object { "  $_" }) }
        } else { $lines += '  (Not found)' }
        $lines += ''
    }
    Show-Report 'Minecraft files (top level only)' $lines
}
New-MenuButton 'System Info' 279 {
    $lines = @("Computer: $env:COMPUTERNAME", "Windows: $([Environment]::OSVersion.VersionString)", "PowerShell: $($PSVersionTable.PSVersion)", "Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
    Show-Report 'Basic system information' $lines
}
New-MenuButton 'Export Report' 337 {
    $save = New-Object System.Windows.Forms.SaveFileDialog
    $save.Filter = 'Text file (*.txt)|*.txt'
    $save.FileName = 'YungehSS-report.txt'
    if ($save.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        [System.IO.File]::WriteAllText($save.FileName,$output.Text)
        [System.Windows.Forms.MessageBox]::Show('Report saved successfully.','Yungeh SS Tool') | Out-Null
    }
}

$footer = New-Object System.Windows.Forms.Label
$footer.Text = 'Results are informational only. No automatic uploads or changes.'
$footer.Location = New-Object System.Drawing.Point(235,520)
$footer.Size = New-Object System.Drawing.Size(630,25)
$footer.ForeColor = [System.Drawing.Color]::Silver
$form.Controls.Add($footer)

$answer = [System.Windows.Forms.MessageBox]::Show('Run local read-only diagnostics on this computer? Only continue with the owner''s permission.','Yungeh SS Tool - Consent',[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)
if ($answer -eq [System.Windows.Forms.DialogResult]::Yes) {
    [void][System.Windows.Forms.Application]::Run($form)
}
