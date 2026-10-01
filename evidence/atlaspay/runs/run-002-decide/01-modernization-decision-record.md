# Modernization Decision Record: AtlasPay Dynamic Transaction Limit

**Stage:** DECIDE  
**Run:** `run-002`  
**Evaluation Scope:** AtlasPay Estate — Dynamic Transaction Limit Capability  
**Decision Framework:** Agentic Strangler Framework — Modernization Decision Playbook (`framework-assets/playbooks/modernization-decision/playbook.yaml` v0.3.4)  
**Evidence Baseline:** Frozen UNDERSTAND Evidence (`runs/atlaspay/understand/run-001/`)  
**Human Decision Owner:** REQUIRED — NOT YET ASSIGNED  
**Approval Status:** PENDING HUMAN DECISION  

---

## 1. Business Objective

The business objective for this decision stage is:
> **Make the Dynamic Transaction Limit capability easier and safer to evolve while preserving existing externally observable behavior unless a business change is explicitly approved.**

Key drivers derived from the business objective and frozen evidence:
1. **Evolution Agility & Safety:** Enable future policy changes (such as merchant cap adjustments, jurisdiction updates, or tiering rules) to be implemented with minimal regression risk to core transaction processing.
2. **Behavioral Equivalence:** Preserve strict behavioral parity across all 25 recovered business rules, resolution sequences, fallback mechanisms, and boundary constraints.
3. **Decoupling:** Reduce tight structural coupling between the transaction orchestration tier and internal sub-programs, without destabilizing core online CICS SLAs.
4. **Risk-Controlled Decision Making:** Ground the disposition in verifiable evidence, carry forward all unresolved operational uncertainties, and ensure no code or architectural changes proceed without explicit human authorization.

---

## 2. Decision Context

This decision is based exclusively on the frozen evidence produced in UNDERSTAND (`runs/atlaspay/understand/run-001/01` through `06`). No source code modifications or ungrounded assumptions are introduced.

### 2.1 Capability Boundary and Flow Summary
The Dynamic Transaction Limit capability is an online limit resolution engine executed synchronously within the AtlasPay card authorization path:
- **Upstream Entry:** Initiated via Digital Authorization API into CICS transaction `ATLA` executing [`ATLAUTH.cbl:1-35`](src/cobol/ATLAUTH.cbl:1). A diagnostic CICS transaction `ATLI` also directly triggers [`TRNLIM01.cbl:1-30`](src/cobol/TRNLIM01.cbl:1) ([`cics/transactions.yaml:1-8`](cics/transactions.yaml:1)).
- **Orchestration:** `ATLAUTH` performs account validation (`ACCTVAL`) and merchant validation (`MERCHCHK`), then invokes limit orchestrator `TRNLIM01` passing `AUTH-REQUEST` ([`AUTHREQ.cpy:1-12`](src/copybooks/AUTHREQ.cpy:1)) and `AUTH-RESPONSE` ([`AUTHRESP.cpy:1-9`](src/copybooks/AUTHRESP.cpy:1)).
- **Sub-System Execution:** `TRNLIM01` initializes and populates `LIMIT-CONTEXT` ([`LIMITCTX.cpy:1-25`](src/copybooks/LIMITCTX.cpy:1)) by invoking six sub-programs in strict sequence:
  1. [`LIMITPOL.cbl:1-38`](src/cobol/LIMITPOL.cbl:1) — Queries Db2 `ATLAS_LIMIT_POLICY` table; populates base, jurisdiction, and product max limits; provides fallback floor of 1,000.00 on SQL error/not found.
  2. [`EXCEPT01.cbl:1-42`](src/cobol/EXCEPT01.cbl:1) — Reads VSAM cluster `EXCPTKS` for grandfathered account exceptions (`ER-ACTIVE = 'Y'`).
  3. [`TMPCTRL.cbl:1-18`](src/cobol/TMPCTRL.cbl:1) — Transfers `AR-TEMP-CONTROL-AMT` into `LC-TEMP-LIMIT`.
  4. [`MERCHVAL.cbl:1-26`](src/cobol/MERCHVAL.cbl:1) — Evaluates hardcoded MCC caps: MCC 7995 (1,000.00), MCC 6051 (2,000.00), default 9,999,999.99.
  5. [`CUSTRSK.cbl:1-24`](src/cobol/CUSTRSK.cbl:1) — Invokes external MQ wrapper `MQRSKGET` to retrieve real-time account risk score.
  6. [`RISKFBK.cbl:1-19`](src/cobol/RISKFBK.cbl:1) — Conditionally invoked if `LC-RISK-AVAILABLE = 'N'`; assigns deterministic fallback risk score of 650.
- **Rule Resolution:** `TRNLIM01` invokes [`LIMUTIL.cbl:1-55`](src/cobol/LIMUTIL.cbl:1) to execute the deterministic 7-step limit calculation algorithm:
  - Step 1: Base limit (`LC-BASE-LIMIT`).
  - Step 2: Jurisdiction cap (`MIN(Candidate, LC-JURIS-LIMIT)`).
  - Step 3: Merchant category cap (`MIN(Candidate, LC-MCC-LIMIT)`).
  - Step 4: Temporary customer control (`MIN(Candidate, LC-TEMP-LIMIT)`).
  - Step 5: Grandfathered override (if `LC-GRANDFATHERED = 'Y'`, replace candidate entirely with `LC-EXCEPTION-LIMIT`).
  - Step 6: Risk adjustments (if non-grandfathered: Score ≥ 800 → ×0.80; Score < 500 → ×0.70; 500–799 → unchanged).
  - Step 7: Product maximum ceiling cap (`MIN(Candidate, LC-PRODUCT-MAX)`).
