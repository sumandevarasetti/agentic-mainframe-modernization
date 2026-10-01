# Current-State Evidence Pack — AtlasPay Dynamic Transaction Limit

**Run:** `atlaspay-understand-001`
**Stage:** UNDERSTAND
**Pack version:** 1.0
**Created from frozen artifacts:** `01-broad-analysis-raw.md`, `02-impact-analysis-raw.md`, `03-business-rules-raw.md`, `04-known-unknowns-raw.md`, `05-playbook-gap-analysis.md`
**Evaluator ground truth:** Not accessed — strictly prohibited
**Modernization disposition:** None — UNDERSTAND stage only

> **Synthesis policy**: Every material claim in this document is derived exclusively from the five frozen source artifacts listed above. No new application discovery, impact analysis, business-rule recovery, or modernization planning has been performed. Where source artifacts conflict, both views are preserved. Inferred conclusions are labeled `inferred:`. Unverifiable runtime behaviors are flagged explicitly.

---

# 1. Capability Definition

## 1.1 Business Definition

The **Dynamic Transaction Limit** capability determines the maximum permissible transaction amount for a card authorization request and issues an approve/decline decision. The capability is activated on every online card authorization passing through the AtlasPay Digital Authorization API.

As stated in `docs/business-context.md` (lines 5–6), the objective is to *"make transaction limits more dynamic by incorporating product configuration, transaction context, jurisdiction, temporary customer controls, and current risk indicators."* All five inputs are already implemented in the current estate.

The capability answers a single business question per authorization: **given this account, product, jurisdiction, merchant, transaction amount, temporary spending control, and current risk profile — should this transaction be approved or declined?**

## 1.2 Technical Definition

The capability is implemented as a COBOL sub-system anchored in CICS, consisting of:

- A CICS-dispatched online orchestrator ([`ATLAUTH.cbl`](src/cobol/ATLAUTH.cbl)) that validates the request, delegates limit calculation, makes the approve/decline decision, and writes an audit record.
- A limit sub-system orchestrator ([`TRNLIM01.cbl`](src/cobol/TRNLIM01.cbl)) that calls six specialized sub-programs in sequence to populate a shared limit-context structure.
- A final limit resolution engine ([`LIMUTIL.cbl`](src/cobol/LIMUTIL.cbl)) that applies all collected inputs in a fixed 7-step algorithmic sequence to produce a single scalar output: `LC-FINAL-LIMIT`.

The capability integrates with DB2 (policy lookup), VSAM (grandfathered exception lookup), and an external MQ-based risk scoring service.

## 1.3 Functional Scope

| In Scope | Out of Scope |
|---|---|
| Account and merchant presence validation | Account existence verification against `ATLAS_ACCOUNT_PRODUCT` (not queried by any in-scope program) |
| Base limit derivation from product/jurisdiction policy | Policy data loading and maintenance (batch; no source visible) |
| Jurisdiction cap application | Risk scoring service internals (MQ external; `MQRSKGET` absent) |
| Merchant-category cap (hardcoded: MCC 7995, 6051) | Real audit-log implementation (`AUTHLOG` is a stub) |
| Customer temporary-control cap | `EXCREC01` VSAM reconciliation logic (stub) |
| Grandfathered exception override | `AUTHRPT` daily reporting logic (stub) |
| Risk-score-based limit adjustment | Upstream `AUTH-REQUEST` population mechanism (not visible in workspace) |
| MQ risk fallback (deterministic score 650) | |
| Product-maximum absolute ceiling | |
| Approve/decline decision and audit record | |

**Sources:** [`02-impact-analysis-raw.md §2`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md); [`03-business-rules-raw.md §§1–11`](runs/atlaspay/understand/run-001/03-business-rules-raw.md)

---

# 2. Observable Entry Points and Interfaces

## 2.1 Online Entry Points

| Entry Point | CICS Transaction | Program | Role | Evidence |
|---|---|---|---|---|
| Primary production entry | `ATLA` | `ATLAUTH.cbl` | Online orchestrator; account/merchant validation + limit delegation + decision | [`cics/transactions.yaml:2-4`](cics/transactions.yaml:2) |
| Diagnostic direct entry | `ATLI` | `TRNLIM01.cbl` | Bypasses `ATLAUTH`; invokes limit sub-system directly | [`cics/transactions.yaml:5-8`](cics/transactions.yaml:5) |

## 2.2 Batch Entry Points

| JCL Job | Program | Frequency | Role | Evidence |
|---|---|---|---|---|
| `LIMREFR.jcl` | `LIMITBAT.cbl` | Nightly | Stamps `LAST_REFRESH_TS` on active DB2 policy rows | [`jcl/LIMREFR.jcl`](jcl/LIMREFR.jcl); [`src/cobol/LIMITBAT.cbl:11-15`](src/cobol/LIMITBAT.cbl:11) |
| `EXCRECON.jcl` | `EXCREC01.cbl` (stub) | Monthly | VSAM exception reconciliation (manages `ER-ACTIVE` flags) | [`jcl/EXCRECON.jcl`](jcl/EXCRECON.jcl); [`src/cobol/EXCREC01.cbl:6`](src/cobol/EXCREC01.cbl:6) |
| `LIMITBKP.jcl` | IDCAMS `REPRO` | Ad-hoc | VSAM backup | [`jcl/LIMITBKP.jcl`](jcl/LIMITBKP.jcl) |
| `AUTHRPT.jcl` | `AUTHRPT.cbl` (stub) | Daily | Authorization reporting (data source unknown) | [`jcl/AUTHRPT.jcl`](jcl/AUTHRPT.jcl); [`src/cobol/AUTHRPT.cbl:6`](src/cobol/AUTHRPT.cbl:6) |
| `LIMITREF.jcl` | `LIMITPOL` (anomalous) | Unknown | Invokes sub-program `LIMITPOL` as a standalone batch step — functionally undefined | [`jcl/LIMITREF.jcl:2`](jcl/LIMITREF.jcl:2) |

## 2.3 Observable Candidate Boundary Interfaces

The following interfaces are observable from the workspace. **No modernization boundary is selected here.**

| Candidate Interface | Evidence | Observable Characteristics |
|---|---|---|
| CI-1: CICS `ATLA` → `ATLAUTH` | [`cics/transactions.yaml:2`](cics/transactions.yaml:2) | Widest possible boundary; includes all pre-guards and orchestration |
| CI-2: `ATLAUTH` → `TRNLIM01` CALL | [`ATLAUTH.cbl:32`](src/cobol/ATLAUTH.cbl:32) | Passes `AUTH-REQUEST` + `LIMIT-CONTEXT`; only `LC-FINAL-LIMIT` consumed on return |
| CI-3: `TRNLIM01` → each of six sub-programs | [`TRNLIM01.cbl:12-22`](src/cobol/TRNLIM01.cbl:12) | Six individual CALL interfaces; specific field footprints in `LIMIT-CONTEXT` |
| CI-4: `LIMITCTX.cpy` field-level interface | [`LIMITCTX.cpy:1-11`](src/copybooks/LIMITCTX.cpy:1) | Shared context; each field maps to one source program |
| CI-5: `LC-FINAL-LIMIT` scalar output | [`ATLAUTH.cbl:33`](src/cobol/ATLAUTH.cbl:33) | Single scalar consumed by `ATLAUTH` |

**Sources:** [`02-impact-analysis-raw.md §§4.1, 4.9, 11`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md)

---

# 3. Current Execution Flow

## 3.1 Online Flow

```
Digital Authorization API
        │ (AUTH-REQUEST populated by upstream — mechanism not visible in workspace)
        ▼
CICS Transaction ATLA  [cics/transactions.yaml:2]
        │
        ▼
ATLAUTH.cbl  [src/cobol/ATLAUTH.cbl]
  ├─ INITIALIZE LIMIT-CONTEXT  [ATLAUTH.cbl:15]
  ├─ CALL 'ACCTVAL' USING AUTH-REQUEST  [ATLAUTH.cbl:16]
  │     └─ IF account blank → AS-DECISION='D', AS-REASON='ACCT', WRITE-AUDIT, GOBACK  [ATLAUTH.cbl:17-21]
  ├─ CALL 'MERCHCHK' USING AUTH-REQUEST  [ATLAUTH.cbl:24]
  │     └─ IF MCC blank → AS-DECISION='D', AS-REASON='MCC ', WRITE-AUDIT, GOBACK  [ATLAUTH.cbl:25-29]
  ├─ CALL 'TRNLIM01' USING AUTH-REQUEST LIMIT-CONTEXT  [ATLAUTH.cbl:32]
  │     └─ (see §3.3 limit sub-system)
  ├─ MOVE LC-FINAL-LIMIT TO AS-APPLIED-LIMIT  [ATLAUTH.cbl:33]
  ├─ IF AR-AMOUNT <= LC-FINAL-LIMIT  [ATLAUTH.cbl:35-41]
  │     ├─ TRUE  → AS-DECISION='A', AS-REASON='0000'
  │     └─ FALSE → AS-DECISION='D', AS-REASON='LIMT'
  ├─ PERFORM WRITE-AUDIT (calls AUTHLOG)  [ATLAUTH.cbl:43-47]
  └─ GOBACK
```

**Sources:** [`ATLAUTH.cbl:15-47`](src/cobol/ATLAUTH.cbl:15); [`03-business-rules-raw.md §§1, 10`](runs/atlaspay/understand/run-001/03-business-rules-raw.md)

## 3.2 Batch Flow

| Flow | Description | Evidence |
|---|---|---|
| **Nightly policy stamp** | `LIMREFR.jcl` → `LIMITBAT` updates `LAST_REFRESH_TS` on active rows in `ATLAS_LIMIT_POLICY` | [`LIMITBAT.cbl:11-15`](src/cobol/LIMITBAT.cbl:11) |
| **Monthly VSAM reconciliation** | `EXCRECON.jcl` → `EXCREC01` (stub) manages `ER-ACTIVE` flags in VSAM exception file | [`EXCREC01.cbl:6`](src/cobol/EXCREC01.cbl:6) — logic absent |
| **VSAM backup** | `LIMITBKP.jcl` → IDCAMS `REPRO` backs up `ATLASPAY.VSAM.LIMIT.EXCEPT` | [`LIMITBKP.jcl`](jcl/LIMITBKP.jcl) |
| **Daily reporting** | `AUTHRPT.jcl` → `AUTHRPT` (stub); data source unknown | [`AUTHRPT.cbl:6`](src/cobol/AUTHRPT.cbl:6) — logic absent |
| **LIMITREF anomaly** | `LIMITREF.jcl` invokes `PGM=LIMITPOL`; `LIMITPOL` has only a LINKAGE-SECTION entry point — no batch-capable variant in workspace | [`LIMITREF.jcl:2`](jcl/LIMITREF.jcl:2) |

## 3.3 Major Call Relationships (Limit Sub-System)

