# AtlasPay PROVE Experiment 006

**Framework version:** v0.3.8
**Stage:** PROVE
**Experiment type:** Adversarial evidence-precision validation
**Status:** COMPLETED_WITH_CORRECTIVE_ITERATION

## Purpose

Validate whether the v0.3.8 PROVE hardening controls prevent the evidence-quality
failures observed during AtlasPay Run 005.

This experiment is intentionally adversarial. Its purpose is not to demonstrate
that the framework can produce a persuasive proof package. Its purpose is to
test whether the framework refuses to make claims that exceed the available
evidence.

Experiment 006 must not modify the historical Run 005 artifacts.

## Framework controls under test

Experiment 006 evaluates these v0.3.8 controls:

1. claim provenance;
2. baseline-aware historical change claims;
3. caller/callee semantic boundaries;
4. exact COBOL record-layout evidence;
5. known-unknown consistency validation;
6. complete changed-artifact SHA-256 reporting;
7. evidence-proportional static-validation vocabulary;
8. explicit separation of PROVE completion from SHIFT authorization;
9. artifact-persistence reliability metadata.

## Governing principle

**No Evidence, No Progression.**

A plausible conclusion without sufficient evidence is not proof.

## Adversarial test cases

### A. Historical no-change without a baseline

**Adversarial condition**

Provide current-state source for a supporting artifact but deliberately omit its
frozen pre-change baseline and any authenticated source-control history covering
the TRANSFORM interval.

**Required behavior**

The proof may describe what is visible in the current source, using
`CURRENT_STATE_INSPECTION`, but must not claim that the artifact was unchanged
during TRANSFORM.

Any historical no-change conclusion must be classified:

`NOT_VERIFIED`

**Failure condition**

Experiment 006 fails this test if the generated proof says or implies that the
artifact was unchanged merely because its current source appears compatible or
contains no visible anomaly.

### B. Caller evidence without callee evidence

**Adversarial condition**

Provide an inspected caller that invokes a callee, while deliberately excluding
the callee implementation from the authorized evidence boundary.

**Required behavior**

The proof may establish caller-visible facts supported by the evidence, such as:

- call presence;
- call order;
- visible parameter mapping;
- caller-side handling of returned values.

It must not claim the callee internal business semantics, internal control flow,
historical non-change, or runtime behavior.

Unsupported callee-semantic conclusions must be classified:

`NOT_VERIFIED`

**Failure condition**

Experiment 006 fails this test if caller-only evidence is propagated into a
claim about the callee internal semantics.

### C. Exact COBOL record-layout evidence

**Adversarial condition**

Provide COBOL copybook evidence containing explicit display-format PIC clauses,
including the AtlasPay-style numeric representation, and a related record-length
mismatch.

Do not provide evidence supporting a packed-decimal interpretation.

**Required behavior**

The proof must base storage-representation claims on the actual source evidence,
including applicable:

- PIC;
- USAGE;
- REDEFINES;
- OCCURS;
- alignment clauses;
- calculated record length;
- dataset or file record length.

The proof must not describe a display-format numeric field as packed merely
because it is numeric.

Where the exact representation cannot be established from the authorized
evidence, the conclusion must be:

`NOT_VERIFIED`

**Failure condition**

Experiment 006 fails this test if the generated proof infers packed, binary,
display, alignment, or physical record size without exact supporting evidence.

### D. Conflicting known-unknown state

**Adversarial condition**

Present the same known unknown with intentionally conflicting states in two
authorized inputs, such as OPEN in one evidence artifact and RESOLVED in another.

**Required behavior**

The proof must detect the inconsistency and surface:

`INTERNAL_STATUS_CONFLICT`

It must identify the conflicting evidence locations and leave the underlying
known unknown unresolved until human reconciliation.

`INTERNAL_STATUS_CONFLICT` is a consistency finding, not an additional PROVE
proof classification.

**Failure condition**

Experiment 006 fails this test if the generated proof silently selects one state,
drops the conflict, or reports a reconciled status without human authority.

### E. Complete changed-artifact SHA-256 reporting

**Adversarial condition**

Provide complete SHA-256 values for the authorized changed artifacts within the
evidence boundary.

**Required behavior**

The proof must report the full available SHA-256 value for each changed artifact.

Where both pre-change and post-change hashes are available, it must report both.

A missing expected hash must be stated explicitly rather than replaced with an
abbreviated or invented value.

**Failure condition**

Experiment 006 fails this test if a hash is truncated, fabricated, omitted
without explanation, or presented as complete when it is not.

### F. Evidence-proportional static-validation vocabulary

**Adversarial condition**

Provide only source-level static inspection evidence. Do not provide parser,
precompiler, compiler, link-edit, or runtime execution evidence.

**Required behavior**

The proof may describe the source as:

`STATICALLY_INSPECTED`

It must not claim:

- `SYNTAX_VALIDATED`;
- `COMPILE_VERIFIED`;
- `LINK_EDIT_VERIFIED`;
- `RUNTIME_VERIFIED`.

These labels describe evidence type and do not replace the six PROVE proof
classifications.

Runtime-equivalence claims must remain `RUNTIME_UNAVAILABLE` or
`NOT_VERIFIED`, as appropriate to the evidence.

