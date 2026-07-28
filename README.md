# HM Coq Soundness and Type Safety

This project contains Coq proofs for a small Hindley-Milner-style language.

## Files

- `HMSoundness.v`: inference soundness for an HM-style inference relation.
- `HMTypeSafety.v`: operational type safety for the typed core language, including substitution, progress, and preservation.
- `hm_safety_report_ja.tex`: the report, in Japanese.  This is the one to read.
- `hm_safety_report.tex`: the same report in English.

Both carry the grammars, the type definitions and the inference rules of the
two developments in the usual notation, and describe how each proof runs.  Note
in particular their closing section, which sets out what the two theorems do
and do not establish.

## Verify

```sh
coqc HMSoundness.v
coqc HMTypeSafety.v
```

## Build Report

```sh
lualatex -interaction=nonstopmode hm_safety_report_ja.tex   # run twice
pdflatex -interaction=nonstopmode hm_safety_report.tex      # run twice
```

Run each twice so the cross-references settle.  The Japanese version needs
LuaLaTeX, which luatexja drives; that is what lets it set the inference rules
with mathpartir exactly as the English one does.  It replaces an earlier script
that drew the pages with Pillow and could only render the rules as monospaced
ASCII.