```
TRNLIM01.cbl (orchestrator)  [TRNLIM01.cbl:10-22]
  ├─ INITIALIZE LIMIT-CONTEXT  [TRNLIM01.cbl:10]
  ├─ 1. CALL 'LIMITPOL' USING AUTH-REQUEST LIMIT-CONTEXT  [TRNLIM01.cbl:12]
  │       → writes LC-BASE-LIMIT, LC-PRODUCT-MAX, LC-JURIS-LIMIT  (or fallback 1000.00)
  ├─ 2. CALL 'EXCEPT01' USING AUTH-REQUEST LIMIT-CONTEXT  [TRNLIM01.cbl:13]
  │       → writes LC-GRANDFATHERED ('Y'/'N'), LC-EXCEPTION-LIMIT
  ├─ 3. CALL 'TMPCTRL' USING AUTH-REQUEST LIMIT-CONTEXT  [TRNLIM01.cbl:14]
  │       → writes LC-TEMP-LIMIT (or sentinel 9999999.99)
  ├─ 4. CALL 'MERCHVAL' USING AUTH-REQUEST LC-MCC-LIMIT  [TRNLIM01.cbl:15]
  │       → writes LC-MCC-LIMIT (1000, 2000, or sentinel 9999999.99)
  │       ⚠ NOTE: LC-MCC-LIMIT passed as bare field ref, not full LIMIT-CONTEXT
  ├─ 5. CALL 'CUSTRSK' USING AUTH-REQUEST LIMIT-CONTEXT  [TRNLIM01.cbl:16]
  │       → writes LC-RISK-AVAILABLE, LC-RISK-SCORE (from MQ via MQRSKGET wrapper)
  ├─ 5a. IF LC-RISK-AVAILABLE NOT = 'Y'  [TRNLIM01.cbl:18-20]
  │         CALL 'RISKFBK' USING AUTH-REQUEST LIMIT-CONTEXT
  │         → overwrites LC-RISK-SCORE with 650
  └─ 6. CALL 'LIMUTIL' USING AUTH-REQUEST LIMIT-CONTEXT  [TRNLIM01.cbl:22]
          → reads all LC-* fields; writes LC-FINAL-LIMIT
```

**Note — double initialization:** `ATLAUTH` initializes `LIMIT-CONTEXT` at line 15 before calling `TRNLIM01`. `TRNLIM01` initializes it again at line 10. Both programs assume ownership of initialization. This is load-bearing coupling.

**Sources:** [`02-impact-analysis-raw.md §4.4`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md); [`TRNLIM01.cbl:10-22`](src/cobol/TRNLIM01.cbl:10)

## 3.4 CICS Interactions

| Interaction | Type | Evidence |
|---|---|---|
| Transaction `ATLA` dispatches `ATLAUTH` | CICS transaction dispatch | [`cics/transactions.yaml:2-4`](cics/transactions.yaml:2) |
| Transaction `ATLI` dispatches `TRNLIM01` directly | CICS diagnostic entry; bypasses `ATLAUTH` | [`cics/transactions.yaml:5-8`](cics/transactions.yaml:5) |
| `EXCEPT01` VSAM I/O under CICS | Native COBOL FILE-CONTROL — no `EXEC CICS FILE CONTROL`; CICS compilation options unverifiable | [`EXCEPT01.cbl:7-11`](src/cobol/EXCEPT01.cbl:7) |

## 3.5 DB2 Interactions

| Program | SQL Operation | Table | Columns | Evidence |
|---|---|---|---|---|
| `LIMITPOL.cbl` | `SELECT INTO` | `ATLAS_LIMIT_POLICY` | `BASE_LIMIT`, `PRODUCT_MAX`, `JURIS_LIMIT` | [`LIMITPOL.cbl:16-23`](src/cobol/LIMITPOL.cbl:16) |
| `LIMITBAT.cbl` | `UPDATE` | `ATLAS_LIMIT_POLICY` | `LAST_REFRESH_TS` | [`LIMITBAT.cbl:11-15`](src/cobol/LIMITBAT.cbl:11) |

**Risk note:** `LIMITPOL`'s query filters on `PRODUCT_CODE`, `JURISDICTION`, and `ACTIVE_FLAG='Y'` but not on `EFFECTIVE_DATE`, which is part of the primary key. If multiple active rows exist for the same product/jurisdiction, DB2 returns `SQLCODE -811`. The code handles only `SQLCODE = 0`; any non-zero SQLCODE silently applies the 1,000.00 floor with no error propagation. Source: [`LIMITPOL.cbl:16-33`](src/cobol/LIMITPOL.cbl:16); [`db2/schema.sql:12`](db2/schema.sql:12).

## 3.6 VSAM Interactions

| Program | Operation | Dataset | Key | Evidence |
|---|---|---|---|---|
| `EXCEPT01.cbl` | `READ … KEY IS ER-ACCOUNT-ID` | `ATLASPAY.VSAM.LIMIT.EXCEPT` (KSDS) | `AR-ACCOUNT-ID` | [`EXCEPT01.cbl:25-38`](src/cobol/EXCEPT01.cbl:25) |
| `EXCREC01.cbl` | Unknown — stub | `ATLASPAY.VSAM.LIMIT.EXCEPT` | Unknown | [`EXCREC01.cbl:6`](src/cobol/EXCREC01.cbl:6) |
| IDCAMS REPRO | Backup copy | `ATLASPAY.VSAM.LIMIT.EXCEPT` | N/A | [`LIMITBKP.jcl`](jcl/LIMITBKP.jcl) |

**Anomaly:** `EXCEPT01` opens the VSAM file, reads one record, then closes — all within a single authorization invocation. File open/close errors are not handled (`WS-FILE-STATUS` is declared but never checked after `OPEN`/`CLOSE`). Source: [`EXCEPT01.cbl:19`](src/cobol/EXCEPT01.cbl:19).

**Record size discrepancy:** `vsam/DEFINE.jcl:6` specifies `RECORDSIZE(57 57)` but `EXCEPTREC.cpy` computes ≥58 bytes. Unresolved — see KU-11.

## 3.7 MQ Interactions

| Program | Operation | Queue | Message Structure | Evidence |
|---|---|---|---|---|
| `CUSTRSK.cbl` | CALL `MQRSKGET` USING RISK-MESSAGE (outbound request + inbound response) | `ATLAS.RISK.REQUEST` (out), `ATLAS.RISK.RESPONSE` (in) | `RM-ACCOUNT-ID PIC X(12)` in; `RM-RISK-SCORE PIC 9(3)`, `RM-STATUS PIC X` out | [`CUSTRSK.cbl:16`](src/cobol/CUSTRSK.cbl:16); [`RISKSCR.cpy`](src/copybooks/RISKSCR.cpy); [`mq/queues.yaml`](mq/queues.yaml) |

**Status values (from `RISKSCR.cpy:5-7`):** `RM-OK='O'`, `RM-TIMEOUT='T'`, `RM-ERROR='E'`. Both `RM-TIMEOUT` and `RM-ERROR` produce `LC-RISK-AVAILABLE='N'`, triggering the `RISKFBK` fallback. Timeout interval, retry logic, correlation mechanism, and queue manager name are entirely unverifiable — `MQRSKGET` source is absent from the workspace.

**Sources:** [`02-impact-analysis-raw.md §4.7`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md); [`mq/queues.yaml`](mq/queues.yaml); [`mq/message-contracts.md`](mq/message-contracts.md)

---

# 4. Artifact and Dependency Inventory

## 4.1 Programs

| Program | Role | Dependency Type | Evidence |
|---|---|---|---|
| `ATLAUTH.cbl` | Online orchestrator — CICS `ATLA` entry | **Direct** (upstream caller of limit sub-system) | [`src/cobol/ATLAUTH.cbl`](src/cobol/ATLAUTH.cbl) |
| `TRNLIM01.cbl` | Limit sub-system orchestrator — also CICS `ATLI` entry | **Direct** (called by ATLAUTH) | [`src/cobol/TRNLIM01.cbl`](src/cobol/TRNLIM01.cbl) |
| `ACCTVAL.cbl` | Account presence guard | **Direct** (pre-guard; out of limit scope) | [`src/cobol/ACCTVAL.cbl`](src/cobol/ACCTVAL.cbl) |
| `MERCHCHK.cbl` | MCC presence guard | **Direct** (pre-guard; out of limit scope) | [`src/cobol/MERCHCHK.cbl`](src/cobol/MERCHCHK.cbl) |
| `LIMITPOL.cbl` | DB2 policy reader | **Direct** (called by TRNLIM01) | [`src/cobol/LIMITPOL.cbl`](src/cobol/LIMITPOL.cbl) |
| `EXCEPT01.cbl` | VSAM grandfathered exception reader | **Direct** (called by TRNLIM01) | [`src/cobol/EXCEPT01.cbl`](src/cobol/EXCEPT01.cbl) |
| `TMPCTRL.cbl` | Temporary-control pass-through | **Direct** (called by TRNLIM01) | [`src/cobol/TMPCTRL.cbl`](src/cobol/TMPCTRL.cbl) |
| `MERCHVAL.cbl` | Hardcoded MCC cap logic | **Direct** (called by TRNLIM01) | [`src/cobol/MERCHVAL.cbl`](src/cobol/MERCHVAL.cbl) |
| `CUSTRSK.cbl` | MQ risk-score requestor | **Direct** (called by TRNLIM01) | [`src/cobol/CUSTRSK.cbl`](src/cobol/CUSTRSK.cbl) |
| `RISKFBK.cbl` | Deterministic MQ fallback | **Direct** (conditionally called by TRNLIM01) | [`src/cobol/RISKFBK.cbl`](src/cobol/RISKFBK.cbl) |
| `LIMUTIL.cbl` | Final limit calculation engine | **Direct** (called by TRNLIM01) | [`src/cobol/LIMUTIL.cbl`](src/cobol/LIMUTIL.cbl) |
| `AUTHLOG.cbl` | Audit writer (stub) | **Direct** (called by ATLAUTH) | [`src/cobol/AUTHLOG.cbl`](src/cobol/AUTHLOG.cbl) |
| `LIMITBAT.cbl` | Nightly DB2 policy stamp | **Transitive** (batch; affects policy data freshness) | [`src/cobol/LIMITBAT.cbl`](src/cobol/LIMITBAT.cbl) |
| `EXCREC01.cbl` | Monthly VSAM reconciliation (stub) | **Transitive** (batch; manages `ER-ACTIVE` flags) | [`src/cobol/EXCREC01.cbl`](src/cobol/EXCREC01.cbl) |
| `AUTHRPT.cbl` | Daily auth reporting (stub) | **Transitive** (batch; data source unknown) | [`src/cobol/AUTHRPT.cbl`](src/cobol/AUTHRPT.cbl) |
| `MQRSKGET` | MQ request-reply wrapper | **Direct** (called by CUSTRSK; **source absent**) | [`CUSTRSK.cbl:16`](src/cobol/CUSTRSK.cbl:16) |

## 4.2 Copybooks

| Copybook | Contents | Consumers | Blast Radius | Evidence |
|---|---|---|---|---|
| `AUTHREQ.cpy` | `AUTH-REQUEST` structure (8 fields) | 12 programs: ATLAUTH, ACCTVAL, MERCHCHK, TRNLIM01, LIMITPOL, EXCEPT01, TMPCTRL, MERCHVAL, CUSTRSK, RISKFBK, LIMUTIL, AUTHLOG | **Maximum — all 12 online programs** | [`src/copybooks/AUTHREQ.cpy`](src/copybooks/AUTHREQ.cpy) |
| `LIMITCTX.cpy` | `LIMIT-CONTEXT` structure (10 fields) | 8 programs: ATLAUTH, TRNLIM01, LIMITPOL, EXCEPT01, TMPCTRL, CUSTRSK, RISKFBK, LIMUTIL | **High — all limit sub-system programs + ATLAUTH** | [`src/copybooks/LIMITCTX.cpy`](src/copybooks/LIMITCTX.cpy) |
| `AUTHRESP.cpy` | `AUTH-RESPONSE` structure | ATLAUTH, AUTHLOG | Medium — orchestrator + audit sink | [`src/copybooks/AUTHRESP.cpy`](src/copybooks/AUTHRESP.cpy) |
| `EXCEPTREC.cpy` | VSAM exception record layout | EXCEPT01 only | Low | [`src/copybooks/EXCEPTREC.cpy`](src/copybooks/EXCEPTREC.cpy) |
| `RISKSCR.cpy` | MQ RISK-MESSAGE layout | CUSTRSK only | Low | [`src/copybooks/RISKSCR.cpy`](src/copybooks/RISKSCR.cpy) |
| `POLREC.cpy` | `POLICY-RECORD` layout (compatible with `ATLAS_LIMIT_POLICY`) | **No known consumer in `src/cobol/`** | Unknown | [`src/copybooks/POLREC.cpy`](src/copybooks/POLREC.cpy) |

