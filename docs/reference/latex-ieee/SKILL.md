---
name: ieee-latex
description: Use this skill whenever creating, editing, reviewing, or troubleshooting LaTeX documents in IEEE format. Covers conference papers, journal articles, and technical notes using the IEEEtran class. Includes document structure, formatting rules, equations, figures, tables, bibliography management with BibTeX, common mistakes, and submission best practices. Trigger when the user mentions IEEE, IEEEtran, conference paper, journal paper in LaTeX, or needs help formatting academic/engineering papers for IEEE publication.
---

# IEEE LaTeX Skill — Complete Guide

This skill provides comprehensive best practices and rules for creating professional IEEE-formatted documents using LaTeX and the IEEEtran class. Follow these guidelines to produce papers that comply with IEEE standards for conferences, journals, and technical notes.

---

## Assets (Plantillas listas para usar)

Esta skill incluye plantillas funcionales en la carpeta `assets/`:

| Archivo | Descripción |
|---------|-------------|
| `assets/template-conference.tex` | Plantilla completa para **artículos de conferencia** IEEE. Incluye ejemplos de figuras, tablas, ecuaciones, subfiguras, listings de código, y estructura de secciones. |
| `assets/template-journal.tex` | Plantilla completa para **artículos de revista (journal)** IEEE. Incluye `\IEEEPARstart`, biografías de autores, `\thanks`, y `\markboth`. |
| `assets/references.bib` | Archivo BibTeX de ejemplo con entradas de todos los tipos comunes: `@ARTICLE`, `@INPROCEEDINGS`, `@BOOK`, `@TECHREPORT`, `@MASTERSTHESIS`, `@MANUAL`, `@MISC`. |

### Cómo usar las plantillas

1. **Copiar** la plantilla correspondiente (`template-conference.tex` o `template-journal.tex`) al directorio de trabajo del usuario.
2. **Copiar** `references.bib` al mismo directorio.
3. **Renombrar** ambos archivos según el proyecto.
4. **Crear** la carpeta `figures/` en el mismo directorio para las imágenes.
5. **Reemplazar** el contenido de ejemplo con el contenido real del usuario.
6. **Compilar**: `pdflatex` → `bibtex` → `pdflatex` → `pdflatex`.

### Regla para Claude

Cuando el usuario pida crear un documento IEEE LaTeX:
- **Conferencia → copiar** `assets/template-conference.tex`
- **Journal/Revista → copiar** `assets/template-journal.tex`
- **Siempre copiar** `assets/references.bib` como punto de partida
- Adaptar el contenido de la plantilla a las necesidades específicas del usuario
- NUNCA crear un documento IEEE desde cero sin consultar esta skill y sus plantillas

---

## 1. Document Class and Mode Selection

### 1.1 Basic Setup

Always start with the correct document class and mode:

```latex
% For CONFERENCE papers:
\documentclass[conference]{IEEEtran}

% For JOURNAL papers:
\documentclass[journal]{IEEEtran}

% For TECHNICAL NOTES / Correspondence / Short papers:
\documentclass[technote]{IEEEtran}
% technote mode should typically also use 9pt option:
\documentclass[technote,9pt]{IEEEtran}

% For PEER REVIEW (journal with review cover page):
\documentclass[peerreview]{IEEEtran}

% For PEER REVIEW with author names visible on cover:
\documentclass[peerreviewca]{IEEEtran}
```

### 1.2 Important Class Options

| Option | Purpose |
|--------|---------|
| `conference` | Conference proceedings format |
| `journal` | Journal article format (default) |
| `technote` | Technical note / correspondence |
| `peerreview` | Journal with anonymous review cover |
| `compsoc` | IEEE Computer Society style |
| `comsoc` | IEEE Communications Society style |
| `transmag` | IEEE Transactions on Magnetics style |
| `10pt`, `11pt`, `12pt` | Font size |
| `draftcls` | Draft mode (shows overfull markers) |
| `draftclsnofoot` | Draft without "DRAFT" footer |
| `romanappendices` | Number appendices with Roman numerals |
| `nofonttune` | Disable IEEEtran's interword spacing tuning |

### 1.3 Critical Rule

**NEVER alter margins, column widths, line spacing, or text fonts.** IEEEtran prescribes all layout parameters. Do NOT use packages like `geometry.sty` to modify page layout. The template anticipates your paper as part of complete proceedings, not a standalone document.

---

