# Slice 4 Gate Resolution — AtlasPay TRANSFORM Run 004

**Stage:** TRANSFORM
**Slice:** 4 — Risk Interface Encapsulation & Shared-State Reduction
**Capability:** Dynamic Transaction Limit
**Human Reviewer:** Suman Devarasetti
**Decision:** AUTHORIZE NARROWED SLICE 4A WITH CONTAINMENT GATES
**Runtime Validation:** UNAVAILABLE

## Purpose

Determine whether CUSTRSK can be decoupled from broad shared structures without
changing external risk invocation, fallback behavior, ordering, or business
semantics.

## Current Observed Structure

`TRNLIM01.cbl` currently invokes:

`CALL 'CUSTRSK' USING AUTH-REQUEST LIMIT-CONTEXT`

`CUSTRSK.cbl` receives the complete:

- AUTH-REQUEST;
- LIMIT-CONTEXT.

However, CUSTRSK actually uses only:

- `AR-ACCOUNT-ID` from AUTH-REQUEST;
- `LC-RISK-SCORE` from LIMIT-CONTEXT;
- `LC-RISK-AVAILABLE` from LIMIT-CONTEXT.

No other request or limit-context fields are referenced by CUSTRSK.

## KU-01 — Missing MQRSKGET Implementation

### Evidence

CUSTRSK invokes:

`CALL 'MQRSKGET' USING RISK-MESSAGE`

but `MQRSKGET` source is not present in the AtlasPay workspace.

Therefore the following remain unverified:

- MQ implementation;
- timeout mechanics;
- retries;
- correlation behavior;
- queue interaction details;
- external error handling.

The synthetic MQ documentation describes a risk request containing:

- account_id;
- correlation_id.

However, `RISKSCR.cpy` defines:

- RM-ACCOUNT-ID;
- RM-RISK-SCORE;
- RM-STATUS;

and contains no correlation-id field.

Because MQRSKGET is absent, the relationship between the documented
correlation_id and the actual missing wrapper implementation cannot be
established.

### Decision

**Gate Type: CONTAINMENT**

KU-01 remains unresolved.

Slice 4A must preserve exactly:

- `RISK-MESSAGE`;
- `RISKSCR.cpy`;
- `CALL 'MQRSKGET' USING RISK-MESSAGE`;
- assignment of account ID into `RM-ACCOUNT-ID`;
- RM-OK success interpretation;
- non-RM-OK unavailable interpretation.

Do not add correlation-id handling.

Do not change the MQ message structure.

Do not infer implementation behavior for MQRSKGET.

## KU-17 — Unconditional Risk Invocation

### Evidence

`TRNLIM01` calls CUSTRSK unconditionally before LIMUTIL.

LIMUTIL later ignores risk adjustment when:

`LC-GRANDFATHERED = 'Y'`

Therefore the external risk call still occurs even for a path whose final
calculation does not use risk.

The workspace does not establish whether this ordering is intentional,
operationally necessary, or merely inefficient.

### Decision

**Gate Type: CONTAINMENT**

KU-17 remains unresolved.

Slice 4A must preserve:

- the position of CUSTRSK in TRNLIM01;
- unconditional invocation of CUSTRSK;
- existing ordering relative to LIMITPOL, EXCEPT01, TMPCTRL, MERCHVAL,
  RISKFBK, and LIMUTIL.

Do not optimize away the risk call for grandfathered accounts.

## C-04 — Timeout vs. Error Behavior

### Evidence

`RISKSCR.cpy` distinguishes:

- `RM-OK = 'O'`;
- `RM-TIMEOUT = 'T'`;
- `RM-ERROR = 'E'`.

CUSTRSK currently treats every non-OK result identically:

- `LC-RISK-AVAILABLE = 'N'`;
- `LC-RISK-SCORE = 000`.

TRNLIM01 then invokes RISKFBK, which sets:

- `LC-RISK-SCORE = 650`;
- `LC-RISK-AVAILABLE = 'N'`.

### Decision

**Gate Type: CONTAINMENT**

Slice 4A must preserve this collapse of timeout/error behavior.

Do not introduce separate timeout and error semantics.

## Shared-State Refactoring Assessment

The current CUSTRSK interface is broader than its observed dependency set.

CUSTRSK does not need the entire AUTH-REQUEST or LIMIT-CONTEXT to perform its
current responsibility.

A narrowly scoped source-level refactor may therefore reduce coupling while
preserving behavior.

## Authorized Slice 4A

**CUSTRSK Narrow Interface Refactoring**

### Authorized Source Files

Only:

- `src/cobol/CUSTRSK.cbl`
- `src/cobol/TRNLIM01.cbl`

### Approved Interface Direction

CUSTRSK may be changed from:

`USING AUTH-REQUEST LIMIT-CONTEXT`

to a narrow interface containing only the values it currently requires:

- account ID;
- risk score;
- risk availability.

The corresponding TRNLIM01 call may be updated to pass those existing fields.

No new data field may be created.

## Required Behavioral Preservation

Slice 4A must preserve:

1. the same account ID supplied to RM-ACCOUNT-ID;
2. the same `CALL 'MQRSKGET' USING RISK-MESSAGE`;
3. RM-OK -> available Y + returned score;
4. non-RM-OK -> available N + score 000;
5. unconditional CUSTRSK invocation;
6. existing TRNLIM01 call ordering;
7. existing RISKFBK condition;
8. fallback score 650;
9. LIMUTIL risk semantics;
10. all existing data definitions.

## Prohibited Changes

Do not modify:

- `RISKSCR.cpy`;
- `AUTHREQ.cpy`;
- `LIMITCTX.cpy`;
- `RISKFBK.cbl`;
- `LIMUTIL.cbl`;
- MQ documentation;
- queue definitions;
- tests;
- any other source.

Do not add:

- correlation-id fields;
- retries;
- timeout values;
- MQ configuration;
- asynchronous behavior;
- new status codes;
- logging;
- new error handling;
- grandfathered-path optimization;
- new fallback semantics.

## Validation Boundary

Runtime validation remains unavailable.

Slice 4A may establish only:

- static interface compatibility;
- parameter-use reduction;
- unchanged MQ call text;
- unchanged call ordering;
- unchanged fallback control flow;
- source diff.

It may not claim runtime linkage or behavioral equivalence.

## Rollback Boundary

Source-level rollback consists of the exact pre-Slice-4A versions of:

- `src/cobol/CUSTRSK.cbl`;
- `src/cobol/TRNLIM01.cbl`.

Build, link-edit, deployment, and runtime rollback remain unverified.

## Authorization

```yaml
slice: 4A
decision: AUTHORIZED_WITH_CONTAINMENT_GATES
allowed_files:
  - src/cobol/CUSTRSK.cbl
  - src/cobol/TRNLIM01.cbl
ku_01: CONTAINMENT
ku_17: CONTAINMENT
c_04: CONTAINMENT
mq_contract_change_authorized: false
call_order_change_authorized: false
fallback_change_authorized: false
runtime_validation: UNAVAILABLE
deployment_authorized: false
production_change_authorized: false