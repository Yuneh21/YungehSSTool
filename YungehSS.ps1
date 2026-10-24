# Yungeh SS Tool - original, local-only diagnostic dashboard
# Windows PowerShell 5.1 / Windows Forms. No external downloads or uploads.
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

function Color([string]$hex) { return [System.Drawing.ColorTranslator]::FromHtml($hex) }
$bg=(Color '#0B1020'); $panel=(Color '#111A2D'); $card=(Color '#17243A'); $accent=(Color '#39C6D6'); $muted=(Color '#91A3BA'); $white=(Color '#E9F4FF'); $border=(Color '#2B3D58')
$form=New-Object System.Windows.Forms.Form
$form.Text='Yungeh SS Tool | Diagnostic Dashboard'; $form.Size=New-Object System.Drawing.Size(1190,780)
$form.MinimumSize=New-Object System.Drawing.Size(1050,700); $form.StartPosition='CenterScreen'; $form.BackColor=$bg
$form.Font=New-Object System.Drawing.Font('Segoe UI',9)

function Label($parent,$text,$x,$y,$w,$h,$size,$color,$bold=$false) {
 $l=New-Object System.Windows.Forms.Label; $l.Text=$text; $l.Location=New-Object System.Drawing.Point($x,$y)
 $l.Size=New-Object System.Drawing.Size($w,$h); $l.ForeColor=$color
 $style=[System.Drawing.FontStyle]::Regular; if($bold){$style=[System.Drawing.FontStyle]::Bold}
 $l.Font=New-Object System.Drawing.Font('Segoe UI',$size,$style); $parent.Controls.Add($l); return $l
}
function Button($parent,$text,$x,$y,$w,$h,$background,$foreground) {
 $b=New-Object System.Windows.Forms.Button; $b.Text=$text; $b.Location=New-Object System.Drawing.Point($x,$y)
 $b.Size=New-Object System.Drawing.Size($w,$h); $b.FlatStyle='Flat'; $b.FlatAppearance.BorderSize=0
 $b.BackColor=$background; $b.ForeColor=$foreground; $b.Cursor='Hand'; $b.Font=New-Object System.Drawing.Font('Segoe UI',9,[System.Drawing.FontStyle]::Bold)
 $parent.Controls.Add($b); return $b
}
$sidebar=New-Object System.Windows.Forms.Panel; $sidebar.BackColor=$panel; $sidebar.Dock='Left'; $sidebar.Width=210; $form.Controls.Add($sidebar)
$logo=(Label $sidebar 'Y  /  SS' 23 25 170 48 25 $accent $true)
$null=(Label $sidebar 'YUNGEH DIAGNOSTICS' 24 75 180 24 9 $muted $true)
$null=(Label $sidebar 'ACTIONS' 22 143 170 22 9 $accent $true)
$main=New-Object System.Windows.Forms.Panel; $main.Dock='Fill'; $main.BackColor=$bg; $form.Controls.Add($main); $main.BringToFront()
$header=New-Object System.Windows.Forms.Panel; $header.BackColor=$panel; $header.Dock='Top'; $header.Height=92; $main.Controls.Add($header)
$null=(Label $header 'YUNGEH  /  SS TOOL' 24 16 500 38 21 $white $true)
$null=(Label $header 'Local diagnostic toolkit  •  Permission required' 26 56 650 22 10 $muted)
$status=(Label $header '●  READY' 795 30 140 30 11 $accent $true)
$console=New-Object System.Windows.Forms.TextBox; $console.Multiline=$true; $console.ReadOnly=$true
$console.ScrollBars='Vertical'; $console.BackColor=(Color '#080D17'); $console.ForeColor=(Color '#A9F3DF')
$console.BorderStyle='None'; $console.Font=New-Object System.Drawing.Font('Consolas',9)
$console.Dock='Bottom'; $console.Height=130; $main.Controls.Add($console)
$workspace=New-Object System.Windows.Forms.Panel; $workspace.Dock='Fill'; $workspace.BackColor=$bg; $workspace.AutoScroll=$true
$main.Controls.Add($workspace); $workspace.BringToFront()
$console.BringToFront(); $header.BringToFront()
function Log([string]$msg) { $console.AppendText(('['+(Get-Date -Format 'HH:mm:ss')+'] '+$msg+[Environment]::NewLine)) }
$null=(Label $sidebar 'CATEGORIES' 22 245 175 23 9 $accent $true)
$nav=@{}
$categories=@('Overview','Client Checker','Macro Detector','Minecraft Mods','Running Processes','System Info')
$navY=275
foreach($name in $categories) {
 $btn=(Button $sidebar $name 14 $navY 181 42 $card $white); $nav[$name]=$btn; $navY+=50
}
$export=(Button $sidebar 'Export current report' 14 190 181 40 (Color '#234D5D') $white)
$null=(Label $sidebar 'READ-ONLY MODE' 22 615 175 22 9 $accent $true)
$null=(Label $sidebar 'No hidden scans, uploads,`nor file changes.' 22 638 180 50 9 $muted)
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
