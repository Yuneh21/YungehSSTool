
# Yungeh SS Tool - Black & Blue Edition
# Local, read-only diagnostics. Windows PowerShell 5.1.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

function C([string]$hex) {
    [System.Drawing.ColorTranslator]::FromHtml($hex)
}

$bg = C '#090F1C'
$panel = C '#101D30'
$tile = C '#192C45'
$blue = C '#168BFF'
$white = C '#EFF7FF'
$muted = C '#A4B8D1'
$green = C '#73D7FF'

$script:permission = $false
$script:mainLog = $null

function WriteLog([string]$message) {
    if ($script:mainLog) {
        $script:mainLog.AppendText(
            "[$(Get-Date -Format 'HH:mm:ss')] $message`r`n"
        )
    }
}

function MakeLabel($parent, $text, $x, $y, $w, $h, $size, $color) {
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $text
    $label.SetBounds($x, $y, $w, $h)
    $label.ForeColor = $color
    $label.Font = New-Object System.Drawing.Font('Segoe UI', $size)
    $parent.Controls.Add($label)
    return $label
}

function MakeButton($parent, $text, $x, $y, $w, $h, $color) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $text
    $button.SetBounds($x, $y, $w, $h)
    $button.BackColor = $color
    $button.ForeColor = $white
    $button.FlatStyle = 'Flat'
    $button.FlatAppearance.BorderSize = 0
    $button.Cursor = 'Hand'
    $parent.Controls.Add($button)
    return $button
}

$script:detectors = [ordered]@{
    'Minecraft' = @(
        'Minecraft Processes',
        'Installed Minecraft Mods',
        'Outside Mods Folder',
        'Minecraft Versions',
        'Minecraft Logs'
    )
    'Macro Detectors' = @(
        'Macro Software',
        'Peripheral Software',
        'Java Processes'
    )
    'Windows' = @(
        'Running Processes',
        'System Information',
        'Java Executables'
    )
}