## 2. Essential Packages

### 2.1 Recommended Package Set

```latex
\documentclass[conference]{IEEEtran}

% ---- Encoding and Language ----
\usepackage[utf8]{inputenc}   % UTF-8 input encoding
\usepackage[T1]{fontenc}      % Better font encoding for accented chars
% \usepackage[spanish]{babel} % Uncomment for Spanish language support

% ---- Citations ----
\usepackage{cite}             % Improved citation handling (compress ranges)

% ---- Mathematics ----
\usepackage{amsmath}          % Enhanced math environments
\usepackage{amssymb}          % Additional math symbols
\usepackage{amsfonts}         % Math fonts

% ---- Graphics ----
\usepackage{graphicx}         % ALWAYS use graphicx (not older psfig, epsfig)
\usepackage[caption=false]{subfig}  % Subfigures (IEEE-compatible)

% ---- Tables ----
\usepackage{array}            % Enhanced table column types
\usepackage{booktabs}         % Professional table rules (\toprule, \midrule)
\usepackage{multirow}         % Multi-row cells in tables

% ---- Algorithms ----
\usepackage{algorithmic}      % Pseudocode (IEEE-preferred)
\usepackage{algorithm}        % Algorithm float environment

% ---- Hyperlinks (load LAST) ----
\usepackage{url}              % URL formatting
\usepackage[hidelinks]{hyperref} % Clickable links without colored boxes

% ---- Special IEEE command unlock ----
\IEEEoverridecommandlockouts  % Only if needed (e.g., for \thanks in conference)
```

### 2.2 Packages to AVOID

| Package | Reason | Alternative |
|---------|--------|-------------|
| `geometry` | Alters IEEE margins | None needed |
| `psfig`, `epsfig` | Obsolete | `graphicx` |
| `eqnarray` | Poor spacing, deprecated | `align` or `IEEEeqnarray` |
| `subfigure` (old) | Deprecated | `subfig` with `caption=false` |
| `times` | Not needed | IEEEtran handles fonts |
| Unnecessary packages | Loading unused packages causes conflicts | Audit all packages |

**Rule:** Don't load packages "because that's how it was always done." Audit every package against the current IEEEtran version (v1.8b+).

---

## 3. Document Structure

### 3.1 Title and Authors

```latex
\title{Paper Title: Do NOT Use Symbols, Special Characters,\\
Footnotes, or Math in Title}

% --- Conference mode authors ---
\author{
  \IEEEauthorblockN{First Author\IEEEauthorrefmark{1}, 
    Second Author\IEEEauthorrefmark{2}, 
    Third Author\IEEEauthorrefmark{1}}
  \IEEEauthorblockA{\IEEEauthorrefmark{1}Department of Engineering,\\
    University Name, City, Country\\
    Email: first@university.edu}
  \IEEEauthorblockA{\IEEEauthorrefmark{2}Company Name,\\
    City, Country\\
    Email: second@company.com}
}

% --- Journal mode authors ---
\author{
  First~A.~Author,~\IEEEmembership{Member,~IEEE,}
  Second~B.~Author,~and~Third~C.~Author,~Jr.,~\IEEEmembership{Fellow,~IEEE}
  \thanks{Manuscript received Month Day, Year.}
  \thanks{F. A. Author is with Department, University (e-mail: author@uni.edu).}
}
```

### 3.2 Title Rules

- **Title:** 24pt font, centered at top. Maximum ~12 words recommended.
- **CRITICAL:** Do NOT use symbols, special characters, footnotes, or math in the title or abstract.
- Author names: left-to-right, then next line. Do NOT arrange in columns.
- Family name must be the last part (e.g., "John A.K. Smith").
- Include at minimum: name, company/institution, country.
- Email is **compulsory** for the corresponding author.

### 3.3 Abstract and Keywords

```latex
\begin{abstract}
Your abstract here. Should be 100--200 words for regular papers,
no more than 50 words for correspondence/technote papers.
Do NOT include citations, equations, or special characters.
\end{abstract}

\begin{IEEEkeywords}
Component, formatting, style, insert.
% List 5-10 terms. Capitalize the first term.
% List alphabetically. Use IEEE Taxonomy terms when possible.
\end{IEEEkeywords}
```

### 3.4 Section Structure

