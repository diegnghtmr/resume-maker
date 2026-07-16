# Architecture

Full rationale: `docs/system-design.md`. Quick map:

```
shared/     fed-res.cls (the class), citations.bib, links.tex (all published URLs)
content/    en/ and es/ — one partial per section; *.short (main) and *.full (detail)
cv/         8 thin assembly stubs -> the 8 canonical PDFs
applications/  one folder per job ("la fonda"), append-only
.github/workflows/publish.yml   compiles cv/ and deploys PDFs to GitHub Pages
```

## Shared vs variant
- Shared everywhere: `fed-res.cls`, `citations.bib`.
- Shared per language: the contact header (`content/<lang>/header.tex`) — EN "Portfolio:", ES "Portafolio:".
- Variant: section prose (EN/ES), document shape (main = many sections + links; detail = one section),
  and short vs full section bodies.

## Invariants (never break)
- Class only in `shared/`; resolved via `TEXINPUTS` (set in `latexmkrc` and in CI env).
- Links only via `shared/links.tex` macros.
- ASCII, space-free, lowercase-hyphen filenames; accents only inside TeX text.
- Output basenames unique (main-en.pdf, education-en.pdf, …).
- Build from the repo root.

## Permanent-link model
`shared/links.tex` maps each detail CV to a permanent GitHub Pages URL; the main CV
references the macro (e.g. `\href{\urlEducationEn}{See more}`). Updating a detail CV
never changes its URL, so the main CV never needs editing. This replaces the old
Google Drive flow, where every re-upload minted a new file id.
