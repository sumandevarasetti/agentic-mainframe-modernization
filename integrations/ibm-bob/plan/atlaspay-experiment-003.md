# AtlasPay PLAN Experiment 003 — Evidence-Bounded Refactor Planning

**Framework:** v0.3.5  
**Estate:** AtlasPay  
**Capability:** Dynamic Transaction Limit  
**Approved disposition:** REFACTOR — APPROVED WITH CONDITIONS  
**Goal:** Produce a reversible implementation plan from the approved DECIDE gate without modifying source.

## Preconditions

PLAN may begin only if the isolated workspace contains:

- frozen UNDERSTAND Run 001 artifacts;
- final DECIDE record `03-modernization-decision-record-final.md`;
- human gate `04-human-decision-gate.md`;
- `framework-assets/playbooks/implementation-plan/playbook.yaml`.

The human gate must explicitly authorize DECIDE → PLAN.

## Native Capability First

Preferred mode: **Z Architect**.

Use IBM Bob's native implementation-planning capability where available:

- implementation-planning skill;
- `/implementation-planning`.

Do not replace the native planning capability with a framework prompt if the native capability is available.

The framework playbook defines what evidence the plan must contain.

## Approved scope

The approved disposition is **REFACTOR**.

The plan must remain within these boundaries:

- preserve externally observable behavior unless separately approved;
- preserve behaviorally load-bearing ordering/control semantics;
- no automatic EXTRACT or EXPOSE;
- no new platform or runtime migration;
- no target technology chosen beyond the existing execution environment unless the human gate explicitly authorizes it;
- all 18 known unknowns remain active until resolved by evidence.

## Required planning behavior

The plan should decompose REFACTOR into independently reviewable change slices.

For every slice, capture:

- objective;
- evidence/rationale;
- artifacts potentially affected;
- prerequisite unknowns;
- dependency ordering;
- behavioral invariants;
- tests/evidence required before and after;
- rollback mechanism;
- abort condition;
- human checkpoint.

Do not edit source.

## Mandatory gates

At minimum, planning must account for:

- KU-13 before relying on the characterization suite as authoritative;
- business confirmation before changing MCC policy representation;
- KU-03 before any `TRNLIM01` interface change;
- KU-05/KU-06 before exception-handling changes;
- KU-07 before policy-query changes;
- KU-08 before policy-table schema changes;
- KU-11/KU-12 before VSAM structure or `EXCEPT01` runtime changes;
- KU-01 before risk-path changes;
- KU-04 before audit/response-field changes.

## Output

Save the native/structured plan to:

`runs/atlaspay/plan/run-003/01-implementation-plan.md`

The plan must include:

1. Decision Traceability
2. Plan Scope
3. Explicit Out-of-Scope
4. Preconditions
5. Sequenced Change Slices
6. Artifact Impact Map
7. Known-Unknown Resolution Gates
8. Behavioral Invariants
9. Validation / Proof Matrix
10. Rollback and Abort Plan
11. Risk Register
12. PLAN Exit Criteria
13. Human Plan Gate

Human Plan Approver must remain:

`REQUIRED — NOT YET ASSIGNED`

Approval Status must remain:

`PENDING HUMAN PLAN APPROVAL`

## Exit rule

**No approved plan, no progression to TRANSFORM.**