- **Decision & Audit:** `ATLAUTH` compares `AR-TRANSACTION-AMT` against `AS-RESOLVED-LIMIT` (Set `AS-AUTH-DECISION` = `APPROVED` or `DECLINED`), then executes [`AUTHLOG.cbl:1-14`](src/cobol/AUTHLOG.cbl:1) for compliance logging.

### 2.2 Key Architecture and Coupling Characteristics
- **Shared Mutable State:** All seven limit sub-programs share and mutate a single 25-line data structure ([`LIMITCTX.cpy`](src/copybooks/LIMITCTX.cpy:1)).
- **Multi-Resource Data Tier:** The capability couples across Db2 (SQL query), VSAM (keyed direct read), and IBM MQ (asynchronous request/reply via wrapper).
- **Batch Touchpoints:** Nightly batch processing exists via `LIMITBAT.cbl` (refreshes cache timestamp), `EXCREC01.cbl` (VSAM reconciliation), and `AUTHRPT.cbl` (audit reporting) ([`02-impact-analysis-raw.md:382-393`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md:382)).

---

## 3. Options Considered

Every modernization disposition defined in the framework playbook is systematically evaluated against the 10 mandatory dimensions using frozen UNDERSTAND evidence.

### 3.1 Disposition: KEEP

#### 1. Business Rationale
Preserves the current production mainframe implementation without change. Eliminates all near-term execution costs and transformation risks. Meets the requirement of zero regression risk for existing transaction traffic.

#### 2. Technical Rationale
The current COBOL implementation is fully functional, highly optimized for CICS transaction processing, exhibits low internal complexity (cyclomatic scores ≤ 6 across all programs), and executes deterministically across all paths.

#### 3. Evidence from Frozen UNDERSTAND Pack
- **Supporting:** All 25 business rules are cataloged and proven in source code ([`03-business-rules-raw.md:31-632`](runs/atlaspay/understand/run-001/03-business-rules-raw.md:31)). The codebase is compact (15 programs, ~450 total LOC). Static calls execute with minimal latency.
- **Weakening:** Hardcoded MCC rules in [`MERCHVAL.cbl:14-22`](src/cobol/MERCHVAL.cbl:14) require COBOL recompilation and CICS newcopy for any commercial MCC policy change. `LIMITCTX.cpy` remains a shared mutable state bottleneck.

#### 4. Coupling Analysis
- **Reduced:** None.
- **Retained:** Retains tight shared mutable memory coupling via `LIMITCTX.cpy`, direct CICS execution coupling, and multi-resource coupling (Db2, VSAM, MQ).
- **Introduced:** None.

#### 5. Behavioral Risk
Zero behavioral risk of transformation regression. However, latent code anomalies remain active (e.g., `LIMITPOL` multi-row -811 risk under non-unique effective dates, `EXCEPT01` expiry date non-enforcement).

#### 6. Data and Transaction Coupling Risk
Retains synchronous Db2, VSAM, and MQ calls within the CICS transaction execution thread, leaving online response time vulnerable to downstream resource latency.

#### 7. Operational and Integration Risk
Zero migration or cutover risk. Maintenance remains tied to mainframe developer availability and traditional z/OS batch/online deployment cycles.

#### 8. Known Unknowns Constraining the Option
Constrained by KU-01 (unverified `MQRSKGET` internals), KU-06 (unclear expiry date business intent), KU-07 (Db2 effective date schema vs query), and KU-12 (native VSAM I/O compilation under CICS).

#### 9. Assumptions Separately Stated
- *Assumption:* CICS transaction processing capacity and mainframe developer staffing remain adequate for business needs.
- *Assumption:* Frequency of merchant category code and limit policy changes remains low.

#### 10. Proof Obligations if Selected
- Must monitor Db2 `ATLAS_LIMIT_POLICY` table maintenance to ensure duplicate effective dates do not trigger SQLCODE -811.
- Must verify VSAM `EXCPTKS` file stability and maintenance via `EXCRECON.jcl`.

---

### 3.2 Disposition: REFACTOR

#### 1. Business Rationale
Makes the Dynamic Transaction Limit capability significantly easier and safer to evolve while keeping execution natively on z/OS. Allows externalizing hardcoded rules (e.g., MCC limits) and cleaning up architectural anomalies without changing runtime platforms or introducing cross-platform network latency.

#### 2. Technical Rationale
Refactors internal COBOL program boundaries and data flows:
- Encapsulates `LIMITCTX.cpy` mutations behind clean parameter interfaces or modular subprograms.
- Moves hardcoded merchant category rules in `MERCHVAL.cbl` into Db2 policy tables (`ATLAS_LIMIT_POLICY`) or a centralized configuration table.
- Rectifies technical debt: corrects VSAM record-length discrepancies (KU-11), aligns CICS VSAM access standards (KU-12), and fixes batch invocation anomalies (`LIMITREF.jcl`, KU-10).

#### 3. Evidence from Frozen UNDERSTAND Pack
- **Supporting:** The sub-system has clean modular separation with a clear 7-step calculation in `LIMUTIL.cbl` ([`03-business-rules-raw.md:424-452`](runs/atlaspay/understand/run-001/03-business-rules-raw.md:424)). Programs are small and cohesive.
- **Weakening:** Requires modifying COBOL source code and recompiling core programs, introducing potential regression risks that must be validated with characterization suites.

#### 4. Coupling Analysis
- **Reduced:** Reduces copybook fan-out blast radius (`LIMITCTX.cpy`), eliminates hardcoded business constants from logic programs.
- **Retained:** Retains CICS runtime coupling, Db2 table schemas, VSAM cluster dependencies, and MQ integration points.
- **Introduced:** Minor intra-module parameter linkage changes.