```latex
\section{Introduction}       % Level 1: SMALL CAPS, centered
\subsection{Subsection}      % Level 2: Italic, left-justified
\subsubsection{Subsubsection} % Level 3: Indented, italic, with colon

% LaTeX auto-numbers sections. Do NOT number them manually.
% Maximum 3 levels of headings.
```

**Heading capitalization rules:** Capitalize every word EXCEPT short minor words: "a", "an", "the", "and", "but", "or", "for", "nor", "as", "at", "by", "in", "of", "on", "to", "up" (unless they are the first or last word).

### 3.5 Complete Document Skeleton

```latex
\documentclass[conference]{IEEEtran}
\usepackage{cite}
\usepackage{amsmath,amssymb,amsfonts}
\usepackage{graphicx}
\usepackage{url}

\begin{document}

\title{Your Paper Title Here}
\author{...}
\maketitle

\begin{abstract}
...
\end{abstract}

\begin{IEEEkeywords}
keyword1, keyword2, keyword3
\end{IEEEkeywords}

\section{Introduction}
...

\section{Related Work}
...

\section{Methodology}
...

\section{Results}
...

\section{Conclusion}
...

\section*{Acknowledgment}
% Use \section* (no number). Spell "Acknowledgment" without the 'e'
% per IEEE style (American English).

\bibliographystyle{IEEEtran}
\bibliography{references}  % references.bib file

\end{document}
```

---

## 4. Equations and Mathematics

### 4.1 Core Rules

1. **Use `equation` for single equations, `align` or `IEEEeqnarray` for multi-line. NEVER use `eqnarray`.**
2. **Number equations consecutively** throughout the paper: (1), (2), (3)...
3. **Appendix equations:** (A1), (A2) — or continue consecutive numbering.
4. **Sub-equations:** (1a), (1b) — NO hyphens: ~~(1-a)~~ NO periods: ~~(2.a)~~
5. **Punctuate equations** as part of the sentence with commas and periods.
6. **Define all symbols** before or immediately after the equation.
7. **Use soft cross-references:** `\eqref{eq}` not `(1)` or `Eq.~(1)`.

### 4.2 Equation Examples

```latex
% Single equation
\begin{equation}
  a + b = \gamma
  \label{eq:example}
\end{equation}

% Referencing: Use \eqref{}, NOT hard-coded numbers
As shown in \eqref{eq:example}, ...     % CORRECT
% At the start of a sentence:
Equation~\eqref{eq:example} shows...     % CORRECT
% WRONG: Eq.~\eqref{eq:example}, equation \eqref{eq:example}

% Multi-line: Use align (from amsmath)
\begin{align}
  f(x) &= a_0 + a_1 x + a_2 x^2, \label{eq:poly}\\
  g(x) &= b_0 + b_1 x. \label{eq:linear}
\end{align}

% Or IEEEeqnarray (native, preferred by IEEE):
\begin{IEEEeqnarray}{rCl}
  f(x) &=& a_0 + a_1 x + a_2 x^2, \label{eq:poly2}\\
  g(x) &=& b_0 + b_1 x. \label{eq:linear2}
\end{IEEEeqnarray}
```

### 4.3 Math Typesetting Rules

| Element | Format | Example |
|---------|--------|---------|
| Variables | *Italic* | $x$, $y$, $n$ |
| Vectors | **Bold italic** | $\mathbf{x}$, $\boldsymbol{\theta}$ |
| Matrices | **Bold uppercase** | $\mathbf{A}$, $\mathbf{M}$ |
| Functions | Roman (upright) | $\sin$, $\cos$, $\log$, $\min$ |
| Constants | Roman | $\mathrm{e}$ (Euler), $\mathrm{j}$ (imaginary) |
| Units | Roman, thin space | $5~\mathrm{V}$, $10~\mathrm{MHz}$ |
| Minus sign | Long dash | `$-$` not hyphen `-` |

**Critical:** Variables must be italic BOTH in equations AND in running text. Don't write "the variable n" — write "the variable $n$".

### 4.4 Display Math Rules

```latex
% CORRECT display math:
\begin{equation}
  E = mc^2
\end{equation}

% Or without numbering:
\begin{equation*}
  E = mc^2
\end{equation*}

% NEVER use $$ ... $$ for display math in LaTeX:
%% $$ E = mc^2 $$  % BAD — PlainTeX syntax, causes spacing issues

% NEVER use \nonumber or \notag inside {array}
```

### 4.5 Long Equations

It is the **author's responsibility** to ensure equations fit within column width. Strategies:

