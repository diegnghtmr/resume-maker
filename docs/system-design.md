# Resume-Maker — System Design & Research

> Status: **Implemented (v4).** The idea is validated, the repo is restructured to this
> design, the `Publish CVs` CI is in place, and the `resume-maker` skill is built.
> Remaining manual step: create the public GitHub repo + enable Pages
> (README → "First-time GitHub setup"), then push to trigger the first build.
>
> Last updated: 2026-07-15

---

## 1. TL;DR — Verdict

**The idea is valid and the technology supports every requirement.** GitHub Pages gives a
CV PDF a **permanent URL that never changes when you update the content** — which is the exact
thing Google Drive cannot do (Drive mints a new `fileId` on every re-upload). Combined with a
GitHub Actions job that compiles LaTeX → PDF in the cloud, you get:

- Edit `.tex` → push → CI builds the PDF → it appears at the **same URL** forever.
- The "main" CV links to detail CVs with links you set **once** and never touch again.
- Versions live in git tags (`v4`, future `v5`), history is the commit log.
- Per-job tailored CVs live in an append-only `applications/` pool ("la fonda") — nothing is ever lost.
- An AI agent standing in the repo reads one Skill and can generate a new tailored CV end-to-end.

The Drive round-trip (delete → re-upload → copy new URL → edit the main CV) **disappears entirely.**

There is exactly **one real tradeoff to decide** (privacy of a public Pages site — see §10 and §14).

---

## 2. The problem, from the current repo

Evidence pulled from your actual files:

- `cv_v4_es/Your Resume.tex` line 29 / 40 / 89 (and the EN mirror) hard-code **Google Drive
  links** in the section headers, e.g.
  `\section{Educación \hfill \href{https://drive.google.com/file/d/1cras1sFMm4x.../view}{Ver más}}`.
- There are **6 such links total** (3 per language). Each points to a hand-exported PDF on Drive.
  When a detail CV changes, Drive gives a new id → you must re-paste the link in the main CV.
- The repo carries **8 byte-identical copies of `fed-res.cls`** and **8 of `citations.bib`**.
- There are **64 dead "Resume Sections" template files** (the original boilerplate, e.g.
  `School or Program Name`) — **nothing `\input`s them**; they are pure dead weight.
- Main vs. detail CVs are **not** the same content: the detail is a **superset** (Work Experience
  main = 2 jobs / detail = 3; Certifications main = 7 / detail = 12; Education is equal).

So the friction is structural: duplicated infrastructure + manually-synced external links.

---

## 3. Validation findings (verified 2026-07)

All three pillars were verified against current documentation, not memory. Sources in §16.

### 3.1 Permanent URLs — the core fix ✅
- Publishing method (current, post-2024-12-05 deprecation): first-party Actions pipeline
  `configure-pages@v5` → `upload-pages-artifact@v3` → `deploy-pages@v4`. No older versions work.
- URL shape (project site): `https://USER.github.io/REPO/path/file.pdf`.
  With a custom domain it becomes `https://cv.diegnghtmr.me/path/file.pdf`.
- **URL stability: the URL = host + repo name + file path. None of those change when the PDF
  content changes.** Re-deploying a new PDF at the same path yields a byte-identical URL forever.
- PDFs serve **inline** (`Content-Type: application/pdf`, no forced download) — unlike raw
  GitHub URLs, which is precisely why Pages is the right host for viewable CVs.

### 3.2 Cloud LaTeX build ✅
- `xu-cheng/latex-action@v4` runs a full TeX Live in Docker — **no local LaTeX install needed**.
- Because each CV compiles from a directory where its class/bib are reachable, a custom
  `fed-res.cls` "just works" (via `working_directory`, `work_in_root_file_dir`, or `TEXINPUTS`).
- `latexmk` auto-runs bibtex/biber **only if the document actually `\cite`s** — your inert
  `citations.bib` (its `\addbibresource` is commented out in the class) is silently ignored, no error.
- Cost caveat: Linux runners only; each run re-pulls the multi-GB TeX Live image → **~2–5 min/run**.
  Fine for a CV. If speed ever matters, `Tectonic` builds in seconds (tradeoff: XeTeX engine).

