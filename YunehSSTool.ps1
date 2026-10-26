# Applies a local visual theme to an independently downloaded CheesySSTool script.
# Original credit is retained. No scanners, download links, or execution commands are changed.
$ErrorActionPreference = 'Stop'
$source = Join-Path $env:USERPROFILE 'Downloads\CheesySSTool.ps1'
$destination = Join-Path $env:USERPROFILE 'Downloads\YunehSSTool_Themed.ps1'
if (-not (Test-Path -LiteralPath $source)) {
    Write-Host "First download CheesySSTool.ps1 into your Downloads folder from the original author's repository." -ForegroundColor Yellow
    exit 1
}
$content = [IO.File]::ReadAllText($source)
$start = $content.IndexOf('[xml]$xaml = @"')
if ($start -lt 0) { throw 'Could not locate the expected XAML menu. Source may have changed.' }
$end = $content.IndexOf('"@', $start + 16)
if ($end -lt 0) { throw 'Could not find end of XAML menu. No changes made.' }
$menu = $content.Substring($start, $end + 2 - $start)
$menu = $menu.Replace('Title="CheesySSTool"','Title="YunehSSTool"')
$menu = $menu.Replace('Text="  CheesySSTool"','Text="  YunehSSTool"')
$menu = $menu.Replace('Text="=^.^="','Text="Y."')
# Keep author credit, so this is clearly a themed derivative.
$colors = @{
    '#0F0B00'='#080F18'; '#1A1200'='#0D1827'; '#221800'='#142235';
    '#F5C200'='#68CFFF'; '#A07800'='#3299D1'; '#FFF4C8'='#EDF9FF';
    '#907830'='#8DB3C9'; '#060400'='#050B12'; '#3D2E00'='#224760';
    '#0A0700'='#07111C'; '#2A1E00'='#16314B'; '#33F5C200'='#3368CFFF'
}
foreach ($old in $colors.Keys) { $menu = $menu.Replace($old,$colors[$old]) }
$content = $content.Substring(0,$start) + $menu + $content.Substring($end+2)
[IO.File]::WriteAllText($destination,$content,[Text.UTF8Encoding]::new($true))
Write-Host "Created: $destination" -ForegroundColor Cyan
Write-Host 'Only the XAML menu was modified. Review the original script before running it.'