function Scan([string]$name) {
    $out = New-Object 'System.Collections.Generic.List[string]'
    $out.Add("YUNGEH SS TOOL | $name")
    $out.Add("Started: $(Get-Date)")
    $out.Add('Results are for review, not proof of cheating.')
    $out.Add('---------------------------------------------')

    try {
        switch ($name) {
            'Minecraft Processes' {
                $pattern = 'javaw|java|minecraft|lunar|badlion|feather|prism|modrinth|curseforge'
                $items = @(Get-Process -ErrorAction SilentlyContinue |
                    Where-Object { $_.ProcessName -match $pattern })

                if ($items.Count -eq 0) {
                    $out.Add('No matching processes found.')
                }

                foreach ($item in $items) {
                    $out.Add("FOUND: $($item.ProcessName) | PID $($item.Id)")
                }
            }

            'Installed Minecraft Mods' {
                $root = Join-Path $env:APPDATA '.minecraft\mods'
                $out.Add("IN MINECRAFT MODS: $root")

                if (Test-Path $root) {
                    $items = @(Get-ChildItem $root -Filter '*.jar' -File -ErrorAction SilentlyContinue)
                    if ($items.Count -eq 0) {
                        $out.Add('No JAR files found.')
                    }
                    foreach ($item in $items) {
                        $out.Add("FILE: $($item.Name)")
                    }
                } else {
                    $out.Add('Minecraft mods folder not found.')
                }
            }

            'Outside Mods Folder' {
                $out.Add('NOT IN MINECRAFT MODS:')
                $folders = @(
                    [Environment]::GetFolderPath('Desktop'),
                    (Join-Path $env:USERPROFILE 'Downloads')
                )

                foreach ($folder in $folders) {
                    $out.Add("Checking: $folder")
                    if (Test-Path $folder) {
                        $items = @(Get-ChildItem $folder -File -ErrorAction SilentlyContinue |
                            Where-Object { $_.Extension -in @('.jar', '.exe') } |
                            Select-Object -First 100)

                        foreach ($item in $items) {
                            $out.Add("FILE: $($item.FullName)")
                        }
                    }
                }
                $out.Add('Only selected folders were checked. Files are not automatically cheats.')
            }

            'Minecraft Versions' {
                $root = Join-Path $env:APPDATA '.minecraft\versions'
                if (Test-Path $root) {
                    Get-ChildItem $root -Directory -ErrorAction SilentlyContinue |
                        Select-Object -First 100 |
                        ForEach-Object { $out.Add($_.Name) }
                } else {
                    $out.Add('Versions folder not found.')
                }
            }

            'Minecraft Logs' {
                $root = Join-Path $env:APPDATA '.minecraft\logs'
                if (Test-Path $root) {
                    Get-ChildItem $root -File -ErrorAction SilentlyContinue |
                        Select-Object -First 50 |
                        ForEach-Object { $out.Add($_.Name) }
                } else {
                    $out.Add('Logs folder not found.')
                }
            }

            'Macro Software' {
                $pattern = 'autohotkey|autoit|tinytask|pulover|macrorecorder|keyran'
                $items = @(Get-Process -ErrorAction SilentlyContinue |
                    Where-Object { $_.ProcessName -match $pattern })

                if ($items.Count -eq 0) {
                    $out.Add('No matching macro software processes found.')
                }

                foreach ($item in $items) {
                    $out.Add("REVIEW: $($item.ProcessName) | PID $($item.Id)")
                }
                $out.Add('Macro software can have legitimate uses.')
            }

            'Peripheral Software' {
                $pattern = 'lghub|logioptions|razer|synapse|icue|steelseries'
                $items = @(Get-Process -ErrorAction SilentlyContinue |
                    Where-Object { $_.ProcessName -match $pattern })

                if ($items.Count -eq 0) {
                    $out.Add('No matching peripheral software found.')
                }

                foreach ($item in $items) {
                    $out.Add("INFO: $($item.ProcessName)")
                }
            }

            'Java Processes' {
                $items = @(Get-Process -ErrorAction SilentlyContinue |
                    Where-Object { $_.ProcessName -match '^javaw?$' })

                if ($items.Count -eq 0) {
                    $out.Add('No Java processes found.')
                }

                foreach ($item in $items) {
                    $out.Add("JAVA: $($item.ProcessName) | PID $($item.Id)")
                }
            }

            'Running Processes' {
                Get-Process -ErrorAction SilentlyContinue |
                    Sort-Object ProcessName |
                    Select-Object -First 150 |
                    ForEach-Object {
                        $out.Add("$($_.ProcessName) | PID $($_.Id)")
                    }
            }

            'System Information' {
                $out.Add("Windows: $([Environment]::OSVersion.VersionString)")
                $out.Add("PowerShell: $($PSVersionTable.PSVersion)")
                $out.Add("64-bit Windows: $([Environment]::Is64BitOperatingSystem)")
                $out.Add("Processors: $([Environment]::ProcessorCount)")
            }

            'Java Executables' {
                $items = @(Get-Command java.exe, javaw.exe -ErrorAction SilentlyContinue)
                if ($items.Count -eq 0) {
                    $out.Add('Java not found on PATH.')
                }
                foreach ($item in $items) {
                    $out.Add("JAVA: $($item.Source)")
                }
            }
        }
    } catch {
        $out.Add("ERROR: $($_.Exception.Message)")
    }

    $out.Add('---------------------------------------------')
    $out.Add('SCAN COMPLETE')
    return $out.ToArray()
}

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Yungeh SS Tool - Black & Blue'
$form.Size = New-Object System.Drawing.Size(1100, 740)
$form.MinimumSize = New-Object System.Drawing.Size(900, 650)
$form.StartPosition = 'CenterScreen'
$form.BackColor = $bg

$sidebar = New-Object System.Windows.Forms.Panel
$sidebar.Dock = 'Left'
$sidebar.Width = 230
$sidebar.BackColor = $panel
$form.Controls.Add($sidebar)

$null = MakeLabel $sidebar 'YUNGEH' 20 25 200 50 27 $blue
$null = MakeLabel $sidebar 'SS TOOL / DETECTORS' 22 80 200 30 10 $muted
$null = MakeLabel $sidebar 'CATEGORIES' 20 135 200 30 10 $blue

$main = New-Object System.Windows.Forms.Panel
$main.Dock = 'Fill'
$main.BackColor = $bg
$form.Controls.Add($main)
$main.BringToFront()

$header = New-Object System.Windows.Forms.Panel
$header.Dock = 'Top'
$header.Height = 105
$header.BackColor = $panel
$main.Controls.Add($header)

$script:pageTitle = MakeLabel $header 'Minecraft' 25 15 700 50 23 $white
$null = MakeLabel $header 'Click a detector to open its scanner window.' 27 70 750 25 10 $muted

$logPanel = New-Object System.Windows.Forms.Panel
$logPanel.Dock = 'Bottom'
$logPanel.Height = 180
$logPanel.BackColor = C '#07101D'
$main.Controls.Add($logPanel)

$null = MakeLabel $logPanel 'ACTIVITY CONSOLE' 18 8 300 28 11 $blue

$script:mainLog = New-Object System.Windows.Forms.TextBox
$script:mainLog.Multiline = $true
$script:mainLog.ReadOnly = $true
$script:mainLog.ScrollBars = 'Vertical'
$script:mainLog.Dock = 'Bottom'
$script:mainLog.Height = 145
$script:mainLog.BackColor = C '#07101D'
$script:mainLog.ForeColor = $green
$script:mainLog.BorderStyle = 'None'
$script:mainLog.Font = New-Object System.Drawing.Font('Consolas', 9)
$logPanel.Controls.Add($script:mainLog)