### 3.3 Versioning & variants ✅
- **Versions** → annotated git tags on a single evolving line (`git tag -a v4`, later `v5`).
  Immutable, named, one-command rollback; optionally attach the built PDF to a GitHub Release.
- **Per-job variants ("fonda")** → **directory-per-variant on `main`**, committed and never deleted.
  Best fit for an AI agent (it can read/diff every variant in one tree) and for "never lose it".
- **Do not** migrate to RenderCV / JSON Resume / YAMLResume: none of them consume a custom
  `fed-res.cls` — you'd have to re-implement your class as their theme engine. The AI agent **is**
  your templating engine; keep full standalone `.tex` per variant and factor shared facts into a master.

---

## 4. Scope

### In scope (what we WILL do)
1. Restructure the repo to a single shared core (one `fed-res.cls`, one `citations.bib`).
2. Author each section once as reusable partials, with distinct **short** (main) and **full** (detail) forms.
3. Centralize the 6 external links into one `shared/links.tex` pointing at permanent Pages URLs.
4. Add a GitHub Actions workflow that compiles every CV and deploys the PDFs to GitHub Pages.
5. Establish a version model (git tags) and a per-job variant pool (`applications/`).
6. Write a lazy-loaded repo Skill so any agent can drive the whole system from a short instruction.
7. Copy the existing LaTeX skill into the repo for tracking (see §13.2 for the caveat).

### Out of scope (what we will NOT do)
- No migration to a data-driven renderer (RenderCV/JSON Resume) — keeps `fed-res.cls`.
- No per-version directories (`v4/`, `v5/`) — that reintroduces duplication and drift.
- No public publishing of tailored **application** CVs by default (privacy — see §9.3).
- No attempt to password-protect the Pages site — not possible below GitHub Enterprise (§10).
- No Google Drive in the loop, at all.

---

## 5. Target architecture

```
resume-maker/
├── .github/workflows/
│   └── publish.yml              # build all CVs → PDFs → deploy to GitHub Pages
├── shared/
│   ├── fed-res.cls              # ONE canonical class  (replaces 8 identical copies)
│   ├── citations.bib            # ONE canonical bib    (replaces 8; inert today)
│   ├── links.tex                # every permanent published URL, defined ONCE
│   └── preamble.tex             # optional: shared settings the class doesn't cover
├── content/
│   ├── en/
│   │   ├── header.tex           # contact block, "Portfolio:" label
│   │   ├── profile.tex
│   │   ├── skills.tex
│   │   ├── languages.tex
│   │   ├── education.short.tex        education.full.tex
│   │   ├── work.short.tex             work.full.tex
│   │   └── certifications.short.tex   certifications.full.tex
│   └── es/
│       ├── header.tex           # "Portafolio:" label (only differing token EN↔ES)
│       ├── perfil.tex  habilidades.tex  idiomas.tex
│       ├── educacion.short.tex        educacion.full.tex
│       ├── experiencia.short.tex      experiencia.full.tex
│       └── certificaciones.short.tex  certificaciones.full.tex
├── cv/                          # the CANONICAL current-version set (today: v4)
│   ├── main-en.tex  main-es.tex                 # short sections + "See more" links
│   ├── education-en.tex  education-es.tex        # detail = *.full partials
│   ├── work-en.tex  work-es.tex
│   └── certifications-en.tex  certifications-es.tex
├── applications/                # "la fonda" — append-only, one folder per job, never deleted
│   └── 2026-07-15-acme-staff-engineer/
│       ├── job.md               # the job description + tailoring notes
│       └── main-en.tex          # self-contained tailored CV (\inputs shared partials)
├── build/                       # gitignored — compiled PDFs staged for Pages
├── docs/system-design.md        # this file
├── latexmkrc                    # sets TEXINPUTS so {fed-res} + partials resolve
├── .gitignore                   # build/, *.aux, *.log, *.out, *.fls, *.fdb_latexmk
└── README.md
```

