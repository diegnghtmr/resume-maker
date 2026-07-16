# resume-maker

LaTeX résumé system for **Diego Alejandro Flores Quintero**. One shared core, each
section authored once, compiled to PDF and published to GitHub Pages at **permanent
URLs** — update a CV and its link never changes.

- Full design & rationale: [docs/system-design.md](docs/system-design.md)
- Agent skill (drives generation end-to-end): `.claude/skills/resume-maker/SKILL.md`

## Layout

| Path | What |
|------|------|
| `shared/` | `fed-res.cls` (the class), `citations.bib`, `links.tex` (every published URL) |
| `content/en`, `content/es` | section partials — `*.short` (main) and `*.full` (detail) |
| `cv/` | thin assembly stubs → the 8 canonical PDFs |
| `applications/` | one folder per job application ("la fonda"), append-only |
| `.github/workflows/publish.yml` | compiles `cv/` and deploys the PDFs to Pages |
| `build/`, `site/` | generated output (gitignored) |

## Permanent URLs

Base: `https://diegnghtmr.github.io/resume-maker`

| CV | Path |
|----|------|
| Main | `/cv/main-en.pdf` · `/cv/main-es.pdf` |
| Education detail | `/cv/education-en.pdf` · `/cv/educacion-es.pdf` |
| Work detail | `/cv/work-en.pdf` · `/cv/experiencia-es.pdf` |
| Certifications detail | `/cv/certifications-en.pdf` · `/cv/certificaciones-es.pdf` |

Updating any CV keeps the same URL — no more re-uploading and re-linking.

## Build locally (optional)

No local LaTeX install needed — build in a container with parity to CI. Start Docker Desktop, then:

```powershell
./scripts/build.ps1                 # all 8 CVs  (PowerShell)
./scripts/build.ps1 cv/main-en.tex  # one file
```
```sh
scripts/build.sh                    # all 8 CVs  (Git Bash / macOS / Linux / WSL)
scripts/build.sh cv/main-en.tex     # one file
```

Output → `build/cv/*.pdf`. First run pulls the TeX Live image (~a few GB, cached after);
override it with `LATEX_IMAGE`. Prefer a native install? `latexmk cv/main-en.tex` from the
repo root also works. No setup at all? Just `git push` — CI builds and publishes.

## First-time GitHub setup

1. Create a **public** repo named `resume-maker` and push `main`.
2. Settings → Pages → **Source: GitHub Actions**.
3. Push → the `Publish CVs` workflow builds and deploys to the base URL above
   (first run ~2–5 min while it pulls the TeX Live image).

## Common tasks

- **Edit a CV** — change the relevant `content/<lang>/*.tex`, push. Same URL updates.
- **Cut a version** — `git tag -a v5 -m "v5: ..."; git push --tags`.
- **Tailor for a job** — see [applications/README.md](applications/README.md), or just tell
  your coding agent *"generate a CV for &lt;role&gt; at &lt;company&gt;"*.

Privacy: the Pages site is public (GitHub Free plan). `robots.txt` discourages indexing;
details in `docs/system-design.md` §10.