#### 5. Behavioral Risk
Low-to-moderate risk during refactoring of parameter passing and SQL queries. Risk is strictly bounded because execution remains on the z/OS compiler and runtime environment.

#### 6. Data and Transaction Coupling Risk
Maintains existing transaction boundaries and two-phase commit / CICS syncpoint semantics. Does not introduce distributed transaction or eventual consistency complexities.

#### 7. Operational and Integration Risk
Low operational risk. Uses established z/OS promotion, load module packaging, and CICS phased cutover procedures.

#### 8. Known Unknowns Constraining the Option
Constrained by KU-06 (clarifying whether expiry date should be evaluated in online COBOL), KU-07 (Db2 multi-row query behavior), and KU-13 (golden master assertion discrepancies).

#### 9. Assumptions Separately Stated
- *Assumption:* Business stakeholders desire MCC caps to be dynamic/table-driven rather than hardcoded.
- *Assumption:* Characterization test harness can be established to validate refactored COBOL modules.

#### 10. Proof Obligations if Selected
- Must prove 100% behavioral equivalence across all 25 business rules using Golden Master characterization test suites.
- Must prove that refactored VSAM and Db2 access obeys CICS thread-safety and concurrency standards.

---

### 3.3 Disposition: EXPOSE

#### 1. Business Rationale
Allows distributed channels, digital platforms, and cloud applications to invoke the mainframe limit engine via modern standardized APIs (REST/JSON or gRPC), expanding capability reuse across the enterprise without altering core calculation logic.

#### 2. Technical Rationale
Wraps CICS transaction `ATLA` or subprogram `TRNLIM01` via z/OS Connect Enterprise Edition, CICS Web Services, or an API gateway. Translates JSON payloads into `AUTH-REQUEST` / `LIMIT-CONTEXT` copybook binary layouts.

#### 3. Evidence from Frozen UNDERSTAND Pack
- **Supporting:** `ATLAUTH` already acts as a service wrapper receiving a structured `AUTH-REQUEST` copybook ([`02-impact-analysis-raw.md:188-198`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md:188)). The boundary between authorization orchestration and limit calculation is clearly delineated at `I-2` ([`ATLAUTH.cbl:22`](src/cobol/ATLAUTH.cbl:22)).
- **Weakening:** EXPOSE alone does not address internal maintainability issues (hardcoded MCC caps in `MERCHVAL`, shared mutable state in `LIMITCTX`, or Db2 SQL query fragility).

#### 4. Coupling Analysis
- **Reduced:** Decouples external API consumers from binary COBOL copybook layouts and mainframe-specific EBCDIC protocols.
- **Retained:** Retains all internal mainframe coupling, `LIMITCTX.cpy` mutable memory sharing, and underlying Db2/VSAM/MQ dependencies.
- **Introduced:** Introduces API gateway / z/OS Connect runtime dependency and payload transformation overhead.

#### 5. Behavioral Risk
Very low behavioral risk for core logic. Risk is isolated to API data serialization, binary/ASCII conversion, and numeric precision mapping (e.g., `PIC 9(7)V99`).

#### 6. Data and Transaction Coupling Risk
Maintains mainframe transactional consistency. Introduces API connection timeouts and connection pool management overhead under high transaction volumes.

#### 7. Operational and Integration Risk
Low-to-moderate. Requires operational management of API gateway / z/OS Connect artifacts, TLS endpoints, and API security tokens.

#### 8. Known Unknowns Constraining the Option
Constrained by KU-02 (understanding how `AUTH-REQUEST` fields are mapped before CICS invocation) and KU-09 (`AS-RISK-MODE` unassigned response field handling).

#### 9. Assumptions Separately Stated
- *Assumption:* External consumers require API-level access to the limit calculation independently of the full authorization path.
- *Assumption:* z/OS Connect or equivalent API infrastructure is available in the target infrastructure.

#### 10. Proof Obligations if Selected
- Must prove data type fidelity between JSON numbers and COBOL COMP-3 / zoned decimal fields.
- Must prove API gateway throughput meets peak authorization SLA requirements (< 50ms latency).

---

### 3.4 Disposition: EXTRACT

#### 1. Business Rationale
Isolates the Dynamic Transaction Limit calculation from card authorization orchestration (`ATLAUTH`), allowing the limit calculation engine to be deployed as an independent callable service (either in CICS or standalone), accelerating release cadences for policy and limit rules.

#### 2. Technical Rationale
Carves out `TRNLIM01`, its six sub-programs, and `LIMUTIL` from `ATLAUTH`. Defines a formal contract over `AUTH-REQUEST` (or a dedicated limit request DTO) and `LIMIT-CONTEXT`/`AUTH-RESPONSE`, removing `ATLAUTH`'s direct orchestration entanglement.

#### 3. Evidence from Frozen UNDERSTAND Pack
- **Supporting:** `TRNLIM01` already exhibits high cohesion as a dedicated limit orchestrator ([`02-impact-analysis-raw.md:238-248`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md:238)). Interface `I-2` is a clean `CALL 'TRNLIM01' USING WS-AUTH-REQUEST WS-AUTH-RESPONSE`. Diagnostic entry `ATLI` proves `TRNLIM01` can run independently ([`cics/transactions.yaml:5-8`](cics/transactions.yaml:5)).
- **Weakening:** EXTRACT requires managing data dependencies across disparate datastores (Db2, VSAM, MQ) if extracted outside of the shared CICS environment.

