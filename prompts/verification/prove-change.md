# PROVE Change Prompt

**Framework stage:** PROVE
**Version:** 0.3.8
**Status:** Portable supplemental prompt pattern

## Purpose

Evaluate a completed TRANSFORM change set using objective evidence without
converting static analysis into runtime proof or extending claims beyond their
evidence provenance.

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
2. compare pre-change and post-change source where a frozen baseline exists;
3. classify every material difference;
4. map each difference to its explicit authorization;
5. identify the provenance class supporting each material proof claim;
6. verify preserved invariants using only evidence within the authorized boundary;
7. distinguish caller-observable evidence from callee-internal semantics;
8. identify interface changes separately from behavioral changes;
9. check for out-of-scope changes without inferring historical non-change from current state alone;
10. carry unresolved known unknowns and containment gates forward;
11. reconcile known-unknown status across tables, narrative, risk highlights, and final summary;
12. report complete SHA-256 values for changed artifacts when those hashes are available in authorized evidence;
13. classify static validation according to the tool actually used;
14. classify runtime evidence honestly;
15. state PROVE completion separately from SHIFT authorization;
16. record proof-generation and artifact-persistence status separately from semantic proof classifications.

Use only these proof classifications:

- STATICALLY_VERIFIED
- RUNTIME_VERIFIED
- RUNTIME_UNAVAILABLE
- NOT_VERIFIED
- DIFFERENCE_EXPLAINED
- DIFFERENCE_UNEXPLAINED

## Claim provenance

Every material proof claim must identify both its evidence source and its
provenance class.

Use one of:

- `PRE_POST_DIFF`
- `CURRENT_STATE_INSPECTION`
- `AUTHORIZATION_RECORD`
- `STATIC_CALL_PATH`
- `STATIC_DATA_CONTRACT`
- `BUILD_RESULT`
- `RUNTIME_TEST`
- `OPERATIONAL_EVIDENCE`

Do not imply a stronger provenance class than the evidence actually provides.

## Historical change rule

This rule applies package-wide, not only to artifacts explicitly identified as
historical-change test cases.

Current-state inspection alone can establish that source text or behavior is
present in the inspected artifact. It cannot establish that the artifact was
unchanged during TRANSFORM.

Any historical claim using language such as:

- unchanged;
- preserved;
- identical;
- same as before;
- retained unchanged;

requires a frozen pre-change baseline, authenticated source-control diff covering
the relevant interval, or equivalent authorized historical provenance.

If that provenance is absent, classify the historical claim as:

`NOT_VERIFIED`

Do not convert "present in current source" or "no anomaly observed" into
historical non-change.

Before completing the proof package, scan the complete package for historical
change language and verify that every such claim has adequate historical
provenance.

## Caller/callee semantic boundary

Caller evidence may establish call presence, call order, visible parameter mapping,
and caller-side handling of returned values.

Caller evidence alone must not be used to prove:

- callee-internal business semantics;
- callee-internal control flow;
- callee historical non-change;
- callee runtime behavior.

Direct callee evidence is required for callee-semantic claims.

If the callee is outside the authorized evidence boundary, classify unsupported
callee-semantic conclusions as:

`NOT_VERIFIED`

## COBOL record-layout rule

Before making a COBOL representation or record-length claim, distinguish the
different evidence layers explicitly:

1. logical positions implied by PIC clauses;
2. declared COBOL representation such as USAGE;
3. physical encoded byte size;
4. dataset or file declared record size;
5. runtime record compatibility.

Where applicable, inspect:

- PIC;
- USAGE;
- REDEFINES;
- OCCURS;
- synchronization or alignment clauses;
- compiler or representation environment evidence;
- dataset or file record length.

PIC clauses may support calculation of logical positions. They do not, by
themselves, prove physical encoded byte size or runtime compatibility.

Do not infer packed, display, binary, alignment, physical byte size, or runtime
record compatibility from field names or apparent numeric length alone.

A dataset record-size declaration establishes the declared dataset size. It does
not by itself prove that a copybook layout is physically compatible at runtime.

If representation or environment evidence required for a physical-byte or
runtime-compatibility claim is absent, classify that claim as:

`NOT_VERIFIED`

## Known-unknown consistency rule

Before producing the final PROVE recommendation, reconcile every known unknown
across:

