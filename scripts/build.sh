#!/usr/bin/env bash
# Build résumé PDFs locally in a container — parity with CI, no local LaTeX needed.
#
# Usage:
#   scripts/build.sh                 # build all 8 canonical CVs
#   scripts/build.sh cv/main-en.tex  # build specific file(s)
#   LATEX_IMAGE=texlive/texlive:TL2026 scripts/build.sh   # pin the image
#
# Requires Docker Desktop running. First run pulls a multi-GB TeX Live image (cached after).
set -euo pipefail

IMAGE="${LATEX_IMAGE:-texlive/texlive:latest}"

# Repo root (this script lives in scripts/).
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# Windows Git Bash needs a Windows-style mount source; cygpath -m yields C:/path.
if command -v cygpath >/dev/null 2>&1; then HOSTROOT="$(cygpath -m "$ROOT")"; else HOSTROOT="$ROOT"; fi

if ! docker info >/dev/null 2>&1; then
  echo "ERROR: Docker daemon not reachable. Start Docker Desktop and retry." >&2
  exit 1
fi

if [ "$#" -gt 0 ]; then
  TARGETS=("$@")
else
  TARGETS=(cv/main-en.tex cv/main-es.tex \
           cv/education-en.tex cv/educacion-es.tex \
           cv/work-en.tex cv/experiencia-es.tex \
           cv/certifications-en.tex cv/certificaciones-es.tex)
fi

echo "Building ${#TARGETS[@]} CV(s) with ${IMAGE} ..."
# ./latexmkrc (mounted at /work) sets pdflatex, TEXINPUTS, and out_dir=build/cv.
MSYS_NO_PATHCONV=1 docker run --rm -v "${HOSTROOT}:/work" -w /work "${IMAGE}" \
  latexmk "${TARGETS[@]}"
echo "Done. PDFs are in build/cv/"