Delta vs. today: `8 fed-res.cls → 1`, `8 citations.bib → 1`, `64 dead files → 0`,
`8 inlined headers → 2`, `6 hard-coded Drive URLs → 1 links.tex`, each section authored once.

**Assembly is thin.** A canonical CV is a stub that pulls partials, e.g. `cv/main-en.tex`:

```latex
\documentclass[letterpaper,12pt]{fed-res}
\input{shared/links.tex}
\begin{document}
  \input{content/en/header.tex}
  \input{content/en/profile.tex}
  \section{Education \hfill \href{\urlEducationEn}{See more}}      \input{content/en/education.short.tex}
  \section{Work Experience \hfill \href{\urlWorkEn}{See more}}     \input{content/en/work.short.tex}
  \input{content/en/skills.tex}
  \section{Certifications \hfill \href{\urlCertsEn}{See more}}     \input{content/en/certifications.short.tex}
  \input{content/en/languages.tex}
\end{document}
```

The detail `cv/education-en.tex` is the same header + `education.full.tex`, no link.

---

## 6. The stable-link model (the heart of the fix)

`shared/links.tex` is the single source of truth for every external link:

```latex
% shared/links.tex — edit a URL here ONCE; every CV updates on next build.
\newcommand{\SITE}{https://diegnghtmr.github.io/resume-maker}   % DECIDED (D1) — tied to the public repo name "resume-maker"
\newcommand{\urlEducationEn}{\SITE/cv/education-en.pdf}
\newcommand{\urlWorkEn}{\SITE/cv/work-en.pdf}
\newcommand{\urlCertsEn}{\SITE/cv/certifications-en.pdf}
\newcommand{\urlEducationEs}{\SITE/cv/educacion-es.pdf}
\newcommand{\urlWorkEs}{\SITE/cv/experiencia-es.pdf}
\newcommand{\urlCertsEs}{\SITE/cv/certificaciones-es.pdf}
```

**Before:** update detail CV → export PDF → upload to Drive → copy new `fileId` → open main CV
→ replace `\href` → re-export main → re-upload main. (×6 possible links.)

**After:** update `content/en/education.full.tex` → `git push`. CI rebuilds `education-en.pdf`,
Pages serves it at the same `\urlEducationEn`. The main CV never changes. **Zero manual link work.**

---

## 7. Versioning model

- The **canonical `cv/` set is always "the current version."** The public Pages URLs always serve it.
- Cut a version with an annotated tag: `git tag -a v5 -m "v5: ..."; git push --tags`.
- History = commit log; rollback = `git checkout v4 -- cv/`.
- Optional: a `release.yml` that, on tag push, builds the PDFs and attaches them to a GitHub Release
  so each version's rendered PDF is frozen and downloadable.
- **The permanent public link always reflects the latest version** — exactly your requirement.
  Old versions are recoverable from tags/Releases, not from the canonical URL.

## 8. Variant pool — "la fonda"

- One committed folder per application: `applications/YYYY-MM-DD-company-role/`.
- Sortable, greppable, never deleted → the archive can't rot or be garbage-collected.
- Each holds `job.md` (the JD + why you tailored what) and a self-contained tailored `.tex`.
- The agent creates a variant by copying the canonical main + selecting/rewording facts from the
  `content/` master partials to match the JD.
- Publishing an application CV publicly is **opt-in per application** (§9.3).

---

## 9. Publishing & CI

### 9.1 Reference workflow (`.github/workflows/publish.yml`)

```yaml
name: Publish CVs
on:
  push: { branches: [main] }
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency: { group: pages, cancel-in-progress: false }

jobs:
  publish:
    runs-on: ubuntu-latest            # latex-action is a container action → Linux only
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - uses: actions/checkout@v4

      - name: Compile canonical CVs
        uses: xu-cheng/latex-action@v4
        with:
          root_file: |
            cv/main-en.tex
            cv/main-es.tex
            cv/education-en.tex
            cv/education-es.tex
            cv/work-en.tex
            cv/work-es.tex
            cv/certifications-en.tex
            cv/certifications-es.tex
        env:
          # shared/ has fed-res.cls; content/ has the \input partials. Recursive (//) search.
          TEXINPUTS: ".:./shared//:./content//:"

      - name: Assemble Pages site
        run: |
          mkdir -p build/cv
          cp cv/*.pdf build/cv/ 2>/dev/null || cp *.pdf build/cv/
          printf 'User-agent: *\nDisallow: /\n' > build/robots.txt   # discourage indexing (§10)

      - uses: actions/configure-pages@v5
      - uses: actions/upload-pages-artifact@v3
        with: { path: build }
      - id: deployment
        uses: actions/deploy-pages@v4
```

