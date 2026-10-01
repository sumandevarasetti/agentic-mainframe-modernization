# Human Plan Gate — AtlasPay Dynamic Transaction Limit

**Stage:** PLAN  
**Run:** atlaspay-plan-003  
**Capability:** Dynamic Transaction Limit  
**Reviewed Plan:** 02-implementation-plan-reviewed.md  
**Human Plan Approver:** Suman Devarasetti  
**Decision:** APPROVED WITH CONDITIONS — REFACTOR PLAN  
**Approval Date:** 2026-09-19

## Decision

The reviewed implementation plan for the approved REFACTOR disposition is:

**APPROVED WITH CONDITIONS**

Progression from PLAN to TRANSFORM is authorized subject to the gates defined in this document.

This is not blanket authorization to modify every in-scope artifact.

Each executable change slice must satisfy its applicable resolution gates, containment gates, evidence requirements, and rollback prerequisites before implementation begins.

## Approved Planning Scope

The approved PLAN remains limited to bounded refactoring of the AtlasPay Dynamic Transaction Limit capability in its existing execution context.

The six planned slices are accepted as the working transformation structure:

1. Characterization Baseline & KU-13 Authority Resolution
2. Database Query Semantics & Policy Data Access Refactoring
3. VSAM Exception Evidence & Runtime Compatibility
4. MCC Policy-Intent Gate & Conditional Structural Refactoring
5. Parameter Interface Encapsulation & Shared-State Decoupling
6. TRNLIM01 Orchestrator & Dual-Caller Compatibility

The sequence may be refined during TRANSFORM only when evidence requires it and the approved scope is not expanded.

## Conditions of Approval

### 1. AtlasPay Executability Is Not Assumed

AtlasPay is an analysis-grade synthetic estate.

This approval does not assert that the estate currently:

- compiles on z/OS;
- produces deployable load modules;
- executes in CICS;
- has verified runtime regions;
- has verified deployment libraries;
- or has a proven rollback mechanism.

Before an executable transformation slice begins, the authorized environment must establish the relevant build, deploy, execute, restore, and rollback mechanism.

### 2. KU-13 Must Be Resolved Before Executable Characterization Is Authoritative

The conflicting high-risk test expectations remain unresolved.

The source currently implements:

`risk score >= 800 -> candidate * 0.80`

That is observed implementation behavior.

It is not automatically elevated to authoritative business intent.

A human QA/business authority must resolve KU-13 before the characterization suite is treated as the normative specification for TRANSFORM or PROVE.

### 3. Grandfathered Product-Max Behavior Remains Unresolved

Current source behavior applies the product-maximum ceiling after the grandfathered exception override.

This is the observed baseline.

C-02 remains unresolved regarding whether this is intended business policy.

TRANSFORM must preserve the current behavior unless an explicitly approved business-policy decision authorizes a change.

### 4. Exception Expiry Semantics Must Not Be Invented

KU-05, KU-06, and C-03 remain resolution gates.

No transformation may assume that `ER-EXPIRY-DATE` belongs in:

- online authorization;
- batch reconciliation;
- or any other process

until business/operations evidence establishes the intended responsibility.

Until then, preserve observed current behavior.

### 5. Policy Query Semantics Require an Approved Rule

KU-07 must be resolved before changing policy-selection semantics.

The transformation may proceed only after either:

- evidence proves the existing data model guarantees a singleton result; or
- a human-approved deterministic rule defines which effective-dated row applies.

No SQL implementation is pre-approved by this gate.

### 6. MCC Representation Is Conditional

MCC 7995 and MCC 6051 behavior must remain unchanged unless human business ownership determines whether these values are:

- regulatory or contractual constants;
- intentionally code-controlled values;
- or configurable business policy.

This PLAN approval does not authorize externalizing them merely because they are currently hardcoded.

### 7. Containment Gates Are Valid

A known unknown does not have to be resolved when the approved transformation explicitly avoids changing the behavior it constrains.

Examples:

- KU-01 may remain open if the MQ contract and invocation behavior are unchanged.
- KU-17 may remain open if `CUSTRSK` invocation ordering remains unchanged.
- KU-04 may remain open if audit invocation/interface behavior remains unchanged.
- KU-09 may remain open if `AS-RISK-MODE` behavior and response layout remain unchanged.

If TRANSFORM crosses one of those containment boundaries, the unknown becomes a resolution gate.

### 8. Preserve Behavior, Not Assumptions

TRANSFORM must preserve:

- externally observable current behavior;
- behaviorally load-bearing ordering;
- caller compatibility;
- fallback behavior;
- relevant batch/data compatibility.

Unresolved business intent must not be silently converted into a new requirement.

Any intentional behavioral difference requires explicit human approval.

### 9. Rollback Must Be Demonstrated Before Execution

Source-level reversibility alone is insufficient.

Before each executable slice, TRANSFORM must establish:

- restorable baseline artifacts;
- actual build/deploy/restore procedure;
- rollback trigger;
- rollback owner;
- verification that rollback restores the approved baseline.

A slice whose rollback path cannot be demonstrated must not execute.

### 10. No Scope Expansion

This approval does not authorize:

- EXTRACT;
- EXPOSE;
- TRANSFORM to another language/runtime;
- REPLATFORM;
- RETIRE;
- new platform selection;
- new API architecture;
- unapproved business-policy changes.

Any such change requires returning to DECIDE.

## Human Gate Result

```yaml
human_plan_approver: Suman Devarasetti
plan_decision: REFACTOR
approval_status: APPROVED_WITH_CONDITIONS
progression_to_transform: AUTHORIZED_WITH_GATES
blanket_source_modification_authorized: false
slice_execution_authorized: conditional
deployment_authorized: false
production_change_authorized: false