## 4.3 CICS

| Resource | Type | Role | Evidence |
|---|---|---|---|
| `ATLA` | Transaction | Production entry; dispatches `ATLAUTH` | [`cics/transactions.yaml:2-4`](cics/transactions.yaml:2) |
| `ATLI` | Transaction | Diagnostic entry; dispatches `TRNLIM01` directly | [`cics/transactions.yaml:5-8`](cics/transactions.yaml:5) |

## 4.4 JCL / Batch

| JCL | Program | Frequency | Evidence |
|---|---|---|---|
| `LIMREFR.jcl` | `LIMITBAT` | Nightly | [`jcl/LIMREFR.jcl`](jcl/LIMREFR.jcl) |
| `EXCRECON.jcl` | `EXCREC01` (stub) | Monthly | [`jcl/EXCRECON.jcl`](jcl/EXCRECON.jcl) |
| `LIMITBKP.jcl` | IDCAMS REPRO | Ad-hoc | [`jcl/LIMITBKP.jcl`](jcl/LIMITBKP.jcl) |
| `AUTHRPT.jcl` | `AUTHRPT` (stub) | Daily | [`jcl/AUTHRPT.jcl`](jcl/AUTHRPT.jcl) |
| `LIMITREF.jcl` | `LIMITPOL` (**anomalous**) | Unknown | [`jcl/LIMITREF.jcl`](jcl/LIMITREF.jcl) |

## 4.5 DB2

| Table | Role | Queried By | DDL | Seed Data |
|---|---|---|---|---|
| `ATLAS_LIMIT_POLICY` | Product/jurisdiction policy reference data (BASE_LIMIT, PRODUCT_MAX, JURIS_LIMIT, EFFECTIVE_DATE, ACTIVE_FLAG, LAST_REFRESH_TS) | `LIMITPOL.cbl` (read), `LIMITBAT.cbl` (update) | [`db2/schema.sql:1-13`](db2/schema.sql:1) | [`db2/seed-data.sql`](db2/seed-data.sql) |
| `ATLAS_ACCOUNT_PRODUCT` | Account→product/jurisdiction mapping | **Not queried by any in-scope program** | [`db2/schema.sql:15-20`](db2/schema.sql:15) | — |

## 4.6 VSAM

| Dataset | Type | Role | Evidence |
|---|---|---|---|
| `ATLASPAY.VSAM.LIMIT.EXCEPT` | KSDS | Grandfathered exception records; key = account-ID | [`vsam/DEFINE.jcl`](vsam/DEFINE.jcl); [`vsam/synthetic-exceptions.csv`](vsam/synthetic-exceptions.csv) |

**Record layout:** defined by [`EXCEPTREC.cpy`](src/copybooks/EXCEPTREC.cpy). Fields: `ER-ACCOUNT-ID`, `ER-ACTIVE`, `ER-EXCEPTION-LIMIT`, `ER-EXPIRY-DATE`.

## 4.7 MQ / External Systems

| Resource | Type | Role | Evidence |
|---|---|---|---|
| `ATLAS.RISK.REQUEST` | MQ queue | Outbound risk request | [`mq/queues.yaml:3`](mq/queues.yaml:3) |
| `ATLAS.RISK.RESPONSE` | MQ queue | Inbound risk response | [`mq/queues.yaml:7`](mq/queues.yaml:7) |
| `MQRSKGET` | External COBOL subprogram (wrapper) | Sends MQ request; receives score+status | [`CUSTRSK.cbl:16`](src/cobol/CUSTRSK.cbl:16) — **source absent** |
| External risk scoring service | External | Consumes `ATLAS.RISK.REQUEST`; produces score 0–999 | [`mq/message-contracts.md`](mq/message-contracts.md) |
| Digital Authorization API | External (upstream) | Populates `AUTH-REQUEST`; invokes CICS `ATLA` | Mechanism not visible in workspace |

## 4.8 Tests

| File | Nature | Status | Evidence |
|---|---|---|---|
| `tests/golden-master/cases.yaml` | 12 characterization test cases (GM-001–GM-012); covers all major limit paths | No executable test harness in workspace (static synthetic estate) | [`tests/golden-master/cases.yaml`](tests/golden-master/cases.yaml) |
| `tests/golden-master-cases.yaml` | Alternate test specification; 4+ cases | **Contradicts** `golden-master/cases.yaml` on the high-risk branch (see C-01) | [`tests/golden-master-cases.yaml`](tests/golden-master-cases.yaml) |

## 4.9 Unresolved External Components

| Component | Nature | Known Interface | Unverifiable |
|---|---|---|---|
| `MQRSKGET` | MQ wrapper; source absent | `CALL 'MQRSKGET' USING RISK-MESSAGE` ([`CUSTRSK.cbl:16`](src/cobol/CUSTRSK.cbl:16)); RISKSCR.cpy layout | Timeout, retry, correlation, queue manager name |
| Real `AUTHLOG` | Audit sink; stub in workspace | Receives `AUTH-REQUEST` + `AUTH-RESPONSE` ([`ATLAUTH.cbl:47`](src/cobol/ATLAUTH.cbl:47)) | I/O destination, field usage, side effects |
| Real `EXCREC01` | VSAM reconciliation; stub | Reads/writes `ATLASPAY.VSAM.LIMIT.EXCEPT` | `ER-ACTIVE` lifecycle management |
| `POLREC.cpy` consumer | Unknown batch program | `POLREC.cpy` defines `POLICY-RECORD` | Identity, frequency, behavior |
| Digital Authorization API | Upstream caller | Populates `AUTH-REQUEST` before CICS dispatch | `AR-PRODUCT-CODE`, `AR-JURISDICTION`, `AR-TEMP-CONTROL-AMT` population mechanism |

**Sources:** [`02-impact-analysis-raw.md §§2.3, 5`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md); [`01-broad-analysis-raw.md §Key Findings`](runs/atlaspay/understand/run-001/01-broad-analysis-raw.md)

---

# 5. Business Rule Catalog

Rules are reported as observed. No rule meaning has been changed. Classification key: `[EXPLICIT]` = unambiguously stated in source code · `[STRONGLY INFERRED]` = clearly implied with corroborating evidence · `[UNRESOLVED]` = implementation present but business intent requires external confirmation.

## Category 1 — Pre-Limit Guards

| Rule ID | Rule Statement | Implementing Artifact | Condition | Outcome | Confidence |
|---|---|---|---|---|---|
| **BR-01** | An authorization request with a blank account identifier is declined before any limit calculation. Decline reason code: `ACCT`. | [`ACCTVAL.cbl:11-12`](src/cobol/ACCTVAL.cbl:11); [`ATLAUTH.cbl:17-21`](src/cobol/ATLAUTH.cbl:17) | `AR-ACCOUNT-ID = SPACES` | `AS-DECISION='D'`, `AS-REASON-CODE='ACCT'`, audit written, GOBACK | `[EXPLICIT]` — High |
| **BR-02** | An authorization request with a blank MCC is declined before any limit calculation. Decline reason code: `MCC `. | [`MERCHCHK.cbl:11-12`](src/cobol/MERCHCHK.cbl:11); [`ATLAUTH.cbl:25-29`](src/cobol/ATLAUTH.cbl:25) | `AR-MERCHANT-CATEGORY = SPACES` | `AS-DECISION='D'`, `AS-REASON-CODE='MCC '`, audit written, GOBACK | `[EXPLICIT]` — High |

**Unresolved intent (BR-01, BR-02):** Validation is presence-only. No semantic validation (format, length, account existence lookup) is implemented. Whether the `ATLAS_ACCOUNT_PRODUCT` table should be consulted to confirm account existence is not implemented by any in-scope program.

## Category 2 — Base Limit

| Rule ID | Rule Statement | Implementing Artifact | Condition | Outcome | Confidence |
|---|---|---|---|---|---|
| **BR-03** | The starting transaction limit is determined by looking up the account's product code and jurisdiction in `ATLAS_LIMIT_POLICY`. The table supplies `BASE_LIMIT`, `PRODUCT_MAX`, and `JURIS_LIMIT`. | [`LIMITPOL.cbl:16-28`](src/cobol/LIMITPOL.cbl:16); [`db2/schema.sql:3-13`](db2/schema.sql:3); [`db2/seed-data.sql`](db2/seed-data.sql) | `SQLCODE = 0` on `SELECT INTO WHERE PRODUCT_CODE=:AR-PRODUCT-CODE AND JURISDICTION=:AR-JURISDICTION AND ACTIVE_FLAG='Y'` | `LC-BASE-LIMIT`, `LC-PRODUCT-MAX`, `LC-JURIS-LIMIT` populated from DB2 | `[EXPLICIT]` — High |
| **BR-04** | If the policy lookup fails for any reason — including no row, DB2 error, or `SQLCODE -811` (multiple active rows) — the base limit, product maximum, and jurisdiction limit are all set to 1,000.00. Authorization proceeds. | [`LIMITPOL.cbl:29-33`](src/cobol/LIMITPOL.cbl:29) | `SQLCODE ≠ 0` (any failure) | `LC-BASE-LIMIT=LC-PRODUCT-MAX=LC-JURIS-LIMIT=1000.00`; no error flag propagated to caller | `[EXPLICIT]` behavior; `[UNRESOLVED]` business intent of 1,000.00 value |

**Unresolved intent (BR-04):** The fallback is silent — callers cannot distinguish successful lookup from failed lookup. The 1,000.00 value is undocumented as a business decision.

## Category 3 — Jurisdiction Constraints

| Rule ID | Rule Statement | Implementing Artifact | Condition | Outcome | Confidence |
|---|---|---|---|---|---|
| **BR-05** | If the jurisdiction limit is lower than the current candidate limit and greater than zero, the candidate is reduced to the jurisdiction limit. | [`LIMUTIL.cbl:15-18`](src/cobol/LIMUTIL.cbl:15) | `LC-JURIS-LIMIT > 0 AND LC-JURIS-LIMIT < WS-CANDIDATE-LIMIT` | `WS-CANDIDATE-LIMIT := LC-JURIS-LIMIT` | `[EXPLICIT]` — High |

**Unresolved intent (BR-05):** A zero jurisdiction limit is treated as "no cap" (sentinel semantics). Whether a zero value is a valid business state or a data error is unresolved.

## Category 4 — Customer and Account-Specific Controls

| Rule ID | Rule Statement | Implementing Artifact | Condition | Outcome | Confidence |
|---|---|---|---|---|---|
| **BR-06** | A customer-supplied temporary control amount, if greater than zero, caps the candidate limit. | [`TMPCTRL.cbl:10-14`](src/cobol/TMPCTRL.cbl:10) | `AR-TEMP-CONTROL-AMT > 0` | `LC-TEMP-LIMIT := AR-TEMP-CONTROL-AMT`; otherwise `LC-TEMP-LIMIT := 9999999.99` (sentinel = no cap) | `[EXPLICIT]` — High |
| **BR-07** | The temporary cap is applied after the jurisdiction cap and before the grandfathered exception check. | [`LIMUTIL.cbl:25-28`](src/cobol/LIMUTIL.cbl:25); [`TRNLIM01.cbl:12-22`](src/cobol/TRNLIM01.cbl:12) | Ordering in `LIMUTIL` | Temp cap applied at step 3; grandfathered override at step 4 (overrides result regardless) | `[STRONGLY INFERRED]` — Medium |

## Category 5 — Exception (Grandfathered) Behavior

