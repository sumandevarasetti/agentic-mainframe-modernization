# PROVE Run 006 — Corrective Regression Manifest

**Parent run:** Run 006
**Corrected candidate:** v0.3.8
**Corrected commit:** ab860c400e1e8ef9df1a993e24c666e30106b110
**Scope:** Targeted regression only
**Tests:** A and C plus final package consistency
**Runtime:** RUNTIME_UNAVAILABLE

## Purpose

Verify only the two evidence-precision controls corrected after independent
evaluation of the frozen Run 006 raw package.

Do not repeat Tests B, D, E, F, G, or H.

## Corrected framework assets

Use:

- `framework-assets/playbooks/proof-package/playbook.yaml`
- `framework-assets/prompts/verification/prove-change.md`

These contain the corrected v0.3.8 controls from commit:

`ab860c400e1e8ef9df1a993e24c666e30106b110`

## Authorized evidence for Test A

Use:

- four Run 004 frozen pre-change snapshots;
- corresponding current LIMITPOL, EXCEPT01, CUSTRSK, and TRNLIM01 sources;
- `src/cobol/MERCHVAL.cbl` as current-state-only evidence;
- `src/cobol/ATLAUTH.cbl` as current-state-only evidence;
- authorized Run 004 transform evidence already used by Run 006.

Historical claims about the four changed artifacts may use PRE_POST_DIFF.

MERCHVAL and ATLAUTH have no authorized pre-change baseline in this regression.
Current-state inspection may establish presence, but historical non-change must
remain NOT_VERIFIED.

## Authorized evidence for Test C

Use only:

- `src/copybooks/EXCEPTREC.cpy`
- `vsam/DEFINE.jcl`

Distinguish:

1. logical PIC positions;
2. declared COBOL representation;
3. physical encoded byte size;
4. dataset-declared record size;
5. runtime record compatibility.

Do not promote logical positions into proven physical byte size.

## Forbidden evidence

Do not read or use:

- `01-modernization-proof-package-raw.md`;
- `02-external-evaluation.md`;
- `evals/atlaspay/ground-truth.yaml`;
- hidden evaluator material;
- repository history for withheld baselines;
- any new runtime, compiler, precompiler, or link-edit evidence.

## Required result

Generate one corrective regression report containing:

1. Test A historical-provenance matrix;
2. Test C record-layout evidence matrix;
3. complete final historical-language consistency scan;
4. explicit A PASS/FAIL;
5. explicit C PASS/FAIL;
6. runtime status;
7. SHIFT authorization status.

`runtime_validation: RUNTIME_UNAVAILABLE`

`progression_to_shift_authorized: false`

`deployment_authorized: false`

`production_change_authorized: false`

**No Evidence, No Progression.**
**No proof by plausibility.**