#### 4. Coupling Analysis
- **Reduced:** Decouples pre-authorization guards (`ACCTVAL`, `MERCHCHK`) and post-decision audit (`AUTHLOG`) from limit policy evaluation.
- **Retained:** Retains internal sub-program coupling to `LIMITCTX.cpy` unless combined with REFACTOR.
- **Introduced:** Introduces an inter-service communication boundary between `ATLAUTH` and the extracted limit component.

#### 5. Behavioral Risk
Low-to-moderate. Behavioral logic within `LIMUTIL` remains intact; risk is restricted to boundary contract parameter marshaling.

#### 6. Data and Transaction Coupling Risk
If extracted within z/OS/CICS, data coupling is unchanged. If extracted to an external runtime, data access to Db2 `ATLAS_LIMIT_POLICY` and VSAM `EXCPTKS` must be bridged or migrated.

#### 7. Operational and Integration Risk
Moderate. Involves deploying and monitoring a discrete service component and managing versioned interface contracts.

#### 8. Known Unknowns Constraining the Option
Constrained by KU-03 (`ATLI` linkage population), KU-15 (lack of `ATLAS_ACCOUNT_PRODUCT` usage in online path), and KU-17 (unconditional MQ risk call for grandfathered accounts).

#### 9. Assumptions Separately Stated
- *Assumption:* The organization intends to reuse the Dynamic Transaction Limit engine across other authorization or banking channels.

#### 10. Proof Obligations if Selected
- Must prove interface contract robustness under all error conditions (Db2 unavailable, VSAM locked, MQ timeout).
- Must prove end-to-end latency does not degrade authorization throughput.

---

### 3.5 Disposition: TRANSFORM

#### 1. Business Rationale
Re-implements the Dynamic Transaction Limit logic into a modern language/framework (e.g., Java, Go, Python microservice or cloud-native serverless engine), enabling modern CI/CD practices, cloud scalability, and integration with modern enterprise rule engines.

#### 2. Technical Rationale
Re-writes the 25 business rules and 7-step resolution algorithm into a target object-oriented or functional paradigm. Migrates or bridges data stores (Db2 SQL → modern SQL/NoSQL, VSAM → distributed key-value store, MQ → modern event bus/gRPC).

#### 3. Evidence from Frozen UNDERSTAND Pack
- **Supporting:** Business logic is mathematically well-defined and compact (25 rules cataloged in `03-business-rules-raw.md`). The 7-step algorithm in `LIMUTIL` has zero external I/O dependencies.
- **Weakening:** The capability is heavily entwined with heterogeneous mainframe data sources: Db2 (`LIMITPOL`), native VSAM (`EXCEPT01`), and asynchronous MQ (`CUSTRSK`/`MQRSKGET`). Transforming the capability off-mainframe requires dual-writes or distributed data synchronization with batch jobs (`EXCREC01`, `LIMITBAT`, `AUTHRPT`).

#### 4. Coupling Analysis
- **Reduced:** Completely eliminates COBOL copybook dependencies, mainframe compiler locks, and legacy shared memory structures.
- **Retained:** Retains logical data entity relationships (Product, Jurisdiction, Grandfathered Exception, Risk Score).
- **Introduced:** Introduces distributed network latency into the real-time authorization path, distributed transaction/consistency management, and hybrid cloud-to-mainframe integration links.

#### 5. Behavioral Risk
High. Substantial risk of subtle algorithmic divergence (numeric rounding, decimal precision in COBOL `COMP-3`, order-of-operation nuances, SQL query semantics, and edge-case exception handling).

#### 6. Data and Transaction Coupling Risk
High. Decoupling the online limit check from mainframe VSAM and Db2 creates data replication lags and eventual consistency risks across online CICS authorization and nightly batch jobs (`EXCRECON.jcl`, `LIMITREF.jcl`).

#### 7. Operational and Integration Risk
High. Requires introducing new runtime environments, distributed monitoring, cross-platform security, dual-run testing frameworks, and complex rollback mechanisms.

#### 8. Known Unknowns Constraining the Option
Severely constrained by KU-01 (`MQRSKGET` missing source/timeouts), KU-04 (`AUTHLOG` real sink), KU-05/06 (VSAM reconciliation and expiry date semantics), and KU-13 (test assertion discrepancies).

#### 9. Assumptions Separately Stated
- *Assumption:* A target cloud or distributed runtime platform is established and capable of meeting sub-50ms authorization SLAs.
- *Assumption:* Enterprise data architecture supports migrating or replicating VSAM and Db2 data stores.

#### 10. Proof Obligations if Selected
- Must execute automated bit-for-bit / penny-for-penny parallel run characterization across millions of synthetic and production transactions.
- Must prove zero latency regression in the mission-critical authorization critical path.

---

### 3.6 Disposition: REPLATFORM

#### 1. Business Rationale
Migrates the existing COBOL code, Db2 tables, and VSAM files to an alternative mainframe emulator, containerized COBOL runtime, or cloud-hosted mainframe environment (e.g., AWS Mainframe Modernization, Micro Focus Enterprise Server) to reduce hardware/MIPS licensing costs.

#### 2. Technical Rationale
Recompiles the 15 COBOL programs and executes them within an emulated CICS/Db2/VSAM/MQ runtime on Linux/x86 or cloud infrastructure without altering underlying program logic.

#### 3. Evidence from Frozen UNDERSTAND Pack
- **Supporting:** The application uses standard COBOL constructs, standard SQL, and standard VSAM KSDS files.
- **Weakening:** Replatforming does nothing to achieve the primary business objective: making the capability easier and safer to evolve. Technical debt (hardcoded MCCs in `MERCHVAL`, shared `LIMITCTX.cpy`, missing expiry date logic) is preserved verbatim on a new infrastructure.

