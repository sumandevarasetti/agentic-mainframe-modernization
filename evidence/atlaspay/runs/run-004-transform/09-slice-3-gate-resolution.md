# Slice 3 Gate Resolution — AtlasPay TRANSFORM Run 004

**Stage:** TRANSFORM
**Slice:** 3 — MCC Policy-Intent Gate & Conditional Structural Refactoring
**Capability:** Dynamic Transaction Limit
**Human Reviewer:** Suman Devarasetti
**Decision:** NO SOURCE CHANGE — CONTAIN CURRENT BEHAVIOR
**Runtime Validation:** UNAVAILABLE

## Purpose

Determine whether the observed MCC-specific limit behavior should be
structurally refactored or externalized.

This review does not assume that hardcoded values are defects merely because
they are hardcoded.

## Observed Source Behavior

`src/cobol/MERCHVAL.cbl` currently establishes:

- default `LK-MCC-LIMIT = 9999999.99`;
- MCC `7995` -> `LK-MCC-LIMIT = 1000.00`;
- MCC `6051` -> `LK-MCC-LIMIT = 2000.00`;
- all other MCC values retain the default sentinel.

`src/cobol/LIMUTIL.cbl` applies the resulting MCC limit only when:

- `LC-MCC-LIMIT > 0`; and
- `LC-MCC-LIMIT < WS-CANDIDATE-LIMIT`.

Therefore the observable source behavior is a numeric mapping and cap.

## Existing Test Evidence

The characterization baseline contains:

- GM-005: MCC `7995` -> expected limit `1000.00`;
- GM-006: MCC `6051` -> expected limit `2000.00`.

These cases support the observed numeric behavior.

Descriptions attached to those tests are not treated as authoritative evidence
of regulatory, contractual, network, or business-policy origin.

## Policy-Intent Question

The workspace does not establish whether MCC `7995` and MCC `6051` values are:

- regulatory requirements;
- card-network requirements;
- contractual rules;
- deliberately code-controlled business rules;
- configurable policy;
- or synthetic teaching constants.

No source artifact establishes ownership or change authority for these values.

## Gate Decision

**Gate Type: CONTAINMENT**

The policy intent remains unresolved.

The current behavior must therefore be preserved without converting it into a
new configuration or policy architecture.

Do not infer that hardcoded data must automatically be externalized.

## Structural Refactoring Assessment

`MERCHVAL.cbl` is already:

- narrowly scoped;
- isolated behind a simple program interface;
- approximately one small decision table;
- free of unrelated responsibilities;
- directly called through `TRNLIM01`;
- explicitly consumed as an MCC limit by `LIMUTIL`.

A paragraph extraction or equivalent structural rewrite would add source churn
without demonstrating a corresponding modernization benefit.

## Slice 3 Decision

**NO SOURCE CHANGE IS AUTHORIZED.**

`src/cobol/MERCHVAL.cbl` remains unchanged.

Specifically, do not:

- externalize MCC values;
- create a database table;
- create configuration files;
- introduce a new service;
- introduce a policy engine;
- rename the MCC codes using inferred business semantics;
- change `1000.00`;
- change `2000.00`;
- change the `9999999.99` sentinel;
- modify `LIMUTIL.cbl`;
- modify `TRNLIM01.cbl`;
- modify existing tests.

## Containment Boundary

The current observed behavior remains the regression baseline:

```yaml
mcc_7995_limit: 1000.00
mcc_6051_limit: 2000.00
other_mcc_behavior: NO_MCC_CAP_VIA_SENTINEL
sentinel: 9999999.99
business_policy_origin: UNRESOLVED
configurability_intent: UNRESOLVED