# PROVE Change Prompt

**Framework stage:** PROVE
**Version:** 0.3.7
**Status:** Portable supplemental prompt pattern

## Purpose

Evaluate a completed TRANSFORM change set using objective evidence without
converting static analysis into runtime proof.

## Prompt

Prove only the approved transformed change set for:

`{{CAPABILITY}}`

Use these as authoritative inputs:

- approved TRANSFORM exit gate;
- TRANSFORM evidence pack;
- human-approved slice gates;
- pre-change source snapshots;
- current transformed source;
- characterization baseline;
- reviewed PLAN;
- known-unknown register.

Do not modify source or tests.

## Required method

For every transformed artifact:

1. identify the approved change;
2. compare pre-change and post-change source;
3. classify every material difference;
4. map each difference to its authorization;
5. verify preserved invariants using available evidence;
6. identify interface changes separately from behavioral changes;
7. check for out-of-scope changes;
8. carry unresolved known unknowns forward;
9. classify runtime evidence honestly.

Use only these proof classifications:

- STATICALLY_VERIFIED
- RUNTIME_VERIFIED
- RUNTIME_UNAVAILABLE
- NOT_VERIFIED
- DIFFERENCE_EXPLAINED
- DIFFERENCE_UNEXPLAINED

## Critical evidence rule

A source diff that appears equivalent is not runtime-equivalence proof.

A clean static diagnostic is not runtime-equivalence proof.

Matching interfaces by inspection are not runtime-linkage proof.

When no authorized executable environment exists, runtime-related claims must
be classified as:

`RUNTIME_UNAVAILABLE`

or:

`NOT_VERIFIED`

## Required output

Produce a Modernization Proof Package containing:

1. proof scope;
2. artifact-by-artifact change matrix;
3. authorization traceability;
4. before/after difference classification;
5. behavioral-invariant matrix;
6. interface-compatibility assessment;
7. known-unknown status;
8. unsupported-change assessment;
9. static-validation evidence;
10. runtime-evidence status;
11. rollback-evidence assessment;
12. unexplained differences;
13. proof gaps;
14. PROVE exit recommendation for human review.

## Rules

- Do not modify source.
- Do not modify tests.
- Do not repair findings during PROVE.
- Do not suppress unexplained differences.
- Do not resolve unknowns by assumption.
- Do not claim runtime equivalence without runtime evidence.
- Do not deploy.
- Do not authorize production change.

If an unexplained difference is found, classify it and stop progression rather
than fixing it silently.

**No proof by plausibility.**
