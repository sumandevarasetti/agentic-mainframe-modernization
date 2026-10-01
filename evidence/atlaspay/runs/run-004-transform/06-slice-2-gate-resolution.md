# Slice 2 Gate Resolution — AtlasPay TRANSFORM Run 004

**Stage:** TRANSFORM
**Slice:** 2 — VSAM Exception Evidence & Runtime Compatibility
**Capability:** Dynamic Transaction Limit
**Human Reviewer:** Suman Devarasetti
**Decision:** AUTHORIZE NARROWED SLICE 2A WITH CONTAINMENT GATES
**Runtime Validation:** UNAVAILABLE

## Purpose

Resolve or contain the known unknowns that constrain changes to the AtlasPay
exception lookup before any source modification occurs.

This gate does not authorize changes to VSAM layout, exception eligibility,
expiry semantics, or reconciliation behavior.

## KU-11 — VSAM Record-Length Discrepancy

### Evidence

`src/copybooks/EXCEPTREC.cpy` defines:

- ER-ACCOUNT-ID: PIC X(12) = 12 bytes
- ER-EFFECTIVE-DATE: PIC 9(8) = 8 bytes
- ER-EXPIRY-DATE: PIC 9(8) = 8 bytes
- ER-EXCEPTION-LIMIT: PIC 9(7)V99 = 9 display bytes
- ER-REASON: PIC X(20) = 20 bytes
- ER-ACTIVE: PIC X = 1 byte

Total source-defined record length:

58 bytes

`vsam/DEFINE.jcl` declares:

`RECORDSIZE(57 57)`

The two artifacts therefore disagree.

### Decision

**Gate Type: CONTAINMENT**

KU-11 remains unresolved.

Slice 2A must not modify:

- `EXCEPTREC.cpy`;
- `vsam/DEFINE.jcl`;
- record lengths;
- field definitions;
- key offset or key length;
- dataset definition.

No assumption may be made that either 57 or 58 is the correct production
representation.

Resolution requires evidence from an authorized executable/runtime environment
or an explicit synthetic-estate design decision in a future gate.

## KU-12 — EXCEPT01 Runtime / CICS Compatibility

### Evidence

`EXCEPT01.cbl` currently uses native COBOL indexed-file operations:

- `OPEN INPUT EXCEPT-FILE`
- keyed `READ EXCEPT-FILE`
- `CLOSE EXCEPT-FILE`

The repository does not contain evidence proving:

- compilation settings;
- CICS translator settings;
- runtime file-control configuration;
- whether EXCPTKS is accessed as a native COBOL file or CICS-managed file;
- executable load modules;
- an authorized CICS region.

### Decision

**Gate Type: CONTAINMENT**

KU-12 remains unresolved.

Slice 2A may preserve the existing OPEN/READ/CLOSE statements exactly, but
must not:

- convert the access to EXEC CICS READ;
- change SELECT/ASSIGN;
- change FILE-CONTROL;
- change ACCESS MODE;
- change RECORD KEY;
- change FILE STATUS handling;
- add runtime-specific compiler or CICS assumptions.

No claim of CICS runtime compatibility may be made.

## KU-05 / KU-06 / C-03 — Expiry and Reconciliation Semantics

### Evidence

`EXCEPTREC.cpy` contains:

- ER-EFFECTIVE-DATE
- ER-EXPIRY-DATE
- ER-ACTIVE

`EXCEPT01.cbl` evaluates only:

`ER-ACTIVE = 'Y'`

It does not evaluate ER-EFFECTIVE-DATE or ER-EXPIRY-DATE.

`EXCREC01.cbl` states that it represents synthetic monthly reconciliation,
but also explicitly states:

"The detailed VSAM update logic is intentionally omitted."

`EXCRECON.jcl` invokes EXCREC01, but the actual expiry/update behavior is not
implemented in the workspace.

### Decision

**Gate Type: CONTAINMENT**

KU-05, KU-06, and C-03 remain unresolved.

Slice 2A must preserve the current observed online behavior:

- keyed lookup by account ID;
- `ER-ACTIVE = 'Y'` is the only eligibility test performed by EXCEPT01;
- no online effective-date check;
- no online expiry-date check;
- no inferred reconciliation behavior.

Do not add date comparison or expiry logic.

Do not claim that batch reconciliation is responsible for expiry enforcement.

Any semantic change requires a separate human business/operations decision.

## Existing Observed Behavior

Current EXCEPT01 behavior is:

1. set `LC-GRANDFATHERED` to `N`;
2. open EXCEPT-FILE;
3. move `AR-ACCOUNT-ID` to `ER-ACCOUNT-ID`;
4. perform keyed read;
5. invalid key -> no exception applied;
6. valid key + `ER-ACTIVE = 'Y'` ->
   - `LC-GRANDFATHERED = 'Y'`;
   - copy `ER-EXCEPTION-LIMIT` to `LC-EXCEPTION-LIMIT`;
7. valid key + `ER-ACTIVE != 'Y'` -> no exception applied;
8. close file;
9. return.

Slice 2A must preserve this sequence semantically.

## Authorized Slice 2A

**Behavior-Preserving EXCEPT01 Structural Refactoring**

### Allowed Source File

Only:

`src/cobol/EXCEPT01.cbl`

### Allowed Changes

Structural refactoring only, such as separating the existing logic into
clearly named paragraphs for:

- initialization;
- file lookup;
- exception-result handling.

The transformation must preserve the existing file operations and eligibility
semantics.

### Prohibited Changes

Do not modify:

- `src/copybooks/EXCEPTREC.cpy`;
- `vsam/DEFINE.jcl`;
- `vsam/synthetic-exceptions.csv`;
- `src/cobol/EXCREC01.cbl`;
- `jcl/EXCRECON.jcl`;
- any other source file.

Do not change:

- SELECT EXCEPT-FILE;
- ASSIGN TO EXCPTKS;
- ORGANIZATION;
- ACCESS MODE;
- RECORD KEY;
- FILE STATUS;
- OPEN behavior;
- READ key;
- INVALID KEY behavior;
- ER-ACTIVE logic;
- ER-EXCEPTION-LIMIT assignment;
- CLOSE behavior;
- program linkage.

Do not add:

- ER-EFFECTIVE-DATE logic;
- ER-EXPIRY-DATE logic;
- EXEC CICS file commands;
- new error/status behavior;
- new record-size assumptions;
- new runtime configuration.

## Behavioral Invariants

Before and after Slice 2A:

1. `LC-GRANDFATHERED` begins as `N`.
2. lookup remains keyed by `AR-ACCOUNT-ID`.
3. missing record leaves grandfathered status as `N`.
4. inactive record leaves grandfathered status as `N`.
5. active record sets grandfathered status to `Y`.
6. active record copies the same exception limit.
7. expiry/effective dates remain unused.
8. caller interface remains unchanged.

## Validation Boundary

Runtime execution is unavailable.

Slice 2A may therefore produce only:

- source diff;
- static control-flow comparison;
- file-definition comparison;
- interface comparison;
- eligibility-condition comparison.

It may not claim runtime VSAM or CICS equivalence.

## Rollback Boundary

Source-level rollback is the exact pre-Slice-2A version of:

`src/cobol/EXCEPT01.cbl`

Runtime build/deploy/restore procedures remain unverified.

## Authorization

**Slice 2A: AUTHORIZED**

Authorization is limited strictly to behavior-preserving structural
refactoring of `EXCEPT01.cbl`.

KU-11 remains an active containment gate.

KU-12 remains an active containment gate.

KU-05, KU-06, and C-03 remain active containment gates.

Deployment remains unauthorized.

Production change remains unauthorized.