#### 4. Coupling Analysis
- **Reduced:** May reduce MIPS/hardware coupling.
- **Retained:** Retains all application-level coupling, shared mutable memory structures, batch JCL dependencies, and copybook blast radius.
- **Introduced:** Introduces emulator runtime dependencies, platform middleware bridge configurations, and external MQ/Db2 connection layers.

#### 5. Behavioral Risk
Moderate. Potential compiler differences in COBOL arithmetic, file locking semantics on emulated VSAM, and CICS emulator API compatibility (especially around native VSAM I/O in `EXCEPT01`, KU-12).

#### 6. Data and Transaction Coupling Risk
Requires full migration of Db2 tables, VSAM datasets, and batch JCL streams to the replatformed target.

#### 7. Operational and Integration Risk
High infrastructure and migration effort with zero functional improvement to business agility.

#### 8. Known Unknowns Constraining the Option
Constrained by KU-01 (`MQRSKGET` platform portability), KU-10 (`LIMITREF.jcl` execution of non-batch program), and KU-12 (native VSAM I/O compatibility under emulated CICS).

#### 9. Assumptions Separately Stated
- *Assumption:* Target platform provides complete CICS, Db2, VSAM, and MQ emulation fidelity.
- *Assumption:* Infrastructure cost reduction is a primary driver (contrary to stated business objective).

#### 10. Proof Obligations if Selected
- Must prove 100% execution parity across online transactions and all 5 batch JCL jobs.
- Must prove performance and recovery characteristics match z/OS SLAs.

---

### 3.7 Disposition: RETIRE

#### 1. Business Rationale
Decommissions the Dynamic Transaction Limit capability and removes all associated code and data stores if the capability is obsolete, redundant, or replaced by an existing global corporate solution.

#### 2. Technical Rationale
Removes `TRNLIM01` and its sub-programs, cleans up CICS transaction definitions (`ATLA`, `ATLI`), drops Db2 tables (`ATLAS_LIMIT_POLICY`, `ATLAS_ACCOUNT_PRODUCT`), and deletes VSAM datasets (`EXCPTKS`).

#### 3. Evidence from Frozen UNDERSTAND Pack
- **Supporting:** None.
- **Weakening:** `ATLAUTH.cbl:22` strictly requires `TRNLIM01` to establish `AS-RESOLVED-LIMIT` and make the authorization decision (`APPROVED` vs `DECLINED`) ([`03-business-rules-raw.md:508-549`](runs/atlaspay/understand/run-001/03-business-rules-raw.md:508)). Removing this capability would collapse core transaction processing across the entire card portfolio.

#### 4. Coupling Analysis
- **Reduced:** Eliminates all associated components and dependencies.
- **Retained:** None.
- **Introduced:** None.

#### 5. Behavioral Risk
Catastrophic. Authorization processing would cease or require an immediate replacement engine.

#### 6. Data and Transaction Coupling Risk
Total disruption to upstream digital authorization API and downstream compliance/audit logging.

#### 7. Operational and Integration Risk
Extreme. Infeasible without a fully operational, pre-validated replacement limit engine.

#### 8. Known Unknowns Constraining the Option
Not applicable; option is invalidated by foundational functional necessity.

#### 9. Assumptions Separately Stated
- *Assumption:* None. Proven to be an active, critical core capability.

#### 10. Proof Obligations if Selected
- Must prove that an alternative production system exists that fulfills all 25 cataloged business rules prior to decommissioning.

---

## 4. Comparative Decision Matrix

The following matrix synthesizes the evaluation of all seven options against the mandatory decision dimensions. No arbitrary numeric scores are applied; evaluations are strictly qualitative and evidence-grounded.

| Decision Dimension | KEEP | REFACTOR | EXPOSE | EXTRACT | TRANSFORM | REPLATFORM | RETIRE |
|---|---|---|---|---|---|---|---|
| **Business Value** | Baseline; zero evolution agility; high risk for future policy changes | **High**; unlocks dynamic limit policy evolution & eliminates code debt | Moderate; enables external API reuse without solving evolution friction | Moderate-High; enables independent limit service evolution | High; full modern cloud agility, but offset by high transformation cost/risk | Low; purely infrastructure cost play; zero agility gain | Negative; destroys critical core authorization function |
| **Coupling Reduction** | None; preserves shared `LIMITCTX` and tight copybook fan-out | **High**; encapsulates shared mutable state & externalizes hardcoded MCCs | Low; wraps CICS entry but leaves internal coupling intact | Moderate; decouples orchestrator from calculation engine | **High**; completely decouples from mainframe artifacts | Low; retains all internal application coupling | Total elimination (inapplicable) |
| **Change Surface** | None (0 lines modified) | **Low-Medium**; bounded to `src/cobol/` limit sub-programs & Db2 policy | Low; bounded to z/OS Connect / API gateway configuration | Medium; bounded to `ATLAUTH` / `TRNLIM01` interface & extraction | **High**; full rewrite across 15 programs, Db2, VSAM, MQ, & batch | High; platform migration across all programs, JCL, and datasets | Destructive across all 15 programs & datastores |
| **Behavioral Risk** | None | **Low**; execution remains on z/OS runtime; validated via Golden Master | Very Low; logic unchanged, only interface marshaling | Low-Medium; boundary contract changes | **High**; numeric precision, rounding, & algorithm translation divergence | Moderate; compiler & emulator runtime behavioral differences | Critical / Catastrophic; terminates capability |
| **Data/Transaction Coupling** | Retains multi-resource sync coupling (Db2, VSAM, MQ) | Retains mainframe sync coupling; cleans up SQL/VSAM anomalies | Retains mainframe sync coupling | Retains sync coupling within CICS | **High**; distributed data consistency, latency, & dual-write risks | Retains data coupling in emulated environment | Drops all data stores |
| **Operational Risk** | Zero | **Low**; standard z/OS compile, bind, and CICS newcopy procedures | Low; standard API gateway monitoring | Moderate; new service lifecycle management | **High**; hybrid cloud monitoring, network reliability, distributed failure modes | High; emulator infrastructure stability & migration cutover | Catastrophic |
| **Testability & Provability** | Fully provable against existing baseline | **High**; direct deterministic comparison using Golden Master suites | High; API input/output payload verification | High; component-level contract testing | Moderate-Low; requires complex dual-run parallel testing | Moderate; requires full estate regression testing | N/A |
| **Reversibility** | Immediate / N/A | **High**; standard load module rollback in CICS | High; disable API route or revert wrapper | Moderate-High; rollback to monolithic CICS call | Low; complex dual-write and data synchronization rollbacks | Moderate-Low; platform rollback is complex | Irreversible once decommissioned |
| **Impact of Unresolved Unknowns** | Low (current behavior continues as-is) | **Low-Medium**; KU-06, KU-07, and KU-13 must be resolved during PLAN | Low; KU-02 and KU-09 must be mapped | Moderate; KU-01, KU-03, and KU-17 must be addressed | **Critical**; KU-01, KU-04, KU-05, KU-06, KU-15 heavily block rewrite | High; KU-01, KU-10, KU-12 block emulator compatibility | N/A |
| **Relative Implementation Complexity** | None | **Low-Medium** (compact codebase: ~450 LOC across 7 subprograms) | Low | Medium | **High** (distributed data, hybrid networking, dual-run) | High (platform-wide infrastructure migration) | Extreme |