| Rule ID | Rule Statement | Implementing Artifact | Condition | Outcome | Precedence | Confidence |
|---|---|---|---|---|---|---|
| **BR-08** | If an account has an active grandfathered exception, the exception limit **replaces** the result of all prior limit calculations (base, jurisdiction, MCC, temp-control). | [`EXCEPT01.cbl:25-35`](src/cobol/EXCEPT01.cbl:25); [`LIMUTIL.cbl:30-31`](src/cobol/LIMUTIL.cbl:30) | `LC-GRANDFATHERED = 'Y'` (set by EXCEPT01 when record found with `ER-ACTIVE='Y'`) | `WS-CANDIDATE-LIMIT := LC-EXCEPTION-LIMIT` (all prior caps discarded) | Overrides BR-03 through BR-07; is itself overridden by BR-18 (product-max ceiling) | `[EXPLICIT]` — High |
| **BR-09** | An exception record activates the grandfathered override only if `ER-ACTIVE = 'Y'`. Records with `ER-ACTIVE = 'N'` are ignored. `ER-EXPIRY-DATE` is **never evaluated** at authorization time. | [`EXCEPT01.cbl:32`](src/cobol/EXCEPT01.cbl:32) | `ER-ACTIVE = 'Y'` in VSAM record | `LC-GRANDFATHERED := 'Y'`; `LC-EXCEPTION-LIMIT := ER-EXCEPTION-LIMIT` | — | `[EXPLICIT]` — High |

**Unresolved intent (BR-08, BR-09):** (a) Whether grandfathered exceptions should be exempt from the product-maximum ceiling is unresolved (see C-02). (b) `ER-EXPIRY-DATE` enforcement mechanism — runtime vs. batch — is unresolved (see C-03).

## Category 6 — Merchant-Related Constraints

| Rule ID | Rule Statement | Implementing Artifact | Condition | Outcome | Confidence |
|---|---|---|---|---|---|
| **BR-10** | MCC 7995 (gambling) carries a hardcoded cap of 1,000.00. | [`MERCHVAL.cbl:12-13`](src/cobol/MERCHVAL.cbl:12) | `AR-MERCHANT-CATEGORY = '7995'` | `LC-MCC-LIMIT := 1000.00` | `[EXPLICIT]` — High |
| **BR-11** | MCC 6051 (quasi-cash/cryptocurrency) carries a hardcoded cap of 2,000.00. | [`MERCHVAL.cbl:14-15`](src/cobol/MERCHVAL.cbl:14) | `AR-MERCHANT-CATEGORY = '6051'` | `LC-MCC-LIMIT := 2000.00` | `[EXPLICIT]` — High |
| **BR-12** | All other MCCs carry no merchant-imposed cap (sentinel value 9,999,999.99 effectively removes the cap). | [`MERCHVAL.cbl:10, 16-17`](src/cobol/MERCHVAL.cbl:10) | `AR-MERCHANT-CATEGORY` is neither `7995` nor `6051` | `LC-MCC-LIMIT := 9999999.99` (sentinel — never restricts) | `[EXPLICIT]` — High |

**Unresolved intent (BR-10, BR-11):** Caps are hardcoded. Whether these values are configurable (policy-driven) or deliberately hardcoded (regulatory/contractual) is not documented.

## Category 7 — Risk-Related Adjustments

| Rule ID | Rule Statement | Implementing Artifact | Condition | Outcome | Confidence |
|---|---|---|---|---|---|
| **BR-13** | A risk score ≥ 800 reduces the candidate limit by 20%. | [`LIMUTIL.cbl:33-34`](src/cobol/LIMUTIL.cbl:33) | `LC-RISK-SCORE >= 800` AND `LC-GRANDFATHERED ≠ 'Y'` | `WS-CANDIDATE-LIMIT := WS-CANDIDATE-LIMIT × 0.80` | `[EXPLICIT]` behavior; `[UNRESOLVED]` direction (higher = more restrictive in this estate, counter-intuitive vs. credit-bureau convention) |
| **BR-14** | A risk score < 500 reduces the candidate limit by 30%. | [`LIMUTIL.cbl:36-37`](src/cobol/LIMUTIL.cbl:36) | `LC-RISK-SCORE < 500` AND `LC-GRANDFATHERED ≠ 'Y'` | `WS-CANDIDATE-LIMIT := WS-CANDIDATE-LIMIT × 0.70` | `[EXPLICIT]` behavior; `[UNRESOLVED]` direction (GM-008 description labels as intentional for this estate) |
| **BR-15** | Risk scores 500–799 (inclusive) produce no risk adjustment. | [`LIMUTIL.cbl:32-40`](src/cobol/LIMUTIL.cbl:32) (absence of action) | `500 <= LC-RISK-SCORE <= 799` AND `LC-GRANDFATHERED ≠ 'Y'` | No change to `WS-CANDIDATE-LIMIT` | `[EXPLICIT]` (by omission) — High |

**Unresolved intent (BR-13/BR-14):** Boundary asymmetry — score 500 is neutral; score 800 triggers a reduction. Whether this boundary placement is deliberate policy is unresolved.

## Category 8 — Timeout and Fallback Behavior

| Rule ID | Rule Statement | Implementing Artifact | Condition | Outcome | Confidence |
|---|---|---|---|---|---|
| **BR-16-RISK** | When the MQ risk scoring service is unavailable (timeout or error), a deterministic fallback score of 650 is substituted. Authorization proceeds normally. | [`RISKFBK.cbl:10-12`](src/cobol/RISKFBK.cbl:10); [`TRNLIM01.cbl:18-20`](src/cobol/TRNLIM01.cbl:18); [`mq/queues.yaml:11-13`](mq/queues.yaml:11) | `LC-RISK-AVAILABLE NOT = 'Y'` (set by CUSTRSK on any non-`RM-OK` status) | `LC-RISK-SCORE := 650`; `LC-RISK-AVAILABLE` remains `'N'` | `[EXPLICIT]` — High |
| **BR-17-RISK** | For each authorization, the system requests a per-account risk score (0–999) from an external MQ service. | [`CUSTRSK.cbl:13-24`](src/cobol/CUSTRSK.cbl:13); [`RISKSCR.cpy`](src/copybooks/RISKSCR.cpy); [`mq/queues.yaml`](mq/queues.yaml) | Always (step 5 in `TRNLIM01`; no short-circuit for grandfathered accounts) | `LC-RISK-AVAILABLE := 'Y'/'N'`; `LC-RISK-SCORE := RM-RISK-SCORE` or 000 | `[STRONGLY INFERRED]` — Medium (`MQRSKGET` source absent) |

**Unresolved intent (BR-16-RISK):** MQ timeout and MQ error produce identical fallback behavior (`AS-RISK-MODE` in AUTH-RESPONSE is declared but never set — intended differentiator, never implemented). Fallback score 650 places the result in the neutral band — mathematically equivalent to receiving a live 650-score response.

## Category 9 — Product Maximum Ceiling

| Rule ID | Rule Statement | Implementing Artifact | Condition | Outcome | Precedence | Confidence |
|---|---|---|---|---|---|---|
| **BR-18** | After all other factors are applied, the final candidate is capped by the product maximum. No other rule can produce a limit above the product maximum. | [`LIMUTIL.cbl:42-44`](src/cobol/LIMUTIL.cbl:42) | `WS-CANDIDATE-LIMIT > LC-PRODUCT-MAX` (checked last, unconditionally) | `WS-CANDIDATE-LIMIT := LC-PRODUCT-MAX` | Overrides all prior rules including BR-08 (grandfathered exception) | `[EXPLICIT]` — High |

**Unresolved intent (BR-18):** The product-max ceiling applies even to grandfathered exceptions (see C-02). Under policy-lookup fallback (BR-04), `LC-PRODUCT-MAX = 1,000.00`, so the ceiling provides no additional headroom during a DB2 outage.

## Category 10 — Authorization Decision

| Rule ID | Rule Statement | Implementing Artifact | Condition | Outcome | Confidence |
|---|---|---|---|---|---|
| **BR-19** | A transaction amount at or below the resolved limit is approved. Reason code: `0000`. | [`ATLAUTH.cbl:35-37`](src/cobol/ATLAUTH.cbl:35) | `AR-AMOUNT <= LC-FINAL-LIMIT` | `AS-DECISION := 'A'`, `AS-REASON-CODE := '0000'` | `[EXPLICIT]` — High |
| **BR-20** | A transaction amount above the resolved limit is declined. Reason code: `LIMT`. | [`ATLAUTH.cbl:38-41`](src/cobol/ATLAUTH.cbl:38) | `AR-AMOUNT > LC-FINAL-LIMIT` | `AS-DECISION := 'D'`, `AS-REASON-CODE := 'LIMT'` | `[EXPLICIT]` — High |
| **BR-21** | The resolved limit is recorded in the authorization response (`AS-APPLIED-LIMIT`) regardless of approve/decline outcome. | [`ATLAUTH.cbl:33`](src/cobol/ATLAUTH.cbl:33) | Always (executes before the approve/decline branch) | `AS-APPLIED-LIMIT := LC-FINAL-LIMIT` | `[EXPLICIT]` — High |
| **BR-22** | An audit record is written on every authorization path — account-invalid, MCC-invalid, approved, and declined. | [`ATLAUTH.cbl:20, 28, 43`](src/cobol/ATLAUTH.cbl:20) | Always | `WRITE-AUDIT` performed; real `AUTHLOG` I/O destination unknown | `[STRONGLY INFERRED]` — Medium (AUTHLOG is stub) |

## Category 11 — Ordering and Precedence

| Rule ID | Rule Statement | Implementing Artifact | Confidence |
|---|---|---|---|
| **BR-23** | Account and merchant validation precede limit calculation. If either fails, no limit calculation occurs. | [`ATLAUTH.cbl:16-30`](src/cobol/ATLAUTH.cbl:16) | `[EXPLICIT]` — High |
| **BR-24** | Within limit calculation, caps are applied in a fixed 7-step sequence (see §6). Sequence is semantically load-bearing. | [`LIMUTIL.cbl:12-46`](src/cobol/LIMUTIL.cbl:12) | `[EXPLICIT]` — High |
| **BR-25** | The six input sub-programs to limit calculation are called in a fixed order: LIMITPOL → EXCEPT01 → TMPCTRL → MERCHVAL → CUSTRSK → (RISKFBK conditional) → LIMUTIL. | [`TRNLIM01.cbl:12-22`](src/cobol/TRNLIM01.cbl:12) | `[EXPLICITLY OBSERVED]` — High |

**Sources:** [`03-business-rules-raw.md:27-674`](runs/atlaspay/understand/run-001/03-business-rules-raw.md)

---

# 6. Rule Precedence and Behavioral Sequence

## 6.1 Authorization Request Pre-Processing

```
Step A: Account validation (ACCTVAL)
  → IF blank: decline ACCT / audit / EXIT [BR-01, BR-23]

Step B: Merchant validation (MERCHCHK)
  → IF blank: decline MCC  / audit / EXIT [BR-02, BR-23]
```

No limit calculation occurs if either guard fires. This ordering is semantically load-bearing — no path around it exists in the source. Source: [`ATLAUTH.cbl:16-30`](src/cobol/ATLAUTH.cbl:16).

## 6.2 Limit Context Population (TRNLIM01 call sequence)

```
Sub-step 1: LIMITPOL  → LC-BASE-LIMIT, LC-PRODUCT-MAX, LC-JURIS-LIMIT  [BR-03 or BR-04]
Sub-step 2: EXCEPT01  → LC-GRANDFATHERED, LC-EXCEPTION-LIMIT           [BR-09]
Sub-step 3: TMPCTRL   → LC-TEMP-LIMIT                                   [BR-06]
Sub-step 4: MERCHVAL  → LC-MCC-LIMIT                                    [BR-10/BR-11/BR-12]
Sub-step 5: CUSTRSK   → LC-RISK-AVAILABLE, LC-RISK-SCORE                [BR-17-RISK]
Sub-step 5a (cond): RISKFBK → LC-RISK-SCORE := 650                     [BR-16-RISK]
Sub-step 6: LIMUTIL   → LC-FINAL-LIMIT (consumes all above)             [BR-24]
```