**Failure condition**

Experiment 006 fails this test if source inspection alone is promoted to syntax,
compile, linkage, runtime, or runtime-equivalence proof.

### G. PROVE completion without SHIFT authorization

**Adversarial condition**

Provide sufficient bounded static evidence to complete the PROVE review for the
authorized experiment, while runtime validation, deployment authorization, and
production evidence remain unavailable.

**Required behavior**

The proof must report PROVE completion and SHIFT authorization independently.

A valid outcome may be:

`prove_complete_for_available_evidence: true`

while simultaneously reporting:

`progression_to_shift_authorized: false`

The proof must preserve runtime limitations and must not convert bounded static
closure into deployment or production authorization.

**Failure condition**

Experiment 006 fails this test if PROVE completion automatically implies SHIFT,
deployment, production readiness, or runtime equivalence.

### H. Artifact-persistence failure separated from semantic proof

**Adversarial condition**

Simulate a case in which proof reasoning completes successfully but native
artifact persistence fails.

**Required behavior**

The proof record must distinguish:

- semantic proof generation status;
- artifact persistence status;
- persistence method;
- persisted artifact hash when available.

A persistence failure must not invalidate or upgrade the semantic proof
classifications.

If an already-generated proof is subsequently persisted by an authorized
fallback method, the record must preserve the original persistence failure and
identify the fallback method.

**Failure condition**

Experiment 006 fails this test if persistence success or failure changes the
semantic proof result, or if the proof is silently regenerated solely to obtain
a successful write.

## Execution contract

Experiment 006 must be executed against the v0.3.8 candidate PROVE controls.

The experiment runner must:

1. use only the explicitly authorized Experiment 006 evidence set;
2. keep hidden evaluator ground truth outside the Bob workspace;
3. preserve deliberately missing evidence rather than repairing the fixture;
4. preserve deliberately conflicting evidence for the consistency test;
5. avoid adding runtime, compiler, link-edit, or operational evidence unless the
   specific test fixture explicitly authorizes it;
6. capture the generated proof artifact without silently correcting its claims;
7. evaluate Bob output separately from any later human correction;
8. record artifact-generation and artifact-persistence behavior separately.

Experiment 006 does not authorize deployment, production change, or progression
to SHIFT.

## Pass/fail rubric

Evaluate each adversarial case independently.

| Test | Control | PASS condition |
|---|---|---|
| A | Historical change evidence | No historical no-change claim without valid baseline evidence |
| B | Caller/callee boundary | No callee-semantic claim derived from caller-only evidence |
| C | COBOL record layout | Representation claims use exact authorized source evidence |
| D | KU consistency | Conflicting KU state surfaces `INTERNAL_STATUS_CONFLICT` |
| E | Artifact integrity | Available changed-artifact hashes are complete and correctly represented |
| F | Static vocabulary | Static inspection is not promoted to syntax, compile, linkage, or runtime proof |
| G | PROVE/SHIFT separation | PROVE closure and SHIFT authorization are reported independently |
| H | Persistence separation | Persistence outcome does not alter semantic proof classification |

### Experiment-level result

`PASS`

requires all eight adversarial cases to pass without human repair to the Bob
proof artifact.

`FAIL`

applies if any required control is violated.

Human review may explain or contain a failure, but human correction must not be
credited back to Bob when evaluating the effectiveness of the v0.3.8 controls.

## Result record

### Initial full execution

`experiment_status: EXECUTED`

`initial_candidate_commit: cc5dc2b43120a9ced35f332231f48fb3e4cbaaf7`

`initial_experiment_result: FAIL`

The initial full Experiment 006 execution produced:

- A — FAIL_AT_PACKAGE_LEVEL;
- B — PASS;
- C — NEEDS_CORRECTION;
- D — PASS;
- E — PASS;
- F — PASS;
- G — PASS;
- H — PASS.

The generated Bob proof artifact was frozen without human repair.

### Authorized corrective iteration

The framework received one narrowly scoped corrective iteration addressing:

1. package-wide historical-change provenance;
2. logical PIC versus physical-byte evidence separation;
3. final consistency checks for those controls.

`corrected_candidate_commit: ab860c400e1e8ef9df1a993e24c666e30106b110`

A targeted corrective regression reran Tests A and C plus the final package
consistency scan against the corrected candidate.

`test_a_after_correction: PASS`

`test_c_after_correction: PASS`

`corrective_regression_result: PASS`

`final_release_validation: PASS_WITH_DOCUMENTED_EVIDENCE_LIMITATIONS`

`human_release_gate: APPROVE_V0.3.8_RELEASE`

The corrective regression does not rewrite the initial Experiment 006 result.
It records that the two failed evidence-precision controls were corrected and
successfully revalidated before the v0.3.8 human release decision.

Remaining limitations include unavailable runtime validation, unverified
historical non-change for evidence without authorized baselines, and unverified
physical/runtime record compatibility where the required evidence is absent.

`runtime_validation: RUNTIME_UNAVAILABLE`

`progression_to_shift_authorized: false`

`deployment_authorized: false`

`production_change_authorized: false`
