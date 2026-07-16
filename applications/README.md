# applications — "la fonda"

Append-only pool of résumés tailored to a specific job. **Never delete a folder here** —
this is the archive of everything you have sent out.

## Convention

One folder per application, named `YYYY-MM-DD-company-role` (ASCII, lowercase, hyphens).
The folder below is an **illustrative example, not an existing one** — this pool starts empty:

```
applications/
└── 2026-07-15-acme-staff-engineer/
    ├── job.md          # the job description + what you tailored and why
    └── main-en.tex     # tailored CV — inline the tailored bullets (see step 4)
```

## How to create one

1. Copy the closest canonical stub (e.g. `cv/main-en.tex`) into a new dated folder.
2. Save the job description and your tailoring notes in `job.md`.
3. Tailor by reordering/rewording bullets drawn from `content/<lang>/*.tex`.
   **Never invent facts** — only reshape what already exists in the master content.
4. For a durable, frozen snapshot, **inline** the tailored bullets directly in the
   application `.tex` (the canonical `cv/` set uses shared partials; archived
   applications should stand on their own so they never drift).
5. Build from the repo root with the container: `scripts/build.ps1 applications/<folder>/main-en.tex`
   (or `scripts/build.sh`). Output → `build/applications/<folder>/main-en.pdf`.
   **Do not run bare `latexmk` on an application** — it writes to `build/cv/main-en.pdf` and
   overwrites the canonical main CV. Only the scripts pass a per-source-dir `-outdir`.

## Publishing (optional, OFF by default — read the hazard)

Applications are **build-only**: compiled and archived, not deployed.

To publish one you **must first give it a unique basename** (e.g. `main-en-acme.tex`), then add
that path to `root_file` in [.github/workflows/publish.yml](../.github/workflows/publish.yml).
**Hazard:** CI routes all output flat into `build/cv/`, so an application still named `main-en.tex`
would overwrite the canonical `main-en.pdf` and publish your tailored CV at `/cv/main-en.pdf` —
the permanent link printed on every other application. Silent and public.

> Shortcut: tell your coding agent *"generate a CV for &lt;role&gt; at &lt;company&gt;"* and the
> `resume-maker` skill does all of the above.