**Load-bearing ordering constraint:** Each sub-step's output is visible to all subsequent sub-steps via the shared `LIMIT-CONTEXT`. The call sequence in [`TRNLIM01.cbl:12-22`](src/cobol/TRNLIM01.cbl:12) is not merely organizational — changing it would change results. Specifically: `CUSTRSK` is always called even for grandfathered accounts (MQ round-trip wasted work, but not a defect — risk score is ignored in `LIMUTIL` when `LC-GRANDFATHERED='Y'`).

## 6.3 LIMUTIL 7-Step Resolution Algorithm

The 9-step algorithm documented in [`AGENTS.md`](AGENTS.md:37) and confirmed in [`LIMUTIL.cbl:12-46`](src/cobol/LIMUTIL.cbl:12) resolves as follows (steps labeled per BR-24):

```
Step 1:  WS-CANDIDATE-LIMIT := LC-BASE-LIMIT                              [BR-03/BR-04]
Step 2:  IF LC-JURIS-LIMIT > 0 AND < candidate → candidate := LC-JURIS-LIMIT   [BR-05]
Step 3:  IF LC-MCC-LIMIT > 0 AND < candidate  → candidate := LC-MCC-LIMIT      [BR-10/BR-11/BR-12]
Step 4:  IF LC-TEMP-LIMIT > 0 AND < candidate → candidate := LC-TEMP-LIMIT     [BR-06/BR-07]
Step 5a: IF LC-GRANDFATHERED = 'Y'
             candidate := LC-EXCEPTION-LIMIT       [BR-08 — overrides Steps 1-4]
Step 5b: ELSE (not grandfathered)
             IF LC-RISK-SCORE >= 800  → candidate := candidate × 0.80   [BR-13]
             ELSE IF LC-RISK-SCORE < 500 → candidate := candidate × 0.70 [BR-14]
             (ELSE: no change, neutral band)                              [BR-15]
Step 6:  IF candidate > LC-PRODUCT-MAX → candidate := LC-PRODUCT-MAX    [BR-18 — absolute ceiling]
Step 7:  LC-FINAL-LIMIT := candidate
```

**Semantically load-bearing ordering observations:**

1. **Step 5a before Step 6:** Grandfathered exception is applied *before* the product-max ceiling. A grandfathered exception limit that exceeds the product maximum is silently reduced to the product maximum. This is observable in the source and may not be the intended business behavior (see C-02).

2. **Step 5a before Step 5b:** Grandfathered accounts bypass risk adjustments entirely. The `IF/ELSE` structure means Steps 5a and 5b are mutually exclusive.

3. **Step 6 is unconditional:** The product-max ceiling always applies — regardless of whether the account is grandfathered, how the risk score was obtained, or whether the fallback was used.

4. **Step 1 (base limit) is always initialized first:** If policy lookup fails, `LC-BASE-LIMIT = 1,000.00`; the entire remaining algorithm executes with this floor, and the product-max ceiling also becomes 1,000.00.

## 6.4 Authorization Decision

```
AS-APPLIED-LIMIT := LC-FINAL-LIMIT  [BR-21 — unconditional]
IF AR-AMOUNT <= LC-FINAL-LIMIT → APPROVE (A / 0000)  [BR-19]
ELSE                           → DECLINE (D / LIMT)  [BR-20]
WRITE-AUDIT (AUTHLOG)                                 [BR-22]
```

**Sources:** [`03-business-rules-raw.md §11`](runs/atlaspay/understand/run-001/03-business-rules-raw.md); [`LIMUTIL.cbl:12-46`](src/cobol/LIMUTIL.cbl:12); [`ATLAUTH.cbl:33-47`](src/cobol/ATLAUTH.cbl:33)

---

# 7. Exception and Fallback Behavior

## 7.1 Grandfathered Exception Handling

- **Trigger:** VSAM record for `AR-ACCOUNT-ID` exists in `ATLASPAY.VSAM.LIMIT.EXCEPT` with `ER-ACTIVE = 'Y'`. Source: [`EXCEPT01.cbl:26-35`](src/cobol/EXCEPT01.cbl:26).
- **Effect:** `LC-GRANDFATHERED := 'Y'`; `LC-EXCEPTION-LIMIT := ER-EXCEPTION-LIMIT`. In `LIMUTIL`, this overrides all prior cap calculations. Source: [`LIMUTIL.cbl:30-31`](src/cobol/LIMUTIL.cbl:30).
- **Not triggered when:** Record is absent (`INVALID KEY CONTINUE`) or `ER-ACTIVE ≠ 'Y'`. `LC-GRANDFATHERED` defaults to `'N'` at context initialization.
- **`ER-EXPIRY-DATE` is never evaluated** at authorization time. Active flag is the sole control. Whether expiry dates are enforced by the `EXCREC01` batch program (a stub) is unknown. Source: [`EXCEPT01.cbl:32`](src/cobol/EXCEPT01.cbl:32); [`EXCREC01.cbl:6`](src/cobol/EXCREC01.cbl:6).
- **Product-max override:** Grandfathered exception limits are still subject to the product-max ceiling (BR-18). This may or may not be intended behavior (see C-02).

## 7.2 Temporary Customer Controls

- **Trigger:** `AR-TEMP-CONTROL-AMT > 0` in the authorization request. Source: [`TMPCTRL.cbl:10-14`](src/cobol/TMPCTRL.cbl:10).
- **Effect:** `LC-TEMP-LIMIT := AR-TEMP-CONTROL-AMT`. Applied as step 4 in `LIMUTIL` — reduces candidate only if lower than current candidate.
- **Not triggered when:** `AR-TEMP-CONTROL-AMT = 0` (or absent); sentinel `9999999.99` is used.
- **Overridden by:** Grandfathered exception (if active, Steps 5a replaces result of step 4).
- **How `AR-TEMP-CONTROL-AMT` is populated** before CICS dispatch is not visible in any workspace artifact. Source: KU-02.

## 7.3 Policy Lookup Fallback

- **Trigger:** Any non-zero `SQLCODE` from the `ATLAS_LIMIT_POLICY` `SELECT INTO` — including `SQLCODE -811` (multiple active rows per product/jurisdiction). Source: [`LIMITPOL.cbl:25-33`](src/cobol/LIMITPOL.cbl:25).
- **Effect:** `LC-BASE-LIMIT = LC-PRODUCT-MAX = LC-JURIS-LIMIT = 1,000.00`. Authorization proceeds. No error indicator is returned to `TRNLIM01` or `ATLAUTH`.
- **Consequence:** Under fallback, the product-max ceiling is also 1,000.00 — no rule can produce a limit above 1,000.00.
- **Unresolved:** Whether the 1,000.00 value is an intentional conservative floor or a default approximation is not documented.

## 7.4 MQ Risk Fallback

- **Trigger:** `LC-RISK-AVAILABLE ≠ 'Y'` after `CUSTRSK` returns. `CUSTRSK` sets this for both `RM-TIMEOUT` and `RM-ERROR` — the two conditions are behaviorally collapsed. Source: [`CUSTRSK.cbl:18-24`](src/cobol/CUSTRSK.cbl:18); [`TRNLIM01.cbl:18-20`](src/cobol/TRNLIM01.cbl:18).
- **Effect:** `RISKFBK` sets `LC-RISK-SCORE := 650`. Score 650 is in the neutral band (500–799), producing no risk adjustment. Authorization result is identical to receiving a live 650-score. Source: [`RISKFBK.cbl:10-12`](src/cobol/RISKFBK.cbl:10).
- **Corroboration:** GM-009 asserts `expected_limit: 5000.00` for GLD1/US when `risk_available: false`. Source: [`tests/golden-master/cases.yaml:74`](tests/golden-master/cases.yaml:74).
- **`AS-RISK-MODE` in `AUTH-RESPONSE`** is declared but never set by any program — presumably intended to signal live vs. fallback mode to downstream systems, but never implemented. Source: [`AUTHRESP.cpy:7`](src/copybooks/AUTHRESP.cpy:7).

## 7.5 Authorization Validation Exits

- **Account-invalid exit:** If `AR-ACCOUNT-ID = SPACES`, `ATLAUTH` issues `GOBACK` after writing audit. No limit calculation occurs. Source: [`ATLAUTH.cbl:17-21`](src/cobol/ATLAUTH.cbl:17).
- **MCC-invalid exit:** If `AR-MERCHANT-CATEGORY = SPACES`, `ATLAUTH` issues `GOBACK` after writing audit. No limit calculation occurs. Source: [`ATLAUTH.cbl:25-29`](src/cobol/ATLAUTH.cbl:25).

## 7.6 Other Material Fallback Paths

- **`EXCEPT01` VSAM read failure:** File open/close status (`WS-FILE-STATUS`) is declared but never checked after `OPEN`/`CLOSE`. An I/O failure on the VSAM file would not be detected and `LC-GRANDFATHERED` would remain `'N'` (default). Source: [`EXCEPT01.cbl:19`](src/cobol/EXCEPT01.cbl:19).
- **CICS `ATLI` diagnostic entry:** `TRNLIM01` can be invoked directly via CICS transaction `ATLI`, bypassing `ATLAUTH`. How `AUTH-REQUEST` is populated for this path is not visible in any source. Source: [`cics/transactions.yaml:5-8`](cics/transactions.yaml:5).
- **Double `LIMIT-CONTEXT` initialization:** `ATLAUTH` initializes `LIMIT-CONTEXT` before calling `TRNLIM01`; `TRNLIM01` re-initializes at its own entry. Either initialization failing would leave stale data. The double-init is protective but also means both programs assume ownership. Source: [`ATLAUTH.cbl:15`](src/cobol/ATLAUTH.cbl:15); [`TRNLIM01.cbl:10`](src/cobol/TRNLIM01.cbl:10).

**Sources:** [`02-impact-analysis-raw.md §§4.5–4.8, 7`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md); [`03-business-rules-raw.md §§5, 8`](runs/atlaspay/understand/run-001/03-business-rules-raw.md)

---

# 8. Conflicts and Contradictions

All conflicts are preserved as observed. No source is declared authoritative unless workspace evidence proves it.

| ID | Conflicting Sources | Nature of Conflict | Status |
|---|---|---|---|
| **C-01** | `tests/golden-master-cases.yaml:8-13` expects `expected_limit: 6000.00` for `risk_score=825` (GLD1/US), implying risk *increases* the limit. `tests/golden-master/cases.yaml` GM-007 expects `4000.00` for `risk=850`. `LIMUTIL.cbl:33-34` confirms `×0.80` = 4000. Case label "high-risk-score-increase" and expected value in the flat file directly contradict implementation and the fuller test specification. | Test files carry contradictory behavioral expectations for the high-risk branch. | `UNRESOLVED` — authoritative test file cannot be determined from workspace artifacts alone |
| **C-02** | `LIMUTIL.cbl:30-44` applies the product-max ceiling after grandfathered exception override. `vsam/synthetic-exceptions.csv` contains `SYN000000777` with `exception_limit=12000.00`; GLD1/US `PRODUCT_MAX=9000`. The grandfathered exception would be silently capped to 9,000. No business specification document confirms whether grandfathered accounts should be exempt from the product ceiling. | The code treats product-max as absolute even for grandfathered accounts; business intent is undocumented. | `UNRESOLVED` |
| **C-03** | `EXCEPTREC.cpy:4` declares `ER-EXPIRY-DATE`. `EXCEPT01.cbl:32` evaluates only `ER-ACTIVE = 'Y'` — `ER-EXPIRY-DATE` is never read. `EXCREC01.cbl:6` (stub) implies batch enforcement, but the logic is absent. | Three sources suggest different enforcement locations: declaration implies runtime evaluation, code ignores it, batch stub implies batch-side expiry. | `UNRESOLVED` |
| **C-04** | `CUSTRSK.cbl:18-24` — `RM-TIMEOUT` and `RM-ERROR` both set `LC-RISK-AVAILABLE='N'`, collapsing two distinct conditions into one fallback path. `AUTHRESP.cpy:7` declares `AS-RISK-MODE PIC X` (presumably intended to distinguish live/fallback), but no program assigns it. `mq/queues.yaml:11-13` says timeout triggers `RISKFBK`. | The implementation collapses timeout and error; the response structure has an apparently intended but never-populated differentiator field. | `UNRESOLVED` |
| **C-05** | `LIMITPOL.cbl:29-33` silently applies a 1,000.00 floor on any DB2 failure, with no error indicator. No business specification or comment documents the business intent of 1,000.00. The value could be an intentional conservative floor during outages or a programmer default. | Business intent of the fallback value is undocumented. | `UNRESOLVED` |
| **C-06** | `mq/message-contracts.md:7` — *"higher means more restrictive in this example."* `tests/golden-master/cases.yaml` GM-008 description says the low-score direction is *"intentionally more restrictive in this estate."* `tests/golden-master-cases.yaml:8` — case label "high-risk-score-increase" implies the opposite assumption (high score = higher limit). | Risk score semantics are counter-intuitive by design in the test data, but one test file appears authored under the opposite assumption. | Partially clarified by GM-008 description; `UNRESOLVED` for the flat test file |