- Use the solidus `/` instead of `\frac{}{}` for inline fractions.
- Use `\exp()` instead of `e^{...}` for complex exponents.
- Break long equations using `align` with `\\` and proper alignment.
- Use subfunctions to reduce width.
- **NEVER alter math font size** to fit equations.

---

## 5. Figures

### 5.1 Basic Figure

```latex
\begin{figure}[!t]    % [!t] = top of page, IEEE standard placement
  \centering
  \includegraphics[width=\columnwidth]{figures/myimage.pdf}
  \caption{Description of the figure. End with a period.}
  \label{fig:myimage}  % MUST be AFTER \caption
\end{figure}
```

### 5.2 Double-Column Figure

```latex
\begin{figure*}[!t]   % figure* spans both columns
  \centering
  \includegraphics[width=\textwidth]{figures/wide_image.pdf}
  \caption{A wide figure spanning both columns.}
  \label{fig:wide}
\end{figure*}
```

### 5.3 Subfigures

```latex
\begin{figure}[!t]
  \centering
  \subfloat[First case.]{\includegraphics[width=0.45\columnwidth]{fig_a.pdf}%
    \label{fig:case_a}}
  \hfil
  \subfloat[Second case.]{\includegraphics[width=0.45\columnwidth]{fig_b.pdf}%
    \label{fig:case_b}}
  \caption{Overall caption for both subfigures.}
  \label{fig:cases}
\end{figure}
```

### 5.4 Figure Rules

1. **\label MUST go AFTER \caption.** Placing it before produces wrong numbering (references the section number instead). This is the #1 most common LaTeX mistake.
2. Use `[!t]` for float placement (top of page, IEEE standard).
3. **Image formats:** Use PDF or EPS for vector graphics (graphs, charts, diagrams). Use PNG/JPEG only for photographs.
4. **Resolution:** Minimum 300 DPI for bitmap images; 600 DPI preferred.
5. **Reference in text:** `Fig.~\ref{fig:myimage}` — abbreviate "Fig." except at start of sentence: "Figure~\ref{fig:myimage} shows..."
6. **Numbering:** Figures are numbered sequentially: Fig. 1, Fig. 2, etc.
7. **Captions:** Below the figure. End with a period. Descriptive but concise.
8. Use `graphicx` package. NEVER use `psfig` or `epsfig`.
9. Do NOT specify the graphics driver when loading graphicx: `\usepackage{graphicx}` (no `[dvips]` or `[pdftex]`).
10. Ensure the BoundingBox is trimmed properly to avoid excessive whitespace.

---

## 6. Tables

### 6.1 Basic Table

```latex
\begin{table}[!t]
  \caption{Results of the Experiment}  % Caption ABOVE the table (IEEE style)
  \label{tab:results}                  % AFTER \caption
  \centering
  \begin{tabular}{lcc}
    \toprule
    \textbf{Method} & \textbf{Accuracy (\%)} & \textbf{Time (s)} \\
    \midrule
    Method A & 95.2 & 1.3 \\
    Method B & 97.8 & 2.1 \\
    Proposed & \textbf{99.1} & 1.5 \\
    \bottomrule
  \end{tabular}
\end{table}
```

### 6.2 Table Rules

1. **Caption goes ABOVE the table** (unlike figures where it goes below).
2. **\label MUST go AFTER \caption.**
3. **Numbering:** Tables use Roman numerals: TABLE I, TABLE II, etc.
4. **Reference in text:** `Table~\ref{tab:results}` — do NOT abbreviate "Table".
5. Use `table*` for double-column tables.
6. Use `booktabs` for professional rules (`\toprule`, `\midrule`, `\bottomrule`). Avoid vertical lines and excessive horizontal lines.
7. Column headers should be bold.
8. Units should be in the header row, not repeated in every cell.

---

## 7. Citations and Bibliography

### 7.1 BibTeX Setup

```latex
% At the end of the document, before \end{document}:
\bibliographystyle{IEEEtran}
\bibliography{references}       % loads references.bib
```

### 7.2 Using the cite Package

The `cite` package (recommended) automatically sorts and compresses citation ranges:

```latex
\usepackage{cite}

% In text:
As shown in \cite{smith2020,jones2021,doe2022}
% Produces: As shown in [1]-[3]    (if consecutive)
% Or:       As shown in [1], [3], [5]  (if not)
```

### 7.3 Citation Style Rules

