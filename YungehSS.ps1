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
 $win=New-Object System.Windows.Forms.Form;$win.Text='Yungeh Scanner - '+$name;$win.Size=New-Object System.Drawing.Size(700,510)
 $win.StartPosition='CenterParent';$win.BackColor=(C '#070D18');$win.ForeColor=$white
 $null=L $win 'YUNGEH  /  SCANNER' 22 16 610 37 19 $blue $true
 $null=L $win $name 24 57 610 25 11 $white
 $output=New-Object System.Windows.Forms.TextBox;$output.Multiline=$true;$output.ReadOnly=$true;$output.ScrollBars='Vertical'
 $output.BackColor=(C '#070D18');$output.ForeColor=$green;$output.BorderStyle='None';$output.Font=New-Object System.Drawing.Font('Consolas',10)
 $output.SetBounds(23,107,635,280);$output.Anchor='Top,Left,Right,Bottom';$win.Controls.Add($output)
 $bar=New-Object System.Windows.Forms.ProgressBar;$bar.SetBounds(23,398,635,16);$bar.Anchor='Bottom,Left,Right';$bar.Style='Continuous';$bar.Maximum=100;$win.Controls.Add($bar)
 $save=B $win 'SAVE RESULTS' 23 424 155 35 $tile;$save.Anchor='Bottom,Left';$save.Enabled=$false
 $close=B $win 'CLOSE' 544 424 114 35 $blue;$close.Anchor='Bottom,Right';$close.Add_Click({$win.Close()})
 $save.Add_Click({
  $dlg=New-Object System.Windows.Forms.SaveFileDialog;$dlg.Filter='Text report (*.txt)|*.txt';$dlg.FileName='YungehSS-Report.txt'
  if($dlg.ShowDialog($win) -eq [System.Windows.Forms.DialogResult]::OK){try{[System.IO.File]::WriteAllText($dlg.FileName,$output.Text);WriteLog ('Saved report: '+$dlg.FileName)}catch{[System.Windows.Forms.MessageBox]::Show($_.Exception.Message)}}
 })
 $lines=@(Scan $name);$index=0
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
$form=New-Object System.Windows.Forms.Form;$form.Text='Yungeh SS Tool - Detector Hub';$form.Size=New-Object System.Drawing.Size(1120,750)
$form.MinimumSize=New-Object System.Drawing.Size(940,650);$form.StartPosition='CenterScreen';$form.BackColor=$bg
$side=New-Object System.Windows.Forms.Panel;$side.Dock='Left';$side.Width=230;$side.BackColor=$panel;$form.Controls.Add($side)
$null=L $side 'YUNGEH' 22 22 195 48 27 $blue $true
$null=L $side 'SS TOOL  /  DETECTORS' 24 72 200 25 9 $muted $true
$null=L $side 'CATEGORIES' 20 130 190 25 9 $blue $true
$right=New-Object System.Windows.Forms.Panel;$right.Dock='Fill';$right.BackColor=$bg;$form.Controls.Add($right);$right.BringToFront()
$top=New-Object System.Windows.Forms.Panel;$top.Dock='Top';$top.Height=112;$top.BackColor=$panel;$right.Controls.Add($top)
$script:pageTitle=L $top 'Minecraft' 26 20 760 48 23 $white $true
$null=L $top 'Choose a detector. Each one opens its own scan window.' 28 72 770 28 10 $muted
$logPanel=New-Object System.Windows.Forms.Panel;$logPanel.Dock='Bottom';$logPanel.Height=185;$logPanel.BackColor=(C '#07101D');$right.Controls.Add($logPanel)
$null=L $logPanel 'ACTIVITY CONSOLE' 20 10 350 26 10 $blue $true
$script:mainLog=New-Object System.Windows.Forms.TextBox;$script:mainLog.Multiline=$true;$script:mainLog.ReadOnly=$true
$script:mainLog.ScrollBars='Vertical';$script:mainLog.Dock='Bottom';$script:mainLog.Height=147
$script:mainLog.BackColor=(C '#07101D');$script:mainLog.ForeColor=$green;$script:mainLog.BorderStyle='None'
$script:mainLog.Font=New-Object System.Drawing.Font('Consolas',9);$logPanel.Controls.Add($script:mainLog)
$body=New-Object System.Windows.Forms.FlowLayoutPanel;$body.Dock='Fill';$body.Padding=New-Object System.Windows.Forms.Padding(22)
$body.AutoScroll=$true;$body.BackColor=$bg;$right.Controls.Add($body);$body.BringToFront();$top.BringToFront();$logPanel.BringToFront()
function SetCategory([string]$category){
 $script:pageTitle.Text=$category;$body.Controls.Clear()
 foreach($detector in $script:detectors[$category]){
  $btn=B $body ($detector+'   >') 0 0 355 82 $tile
  $btn.Margin=New-Object System.Windows.Forms.Padding(8)
  $btn.Tag=$detector;$btn.Add_Click({param($sender,$e) OpenDetector ([string]$sender.Tag)})
 }
 WriteLog ('Selected category: '+$category)
}
$y=170
foreach($category in $script:detectors.Keys){
 $b=B $side $category 16 $y 196 52 $tile;$b.Tag=$category
 $b.Add_Click({param($sender,$e) SetCategory ([string]$sender.Tag)})
 $y+=65
}
$null=L $side 'READ-ONLY • LOCAL' 19 560 200 30 10 $green $true
$null=L $side 'Permission required.`nNo automatic uploads.' 19 594 200 55 9 $muted
SetCategory 'Minecraft';WriteLog 'Yungeh SS Tool ready.'
[void][System.Windows.Forms.Application]::Run($form)
