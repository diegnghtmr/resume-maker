# applications — "la fonda"

Append-only pool of résumés tailored to a specific job or audience. **Never delete a folder
here** — this is the archive of everything you have sent out.

## Convention

One folder per application, named `YYYY-MM-DD-company-role` (or `YYYY-MM-DD-audience-role` when
there is no posting; ASCII, lowercase, hyphens).
The folder below is an **illustrative example, not an existing one** — this pool starts empty:

```
applications/
└── 2026-07-15-acme-staff-engineer/
    ├── job.md          # the job description + what you tailored and why
    └── main-en.tex     # tailored CV — a copy of cv/main-en.tex, sections inlined (see step 3)
```

## How to create one

1. Copy the canonical stub `cv/main-<lang>.tex` into a new dated folder — the only starting point.
2. Save the job description (or, with no posting, the target audience) and your tailoring notes
   in `job.md`.
3. **Inline** each section's `\input{content/<lang>/...}` and tailor **by emphasis only**:
   reorder, keep the most relevant items, reword bullets. Keep every `\section{...}` line
   byte-identical (titles, order, "See more" links) and keep skill-category labels, entry titles,
   dates, and layout verbatim. **Never invent facts** — only reshape what already exists in the
   master content. Inlining freezes the snapshot so it never drifts.
4. Keep it to **2 pages** by trimming the least relevant items (never a section); list every trim
   in `job.md`.
5. Build from the repo root with the container: `scripts/build.ps1 applications/<folder>/main-en.tex`
   from PowerShell, or `bash scripts/build.sh applications/<folder>/main-en.tex` from Git Bash /
   macOS / Linux. Output → `build/applications/<folder>/main-en.pdf`.
   **Do not run bare `latexmk` on an application** — it writes to `build/cv/main-en.pdf` and
   overwrites the canonical main CV. Only the scripts pass a per-source-dir `-outdir`.

Full rules and the pre-delivery checklist:
[.claude/skills/resume-maker/references/new-application.md](../.claude/skills/resume-maker/references/new-application.md).

## Publishing (optional, OFF by default — read the hazard)

Applications are **build-only**: compiled and archived, not deployed.

To publish one you **must first give it a unique basename** (e.g. `main-en-acme.tex`), then add
that path to `root_file` in [.github/workflows/publish.yml](../.github/workflows/publish.yml).
**Hazard:** CI routes all output flat into `build/cv/`, so an application still named `main-en.tex`
would overwrite the canonical `main-en.pdf` and publish your tailored CV at `/cv/main-en.pdf` —
the permanent link printed on every other application. Silent and public.

> Shortcut: tell your coding agent *"generate a CV for &lt;role&gt; at &lt;company&gt;"* (or
> *"for &lt;audience&gt;"*) and the `resume-maker` skill does all of the above.
