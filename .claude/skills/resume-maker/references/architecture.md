# Architecture

Full rationale: `docs/system-design.md` (design record — check its status banner; some sections
are historical). Quick map:

```
shared/        fed-res.cls (the ONE class), links.tex (every published URL),
               citations.bib (INERT — \addbibresource is commented out in the class)
content/       en/ and es/ — one partial per section; *.short (main) and *.full (detail)
cv/            8 thin assembly stubs -> the 8 canonical PDFs
applications/  one folder per job ("la fonda"), append-only, build-only
web/           index.html — landing page deployed to the site ROOT; hard-codes all 8 PDF links
scripts/       build.ps1 | build.sh — containerized build (Docker; no local LaTeX needed)
latexmkrc      pdfLaTeX + TEXINPUTS + default output dir (build/cv)
docs/          system-design.md + reference/latex-ieee/ (vendored LaTeX reference)
build/         local output (gitignored). site/ exists only inside CI.
.github/workflows/publish.yml   compiles cv/ and deploys PDFs + web/ to GitHub Pages
```

## Shared vs variant
- Shared everywhere: `fed-res.cls`. (`citations.bib` is shared but **inert** — nothing cites it;
  don't waste an edit there.)
- Shared per language: the contact header (`content/<lang>/header.tex`) — EN "Portfolio:", ES "Portafolio:".
- Variant: section prose (EN/ES), document shape (main = many sections + links; detail = one section),
  and short vs full section bodies.

## Invariants (never break)
- Class only in `shared/`; resolved via `TEXINPUTS` (set in `latexmkrc` and in CI env).
- Links only via `shared/links.tex` macros.
- ASCII, space-free, lowercase-hyphen filenames; accents only inside TeX text.
- **Output basenames must be unique.** Output is flat in `build/cv/`, so two root files named
  `main-en.tex` overwrite each other. This is why applications are built via `scripts/build.*`
  (which pass a per-source-dir `-outdir`) and why anything added to `publish.yml`'s `root_file`
  needs a distinct basename.
- Build from the repo root.

## Paired edit: links.tex + web/index.html
`shared/links.tex` holds the URL macros used **inside** the CVs. `web/index.html` is the public
landing page and **hard-codes the same PDF paths**. Adding, renaming, or removing a published CV
requires updating **both**, or the landing page links 404.

## Permanent-link model
`shared/links.tex` maps each detail CV to a permanent GitHub Pages URL; the main CV references
the macro (e.g. `\href{\urlEducationEn}{See more}`). Updating a detail CV never changes its URL,
so the main CV never needs editing. This replaces the old Google Drive flow, where every
re-upload minted a new file id.
