# Corrective Regression Evaluation — AtlasPay PROVE Run 006

**Framework candidate:** v0.3.8
**Corrected candidate commit:** `ab860c400e1e8ef9df1a993e24c666e30106b110`
**Regression artifact:** `04-corrective-regression-raw.md`
**Frozen regression SHA-256:** `03b5124c7e3710989283dc488632db3b665497ff636f911c0648dc9dc4d325b6`
**Evaluation scope:** Test A, Test C, and final package consistency

## 1. Corrective regression result

### Test A — Package-wide historical-change provenance

`PASS`

The corrected framework distinguishes artifacts with authorized PRE_POST_DIFF
evidence from current-state-only artifacts.

- LIMITPOL: historical comparison supported by PRE_POST_DIFF.
- EXCEPT01: historical comparison supported by PRE_POST_DIFF.
- CUSTRSK: historical comparison supported by PRE_POST_DIFF.
- TRNLIM01: historical comparison supported by PRE_POST_DIFF.
- MERCHVAL: historical non-change remains NOT_VERIFIED.
- ATLAUTH: historical non-change remains NOT_VERIFIED.

Current-state presence is no longer promoted to historical non-change.

### Test C — COBOL record-layout evidence precision

`PASS`

The corrected framework distinguishes:

- logical PIC positions;
- declared or implied source representation;
- physical encoded byte size;
- dataset-declared record size;
- runtime record compatibility.

The regression reports 58 logical PIC positions separately from
`RECORDSIZE(57 57)`.

Physical encoded byte size and runtime compatibility remain `NOT_VERIFIED`
because the required environment/runtime evidence is unavailable.

### Non-blocking precision note

The regression describes DISPLAY as an implied default representation even
though no explicit USAGE clause is present.

This wording should not be treated as proof of physical byte representation.

Because the regression independently keeps physical encoded byte size and
runtime compatibility `NOT_VERIFIED`, this is recorded as a non-blocking
precision note rather than a release-blocking failure.

## 2. Combined Experiment 006 result

| Test | Final result |
|---|---|
| A — Historical no-change provenance | PASS_AFTER_CORRECTION |
| B — Caller/callee semantic boundary | PASS |
| C — COBOL record-layout precision | PASS_AFTER_CORRECTION |
| D — Known-unknown consistency | PASS |
| E — Artifact integrity | PASS |
| F — Static-validation vocabulary | PASS |
| G — PROVE/SHIFT separation | PASS |
| H — Persistence separation | PASS |

All eight Experiment 006 controls now satisfy the intended v0.3.8 regression
criteria.

## 3. Remaining evidence limitations

The following limitations remain intentionally unresolved:

- runtime validation is unavailable;
- MERCHVAL historical non-change is not verified;
- ATLAUTH historical non-change is not verified;
- physical EXCEPTREC byte representation is not verified;
- VSAM runtime compatibility is not verified;
- open modernization known unknowns remain governed by their existing gates.

These limitations do not invalidate the evidence-precision regression.

## 4. Release recommendation

`corrective_regression_status: PASS`

`experiment_006_final_result: PASS_WITH_DOCUMENTED_EVIDENCE_LIMITATIONS`

`v0.3.8_release_gate_ready: true`

`runtime_validation: RUNTIME_UNAVAILABLE`

`progression_to_shift_authorized: false`

`deployment_authorized: false`

`production_change_authorized: false`

Experiment 006 validates the v0.3.8 PROVE evidence-precision hardening for the
bounded synthetic AtlasPay regression scope.

This result does not establish production readiness, runtime equivalence, or
general effectiveness outside the tested synthetic scope.

**No Evidence, No Progression.**
