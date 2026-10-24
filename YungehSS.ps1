
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()

$bg = [System.Drawing.Color]::FromArgb(13,17,27)
$panel = [System.Drawing.Color]::FromArgb(22,29,44)
$blue = [System.Drawing.Color]::FromArgb(45,156,255)
$white = [System.Drawing.Color]::White
$muted = [System.Drawing.Color]::LightGray

$form = New-Object System.Windows.Forms.Form
$form.Text = "Yungeh SS Tool"
$form.Size = New-Object System.Drawing.Size(1050,680)
$form.StartPosition = "CenterScreen"
$form.BackColor = $bg

$sidebar = New-Object System.Windows.Forms.Panel
$sidebar.Dock = "Left"
$sidebar.Width = 240
$sidebar.BackColor = $panel
$form.Controls.Add($sidebar)

$title = New-Object System.Windows.Forms.Label
$title.Text = "YUNGEH"
$title.ForeColor = $blue
$title.Font = New-Object System.Drawing.Font("Segoe UI",23,[System.Drawing.FontStyle]::Bold)
$title.Location = New-Object System.Drawing.Point(22,25)
$title.Size = New-Object System.Drawing.Size(200,50)
$sidebar.Controls.Add($title)

$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = "SS TOOL"
$subtitle.ForeColor = $muted
$subtitle.Location = New-Object System.Drawing.Point(26,76)
$subtitle.Size = New-Object System.Drawing.Size(180,25)
$sidebar.Controls.Add($subtitle)

$heading = New-Object System.Windows.Forms.Label
$heading.Text = "Dashboard"
$heading.ForeColor = $white
$heading.Font = New-Object System.Drawing.Font("Segoe UI",20,[System.Drawing.FontStyle]::Bold)
$heading.Location = New-Object System.Drawing.Point(275,30)
$heading.Size = New-Object System.Drawing.Size(700,50)
$form.Controls.Add($heading)

$description = New-Object System.Windows.Forms.Label
$description.Text = "Select a tool to begin a local scan."
$description.ForeColor = $muted
$description.Location = New-Object System.Drawing.Point(280,82)
$description.Size = New-Object System.Drawing.Size(700,30)
$form.Controls.Add($description)

$results = New-Object System.Windows.Forms.TextBox
$results.Multiline = $true
$results.ReadOnly = $true
$results.ScrollBars = "Vertical"
$results.BackColor = $panel
$results.ForeColor = $white
$results.Font = New-Object System.Drawing.Font("Consolas",11)
$results.Location = New-Object System.Drawing.Point(280,155)
$results.Size = New-Object System.Drawing.Size(720,420)
$results.Anchor = "Top,Bottom,Left,Right"
$form.Controls.Add($results)

$results.Text = "Yungeh SS Tool ready."

function Add-ToolButton {
    param(
        [string]$Text,
        [int]$Y,
        [System.Drawing.Color]$Color,
        [scriptblock]$Action
    )

    $button = New-Object System.Windows.Forms.Button
    $button.Text = $Text
    $button.Location = New-Object System.Drawing.Point(18,$Y)
    $button.Size = New-Object System.Drawing.Size(205,47)
    $button.FlatStyle = "Flat"
    $button.FlatAppearance.BorderSize = 0
    $button.BackColor = $Color
    $button.ForeColor = $white
    $button.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
    $button.Add_Click($Action)
    $sidebar.Controls.Add($button)
}

Add-ToolButton "Dashboard" 135 $blue {
    $heading.Text = "Dashboard"
    $results.Text = "Welcome to Yungeh SS Tool."
}

Add-ToolButton "Client Checker" 195 ([System.Drawing.Color]::MediumPurple) {
    $heading.Text = "Client Checker"
    $results.Clear()
    $results.AppendText("Checking Minecraft-related processes...`r`n`r`n")

    Get-Process -ErrorAction SilentlyContinue |
        Where-Object { $_.ProcessName -match "minecraft|java|lunar|badlion|feather" } |
        ForEach-Object {
            $results.AppendText("$($_.ProcessName) - PID $($_.Id)`r`n")
        }

    $results.AppendText("`r`nScan complete. Process names alone do not indicate cheating.")
}

Add-ToolButton "Macro Detector" 255 ([System.Drawing.Color]::DeepPink) {
    $heading.Text = "Macro Detector"
    $results.Clear()
    $results.AppendText("Checking known automation applications...`r`n`r`n")

    $patterns = "autohotkey|autoit|pulover|tinytask|macrorecorder"

    Get-Process -ErrorAction SilentlyContinue |
        Where-Object { $_.ProcessName -match $patterns } |
        ForEach-Object {
            $results.AppendText("Found: $($_.ProcessName)`r`n")
        }

    $results.AppendText("`r`nScan complete. This does not detect every macro or prove misuse.")
}

Add-ToolButton "Minecraft Mods" 315 ([System.Drawing.Color]::DarkCyan) {
    $heading.Text = "Minecraft Mods"
    $results.Clear()

    $modsPath = Join-Path $env:APPDATA ".minecraft\mods"

    if (Test-Path $modsPath) {
        Get-ChildItem $modsPath -Filter "*.jar" -File -ErrorAction SilentlyContinue |
            ForEach-Object {
                $results.AppendText("$($_.Name)`r`n")
            }
    }
    else {
        $results.Text = "Minecraft mods folder not found."
    }
}

Add-ToolButton "Running Processes" 375 ([System.Drawing.Color]::DarkOrange) {
    $heading.Text = "Running Processes"
    $results.Clear()

    Get-Process -ErrorAction SilentlyContinue |
        Sort-Object ProcessName |
        Select-Object -First 100 |
        ForEach-Object {
            $results.AppendText("$($_.ProcessName) - PID $($_.Id)`r`n")
        }
}

Add-ToolButton "System Info" 435 ([System.Drawing.Color]::SeaGreen) {
    $heading.Text = "System Information"
    $results.Text = "Windows: $([Environment]::OSVersion.VersionString)`r`nComputer: $env:COMPUTERNAME`r`nUser: $env:USERNAME"
}

Add-ToolButton "Export Results" 495 ([System.Drawing.Color]::SlateBlue) {
    $dialog = New-Object System.Windows.Forms.SaveFileDialog
    $dialog.Filter = "Text Files (*.txt)|*.txt"
    $dialog.FileName = "YungehSS-Report.txt"

    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        [System.IO.File]::WriteAllText($dialog.FileName,$results.Text)
        [System.Windows.Forms.MessageBox]::Show("Report saved successfully.")
    }
}

$consent = [System.Windows.Forms.MessageBox]::Show(
    "Only scan this computer with its owner's permission. Continue?",
    "Yungeh SS Tool",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

if ($consent -eq [System.Windows.Forms.DialogResult]::Yes) {
    [void][System.Windows.Forms.Application]::Run($form)
}
