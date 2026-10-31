# Link canonical project Skills to Claude Code on Windows. Run from repository root.
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = Join-Path $repo '.agents\skills'
$claudeDir = Join-Path $repo '.claude'
$target = Join-Path $claudeDir 'skills'
if (-not (Test-Path -LiteralPath $source -PathType Container)) { throw "Source folder missing: $source" }
New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
$existing = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
if ($null -ne $existing) {
    if ($existing.LinkType -in @('Junction', 'SymbolicLink')) {
        $currentTarget = @($existing.Target)[0]
        $actual = [System.IO.Path]::GetFullPath($currentTarget).TrimEnd('\')
        $expected = [System.IO.Path]::GetFullPath($source).TrimEnd('\')
        if ($actual -ieq $expected) {
            Write-Host "Already linked: $target -> $source" -ForegroundColor Green
            exit 0
        }
        throw "Existing link points elsewhere: $target -> $currentTarget. Inspect manually; nothing was changed."
    }
    throw "Existing folder is not a link: $target. Move it manually after checking its contents."
}
New-Item -ItemType Junction -Path $target -Target $source | Out-Null
Write-Host "Linked: $target -> $source" -ForegroundColor Green
Write-Host 'Start a new Claude Code session and verify /business-context-init or /business-skill-router.'
Write-Host 'The junction is local and must be recreated after another Git clone.'
