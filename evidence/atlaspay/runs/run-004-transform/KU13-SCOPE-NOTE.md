# KU-13 Scope Clarification

**Status:** Publication-layer scope clarification — does NOT modify frozen Run 004 or Run 005 artifacts.

---

## Overview

KU-13 has two distinct dimensions that must not be conflated. This note makes those dimensions explicit.

---

## Dimension A — Regression-oracle authority

**Status: `RESOLVED_FOR_SYNTHETIC_REGRESSION_BASELINE`**

A human authority decision was made during Run 004 (Slice 0) to select the source-implemented behavior of the synthetic AtlasPay estate as the regression oracle for the transformation exercise.

This decision is recorded in the frozen artifact:

`evidence/atlaspay/runs/run-004-transform/00-ku13-authority-decision.md`

And elaborated in:

`evidence/atlaspay/runs/run-004-transform/01-slice-0-characterization-baseline.md`

**What this resolution means:**

- The characterization behavior implemented in the synthetic source is the accepted baseline for regression testing within this exercise.
- Subsequent static-verification claims in PROVE (Run 005 and Run 006) can use this baseline as the regression oracle.
- This resolution was sufficient for the synthetic transformation exercise to proceed.

**What this resolution does NOT mean:**

- It does not establish what historical production business intent originally was.
- It does not claim that the selected synthetic oracle is a recovered real-world business policy.
- It does not establish external regulatory, network, contractual, or production-system intent.
- It does not authorize deployment, production change, or SHIFT.

---

## Dimension B — Historical/business intent

**Status: `UNRESOLVED / NOT CLAIMED`**

The original business intent behind the characterization values (e.g., why a specific limit is `6000.00`, what regulatory or contractual origin it has, whether it is still the current business policy) is not established by the AtlasPay synthetic estate and was not established by the Run 004 authority decision.

This dimension remains explicitly open:

- No historical production artifact was recovered that confirms the business intent.
- No regulatory, network, or contractual source was identified.
- The synthetic estate does not claim to represent any real institution's policy.

---

## Why PROVE still references KU-13 as open

In Run 005 and Run 006, KU-13 is listed as an open containment gate. This is consistent with the above.

- The regression-oracle authority (Dimension A) was resolved for the synthetic exercise.
- The historical/business-intent dimension (Dimension B) remains unresolved.
- PROVE references to KU-13 as still open refer to Dimension B — the unresolved business intent — not to the regression-oracle authority.

These two references are not contradictory. The oracle was selected; the underlying business intent was not recovered.

---

## Explicit summary

| Dimension | Status |
|---|---|
| Regression-oracle authority for synthetic transformation exercise | `RESOLVED_FOR_SYNTHETIC_REGRESSION_BASELINE` |
| Historical production business intent | `UNRESOLVED / NOT CLAIMED` |
| External regulatory/contractual/network intent | `UNRESOLVED / NOT CLAIMED` |
| Real-world policy recovery | `NOT ATTEMPTED — synthetic estate` |

---

## Related frozen artifacts (not modified by this note)

| Artifact | Role |
|---|---|
| `evidence/atlaspay/runs/run-004-transform/00-ku13-authority-decision.md` | Human KU-13 oracle authority decision |
| `evidence/atlaspay/runs/run-004-transform/01-slice-0-characterization-baseline.md` | Characterization baseline establishing oracle |
| `evidence/atlaspay/runs/run-005-prove/01-modernization-proof-package.md` | Run 005 proof references KU-13 as open (Dimension B) |
| `evidence/atlaspay/runs/run-006-prove-hardening/01-modernization-proof-package-raw.md` | Run 006 initial proof references KU-13 as open (Dimension B) |
