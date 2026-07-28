# HM Coq Soundness and Type Safety

This project contains Coq proofs for a small Hindley-Milner-style language.

## Files

- `HMSoundness.v`: inference soundness for an HM-style inference relation.
- `HMTypeSafety.v`: operational type safety for the typed core language, including substitution, progress, and preservation.
- `hm_safety_report.tex`: LaTeX report source.
- `hm_safety_report.pdf`: English report PDF.
- `hm_safety_report_ja.pdf`: Japanese report PDF generated from local fonts.
- `make_japanese_pdf.py`: script used to generate the Japanese PDF without Japanese LaTeX packages.

## Verify

```sh
coqc HMSoundness.v
coqc HMTypeSafety.v
```

## Build Report

```sh
pdflatex -interaction=nonstopmode hm_safety_report.tex
python3 make_japanese_pdf.py
```
