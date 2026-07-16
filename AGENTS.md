# AGENTS.md

Guidance for AI coding agents working in this repository.

## What this repo is
A shared-core LaTeX résumé system, published to GitHub Pages at permanent URLs.
Start with `README.md` and `docs/system-design.md`.

## Skills
| Skill | When | Path |
|-------|------|------|
| `resume-maker` | Create, edit, tailor, version, or publish a CV | `.claude/skills/resume-maker/SKILL.md` |

Vendored reference (tracked, not an active skill): `docs/reference/latex-ieee/` — general
LaTeX guidance (IEEE-oriented; for résumés the `resume-maker` skill governs).

## Golden rules
- Move content, don't rewrite it, unless asked. Preserve facts exactly.
- Build from the repo root. Filenames ASCII / space-free. Links only via `shared/links.tex`.
- `applications/` is append-only. Commit with Conventional Commits; no AI attribution.
