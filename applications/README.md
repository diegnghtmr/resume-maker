# applications — "la fonda"

Append-only pool of résumés tailored to a specific job. **Never delete a folder here** —
this is the archive of everything you have sent out.

## Convention

One folder per application, named `YYYY-MM-DD-company-role` (ASCII, lowercase, hyphens):

```
applications/
└── 2026-07-15-acme-staff-engineer/
    ├── job.md          # the job description + what you tailored and why
    └── main-en.tex     # self-contained tailored CV
```

## How to create one

1. Copy the closest canonical stub (e.g. `cv/main-en.tex`) into a new dated folder.
2. Save the job description and your tailoring notes in `job.md`.
3. Tailor by reordering/rewording bullets drawn from `content/<lang>/*.tex`.
   **Never invent facts** — only reshape what already exists in the master content.
4. For a durable, frozen snapshot, **inline** the tailored bullets directly in the
   application `.tex` (the canonical `cv/` set uses shared partials; archived
   applications should stand on their own so they never drift).
5. Build from the repo root: `latexmk applications/2026-07-15-acme-staff-engineer/main-en.tex`.

## Publishing (optional)

Applications are **build-only by default** — compiled and archived, not published.
To publish one, add its `.tex` path to `root_file` in
[.github/workflows/publish.yml](../.github/workflows/publish.yml) and push; its PDF
then appears under `/cv/<name>.pdf`.

> Shortcut: tell your coding agent *"generate a CV for &lt;role&gt; at &lt;company&gt;"* and the
> `resume-maker` skill does all of the above.
