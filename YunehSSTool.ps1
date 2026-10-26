# YunehSSTool theme builder. Original functionality remains credited to cheese cat.
# Downloads source as TEXT and writes a themed COPY; it does not execute the source.
$ErrorActionPreference = 'Stop'
$sourceUrl = 'https://raw.githubusercontent.com/cheesecatlol/CheesySSTool/refs/heads/main/CheesySSTool.ps1'
$out = Join-Path $env:USERPROFILE 'Downloads\YunehSSTool.ps1'
try {
    $src = (Invoke-WebRequest -Uri $sourceUrl -UseBasicParsing -TimeoutSec 35).Content
    if ($src -is [byte[]]) { $src = [Text.Encoding]::UTF8.GetString($src) }
    if ($src -notmatch '\$ToolData\s*=\s*@\(' -or $src -notmatch '\[xml\]\$xaml') { throw 'Unexpected source format. No file was written.' }
    $begin = $src.IndexOf('[xml]$xaml')
    $end = $src.IndexOf('"@', $begin)
    if ($begin -lt 0 -or $end -lt 0) { throw 'Could not locate the UI markup.' }
    # Replace only display text and colors, not tool data or launch commands.
    $src = $src.Replace('Title="CheesySSTool"','Title="YunehSSTool"')
    $src = $src.Replace('Text="  CheesySSTool"','Text="  YunehSSTool"')
    $src = $src.Replace('Text="CheesySSTool"','Text="YunehSSTool"')
    $src = $src.Replace('Text="=^.^="','Text="Y."')
    $src = $src.Replace('Color="#0F0B00"','Color="#080E18"')
    $src = $src.Replace('Color="#1A1200"','Color="#0D1929"')
    $src = $src.Replace('Color="#221800"','Color="#14253B"')
    $src = $src.Replace('Color="#F5C200"','Color="#65D4FF"')
    $src = $src.Replace('Color="#A07800"','Color="#3189B7"')
    $src = $src.Replace('Color="#FFF4C8"','Color="#EAF8FF"')
    $src = $src.Replace('Color="#907830"','Color="#91B5CE"')
    $src = $src.Replace('Color="#060400"','Color="#050A12"')
    $src = $src.Replace('#F5C200','#65D4FF').Replace('#33F5C200','#3365D4FF')
    $src = $src.Replace('#0F0B00','#080E18').Replace('#1A1200','#0D1929').Replace('#221800','#14253B')
    $src = $src.Replace('#3D2E00','#294561').Replace('#2A1E00','#203A55').Replace('#0A0700','#07111E')
    $src = $src.Replace('#FFF4C8','#EAF8FF').Replace('#907830','#91B5CE').Replace('#060400','#050A12')
    $src = $src.Replace('#5A4010','#7094B2')
    $src = $src.Replace('CornerRadius="8"','CornerRadius="12"').Replace('CornerRadius="6"','CornerRadius="10"')
    # Change the install folder label only. Preserve developer attribution and tool names.
    $src = $src.Replace('Downloads\CheesySSTool','Downloads\YunehSSTool')
    $header = '# YunehSSTool themed edition - original CheesySSTool code by cheese cat; theme modification only.' + "`r`n"
    [IO.File]::WriteAllText($out, $header + $src, (New-Object Text.UTF8Encoding($false)))
    Write-Host "Created: $out" -ForegroundColor Cyan
    Write-Host 'Tool names, download URLs, commands, and author credits are retained.'
    Write-Host 'Review the generated script before running it. No third-party tools were launched.'
} catch {
    Write-Host "Build failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
