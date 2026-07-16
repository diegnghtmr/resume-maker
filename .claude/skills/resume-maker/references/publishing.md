# Publishing, versions, privacy

## Permanent URLs
Base: `https://diegnghtmr.github.io/resume-maker`. Defined in `shared/links.tex`.
The URL never changes when content changes.

| CV | Path |
|----|------|
| Main | /cv/main-en.pdf · /cv/main-es.pdf |
| Education | /cv/education-en.pdf · /cv/educacion-es.pdf |
| Work | /cv/work-en.pdf · /cv/experiencia-es.pdf |
| Certifications | /cv/certifications-en.pdf · /cv/certificaciones-es.pdf |

The site **root** is the landing page (`web/index.html`), deployed by the same workflow.

## Build & deploy
- **CI** — `.github/workflows/publish.yml`, on every push to `main`. It compiles the explicit
  **`root_file` list** (a hardcoded list — **NOT** a `cv/*.tex` glob), then copies
  `build/cv/*.pdf` → `site/cv/`, copies `web/.` → `site/` (the landing page), writes
  `site/robots.txt`, and deploys via `configure-pages@v5` → `upload-pages-artifact@v3` →
  `deploy-pages@v4`.
- **Local** — `scripts/build.ps1 <file>` or `scripts/build.sh <file>`: TeX Live in Docker, no
  local LaTeX needed. Canonical → `build/cv/`; applications → `build/applications/<job>/`.
  Uses pdfLaTeX (the class needs `\pdfgentounicode`/`glyphtounicode`), not Tectonic/XeTeX.
  A native `latexmk cv/main-en.tex` works for **canonical** CVs only — **never** for an
  application (it writes to `build/cv/` and overwrites the canonical PDF).
- **Timing** — every CI run re-pulls the TeX Live image (~2–5 min); CI has no image cache. The
  local Docker image, by contrast, caches after the first pull.

## Adding a NEW published CV — four files change together
1. `cv/<name>.tex` — the new stub. **Unique basename** (output is flat in `build/cv/`).
2. `.github/workflows/publish.yml` — add it to `root_file`, **or CI never compiles it**.
3. `shared/links.tex` — a `\url…` macro, if another CV links to it.
4. `web/index.html` — the landing page hard-codes the links.

Miss #2 and the landing page ships a live 404. Miss #4 and the CV is unreachable from the site.

## Versioning
- One evolving canonical set in `cv/`. Cut a version with an annotated tag:
  `git tag -a v5 -m "v5: ..."; git push --tags`. History = commit log; rollback = `git checkout <tag> -- cv/`.
- The permanent URLs always serve the latest version; older versions live in tags/Releases.

## Privacy
The Pages site is public on GitHub Free (auth-gated Pages is Enterprise-only). CI writes a
`robots.txt` disallowing crawlers (discourages, does not guarantee de-indexing), and
`web/index.html` carries `<meta name="robots" content="noindex, nofollow">` — which covers the
**HTML page only, not the PDFs** (Pages allows no custom headers). Note the landing page
**publicly enumerates every published CV** from the site root, so "don't link them publicly" is
no longer a lever. Keep application CVs unpublished unless you intend them public.
