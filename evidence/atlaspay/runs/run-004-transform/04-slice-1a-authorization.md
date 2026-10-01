# Slice 1A Source Authorization — AtlasPay TRANSFORM Run 004

**Stage:** TRANSFORM
**Slice:** 1A — Behavior-Preserving LIMITPOL Structural Refactoring
**Human Authorizer:** Suman Devarasetti
**Status:** AUTHORIZED WITH CONTAINMENT GATES

## Authorized Source

Only:

`src/cobol/LIMITPOL.cbl`

## Purpose

Improve internal structure/readability of LIMITPOL without changing observable
behavior, SQL semantics, program interface, fallback policy, or data model.

## Resolution / Containment Status

- KU-07: CONTAINMENT — effective-date selection semantics must not change.
- KU-08: RESOLVED FOR ISOLATED WORKSPACE — POLREC.cpy has no mapped COBOL consumer.
- KU-10: RESOLVED FOR WORKSPACE CLASSIFICATION — LIMITREF.jcl is anomalous/unverified.
- C-05: CONTAINMENT — 1000.00 SQL failure fallback must remain unchanged.

## Allowed Changes

- Extract existing policy retrieval into a clearly named COBOL paragraph.
- Extract existing success/fallback result handling into a clearly named paragraph.
- Improve internal readability and procedural separation.
- Preserve existing source semantics.

## Prohibited Changes

Do not change:

- SELECT columns;
- WHERE predicates;
- ACTIVE_FLAG logic;
- effective-date handling;
- SQLCODE handling;
- fallback value 1000.00;
- LINKAGE SECTION;
- PROCEDURE DIVISION USING parameters;
- AUTHREQ;
- LIMITCTX;
- DB2 schema or seed data;
- JCL;
- POLREC.cpy;
- any other COBOL program.

Do not add new SQL.

## Runtime Boundary

Runtime Validation: UNAVAILABLE

This authorization permits source-level refactoring and static verification only.

It does not authorize deployment or production change.
