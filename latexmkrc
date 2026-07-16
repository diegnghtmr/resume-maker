# latexmkrc — build configuration for the résumé system.
#
# Always compile from the REPO ROOT, e.g.:
#     latexmk cv/main-en.tex
# CI (xu-cheng/latex-action) runs latexmk from the repo root too, so it reads
# this same file. Do NOT compile from inside cv/ — the \input paths are relative
# to the root.

# Use pdflatex: the class relies on \pdfgentounicode and \input{glyphtounicode}.
$pdf_mode = 1;

# Keep artifacts out of the source tree and mirror the public URL layout
# (https://diegnghtmr.github.io/resume-maker/cv/<name>.pdf).
$out_dir = 'build/cv';
$aux_dir = 'build/cv';

# Make the shared class (shared/fed-res.cls) and the language partials
# (content/**) importable from the root. Trailing empty entry keeps the standard
# TeX search path so system packages still resolve. '//' searches recursively.
$ENV{'TEXINPUTS'} = './shared//:./content//:' . ($ENV{'TEXINPUTS'} // '');
$ENV{'BIBINPUTS'} = './shared//:' . ($ENV{'BIBINPUTS'} // '');
