# Raw Bob Output — Known Unknowns Register

Run: atlaspay-understand-001
Stage: UNDERSTAND
Execution mode: PP4Z workspace
Z Understand: Not configured
Manual corrections: None

Bob analysis completed: Yes
Bob artifact write completed: No
Failure: AI_APICallError during artifact creation/finalization
Recovery method: Raw synthesized output copied from Bob task
Human consolidation or correction before freeze: None

---
Now I'll synthesize all genuine unknowns. Let me enumerate them carefully from direct evidence:

**Confirmed unknowns from source inspection:**

1. **KU-01**: `MQRSKGET` source absent — timeout interval, retry count, correlation-ID mechanism, queue manager name entirely unknown (`CUSTRSK.cbl:16`; no source in `src/cobol/`)
2. **KU-02**: `AUTH-REQUEST` population mechanism before CICS dispatch — `ATLAUTH.cbl:6` copies into WORKING-STORAGE; `ATLAS_ACCOUNT_PRODUCT` exists but no program queries it; how AR-PRODUCT-CODE, AR-JURISDICTION, AR-TEMP-CONTROL-AMT, AR-TRANSACTION-TYPE are set is unknown
3. **KU-03**: `AUTH-REQUEST` population for CICS `ATLI` direct entry — `cics/transactions.yaml:5-8`; no source shows how TRNLIM01 receives a populated LINKAGE SECTION when invoked via ATLI
4. **KU-04**: Real `AUTHLOG` I/O destination and behavior — `AUTHLOG.cbl:10` stub comment
5. **KU-05**: Real `EXCREC01` reconciliation logic — how `ER-ACTIVE` is managed/cleared — `EXCREC01.cbl:5`
6. **KU-06**: `ER-EXPIRY-DATE` enforcement intent — declared in `EXCEPTREC.cpy:4`, never evaluated in `EXCEPT01.cbl:32`; whether enforcement is batch-side (EXCREC01) or was omitted entirely is unknown
7. **KU-07**: Whether multiple active rows per `(PRODUCT_CODE, JURISDICTION)` can exist in production — `db2/schema.sql:12` PK includes EFFECTIVE_DATE; `LIMITPOL.cbl:16-23` does not filter on EFFECTIVE_DATE; SQLCODE -811 risk
8. **KU-08**: `POLREC.cpy` consumer — no `COPY POLREC` in any `src/cobol/` file; possible absent batch program consuming `ATLAS_LIMIT_POLICY` records
9. **KU-09**: `AS-RISK-MODE` semantics — `AUTHRESP.cpy:7` declares it; no assignment anywhere in workspace; likely intended to distinguish live/fallback risk mode but never implemented
10. **KU-10**: `LIMITREF.jcl` intent — `jcl/LIMITREF.jcl:2` executes `PGM=LIMITPOL`; `LIMITPOL` has only a LINKAGE SECTION entry point, no batch entry; whether a batch-capable variant exists in production load library is unknown
11. **KU-11**: VSAM record-size discrepancy — `vsam/DEFINE.jcl:6` RECORDSIZE(57 57) vs. `EXCEPTREC.cpy` computed 58 bytes
12. **KU-12**: EXCEPT01 native VSAM I/O behavior under CICS — `EXCEPT01.cbl:7-11` uses native COBOL FILE-CONTROL with no `EXEC CICS FILE CONTROL`; CICS compilation options (RENT, REUS) and whether this compiles/runs correctly are unknown
13. **KU-13**: Conflict between `tests/golden-master-cases.yaml` and `tests/golden-master/cases.yaml` for high-risk branch — `tests/golden-master-cases.yaml:12` expects 6000.00 (increase); `tests/golden-master/cases.yaml:64` expects 4000.00 (reduction); `LIMUTIL.cbl:33-34` confirms ×0.80; authoritative test file cannot be determined
14. **KU-14**: `LIMITBAT`'s `LAST_REFRESH_TS` purpose — stamped nightly (`LIMITBAT.cbl:13-14`); no program reads it; operational purpose (staleness detection, monitoring) is unknown
15. **KU-15**: `ATLAS_ACCOUNT_PRODUCT` table has no consumer in the online path — `db2/schema.sql:15-20`; no in-scope program queries it; whether account→product resolution happens upstream (API) or is entirely bypassed is unknown
16. **KU-16**: `AR-TRANSACTION-TYPE` field purpose — `AUTHREQ.cpy:5`; no in-scope program evaluates it; declared in the request structure but behaviorally inert in this workspace
17. **KU-17**: Whether `CUSTRSK` is invoked for accounts already known to be grandfathered — `TRNLIM01.cbl:16` calls CUSTRSK unconditionally before the `RISKFBK` conditional; the MQ call is made even when `LC-GRANDFATHERED='Y'` (set at line 13 via EXCEPT01); the risk score is then used in `LIMUTIL.cbl:32-40` which is inside the `ELSE` (non-grandfathered) branch — so the MQ call is wasted work, but whether this is intentional (future use) or an oversight is unknown
18. **KU-18**: `AUTHRPT` data source — `src/cobol/AUTHRPT.cbl:5` is a stub; `jcl/AUTHRPT.jcl` shows it runs daily; what data it reports on and whether it reads `AUTH-RESPONSE` data from any downstream store is unknown

Some of these overlap or can be consolidated. Let me review which are genuinely distinct and not resolvable from workspace evidence, then write the register.
