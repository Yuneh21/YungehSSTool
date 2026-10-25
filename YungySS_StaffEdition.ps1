# Yungy SS Tool - original, permission-based local diagnostic dashboard
# Windows PowerShell 5.1. Read-only. No networking or uploads.
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()
function C([string]$hex) { [System.Drawing.ColorTranslator]::FromHtml($hex) }
$bg=C '#080D16'; $panel=C '#101827'; $tile=C '#17253B'; $blue=C '#238CFF'; $white=C '#EAF4FF'; $muted=C '#91A8C4'; $green=C '#68D9F8'
$script:permission=$false
$script:mainLog=$null
function WriteLog([string]$s) { if($script:mainLog){$script:mainLog.AppendText(('['+(Get-Date -Format 'HH:mm:ss')+'] '+$s+[Environment]::NewLine))} }
function L($parent,[string]$s,[int]$x,[int]$y,[int]$w,[int]$h,[int]$size,$color,[bool]$bold=$false){
 $v=New-Object System.Windows.Forms.Label; $v.Text=$s; $v.SetBounds($x,$y,$w,$h);$v.ForeColor=$color
 $style=[System.Drawing.FontStyle]::Regular;if($bold){$style=[System.Drawing.FontStyle]::Bold}
 $v.Font=New-Object System.Drawing.Font('Segoe UI',$size,$style);$parent.Controls.Add($v);return $v
}
function B($parent,[string]$s,[int]$x,[int]$y,[int]$w,[int]$h,$color){
 $v=New-Object System.Windows.Forms.Button;$v.Text=$s;$v.SetBounds($x,$y,$w,$h);$v.BackColor=$color;$v.ForeColor=$white
 $v.FlatStyle='Flat';$v.FlatAppearance.BorderSize=1;$v.FlatAppearance.BorderColor=(C '#29405E');$v.Cursor='Hand';$v.Font=New-Object System.Drawing.Font('Segoe UI Semibold',10,[System.Drawing.FontStyle]::Bold)
 $parent.Controls.Add($v);return $v
}
$script:detectors=[ordered]@{
 'Minecraft'=@('Minecraft Processes','Installed Minecraft Mods','Outside Mods Folder','Minecraft Versions','Minecraft Logs','Minecraft Crash Reports','Minecraft Resource Packs','Minecraft Shader Packs','Minecraft Config Files','Minecraft Launcher Profiles')
 'Macro Detectors'=@('Macro Software','Peripheral Software','Java Processes','Startup Entries','Scheduled Tasks','Running Services')
 'Windows'=@('Running Processes','System Information','Java Executables','Recent Downloads','Installed Applications','USB Device Names','System Uptime','Network Adapter Summary')
}
function Scan([string]$name){
 $out=New-Object 'System.Collections.Generic.List[string]'
 $out.Add('YUNGY SS TOOL  |  '+$name)
 $out.Add('Started: '+(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
 $out.Add('Results are indicators for review, not proof of cheating.')
 $out.Add('----------------------------------------------------')
 try {
  switch($name){
   'Minecraft Crash Reports' {
    $root=Join-Path $env:APPDATA '.minecraft\crash-reports'
    $out.Add('Crash report filenames only: '+$root)
    if(Test-Path -LiteralPath $root){foreach($a in @(Get-ChildItem -LiteralPath $root -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 40)){$out.Add(('  {0}  {1}' -f $a.LastWriteTime,$a.Name))}}else{$out.Add('Folder not found.')}
   }
   'Minecraft Resource Packs' {
    $root=Join-Path $env:APPDATA '.minecraft\resourcepacks'
    $out.Add('Resource pack names: '+$root)
    if(Test-Path -LiteralPath $root){foreach($a in @(Get-ChildItem -LiteralPath $root -ErrorAction SilentlyContinue | Select-Object -First 100)){$out.Add('  '+$a.Name)}}else{$out.Add('Folder not found.')}
   }
   'Minecraft Shader Packs' {
    $root=Join-Path $env:APPDATA '.minecraft\shaderpacks'
    $out.Add('Shader pack names: '+$root)
    if(Test-Path -LiteralPath $root){foreach($a in @(Get-ChildItem -LiteralPath $root -ErrorAction SilentlyContinue | Select-Object -First 100)){$out.Add('  '+$a.Name)}}else{$out.Add('Folder not found.')}
   }
   'Minecraft Config Files' {
    $root=Join-Path $env:APPDATA '.minecraft\config'
    $out.Add('Config filenames only: '+$root)
    if(Test-Path -LiteralPath $root){foreach($a in @(Get-ChildItem -LiteralPath $root -File -ErrorAction SilentlyContinue | Select-Object -First 100)){$out.Add('  '+$a.Name)}}else{$out.Add('Folder not found.')}
   }
   'Minecraft Launcher Profiles' {
    $root=Join-Path $env:APPDATA '.minecraft'
    foreach($n in @('launcher_profiles.json','launcher_profiles_microsoft_store.json','launcher_accounts.json')){
     $f=Join-Path $root $n
     if(Test-Path -LiteralPath $f){$out.Add('Present: '+$n)}else{$out.Add('Not found: '+$n)}
    }
    $out.Add('Profile contents and account details are not read.')
   }
   'Startup Entries' {
    foreach($root in @('HKCU:\Software\Microsoft\Windows\CurrentVersion\Run','HKLM:\Software\Microsoft\Windows\CurrentVersion\Run')){
     $out.Add('Registry: '+$root)
     if(Test-Path $root){$item=Get-ItemProperty -Path $root -ErrorAction SilentlyContinue;foreach($prop in @($item.PSObject.Properties | Where-Object {$_.Name -notmatch '^PS'} | Select-Object -First 60)){$out.Add('  '+$prop.Name)}}
    }
    $out.Add('Entry names only; values are not collected.')
   }
   'Scheduled Tasks' {
    if(Get-Command Get-ScheduledTask -ErrorAction SilentlyContinue){
     foreach($t in @(Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object {$_.TaskPath -notlike '\Microsoft*'} | Select-Object -First 80)){$out.Add(('  {0}  [{1}]' -f $t.TaskName,$t.State))}
    }else{$out.Add('Scheduled task cmdlet unavailable.')}
   }
   'Running Services' {
    foreach($v in @(Get-Service -ErrorAction SilentlyContinue | Where-Object {$_.Status -eq 'Running'} | Select-Object -First 100)){$out.Add('  '+$v.Name)}
   }
   'Recent Downloads' {
    $root=Join-Path $env:USERPROFILE 'Downloads'
    $out.Add('Recent filenames (not file contents): '+$root)
    if(Test-Path -LiteralPath $root){foreach($a in @(Get-ChildItem -LiteralPath $root -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 60)){$out.Add(('  {0}  {1}' -f $a.LastWriteTime,$a.Name))}}else{$out.Add('Folder not found.')}
   }
   'Installed Applications' {
    $roots=@('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*')
    $names=@(foreach($r in $roots){Get-ItemProperty -Path $r -ErrorAction SilentlyContinue | Where-Object {$_.DisplayName} | Select-Object -ExpandProperty DisplayName})
    foreach($n in @($names | Sort-Object -Unique | Select-Object -First 150)){$out.Add('  '+$n)}
   }
   'USB Device Names' {
    if(Get-Command Get-PnpDevice -ErrorAction SilentlyContinue){
     foreach($d in @(Get-PnpDevice -PresentOnly -ErrorAction SilentlyContinue | Where-Object {$_.Class -eq 'USB'} | Select-Object -First 80)){$out.Add('  '+$d.FriendlyName)}
    }else{$out.Add('PnP device cmdlet unavailable.')}
   }
   'System Uptime' {
    $os=Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
    if($os){$out.Add('Last boot: '+$os.LastBootUpTime);$out.Add('Uptime: '+((Get-Date)-$os.LastBootUpTime).ToString())}else{$out.Add('Uptime unavailable.')}
   }
   'Network Adapter Summary' {
    foreach($n in @(Get-NetAdapter -ErrorAction SilentlyContinue | Select-Object -First 40)){$out.Add(('  {0}  [{1}]' -f $n.Name,$n.Status))}
    $out.Add('No IP addresses, browsing history or network traffic collected.')
   }
   'Minecraft Processes' {
    $p=@(Get-Process -ErrorAction SilentlyContinue | Where-Object {$_.ProcessName -match 'javaw|java|minecraft|lunar|badlion|feather|prism|modrinth|curseforge'} | Sort-Object ProcessName)
    if(!$p.Count){$out.Add('No matching game/launcher process is currently running.')}
    foreach($a in $p){$out.Add(('FOUND  {0}  PID {1}' -f $a.ProcessName,$a.Id))}
   }
   'Installed Minecraft Mods' {
    $root=Join-Path $env:APPDATA '.minecraft\mods';$out.Add('IN MINECRAFT MODS: '+$root)
    if(Test-Path -LiteralPath $root){$f=@(Get-ChildItem -LiteralPath $root -File -Filter '*.jar' -ErrorAction SilentlyContinue | Select-Object -First 250);if(!$f.Count){$out.Add('No .jar files found.')};foreach($a in $f){$out.Add('  '+$a.Name)}}else{$out.Add('Folder not found.')}
   }
   'Outside Mods Folder' {
    $out.Add('NOT IN MINECRAFT MODS (selected locations only):')
    $roots=@([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Downloads'))
    foreach($root in $roots){
     $out.Add('Folder: '+$root)
     if(Test-Path -LiteralPath $root){$f=@(Get-ChildItem -LiteralPath $root -File -ErrorAction SilentlyContinue | Where-Object {$_.Extension -in @('.jar','.exe')} | Select-Object -First 100);if(!$f.Count){$out.Add('  No .jar/.exe files at this level.')};foreach($a in $f){$out.Add('  '+$a.Name)}}else{$out.Add('  Not available.')}
    }
    $out.Add('These are ordinary files, not confirmed cheats. Subfolders are not scanned.')
   }
   'Minecraft Versions' {
    $root=Join-Path $env:APPDATA '.minecraft\versions';$out.Add('Versions directory: '+$root)
    if(Test-Path -LiteralPath $root){foreach($a in @(Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue | Select-Object -First 100)){$out.Add('  '+$a.Name)}}else{$out.Add('Folder not found.')}
   }
   'Minecraft Logs' {
    $root=Join-Path $env:APPDATA '.minecraft\logs';$out.Add('Log filenames only: '+$root)
    if(Test-Path -LiteralPath $root){foreach($a in @(Get-ChildItem -LiteralPath $root -File -ErrorAction SilentlyContinue | Select-Object -First 50)){$out.Add('  '+$a.Name)}}else{$out.Add('Folder not found.')}
   }
   'Macro Software' {
    $pattern='autohotkey|autoit|tinytask|pulover|macrorecorder|macro|keyran'
    $p=@(Get-Process -ErrorAction SilentlyContinue | Where-Object {$_.ProcessName -match $pattern})
    if(!$p.Count){$out.Add('No matching known macro process names found.')}
    foreach($a in $p){$out.Add(('REVIEW  {0}  PID {1}' -f $a.ProcessName,$a.Id))}
    $out.Add('Macro software can have legitimate uses. No match does not mean no macros.')
   }
   'Peripheral Software' {
    $pattern='lghub|logioptions|razer|synapse|icue|steelseries|gg|ghub'
    $p=@(Get-Process -ErrorAction SilentlyContinue | Where-Object {$_.ProcessName -match $pattern})
    if(!$p.Count){$out.Add('No matching peripheral application names found.')}
    foreach($a in $p){$out.Add(('INFO  {0}  PID {1}' -f $a.ProcessName,$a.Id))}
    $out.Add('Peripheral apps are not evidence of cheating.')
   }
   'Java Processes' {
    $p=@(Get-Process -ErrorAction SilentlyContinue | Where-Object {$_.ProcessName -match '^javaw?$'})
    if(!$p.Count){$out.Add('No Java processes found.')}
    foreach($a in $p){$out.Add(('JAVA  {0}  PID {1}' -f $a.ProcessName,$a.Id))}
   }
   'Running Processes' {
    foreach($a in @(Get-Process -ErrorAction SilentlyContinue | Sort-Object ProcessName | Select-Object -First 150)){$out.Add(('{0,-30} PID {1}' -f $a.ProcessName,$a.Id))}
    $out.Add('Showing up to 150 running processes.')
   }
   'System Information' {
    $out.Add('Windows: '+[Environment]::OSVersion.VersionString)
    $out.Add('PowerShell: '+$PSVersionTable.PSVersion.ToString())
    $out.Add('64-bit OS: '+[Environment]::Is64BitOperatingSystem)
    $out.Add('Logical processors: '+[Environment]::ProcessorCount)
   }
   'Java Executables' {
    $commands=@(Get-Command java.exe,javaw.exe -ErrorAction SilentlyContinue)
    if(!$commands.Count){$out.Add('Java was not found on PATH.')}
    foreach($a in $commands){$out.Add('Java executable: '+$a.Source)}
   }
  }
 }catch{$out.Add('Scan error: '+$_.Exception.Message)}
 if($out.Count -le 4){$out.Add('No entries returned by this check.')}
 $out.Add('----------------------------------------------------')
 $out.Add('SCAN COMPLETE')
 return $out.ToArray()
}
function OpenDetector([string]$name){
 if(!$script:permission){
  $answer=[System.Windows.Forms.MessageBox]::Show('Do you own this PC or have its owner''s permission to run read-only diagnostics? No data is uploaded.','Permission required','YesNo','Question')
  if($answer -ne [System.Windows.Forms.DialogResult]::Yes){WriteLog 'Permission not granted. Scan cancelled.';return}
  $script:permission=$true
 }
 WriteLog ('Opening detector: '+$name)
 $win=New-Object System.Windows.Forms.Form;$win.Text='Yungy Scanner - '+$name;$win.Size=New-Object System.Drawing.Size(740,530);$win.MinimumSize=New-Object System.Drawing.Size(700,510)
 $win.StartPosition='CenterParent';$win.BackColor=(C '#070D18');$win.ForeColor=$white
 $null=L $win 'Y  /  YUNGY SCANNER' 22 16 650 37 19 $blue $true
 $null=L $win $name 24 57 610 25 11 $white
 $output=New-Object System.Windows.Forms.TextBox;$output.Multiline=$true;$output.ReadOnly=$true;$output.ScrollBars='Vertical'
 $output.BackColor=(C '#0C1523');$output.ForeColor=$green;$output.BorderStyle='None';$output.Font=New-Object System.Drawing.Font('Consolas',10)
 $output.SetBounds(23,107,635,280);$output.Anchor='Top,Left,Right,Bottom';$win.Controls.Add($output)
 $bar=New-Object System.Windows.Forms.ProgressBar;$bar.SetBounds(23,398,635,16);$bar.Anchor='Bottom,Left,Right';$bar.Style='Continuous';$bar.Maximum=100;$win.Controls.Add($bar)
 $save=B $win 'SAVE RESULTS' 23 424 155 35 $tile;$save.Anchor='Bottom,Left';$save.Enabled=$false
 $close=B $win 'CLOSE' 544 424 114 35 $blue;$close.Anchor='Bottom,Right';$close.Add_Click({$win.Close()})
 $save.Add_Click({
  $dlg=New-Object System.Windows.Forms.SaveFileDialog;$dlg.Filter='Text report (*.txt)|*.txt';$dlg.FileName='YungySS-Report.txt'
  if($dlg.ShowDialog($win) -eq [System.Windows.Forms.DialogResult]::OK){try{[System.IO.File]::WriteAllText($dlg.FileName,$output.Text);WriteLog 'Report saved locally.'}catch{[System.Windows.Forms.MessageBox]::Show($_.Exception.Message)}}
 })
 $output.AppendText('Scan collected. Displaying results...'+[Environment]::NewLine);$lines=@(Scan $name);$index=0
 $timer=New-Object System.Windows.Forms.Timer;$timer.Interval=35
 $timer.Add_Tick({
  if($win.IsDisposed){$timer.Stop();$timer.Dispose();return}
  $batch=0
  while($index -lt $lines.Count -and $batch -lt 6){$output.AppendText($lines[$index]+[Environment]::NewLine);$index++;$batch++}
  $bar.Value=[math]::Min(100,[int](100*$index/[math]::Max(1,$lines.Count)))
  if($index -ge $lines.Count){$timer.Stop();$save.Enabled=$true;WriteLog ('Finished: '+$name)}
 }.GetNewClosure())
 $win.Add_Shown({$timer.Start()}.GetNewClosure())
 $win.Add_FormClosed({$timer.Stop();$timer.Dispose()}.GetNewClosure())
 [void]$win.ShowDialog($form)
}
$form=New-Object System.Windows.Forms.Form;$form.Text='Yungy SS Tool  |  Staff Diagnostics';$form.Size=New-Object System.Drawing.Size(1050,710)
$form.MinimumSize=New-Object System.Drawing.Size(940,650);$form.StartPosition='CenterScreen';$form.BackColor=$bg
$side=New-Object System.Windows.Forms.Panel;$side.Dock='Left';$side.Width=215;$side.BackColor=$panel;$form.Controls.Add($side)
$null=L $side 'Y / YUNGY' 20 22 190 48 23 $blue $true
$null=L $side 'SS TOOL  /  STAFF EDITION' 22 72 190 25 9 $muted $true
$null=L $side 'CATEGORIES' 20 130 190 25 9 $blue $true
$right=New-Object System.Windows.Forms.Panel;$right.Dock='Fill';$right.BackColor=$bg;$form.Controls.Add($right);$side.BringToFront()
$top=New-Object System.Windows.Forms.Panel;$top.Dock='Top';$top.Height=102;$top.BackColor=$panel;$right.Controls.Add($top)
$script:pageTitle=L $top 'Minecraft' 26 14 760 48 22 $white $true
$null=L $top 'CHOOSE A CHECK  /  RESULTS OPEN IN A SEPARATE WINDOW' 28 65 770 28 9 $muted
$logPanel=New-Object System.Windows.Forms.Panel;$logPanel.Dock='Bottom';$logPanel.Height=164;$logPanel.BackColor=(C '#07101D');$right.Controls.Add($logPanel)
$null=L $logPanel 'YUNGY  /  ACTIVITY CONSOLE' 20 10 350 26 10 $blue $true
$script:mainLog=New-Object System.Windows.Forms.TextBox;$script:mainLog.Multiline=$true;$script:mainLog.ReadOnly=$true
$script:mainLog.ScrollBars='Vertical';$script:mainLog.Dock='Bottom';$script:mainLog.Height=128
$script:mainLog.BackColor=(C '#07101D');$script:mainLog.ForeColor=$green;$script:mainLog.BorderStyle='None'
$script:mainLog.Font=New-Object System.Drawing.Font('Consolas',9);$logPanel.Controls.Add($script:mainLog)
$body=New-Object System.Windows.Forms.FlowLayoutPanel;$body.Dock='Fill';$body.Padding=New-Object System.Windows.Forms.Padding(18)
$body.AutoScroll=$true;$body.BackColor=$bg;$right.Controls.Add($body);$body.BringToFront();$top.BringToFront();$logPanel.BringToFront()
function SetCategory([string]$category){
 $script:pageTitle.Text=$category;$body.Controls.Clear()
 foreach($detector in $script:detectors[$category]){
  $btn=B $body ('   '+$detector+'     >') 0 0 340 64 $tile
  $btn.Margin=New-Object System.Windows.Forms.Padding(7)
  $btn.Tag=$detector;$btn.Add_Click({param($sender,$e) OpenDetector ([string]$sender.Tag)})
 }
 WriteLog ('Selected category: '+$category)
}
$y=170
foreach($category in $script:detectors.Keys){
 $b=B $side $category 12 $y 188 48 $tile;$b.Tag=$category
 $b.Add_Click({param($sender,$e) SetCategory ([string]$sender.Tag)})
 $y+=60
}
$null=L $side '24 READ-ONLY CHECKS' 19 545 190 30 10 $green $true
$null=L $side 'Permission required.' 19 579 190 30 9 $muted
SetCategory 'Minecraft';WriteLog 'Yungy SS Tool ready.'
[void][System.Windows.Forms.Application]::Run($form)
