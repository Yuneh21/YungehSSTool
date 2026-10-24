# Yungeh SS Tool - original read-only diagnostics
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()
$script:report = New-Object System.Collections.Generic.List[string]
$bg=[System.Drawing.Color]::FromArgb(16,20,32)
$panel=[System.Drawing.Color]::FromArgb(25,32,49)
$accent=[System.Drawing.Color]::FromArgb(63,157,255)
$fg=[System.Drawing.Color]::FromArgb(235,241,250)
$form=New-Object System.Windows.Forms.Form
$form.Text='Yungeh SS Tool | Diagnostics'
$form.Size=New-Object System.Drawing.Size(960,610)
$form.StartPosition='CenterScreen'
$form.BackColor=$bg
$form.ForeColor=$fg
$form.Font=New-Object System.Drawing.Font('Segoe UI',10)
$form.MinimumSize=New-Object System.Drawing.Size(820,520)
$side=New-Object System.Windows.Forms.Panel
$side.Dock='Left'; $side.Width=235; $side.BackColor=$panel
$form.Controls.Add($side)
$brand=New-Object System.Windows.Forms.Label
$brand.Text='YUNGEH  /  SS TOOL'; $brand.Font=New-Object System.Drawing.Font('Segoe UI',14,[System.Drawing.FontStyle]::Bold)
$brand.ForeColor=$accent; $brand.Location=New-Object System.Drawing.Point(20,25); $brand.Size=New-Object System.Drawing.Size(210,38)
$side.Controls.Add($brand)
$subtitle=New-Object System.Windows.Forms.Label
$subtitle.Text='Local read-only diagnostics'; $subtitle.ForeColor=[System.Drawing.Color]::LightGray
$subtitle.Location=New-Object System.Drawing.Point(20,66); $subtitle.AutoSize=$true
$side.Controls.Add($subtitle)
$content=New-Object System.Windows.Forms.Panel
$content.Dock='Fill'; $content.Padding=New-Object System.Windows.Forms.Padding(24)
$form.Controls.Add($content)
$content.BringToFront()
$title=New-Object System.Windows.Forms.Label
$title.Text='Dashboard'; $title.Font=New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]::Bold)
$title.Location=New-Object System.Drawing.Point(25,25); $title.Size=New-Object System.Drawing.Size(650,46)
$content.Controls.Add($title)
$desc=New-Object System.Windows.Forms.Label
$desc.Text='Choose a check from the left. Results are not proof of cheating.'
$desc.ForeColor=[System.Drawing.Color]::LightGray; $desc.Location=New-Object System.Drawing.Point(27,76); $desc.Size=New-Object System.Drawing.Size(650,43)
$content.Controls.Add($desc)
$output=New-Object System.Windows.Forms.TextBox
$output.Multiline=$true; $output.ReadOnly=$true; $output.ScrollBars='Vertical'
$output.BackColor=[System.Drawing.Color]::FromArgb(20,27,42); $output.ForeColor=$fg
$output.BorderStyle='None'; $output.Font=New-Object System.Drawing.Font('Consolas',10)
$output.Location=New-Object System.Drawing.Point(26,130); $output.Size=New-Object System.Drawing.Size(650,345)
$output.Anchor='Top,Bottom,Left,Right'
$content.Controls.Add($output)
$script:consented=$false
function Show-Results([string]$heading,[string[]]$lines) {
    $title.Text=$heading
    $output.Lines=@($lines)
    $script:report.Add(('=== '+$heading+' ==='))
    foreach($line in $lines){$script:report.Add($line)}
    $script:report.Add('')
}
function Require-Consent {
    if($script:consented){return $true}
    [System.Windows.Forms.MessageBox]::Show('The computer owner must agree before any diagnostics run.','Consent required','OK','Information') | Out-Null
    return $false
}
function Run-Check([string]$key) {
    if(-not (Require-Consent)){return}
    try {
        switch($key){
            'client' {
                $items=@(Get-CimInstance Win32_Process | Where-Object { $_.Name -match 'javaw?|minecraft|lunar|badlion|feather|prism|multimc' } | Select-Object -ExpandProperty Name -Unique)
                $lines=@('Recognized Minecraft/Java processes:')+$(if($items.Count){$items}else{'None found.'})+@('','A client name alone does not indicate cheating.')
                Show-Results 'Yungeh Client Checker' $lines
            }
            'macro' {
                $names=@(Get-Process | Where-Object {$_.ProcessName -match 'autohotkey|autoit|pulover|tinytask|macro|logitech|razer|steelseries'} | Select-Object -ExpandProperty ProcessName -Unique)
                $lines=@('Potential automation or peripheral utilities:')+$(if($names.Count){$names}else{'No matching processes found.'})+@('','These tools can have legitimate uses. This is not a behavioral macro detector.')
                Show-Results 'Macro Detector' $lines
            }
            'mods' {
                $dirs=@((Join-Path $env:APPDATA '.minecraft\mods'),(Join-Path $env:APPDATA '.minecraft\versions'))
                $lines=New-Object System.Collections.Generic.List[string]
                foreach($dir in $dirs){
                    $lines.Add('Folder: '+$dir)
                    if(Test-Path $dir){
                        $files=@(Get-ChildItem -LiteralPath $dir -File -ErrorAction SilentlyContinue | Select-Object -First 100 -ExpandProperty Name)
                        if($files.Count){foreach($f in $files){$lines.Add('  '+$f)}}else{$lines.Add('  No files at top level.')}
                    }else{$lines.Add('  Not found.')}
                    $lines.Add('')
                }
                Show-Results 'Minecraft Files' $lines.ToArray()
            }
            'system' {
                $os=Get-CimInstance Win32_OperatingSystem
                Show-Results 'System Information' @('Computer: '+$env:COMPUTERNAME,'Windows: '+$os.Caption,'Version: '+$os.Version,'Current user: '+$env:USERNAME,'','No data is uploaded.')
            }
            'export' {
                if($script:report.Count -eq 0){Show-Results 'Export Report' @('Run a check first, then export.');return}
                $dialog=New-Object System.Windows.Forms.SaveFileDialog
                $dialog.Filter='Text report (*.txt)|*.txt'; $dialog.FileName='YungehSS-report.txt'
                if($dialog.ShowDialog() -eq 'OK'){
                    [System.IO.File]::WriteAllLines($dialog.FileName,$script:report.ToArray())
                    Show-Results 'Report Saved' @('Saved to: '+$dialog.FileName,'No automatic upload occurred.')
                }
            }
        }
    } catch {
        Show-Results 'Check Failed' @($_.Exception.Message,'Try running with standard user permissions first.')
    }
}
$buttons=@(
    @('Client Checker','client'),
    @('Macro Detector','macro'),
    @('Minecraft Files','mods'),
    @('System Information','system'),
    @('Export Report','export')
)
$y=128
foreach($entry in $buttons){
    $btn=New-Object System.Windows.Forms.Button
    $btn.Text=$entry[0]; $btn.Tag=$entry[1]
    $btn.Size=New-Object System.Drawing.Size(195,48)
    $btn.Location=New-Object System.Drawing.Point(18,$y)
    $btn.FlatStyle='Flat'; $btn.FlatAppearance.BorderSize=0
    $btn.BackColor=[System.Drawing.Color]::FromArgb(36,47,69)
    $btn.ForeColor=$fg; $btn.Cursor='Hand'
    $btn.Add_Click({Run-Check ([string]$this.Tag)})
    $side.Controls.Add($btn); $y+=60
}
$output.Text="Welcome to Yungeh SS Tool.`r`n`r`nLocal diagnostics only. No uploads, hidden scans, or automatic punishments.`r`n`r`nSelect a check from the sidebar."
$answer=[System.Windows.Forms.MessageBox]::Show('Only continue if you own this computer or its owner has explicitly agreed to these read-only checks. No results are uploaded. Continue?','Yungeh SS Tool - Permission','YesNo','Question')
if($answer -eq [System.Windows.Forms.DialogResult]::Yes){$script:consented=$true;[System.Windows.Forms.Application]::Run($form)}
