# Yungeh SS Tool - original, read-only local diagnostics
$Host.UI.RawUI.WindowTitle = 'Yungeh SS Tool'
$ErrorActionPreference = 'Continue'
function Banner {
 Clear-Host
 Write-Host '  +==================================================+' -ForegroundColor Cyan
 Write-Host '  |               Y U N G E H                        |' -ForegroundColor Cyan
 Write-Host '  |                 SS TOOL                          |' -ForegroundColor Cyan
 Write-Host '  |           LOCAL DIAGNOSTICS  v2.0               |' -ForegroundColor Cyan
 Write-Host '  +==================================================+' -ForegroundColor Cyan
 Write-Host '  |  1. Minecraft and launcher processes             |' -ForegroundColor Cyan
 Write-Host '  |  2. Java processes                               |' -ForegroundColor Cyan
 Write-Host '  |  3. Minecraft directories                        |' -ForegroundColor Cyan
 Write-Host '  |  4. Mods list (names only)                       |' -ForegroundColor Cyan
 Write-Host '  |  5. Minecraft log file names                     |' -ForegroundColor Cyan
 Write-Host '  |  6. System information                           |' -ForegroundColor Cyan
 Write-Host '  |  7. Java installations                           |' -ForegroundColor Cyan
 Write-Host '  |  8. Save local report                            |' -ForegroundColor Cyan
 Write-Host '  |  9. Exit                                         |' -ForegroundColor Cyan
 Write-Host '  +==================================================+' -ForegroundColor Cyan
 Write-Host '  No uploads, downloads, or changes to your files.' -ForegroundColor DarkGray
}
function MCProcesses { Get-Process | Where-Object { $_.ProcessName -match 'minecraft|java|lunar|badlion|prismlauncher|multimc' } | Select-Object ProcessName,Id,CPU | Format-Table -AutoSize | Out-String }
function JavaProcesses { Get-Process | Where-Object { $_.ProcessName -match '^java(w)?$' } | Select-Object ProcessName,Id,CPU | Format-Table -AutoSize | Out-String }
function MCPaths {
 $paths=@("$env:APPDATA\.minecraft","$env:USERPROFILE\AppData\Roaming\.lunarclient","$env:APPDATA\PrismLauncher")
 foreach($p in $paths){ if(Test-Path $p){"FOUND: $p"}else{"NOT FOUND: $p"} }
}
function MCMods {
 $p=Join-Path $env:APPDATA '.minecraft\mods'
 if(Test-Path $p){Get-ChildItem -LiteralPath $p -File -ErrorAction SilentlyContinue | Select-Object Name,Length | Format-Table -AutoSize | Out-String}else{'Default Minecraft mods folder not found.'}
}
function MCLogs {
 $p=Join-Path $env:APPDATA '.minecraft\logs'
 if(Test-Path $p){Get-ChildItem -LiteralPath $p -File -ErrorAction SilentlyContinue | Select-Object -First 20 Name,LastWriteTime | Format-Table -AutoSize | Out-String}else{'Default Minecraft logs folder not found.'}
}
function SystemInfo { [PSCustomObject]@{OS=[Environment]::OSVersion.VersionString;Computer=$env:COMPUTERNAME;PowerShell=$PSVersionTable.PSVersion.ToString();Date=(Get-Date).ToString('u')} | Format-List | Out-String }
function JavaInfo { $cmd=Get-Command java -ErrorAction SilentlyContinue; if($cmd){ & java -version 2>&1 | Out-String }else{'Java is not on PATH.'} }
function Report {
 $desktop=[Environment]::GetFolderPath('Desktop')
 $dest=Join-Path $desktop 'Yungeh_SS_Report.txt'
 @('YUNGEH SS TOOL - LOCAL REPORT',"Generated: $(Get-Date)",'','MINECRAFT PROCESSES',(MCProcesses),'JAVA PROCESSES',(JavaProcesses),'MINECRAFT PATHS',(MCPaths | Out-String),'MOD FILE NAMES',(MCMods),'LOG FILE NAMES',(MCLogs),'SYSTEM',(SystemInfo),'JAVA VERSION',(JavaInfo)) | Out-File -LiteralPath $dest -Encoding UTF8
 "Report saved locally to: $dest"
}
do {
 Banner
 $choice=Read-Host '  YUNGEH > Choose 1-9'
 Write-Host ''
 switch($choice){
 '1'{MCProcesses}
 '2'{JavaProcesses}
 '3'{MCPaths}
 '4'{MCMods}
 '5'{MCLogs}
 '6'{SystemInfo}
 '7'{JavaInfo}
 '8'{Report}
 '9'{Write-Host 'Goodbye!' -ForegroundColor Cyan}
 default{Write-Host 'Choose a number from 1 to 9.' -ForegroundColor Yellow}
 }
 if($choice -ne '9'){[void](Read-Host 'Press ENTER to return to the menu')}
}while($choice -ne '9')

