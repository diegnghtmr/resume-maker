# CLAUDE.md

Project memory for Claude Code. The full, vendor-neutral rules live in @AGENTS.md.

## What this is

A shared-core LaTeX résumé system. Sections are authored once in `content/<lang>/`, assembled
by thin stubs in `cv/`, compiled to PDF, and published to GitHub Pages at **permanent URLs**
(update a CV → the link never changes).

- **Skill — load it for ANY CV work:** `.claude/skills/resume-maker/SKILL.md`
- **Design & rationale:** `docs/system-design.md`
- **Live site:** https://diegnghtmr.github.io/resume-maker/

## Build (no local LaTeX needed — runs in Docker)

```sh
scripts/build.ps1                                  # all 8 canonical CVs   -> build/cv/
scripts/build.ps1 cv/main-en.tex                   # one file
scripts/build.sh  applications/<job>/main-en.tex   # -> build/applications/<job>/
```

Always build from the repo **ROOT** (`\input` paths are root-relative). Docker Desktop must be
running. Do **not** run bare `latexmk` on an application file — it obeys `latexmkrc` and writes
to `build/cv/`, overwriting a canonical PDF.

## Hard rules

- **Never invent facts** on a CV. Only reshape what already exists in `content/`.
- `fed-res.cls` lives **only** in `shared/`. Never copy it into a folder.
- External links **only** via macros in `shared/links.tex`. Adding/renaming a published CV touches
  **four** files: the `cv/` stub, `root_file` in `publish.yml` (an explicit list, **not** a glob),
  `shared/links.tex`, and `web/index.html`. Miss the workflow → the landing page ships a 404.
- `applications/` is **append-only** and **build-only** (never published unless asked).
- Anything added to `root_file` in `.github/workflows/publish.yml` **must have a unique basename** —
  output is flat in `build/cv/`, so a duplicate name overwrites a canonical CV at its permanent URL.
- Conventional Commits. No AI attribution in commit messages.