| Usage | Example | Correct Output |
|-------|---------|----------------|
| As footnote | `shown in \cite{ref1}` | shown in [1] |
| As noun | `In \cite{ref1}, it was shown...` | In [1], it was shown... |
| Multiple | `\cite{ref1,ref2,ref3}` | [1]–[3] |
| Specific section | `\cite[Sec.~V]{ref4}` | [4, Sec. V] |
| Two citations | `\cite{ref1}, \cite{ref2}` | [1], [2] (note the space) |

### 7.4 BibTeX Entry Best Practices

```bibtex
% JOURNAL ARTICLE
@ARTICLE{heath2016overview,
  author  = {Heath, R. W. and Gonz{\'a}lez-Prelcic, N. and Rangan, S.},
  title   = {An Overview of Signal Processing Techniques for
             Millimeter Wave {MIMO} Systems},
  journal = IEEE_J_STSP,          % Use IEEEabrv abbreviation macros
  volume  = {10},
  number  = {3},
  pages   = {436--453},           % en dash -- for page ranges
  month   = apr,                  % Three-letter month abbreviation
  year    = {2016},
}

% CONFERENCE PAPER
@INPROCEEDINGS{roberts2020fsbfc,
  author    = {Roberts, Ian P. and Jain, Hardik B.},
  title     = {Frequency-Selective Beamforming Cancellation Design
               for Millimeter-Wave Full-Duplex},
  booktitle = IEEE_C_ICC,         % Use IEEEabrv abbreviation macros
  year      = {2020},
  pages     = {1--6},
}

% BOOK
@BOOK{haykin2009neural,
  author    = {Haykin, Simon},
  title     = {Neural Networks and Learning Machines},
  publisher = {Pearson},
  year      = {2009},
  edition   = {3rd},
}
```

### 7.5 BibTeX Critical Rules

1. **Use `IEEEtran.bst`** — it handles IEEE formatting automatically.
2. **Use `IEEEabrv.bib`** macros for journal/conference names (e.g., `IEEE_J_STSP` instead of writing "IEEE J. Sel. Topics Signal Process." manually).
3. **Protect capitalization** in titles with braces: `{MIMO}`, `{GPS}`, `{Bayesian}`.
4. **Always use en dash `--`** for page ranges: `pages = {1--6}`.
5. **Use three-letter month** abbreviations without braces: `month = jan`.
6. **Use accented characters** properly: `Gonz{\'a}lez`.
7. **Never manually format references.** Use BibTeX exclusively.
8. **Don't trust auto-generated BibTeX** from IEEE Xplore or Google Scholar blindly — always verify and clean entries.
9. **References are NOT sorted** in IEEE style — they appear in citation order.
10. **Compile sequence:** `latex` → `bibtex` → `latex` → `latex` (run LaTeX twice after BibTeX).
11. **Don't forget to submit your .bib files** alongside the .tex source.

### 7.6 IEEEabrv Journal/Conference Macros

Use abbreviation macros from `IEEEabrv.bib` for consistency:

```bibtex
% Instead of:
journal = {IEEE Transactions on Signal Processing},
% Use:
journal = IEEE_J_SP,

% Instead of:
booktitle = {Proc. IEEE International Conference on Communications},
% Use:
booktitle = IEEE_C_ICC,
```

Load the abbreviations file:
```latex
\bibliography{IEEEabrv,references}
```

---

## 8. Cross-References

### 8.1 Golden Rules

1. **Always use soft references** (`\ref{}`, `\eqref{}`), NEVER hard-code numbers.
2. **\label MUST go AFTER the counter-updating command:**
   - After `\caption{}` in figures/tables
   - After `\section{}`, `\subsection{}`
   - Inside or after `\begin{equation}`
3. **Never assign the same label** to two different elements.

### 8.2 Reference Formatting

| Element | In text | At sentence start |
|---------|---------|-------------------|
| Figure | `Fig.~\ref{fig:x}` | `Figure~\ref{fig:x}` |
| Table | `Table~\ref{tab:x}` | `Table~\ref{tab:x}` |
| Equation | `\eqref{eq:x}` | `Equation~\eqref{eq:x}` |
| Section | `Section~\ref{sec:x}` | `Section~\ref{sec:x}` |
| Algorithm | `Algorithm~\ref{alg:x}` | `Algorithm~\ref{alg:x}` |

Use `~` (non-breaking space) between the label word and `\ref`.

---

