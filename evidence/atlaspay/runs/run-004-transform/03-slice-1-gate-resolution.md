# Slice 1 Gate Resolution — AtlasPay TRANSFORM Run 004

**Stage:** TRANSFORM
**Slice:** 1 — Database Query Semantics & Policy Data Access Refactoring
**Capability:** Dynamic Transaction Limit
**Human Reviewer:** Suman Devarasetti
**Decision:** AUTHORIZE NARROWED SLICE 1A WITH CONTAINMENT GATES
**Runtime Validation:** UNAVAILABLE

## Purpose

Resolve or contain the gates that constrain changes to `LIMITPOL.cbl`
before any source modification occurs.

This decision does not authorize a change to policy-selection semantics.

## KU-07 — Effective-Date / Multi-Row Policy Selection

### Evidence

`ATLAS_LIMIT_POLICY` has primary key:

`(PRODUCT_CODE, JURISDICTION, EFFECTIVE_DATE)`

The current `LIMITPOL.cbl` query filters only:

- PRODUCT_CODE
- JURISDICTION
- ACTIVE_FLAG = 'Y'

Therefore the schema permits more than one active effective-dated row for
the same product/jurisdiction.

The current synthetic seed data contains only one active row for each
product/jurisdiction represented in the workspace.

### Decision

**Gate Type: CONTAINMENT**

KU-07 remains unresolved as business intent.

Slice 1A must preserve the existing SELECT predicate and may not add:

- ORDER BY;
- FETCH FIRST;
- MAX(EFFECTIVE_DATE);
- current-date filtering;
- new uniqueness assumptions;
- or any other row-selection rule.

No deterministic effective-date selection rule may be invented.

Any future change to row-selection semantics requires a human-approved
business/data rule.

## KU-08 — POLREC.cpy Consumers

### Evidence

`POLREC.cpy` exists in the AtlasPay copybook set.

A review of all 15 COBOL programs in the isolated AtlasPay workspace found
no `COPY POLREC`, `POLICY-RECORD`, or other functional use of this copybook.

### Decision

**Gate Type: RESOLVED FOR WORKSPACE SCOPE**

Within the synthetic AtlasPay repository:

`POLREC.cpy` has no mapped COBOL consumer.

This does not claim that an equivalent copybook would have no consumers in
a real enterprise source estate.

Slice 1A must not modify or delete `POLREC.cpy`.

## KU-10 — LIMITREF.jcl Operational Intent

### Evidence

`LIMITREF.jcl` executes:

`PGM=LIMITPOL`

and supplies:

`REFRESH POLICY PARAMETERS`

through SYSIN.

However, `LIMITPOL`:

- declares `PROCEDURE DIVISION USING AUTH-REQUEST LIMIT-CONTEXT`;
- does not read SYSIN;
- performs a policy SELECT;
- does not refresh policy data.

A separate artifact, `LIMREFR.jcl`, executes `LIMITBAT`.

`LIMITBAT.cbl` performs:

`UPDATE ATLAS_LIMIT_POLICY
 SET LAST_REFRESH_TS = CURRENT TIMESTAMP
 WHERE ACTIVE_FLAG = 'Y'`

### Decision

**Gate Type: RESOLVED FOR WORKSPACE CLASSIFICATION**

For the synthetic AtlasPay workspace:

- `LIMREFR.jcl` → `LIMITBAT` is the source-supported refresh-marker path.
- `LIMITREF.jcl` is retained as an anomalous/unverified artifact.
- `LIMITREF.jcl` must not be treated as evidence that `LIMITPOL` is a
  supported batch refresh program.
- Slice 1A must not modify either JCL artifact.

This classification is limited to the synthetic workspace and does not
claim real operational deployment behavior.

## C-05 — 1,000.00 SQL Failure Fallback

### Evidence

`LIMITPOL.cbl` sets:

- LC-BASE-LIMIT = 1000.00
- LC-PRODUCT-MAX = 1000.00
- LC-JURIS-LIMIT = 1000.00

for any non-zero SQLCODE.

No workspace evidence establishes why 1000.00 was chosen.

### Decision

**Gate Type: CONTAINMENT**

The business intent of the 1,000.00 fallback remains unresolved.

Slice 1A must preserve:

- the trigger: SQLCODE != 0;
- all three fallback assignments;
- the value 1000.00;
- absence of a new error response or status;
- existing caller-visible behavior.

Any future change to fallback policy requires separate human approval.

## Authorized Slice 1A

Slice 1 is narrowed to:

**Behavior-Preserving LIMITPOL Structural Refactoring**

### Allowed Source File

- `src/cobol/LIMITPOL.cbl`

### Allowed Changes

Structural refactoring only, such as:

- separating policy retrieval from result handling into clearly named
  COBOL paragraphs;
- improving internal readability;
- reducing procedural entanglement;
- making success and fallback handling structurally explicit.

### Prohibited Changes

Do not change:

- SQL SELECT columns;
- SQL WHERE predicates;
- effective-date semantics;
- SQLCODE success/failure semantics;
- the 1,000.00 fallback values;
- `AUTH-REQUEST`;
- `LIMIT-CONTEXT`;
- program linkage;
- DB2 schema;
- seed data;
- `POLREC.cpy`;
- `LIMITREF.jcl`;
- `LIMREFR.jcl`;
- `LIMITBAT.cbl`.

Do not introduce:

- ORDER BY;
- FETCH FIRST;
- MAX(EFFECTIVE_DATE);
- new SQL;
- new tables;
- new configuration;
- new runtime dependencies.

## Behavioral Invariants

Before and after Slice 1A:

1. the same SELECT must execute against `ATLAS_LIMIT_POLICY`;
2. SQLCODE = 0 must copy the same three selected values into LIMIT-CONTEXT;
3. SQLCODE != 0 must assign 1000.00 to the same three LIMIT-CONTEXT fields;
4. the program interface must remain unchanged;
5. callers must observe no intended behavioral difference.

## Validation Boundary

Runtime execution is currently unavailable.

Therefore Slice 1A may produce:

- source diff;
- static control-flow comparison;
- SQL-text comparison;
- interface comparison;
- fallback-assignment comparison.

It may NOT claim runtime behavioral equivalence.

## Rollback Boundary

Source-level rollback is the exact pre-Slice-1A version of:

`src/cobol/LIMITPOL.cbl`

Runtime build/deploy/restore procedures remain unverified.

## Authorization

**Slice 1A: AUTHORIZED**

Authorization is limited strictly to the structural refactoring described
above.

KU-07 and C-05 remain active containment gates.

KU-08 is resolved only for the isolated workspace.

KU-10 is resolved only as a synthetic workspace artifact classification.

Deployment remains unauthorized.
Production change remains unauthorized.