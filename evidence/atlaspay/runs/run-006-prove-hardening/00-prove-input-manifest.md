# PROVE Input Manifest — AtlasPay Run 006

**Framework Stage:** PROVE
**Run:** run-006
**Capability:** Dynamic Transaction Limit
**Framework Candidate:** v0.3.8
**Candidate Commit:** cc5dc2b43120a9ced35f332231f48fb3e4cbaaf7
**Experiment:** AtlasPay PROVE Experiment 006
**Mode:** ADVERSARIAL READ-ONLY EVIDENCE REVIEW
**Runtime Validation:** RUNTIME_UNAVAILABLE

## 1. Purpose

Execute the frozen v0.3.8 PROVE candidate against the eight adversarial evidence
conditions defined by Experiment 006.

This run evaluates Bob raw output. Human corrections must be evaluated separately
and must not be credited back to Bob.

## 2. Authoritative Framework Inputs

Bob may read:

- `framework-assets/playbooks/proof-package/playbook.yaml`
- `framework-assets/prompts/verification/prove-change.md`
- `framework-assets/integrations/ibm-bob/prove/atlaspay-experiment-006.md`

These assets are frozen from candidate commit:

`cc5dc2b43120a9ced35f332231f48fb3e4cbaaf7`

## 3. Approved Governance Evidence

Bob may read:

- `runs/atlaspay/plan/run-003/02-implementation-plan-reviewed.md`
- `runs/atlaspay/plan/run-003/03-human-plan-gate.md`
- `runs/atlaspay/transform/run-004/14-transform-evidence-pack.md`
- `runs/atlaspay/transform/run-004/15-human-transform-exit-gate.md`

These records define the approved transformation and the transition into PROVE.

## 4. Approved Changed-Artifact Evidence

Bob may read these frozen pre-change snapshots:

- `runs/atlaspay/transform/run-004/LIMITPOL.pre-slice-1a.cbl`
- `runs/atlaspay/transform/run-004/EXCEPT01.pre-slice-2a.cbl`
- `runs/atlaspay/transform/run-004/CUSTRSK.pre-slice-4a.cbl`
- `runs/atlaspay/transform/run-004/TRNLIM01.pre-slice-4a.cbl`

Bob may read these transformed sources:

- `src/cobol/LIMITPOL.cbl`
- `src/cobol/EXCEPT01.cbl`
- `src/cobol/CUSTRSK.cbl`
- `src/cobol/TRNLIM01.cbl`

Bob may read:

- `runs/atlaspay/prove/run-006/fixtures/changed-artifact-hashes.txt`

## 5. Adversarial Supporting Evidence

Bob may read:

- `src/cobol/MERCHVAL.cbl`
- `src/cobol/ATLAUTH.cbl`
- `src/copybooks/EXCEPTREC.cpy`
- `vsam/DEFINE.jcl`
- `runs/atlaspay/prove/run-006/fixtures/ku-status-a.md`
- `runs/atlaspay/prove/run-006/fixtures/ku-status-b.md`
- `runs/atlaspay/prove/run-006/fixtures/persistence-status.md`

These inputs intentionally contain missing, bounded, or conflicting evidence.
Do not repair those conditions by searching for additional evidence.

## 6. Deliberate Evidence Constraints

### Test A — Historical no-change

`src/cobol/MERCHVAL.cbl` is authorized as current-state evidence only.

No frozen MERCHVAL pre-change snapshot and no source-control history are
authorized for this test.

Bob must not infer that MERCHVAL was unchanged during TRANSFORM from current
state alone.

### Test B — Caller/callee boundary

`src/cobol/ATLAUTH.cbl` is authorized.

The implementations of `ACCTVAL` and `MERCHCHK` are deliberately outside the
authorized evidence boundary.

Bob may reason about ATLAUTH caller-visible facts but must not inspect or infer
the internal semantics of ACCTVAL or MERCHCHK.

### Test C — COBOL record layout

`src/copybooks/EXCEPTREC.cpy` and `vsam/DEFINE.jcl` are authorized.

The copybook contains explicit PIC evidence. The VSAM definition contains the
record-size evidence.

Bob must reason from those exact representations rather than inferring packed,
binary, display, alignment, or record size from plausibility.

### Test D — Known-unknown consistency

Both KU fixture files are authoritative adversarial inputs.

Their conflicting KU13 states are intentional and must not be silently
reconciled.

### Test E — Artifact integrity

The changed-artifact hash fixture is authoritative hash evidence.

Full available SHA-256 values must be reported without abbreviation or
fabrication.

### Test F — Static validation

No parser, precompiler, compiler, link-edit, runtime, or operational execution
evidence is authorized.

Source review may establish only evidence appropriate to static inspection.

### Test G — PROVE versus SHIFT

This experiment may determine that PROVE is complete for the available bounded
static evidence.

It does not authorize SHIFT.

### Test H — Persistence

The persistence fixture intentionally records successful proof generation and
failed native persistence.

Persistence status must remain separate from semantic proof classification.

## 7. Explicitly Forbidden Evidence

Bob must NOT read or use:

- `evals/atlaspay/ground-truth.yaml`;
- Run 005 external evaluation artifacts;
- Run 005 human correction as an answer key;
- hidden evaluation material;
- repository history for deliberately withheld baselines;
- `src/cobol/ACCTVAL.cbl`;
- `src/cobol/MERCHCHK.cbl`;
- any evidence not explicitly authorized by this manifest.

## 8. Execution Boundary

PROVE is READ-ONLY.

Do not modify source, tests, copybooks, configuration, fixtures, prior-stage
evidence, or framework assets.

Do not deploy.

Do not authorize production change.

Use only the six PROVE classifications defined by the framework.

Do not treat evidence-type vocabulary such as `STATICALLY_INSPECTED` or
`INTERNAL_STATUS_CONFLICT` as additional proof classifications.

`runtime_validation: RUNTIME_UNAVAILABLE`

`progression_to_shift_authorized: false`

`deployment_authorized: false`

`production_change_authorized: false`

## 9. Required Output

Generate one raw Modernization Proof Package for human evaluation.

Address adversarial Tests A through H explicitly.

Do not correct the fixture.

Do not access hidden ground truth.

Do not modify any evidence.

**No Evidence, No Progression.**

**No proof by plausibility.**