---

## 5. Proposed Disposition

### Advisory Recommendation: Bounded Combination of REFACTOR and EXTRACT (on z/OS)

Based strictly on the evidence and the stated business objective (*"Make the Dynamic Transaction Limit capability easier and safer to evolve while preserving existing externally observable behavior"*), the recommended disposition is a **bounded, progressive modernization strategy**:

1. **Primary Phase: REFACTOR (In-Place on z/OS)**
   - Encapsulate the shared mutable state in [`LIMITCTX.cpy`](src/copybooks/LIMITCTX.cpy:1) behind explicit parameter linkages.
   - Externalize hardcoded merchant category rules from [`MERCHVAL.cbl:14-22`](src/cobol/MERCHVAL.cbl:14) into dynamic configuration / Db2 policy tables.
   - Rectify latent technical debt: clean up Db2 SQL query effective date semantics (`LIMITPOL.cbl`), reconcile VSAM record size definitions (`vsam/DEFINE.jcl` vs `EXCEPTREC.cpy`), and resolve batch JCL invocation anomalies (`LIMITREF.jcl`).
2. **Secondary Phase: EXTRACT (Modular Boundary Definition)**
   - Formally isolate `TRNLIM01` and its calculation sub-system as a standalone, modular internal service with an explicit, versioned parameter contract.
   - Preserve native execution within CICS / z/OS to maintain sub-millisecond transaction performance and avoid distributed consistency overhead.

### Justification
- **Directly Solves the Business Problem:** Removes hardcoded constraints and eliminates fragile shared mutable memory, allowing future policy rules to evolve rapidly without high regression risk.
- **Minimizes Operational and Behavioral Risk:** Execution remains on the proven z/OS runtime, avoiding network latency spikes, distributed data dual-writes, and numeric conversion discrepancies.
- **High Testability and Reversibility:** Can be proven 100% equivalent using characterization test cases and rolled back via standard CICS load module management.
- **Preserves Future Optionality:** Once refactored and extracted into a clean modular service, the capability can easily be exposed via modern APIs (EXPOSE) or transformed to cloud-native microservices (TRANSFORM) in a subsequent lifecycle stage with drastically reduced risk.

*Note: This proposal is purely advisory. No implementation planning or code transformation may proceed without formal human approval.*

---

## 6. Rejected Alternatives

The following alternatives are weaker for this capability based on the frozen evidence:

1. **KEEP (Rejected as Sole Strategy):**
   - *Why Weaker:* Retaining the system in its exact current state fails the primary business objective. Hardcoded business rules in `MERCHVAL.cbl` and shared mutable memory in `LIMITCTX.cpy` continue to make rule changes risky, slow, and expensive.
2. **TRANSFORM (Full Rewrite / Cloud Migration - Rejected for Current Stage):**
   - *Why Weaker:* Premature. The capability depends on multi-resource data access (Db2, VSAM, MQ) tightly coupled with nightly batch reconciliation (`EXCRECON.jcl`, `LIMITREF.jcl`). Moving execution off-mainframe introduces severe distributed consistency risks, network latency in the sub-50ms authorization path, and high exposure to critical unresolved unknowns (KU-01, KU-04, KU-05, KU-06).
3. **REPLATFORM (Lift-and-Shift to Emulator - Rejected):**
   - *Why Weaker:* Incurs massive infrastructure and migration costs while delivering zero improvement to business agility or code maintainability. Hardcoded logic and technical debt would simply run on a different operating system.
4. **EXPOSE (API Wrapping Alone - Rejected as Primary Solution):**
   - *Why Weaker:* Wrapping the existing CICS transaction in an API gateway provides external access but fails to solve internal maintainability friction or rule evolution risks.
5. **RETIRE (Decommissioning - Rejected):**
   - *Why Weaker:* Functionally impossible. The limit calculation is an active, mandatory component of the core card authorization pipeline.