> The exact PDF output paths (repo root vs. next to source) get pinned and verified during
> implementation — `latexmkrc` will set `$out_dir` so the `cp` step is deterministic.

### 9.2 URL scheme — DECIDED (D1)
- **Chosen:** project site, no custom domain → `https://diegnghtmr.github.io/resume-maker/cv/main-en.pdf`.
  Requires a **public** repo named `resume-maker` with Pages source = GitHub Actions.
  `\SITE` in `shared/links.tex` is hard-set to `https://diegnghtmr.github.io/resume-maker`.
- **The URL is tied to the repo name.** Renaming the repo (or the GitHub user) breaks live links —
  don't. This is the one path-contract to protect.
- Future option (not now): a custom subdomain `cv.diegnghtmr.me` via DNS `CNAME cv → diegnghtmr.github.io`
  + Settings → Pages. Verified it coexists with your apex `diegnghtmr.me` portfolio (different domain
  strings). Migrating later means changing only `\SITE` — one line — and re-pushing.

### 9.3 What gets published
- **Canonical `cv/`** → published to Pages (the permanent public links). ✅
- **`applications/`** → built + archived in git; published **only when you flag it** (you don't
  want a CV tailored for Company X publicly discoverable). Default: not deployed.

---

## 10. Privacy & security — the one real tradeoff

Verified facts you must decide on:

- On the **Free** plan, the repo must be **public** for Pages to work, and **the published site is
  world-readable in every plan** (login-gated Pages is Enterprise-only).
- Your CV exposes **phone number and email**. On Pages, both become publicly fetchable, and the
  PDF can be crawled/indexed by search engines.
