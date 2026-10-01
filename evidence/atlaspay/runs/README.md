# AtlasPay Evidence Runs

**Published under repository version:** v0.3.9  
**Canonical estate:** AtlasPay (synthetic)

---

## Contents

| Directory | Stage | Status |
|---|---|---|
| `run-001-understand/` | UNDERSTAND | Published |
| `run-002-decide/` | DECIDE | Published |
| `run-003-plan/` | PLAN | Published |
| `run-004-transform/` | TRANSFORM | Published (with pre/post source snapshots) |
| `run-005-prove/` | PROVE | Published |
| `run-006-prove-hardening/` | PROVE (adversarial hardening) | Published |

---

## Evaluation blindness note

**AtlasPay is no longer a blind holdout after Run 001 evaluation.**

Run 001 was conducted with evaluator ground truth hidden from IBM Bob. After Run 001 outputs were frozen and scored externally against the evaluator-only ground truth, AtlasPay ceased to be a blind holdout. Runs 002–006 are regression and continuation evidence for the progression: DECIDE → PLAN → TRANSFORM → PROVE → PROVE hardening.

---

## Why this evidence is published

These artifacts are published for:

1. **Book transparency** — readers can inspect the actual artifacts behind book citations, not reconstructed summaries.
2. **Framework validation** — the complete sequence demonstrates the Agentic Mainframe Modernization Framework operating end-to-end through PROVE.
3. **Failure preservation** — Run 006 includes the initial Test A / Test C failures. These failures are not hidden. They are the evidence for Chapter 10.
4. **Hash integrity** — each run README records source and published SHA-256. Byte-identical copies are confirmed.

---

## What is excluded

- **Evaluator-only ground truth** (`evals/atlaspay/ground-truth.yaml`) — never published in runs or anywhere accessible to a model during a scored run.
- **SHIFT and LEARN evidence** — not exercised; not invented.
- Any artifact not present in the frozen `.work` directories was not published.

---

## Terminology note

Raw historical evidence may contain terminology from earlier phases of the project (e.g., draft framework names). Current framework terminology is defined in `docs/agentic-mainframe-modernization.md`. Historical terminology in frozen evidence does not invalidate the evidence.

---

## Screenshot and citation guidance

Each run README contains a per-artifact table indicating whether the artifact is suitable for book citation and screenshot use. Evaluator fixtures and SHA-256 summary files are marked as not suitable for screenshots.

All evidence citations must be pinned to tag `v0.3.9`.
