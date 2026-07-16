# Build résumé PDFs locally in a container — parity with CI, no local LaTeX needed.
#
# Usage:
#   ./scripts/build.ps1                 # build all 8 canonical CVs
#   ./scripts/build.ps1 cv/main-en.tex  # build specific file(s)
#   $env:LATEX_IMAGE='texlive/texlive:TL2026'; ./scripts/build.ps1   # pin the image
#
# Requires Docker Desktop running. First run pulls a multi-GB TeX Live image (cached after).
[CmdletBinding()]
param([Parameter(ValueFromRemainingArguments = $true)][string[]] $Targets)

$ErrorActionPreference = 'Stop'
$image = if ($env:LATEX_IMAGE) { $env:LATEX_IMAGE } else { 'texlive/texlive:latest' }

if (-not $Targets -or $Targets.Count -eq 0) {
    $Targets = @(
        'cv/main-en.tex', 'cv/main-es.tex',
        'cv/education-en.tex', 'cv/educacion-es.tex',
        'cv/work-en.tex', 'cv/experiencia-es.tex',
        'cv/certifications-en.tex', 'cv/certificaciones-es.tex'
    )
}

# Repo root (this script lives in scripts/).
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

docker info *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Error 'Docker daemon not reachable. Start Docker Desktop and retry.'
    exit 1
}

Write-Host "Building $($Targets.Count) CV(s) with $image ..."
# ./latexmkrc (mounted at /work) sets pdflatex, TEXINPUTS, and out_dir=build/cv.
docker run --rm -v "${root}:/work" -w /work $image latexmk @Targets
Write-Host 'Done. PDFs are in build/cv/'
