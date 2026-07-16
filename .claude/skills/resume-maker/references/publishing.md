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

## Build & deploy
- CI: `.github/workflows/publish.yml` compiles every `cv/*.tex` with
  `xu-cheng/latex-action@v4` and deploys the PDFs to GitHub Pages on each push to `main`.
- Local (optional): `latexmk cv/main-en.tex` from the repo root (needs a LaTeX install).
- First CI run pulls the TeX Live image (~2–5 min); later runs are similar (no image cache).

## First-time GitHub setup
1. Create a PUBLIC repo named `resume-maker`; push `main`.
2. Settings → Pages → Source: **GitHub Actions**.
3. Push → the `Publish CVs` workflow builds and deploys to the base URL above.

## Versioning
- One evolving canonical set in `cv/`. Cut a version with an annotated tag:
  `git tag -a v5 -m "v5: ..."; git push --tags`. History = commit log; rollback = `git checkout <tag> -- cv/`.
- The permanent URLs always serve the latest version; older versions live in tags/Releases.

## Privacy
The Pages site is public on GitHub Free (auth-gated Pages is Enterprise-only). CI writes
a `robots.txt` disallowing crawlers (discourages, not guarantees, de-indexing); PDFs cannot
carry a noindex header on Pages. Keep application CVs unpublished unless you intend them public.