## 9. Units, Abbreviations, and Language

### 9.1 Units

- Use SI (MKS) or CGS as primary units. Imperial units may appear in parentheses.
- **Spell out units** in running text: "a few henries" not "a few H".
- In figures and tables, abbreviations are OK: V, A, Hz, MHz, etc.
- Use a thin space between number and unit: `$5~\mathrm{V}$`.
- Do NOT mix SI and CGS units (exception: magnetic quantities).
- Temperature: "Celsius" not "centigrade".

### 9.2 Abbreviations and Acronyms

- **Define on first use** in the text, even if defined in the abstract.
- Standard abbreviations that DON'T need definition: IEEE, SI, MKS, CGS, ac, dc, rms.
- Do NOT use abbreviations in titles or headings unless absolutely unavoidable.
- Example first use: "signal-to-noise ratio (SNR)" then "SNR" afterwards.

### 9.3 Common Language Mistakes to Avoid

| Incorrect | Correct |
|-----------|---------|
| "data is" | "data are" (data is plural) |
| "it's" for possessive | "its" (possessive); "it's" = "it is" |
| "effect" as verb | "affect" as verb, "effect" as noun |
| "non linear" | "nonlinear" |
| "utilize" | "use" (simpler is better) |
| "In order to" | "To" |
| Passive overuse | Active voice preferred: "We propose..." |

---

## 10. Common Mistakes Checklist

### 10.1 Critical LaTeX Mistakes

- [ ] **\label before \caption** → Wrong numbering. Always: `\caption{...}\label{...}`
- [ ] **Using `$$...$$`** → Use `\begin{equation}...\end{equation}` or `\[...\]`
- [ ] **Using `{eqnarray}`** → Use `{align}` or `{IEEEeqnarray}`
- [ ] **Hard-coded references** like `(1)` or `Fig. 3` → Use `\eqref{}`, `\ref{}`
- [ ] **Duplicate labels** → Each `\label{}` must be unique across the document
- [ ] **\nonumber inside {array}** → Does nothing; may break outer equation
- [ ] **Altering margins/fonts** → NEVER modify IEEEtran layout
- [ ] **Missing .bib files** on submission → Always include them
- [ ] **Wrong compile sequence** → Must run `bibtex` then `latex` twice
- [ ] **Loading obsolete packages** → Audit: remove psfig, subfigure, etc.
- [ ] **Not using `\usepackage{cite}`** → Causes unsorted/uncompressed citations
- [ ] **Specifying graphics driver** → `\usepackage{graphicx}` with no options

### 10.2 Content and Formatting Mistakes

- [ ] **Symbols/math in title or abstract**
- [ ] **Abbreviations not defined on first use**
- [ ] **Variables not in italic in running text**
- [ ] **Page limit exceeded** (check conference/journal requirements)
- [ ] **Unbalanced last-page columns** → Use `\balance` or `flushend` package
- [ ] **Copyright notice manually added** → IEEE inserts this automatically
- [ ] **Keywords not using IEEE Taxonomy terms**
- [ ] **Missing acknowledgment section** for funded work

---

## 11. IEEE Conference vs. Journal Specifics

### 11.1 Conference Papers

```latex
\documentclass[conference]{IEEEtran}
\IEEEoverridecommandlockouts  % Needed for \thanks in conference mode
```

- Typical length: 4–6 pages (some allow 2 extra pages with fee).
- Page size: US Letter (8.5" × 11") unless stated otherwise.
- **Do NOT add copyright notice** — IEEE inserts it automatically.
- Some conferences require generating PDF via IEEE PDF eXpress.
- Keywords may not be supported in all conference LaTeX templates (check instructions).

### 11.2 Journal Papers

```latex
\documentclass[journal]{IEEEtran}
```

- Often submitted single-column for peer review; final version is two-column.
- Include author biographies with `\begin{IEEEbiography}` at the end.
- Abstract: 100–200 words.
- Include `\thanks{}` for manuscript dates and affiliations.

---

## 12. Advanced Tips

### 12.1 Balancing Last Page Columns

```latex
% Option A: Manual
\balance  % Place before bibliography or at the start of last page

% Option B: Automatic
\usepackage{flushend}  % Automatically balances last page
```

### 12.2 Triggering Page Breaks Before References

```latex
\IEEEtriggeratref{10}  % Page break before reference [10]

% Custom trigger command:
\IEEEtriggercmd{\enlargethispage{-5in}}
\IEEEtriggeratref{8}
```

