# AtlasPay Mainframe Reference Estate

**Estate version:** 0.3.9
**Status:** Synthetic reference application — canonical source of truth for Project Bob

AtlasPay is the canonical teaching and evaluation estate for Project Bob.

It is intentionally smaller than a real production mainframe portfolio but rich enough to exercise application understanding across online code, batch jobs, data stores, external messaging, exceptions, and incomplete documentation.

## Canonical business problem

**Dynamic Transaction Limit**

The business wants transaction limits to incorporate account/product characteristics, transaction context, jurisdictional rules, temporary controls, historical exceptions, and current risk indicators.

The modernization question is not "convert COBOL to Java." It is: **what is the safest and most valuable way to evolve this capability?**

---

## Canonical source roots

| Asset | Path |
|---|---|
| **Current application source** | `src/` |
| **Current COBOL programs** | `src/cobol/` |
| **Current copybooks** | `src/copybooks/` |
| **Active characterization suite** | `tests/golden-master/cases.yaml` |

These are the authoritative current paths. All Bob analysis runs, framework experiments, and book citations use `src/` as the application root.

---

## Estate contents

- `src/cobol/` — online and batch COBOL programs (canonical current source)
- `src/copybooks/` — shared request/response/context layouts
- `jcl/` — batch jobs
- `db2/` — synthetic policy/account tables
- `vsam/` — synthetic grandfathered exceptions
- `mq/` — risk-service message contracts
- `cics/` — transaction/program metadata
- `tests/` — characterization/Golden Master cases
- `docs/` — intentionally incomplete documentation
- `architecture/` — estate architecture documentation
- `AGENTS.framework.md` — Agentic Mainframe Modernization Framework governance overlay to merge into Bob-generated `AGENTS.md` after `/init`

---

## Historical archive

Earlier v0.1 material (simplified COBOL, illustrative modernization walkthrough, older characterization file) is preserved under `archive/v0.1/` for provenance and the KU-13 story. It is **not** the current source of truth. See `archive/v0.1/README.md`.

---

## IBM Bob experiment note

For scored PP4Z experiments, do not open the complete framework repository as the Bob workspace because evaluator ground truth exists outside this directory. Use the isolated-workspace procedure in `integrations/ibm-bob/understand/atlaspay-experiment-001.md`.

---

## Published evidence runs

Frozen evidence from AtlasPay Runs 001–006 is published under `evidence/atlaspay/runs/`. Each run directory contains a README with artifact inventory, SHA-256 hashes, and book-citation suitability.

---

## Important

All names, code, records, and business rules are synthetic. No real institution's source code, customer data, internal architecture, proprietary logic, credentials, or production operating procedures are included.

---

## Evaluation truth

The framework maintains a separate ground-truth specification under `evals/atlaspay/`. That file exists only for post-run evaluation and must not be exposed to the model during a scored run.
