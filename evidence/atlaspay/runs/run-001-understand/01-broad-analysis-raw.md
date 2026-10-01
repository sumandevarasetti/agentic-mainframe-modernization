# Raw Bob Output — Broad UNDERSTAND Analysis

Run: atlaspay-understand-001
Stage: UNDERSTAND
Analysis: Broad capability analysis
Execution mode: PP4Z workspace
Z Understand: Not configured
Manual corrections: None

---

The analysis above is complete. Here is a summary of what was found and how it was grounded:

---

## What Was Done

Every conclusion in the analysis above cites a specific artifact and line. No claim was made without opening and reading the supporting file. The work proceeded in this order:

1. **All 15 COBOL source programs** in `src/cobol/` were read — 12 online, 3 batch stubs
2. **All 6 copybooks** in `src/copybooks/` were read, including the orphaned [`POLREC.cpy`](src/copybooks/POLREC.cpy)
3. **All 5 JCL jobs** and the VSAM DEFINE JCL were read
4. **DB2 DDL and seed data**, MQ queue/contract files, CICS transaction/program YAML, all docs and architecture files were read
5. **Z Context subagents** were spawned for CICS static-CALL behavior, DB2 `SQLCODE`/`SQLERRD(3)`/`-811` risks, and the MQ `MQRSKGET` wrapper pattern — their findings are reflected in the Known Unknowns and business-rule annotations above

## Key Findings Highlighted

- **[`LIMUTIL.cbl`](src/cobol/LIMUTIL.cbl:1) is the single authoritative source** for the complete 9-step limit resolution algorithm
- **`MQRSKGET` is a user-defined wrapper** with no source in this workspace — its timeout, retry, and correlation behavior are unverifiable (KU-01)
- **`LIMITPOL.cbl` has a latent `-811` risk**: the `SELECT INTO` queries a table whose primary key includes `EFFECTIVE_DATE` but the query does not filter on it — two active rows for the same product/jurisdiction would silently trigger a DB2 cardinality error (KU-08)
- **Grandfathered exception is overridden by product-max ceiling** (KU-12) — the business intent is ambiguous
- **`AS-RISK-MODE` in `AUTH-RESPONSE` is declared but never written** by any program (KU-09)
- **`LIMITREF.jcl` calls `LIMITPOL` as a batch step** — `LIMITPOL` is a subprogram with no batch entry point, making this JCL functionally undefined (KU-06)