---

## 7. Decision Constraints

Any future plan (in PLAN, TRANSFORM, or PROVE) must strictly obey the following constraints:

1. **Read-Only Baseline:** No source code in `src/`, `jcl/`, `db2/`, `vsam/`, `mq/`, or `cics/` may be altered without progressing through a formally approved PLAN stage.
2. **Behavioral Invariance:** The 7-step limit calculation sequence defined in [`LIMUTIL.cbl:10-47`](src/cobol/LIMUTIL.cbl:10) and all 25 business rules cataloged in [`03-business-rules-raw.md`](runs/atlaspay/understand/run-001/03-business-rules-raw.md) must be preserved exactly unless an explicit business policy change is approved by human stakeholders.
3. **SLA & Latency Boundary:** Modernization must not degrade online CICS authorization response time or introduce unmanaged network latency into the real-time path.
4. **Batch Co-existence:** Any data structure or database modifications must maintain backward compatibility with nightly batch reconciliation jobs (`EXCREC01`, `LIMITBAT`, `AUTHRPT`).
5. **No Speculative Target Selection:** Target implementation languages, frameworks, or cloud platforms must not be pre-selected during DECIDE.

---

## 8. Known Unknowns Carried Forward

All 18 genuine known unknowns identified and verified in UNDERSTAND (`runs/atlaspay/understand/run-001/04-known-unknowns-raw.md`) are carried forward as active constraints. None are silently closed.

| Unknown ID | Description | Source Traceability | Impact on Future Stages |
|---|---|---|---|
| **KU-01** | `MQRSKGET` source code absent; queue manager, timeout, and retry parameters unknown | [`CUSTRSK.cbl:16`](src/cobol/CUSTRSK.cbl:16) | Constrains MQ integration and fallback testing in PROVE. |
| **KU-02** | Upstream mechanism for populating `AUTH-REQUEST` prior to CICS dispatch unknown | [`ATLAUTH.cbl:6`](src/cobol/ATLAUTH.cbl:6), [`AUTHREQ.cpy:1-12`](src/copybooks/AUTHREQ.cpy:1) | Requires interface mapping validation during PLAN. |
| **KU-03** | `AUTH-REQUEST` linkage population mechanism for direct CICS `ATLI` diagnostic entry unknown | [`cics/transactions.yaml:5-8`](cics/transactions.yaml:5), [`TRNLIM01.cbl:1-30`](src/cobol/TRNLIM01.cbl:1) | Diagnostic entry behavior must be clarified before modifying `TRNLIM01`. |
| **KU-04** | Real `AUTHLOG` physical I/O destination and compliance storage mechanism unknown | [`AUTHLOG.cbl:10`](src/cobol/AUTHLOG.cbl:10) | Audit logging destination must be verified with operations. |
| **KU-05** | Real `EXCREC01` reconciliation logic and `ER-ACTIVE` flag lifecycle management unknown | [`EXCREC01.cbl:5`](src/cobol/EXCREC01.cbl:5), [`jcl/EXCRECON.jcl:1-5`](jcl/EXCRECON.jcl:1) | Batch exception lifecycle must be confirmed before altering VSAM handling. |
| **KU-06** | Policy intent regarding `ER-EXPIRY-DATE` evaluation (ignored in online `EXCEPT01`) | [`EXCEPTREC.cpy:4`](src/copybooks/EXCEPTREC.cpy:4), [`EXCEPT01.cbl:32`](src/cobol/EXCEPT01.cbl:32) | Business SME must confirm if expiry enforcement belongs online or batch. |
| **KU-07** | Risk of `SQLCODE -811` if multiple effective date rows exist in `ATLAS_LIMIT_POLICY` | [`db2/schema.sql:12`](db2/schema.sql:12), [`LIMITPOL.cbl:16-23`](src/cobol/LIMITPOL.cbl:16) | Db2 query must be refined during refactoring to handle effective dates. |
| **KU-08** | Orphaned copybook `POLREC.cpy` consumer identification | [`src/copybooks/POLREC.cpy:1-10`](src/copybooks/POLREC.cpy:1) | Confirm whether copybook is dead code or used in unreferenced batch jobs. |
| **KU-09** | Semantics and intended consumer of unassigned `AS-RISK-MODE` field in `AUTH-RESPONSE` | [`AUTHRESP.cpy:7`](src/copybooks/AUTHRESP.cpy:7) | Clarify whether external consumers expect `AS-RISK-MODE` to be populated. |
| **KU-10** | `LIMITREF.jcl` executing subprogram `LIMITPOL` without batch entry point | [`jcl/LIMITREF.jcl:2`](jcl/LIMITREF.jcl:2), [`LIMITPOL.cbl:1-38`](src/cobol/LIMITPOL.cbl:1) | Operational execution of `LIMITREF.jcl` must be clarified. |
| **KU-11** | VSAM record size discrepancy: 57 bytes in JCL definition vs 58 bytes in copybook | [`vsam/DEFINE.jcl:6`](vsam/DEFINE.jcl:6), [`EXCEPTREC.cpy:1-7`](src/copybooks/EXCEPTREC.cpy:1) | VSAM cluster definition must be aligned before data refactoring. |
| **KU-12** | Native COBOL VSAM I/O compilation and runtime behavior under CICS in `EXCEPT01` | [`EXCEPT01.cbl:7-11`](src/cobol/EXCEPT01.cbl:7) | Verify CICS runtime environment options (RENT, REUS, CICS File Control). |
| **KU-13** | Test assertion discrepancy between Golden Master test suites for high-risk accounts | [`tests/golden-master-cases.yaml:12`](tests/golden-master-cases.yaml:12), [`tests/golden-master/cases.yaml:64`](tests/golden-master/cases.yaml:64) | Must be formally reconciled in PLAN/PROVE against source code (`LIMUTIL.cbl:33`). |
| **KU-14** | Operational purpose and consumers of `LAST_REFRESH_TS` updated by `LIMITBAT` | [`LIMITBAT.cbl:13-14`](src/cobol/LIMITBAT.cbl:13) | Confirm if monitoring tools inspect `LAST_REFRESH_TS`. |
| **KU-15** | Absence of online consumers for `ATLAS_ACCOUNT_PRODUCT` table in workspace | [`db2/schema.sql:15-20`](db2/schema.sql:15) | Determine if account-to-product resolution is handled upstream by API layer. |
| **KU-16** | Functional purpose of unreferenced `AR-TRANSACTION-TYPE` request field | [`AUTHREQ.cpy:5`](src/copybooks/AUTHREQ.cpy:5) | Verify if transaction type will drive future limit rules. |
| **KU-17** | Unconditional invocation of `CUSTRSK` for grandfathered accounts | [`TRNLIM01.cbl:13-16`](src/cobol/TRNLIM01.cbl:13), [`LIMUTIL.cbl:32-40`](src/cobol/LIMUTIL.cbl:32) | Optimize call sequence during refactoring if MQ call is confirmed redundant. |
| **KU-18** | Downstream data source and reporting logic for stubbed `AUTHRPT` | [`AUTHRPT.cbl:5`](src/cobol/AUTHRPT.cbl:5), [`jcl/AUTHRPT.jcl:1-5`](jcl/AUTHRPT.jcl:1) | Verify reporting requirements for audit compliance. |