### 12.3 Algorithm Environment

```latex
\begin{algorithm}[!t]
  \caption{Algorithm Title}
  \label{alg:example}
  \begin{algorithmic}[1]  % [1] = number every line
    \REQUIRE Input data $X$
    \ENSURE Output result $Y$
    \STATE Initialize $Y \gets 0$
    \FOR{$i = 1$ \TO $n$}
      \IF{$x_i > \theta$}
        \STATE $Y \gets Y + x_i$
      \ENDIF
    \ENDFOR
    \RETURN $Y$
  \end{algorithmic}
\end{algorithm}
```

### 12.4 Author Biographies (Journal only)

```latex
% Without photo:
\begin{IEEEbiographynophoto}{Author Name}
  Biography text here.
\end{IEEEbiographynophoto}

% With photo:
\begin{IEEEbiography}[{\includegraphics[width=1in,height=1.25in,clip,
    keepaspectratio]{photos/author.jpg}}]{Author Name}
  Biography text here.
\end{IEEEbiography}
```

Photo specs: 1" × 1.25", 300 DPI minimum, grayscale 8-bit.

### 12.5 Appendices

```latex
\appendices
\section{Proof of Theorem 1}  % Becomes "Appendix A"
\label{app:proof1}

% Equations in appendix: (A1), (A2), etc.
% This is handled automatically by IEEEtran after \appendices.
```

### 12.6 Compile Workflow

For full compilation with BibTeX:

```bash
# Standard workflow:
pdflatex paper.tex
bibtex paper          # Processes .bib → .bbl
pdflatex paper.tex    # Resolves citations
pdflatex paper.tex    # Resolves cross-references

# Or with latexmk (automates everything):
latexmk -pdf paper.tex
```

---

## 13. Submission Checklist

Before submitting to IEEE:

1. **Compile cleanly** — no errors, minimal warnings.
2. **Check page limits** — respect conference/journal limits strictly.
3. **Verify all references** appear and are complete.
4. **Spell-check** everything, especially the abstract.
5. **Run PDF eXpress** if required by the conference.
6. **Include all source files**: `.tex`, `.bib`, image files.
7. **Do NOT include**: copyright notice (IEEE adds it), page numbers for conferences.
8. **Verify columns balance** on the last page.
9. **Check all figures** are legible when printed in black and white.
10. **Confirm PDF is searchable** (Type 1 or TrueType fonts, not Type 3).

---

## 14. Quick Reference: Minimum Viable Paper

```latex
\documentclass[conference]{IEEEtran}
\IEEEoverridecommandlockouts
\usepackage{cite}
\usepackage{amsmath,amssymb}
\usepackage{graphicx}
\usepackage[caption=false]{subfig}
\usepackage{url}

\begin{document}

\title{A Descriptive Title Without Special Characters}

\author{
  \IEEEauthorblockN{Author Name}
  \IEEEauthorblockA{Department, University\\
  City, Country\\
  email@university.edu}
}

\maketitle

\begin{abstract}
A concise 100--200 word summary. No citations, no equations,
no special characters.
\end{abstract}

\begin{IEEEkeywords}
Keyword one, keyword two, keyword three.
\end{IEEEkeywords}

\section{Introduction}
The problem addressed in this paper \cite{refkey}...

\section{Proposed Method}
We propose a method based on \eqref{eq:main}:
\begin{equation}
  y = f(x) + \epsilon
  \label{eq:main}
\end{equation}

\section{Results}
Results are shown in Table~\ref{tab:results} and Fig.~\ref{fig:result}.

\begin{table}[!t]
  \caption{Experimental Results}
  \label{tab:results}
  \centering
  \begin{tabular}{lc}
    \hline
    \textbf{Method} & \textbf{Accuracy} \\
    \hline
    Baseline & 90.1\% \\
    Proposed & \textbf{95.7\%} \\
    \hline
  \end{tabular}
\end{table}

\begin{figure}[!t]
  \centering
  \includegraphics[width=\columnwidth]{result.pdf}
  \caption{Experimental results visualization.}
  \label{fig:result}
\end{figure}

\section{Conclusion}
Conclusions and future work.

\section*{Acknowledgment}
The authors thank...

\bibliographystyle{IEEEtran}
\bibliography{references}

\end{document}
```

---

## 15. Antipatrones Frecuentes (Errores Reales)

