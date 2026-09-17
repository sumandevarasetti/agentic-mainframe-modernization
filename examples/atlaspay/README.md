# AtlasPay Mainframe Reference Estate

**Estate version:** 0.1.0  
**Status:** Synthetic reference application

AtlasPay is the canonical teaching and evaluation estate for Project Bob.

It is intentionally smaller than a real production mainframe portfolio but rich enough to exercise application understanding across online code, batch jobs, data stores, external messaging, exceptions, and incomplete documentation.

## Canonical business problem

**Dynamic Transaction Limit**

The business wants transaction limits to incorporate account/product characteristics, transaction context, jurisdictional rules, temporary controls, historical exceptions, and current risk indicators.

The modernization question is not "convert COBOL to Java." It is: **what is the safest and most valuable way to evolve this capability?**

## Estate contents

- `src/cobol/` — online and batch COBOL programs
- `src/copybooks/` — shared request/response/context layouts
- `jcl/` — batch jobs
- `db2/` — synthetic policy/account tables
- `vsam/` — synthetic grandfathered exceptions
- `mq/` — risk-service message contracts
- `cics/` — transaction/program metadata
- `tests/` — characterization/Golden Master cases
- `docs/` — intentionally incomplete documentation
- `modernization/` — book/framework walkthroughs
- `AGENTS.framework.md` — Agentic Strangler governance overlay to merge into Bob-generated `AGENTS.md` after `/init`

## IBM Bob experiment note

For scored PP4Z experiments, do not open the complete framework repository as the Bob workspace because evaluator ground truth exists outside this directory. Use the isolated-workspace procedure in `integrations/ibm-bob/understand/atlaspay-experiment-001.md`.

## Important

All names, code, records, and business rules are synthetic. No U.S. Bank or other real institution source code, customer data, internal architecture, or proprietary logic is included.

## Evaluation truth

The framework maintains a separate ground-truth specification under `evals/atlaspay/`. That file exists only for post-run evaluation and must not be exposed to the model during a scored run.
