# Authoring content

Edit section content in `content/<lang>/*.tex`. The `cv/` stubs only assemble.

## Section commands (from fed-res.cls)
- List wrapper: `\resumeSubHeadingListStart ... \resumeSubHeadingListEnd`
- Entry (title/date, then subtitle/place):
  ```latex
  \resumeSubheading
      {Role or Institution}{Date range}
      {Subtitle / Program}{City, Region}
  ```
- Bullets under an entry:
  ```latex
  \resumeItemListStart
      \resumeItem{Achievement, quantified where possible.}
  \resumeItemListEnd
  ```
- Other helpers (argument order matters — from `shared/fed-res.cls`):
  - `\resumeSubheadingShort{Title}{Date}` — entry with no location.
  - `\resumeSubheadingWork{Role}{Dates}{Employer}{Location}{Supervisor}{Hours per week}` —
    the federal-style entry (6 args); rows render as 1&2, then 3&4 italic, then 5&6.
  - `\resumeProjectHeading{Name / description}{Date or link}`
  - `\resumeSubSubheading{Title}{Date}` — a second position at the same employer.
  - `\resumeItem{Bullet text}` · `\resumeSubItem{Bullet}` (tighter spacing)
  - `\cvpub{Full citation text}` — a publication line with hanging indent.

## short vs full
- `*.short.tex` = the version shown in the MAIN CV (kept brief).
- `*.full.tex` = the expanded version in the DETAIL CV (a superset).
- Keep them consistent in facts, different in depth. Editing one never touches the other.
- Today: Education short == full; Work short = 2 jobs, full = 3; Certifications short = 7, full = 12.

## Header, and single-occurrence sections
- `content/<lang>/header.tex` holds the name + contact block (EN "Portfolio:", ES "Portafolio:").
- `profile`/`perfil`, `skills`/`habilidades`, `languages`/`idiomas` appear ONLY in the main CVs.
- Partials contain no `\section{...}` line — the `cv/` stub sets the title (and any link).

## Adding an entry
Insert a new `\resumeSubheading{...}{...}{...}{...}` block (with optional
`\resumeItemListStart/End`) in the relevant partial. Preserve UTF-8 accents; escape
`&` as `\&`. Reuse existing formatting; do not restyle the class.
