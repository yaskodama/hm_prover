# HM Coq Soundness and Type Safety

This project contains Coq proofs for a small Hindley-Milner-style language.

## Files

- `HMSoundness.v`: inference soundness.  Instantiation substitutes for the
  quantified variables and generalization carries the Damas-Milner side
  condition, so the algorithmic and declarative systems genuinely differ and
  the theorem has an obligation to discharge (`gen_max_ok`).
- `HMTypeSafety.v`: progress and preservation for a polymorphic core with
  recursion.  Types have variables, environments map to schemes and `let` is
  polymorphic; quantified variables are de Bruijn indices, which rules out
  capture.  `fix f x. t` is in the language, so the proof now covers what
  MiniML's `let rec` elaborates to.  Beyond single-step preservation it proves
  `soundness`: a well-typed closed term never reaches a stuck state, however
  many steps it takes.  Termination is deliberately not claimed -- a
  well-typed divergent term is given, and shown never to get stuck.
- `HMSoundness.v` also proves the occurs check: if a variable occurs under an
  arrow in a type, no substitution solves the equation between them, so
  unification is right to refuse it.
- `hm_safety_report_ja.tex`: the report, in Japanese.  This is the one to read.
- `hm_safety_report.tex`: the same report in English.

Both carry the grammars, the type definitions and the inference rules of the
two developments in the usual notation.  The Japanese version works each proof
through case by case, and draws derivation trees where the argument is easiest
to see that way: the Let case of soundness, the two branches of the lambda case
of the substitution lemma, and E-Beta against E-Let in preservation.  The
English version has shorter sketches.  Note in both the closing section, which
sets out what the two theorems do and do not establish.

The proofs and the reports come from yaskodama/miniml3, where the earlier
versions kept here were repaired.  Instantiation used to be the identity and
generalization unconstrained, which left the algorithmic and declarative
relations identical and the soundness theorem a restatement; and the safety
proof used to be about a language with no type variables at all.

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
with mathpartir exactly as the English one does.  It replaces make_japanese_pdf.py, which drew the pages
with Pillow and could only render the rules as monospaced ASCII.
