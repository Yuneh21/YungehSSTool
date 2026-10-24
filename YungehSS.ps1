# Yungeh SS Tool - local, consent-based diagnostics
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()
$bg=[Drawing.Color]::FromArgb(12,18,30)
$panel=[Drawing.Color]::FromArgb(19,29,45)
$accent=[Drawing.Color]::FromArgb(55,181,245)
$fg=[Drawing.Color]::FromArgb(225,237,248)
function New-Label($text,$x,$y,$w,$h,$size=10,$color=$fg) {
 $l=New-Object Windows.Forms.Label; $l.Text=$text; $l.Location=New-Object Drawing.Point($x,$y); $l.Size=New-Object Drawing.Size($w,$h); $l.Font=New-Object Drawing.Font('Segoe UI',$size); $l.ForeColor=$color; return $l
}
function New-Button($text,$x,$y,$w,$h) {
 $b=New-Object Windows.Forms.Button; $b.Text=$text; $b.Location=New-Object Drawing.Point($x,$y); $b.Size=New-Object Drawing.Size($w,$h); $b.FlatStyle='Flat'; $b.FlatAppearance.BorderColor=$accent; $b.BackColor=$panel; $b.ForeColor=$fg; $b.Font=New-Object Drawing.Font('Segoe UI',10); return $b
}
$welcome=New-Object Windows.Forms.Form
$welcome.Text='Yungeh SS Tool | Consent'; $welcome.Size=New-Object Drawing.Size(700,450); $welcome.StartPosition='CenterScreen'; $welcome.BackColor=$bg; $welcome.ForeColor=$fg; $welcome.FormBorderStyle='FixedDialog'; $welcome.MaximizeBox=$false
$welcome.Controls.Add((New-Label 'YUNGEH  /  SS TOOL' 28 25 620 45 22 $accent))
$welcome.Controls.Add((New-Label 'BEFORE YOU BEGIN' 30 85 620 30 13 $fg))
$welcome.Controls.Add((New-Label "This application provides local, read-only Minecraft and Windows diagnostics.`r`n`r`nOnly use it with the computer owner's permission. No files are uploaded.`r`nReports are saved only when you choose to save them.`r`n`r`nYou may decline and close the application without running checks." 30 130 625 170 11 $fg))
$accept=New-Button 'ACCEPT & CONTINUE' 350 340 295 45; $accept.BackColor=[Drawing.Color]::FromArgb(18,87,133)
$cancel=New-Button 'CANCEL' 30 340 295 45
$cancel.Add_Click({$welcome.DialogResult='Cancel';$welcome.Close()})
$accept.Add_Click({$welcome.DialogResult='OK';$welcome.Close()})
$welcome.Controls.AddRange(@($accept,$cancel))
if($welcome.ShowDialog() -ne [Windows.Forms.DialogResult]::OK){return}
$form=New-Object Windows.Forms.Form
$form.Text='Yungeh SS Tool'; $form.Size=New-Object Drawing.Size(980,650); $form.MinimumSize=New-Object Drawing.Size(900,600); $form.StartPosition='CenterScreen'; $form.BackColor=$bg; $form.ForeColor=$fg
$sidebar=New-Object Windows.Forms.Panel; $sidebar.Dock='Left'; $sidebar.Width=245; $sidebar.BackColor=$panel; $form.Controls.Add($sidebar)
$sidebar.Controls.Add((New-Label 'YUNGEH' 20 25 210 35 21 $accent))
$sidebar.Controls.Add((New-Label 'SS TOOL  |  v3.0' 22 63 205 25 10 $fg))
$heading=New-Label 'Dashboard' 280 30 650 48 23 $accent; $form.Controls.Add($heading)
$output=New-Object Windows.Forms.TextBox; $output.Location=New-Object Drawing.Point(280,100); $output.Size=New-Object Drawing.Size(655,450); $output.Anchor='Top,Bottom,Left,Right'; $output.Multiline=$true; $output.ReadOnly=$true; $output.ScrollBars='Both'; $output.WordWrap=$false; $output.BackColor=$panel; $output.ForeColor=$fg; $output.BorderStyle='FixedSingle'; $output.Font=New-Object Drawing.Font('Consolas',10); $form.Controls.Add($output)
$script:lastReport='Yungeh SS Tool - Local Diagnostics'
function Display-Result($title,$result){$heading.Text=$title;$output.Text=([string]$result);$script:lastReport="YUNGEH SS TOOL`r`n$title`r`nCreated: $(Get-Date)`r`n`r`n$result"}
$items=@('Dashboard','Minecraft Processes','Java Processes','Minecraft Folders','Mod File Names','Log File Names','System Information','Java Installations','Network Summary','Save Report')
for($i=0;$i -lt $items.Count;$i++){
 $name=$items[$i]; $btn=New-Button $name 15 (112+$i*46) 215 39; $sidebar.Controls.Add($btn)
 $btn.Add_Click({
  switch($name){
   'Dashboard' {Display-Result 'Dashboard' "Welcome to Yungeh SS Tool.`r`n`r`nSelect a category on the left to inspect local diagnostics.`r`nNo checks run until you select a category."}
   'Minecraft Processes' { $p=Get-Process -ErrorAction SilentlyContinue | Where-Object {$_.ProcessName -match 'minecraft|lunar|badlion|prismlauncher'} | Select-Object ProcessName,Id; Display-Result $name ($p|Out-String) }
   'Java Processes' { $p=Get-Process -ErrorAction SilentlyContinue | Where-Object {$_.ProcessName -match '^java|^javaw'} | Select-Object ProcessName,Id; Display-Result $name ($p|Out-String) }
   'Minecraft Folders' { $paths=@("$env:APPDATA\.minecraft","$env:USERPROFILE\.lunarclient","$env:APPDATA\.minecraft\mods"); Display-Result $name (($paths|ForEach-Object {"$_ : $(Test-Path $_)"}) -join "`r`n") }
   'Mod File Names' { $path="$env:APPDATA\.minecraft\mods"; $r=if(Test-Path $path){Get-ChildItem -LiteralPath $path -File -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name | Out-String}else{'Default mods folder not found.'}; Display-Result $name $r }
   'Log File Names' { $path="$env:APPDATA\.minecraft\logs"; $r=if(Test-Path $path){Get-ChildItem -LiteralPath $path -File -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name | Out-String}else{'Default logs folder not found.'}; Display-Result $name $r }
   'System Information' {Display-Result $name ([PSCustomObject]@{Computer=$env:COMPUTERNAME;Windows=[Environment]::OSVersion.VersionString;PowerShell=$PSVersionTable.PSVersion.ToString()} | Format-List | Out-String)}
   'Java Installations' { $r=Get-Command java -All -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source -Unique | Out-String; Display-Result $name $r }
   'Network Summary' { $r=Get-NetAdapter -ErrorAction SilentlyContinue | Select-Object Name,Status,LinkSpeed | Out-String; Display-Result $name $r }
   'Save Report' { $dialog=New-Object Windows.Forms.SaveFileDialog; $dialog.Filter='Text report (*.txt)|*.txt';$dialog.FileName='Yungeh_SS_Report.txt'; if($dialog.ShowDialog() -eq 'OK'){[IO.File]::WriteAllText($dialog.FileName,$script:lastReport);[Windows.Forms.MessageBox]::Show('Report saved.','Yungeh SS Tool')}; }
  }
 }.GetNewClosure())
}
Display-Result 'Dashboard' "Welcome to Yungeh SS Tool.`r`n`r`nSelect a category on the left to inspect local diagnostics.`r`nNo checks run until you select a category."
[void]$form.ShowDialog()
