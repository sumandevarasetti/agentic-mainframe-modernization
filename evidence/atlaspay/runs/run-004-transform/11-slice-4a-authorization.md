# Slice 4A Source Authorization — AtlasPay TRANSFORM Run 004

**Stage:** TRANSFORM
**Slice:** 4A — CUSTRSK Narrow Interface Refactoring
**Human Authorizer:** Suman Devarasetti
**Status:** AUTHORIZED WITH CONTAINMENT GATES

## Authorized Source Files

Only:

- `src/cobol/CUSTRSK.cbl`
- `src/cobol/TRNLIM01.cbl`

## Purpose

Reduce unnecessary shared-structure coupling between TRNLIM01 and CUSTRSK
without changing risk behavior, MQ invocation, fallback semantics, call order,
or data definitions.

## Current Interface

CUSTRSK currently receives:

`USING AUTH-REQUEST LIMIT-CONTEXT`

but only consumes:

- `AR-ACCOUNT-ID`

and only writes:

- `LC-RISK-SCORE`
- `LC-RISK-AVAILABLE`

## Authorized Interface Change

CUSTRSK may be changed to receive only:

- account ID;
- risk score;
- risk availability.

TRNLIM01 may update its CALL statement accordingly using existing fields.

No new data item may be introduced.

## Gate Status

- KU-01: CONTAINMENT — MQRSKGET implementation remains unavailable.
- KU-17: CONTAINMENT — CUSTRSK invocation order remains unchanged.
- C-04: CONTAINMENT — timeout/error distinction remains collapsed.

## Required Preservation

Preserve:

- account ID passed to `RM-ACCOUNT-ID`;
- `CALL 'MQRSKGET' USING RISK-MESSAGE`;
- RM-OK behavior;
- non-RM-OK behavior;
- score 000 on unavailable response inside CUSTRSK;
- `LC-RISK-AVAILABLE = 'Y'` on success;
- `LC-RISK-AVAILABLE = 'N'` on failure;
- existing RISKFBK condition;
- fallback score 650;
- CUSTRSK position in TRNLIM01;
- all existing call ordering.

## Prohibited Changes

Do not modify:

- `RISKSCR.cpy`;
- `AUTHREQ.cpy`;
- `LIMITCTX.cpy`;
- `RISKFBK.cbl`;
- `LIMUTIL.cbl`;
- MQ artifacts;
- tests;
- any other file.

Do not add:

- new copybooks;
- new structures;
- correlation ID;
- retry logic;
- timeout logic;
- logging;
- new status codes;
- grandfathered-path optimization;
- new runtime assumptions.

## Runtime Boundary

Runtime Validation: UNAVAILABLE

This authorization permits source-level interface refactoring and static
verification only.

Deployment and production change remain unauthorized.