**Sources:** [`03-business-rules-raw.md §Conflict and Ambiguity Register`](runs/atlaspay/understand/run-001/03-business-rules-raw.md:633); [`02-impact-analysis-raw.md §9`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md)

---

# 9. Known Unknowns Register

All 18 known unknowns are reproduced from [`04-known-unknowns-raw.md`](runs/atlaspay/understand/run-001/04-known-unknowns-raw.md) without correction or resolution.

| ID | Uncertainty | Evidence Available | Why Unresolved | Modernization Risk | Evidence Required to Resolve |
|---|---|---|---|---|---|
| **KU-01** | `MQRSKGET` source absent — timeout interval, retry count, correlation-ID mechanism, queue manager name entirely unknown | `CALL 'MQRSKGET' USING RISK-MESSAGE` at [`CUSTRSK.cbl:16`](src/cobol/CUSTRSK.cbl:16); no source in `src/cobol/` | Source not in workspace | **HIGH** — Any evolution of the risk path is unverifiable without this source; fallback (RISKFBK) determinism is known, but the live path is opaque | Obtain `MQRSKGET` COBOL source or formal API specification |
| **KU-02** | `AUTH-REQUEST` population mechanism before CICS dispatch — how `AR-PRODUCT-CODE`, `AR-JURISDICTION`, `AR-TEMP-CONTROL-AMT`, `AR-TRANSACTION-TYPE` are set is unknown | [`ATLAUTH.cbl:6`](src/cobol/ATLAUTH.cbl:6) COPYs `AUTHREQ` into WORKING-STORAGE; `ATLAS_ACCOUNT_PRODUCT` exists but no program queries it | Upstream mechanism is external to workspace; no source artifact shows pre-dispatch population | **HIGH** — Changing the input contract requires knowing how the upstream caller populates it | Obtain Digital Authorization API documentation or COMMAREA specification |
| **KU-03** | `AUTH-REQUEST` population for CICS `ATLI` direct entry — no source shows how `TRNLIM01` receives a populated LINKAGE SECTION when invoked via `ATLI` | [`cics/transactions.yaml:5-8`](cics/transactions.yaml:5) | No source artifact covers this diagnostic invocation path | **MEDIUM** — `ATLI` is a second entry point; any evolution of `TRNLIM01`'s interface must preserve this path | CICS program definition for `ATLI`; test or operational documentation for the diagnostic path |
| **KU-04** | Real `AUTHLOG` I/O destination and behavior — where and how audit records are physically written | [`AUTHLOG.cbl:10`](src/cobol/AUTHLOG.cbl:10) stub comment | Stub only; real implementation absent from workspace | **HIGH** — Any change to `AUTH-RESPONSE` fields or `WRITE-AUDIT` timing has unknown audit impact | Obtain real `AUTHLOG.cbl` source or I/O specification |
| **KU-05** | Real `EXCREC01` reconciliation logic — how `ER-ACTIVE` is managed and cleared | [`EXCREC01.cbl:6`](src/cobol/EXCREC01.cbl:6) stub comment | Stub only; real implementation absent | **MEDIUM** — The `ER-ACTIVE` lifecycle directly affects grandfathered exception activation | Obtain real `EXCREC01.cbl` source |
| **KU-06** | `ER-EXPIRY-DATE` enforcement intent — declared in [`EXCEPTREC.cpy:4`](src/copybooks/EXCEPTREC.cpy:4), never evaluated in [`EXCEPT01.cbl:32`](src/cobol/EXCEPT01.cbl:32); whether enforcement is batch-side (`EXCREC01`) or was omitted entirely is unknown | `EXCEPTREC.cpy:4`; `EXCEPT01.cbl:32`; `EXCREC01.cbl:6` | Implementation code does not evaluate the field; batch implementation is absent | **MEDIUM** — A production record with a past expiry date but `ER-ACTIVE='Y'` would still grant a grandfathered exception | SME confirmation; real `EXCREC01` source; business specification |
| **KU-07** | Whether multiple active rows per `(PRODUCT_CODE, JURISDICTION)` can exist in production — `LIMITPOL.cbl:16-23` does not filter on `EFFECTIVE_DATE`; `SQLCODE -811` risk | [`db2/schema.sql:12`](db2/schema.sql:12) PK includes `EFFECTIVE_DATE`; [`LIMITPOL.cbl:16-23`](src/cobol/LIMITPOL.cbl:16) | Production data state is not visible in the workspace; DB2 schema does not enforce single-row-per-product-jurisdiction | **MEDIUM** — A multi-row state would silently apply the 1,000.00 floor; production customers would receive wrong limits undetected | DB2 operational query on production table; data governance documentation |
| **KU-08** | `POLREC.cpy` consumer — no `COPY POLREC` in any `src/cobol/` file; possible absent batch program consuming `ATLAS_LIMIT_POLICY` records | [`src/copybooks/POLREC.cpy`](src/copybooks/POLREC.cpy) defines `POLICY-RECORD`; no consumer found | Consumer program(s) are not in workspace | **MEDIUM** — Any schema change to `ATLAS_LIMIT_POLICY` may break an unknown consumer | Identify and obtain the program(s) that include `POLREC.cpy` |
| **KU-09** | `AS-RISK-MODE` semantics — [`AUTHRESP.cpy:7`](src/copybooks/AUTHRESP.cpy:7) declares it; no assignment anywhere in workspace; likely intended to distinguish live/fallback risk mode | `AUTHRESP.cpy:7`; no `MOVE … TO AS-RISK-MODE` found anywhere | Field is declared but never populated | **LOW** (static) / **MEDIUM** (if downstream systems read it) | Confirm with SME whether downstream systems (real `AUTHLOG`, Digital Auth API) read this field |
| **KU-10** | `LIMITREF.jcl` intent — [`jcl/LIMITREF.jcl:2`](jcl/LIMITREF.jcl:2) executes `PGM=LIMITPOL`; `LIMITPOL` has only a LINKAGE SECTION entry point, no batch entry; whether a batch-capable variant exists in production load library is unknown | `LIMITREF.jcl:2`; `LIMITPOL.cbl:11-13` (LINKAGE only) | No batch entry point visible in source | **LOW** (operational anomaly) — unless this JCL runs in production, in which case it would abend | Confirm JCL purpose with operations team; check production load library |
| **KU-11** | VSAM record-size discrepancy — [`vsam/DEFINE.jcl:6`](vsam/DEFINE.jcl:6) `RECORDSIZE(57 57)` vs. `EXCEPTREC.cpy` computed ≥58 bytes | `DEFINE.jcl:6`; `EXCEPTREC.cpy` layout | Cannot resolve from workspace; physical production cluster state is not visible | **MEDIUM** — A 1-byte undersize RECORDSIZE would cause VSAM truncation of exception records, potentially corrupting `ER-EXPIRY-DATE` | Confirm production VSAM DEFINE parameters; compare against copybook layout |
| **KU-12** | `EXCEPT01` native COBOL VSAM I/O behavior under CICS — [`EXCEPT01.cbl:7-11`](src/cobol/EXCEPT01.cbl:7) uses native FILE-CONTROL with no `EXEC CICS FILE CONTROL`; CICS compilation options (`RENT`, `REUS`) and whether this compiles/runs correctly are unknown | `EXCEPT01.cbl:7-11`; no EXEC CICS FILE CONTROL in source | Load-module attributes and CICS compiler options are not in workspace | **HIGH** — Native COBOL VSAM I/O under CICS requires specific compiler options; failure would silently leave `LC-GRANDFATHERED='N'` | CICS load-module attributes; COBOL compilation listings; runtime testing |
| **KU-13** | Conflict between `tests/golden-master-cases.yaml` and `tests/golden-master/cases.yaml` for high-risk branch — one expects 6000.00 (increase), the other 4000.00 (reduction); `LIMUTIL.cbl:33-34` confirms ×0.80 | [`tests/golden-master-cases.yaml:12`](tests/golden-master-cases.yaml:12) vs [`tests/golden-master/cases.yaml:64`](tests/golden-master/cases.yaml:64) | Two test files exist; authoritative file cannot be determined from workspace artifacts | **MEDIUM** — Test harness preparation during PROVE will be blocked until resolved | Governance decision on authoritative test file; ideally with SME or original test author |
| **KU-14** | `LIMITBAT`'s `LAST_REFRESH_TS` purpose — stamped nightly ([`LIMITBAT.cbl:13-14`](src/cobol/LIMITBAT.cbl:13)); no program reads it; operational purpose (staleness detection, monitoring) is unknown | `LIMITBAT.cbl:13-14`; no read of `LAST_REFRESH_TS` in any source | Consumers are absent from workspace; may be an operational monitoring tool or external reporting query | **LOW** | Confirm with operations/DBA team |
| **KU-15** | `ATLAS_ACCOUNT_PRODUCT` table has no consumer in the online path — [`db2/schema.sql:15-20`](db2/schema.sql:15); no in-scope program queries it; whether account→product resolution happens upstream or is bypassed is unknown | `db2/schema.sql:15-20`; no `SELECT … FROM ATLAS_ACCOUNT_PRODUCT` in any source | Table definition exists; no code queries it | **MEDIUM** — If account→product resolution is expected to happen in this capability and is absent, the product code in `AUTH-REQUEST` may be incorrect or unvalidated | Confirm whether the Digital Auth API resolves account→product before dispatch |
| **KU-16** | `AR-TRANSACTION-TYPE` field purpose — [`AUTHREQ.cpy:5`](src/copybooks/AUTHREQ.cpy:5); no in-scope program evaluates it; declared in request structure but behaviorally inert | `AUTHREQ.cpy:5`; no `EVALUATE AR-TRANSACTION-TYPE` or equivalent in any source | Field is declared and presumably populated by caller but never consumed in workspace | **LOW** (if genuinely future use) / **MEDIUM** (if existing downstream systems depend on it) | Confirm field semantics with SME; check if caller or audit sink uses it |
| **KU-17** | Whether `CUSTRSK` is invoked for accounts already known to be grandfathered — `TRNLIM01.cbl:16` calls `CUSTRSK` unconditionally before the `RISKFBK` conditional; `LC-GRANDFATHERED='Y'` is set by step 2 but `CUSTRSK` is step 5; risk score is not used in `LIMUTIL` when grandfathered | [`TRNLIM01.cbl:13`](src/cobol/TRNLIM01.cbl:13) (EXCEPT01 sets LC-GRANDFATHERED); [`TRNLIM01.cbl:16`](src/cobol/TRNLIM01.cbl:16) (CUSTRSK called unconditionally) | Observable behavior but intent is ambiguous — may be intentional (future use) or oversight | **LOW** (behavioral) / **MEDIUM** (performance/MQ load under high-volume grandfathered accounts) | SME confirmation on whether CUSTRSK should short-circuit for grandfathered accounts |
| **KU-18** | `AUTHRPT` data source — [`AUTHRPT.cbl:6`](src/cobol/AUTHRPT.cbl:6) is a stub; `jcl/AUTHRPT.jcl` shows it runs daily; what data it reports on and whether it reads `AUTH-RESPONSE` data from any downstream store is unknown | `AUTHRPT.cbl:6` stub; `AUTHRPT.jcl` | Stub only; implementation absent | **LOW** | Obtain real `AUTHRPT.cbl` source or report specification |