- known-unknown register;
- evidence matrices;
- narrative findings;
- highlighted risks;
- containment gates;
- final structured summary.

If the same known unknown appears with conflicting states, surface:

`INTERNAL_STATUS_CONFLICT`

Do not silently choose one status.

## Artifact integrity rule

For every changed artifact, report the complete SHA-256 value when that hash is
available within the authorized evidence boundary.

Where both pre-change and post-change hashes are available, report both.

If an expected hash is unavailable, state that explicitly.

Do not fabricate, abbreviate, or truncate a hash and present it as integrity
evidence.

## Static-validation vocabulary

Use validation language proportional to the tool evidence actually produced.

Use these evidence-type descriptions where applicable:

- source inspection only: `STATICALLY_INSPECTED`
- parser or precompiler evidence: `SYNTAX_VALIDATED`
- compiler evidence: `COMPILE_VERIFIED`
- link-edit evidence: `LINK_EDIT_VERIFIED`
- authorized runtime execution: `RUNTIME_VERIFIED`

These evidence-type descriptions do not replace the six PROVE classifications.

Do not say "syntax valid", "compile verified", "linkage verified", or equivalent
unless the corresponding tool actually produced that evidence.

## PROVE completion versus SHIFT authorization

PROVE completion and SHIFT authorization are separate human decisions.

The final package must report both independently, for example:

`prove_complete_for_available_evidence: true|false`

`progression_to_shift_authorized: true|false`

A completed PROVE stage does not imply authorization to SHIFT.

SHIFT requires evidence appropriate to the operational action being authorized.

## Artifact-persistence metadata

Record proof generation and artifact persistence separately.

At minimum record, when known:

- proof generated: true/false;
- proof persisted: true/false;
- persistence method;
- persisted artifact integrity hash.

Persistence success or failure must not alter semantic proof classifications.

If native persistence fails after reasoning succeeds, preserve that distinction.
Do not regenerate semantic conclusions merely to obtain a successful write unless
an authorized human explicitly requests regeneration.

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

1. proof scope and evidence boundary;
2. artifact inventory with claim provenance and available SHA-256 integrity evidence;
3. pre/post comparison for each changed source file where a valid baseline exists;
4. authorization traceability for each material difference;
5. behavioral-invariant matrix;
6. interface-compatibility assessment with caller/callee semantic boundaries;
7. known-unknown and containment-gate status with consistency reconciliation;
8. unsupported-change assessment, including historical no-change claims lacking baseline evidence;
9. rollback-evidence assessment;
10. static-validation evidence using evidence-type vocabulary proportional to the tool actually used;
11. runtime-validation status;
12. unexplained differences;
13. proof gaps and artifact-persistence status;
14. PROVE exit recommendation for human review, including separate SHIFT authorization status.

## Final consistency checks

Before producing the final PROVE recommendation:

1. scan the complete package for historical-change terms such as `unchanged`,
   `preserved`, `identical`, `same as before`, and `retained unchanged`;
2. verify that every historical claim is supported by `PRE_POST_DIFF`,
   authenticated version history, or equivalent authorized historical evidence;
3. where such evidence is absent, replace the historical conclusion with
   `NOT_VERIFIED`;
4. verify that logical PIC positions are not presented as proven physical byte
   size without representation and environment evidence;
5. verify that dataset record size is not presented as proof of runtime record
   compatibility.

## Rules

- Do not modify source.
- Do not modify tests.
- Do not repair findings during PROVE.
- Do not suppress unexplained differences.
- Do not resolve unknowns by assumption.
- Do not extend claims beyond the authorized evidence boundary.
- Do not infer historical non-change without valid baseline evidence.
- Do not infer callee-internal semantics from caller-only evidence.
- Do not promote logical PIC layout to physical byte size or runtime compatibility without exact representation and environment evidence.
- Do not hide or silently reconcile conflicting known-unknown states.
- Do not abbreviate or fabricate integrity hashes.
- Do not describe static inspection as syntax, compile, link-edit, or runtime verification.
- Do not claim runtime equivalence without runtime evidence.
- Do not treat PROVE completion as SHIFT authorization.
- Do not treat artifact-persistence success or failure as semantic proof.
- Do not access hidden evaluator ground truth.
- Do not deploy.
- Do not authorize production change.

If an unexplained difference is found, classify it and stop progression rather
than fixing it silently.

**No proof by plausibility.**
