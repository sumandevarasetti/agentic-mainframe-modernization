# Human Decision Gate — AtlasPay Dynamic Transaction Limit

**Stage:** DECIDE  
**Run:** atlaspay-decide-002  
**Capability:** Dynamic Transaction Limit  
**Decision Record:** 03-modernization-decision-record-final.md  
**Human Decision Owner:** Suman Devarasetti  
**Decision:** APPROVED WITH CONDITIONS — REFACTOR  
**Approval Date:** 2026-09-19  

## Decision

The approved modernization disposition for the AtlasPay Dynamic Transaction Limit capability is:

**REFACTOR**

The objective is to improve the capability's evolvability and reduce unnecessary internal coupling while preserving externally observable current behavior unless a separately approved business-policy change authorizes a difference.

This approval authorizes progression from DECIDE to PLAN.

It does not authorize source-code modification, implementation, deployment, or production change.

## Why REFACTOR

REFACTOR most directly addresses the stated modernization objective while keeping the change bounded to the existing capability.

The frozen evidence identifies two important sources of evolution friction:

- business-policy values embedded directly in executable logic;
- shared mutable state and copybook coupling across the limit-calculation subsystem.

A bounded refactoring disposition addresses these concerns without requiring a new runtime, platform migration, external service boundary, or other strategic objective that has not been established.

## Conditions of Approval

### 1. Preserve Current Behavior

PLAN must preserve externally observable current behavior.

Internal ordering and control semantics must also be preserved where evidence demonstrates that they are behaviorally load-bearing.

Any intentional behavioral change requires explicit human approval as a separate business-policy decision.

### 2. Do Not Assume Configurability Intent

The fact that MCC values are hardcoded does not prove that they are intended to become configurable.

Before PLAN proposes changing how these policy values are represented, human business ownership must determine whether they are:

- regulatory or contractual constants;
- intentionally code-controlled policy;
- or business-configurable policy.

### 3. Preserve Known Unknowns

All 18 UNDERSTAND known unknowns remain active.

PLAN must not resolve any unknown by assumption.

Unknowns must be resolved before the specific change they constrain is implemented.

### 4. Resolve Test Authority

KU-13 must be resolved before behavioral equivalence can be formally proven.

A human decision must establish which expected behavior is authoritative for the conflicting high-risk test case.

### 5. Protect Exception Semantics

C-02, C-03, KU-05, and KU-06 must remain unresolved until appropriate business or operational evidence determines:

- product-maximum treatment of grandfathered exceptions;
- exception-expiry semantics;
- the relationship between online exception processing and batch reconciliation.

PLAN must not silently change these behaviors.

### 6. No Automatic EXTRACT or EXPOSE

EXTRACT and EXPOSE are not approved as part of this decision.

They remain conditional future dispositions.

They require a separately established business objective such as:

- lifecycle isolation;
- independent deployment;
- cross-channel reuse;
- or external capability consumption.

### 7. No Target Technology Selection in This Gate

This decision does not select:

- programming language;
- API technology;
- database/configuration mechanism;
- cloud platform;
- middleware;
- deployment model;
- or target runtime.

Those decisions must be justified during PLAN where applicable.

### 8. Evidence Before Change

PLAN must define the evidence required to prove that each proposed change is safe before TRANSFORM begins.

At minimum this includes:

- behavioral equivalence;
- rule and precedence preservation;
- caller/interface compatibility;
- batch coexistence;
- fallback-path behavior;
- data integrity;
- rollback criteria;
- unresolved-risk ownership.

## Conditional Options

**EXTRACT:** Not approved. May be reconsidered if lifecycle isolation or reuse becomes an explicit business requirement and evidence supports a stable capability boundary.

**EXPOSE:** Not approved. May be reconsidered if independent external consumption becomes an explicit requirement.

**TRANSFORM:** Not approved under the current objective.

**REPLATFORM:** Not approved under the current objective.

**RETIRE:** Not supported by current evidence.

**KEEP:** Remains the rollback/baseline disposition if PLAN cannot produce sufficient evidence for safe refactoring.

## Human Gate Result

```yaml
human_decision_owner: Suman Devarasetti
decision: REFACTOR
approval_status: APPROVED_WITH_CONDITIONS
progression_to_plan: AUTHORIZED
source_modification_authorized: false
implementation_authorized: false
deployment_authorized: false