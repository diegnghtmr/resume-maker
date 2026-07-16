# resume-maker

LaTeX résumé system for **Diego Alejandro Flores Quintero**. One shared core, each
section authored once, compiled to PDF and published to GitHub Pages at **permanent
URLs** — update a CV and its link never changes.

- Full design & rationale: [docs/system-design.md](docs/system-design.md)
- Agent skill (drives generation end-to-end): `.claude/skills/resume-maker/SKILL.md`

## Layout

| Path | What |
|------|------|
| `shared/` | `fed-res.cls` (the class), `links.tex` (every published URL), `citations.bib` (inert — nothing cites it) |
| `content/en`, `content/es` | section partials — `*.short` (main) and `*.full` (detail) |
| `cv/` | thin assembly stubs → the 8 canonical PDFs |
| `applications/` | one folder per job application ("la fonda"), append-only, build-only |
| `web/index.html` | landing page deployed to the site root (hard-codes all 8 PDF links) |
| `scripts/` | `build.ps1` / `build.sh` — containerized build entry points |
| `latexmkrc` | pdfLaTeX + `TEXINPUTS` + default output dir (`build/cv`) |
| `docs/` | `system-design.md` + `reference/latex-ieee/` (vendored LaTeX reference) |
| `AGENTS.md`, `CLAUDE.md` | rules for AI agents (the skill lives in `.claude/skills/resume-maker/`) |
| `.github/workflows/publish.yml` | compiles `cv/` and deploys the PDFs + landing page to Pages |
| `build/` | local generated output (gitignored). `site/` is created only inside CI. |

## Permanent URLs

Base: `https://diegnghtmr.github.io/resume-maker`

| CV | Path |
|----|------|
| Main | `/cv/main-en.pdf` · `/cv/main-es.pdf` |
| Education detail | `/cv/education-en.pdf` · `/cv/educacion-es.pdf` |
| Work detail | `/cv/work-en.pdf` · `/cv/experiencia-es.pdf` |
| Certifications detail | `/cv/certifications-en.pdf` · `/cv/certificaciones-es.pdf` |

The site root (`https://diegnghtmr.github.io/resume-maker/`) is a landing page (`web/index.html`)
linking every CV. Updating any CV keeps the same URL — no more re-uploading and re-linking.

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

Output → `build/cv/*.pdf` (applications → `build/applications/<job>/`). First run pulls the TeX
Live image (~a few GB, cached **locally** after that); override it with `LATEX_IMAGE`.
Prefer a native install? `latexmk cv/main-en.tex` works for **canonical** CVs — but never run
bare `latexmk` on an application file: it writes to `build/cv/` and overwrites the canonical PDF.
No setup at all? Just `git push` — CI builds and publishes.

## GitHub setup — ✅ already done (kept for reference)

1. Create a **public** repo named `resume-maker` and push `main`.
2. Settings → Pages → **Source: GitHub Actions**.
3. Push → the `Publish CVs` workflow builds and deploys to the base URL above.
   Every run takes ~2–5 min: CI re-pulls the TeX Live image each time (no CI image cache).

## Common tasks

- **Edit a CV** — change the relevant `content/<lang>/*.tex`, push. Same URL updates.
- **Cut a version** — `git tag -a v5 -m "v5: ..."; git push --tags`.
- **Tailor for a job** — see [applications/README.md](applications/README.md), or just tell
  your coding agent *"generate a CV for &lt;role&gt; at &lt;company&gt;"*.
- **Add a NEW published CV** — four files change together: the `cv/` stub (unique basename),
  `root_file` in `.github/workflows/publish.yml` (an explicit list, **not** a glob),
  `shared/links.tex`, and `web/index.html`. Miss the workflow → the landing page ships a 404.

Privacy: the Pages site is public (GitHub Free plan). `robots.txt` and a `noindex` meta on the
landing page discourage indexing, but PDFs can't carry a noindex header and the landing page
publicly lists every CV. Details in `docs/system-design.md` §10.
