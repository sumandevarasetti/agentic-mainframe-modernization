# Changelog

## 0.3.8 — PROVE Evidence-Precision Hardening

- Hardened PROVE claim provenance and evidence-boundary rules
- Added baseline requirements for historical no-change claims
- Added caller/callee semantic-boundary controls
- Added exact COBOL record-layout evidence requirements
- Added known-unknown consistency detection with `INTERNAL_STATUS_CONFLICT`
- Required complete available SHA-256 reporting for changed artifacts
- Added evidence-proportional static-validation vocabulary
- Separated PROVE completion from SHIFT authorization
- Separated artifact-persistence reliability from semantic proof
- Added AtlasPay Experiment 006 as an adversarial validation specification
- Executed AtlasPay Experiment 006; the initial full run identified failures in Test A and Test C while Tests B, D, E, F, G, and H passed
- Applied one bounded corrective iteration for package-wide historical provenance and logical-layout versus physical-byte evidence precision
- Revalidated Test A and Test C successfully against the corrected candidate
- Final release validation: `PASS_WITH_DOCUMENTED_EVIDENCE_LIMITATIONS`
- Runtime validation remains unavailable; no deployment, production change, or SHIFT progression is authorized by v0.3.8

## 0.3.7 — PROVE Stage Foundation

- Added `playbooks/proof-package/` for evidence-classified PROVE execution
- Added portable `prove-change.md` verification prompt
- Added AtlasPay PROVE Experiment 005
- Added explicit proof vocabulary: STATICALLY_VERIFIED, RUNTIME_VERIFIED,
  RUNTIME_UNAVAILABLE, NOT_VERIFIED, DIFFERENCE_EXPLAINED, and
  DIFFERENCE_UNEXPLAINED
- Required pre/post change traceability and authorization mapping
- Added unsupported-change and unexplained-difference detection
- Preserved unresolved known unknowns and containment gates through PROVE
- Made PROVE read-only: no source/test repair during evidence evaluation
- Prohibited proof by plausibility and runtime-equivalence claims without
  authorized execution evidence

## 0.3.6 — TRANSFORM Stage Foundation

- Added `playbooks/controlled-transform/` for one-slice-at-a-time source transformation
- Added controlled-refactor supplemental prompt
- Added AtlasPay TRANSFORM Experiment 004
- Enforced slice-specific source authorization and gate clearance
- Added explicit distinction between source-level transformation and runtime validation
- Required source diffs, rollback evidence, and honest runtime status
- Prohibited deployment and production authorization in TRANSFORM
- Established Slice 0 as characterization/KU-13 authority work before any source-changing slice

## 0.3.5 — PLAN Stage Foundation

- Added `playbooks/implementation-plan/` for evidence-bounded PLAN execution
- Added a portable implementation-planning prompt that keeps PLAN read-only
- Added AtlasPay PLAN Experiment 003 for the human-approved REFACTOR disposition
- Mapped PLAN to PP4Z native `implementation-planning` / `/implementation-planning`
- Required sequenced change slices, explicit out-of-scope boundaries, proof obligations, rollback, abort conditions, and known-unknown resolution gates
- Added a named Human Plan Approver gate before TRANSFORM
- Preserved the rule that no source modification is authorized during PLAN

## 0.3.4 — Run 001 Evaluation & Evidence-Boundary Refinement

- Added the formal AtlasPay UNDERSTAND Run 001 evaluation report and artifact manifest
- Recorded the PP4Z workspace-mode baseline: 21/21 canonical dependencies, 9/9 canonical rule families, 4/4 planted cross-artifact relationships, and 30/30 canonical claims with evidence traceability
- Recorded the main weakness: incomplete coverage of broad evidence-boundary known unknowns
- Added a dedicated `playbooks/known-unknowns/` evidence contract
- Added the first DECIDE playbook and AtlasPay DECIDE Experiment 002 runbook

## 0.3.2 — Z Scope Clarification

- Locked the current book and repository implementation scope to IBM Z and IBM Bob Premium Package for Z

## 0.3.1 — PP4Z Alignment

- Adopted **Native Capability First**
- Added formal Agentic Strangler ↔ IBM Bob Premium Package for Z capability mapping

## 0.3.0 — UNDERSTAND Pack

- Added UNDERSTAND prompt/playbook foundation

## 0.2.0 — Reference Estates & Benchmark Foundation

- Expanded AtlasPay synthetic reference estate and added CardDemo adapter

## 0.1.0 — Initial starter pack

- Added canonical Agentic Strangler framework definition
