---
name: resume-maker
description: "Trigger: generate/update/tailor/publish a CV or resume in this repo, new CV version, CV for a job posting. Drives the shared-core LaTeX CV system (content partials, cv/ stubs, GitHub Pages permanent URLs)."
license: Apache-2.0
metadata:
  author: diegnghtmr
  version: "1.0"
---

# resume-maker

Shared-core LaTeX resume system, published to GitHub Pages at permanent URLs.
Full design and rationale: `docs/system-design.md`.

## Activation Contract

Use when, standing in this repo, the user asks to create or edit a CV, cut a new
version, tailor a CV to a job posting, or publish/link a CV. Read the matching
reference file (Decision Gates) before acting.

## Hard Rules

- Content lives in `content/<lang>/*.tex`; `cv/*.tex` are thin stubs that only
  `\input` partials and set `\section` titles. Do not inline content into stubs.
- Sections have two forms: `*.short.tex` (main CV) and `*.full.tex` (detail CV). Keep both, distinct.
- Every "See more" link comes from a macro in `shared/links.tex`. Never hard-code a URL in a CV body.
- The class `fed-res.cls` lives ONLY in `shared/`. Never copy it into a folder.
- Filenames/paths are ASCII, space-free, lowercase-hyphen. Accents only inside TeX text.
- Build from the repo ROOT (`latexmk cv/main-en.tex`), never from inside `cv/`.
- `applications/` is append-only — copy, never delete a past variant.
- When tailoring, never invent facts; only reshape what already exists in `content/`.

## Decision Gates

| Task | Read | Then |
|------|------|------|
| Edit an existing CV's content | `references/authoring.md` | change `content/<lang>/*.tex`, commit |
| Create a CV tailored to a job | `references/new-application.md` | new `applications/<date-company-role>/` |
| Cut a numbered version (v5…) | `references/publishing.md` | evolve `cv/` + `content/`, then `git tag -a v5` |
| Publish / verify build & URLs | `references/publishing.md` | push; CI builds and deploys to Pages |
| Understand structure & invariants | `references/architecture.md` | — |

## Execution Steps

1. Detect the current version from the latest `git tag` (e.g. `v4`); the canonical set is `cv/`.
2. Do the task per the Decision Gate, reusing `content/` and the class as-is.
3. Verify: run `latexmk <file>` locally if LaTeX is installed; otherwise rely on the
   `Publish CVs` CI — there is no local LaTeX by default, so CI is the source of truth.
4. Commit with a Conventional Commit message (no AI attribution). Publishing keeps the same permanent URL.

## Output Contract

Report: files changed, the affected CV(s) and their permanent URL(s), whether a new
version tag was cut, and whether CI publishing was triggered.

## References

- `references/architecture.md` — structure, conventions, invariants
- `references/authoring.md` — editing content, section commands, short vs full
- `references/publishing.md` — CI, permanent URLs, versioning, privacy
- `references/new-application.md` — tailoring a CV for a job ("la fonda")
- `docs/system-design.md` — full design & rationale
- `docs/reference/latex-ieee/SKILL.md` — general LaTeX reference (IEEE-oriented; secondary)
