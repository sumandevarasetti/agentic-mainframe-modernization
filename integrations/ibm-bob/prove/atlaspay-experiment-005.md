# AtlasPay PROVE Experiment 005 — Modernization Proof Package

**Framework:** v0.3.7
**Estate:** AtlasPay
**Capability:** Dynamic Transaction Limit
**Prior stage:** TRANSFORM Run 004
**Goal:** Determine exactly what the completed transformation evidence proves,
what remains unverified, and whether any unsupported change occurred.

## Important limitation

AtlasPay is a synthetic analysis-grade estate.

The current experiment does not have an authorized executable z/OS/CICS/Db2/
VSAM/MQ runtime.

Therefore PROVE may establish static evidence but must not represent static
analysis as runtime behavioral equivalence.

## Preconditions

Experiment 005 begins only after TRANSFORM Run 004 contains:

- `14-transform-evidence-pack.md`;
- `15-human-transform-exit-gate.md`;
- all slice-specific human gates;
- pre-change source snapshots for source-changing slices;
- transformed source.

## Workspace isolation

Run the experiment only in the isolated AtlasPay workspace.

The hidden evaluation ground truth must not be exposed to Bob during proof
generation.

Ground truth may be used later by the external evaluator after Bob's proof
artifact is frozen.

## PROVE authority

PROVE is read-only.

Bob may:

- inspect source;
- inspect pre-change snapshots;
- inspect TRANSFORM evidence;
- compare interfaces and control flow;
- inspect characterization evidence;
- run non-mutating static diagnostics if available.

Bob must not:

- modify source;
- modify tests;
- change expected values;
- resolve known unknowns by assumption;
- deploy;
- authorize production use.

## Required proof vocabulary

Every material conclusion must use one of:

- `STATICALLY_VERIFIED`
- `RUNTIME_VERIFIED`
- `RUNTIME_UNAVAILABLE`
- `NOT_VERIFIED`
- `DIFFERENCE_EXPLAINED`
- `DIFFERENCE_UNEXPLAINED`

## Required artifact

Create:

`runs/atlaspay/prove/run-005/01-modernization-proof-package.md`

The proof package must include:

1. proof scope and evidence boundary;
2. transformed artifact inventory;
3. pre/post comparison for each changed source file;
4. authorization mapping for each material difference;
5. behavioral-invariant matrix;
6. interface compatibility matrix;
7. known-unknown and containment-gate status;
8. unsupported-change assessment;
9. rollback-evidence assessment;
10. static-validation evidence;
11. runtime-validation status;
12. unexplained differences;
13. proof gaps;
14. human PROVE gate recommendation.

## AtlasPay transformed artifacts

Expected source-changing artifacts from TRANSFORM Run 004:

- `src/cobol/LIMITPOL.cbl`
- `src/cobol/EXCEPT01.cbl`
- `src/cobol/CUSTRSK.cbl`
- `src/cobol/TRNLIM01.cbl`

`MERCHVAL.cbl` is an intentional KEEP/no-source-change outcome.

## Required special checks

### LIMITPOL

Verify statically that:

- SQL columns remain unchanged;
- predicates remain unchanged;
- interface remains unchanged;
- 1000.00 fallback remains unchanged;
- KU-07 and C-05 remain visible.

### EXCEPT01

Verify statically that:

- file-control definition remains unchanged;
- keyed lookup semantics remain unchanged;
- ER-ACTIVE remains the eligibility condition;
- no expiry/effective-date logic was introduced;
- KU-11/KU-12/KU-05/KU-06/C-03 remain visible.

### CUSTRSK / TRNLIM01

Verify statically that:

- the CUSTRSK interface change is explicitly classified as intentional;
- mapped caller TRNLIM01 passes compatible scalar fields;
- MQRSKGET invocation remains unchanged;
- CUSTRSK call ordering remains unchanged;
- RISKFBK triggering remains unchanged;
- runtime linkage is not claimed verified;
- KU-01/KU-17/C-04 remain visible.

### Slice 5 / ATLI

Verify that:

- the external TRNLIM01 interface remains unchanged;
- ATLAUTH static caller compatibility is inspectable;
- ATLI routing evidence exists;
- ATLI input/linkage population remains unresolved;
- KU-03 remains open.

## Runtime classification

For this experiment, absent new authorized execution evidence:

`runtime_validation: RUNTIME_UNAVAILABLE`

This is a valid proof result.

It is not a failed experiment.

## Exit rule

Bob does not approve PROVE exit.

Bob produces the proof package.

A named human reviews the evidence and determines whether PROVE is complete
for the evidence level actually available.

**No proof by plausibility.**