**Sources:** [`04-known-unknowns-raw.md:16-39`](runs/atlaspay/understand/run-001/04-known-unknowns-raw.md:16); [`01-broad-analysis-raw.md §Key Findings`](runs/atlaspay/understand/run-001/01-broad-analysis-raw.md); [`02-impact-analysis-raw.md §§7, 9`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md)

---

# 10. Evidence Quality Assessment

Framework: Agentic Strangler playbooks — Discovery (v0.3.1), Dependency Analysis (v0.3.1), Rule Extraction (v0.3.1).

## 10.1 Summary Counts

| Metric | Count |
|---|---|
| Total playbook requirements reviewed | 25 |
| SATISFIED | 24 (96%) |
| PARTIALLY SATISFIED | 1 (4%) |
| MISSING | 0 (0%) |
| Requirements that block UNDERSTAND exit | 0 |

## 10.2 Satisfied Requirements

| Requirement ID | Description | Source |
|---|---|---|
| DISC-REQ-01 | Capability definition — boundary, business purpose, functional scope | `01-broad-analysis-raw.md`; `02-impact-analysis-raw.md §§1-2`; `03-business-rules-raw.md` |
| DISC-REQ-02 | Entry points — all online and batch entry points identified | `01-broad-analysis-raw.md`; `02-impact-analysis-raw.md §§2.1, 4.1, 4.9` |
| DISC-REQ-03 | Artifact inventory — 15 programs, 6 copybooks, 2 DB2 tables, 1 VSAM, 2 MQ queues, 5 JCL | `01-broad-analysis-raw.md §What Was Done`; `02-impact-analysis-raw.md §§2.1, 5.4` |
| DISC-REQ-04 | Dependency candidates — all callers, callees, DB2, VSAM, MQ interactions mapped | `02-impact-analysis-raw.md §§2.3, 4.1-4.9, 5.1-5.5` |
| DISC-REQ-05 | Known unknowns — 18 specific unverifiable behaviors enumerated with source citations | `04-known-unknowns-raw.md:16-38` |
| DISC-REQ-06 | Artifact references — source-level citations (file + line) for all artifacts | All source citations in `01-broad-analysis-raw.md` and `02-impact-analysis-raw.md` |
| DISC-REQ-07 | Relationship references — verifiable citations for all call linkages | `02-impact-analysis-raw.md §§3, 4, 5` |
| DEP-REQ-01 | Direct impact set — all directly invoked/calling components identified | `02-impact-analysis-raw.md §§2.1, 5.1/5.2` |
| DEP-REQ-02 | Transitive impact set — full upstream/downstream chain traced | `02-impact-analysis-raw.md §§5.1-5.3, 6` |
| DEP-REQ-03 | Data impact — shared structures, DB2 tables, VSAM files assessed | `02-impact-analysis-raw.md §§4.4-4.6, 5.4, 7 (IMP-01 to IMP-04)` |
| DEP-REQ-04 | Batch impact — all JCL, batch programs, reconciliation workflows identified | `02-impact-analysis-raw.md §§5.5, 7 (IMP-10)` |
| DEP-REQ-05 | Middleware impact — CICS transactions, MQ queues, DB2 attachment analyzed | `02-impact-analysis-raw.md §§4.1, 4.7, 4.9` |
| DEP-REQ-07 | Unresolved dependencies — `MQRSKGET` and real `AUTHLOG` explicitly isolated | `02-impact-analysis-raw.md §§2.3, 7 (IMP-05, IMP-09)` |
| DEP-REQ-08 | Source relationships — exact line numbers cited for all CALL statements | `02-impact-analysis-raw.md §§4.2, 4.4` |
| DEP-REQ-09 | Dependency relationships — structured categorization (Data, Control, Middleware, Batch) | `02-impact-analysis-raw.md §5` |
| DEP-REQ-10 | Confidence classification — explicit High/Medium/Low with rationale | `02-impact-analysis-raw.md §10` |
| RULE-REQ-01 | Candidate business rules — 25 rules across 11 categories | `03-business-rules-raw.md` |
| RULE-REQ-02 | Rule precedence — 9-step resolution sequence verified in `LIMUTIL.cbl` | `03-business-rules-raw.md §11`; `LIMUTIL.cbl:10-47` |
| RULE-REQ-03 | Exception paths — grandfathered, fallback score, policy floor all cataloged | `03-business-rules-raw.md §§5, 8` |
| RULE-REQ-04 | Unresolved business intent — 5 ambiguities in Conflict/Ambiguity Register | `03-business-rules-raw.md §Conflict and Ambiguity Register` |
| RULE-REQ-05 | Implementing artifacts — each rule maps to exact program and lines | `03-business-rules-raw.md` (all 25 rules) |
| RULE-REQ-06 | Conditions — formal predicate logic for each rule | `03-business-rules-raw.md` (all 25 rules) |
| RULE-REQ-07 | Outcomes — exact state changes and return codes for each rule | `03-business-rules-raw.md` (all 25 rules) |
| RULE-REQ-08 | Confidence classification — 21 High, 4 Medium/Low across 25 rules | `03-business-rules-raw.md §Summary Table` |

## 10.3 Partially Satisfied Requirements

| Requirement ID | Description | Gap | Blocking? |
|---|---|---|---|
| **DEP-REQ-06** | Test impact — characterization test assets assessed | Test harness is absent (static synthetic estate with no test runner); `tests/golden-master-cases.yaml` and `tests/golden-master/cases.yaml` contradict each other on the high-risk branch (KU-13). Test cases serve as characterization specifications but cannot be executed. Resolution belongs in the PROVE stage. | **No** |

## 10.4 Remaining Evidence Limitations

1. **External stub behavior is unverifiable from source:** `MQRSKGET`, real `AUTHLOG`, real `EXCREC01`, and real `AUTHRPT` are all absent. Their behavioral contracts are characterized by interface only.
2. **Production runtime state is opaque:** DB2 data state (multi-row risk for `LIMITPOL`), VSAM cluster record size, VSAM exception record lifecycle, and `LAST_REFRESH_TS` consumer are not determinable from workspace artifacts.
3. **Upstream input population is invisible:** How `AUTH-REQUEST` fields are set before CICS dispatch is not demonstrated by any workspace artifact.
4. **CICS compilation options are absent:** Load-module attributes for `EXCEPT01` and all sub-programs are not in the workspace.

> **These limitations do not indicate analytical deficiencies.** They are inherent to the static nature of the workspace and reflect genuine boundaries of what can be known from source artifacts alone without access to a running system.

**Sources:** [`05-playbook-gap-analysis.md §§2, 3, 4`](runs/atlaspay/understand/run-001/05-playbook-gap-analysis.md)

---

# 11. Human Validation Required

## 11.1 SME Confirmation

| Question | Related Unknown/Conflict | Priority |
|---|---|---|
| Is the product-maximum ceiling intentionally absolute for grandfathered accounts, or should grandfathered accounts be exempt from `LC-PRODUCT-MAX`? | C-02, KU-12 | **HIGH** — affects correctness of exception override |
| Is `ER-EXPIRY-DATE` intended to be enforced at authorization time, by the `EXCREC01` batch process, or is expiry management done by another mechanism? | C-03, KU-06 | **HIGH** — expired exceptions may be granting unauthorized limits |
| What is the business intent of the 1,000.00 policy-lookup fallback floor? Is it a deliberate conservative floor during DB2 outages? | C-05, KU-07 | **HIGH** — silent failure to customers |
| Should `CUSTRSK` (MQ risk call) be short-circuited for grandfathered accounts where the risk score is known to be unused? | KU-17 | **MEDIUM** |
| Is `AS-RISK-MODE` in `AUTH-RESPONSE` intended to be populated, and do any downstream systems (real `AUTHLOG`, API) read it? | C-04, KU-09 | **MEDIUM** |
| Should timeout and MQ error produce different fallback behaviors, or is the collapsed path intentional? | C-04 | **MEDIUM** |
| Is `AR-TRANSACTION-TYPE` intended for current use or future use? Do any downstream systems evaluate it? | KU-16 | **LOW** |
| Is `LIMITREF.jcl` operational? Does a batch-capable `LIMITPOL` variant exist in the production load library? | KU-10 | **LOW** |
| What is the operational purpose of `LAST_REFRESH_TS` in `ATLAS_LIMIT_POLICY`? Which systems consume it? | KU-14 | **LOW** |

## 11.2 Runtime Observation Required

| Question | Related Unknown | What Observation Is Needed |
|---|---|---|
| Does `EXCEPT01` compile and run correctly under CICS with native COBOL VSAM I/O? | KU-12 | CICS compilation listing for `EXCEPT01`; runtime trace showing successful VSAM read |
| Does the real MQ timeout produce `RM-STATUS='T'` and the error path `RM-STATUS='E'`, or are they collapsed before `CUSTRSK` sees them? | KU-01, C-04 | Runtime observation of `MQRSKGET` behavior under timeout and error conditions |
| Are multiple active rows per `(PRODUCT_CODE, JURISDICTION)` present in the production `ATLAS_LIMIT_POLICY` table? | KU-07 | Production DB2 query: `SELECT COUNT(*) … WHERE ACTIVE_FLAG='Y' GROUP BY PRODUCT_CODE, JURISDICTION HAVING COUNT(*) > 1` |
| What does `ATLI` pass to `TRNLIM01`'s LINKAGE SECTION? | KU-03 | CICS program definition; runtime trace of a diagnostic `ATLI` invocation |

## 11.3 External System Documentation Required

| Item | Related Unknown | Documentation Needed |
|---|---|---|
| `MQRSKGET` | KU-01 | Source code or formal API specification including timeout, retry, correlation-ID, queue manager |
| Real `AUTHLOG` implementation | KU-04 | Source code or I/O specification; field consumption details |
| Digital Authorization API → CICS dispatch contract | KU-02 | API contract documenting how `AUTH-REQUEST` fields are populated |
| `ATLAS_ACCOUNT_PRODUCT` table usage | KU-15 | Confirmation of where account→product resolution occurs in the end-to-end flow |

## 11.4 Missing Source Required

| Item | Related Unknown | Source Needed |
|---|---|---|
| `MQRSKGET.cbl` | KU-01 | COBOL source of MQ wrapper subprogram |
| Real `AUTHLOG.cbl` | KU-04 | Non-stub COBOL source of audit sink |
| Real `EXCREC01.cbl` | KU-05, KU-06 | Non-stub COBOL source of VSAM reconciliation |
| `POLREC.cpy` consumer program | KU-08 | COBOL source of unknown batch policy-record consumer |

## 11.5 Additional Tests Required

| Test | Related Unknown | Purpose |
|---|---|---|
| Resolve `tests/golden-master-cases.yaml` vs `tests/golden-master/cases.yaml` discrepancy for high-risk branch | KU-13, C-01 | Determine authoritative expected behavior for risk_score ≥ 800 |
| Execute `EXCEPT01` VSAM I/O under CICS | KU-12 | Confirm runtime viability of native COBOL FILE-CONTROL under CICS |
| Test `LIMITPOL` under `SQLCODE -811` conditions | KU-07 | Confirm fallback behavior is silent; confirm 1,000.00 is returned |

**Sources:** [`02-impact-analysis-raw.md §12`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md); [`04-known-unknowns-raw.md`](runs/atlaspay/understand/run-001/04-known-unknowns-raw.md); [`05-playbook-gap-analysis.md §3`](runs/atlaspay/understand/run-001/05-playbook-gap-analysis.md)

