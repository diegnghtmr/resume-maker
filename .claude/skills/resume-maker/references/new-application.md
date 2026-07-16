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
6. Build from the repo root: `latexmk applications/<folder>/main-en.tex`.
7. Commit (Conventional Commits). Do NOT delete past application folders — append-only.

## Naming
`YYYY-MM-DD-company-role`, e.g. `2026-07-15-acme-staff-engineer`. Sortable and greppable.

## Publishing (optional, off by default)
Applications are build-only by default. To publish one, add its `.tex` path to
`root_file` in `.github/workflows/publish.yml` and push; its PDF then appears at
`/cv/<name>.pdf`. Otherwise it stays private (compiled and archived, not deployed).
