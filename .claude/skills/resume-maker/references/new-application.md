# Tailoring a CV for a job or audience ("la fonda")

A tailored CV is the canonical main CV **re-emphasized, never redesigned**: same sections, same
titles, same entries, same layout. Only order, selection and bullet emphasis change.

## Steps
1. Create `applications/YYYY-MM-DD-<company|audience>-<role>/` (see Naming).
2. Save the posting (or, with no posting, the audience) + notes in `job.md`
   (template: `assets/job.template.md`).
3. **Copy the canonical stub** `cv/main-<lang>.tex` into the folder. This is the ONLY starting
   point — `assets/application.template.tex` is deprecated (header comment only).
4. Replace each section's `\input{content/<lang>/...}` with that partial's content, then tailor it
   per the table below. Keep `\input{shared/links.tex}` and `\input{content/<lang>/header.tex}`
   as-is. Keep every `\section{...}` line **byte-identical** to the stub — titles, order, and the
   `\hfill \href{...}{See more | Ver más}` links. Inlining freezes the archive so it never drifts
   when `content/` evolves.
5. Build (see Build & inspect) and run the Pre-delivery checklist.
6. Commit (Conventional Commits). Do NOT delete past application folders — append-only.

## May change / Must not change

| May change (emphasis) | Must not change (structure & facts) |
|---|---|
| Order of entries, bullets, and skill-category lines within a section | Section set, titles, order, and "See more" / "Ver más" links |
| Which items to keep — drop the least relevant bullets, skills, certifications; pull an entry or bullet from the `.full` partial when it fits the target | Skill-category labels (`\textbf{…:}` in `skills.tex` / `habilidades.tex`): never rename, merge, or invent one |
| Bullet wording, for emphasis, within the same facts | Entry titles, employers, places, dates — verbatim, casing included (`Actualidad`, `Noviembre 2025`, `Asistente Virtual`) |
| Profile wording, within facts already in `profile` / `perfil` | Layout: class macros, block shape (e.g. the 3-line Languages block), list options, `\vspace` / `itemsep` |
| — | Facts: no new claims — goals/objectives, levels, metrics, tools — unless the user states them in chat |

**Repo conventions beat generic writing-style skills.** A style skill (e.g. RAE-based Spanish
rules) may polish prose sentences — profile, bullets — and must never touch section or entry
titles, labels, dates, casing, layout, or facts.

## No posting ("a CV for <audience>")
Still a tailored application: folder `YYYY-MM-DD-<audience>-<role>`, audience recorded in
`job.md` (Source: none). Tailor by emphasis only, as above — no audience-specific sections,
skill categories, or objective sentences.

## Facts the user states in chat
A fact the user states in chat (a corrected title, an end date) is authoritative for this
application. Use it, record it in `job.md` under **Owner-provided facts**, then ask ONE question:
also update `content/<lang>/` in **both** languages? (the published CVs still show the stale
value). Never edit `content/` without that yes; never diverge silently.

## Page fit (≤ 2 pages)
The canonical main CV is 2 pages; an application must be too. If it spills, trim the least
relevant ITEMS inside existing sections — the "See more" links carry the full lists. Never remove
or merge a section, and never squeeze with layout macros or spacing. Record every trim in `job.md`.

## Long entry titles overflow the margin
`\resumeSubheading`'s left column is `l` (no wrapping; `shared/fed-res.cls`), so a long title plus
its date runs past the margin. The build still succeeds; the only signal is a warning,
`Overfull \hbox (…pt too wide) in alignment at lines N--N`, buried in the console output and in
the `.log`. Fix: ask the user for a shorter title; fallback, in this file only, split it:
`{\begin{tabular}[t]{@{}l@{}}First part,\\ second part\end{tabular}}`. Never edit `fed-res.cls`
for one application.

## Build & inspect
- **PowerShell:** `scripts/build.ps1 applications/<folder>/main-<lang>.tex`.
  **Git Bash / macOS / Linux:** `bash scripts/build.sh applications/<folder>/main-<lang>.tex` —
  `build.ps1` is PowerShell-only; bash cannot parse it. Output → `build/applications/<folder>/`
  (`main-<lang>.pdf` and `.log`).
- **Do NOT run bare `latexmk` on an application file** — it obeys `latexmkrc` and writes to
  `build/cv/main-<lang>.pdf`, overwriting the canonical main CV. The scripts pass a per-source-dir
  `-outdir`; bare `latexmk` does not. If you must, pass it yourself:
  `latexmk -outdir=build/applications/<folder> -auxdir=build/applications/<folder> applications/<folder>/main-<lang>.tex`.
- **Pages:** latexmk prints `Output written on <pdf> (N pages, …)`; the line is also in the `.log`.
- **Visual check:** there is no `pdftoppm` (neither on the host nor in the image). Render with
  Ghostscript inside the same image, from the repo root, then delete the PNGs:
  ```sh
  MSYS_NO_PATHCONV=1 docker run --rm -v "$(pwd -W):/work" -w /work texlive/texlive:latest \
    gs -q -dNOPAUSE -dBATCH -sDEVICE=png16m -r70 \
    -sOutputFile=build/applications/<folder>/page-%d.png build/applications/<folder>/main-<lang>.pdf
  ```
  That is the Git Bash form. macOS/Linux: `$(pwd)`, no prefix. PowerShell: no prefix, mount
  `"${PWD}:/work"`, one line.

## Pre-delivery checklist
- [ ] `rg '^\x5csection' cv/main-<lang>.tex` and the same on the application print identical
      lines (`\x5c` is `\`; unlike `'^\\section'`, this form survives PowerShell and Git Bash quoting).
- [ ] 0 `Overfull` in `build/applications/<folder>/main-<lang>.log`; `(N pages` with N ≤ 2.
- [ ] Skill-category labels, entry titles, and dates match `content/<lang>/` verbatim.
- [ ] Every claim traces to `content/<lang>/` or to the user's chat message.
- [ ] `job.md` lists every trim and every owner-provided fact.

## Naming
`YYYY-MM-DD-<company>-<role>`, or `YYYY-MM-DD-<audience>-<role>` with no posting (the date you
create it), e.g. `2026-07-15-acme-staff-engineer` — an illustrative name, not an existing folder.
Sortable and greppable. Slugify to lowercase ASCII with hyphens.

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
