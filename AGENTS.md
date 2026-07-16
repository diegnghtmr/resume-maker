# AGENTS.md

Guidance for AI coding agents working in this repository. (Claude Code loads this via
`CLAUDE.md`; other agents should read this file directly.)

## What this repo is

A shared-core LaTeX résumé system for Diego Alejandro Flores Quintero. Each section is authored
**once** in `content/<lang>/`, assembled by thin stubs in `cv/`, compiled to PDF, and published to
GitHub Pages at **permanent URLs** — updating a CV never changes its link. This replaced a Google
Drive flow where every re-upload minted a new file id.

Live: <https://diegnghtmr.github.io/resume-maker/> · Design & rationale: `docs/system-design.md`

## Map

| Path | What |
|------|------|
| `shared/` | `fed-res.cls` (the ONE class), `links.tex` (every published URL), `citations.bib` (**inert** — `\addbibresource` is commented out in the class) |
| `content/en`, `content/es` | section partials; `*.short.tex` (main CV) and `*.full.tex` (detail CV — usually fuller: work 2 vs 3 jobs, certs 7 vs 12; education is currently identical). No `\section` line inside — the stub sets it. |
| `cv/` | 8 thin assembly stubs → the 8 canonical PDFs |
| `applications/` | "la fonda" — one folder per job, append-only, **build-only** |
| `web/index.html` | landing page deployed to the site root; **hard-codes all 8 PDF links** |
| `scripts/build.ps1` \| `build.sh` | containerized build (Docker; no local LaTeX needed) |
| `latexmkrc` | pdfLaTeX + `TEXINPUTS` + default output dir (`build/cv`) |
| `.github/workflows/publish.yml` | compiles `cv/` and deploys PDFs + landing page to Pages |
| `docs/` | `system-design.md` (design record) + `reference/latex-ieee/` (vendored LaTeX ref, IEEE-oriented) |
| `build/` | local output (gitignored). `site/` is created only inside CI. |

## Skills

| Skill | When | Path |
|-------|------|------|
| `resume-maker` | Create, edit, tailor, version, or publish a CV | `.claude/skills/resume-maker/SKILL.md` |

## Build

```sh
scripts/build.ps1                                  # all 8 canonical CVs  -> build/cv/
scripts/build.ps1 cv/main-en.tex                   # one file
scripts/build.sh  applications/<job>/main-en.tex   # -> build/applications/<job>/
```

Always from the repo **ROOT** — `\input` paths are root-relative. The scripts pass a per-source-dir
`-outdir`; **bare `latexmk` does not** and will write an application's PDF to `build/cv/`,
overwriting a canonical one.

## Golden rules

- **Never invent facts.** Reshape only what exists in `content/`. Move content, don't rewrite it, unless asked.
- Class only in `shared/`. Links only via `shared/links.tex`. Filenames ASCII / space-free / lowercase-hyphen.
- Adding or renaming a published CV touches **four** files together: the `cv/` stub, `root_file` in
  `.github/workflows/publish.yml` (CI compiles an **explicit list, not a glob**), `shared/links.tex`,
  and `web/index.html` (it hard-codes the links). Miss the workflow → the landing page 404s.
- `applications/` is append-only and build-only. Publishing one is an explicit, opt-in act.
- **Unique basenames.** Every entry in `publish.yml`'s `root_file` must have a distinct basename;
  output is flat in `build/cv/`, so a duplicate silently overwrites a canonical CV at its public URL.
- Versions are annotated git tags on the single evolving `cv/` line (`git tag -a v5 -m "…"`). No per-version dirs.
- Conventional Commits; no AI attribution.
