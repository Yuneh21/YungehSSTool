$null=Label $header 'Local diagnostic toolkit  •  Permission required' 26 56 650 22 10 $muted
$status=Label $header '●  READY' 795 30 140 30 11 $accent $true
$console=New-Object System.Windows.Forms.TextBox; $console.Multiline=$true; $console.ReadOnly=$true
$console.ScrollBars='Vertical'; $console.BackColor=Color '#080D17'; $console.ForeColor=Color '#A9F3DF'
$console.BorderStyle='None'; $console.Font=New-Object System.Drawing.Font('Consolas',9)
$console.Dock='Bottom'; $console.Height=130; $main.Controls.Add($console)
$workspace=New-Object System.Windows.Forms.Panel; $workspace.Dock='Fill'; $workspace.BackColor=$bg; $workspace.AutoScroll=$true
$main.Controls.Add($workspace); $workspace.BringToFront()
$console.BringToFront(); $header.BringToFront()
function Log([string]$msg) { $console.AppendText(('['+(Get-Date -Format 'HH:mm:ss')+'] '+$msg+[Environment]::NewLine)) }
$null=Label $sidebar 'CATEGORIES' 22 245 175 23 9 $accent $true
$nav=@{}
$categories=@('Overview','Client Checker','Macro Detector','Minecraft Mods','Running Processes','System Info')
$navY=275
foreach($name in $categories) {
 $btn=Button $sidebar $name 14 $navY 181 42 $card $white; $nav[$name]=$btn; $navY+=50
}
$export=Button $sidebar 'Export current report' 14 190 181 40 (Color '#234D5D') $white
$null=Label $sidebar 'READ-ONLY MODE' 22 615 175 22 9 $accent $true
$null=Label $sidebar 'No hidden scans, uploads,`nor file changes.' 22 638 180 50 9 $muted
$script:lastReport='No scan has been run.'
$script:current='Overview'
$script:consent=$false
$script:scanButton=$null
$script:resultBox=$null
$script:pageTitle=$null
$script:pageDesc=$null
$script:tiles=@()
function CheckConsent {
 if($script:consent){return $true}
 $choice=[System.Windows.Forms.MessageBox]::Show('Run read-only diagnostics on this computer? Only scan devices you own or have permission to inspect. No information is uploaded.','Permission to scan','YesNo','Question')
 if($choice -eq [System.Windows.Forms.DialogResult]::Yes){$script:consent=$true;return $true}; return $false
}
function GetScan([string]$name) {
 $lines=New-Object 'System.Collections.Generic.List[string]'
 $lines.Add('YUNGEH SS TOOL  |  '+$name)
 $lines.Add('Time: '+(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
 $lines.Add('Informational results only; not proof of cheating.')
 $lines.Add('-------------------------------------------------------')
 try {
  switch($name) {
   'Client Checker' {
    $pattern='minecraft|javaw|lunar|badlion|prism|multimc|feather|curseforge|modrinth'
    $p=@(Get-Process -ErrorAction SilentlyContinue | Where-Object {$_.ProcessName -match $pattern} | Sort-Object ProcessName)
    if(!$p.Count){$lines.Add('No matching launcher/game processes found.')}
    foreach($v in $p){$lines.Add(('INFO  {0}  PID {1}' -f $v.ProcessName,$v.Id))}
   }
   'Macro Detector' {
    $pattern='autohotkey|autoit|pulover|tinytask|macro|logioptions|lghub|razer|synapse|icue'
    $p=@(Get-Process -ErrorAction SilentlyContinue | Where-Object {$_.ProcessName -match $pattern} | Sort-Object ProcessName)
    if(!$p.Count){$lines.Add('No known macro/automation processes matched.')}
    foreach($v in $p){$lines.Add(('REVIEW  {0}  PID {1}' -f $v.ProcessName,$v.Id))}
    $lines.Add('Note: macro software has legitimate uses; this is not a cheat verdict.')
   }
   'Minecraft Mods' {
    $roots=@((Join-Path $env:APPDATA '.minecraft\mods'),(Join-Path $env:APPDATA '.minecraft\versions'))
    foreach($root in $roots){
     $lines.Add('Folder: '+$root)
     if(Test-Path -LiteralPath $root){
      $items=@(Get-ChildItem -LiteralPath $root -File -ErrorAction SilentlyContinue | Select-Object -First 120)
      if(!$items.Count){$lines.Add('  No files at this level.')}
      foreach($f in $items){$lines.Add('  '+$f.Name)}
     } else {$lines.Add('  Not found.')}
    }
   }
   'Running Processes' {
    $p=@(Get-Process -ErrorAction SilentlyContinue | Sort-Object ProcessName | Select-Object -First 100)
    foreach($v in $p){$lines.Add(('{0,-30} PID {1}' -f $v.ProcessName,$v.Id))}
    $lines.Add('First 100 processes shown.')
   }
   'System Info' {
    $lines.Add('Computer: '+$env:COMPUTERNAME)
    $lines.Add('Windows: '+[Environment]::OSVersion.VersionString)
    $lines.Add('PowerShell: '+$PSVersionTable.PSVersion.ToString())
    $lines.Add('Architecture: '+[Environment]::Is64BitOperatingSystem)
    $lines.Add('Logical processors: '+[Environment]::ProcessorCount)
   }
   default {$lines.Add('Select a category to begin.')}
  }
 } catch {$lines.Add('Scan error: '+$_.Exception.Message)}
 return ($lines -join [Environment]::NewLine)
}
function SetPage([string]$name) {
 $script:current=$name; $workspace.Controls.Clear()
 foreach($k in $nav.Keys){$nav[$k].BackColor=$card; $nav[$k].ForeColor=$white}
 $nav[$name].BackColor=Color '#14596C'; $nav[$name].ForeColor=$white
 $script:pageTitle=Label $workspace $name 26 24 700 44 22 $white $true
 if($name -eq 'Overview') {
  $null=Label $workspace 'Choose a diagnostic category to open its scan page.' 28 73 780 26 11 $muted
  $items=@(
   @('Client Checker','Game and launcher processes'),@('Macro Detector','Known automation applications'),
   @('Minecraft Mods','Local Minecraft files'),@('Running Processes','Active applications'),@('System Info','Basic device information'))
  $i=0
  foreach($item in $items) {
   $col=$i%2; $row=[math]::Floor($i/2)
   $x=28+($col*365); $y=122+($row*110)
   $tile=Button $workspace ($item[0]+'   >') $x $y 344 90 $card $white
   $tile.Tag=$item[0]
   $tile.Add_Click({param($sender,$args) SetPage ([string]$sender.Tag)})
   $i++
  }
 } else {
  $desc=@{'Client Checker'='Checks common Minecraft and launcher process names.';'Macro Detector'='Looks for known macro or automation process names.';'Minecraft Mods'='Lists local Minecraft mod and version files.';'Running Processes'='Shows a snapshot of running processes.';'System Info'='Displays basic Windows system information.'}[$name]
  $null=Label $workspace $desc 28 73 810 28 11 $muted
  $scan=Button $workspace '▶  START SCAN' 28 120 185 47 (Color '#0F9EAE') $white
  $scan.Add_Click({
   if(!(CheckConsent)){Log 'Scan cancelled: permission not granted.';return}
   $status.Text='●  SCANNING'; $form.Refresh(); Log ('Scanning '+$script:current+'...')
   $script:lastReport=GetScan $script:current
   $script:resultBox.Text=$script:lastReport
   $status.Text='●  COMPLETE'; Log ('Completed '+$script:current)
  })
  $script:resultBox=New-Object System.Windows.Forms.TextBox
  $script:resultBox.Multiline=$true; $script:resultBox.ReadOnly=$true; $script:resultBox.ScrollBars='Both'
  $script:resultBox.WordWrap=$false; $script:resultBox.BackColor=$card; $script:resultBox.ForeColor=$white
  $script:resultBox.BorderStyle='FixedSingle'; $script:resultBox.Font=New-Object System.Drawing.Font('Consolas',10)
  $script:resultBox.Location=New-Object System.Drawing.Point(28,188)
  $script:resultBox.Size=New-Object System.Drawing.Size(740,325)
  $script:resultBox.Anchor='Top,Left,Right,Bottom'
  $workspace.Controls.Add($script:resultBox)
  $null=Label $workspace 'Results are local. Matches are not evidence of rule-breaking.' 28 520 740 24 9 $muted
 }
}
foreach($name in $categories){$nav[$name].Tag=$name; $nav[$name].Add_Click({param($sender,$args) SetPage ([string]$sender.Tag)})}
$export.Add_Click({
 if($script:lastReport -eq 'No scan has been run.') {[System.Windows.Forms.MessageBox]::Show('Run a scan before exporting.');return}
 $dlg=New-Object System.Windows.Forms.SaveFileDialog; $dlg.Filter='Text report (*.txt)|*.txt'; $dlg.FileName='YungehSS-Report.txt'
 if($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
