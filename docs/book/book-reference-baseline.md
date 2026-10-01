# Book Reference Baseline

**Book:** *Project Bob — Accelerating Mainframe Modernization with Agentic AI*
**Repository release:** v0.3.10
**Document purpose:** Canonical reference anchors for the Project Bob companion repository

---

## Book identity

**Title:** Project Bob  
**Subtitle:** Accelerating Mainframe Modernization with Agentic AI

This is not a COBOL-to-Java conversion book. It is a book about how agentic AI compresses the cycle from understanding a legacy capability to making, proving, and safely introducing a modernization decision. Java and API modernization are one possible later-stage outcome, not the definition of modernization.

---

## Repository release

**Version:** v0.3.9 — Book Reference Baseline & Repository Hygiene  
**Reference tag:** v0.3.9

Reproduction of book-cited artifacts must be pinned to the v0.3.9 reference tag.

---

## Canonical estate

**Estate:** AtlasPay  
**Status:** Synthetic  

AtlasPay is a fully synthetic mainframe reference estate. All names, code, records, and business rules are invented for teaching purposes. No real institution's source code, customer data, internal architecture, proprietary logic, credentials, or production operating procedures are included.

---

## Canonical capability

**Capability:** Dynamic Transaction Limit  

The canonical business problem is: the business wants transaction limits to incorporate account/product characteristics, transaction context, jurisdictional rules, temporary controls, historical exceptions, and current risk indicators.

---

## Canonical source root

**Application source:** `examples/atlaspay/src/`  
**COBOL programs:** `examples/atlaspay/src/cobol/`  
**Copybooks:** `examples/atlaspay/src/copybooks/`

These are the authoritative current paths for all book citations, analysis runs, and framework experiments.

---

## Canonical test root

**Active characterization suite:** `examples/atlaspay/tests/golden-master/cases.yaml`

This is the current active suite. The older file at `examples/atlaspay/archive/v0.1/tests/golden-master-cases.yaml` is historical frozen evidence retained for the KU-13 story and is not the active suite.

---

## Canonical governed disposition

**Disposition:** REFACTOR — APPROVED WITH CONDITIONS  

This is the human-authorized modernization disposition for the Dynamic Transaction Limit capability in the reference progression.

---

## Framework

**Framework name:** Agentic Mainframe Modernization Framework

**Lifecycle:**

```
UNDERSTAND → DECIDE → PLAN → TRANSFORM → PROVE → SHIFT → LEARN
```

**Core rules:**

1. No Evidence, No Progression.
2. Agents perform work. Humans retain authority.
3. Agent autonomy decreases as irreversibility increases.
4. Native Capability First.
5. No deployment from TRANSFORM.
6. A plausible conclusion without sufficient evidence is not proof.

---

## Reference progression depth

The reference progression is deeply exercised through PROVE.

- Run 001 (UNDERSTAND) — completed, evaluated against ground truth
- Run 002 (DECIDE) — completed, human gate passed
- Run 003 (PLAN) — completed, human gate passed
- Run 004 (TRANSFORM) — completed, human gate passed
- Run 005 (PROVE) — completed, human PROVE exit gate passed
- Run 006 (PROVE hardening) — completed with one bounded corrective iteration, released as v0.3.8 with `PASS_WITH_DOCUMENTED_EVIDENCE_LIMITATIONS`

SHIFT and LEARN are defined in the framework but are not exercised in the reference progression published in this repository at v0.3.9.

---

## Runtime validation status

**Runtime validation is unavailable.**

The reference progression is conducted through static analysis, evidence review, and inspection of characterization artifacts. No authorized executable runtime or executable characterization harness is established by the published reference progression. No authorized runtime environment exists for the AtlasPay estate at this repository version.

Claims of runtime equivalence or production readiness are not supported by the available evidence. PROVE completion establishes static verification only.

---

## SHIFT authorization

**SHIFT is not authorized** merely by PROVE completion.

SHIFT requires:
- human authorization of production exposure;
- predefined telemetry and rollback thresholds;
- production-grade runtime evidence;
- explicit PROVE-to-SHIFT gate passage.

None of these exist for AtlasPay at v0.3.10.

---

## Deployment authorization

**Deployment is not authorized** by this repository or any artifact within it at v0.3.10.

---

## Production change authorization

**No production change is authorized** by any artifact in this repository at v0.3.10.

---

## Hidden evaluator truth

The evaluator-only ground truth at `evals/atlaspay/ground-truth.yaml` is never book input and never Bob workspace input. It is a post-run scoring artifact only. Book readers and model agents must not have access to this file during any scored run.

AtlasPay is no longer a blind holdout after Run 001 evaluation. Later runs are regression and continuation evidence.

---

## Native Capability First

The framework uses verified IBM Bob Premium Package for Z capabilities before substituting a framework prompt for the same task. Z Understand-backed analysis may be used when it is configured, available, and authorized. The published Run 001 reference execution used PP4Z workspace mode and did not configure Z Understand (`z_understand.configured: false`). The framework does not describe portable YAML playbooks as replacements for native Bob capabilities.

---

## Read it in the book. Run it in the repo.

Book prose describes what the framework does and why. Repository artifacts at v0.3.10 are the runnable, inspectable reference implementation.

---

## Related assets

| Asset | Path |
|---|---|
| Book baseline YAML | `docs/book/book-baseline.yaml` |
| Framework definition | `docs/agentic-mainframe-modernization.md` |
| Book mapping | `docs/book-mapping.md` |
| AtlasPay README | `examples/atlaspay/README.md` |
| Evidence runs | `evidence/atlaspay/runs/` |
| Governance autonomy policy | `governance/autonomy-policy.yaml` |
| Human gates | `governance/human-gates.yaml` |
| Full lifecycle workflow | `workflows/full-agentic-modernization/` |