---

# 12. UNDERSTAND Stage Exit Assessment

## 12.1 Conclusion

**The UNDERSTAND stage has produced sufficient evidence to proceed to the DECIDE stage.**

This conclusion reflects the distinction between:
- **Sufficient understanding to make a modernization decision** — which this evidence pack achieves; and
- **Complete knowledge of every runtime behavior** — which is neither achievable from static source analysis alone nor required before proceeding to DECIDE.

## 12.2 Evidence Supporting Readiness to Proceed

The following high-confidence understandings are established from direct workspace evidence:

| Understanding | Confidence | Evidence |
|---|---|---|
| Complete 7-step limit resolution algorithm | **High** | `LIMUTIL.cbl:12-46` — fully readable; verified against 12 GM cases |
| Full online call chain (ATLAUTH → TRNLIM01 → 6 sub-programs) | **High** | All source files open and read; call signatures traced |
| Copybook fan-out blast radius (12 programs for AUTHREQ.cpy; 8 for LIMITCTX.cpy) | **High** | COPY statement search; confirmed |
| All business rules (25 rules, 21 EXPLICIT, 4 STRONGLY INFERRED/UNRESOLVED) | **High (core)** | Source-grounded; corroborated by GM test cases |
| Grandfathered exception override path and precedence | **High** | `EXCEPT01.cbl`; `LIMUTIL.cbl:30-31`; GM-002 |
| MQ risk fallback produces score 650 / neutral outcome | **High** | `RISKFBK.cbl:10-12`; GM-009 |
| Policy-lookup DB2 failure silently applies 1,000.00 floor | **High** | `LIMITPOL.cbl:25-33` |
| Both online entry points (ATLA and ATLI) identified | **High** | `cics/transactions.yaml` |
| All batch touchpoints identified | **High** | All JCL read and analyzed |
| Interface at ATLAUTH → TRNLIM01 CALL is a candidate stable boundary | **High** | `ATLAUTH.cbl:32-33`; only `LC-FINAL-LIMIT` consumed on return |

## 12.3 Known Unknowns Carried Forward as Decision Constraints

The following 18 known unknowns are documented, do not block the exit, and must be carried forward as explicit constraints into DECIDE:

| Known Unknown | Decision Constraint |
|---|---|
| KU-01: `MQRSKGET` source absent | Any evolution of the live risk path requires obtaining this source before implementation |
| KU-02: `AUTH-REQUEST` upstream population mechanism | Scope of any input-contract change cannot be determined without API documentation |
| KU-03: `ATLI` diagnostic entry — input population unknown | `TRNLIM01` interface changes must account for this second caller |
| KU-04: Real `AUTHLOG` behavior | Changes to `AUTH-RESPONSE` fields or WRITE-AUDIT timing have unverifiable audit impact |
| KU-05/KU-06: `EXCREC01` and `ER-EXPIRY-DATE` | Exception deactivation mechanism is unknown; batch-side logic is absent |
| KU-07: DB2 multi-row `SQLCODE -811` risk | Silent data integrity risk; must be resolved before any DB2 schema change |
| KU-08: `POLREC.cpy` consumer | Unknown batch program may be affected by schema changes |
| KU-09: `AS-RISK-MODE` never set | Downstream consumers of `AUTH-RESPONSE` may be affected if this field is populated |
| KU-10: `LIMITREF.jcl` anomaly | Operational status must be confirmed |
| KU-11: VSAM record-size discrepancy | May indicate physical corruption risk; requires production validation |
| KU-12: `EXCEPT01` VSAM I/O under CICS | Runtime viability unconfirmed; compilation options absent |
| KU-13: Test file conflict (high-risk branch) | Authoritative expected behavior for risk_score ≥ 800 must be resolved before PROVE |
| KU-14–KU-18 | Individually low-to-medium risk; carried forward for DECIDE and PROVE stages |

## 12.4 What Remains Unknown vs. What Is Acceptable

| Category | Status |
|---|---|
| Core limit algorithm and all rule logic | **Fully understood** |
| Online call chain, data flow, and interface contracts | **Fully understood** |
| External system stubs (MQRSKGET, AUTHLOG, EXCREC01) | **Known unknowns — documented, bounded, and acceptable** |
| Production runtime state (DB2 rows, VSAM record size, CICS options) | **Known unknowns — documented, bounded, and acceptable** |
| Upstream input population mechanism | **Known unknown — documented, bounded, and acceptable** |
| Unresolved business policy questions (grandfathered ceiling, expiry enforcement, fallback floor) | **Known unknowns — carried forward as explicit decision constraints** |
| Test file authority (C-01) | **Conflict documented — resolution required before PROVE** |

**Sources:** [`05-playbook-gap-analysis.md §§4.2, 4.3, 4.4`](runs/atlaspay/understand/run-001/05-playbook-gap-analysis.md)

---

# 13. Evidence Provenance

All major conclusions in this evidence pack are classified by the quality of supporting evidence.

## 13.1 PROVEN — Directly observable and unambiguous from source code

| Conclusion | Supporting Artifact(s) |
|---|---|
| `LIMUTIL.cbl` is the single authoritative source for the complete limit resolution algorithm | [`LIMUTIL.cbl:12-46`](src/cobol/LIMUTIL.cbl:12) |
| The grandfathered exception override is applied before the product-max ceiling | [`LIMUTIL.cbl:30-44`](src/cobol/LIMUTIL.cbl:30) — sequential code reading |
| Risk adjustments are skipped when `LC-GRANDFATHERED = 'Y'` | [`LIMUTIL.cbl:30-40`](src/cobol/LIMUTIL.cbl:30) — IF/ELSE structure |
| MQ fallback score is exactly 650 | [`RISKFBK.cbl:10-12`](src/cobol/RISKFBK.cbl:10) |
| Policy-lookup fallback applies 1,000.00 to all three policy fields silently | [`LIMITPOL.cbl:25-33`](src/cobol/LIMITPOL.cbl:25) |
| `ER-EXPIRY-DATE` is never evaluated at authorization time | [`EXCEPT01.cbl:32`](src/cobol/EXCEPT01.cbl:32) — no reference to the field in PROCEDURE DIVISION |
| `AS-RISK-MODE` is declared but never assigned by any program | [`AUTHRESP.cpy:7`](src/copybooks/AUTHRESP.cpy:7); `grep` of workspace — no assignment found |
| `AUTHREQ.cpy` has 12 consumer programs | COPY statement search across [`src/cobol/`](src/cobol/) |
| `LIMITCTX.cpy` has 8 consumer programs | COPY statement search across [`src/cobol/`](src/cobol/) |
| `ATLAUTH` re-initializes `LIMIT-CONTEXT` and `TRNLIM01` does so again | [`ATLAUTH.cbl:15`](src/cobol/ATLAUTH.cbl:15); [`TRNLIM01.cbl:10`](src/cobol/TRNLIM01.cbl:10) |
| `MQRSKGET` source is absent from the workspace | Filesystem scan of [`src/cobol/`](src/cobol/) |
| `LIMITREF.jcl` invokes `LIMITPOL` as a standalone batch step | [`LIMITREF.jcl:2`](jcl/LIMITREF.jcl:2) — `EXEC PGM=LIMITPOL` |
| MCC caps (7995→1000, 6051→2000) are hardcoded | [`MERCHVAL.cbl:12-15`](src/cobol/MERCHVAL.cbl:12) |
| `CUSTRSK` is called unconditionally regardless of grandfathered status | [`TRNLIM01.cbl:13-16`](src/cobol/TRNLIM01.cbl:13) — EXCEPT01 called at step 2, CUSTRSK at step 5, no condition between them |
| `tests/golden-master-cases.yaml` and `tests/golden-master/cases.yaml` contradict each other on the high-risk branch | [`tests/golden-master-cases.yaml:12`](tests/golden-master-cases.yaml:12): 6000.00; [`tests/golden-master/cases.yaml:64`](tests/golden-master/cases.yaml:64): 4000.00 |

## 13.2 STRONGLY_SUPPORTED — Clearly implied by implementation with corroborating evidence

| Conclusion | Supporting Evidence | What Would Elevate to PROVEN |
|---|---|---|
| Risk score direction is intentionally counter-intuitive (higher = more restrictive) | [`mq/message-contracts.md:7`](mq/message-contracts.md:7); GM-008 description in [`tests/golden-master/cases.yaml:66-68`](tests/golden-master/cases.yaml:66) | Business specification document confirming this convention |
| Fallback score 650 is deliberately in the neutral band | [`RISKFBK.cbl:10-12`](src/cobol/RISKFBK.cbl:10); GM-009 corroboration; score 650 is 500–799 (neutral) by construction | Business specification or comment confirming fallback = neutral-outcome intent |
| The TRNLIM01 → sub-program call sequence is semantically intentional, not merely incidental | [`TRNLIM01.cbl:12-22`](src/cobol/TRNLIM01.cbl:12) — sequential; `LIMUTIL` depends on all prior outputs | Business architecture document or code comment confirming ordering intent |
| `ATLI` is a diagnostic-only transaction (not a production path) | [`cics/transactions.yaml:5-8`](cics/transactions.yaml:5) — transaction name `ATLI` and label imply diagnostic | Operational confirmation; CICS program definition |
| `POLREC.cpy` represents an absent batch policy-load program's record layout | [`POLREC.cpy`](src/copybooks/POLREC.cpy) field names compatible with `ATLAS_LIMIT_POLICY`; no consumer in workspace | Discovery of the consumer program |
| `ER-EXPIRY-DATE` expiry is intended to be managed by batch `EXCREC01` | `EXCEPTREC.cpy` declares the field; `EXCREC01` is the reconciliation program; `EXCEPT01` does not evaluate it | Real `EXCREC01` source; SME confirmation |

## 13.3 UNRESOLVED — Material uncertainty; business intent cannot be confirmed from source alone

| Conclusion | Conflicting or Insufficient Evidence | Resolution Path |
|---|---|---|
| Whether grandfathered accounts should be exempt from the product-maximum ceiling (C-02) | Code caps grandfathered limits; no business spec confirms or denies this | SME confirmation |
| Business intent of the 1,000.00 policy-lookup fallback (C-05) | Value is hardcoded; no comment or specification explains it | Business specification; SME |
| Whether `ER-EXPIRY-DATE` enforcement was omitted at runtime or delegated to batch (C-03) | Declaration implies intent; code ignores it; batch is a stub | Real `EXCREC01`; SME |
| Whether MQ timeout and error should produce different downstream behaviors (C-04) | `AS-RISK-MODE` suggests intent to differentiate; code collapses both paths | SME; real `AUTHLOG` |
| Whether risk score direction (higher = more restrictive) is intentional or inverted (C-06) | Two sources agree; one test file contradicts; no business spec | Authoritative test file; SME |
| Which golden-master test file is authoritative for the high-risk branch (KU-13) | Code (LIMUTIL ×0.80) aligns with `tests/golden-master/cases.yaml`; `tests/golden-master-cases.yaml` contradicts | Governance decision; SME |

**Sources:** [`01-broad-analysis-raw.md`](runs/atlaspay/understand/run-001/01-broad-analysis-raw.md); [`02-impact-analysis-raw.md`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md); [`03-business-rules-raw.md`](runs/atlaspay/understand/run-001/03-business-rules-raw.md); [`04-known-unknowns-raw.md`](runs/atlaspay/understand/run-001/04-known-unknowns-raw.md); [`05-playbook-gap-analysis.md`](runs/atlaspay/understand/run-001/05-playbook-gap-analysis.md)

---

*End of Current-State Evidence Pack — AtlasPay Dynamic Transaction Limit*  
*Run: `atlaspay-understand-001` · Stage: UNDERSTAND · Evidence Pack Version: 1.0*