- Pages allows **no custom HTTP headers**, so you cannot send `X-Robots-Tag: noindex` on a PDF.
  The only levers are a `robots.txt` `Disallow` (discourages, doesn't guarantee de-indexing) and
  **not linking the URLs publicly**.

Context that softens this: your CV already publicly links your portfolio, GitHub and LinkedIn,
and a CV is a document made to be handed out. But "handed to a recruiter" ≠ "Google-indexed",
so this is a genuine choice. Options are in §14.

---

## 11. Conventions & invariants (the rules the agent must obey)

- **Filenames are ASCII, space-free.** No accents in paths (`educacion-es.pdf`, not `EDUCACIÓN…`).
  Accents live only inside the TeX text. (Accented/space folder names today break latexmk, zips,
  and cross-OS transfers — a documented migration risk.)
- **Each output has a unique basename** (`main-en.pdf`, `education-en.pdf`, …). Never ship two files
  both named `Your Resume.pdf`.
- **The class lives only in `shared/`.** Never re-copy `fed-res.cls` into a variant folder; `TEXINPUTS`
  (via `latexmkrc`) resolves it.
- **Every external link comes from `shared/links.tex`.** No raw URLs inside a CV body.
- **Sections have two forms:** `*.short` (main) and `*.full` (detail). Never unify them silently —
  the detail is a real superset.
- **`applications/` is append-only.** Copy, never move; never delete a past variant.
- **A published URL path is a contract.** Renaming a repo/file/domain breaks live links — avoid it.

---

## 12. The end-to-end agent workflow (the goal)

Standing in the repo, you tell the agent: *"Generate a CV for <role> at <company>, here's the JD / info."*
The Skill drives:

1. **Read state** — current version (latest git tag), the canonical `cv/` set, and `content/` masters.
2. **Create the variant** — `applications/<date-company-role>/`, copy the right `main-*` stub, drop in `job.md`.
3. **Tailor** — select, reorder, and reword facts from `content/` partials to match the JD; never invent facts.
4. **Build & verify** — compile locally if LaTeX is present, else rely on CI; confirm the PDF renders.
5. **Publish (if asked)** — flag the variant for deployment; CI returns the permanent URL.
6. **Record** — commit with a conventional message; optionally save to memory.

You pass information; the agent handles structure, naming, versioning, build, links, and privacy defaults.

---

## 13. Deliverables to build later (implementation phase)

### 13.1 The repo Skill (`.skill/` or `skills/resume-maker/SKILL.md`)
- Authored per the `skill-creator` rules: YAML frontmatter (`name`, `description` with explicit
  triggers), **lazy-loading** body (short entry point that points to reference files, not a wall of text).
- Encodes: the architecture (§5), conventions (§11), the agent workflow (§12), the build/publish
  commands (§9), and the privacy defaults (§10, §9.3).
- Reference files (loaded on demand): `structure.md`, `authoring.md`, `publishing.md`, `versioning.md`.

### 13.2 Copy of the LaTeX skill — with a caveat
- The only LaTeX skill on this machine is **`ieee-latex`**
  (`C:\Users\diego\.agents\skills\ieee-latex-skill\SKILL.md`). It targets **IEEE papers**
  (`IEEEtran`), not résumés — so it's only partially relevant to `fed-res.cls`.
- Per your request we will **copy it into the repo for tracking**, but the repo's real LaTeX guidance
  should be a **résumé-specific** reference (built around `fed-res.cls`). Flagged as an open item.

---

## 14. Open decisions (need your call before implementation)

| # | Decision | Recommendation |
|---|----------|----------------|
| D1 | **Publishing endpoint & privacy** (§9.2, §10) | ✅ **DECIDED: `diegnghtmr.github.io/resume-maker`, public, with `robots.txt`.** No DNS. `\SITE` set accordingly; a custom domain stays a one-line future migration. |
| D2 | **Repo**: turn *this* folder into the git repo & restructure in place, vs. start a clean repo | Restructure in place — it already holds your content and history-to-be. _(done)_ |
| D3 | **Publish application (fonda) CVs** publicly or keep them build-only | Build-only by default; publish per-application on demand. _(done)_ |
| D4 | **Delete the 64 dead `Resume Sections` files** during migration | Yes — verified unused (nothing `\input`s them). _(done)_ |

## 15. Migration plan (once §14 is decided)

1. `git init`; add `.gitignore`; commit the current state as the baseline; `git tag v4-legacy`.
2. Create `shared/` with one `fed-res.cls`, one `citations.bib`, and `links.tex`.
3. Extract per-language partials into `content/en` and `content/es` (header, profile, skills,
   languages, and each section's `.short` + `.full`), ASCII names.
4. Replace the 8 folders with the 8 thin stubs in `cv/`.
5. Delete the 64 dead template files and the 7 duplicate class/bib copies.
6. Add `latexmkrc` (`TEXINPUTS`, `$out_dir=build`) and `.github/workflows/publish.yml`.
7. Enable Pages (Source = GitHub Actions); set the custom domain + DNS (if D1 = subdomain).
8. Verify every PDF renders and every `\href` resolves to a live Pages URL; `git tag v4`.
9. Build the Skill + copy the LaTeX skill (§13).

---

## 16. Sources (verified 2026-07)

- LaTeX CI: `github.com/xu-cheng/latex-action`, its README & releases; `github.com/WtfJoke/setup-tectonic`.
- Pages: `docs.github.com` (custom workflows, custom domains, visibility), the 2024-12-05 artifacts-v4
  deprecation changelog, `actions/upload-pages-artifact`, `actions/deploy-pages`.
- Versioning/prior art: `docs.rendercv.com`, `jsonresume.org`, `yamlresume.dev`, `github.com/zhiweio/resume-as-code`,
  CircleCI "git tags vs branches", SEI "versioning with git tags".
- Current-repo audit: local read-only analysis of all 8 CV folders (MD5 dedupe, link graph, dead-file detection).
```
