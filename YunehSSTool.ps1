# YunehSSTool UI rebrand builder
# Downloads the original CheesySSTool source, edits visual branding, and saves a separate copy.
# Original functionality and author attribution are retained.
$ErrorActionPreference = 'Stop'
$sourceUrl = 'https://raw.githubusercontent.com/cheesecatlol/CheesySSTool/refs/heads/main/CheesySSTool.ps1'
$out = Join-Path $env:USERPROFILE 'Downloads\YunehSSTool_Rebranded.ps1'
try {
    $response = Invoke-WebRequest -Uri $sourceUrl -UseBasicParsing -TimeoutSec 30
    $scriptText = [string]$response.Content
    if (-not $scriptText.Contains('CheesySSTool') -or -not $scriptText.Contains('$ToolData')) {
        throw 'Unexpected source contents. No file created.'
    }
    # UI-only branding and palette changes. No scanner, launcher or tool commands are changed.
    $scriptText = $scriptText.Replace('Title="CheesySSTool"', 'Title="YunehSSTool"')
    $scriptText = $scriptText.Replace('Text="  CheesySSTool"', 'Text="  YunehSSTool"')
    $scriptText = $scriptText.Replace('Text="CheesySSTool"', 'Text="YunehSSTool"')
    $scriptText = $scriptText.Replace('Text="=^.^="', 'Text="Y."')
    $scriptText = $scriptText.Replace('Color="#0F0B00"', 'Color="#090F1B"')
    $scriptText = $scriptText.Replace('Color="#1A1200"', 'Color="#0C1728"')
    $scriptText = $scriptText.Replace('Color="#221800"', 'Color="#13243A"')
    $scriptText = $scriptText.Replace('Color="#F5C200"', 'Color="#65D5FF"')
    $scriptText = $scriptText.Replace('Color="#A07800"', 'Color="#2F91C4"')
    $scriptText = $scriptText.Replace('Color="#FFF4C8"', 'Color="#E7F7FF"')
    $scriptText = $scriptText.Replace('Color="#907830"', 'Color="#87AFC5"')
    $scriptText = $scriptText.Replace('Color="#060400"', 'Color="#060D18"')
    foreach ($pair in @(
        @('#3D2E00','#24445E'), @('#2A1E00','#1D3855'), @('#33F5C200','#3365D5FF'),
        @('#F5C200','#65D5FF'), @('#0F0B00','#090F1B'), @('#FFF4C8','#E7F7FF'),
        @('#5A4010','#527F9D'), @('#0A0700','#071320')
    )) { $scriptText = $scriptText.Replace($pair[0], $pair[1]) }
    # Replace only the decorative ASCII cat logo block with a large Y. text logo.
    $scriptText = [regex]::Replace($scriptText, '(?s)(<TextBlock x:Name="CatBlock"\s*)Text="[^"]*"', '$1Text="Y."')
    # Keep original author credit; add rebrand label to title bar.
    $scriptText = $scriptText.Replace('Text="  -  by cheese cat"', 'Text="  |  Original by cheese cat"')
    [System.IO.File]::WriteAllText($out, $scriptText, [System.Text.UTF8Encoding]::new($true))
    Write-Host "Created: $out" -ForegroundColor Cyan
    Write-Host 'Review the generated file before running it. Third-party tool links and commands are unchanged.'
} catch {
    Write-Host "Unable to build: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
