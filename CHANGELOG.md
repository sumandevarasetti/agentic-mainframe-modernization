# Changelog

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
