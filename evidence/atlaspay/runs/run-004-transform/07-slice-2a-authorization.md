# Slice 2A Source Authorization — AtlasPay TRANSFORM Run 004

**Stage:** TRANSFORM
**Slice:** 2A — Behavior-Preserving EXCEPT01 Structural Refactoring
**Human Authorizer:** Suman Devarasetti
**Status:** AUTHORIZED WITH CONTAINMENT GATES

## Authorized Source

Only:

`src/cobol/EXCEPT01.cbl`

## Purpose

Improve internal structure/readability of EXCEPT01 without changing:

- VSAM record layout;
- file-control semantics;
- keyed lookup behavior;
- eligibility logic;
- expiry/effective-date semantics;
- program interface;
- runtime assumptions.

## Gate Status

- KU-11: CONTAINMENT — 57/58-byte VSAM discrepancy remains unresolved.
- KU-12: CONTAINMENT — CICS/runtime compatibility remains unverified.
- KU-05: CONTAINMENT — reconciliation logic remains unknown.
- KU-06: CONTAINMENT — expiry ownership remains unknown.
- C-03: CONTAINMENT — no date-based eligibility semantics may be introduced.

## Allowed Changes

Structural refactoring only, such as:

- separating initialization into a named paragraph;
- separating file lookup into a named paragraph;
- separating exception-result handling into a named paragraph;
- improving readability while preserving control flow.

## Prohibited Changes

Do not modify:

- `src/copybooks/EXCEPTREC.cpy`;
- `vsam/DEFINE.jcl`;
- `vsam/synthetic-exceptions.csv`;
- `src/cobol/EXCREC01.cbl`;
- `jcl/EXCRECON.jcl`;
- any other source file.

Do not change:

- `SELECT EXCEPT-FILE`;
- `ASSIGN TO EXCPTKS`;
- `ORGANIZATION IS INDEXED`;
- `ACCESS MODE IS DYNAMIC`;
- `RECORD KEY IS ER-ACCOUNT-ID`;
- `FILE STATUS IS WS-FILE-STATUS`;
- `OPEN INPUT EXCEPT-FILE`;
- keyed `READ`;
- `INVALID KEY` behavior;
- `ER-ACTIVE = 'Y'` logic;
- `ER-EXCEPTION-LIMIT` assignment;
- `CLOSE EXCEPT-FILE`;
- `PROCEDURE DIVISION USING AUTH-REQUEST LIMIT-CONTEXT`.

Do not add:

- ER-EFFECTIVE-DATE logic;
- ER-EXPIRY-DATE logic;
- EXEC CICS READ;
- new error/status behavior;
- new record-size assumptions;
- new runtime configuration.

## Runtime Boundary

Runtime Validation: UNAVAILABLE

This authorization permits source-level structural refactoring and static
verification only.

It does not authorize deployment or production change.