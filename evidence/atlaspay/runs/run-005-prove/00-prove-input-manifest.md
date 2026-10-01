# PROVE Input Manifest — AtlasPay Run 005

**Framework Stage:** PROVE
**Run:** run-005
**Capability:** Dynamic Transaction Limit
**Framework Version:** v0.3.7
**Prior Stage:** TRANSFORM Run 004
**Mode:** READ-ONLY EVIDENCE REVIEW
**Runtime Validation:** RUNTIME_UNAVAILABLE

## 1. Purpose

Freeze the evidence boundary that IBM Bob may use for PROVE Experiment 005.

PROVE evaluates the completed TRANSFORM change set.

It does not modify source, tests, expected results, or prior-stage evidence.

## 2. Authoritative Framework Inputs

Bob may read:

- `framework-assets/playbooks/proof-package/playbook.yaml`
- `framework-assets/prompts/verification/prove-change.md`
- `framework-assets/integrations/ibm-bob/prove/atlaspay-experiment-005.md`

## 3. Authoritative PLAN Inputs

Bob may read:

- `runs/atlaspay/plan/run-003/02-implementation-plan-reviewed.md`
- `runs/atlaspay/plan/run-003/03-human-plan-gate.md`

These define the approved transformation boundaries and proof obligations.

## 4. Authoritative TRANSFORM Inputs

Bob may read:

- `runs/atlaspay/transform/run-004/00-ku13-authority-decision.md`
- `runs/atlaspay/transform/run-004/01-slice-0-characterization-baseline.md`
- `runs/atlaspay/transform/run-004/02-slice-0-human-review-gate.md`

- `runs/atlaspay/transform/run-004/03-slice-1-gate-resolution.md`
- `runs/atlaspay/transform/run-004/04-slice-1a-authorization.md`
- `runs/atlaspay/transform/run-004/05-slice-1a-human-review-gate.md`

- `runs/atlaspay/transform/run-004/06-slice-2-gate-resolution.md`
- `runs/atlaspay/transform/run-004/07-slice-2a-authorization.md`
- `runs/atlaspay/transform/run-004/08-slice-2a-human-review-gate.md`

- `runs/atlaspay/transform/run-004/09-slice-3-gate-resolution.md`

- `runs/atlaspay/transform/run-004/10-slice-4-gate-resolution.md`
- `runs/atlaspay/transform/run-004/11-slice-4a-authorization.md`
- `runs/atlaspay/transform/run-004/12-slice-4a-human-review-gate.md`

- `runs/atlaspay/transform/run-004/13-slice-5-gate-resolution.md`
- `runs/atlaspay/transform/run-004/14-transform-evidence-pack.md`
- `runs/atlaspay/transform/run-004/15-human-transform-exit-gate.md`

## 5. Approved Pre-Change Source Evidence

Bob may read these frozen pre-change snapshots:

- `runs/atlaspay/transform/run-004/LIMITPOL.pre-slice-1a.cbl`
- `runs/atlaspay/transform/run-004/EXCEPT01.pre-slice-2a.cbl`
- `runs/atlaspay/transform/run-004/CUSTRSK.pre-slice-4a.cbl`
- `runs/atlaspay/transform/run-004/TRNLIM01.pre-slice-4a.cbl`

Associated pre-change hash files may also be read where present.

## 6. Approved Post-Change Source Evidence

Bob may read the current transformed sources:

- `src/cobol/LIMITPOL.cbl`
- `src/cobol/EXCEPT01.cbl`
- `src/cobol/CUSTRSK.cbl`
- `src/cobol/TRNLIM01.cbl`

For invariant and compatibility inspection Bob may also read, without modifying:

- `src/cobol/MERCHVAL.cbl`
- `src/cobol/RISKFBK.cbl`
- `src/cobol/LIMUTIL.cbl`
- `src/cobol/ATLAUTH.cbl`
- `src/cobol/AUTHLOG.cbl`

- `src/copybooks/AUTHREQ.cpy`
- `src/copybooks/AUTHRESP.cpy`
- `src/copybooks/LIMITCTX.cpy`
- `src/copybooks/RISKSCR.cpy`
- `src/copybooks/EXCEPTREC.cpy`

- `cics/transactions.yaml`
- `mq/message-contracts.md`
- `mq/queues.yaml`
- `db2/schema.sql`
- `vsam/DEFINE.jcl`

These supporting artifacts are evidence only.

Their presence does not authorize modification.

## 7. Characterization Evidence

Bob may inspect the existing characterization/test evidence referenced by the
approved UNDERSTAND, PLAN, and TRANSFORM records.

Tests are READ-ONLY during PROVE.

Bob must not:

- edit expected results;
- select a different test expectation to make transformed code appear correct;
- create replacement expectations;
- reinterpret a human-resolved baseline.

## 8. Explicitly Forbidden Evidence

Bob must NOT read or use:

- `evals/atlaspay/ground-truth.yaml`;
- any hidden evaluation answer key;
- evaluator-only scoring artifacts;
- post-hoc external evaluator conclusions.

The hidden ground truth remains reserved for independent evaluation after
Bob's proof package is frozen.

## 9. Read-Only Boundary

PROVE authorizes:

- reading;
- comparing;
- diff analysis;
- static reasoning;
- non-mutating static diagnostics where available.

PROVE does NOT authorize:

- source modification;
- test modification;
- copybook modification;
- configuration modification;
- evidence rewriting;
- business-rule alteration;
- deployment;
- production change.

## 10. Proof Classification Boundary

Bob must use only:

- `STATICALLY_VERIFIED`
- `RUNTIME_VERIFIED`
- `RUNTIME_UNAVAILABLE`
- `NOT_VERIFIED`
- `DIFFERENCE_EXPLAINED`
- `DIFFERENCE_UNEXPLAINED`

For Run 005, absent new authorized execution evidence:

`runtime_validation: RUNTIME_UNAVAILABLE`

Static similarity must not be described as runtime equivalence.

## 11. Expected Transformed Source Set

The expected application source changes from TRANSFORM Run 004 are limited to:

1. `src/cobol/LIMITPOL.cbl`
2. `src/cobol/EXCEPT01.cbl`
3. `src/cobol/CUSTRSK.cbl`
4. `src/cobol/TRNLIM01.cbl`

`MERCHVAL.cbl` is an intentional KEEP/no-source-change outcome.

Any additional application-source difference discovered during PROVE must be
classified as potentially unsupported until traced to explicit authorization.

## 12. Human Authority Boundary

Bob generates evidence and a PROVE recommendation.

Bob does not approve PROVE exit.

Final PROVE stage authority remains with the named human reviewer.

**No Evidence, No Progression.**

**No proof by plausibility.**