---

## 9. Proof Obligations

Before any transformed or refactored component is deployed to production, the following proof obligations must be satisfied in PLAN, TRANSFORM, and PROVE:

1. **Golden Master Parity (Characterization Suite):**
   - Execute test characterization across all 25 business rules and edge cases.
   - Reconcile test assertion discrepancy KU-13: verify that high-risk accounts (Risk Score ≥ 800) receive the 20% limit reduction mandated by [`LIMUTIL.cbl:33-34`](src/cobol/LIMUTIL.cbl:33).
2. **Deterministic Fallback Verification:**
   - Prove that when MQ risk services timeout or fail, the system reliably assigns the 650 fallback score via `RISKFBK.cbl` and produces the exact limit result required by BR-16.
   - Prove that when Db2 policy lookup fails, the 1,000.00 floor limit is applied without abending.
3. **Data Integrity & Schema Concurrency:**
   - Prove that refactored Db2 SQL queries correctly filter effective dates, preventing SQLCODE -811 errors.
   - Prove that VSAM file operations in `EXCEPT01` obey CICS concurrency and thread-safety rules without record lock contention.
4. **Performance & Non-Functional SLAs:**
   - Prove that end-to-end limit resolution executes within established sub-millisecond CICS transaction budget.

---

## 10. Unresolved Questions

The following questions materially affect implementation choices in subsequent stages and require human SME guidance:

1. **Business Policy on Expiration Dates (KU-06):**
   - *Question:* Should `EXCEPT01.cbl` actively check `ER-EXPIRY-DATE` against current date during online authorization, or is expiration strictly managed by the nightly batch job `EXCREC01`?
2. **Dynamic Merchant Category Policy (BR-10, BR-11):**
   - *Question:* Should merchant category limit caps (MCC 7995, MCC 6051) be moved into the Db2 `ATLAS_LIMIT_POLICY` table to allow business operations to modify caps without code deployments?
3. **Redundant Risk MQ Calls for Grandfathered Accounts (KU-17):**
   - *Question:* Should `TRNLIM01` bypass the MQ call to `CUSTRSK` when `EXCEPT01` detects `LC-GRANDFATHERED = 'Y'`, reducing unnecessary MQ traffic?
4. **Test Suite Ground Truth (KU-13):**
   - *Question:* Can business stakeholders formally confirm that `tests/golden-master/cases.yaml` (specifying a 20% reduction for high risk) is the authoritative specification?

---

## 11. Human Decision Gate

As mandated by the Agentic Strangler governance and DECIDE playbook:

```yaml
Human Decision Owner: REQUIRED — NOT YET ASSIGNED
Approval Status: PENDING HUMAN DECISION
Date Assigned: PENDING
Decision Recorded: NONE
```

**Mandatory Governance Rule:** No progression to the PLAN stage, no implementation planning, and no modification of application source code is permitted until a named human decision owner is assigned and explicitly records an approved disposition.

---

## 12. DECIDE Stage Exit Assessment

### Sufficiency of Evidence
- **Assessment:** **SUFFICIENT FOR HUMAN DECISION.**
- **Evidence Base:** The frozen UNDERSTAND evidence pack (`runs/atlaspay/understand/run-001/`) provides complete, unambiguous, line-level code citations covering all 25 business rules, call graphs, shared data structures, database schemas, and integration points.
- **Completeness:** All seven framework modernization dispositions (KEEP, REFACTOR, EXPOSE, EXTRACT, TRANSFORM, REPLATFORM, RETIRE) have been systematically evaluated across all 10 required decision dimensions without resorting to ungrounded assumptions.
- **Readiness:** All 18 known unknowns have been carried forward as active constraints. The estate is fully prepared for human review at the Decision Gate.

### Stage Exit Status
- **DECIDE Stage Exit:** **BLOCKED PENDING HUMAN APPROVAL.**
- **Next Permitted Action:** Assignment of a named Human Decision Owner to review this Modernization Decision Record and record a binding decision at the Human Decision Gate.
