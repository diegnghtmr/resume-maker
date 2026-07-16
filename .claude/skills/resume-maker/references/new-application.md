# Tailoring a CV for a job ("la fonda")

## Steps
1. Create `applications/YYYY-MM-DD-company-role/` (ASCII, lowercase, hyphens).
2. Save the posting + notes in `job.md` (template: `assets/job.template.md`).
3. Start from `assets/application.template.tex` (or copy `cv/main-en.tex`).
4. Tailor by reordering / rewording bullets drawn from `content/<lang>/*.tex`.
   NEVER invent facts — only reshape existing ones.
5. For a durable, frozen archive, INLINE the tailored bullets directly in the
   application `.tex`. The canonical `cv/` set uses shared partials; archived
   applications should stand alone so they never drift when `content/` evolves.
6. Build from the repo root: `scripts/build.ps1 applications/<folder>/main-en.tex` (or
   `scripts/build.sh`) → output `build/applications/<folder>/main-en.pdf`.
   **Do NOT run bare `latexmk` on an application file** — it obeys `latexmkrc` and writes to
   `build/cv/main-en.pdf`, overwriting the canonical main CV. The scripts pass a per-source-dir
   `-outdir`; bare `latexmk` does not. If you must, pass it yourself:
   `latexmk -outdir=build/applications/<folder> -auxdir=build/applications/<folder> applications/<folder>/main-en.tex`.
7. Commit (Conventional Commits). Do NOT delete past application folders — append-only.

## Naming
`YYYY-MM-DD-company-role` (the date you create it), e.g. `2026-07-15-acme-staff-engineer`
— an illustrative name, not an existing folder. Sortable and greppable. Slugify company and
role to lowercase ASCII with hyphens.

## Language
Match the posting's language. If the posting is English → `main-en.tex` (draw from `content/en/`);
if Spanish → `main-es.tex` (draw from `content/es/`). If genuinely ambiguous, ask.

## Publishing (optional, OFF by default — read the hazard)
Applications are build-only: compiled and archived, never deployed, unless explicitly asked.

To publish one you **must first give it a unique basename** (e.g. `main-en-acme.tex`), then add
that path to `root_file` in `.github/workflows/publish.yml`. **Hazard:** `latexmkrc` routes all CI
output flat into `build/cv/`, so an application still named `main-en.tex` would compile over the
canonical `build/cv/main-en.pdf` and publish the tailored CV at `/cv/main-en.pdf` — the permanent
URL printed on every other application. Silent and public. Unique basename first, always.
