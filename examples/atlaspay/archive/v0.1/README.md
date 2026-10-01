# AtlasPay Archive — v0.1 Historical Material

**Classification:** Historical frozen evidence  
**Status:** Archived — not the current AtlasPay source of truth

---

## What this directory contains

This directory contains AtlasPay material from the initial v0.1 phase of the project:

- **`cobol/`** — Simplified early COBOL source files used in initial framework prototyping (3 programs: CUSTRSK, LIMITPOL, TRNLIM01). These predate the full synthetic estate.
- **`illustrative-modernization/`** — An illustrative walkthrough of the seven-stage lifecycle (originally `modernization/chapter-03/`). This was a hand-crafted example used for early framework documentation.
- **`tests/golden-master-cases.yaml`** — An older characterization file with a different set of expected values. This file is evidence of the earlier conflicting characterization referenced in the KU-13 story during the AtlasPay TRANSFORM stage.

---

## Why these files are retained

These artifacts are preserved for:

1. **Provenance** — they document the origin and early evolution of the AtlasPay estate.
2. **The KU-13 story** — the conflict between `archive/v0.1/tests/golden-master-cases.yaml` and the current canonical suite at `tests/golden-master/cases.yaml` is an intentional evidence gap that the TRANSFORM stage was designed to surface and resolve.
3. **Framework history** — the illustrative modernization walkthrough in `illustrative-modernization/` demonstrates the lifecycle structure at an earlier stage of framework development.

---

## What is NOT current

These files are **not** the current AtlasPay source of truth. Do not:

- Use `archive/v0.1/cobol/` as the application source for any Bob run or analysis.
- Use `archive/v0.1/illustrative-modernization/` as authoritative modernization decisions for the current estate.
- Use `archive/v0.1/tests/golden-master-cases.yaml` as the active characterization suite.
- Feed archived modernization decisions as input to new Bob runs.

---

## Canonical current source roots

| Asset | Path |
|---|---|
| Current AtlasPay application source | `examples/atlaspay/src/` |
| Current COBOL programs | `examples/atlaspay/src/cobol/` |
| Active characterization suite | `examples/atlaspay/tests/golden-master/cases.yaml` |
| AtlasPay README | `examples/atlaspay/README.md` |

---

## Screenshot and book citation guidance

Historical frozen evidence in this archive is **not suitable** for book-facing screenshot recommendations. Artifacts here may contain terminology from earlier project phases that has since been superseded.

Current book-facing material should reference `examples/atlaspay/src/` and the published evidence runs under `evidence/atlaspay/runs/`.