Estos patrones se observan frecuentemente en documentos de estudiantes e investigadores. Evitarlos a toda costa:

### 15.1 El Antipatrón `[H]` (float package)
```latex
% ❌ MAL: Fuerza posición, destruye el layout
\usepackage{float}
\begin{figure}[H]
  ...
\end{figure}
\FloatBarrier

% ✅ BIEN: Deja que LaTeX maneje la ubicación
\begin{figure}[!t]
  ...
\end{figure}
```
**Regla:** `[H]` causa espacios en blanco enormes, columnas desbalanceadas y rechazos editoriales. IEEE usa `[!t]`. Confiar en el algoritmo de LaTeX.

### 15.2 El Antipatrón de Referencias Manuales
```latex
% ❌ MAL: Sin BibTeX, sin \cite{}, formato inconsistente
\section*{Referencias}
Páginas de manual: mdadm(8).\\
Sitio web: https://example.com

% ✅ BIEN: BibTeX maneja todo automáticamente
\bibliographystyle{IEEEtran}
\bibliography{references}
```
**Regla:** SIEMPRE usar BibTeX con `IEEEtran.bst`. Las citas manuales son propensas a errores y no generan los `[1]` numerados que IEEE requiere.

### 15.3 El Antipatrón de `\setkeys{Gin}` Global
```latex
% ❌ MAL: Aplica dimensiones a TODAS las imágenes
\setkeys{Gin}{width=\columnwidth, height=0.35\textheight, keepaspectratio}

% ✅ BIEN: Tamaño por figura
\includegraphics[width=\columnwidth]{imagen.pdf}
```

### 15.4 El Antipatrón de `verbatim` para Código
```latex
% ❌ MAL: No respeta columnas, no tiene resaltado, comandos rotos
\begin{verbatim}
sudo mdadm --create --verbose 
/dev/md0 --level=1 \
--raid-devices=3 /dev/sdb
\end{verbatim}

% ✅ BIEN: listings respeta columnas y permite continuación
% Configurar lstset con márgenes suficientes para evitar solapamiento:
%   xleftmargin=8pt, xrightmargin=8pt,
%   framexleftmargin=6pt, framexrightmargin=6pt
\begin{lstlisting}[language=bash]
sudo mdadm --create --verbose /dev/md0 \
    --level=1 --raid-devices=3 \
    /dev/sdb /dev/sdc /dev/sdd
\end{lstlisting}
```

### 15.5 El Antipatrón de Paquetes Excesivos
```latex
% ❌ MAL: Carga paquetes que alteran o duplican funcionalidad
\usepackage{float}              % Causa [H]
\usepackage[section]{placeins}  % Parchea un problema que no debería existir
\usepackage{dblfloatfix}        % Rara vez necesario
\usepackage[export]{adjustbox}  % No estándar IEEE

% ✅ BIEN: Solo paquetes necesarios y recomendados
% (ver sección 2 de esta skill para la lista completa)
```

### 15.6 El Antipatrón de `\textbf{}` como Encabezado
```latex
% ❌ MAL: Simula encabezados con negrita, rompe la estructura
\textbf{Descripción:} Aquí va el texto...
\textbf{Evidencia:} La figura muestra...
\textbf{Análisis:} Los datos indican...

% ✅ BIEN: Usar estructura jerárquica de LaTeX
\subsubsection{Descripción}
Aquí va el texto...
% O para encabezados en línea:
\paragraph{Evidencia}
La figura muestra...
```
**Regla:** IEEE tiene 3 niveles de encabezado (`\section`, `\subsection`, `\subsubsection`). Usar `\paragraph{}` para el cuarto nivel informal. Nunca simular encabezados con `\textbf{}`.

---

## Summary of Golden Rules

1. **Never alter IEEEtran layout** (margins, fonts, spacing).
2. **\label always AFTER \caption** or the counter-updating command.
3. **Use `align`/`IEEEeqnarray`**, never `eqnarray`.
4. **Use `\eqref{}`** for equation references, `\ref{}` for everything else.
5. **Use BibTeX with `IEEEtran.bst`**, never format references manually.
6. **Protect uppercase** in BibTeX titles with braces: `{MIMO}`.
7. **Define acronyms on first use** in the text body.
8. **Variables are italic everywhere** — in equations AND in text.
9. **Figures: caption below.** Tables: caption above.
10. **Compile: pdflatex → bibtex → pdflatex → pdflatex.**
