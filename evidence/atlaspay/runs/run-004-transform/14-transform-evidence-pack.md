# TRANSFORM Evidence Pack — AtlasPay Run 004

**Framework Stage:** TRANSFORM
**Run:** run-004
**Capability:** Dynamic Transaction Limit
**Framework Version:** v0.3.6
**Execution Mode:** PP4Z Workspace Mode
**Runtime Validation:** UNAVAILABLE
**Deployment Authorized:** FALSE
**Production Change Authorized:** FALSE

## 1. Purpose

This evidence pack consolidates the source changes, human gates, containment
decisions, unresolved known unknowns, and validation boundaries produced during
TRANSFORM Run 004.

The run demonstrates bounded source transformation under the rule:

**No Evidence, No Progression.**

It does not claim runtime behavioral equivalence.

---

## 2. Slice Summary

### Slice 0 — Characterization Baseline

**Outcome:** COMPLETE

- source modification: FALSE
- characterization type: STATIC
- KU-13 resolved for synthetic regression baseline
- authoritative synthetic behavior:

  `risk_score >= 800 -> candidate * 0.80`

- runtime validation: UNAVAILABLE

Human gate:

`02-slice-0-human-review-gate.md`

---

### Slice 1A — LIMITPOL Structural Refactoring

**Outcome:** APPROVED

Modified:

`src/cobol/LIMITPOL.cbl`

Post-change SHA-256:

`ca425f9884d7a729c38a0f8b4b517b065d6f2d903ccb3509203591ec85759b04`

Transformation:

- separated policy retrieval;
- separated result/fallback handling;
- preserved SQL selection semantics;
- preserved program interface;
- preserved 1000.00 fallback.

Open containment gates:

- KU-07 — applicable-row/effective-date semantics;
- C-05 — 1000.00 fallback business intent.

Static review: PASSED

Runtime equivalence: UNVERIFIED

Human gate:

`05-slice-1a-human-review-gate.md`

---

### Slice 2A — EXCEPT01 Structural Refactoring

**Outcome:** APPROVED

Modified:

`src/cobol/EXCEPT01.cbl`

Post-change SHA-256:

`6735cae2ebc0c354aa51d37af5ff1dd7ff43328d68fda6a7d427a755b33a21a1`

Transformation:

- separated initialization;
- separated exception lookup;
- preserved keyed VSAM access semantics;
- preserved ER-ACTIVE eligibility behavior;
- introduced no expiry/effective-date logic.

Open containment gates:

- KU-11 — 57/58-byte VSAM record-size discrepancy;
- KU-12 — runtime/CICS compatibility;
- KU-05 — reconciliation behavior;
- KU-06 — expiry ownership;
- C-03 — date-based eligibility intent.

Static review: PASSED

Runtime equivalence: UNVERIFIED

Human gate:

`08-slice-2a-human-review-gate.md`

---

### Slice 3 — MCC Policy-Intent Review

**Outcome:** COMPLETE — NO SOURCE CHANGE

`MERCHVAL.cbl` was deliberately left unchanged.

Observed numeric behavior retained:

- MCC 7995 -> 1000.00
- MCC 6051 -> 2000.00
- other MCC -> 9999999.99 sentinel

Policy origin and configurability intent remain unresolved.

No policy engine, table, configuration mechanism, or inferred semantic
classification was introduced.

Gate artifact:

`09-slice-3-gate-resolution.md`

---

### Slice 4A — CUSTRSK Narrow Interface Refactoring

**Outcome:** APPROVED WITH INTERFACE BOUNDARY

Modified:

- `src/cobol/CUSTRSK.cbl`
- `src/cobol/TRNLIM01.cbl`

Post-change SHA-256:

`CUSTRSK.cbl`
`45d138b5d947b06e01450e00f92db6e758c957f8cd2109b1a58a5144e777310a`

`TRNLIM01.cbl`
`2e9f5594d5e5cfcce7d09178c9872117d1e4429cdf9681bbdcb1bcaf0cf3760b`

Transformation:

CUSTRSK changed from:

`USING AUTH-REQUEST LIMIT-CONTEXT`

to a narrow interface containing only:

- account ID;
- risk score;
- risk availability.

Mapped workspace caller:

- TRNLIM01

Static review confirmed preservation of:

- MQRSKGET invocation;
- RM-OK behavior;
- non-RM-OK behavior;
- CUSTRSK orchestration position;
- RISKFBK triggering;
- fallback orchestration.

Important boundary:

The CUSTRSK callable interface changed intentionally.

No business-rule or orchestration behavior change was identified within the
mapped AtlasPay call path by static review.

Runtime linkage and behavioral equivalence remain unverified.

Open containment gates:

- KU-01 — MQRSKGET implementation absent;
- KU-17 — unconditional risk invocation intent;
- C-04 — timeout/error semantic distinction.

Human gate:

`12-slice-4a-human-review-gate.md`

---

### Slice 5 — TRNLIM01 Orchestrator & Dual-Caller Compatibility

**Outcome:** COMPLETE — NO ADDITIONAL SOURCE CHANGE

ATLAUTH static caller compatibility:

REVIEWED

TRNLIM01 external interface:

UNCHANGED

ATLI routing evidence:

PRESENT

ATLI request/linkage population semantics:

UNRESOLVED

ATLI runtime compatibility:

UNVERIFIED

Open gates:

- KU-03 — ATLI input population: OPEN RESOLUTION GATE;
- KU-04 — audit behavior: CONTAINMENT;
- KU-09 — AS-RISK-MODE semantics: CONTAINMENT;
- KU-16 — AR-TRANSACTION-TYPE semantics: CONTAINMENT.

Gate artifact:

`13-slice-5-gate-resolution.md`

---

## 3. Source Modification Inventory

Application source modified during Run 004:

1. `src/cobol/LIMITPOL.cbl`
2. `src/cobol/EXCEPT01.cbl`
3. `src/cobol/CUSTRSK.cbl`
4. `src/cobol/TRNLIM01.cbl`

Application source deliberately not modified where evidence did not justify
change:

- `src/cobol/MERCHVAL.cbl`
- `src/cobol/ATLAUTH.cbl`
- `src/cobol/RISKFBK.cbl`
- `src/cobol/LIMUTIL.cbl`
- copybooks;
- Db2 schema;
- VSAM definitions;
- JCL;
- MQ artifacts;
- CICS transaction definitions;
- tests.

---

## 4. Governance Evidence Chain

Run 004 contains the following control points:

1. `00-ku13-authority-decision.md`
2. `01-slice-0-characterization-baseline.md`
3. `02-slice-0-human-review-gate.md`
4. `03-slice-1-gate-resolution.md`
5. `04-slice-1a-authorization.md`
6. `05-slice-1a-human-review-gate.md`
7. `06-slice-2-gate-resolution.md`
8. `07-slice-2a-authorization.md`
9. `08-slice-2a-human-review-gate.md`
10. `09-slice-3-gate-resolution.md`
11. `10-slice-4-gate-resolution.md`
12. `11-slice-4a-authorization.md`
13. `12-slice-4a-human-review-gate.md`
14. `13-slice-5-gate-resolution.md`
15. this evidence pack.

Pre-change source snapshots and SHA-256 records were also preserved for each
source-changing slice.

---

## 5. Validation Status

```yaml
transform_run: run-004
characterization_baseline: STATIC
source_changes_reviewed: true
static_validation: PASSED
runtime_validation: UNAVAILABLE
runtime_linkage_validation: UNAVAILABLE
runtime_equivalence_verified: false
deployment_validation: NOT_PERFORMED
deployment_authorized: false
production_change_authorized: false