$body = New-Object System.Windows.Forms.FlowLayoutPanel
$body.Dock = 'Fill'
$body.Padding = New-Object System.Windows.Forms.Padding(20)
$body.AutoScroll = $true
$body.BackColor = $bg
$main.Controls.Add($body)
$body.BringToFront()
$header.BringToFront()
$logPanel.BringToFront()

function OpenDetector([string]$name) {
    if (-not $script:permission) {
        $answer = [System.Windows.Forms.MessageBox]::Show(
            "Do you own this PC or have the owner's permission to scan it?",
            'Permission Required',
            'YesNo',
            'Question'
        )

        if ($answer -ne [System.Windows.Forms.DialogResult]::Yes) {
            WriteLog 'Scan cancelled: permission not granted.'
            return
        }

        $script:permission = $true
    }

    WriteLog "Opening detector: $name"

    $win = New-Object System.Windows.Forms.Form
    $win.Text = "Yungeh Scanner - $name"
    $win.Size = New-Object System.Drawing.Size(700, 510)
    $win.StartPosition = 'CenterParent'
    $win.BackColor = C '#070D18'

    $null = MakeLabel $win 'YUNGEH / SCANNER' 22 16 620 40 19 $blue
    $null = MakeLabel $win $name 24 57 620 28 11 $white

    $output = New-Object System.Windows.Forms.TextBox
    $output.Multiline = $true
    $output.ReadOnly = $true
    $output.ScrollBars = 'Vertical'
    $output.BackColor = C '#070D18'
    $output.ForeColor = $green
    $output.BorderStyle = 'None'
    $output.Font = New-Object System.Drawing.Font('Consolas', 10)
    $output.SetBounds(23, 105, 635, 280)
    $output.Anchor = 'Top,Left,Right,Bottom'
    $win.Controls.Add($output)

    $bar = New-Object System.Windows.Forms.ProgressBar
    $bar.SetBounds(23, 398, 635, 16)
    $bar.Maximum = 100
    $bar.Style = 'Continuous'
    $bar.Anchor = 'Bottom,Left,Right'
    $win.Controls.Add($bar)

    $save = MakeButton $win 'SAVE RESULTS' 23 424 155 35 $tile
    $save.Enabled = $false
    $save.Anchor = 'Bottom,Left'

    $close = MakeButton $win 'CLOSE' 544 424 114 35 $blue
    $close.Anchor = 'Bottom,Right'
    $close.Add_Click({ $win.Close() }.GetNewClosure())

    $save.Add_Click({
        $dialog = New-Object System.Windows.Forms.SaveFileDialog
        $dialog.Filter = 'Text files (*.txt)|*.txt'
        $dialog.FileName = 'YungehSS-Report.txt'

        if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            [System.IO.File]::WriteAllText($dialog.FileName, $output.Text)
        }
    }.GetNewClosure())

    $lines = @(Scan $name)
    $index = 0

    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 50

    $timer.Add_Tick({
        if ($index -lt $lines.Count) {
            $output.AppendText($lines[$index] + "`r`n")
            $index++
            $bar.Value = [math]::Min(
                100,
                [int](100 * $index / [math]::Max(1, $lines.Count))
            )
        } else {
            $timer.Stop()
            $save.Enabled = $true
            WriteLog "Completed detector: $name"
        }
    }.GetNewClosure())

    $win.Add_Shown({ $timer.Start() }.GetNewClosure())
    $win.Add_FormClosed({
        $timer.Stop()
        $timer.Dispose()
    }.GetNewClosure())

    [void]$win.ShowDialog($form)
}

function SetCategory([string]$category) {
    $script:pageTitle.Text = $category
    $body.Controls.Clear()

    foreach ($detector in $script:detectors[$category]) {
        $button = MakeButton $body "$detector  >" 0 0 350 78 $tile
        $button.Margin = New-Object System.Windows.Forms.Padding(8)
        $button.Tag = $detector

        $button.Add_Click({
            param($sender, $eventArgs)
            OpenDetector ([string]$sender.Tag)
        })
    }

    WriteLog "Selected category: $category"
}

$y = 175

foreach ($category in $script:detectors.Keys) {
    $button = MakeButton $sidebar $category 16 $y 196 52 $tile
    $button.Tag = $category

    $button.Add_Click({
        param($sender, $eventArgs)
        SetCategory ([string]$sender.Tag)
    })

    $y += 65
}

$null = MakeLabel $sidebar 'READ-ONLY / LOCAL' 20 570 200 30 10 $green
$null = MakeLabel $sidebar 'Permission required' 20 605 200 25 9 $muted

SetCategory 'Minecraft'
WriteLog 'Yungeh SS Tool ready.'

[void][System.Windows.Forms.Application]::Run($form)
