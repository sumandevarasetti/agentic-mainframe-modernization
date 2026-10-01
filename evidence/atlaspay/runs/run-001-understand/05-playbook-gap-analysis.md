# Evidence Gap Register: AtlasPay Dynamic Transaction Limit

**Run:** `atlaspay-understand-001`  
**Evaluation Stage:** `UNDERSTAND`  
**Review Type:** Evidence-Contract Review across Frozen Native PP4Z Outputs and Agentic Strangler Framework Playbooks  
**Evaluator Ground Truth Access:** Strictly Prohibited / Absent  

---

## 1. Executive Summary

This Evidence Gap Register evaluates the frozen native IBM Bob Premium Package for Z (PP4Z) outputs from run `run-001` against the mandatory evidence contracts defined in the Agentic Strangler framework playbooks:
1. `framework-assets/playbooks/discovery/playbook.yaml` (Discovery Playbook v0.3.1)
2. `framework-assets/playbooks/dependency-analysis/playbook.yaml` (Dependency Analysis Playbook v0.3.1)
3. `framework-assets/playbooks/rule-extraction/playbook.yaml` (Rule Extraction Playbook v0.3.1)

The evaluation was conducted as a strict evidence-quality assessment. No application rediscovery was performed, no modifications were made to frozen outputs, and no modernization disposition was proposed.

---

## 2. Playbook Requirement Inventory & Gap Analysis

### 2.1 Discovery Playbook (`framework-assets/playbooks/discovery/playbook.yaml`)

| Requirement ID / Name | Requirement Description | Originating Playbook | Status | Evidence in Frozen PP4Z Outputs | Source Traceability | Missing Evidence | Why Missing Evidence Matters | Can Gap Be Closed in Workspace? | Recommended Evidence-Acquisition Method | Blocks UNDERSTAND Exit? |
|---|---|---|---|---|---|---|---|---|---|---|
| **DISC-REQ-01** `capability_definition` | Explicit definition of capability boundary, business purpose, and functional scope. | Discovery | **SATISFIED** | Documented in `01-broad-analysis-raw.md`, `02-impact-analysis-raw.md` (Section 1 & 2), and `03-business-rules-raw.md`. Defined as Dynamic Transaction Limit calculation within the AtlasPay authorization lifecycle. | [`ATLAUTH.cbl:1-35`](src/cobol/ATLAUTH.cbl:1), [`TRNLIM01.cbl:1-30`](src/cobol/TRNLIM01.cbl:1), [`AGENTS.md:37-56`](AGENTS.md:37) | None. Scope, business purpose, and boundaries are explicitly delineated. | N/A | Yes | `no_action_required` | No |
| **DISC-REQ-02** `entry_points` | Identification of all online/batch entry points initiating capability execution. | Discovery | **SATISFIED** | Captured in `01-broad-analysis-raw.md` and `02-impact-analysis-raw.md` (Section 2.1, 4.1, 4.9). Identifies primary CICS transaction `ATLA` (`ATLAUTH`), diagnostic transaction `ATLI` (`TRNLIM01`), and batch entry points. | [`cics/transactions.yaml:1-8`](cics/transactions.yaml:1), [`src/cobol/ATLAUTH.cbl:1`](src/cobol/ATLAUTH.cbl:1), [`src/cobol/TRNLIM01.cbl:1`](src/cobol/TRNLIM01.cbl:1) | None. Both production and diagnostic online entry points are cataloged. | N/A | Yes | `no_action_required` | No |
| **DISC-REQ-03** `artifact_inventory` | Catalog of all implementing programs, copybooks, tables, queues, files, and JCL. | Discovery | **SATISFIED** | Documented in `01-broad-analysis-raw.md` (What Was Done) and `02-impact-analysis-raw.md` (Section 2.1, 2.2, 5.4). Inventories 15 COBOL programs, 6 copybooks, 2 Db2 tables, 1 VSAM cluster, 2 MQ queues, 5 JCL jobs. | [`src/cobol/`](src/cobol/), [`src/copybooks/`](src/copybooks/), [`db2/schema.sql:1-25`](db2/schema.sql:1), [`mq/queues.yaml:1-12`](mq/queues.yaml:1), [`jcl/`](jcl/) | None. Full physical and logical asset inventory established. | N/A | Yes | `no_action_required` | No |
| **DISC-REQ-04** `dependency_candidates` | Initial mapping of candidate external and internal dependencies and integrations. | Discovery | **SATISFIED** | Detailed in `01-broad-analysis-raw.md` and `02-impact-analysis-raw.md` (Section 2.3, 4.1–4.9, 5.1–5.5). Traces callers, callees, Db2, VSAM, and external MQ interactions. | [`src/cobol/TRNLIM01.cbl:11-20`](src/cobol/TRNLIM01.cbl:11), [`src/cobol/CUSTRSK.cbl:16`](src/cobol/CUSTRSK.cbl:16), [`src/cobol/LIMITPOL.cbl:16-24`](src/cobol/LIMITPOL.cbl:16) | None. Direct and sub-system dependencies mapped to candidate level. | N/A | Yes | `no_action_required` | No |
| **DISC-REQ-05** `known_unknowns` | Explicit enumeration of unverifiable runtime behaviors, missing source, and ambiguities. | Discovery | **SATISFIED** | Comprehensive register of 18 specific known unknowns recorded in `04-known-unknowns-raw.md` and highlighted in `01-broad-analysis-raw.md`. | [`04-known-unknowns-raw.md:16-38`](runs/atlaspay/understand/run-001/04-known-unknowns-raw.md:16) citing source artifacts across [`src/cobol/`](src/cobol/), [`jcl/`](jcl/), [`db2/`](db2/), [`vsam/`](vsam/) | None. Gaps are rigorously captured with source citations rather than filled by inference. | N/A | Yes | `no_action_required` | No |
| **DISC-REQ-06** `artifact_references` | Source-level citations (file + line/section) for all identified artifacts. | Discovery | **SATISFIED** | Complete citation across all programs, copybooks, and data structures in `01-broad-analysis-raw.md` and `02-impact-analysis-raw.md`. | Citations throughout [`01-broad-analysis-raw.md`](runs/atlaspay/understand/run-001/01-broad-analysis-raw.md) and [`02-impact-analysis-raw.md`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md) | None. Traceability links are verified against workspace files. | N/A | Yes | `no_action_required` | No |
| **DISC-REQ-07** `relationship_references` | Verifiable evidence citations for relationships and call linkages between artifacts. | Discovery | **SATISFIED** | Explicit call graphs, copybook inclusion maps, and interface definitions provided in `02-impact-analysis-raw.md` (Sections 3, 4, 5). | [`src/cobol/ATLAUTH.cbl:20-30`](src/cobol/ATLAUTH.cbl:20), [`src/cobol/TRNLIM01.cbl:11-20`](src/cobol/TRNLIM01.cbl:11) | None. Linkage mechanisms (STATIC CALL, COPY) are cited with line numbers. | N/A | Yes | `no_action_required` | No |

---

### 2.2 Dependency Analysis Playbook (`framework-assets/playbooks/dependency-analysis/playbook.yaml`)

| Requirement ID / Name | Requirement Description | Originating Playbook | Status | Evidence in Frozen PP4Z Outputs | Source Traceability | Missing Evidence | Why Missing Evidence Matters | Can Gap Be Closed in Workspace? | Recommended Evidence-Acquisition Method | Blocks UNDERSTAND Exit? |
|---|---|---|---|---|---|---|---|---|---|---|
| **DEP-REQ-01** `direct_impact_set` | Identification of all components directly invoked or calling the capability. | Dependency Analysis | **SATISFIED** | Detailed in `02-impact-analysis-raw.md` Section 2.1 (In Scope) and Section 5.1/5.2. Captures `ATLAUTH`, `TRNLIM01`, `LIMITPOL`, `EXCEPT01`, `TMPCTRL`, `MERCHVAL`, `CUSTRSK`, `RISKFBK`, `LIMUTIL`. | [`src/cobol/ATLAUTH.cbl:22`](src/cobol/ATLAUTH.cbl:22), [`src/cobol/TRNLIM01.cbl:11-20`](src/cobol/TRNLIM01.cbl:11) | None. Direct static call chain is completely verified. | N/A | Yes | `no_action_required` | No |
| **DEP-REQ-02** `transitive_impact_set` | Mapping of downstream, upstream, and indirect components affected by capability changes. | Dependency Analysis | **SATISFIED** | Detailed in `02-impact-analysis-raw.md` Sections 5.1, 5.2, 5.3, 6 (Change Propagation Map). Traces from Digital Auth API through CICS `ATLA`, pre-guards (`ACCTVAL`, `MERCHCHK`), limit engine, and audit log (`AUTHLOG`). | [`src/cobol/ATLAUTH.cbl:20-30`](src/cobol/ATLAUTH.cbl:20), [`src/cobol/TRNLIM01.cbl:11-20`](src/cobol/TRNLIM01.cbl:11) | None. End-to-end call and return chain is documented. | N/A | Yes | `no_action_required` | No |
| **DEP-REQ-03** `data_impact` | Assessment of shared data structures, database tables, and VSAM files. | Dependency Analysis | **SATISFIED** | Documented in `02-impact-analysis-raw.md` Sections 4.4, 4.5, 4.6, 5.4, 7 (IMP-01, IMP-02, IMP-03, IMP-04). Covers `LIMITCTX.cpy`, `AUTHREQ.cpy`, Db2 `ATLAS_LIMIT_POLICY`, VSAM `EXCPTKS`. | [`src/copybooks/LIMITCTX.cpy:1-25`](src/copybooks/LIMITCTX.cpy:1), [`db2/schema.sql:1-14`](db2/schema.sql:1), [`vsam/DEFINE.jcl:1-12`](vsam/DEFINE.jcl:1) | None. Data structures and persistence impacts are thoroughly detailed. | N/A | Yes | `no_action_required` | No |
| **DEP-REQ-04** `batch_impact` | Identification of batch jobs, utilities, and reconciliation workflows interacting with data. | Dependency Analysis | **SATISFIED** | Documented in `02-impact-analysis-raw.md` Section 5.5 and Section 7 (IMP-10). Covers `LIMITBAT.cbl`, `EXCREC01.cbl`, `AUTHRPT.cbl`, and JCL jobs (`LIMITREF.jcl`, `EXCRECON.jcl`, `LIMITBKP.jcl`, `AUTHRPT.jcl`). | [`jcl/LIMITREF.jcl:1-5`](jcl/LIMITREF.jcl:1), [`jcl/EXCRECON.jcl:1-5`](jcl/EXCRECON.jcl:1), [`jcl/LIMITBKP.jcl:1-5`](jcl/LIMITBKP.jcl:1), [`src/cobol/LIMITBAT.cbl:1-20`](src/cobol/LIMITBAT.cbl:1) | None. Batch footprint and JCL anomalies are cataloged. | N/A | Yes | `no_action_required` | No |
| **DEP-REQ-05** `middleware_impact` | Analysis of CICS transaction definitions, MQ queues, and Db2 subsystem coupling. | Dependency Analysis | **SATISFIED** | Documented in `02-impact-analysis-raw.md` Sections 4.1, 4.7, 4.9. Covers CICS `ATLA`/`ATLI` entry, MQ queues `ATLAS.RISK.REQUEST`/`RESPONSE`, Db2 attachment. | [`cics/transactions.yaml:1-8`](cics/transactions.yaml:1), [`mq/queues.yaml:1-12`](mq/queues.yaml:1), [`src/cobol/LIMITPOL.cbl:16-24`](src/cobol/LIMITPOL.cbl:16) | None. Middleware resources and connection points are identified. | N/A | Yes | `no_action_required` | No |
| **DEP-REQ-06** `test_impact` | Assessment of available test assets, test cases, and characterization suites. | Dependency Analysis | **PARTIALLY_SATISFIED** | Documented in `02-impact-analysis-raw.md` Section 10 and `04-known-unknowns-raw.md` (KU-13). Identifies test files `tests/golden-master/cases.yaml` and `tests/golden-master-cases.yaml`, noting a discrepancy in high-risk test assertions. | [`tests/golden-master/cases.yaml:1-80`](tests/golden-master/cases.yaml:1), [`tests/golden-master-cases.yaml:1-20`](tests/golden-master-cases.yaml:1) | Execution framework is absent (synthetic estate with no test harness); exact discrepancy resolution between duplicate test case definitions requires governance clarification. | Test cases serve as characterization specifications during UNDERSTAND; lack of test harness does not prevent impact mapping, but reconciliation is needed during PROVE. | Yes | `no_action_required` | No |
| **DEP-REQ-07** `unresolved_dependencies` | Cataloging of external dependencies whose implementation is unavailable or unverifiable. | Dependency Analysis | **SATISFIED** | Documented in `02-impact-analysis-raw.md` Section 2.3 and Section 7 (IMP-05, IMP-09), and `04-known-unknowns-raw.md` (KU-01, KU-04). Specifically isolates `MQRSKGET` and real `AUTHLOG` destination. | [`src/cobol/CUSTRSK.cbl:16`](src/cobol/CUSTRSK.cbl:16), [`src/cobol/AUTHLOG.cbl:10`](src/cobol/AUTHLOG.cbl:10) | None. Unresolved dependencies are explicitly isolated with impact boundaries. | N/A | Yes | `no_action_required` | No |
| **DEP-REQ-08** `source_relationships` | Verifiable code-level evidence for intra-program and inter-program calls. | Dependency Analysis | **SATISFIED** | Cites exact line numbers for `CALL '...' USING ...` across all programs in `02-impact-analysis-raw.md` Sections 4.2, 4.4. | [`src/cobol/ATLAUTH.cbl:22`](src/cobol/ATLAUTH.cbl:22), [`src/cobol/TRNLIM01.cbl:11-20`](src/cobol/TRNLIM01.cbl:11) | None. All static calls verified against source. | N/A | Yes | `no_action_required` | No |
| **DEP-REQ-09** `dependency_relationships` | Structured categorization of relationships (Data, Control, Middleware, Batch). | Dependency Analysis | **SATISFIED** | Section 5 of `02-impact-analysis-raw.md` provides explicit categorizations for upstream, downstream, internal sub-system, copybook fan-out, and batch dependencies. | [`02-impact-analysis-raw.md:321-393`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md:321) | None. Full taxonomy applied to all identified dependencies. | N/A | Yes | `no_action_required` | No |
| **DEP-REQ-10** `confidence_classification` | Explicit assignment of confidence levels to findings and separation of facts from inferences. | Dependency Analysis | **SATISFIED** | Documented in `02-impact-analysis-raw.md` Section 10 (Confidence Assessment). Explicitly breaks down findings into High, Medium, and Low confidence with rationale. | [`02-impact-analysis-raw.md:545-562`](runs/atlaspay/understand/run-001/02-impact-analysis-raw.md:545) | None. Strict separation of fact and inference maintained. | N/A | Yes | `no_action_required` | No |

---

### 2.3 Rule Extraction Playbook (`framework-assets/playbooks/rule-extraction/playbook.yaml`)

| Requirement ID / Name | Requirement Description | Originating Playbook | Status | Evidence in Frozen PP4Z Outputs | Source Traceability | Missing Evidence | Why Missing Evidence Matters | Can Gap Be Closed in Workspace? | Recommended Evidence-Acquisition Method | Blocks UNDERSTAND Exit? |
|---|---|---|---|---|---|---|---|---|---|---|
| **RULE-REQ-01** `candidate_business_rules` | Catalog of recovered business rules across all lifecycle categories. | Rule Extraction | **SATISFIED** | Catalog of 25 candidate business rules (BR-01 through BR-25) across 11 categories in `03-business-rules-raw.md`. | [`src/cobol/ACCTVAL.cbl`](src/cobol/ACCTVAL.cbl), [`MERCHCHK.cbl`](src/cobol/MERCHCHK.cbl), [`LIMITPOL.cbl`](src/cobol/LIMITPOL.cbl), [`EXCEPT01.cbl`](src/cobol/EXCEPT01.cbl), [`TMPCTRL.cbl`](src/cobol/TMPCTRL.cbl), [`MERCHVAL.cbl`](src/cobol/MERCHVAL.cbl), [`CUSTRSK.cbl`](src/cobol/CUSTRSK.cbl), [`RISKFBK.cbl`](src/cobol/RISKFBK.cbl), [`LIMUTIL.cbl`](src/cobol/LIMUTIL.cbl), [`ATLAUTH.cbl`](src/cobol/ATLAUTH.cbl) | None. Complete set of pre-guards, limit derivation, caps, risk rules, and post-decision rules cataloged. | N/A | Yes | `no_action_required` | No |
| **RULE-REQ-02** `rule_precedence` | Strict execution and resolution order governing rule application. | Rule Extraction | **SATISFIED** | Documented in `03-business-rules-raw.md` Categories 11 (BR-23, BR-24, BR-25) and `01-broad-analysis-raw.md` (Key Findings). Documents 9-step limit resolution sequence in `LIMUTIL.cbl`. | [`src/cobol/LIMUTIL.cbl:10-47`](src/cobol/LIMUTIL.cbl:10), [`src/cobol/TRNLIM01.cbl:11-20`](src/cobol/TRNLIM01.cbl:11) | None. Precedence sequence is unambiguous in source code. | N/A | Yes | `no_action_required` | No |
| **RULE-REQ-03** `exception_paths` | Characterization of override paths, fallback behaviors, and error handling. | Rule Extraction | **SATISFIED** | Detailed in `03-business-rules-raw.md` Category 5 (BR-08, BR-09 grandfathered exception) and Category 8 (BR-16 fallback score 650, BR-04 floor limit 1000.00). | [`src/cobol/EXCEPT01.cbl:25-35`](src/cobol/EXCEPT01.cbl:25), [`src/cobol/RISKFBK.cbl:12-15`](src/cobol/RISKFBK.cbl:12), [`src/cobol/LIMITPOL.cbl:30-34`](src/cobol/LIMITPOL.cbl:30) | None. All exception and fallback branches cataloged. | N/A | Yes | `no_action_required` | No |
| **RULE-REQ-04** `unresolved_business_intent` | Identification of ambiguities in business policy vs. code implementation. | Rule Extraction | **SATISFIED** | Documented in `03-business-rules-raw.md` Conflict and Ambiguity Register (CAR-01 through CAR-05) and `04-known-unknowns-raw.md` (KU-06, KU-07, KU-09, KU-12, KU-17). | [`src/cobol/EXCEPT01.cbl:32`](src/cobol/EXCEPT01.cbl:32), [`src/cobol/LIMUTIL.cbl:44`](src/cobol/LIMUTIL.cbl:44), [`src/copybooks/AUTHRESP.cpy:7`](src/copybooks/AUTHRESP.cpy:7) | None. Policy intent vs implementation gaps explicitly captured. | N/A | Yes | `no_action_required` | No |
| **RULE-REQ-05** `implementing_artifacts` | Identification of exact source files implementing each business rule. | Rule Extraction | **SATISFIED** | Each of the 25 rules in `03-business-rules-raw.md` lists implementing COBOL programs, copybooks, and lines. | Citations in [`03-business-rules-raw.md:31-632`](runs/atlaspay/understand/run-001/03-business-rules-raw.md:31) | None. Direct mapping between rules and source files established. | N/A | Yes | `no_action_required` | No |
| **RULE-REQ-06** `conditions` | Formal predicate logic for each business rule condition. | Rule Extraction | **SATISFIED** | Every rule entry in `03-business-rules-raw.md` includes a dedicated `Condition` specification with exact COBOL variable evaluation logic. | E.g., [`src/cobol/LIMUTIL.cbl:17-47`](src/cobol/LIMUTIL.cbl:17) | None. Condition predicates are completely specified. | N/A | Yes | `no_action_required` | No |
| **RULE-REQ-07** `outcomes` | Exact state changes, calculations, and return codes resulting from rule application. | Rule Extraction | **SATISFIED** | Every rule entry in `03-business-rules-raw.md` includes a dedicated `Outcome` specification describing field mutations and response codes. | E.g., [`src/cobol/ATLAUTH.cbl:25-33`](src/cobol/ATLAUTH.cbl:25), [`src/cobol/LIMUTIL.cbl:20-45`](src/cobol/LIMUTIL.cbl:20) | None. Outcomes are fully documented. | N/A | Yes | `no_action_required` | No |
| **RULE-REQ-08** `confidence_classification` | Confidence rating assigned to each recovered rule and exception path. | Rule Extraction | **SATISFIED** | Summary table in `03-business-rules-raw.md` rates all 25 rules (21 High confidence grounded in code, 4 Medium/Low confidence involving external stubs/ambiguities). | [`03-business-rules-raw.md:648-672`](runs/atlaspay/understand/run-001/03-business-rules-raw.md:648) | None. Confidence classification matches framework standards. | N/A | Yes | `no_action_required` | No |

---

## 3. Deep-Dive on Significant Gaps and Ambiguities

### 3.1 DEP-REQ-06: Test Impact & Golden Master Discrepancies
- **Nature of Gap:** Characterization test suites exist in `tests/golden-master/cases.yaml` and `tests/golden-master-cases.yaml`, but there is no executable test harness in this static evaluation workspace. Furthermore, there is an assertion discrepancy for high-risk accounts (one test case expects a cap increase to 6,000.00 while the other expects a reduction to 4,000.00; `LIMUTIL.cbl:33-34` confirms code reduces by 20% to 4,000.00).
- **Classification:** Acceptable Known Unknown (KU-13).
- **Resolution Path:** In the UNDERSTAND phase, this is documented as an evidence artifact discrepancy. Resolution belongs in the PROVE stage during test harness preparation and characterization test execution.
- **Blocking Status:** Non-blocking for UNDERSTAND stage exit.

### 3.2 External Stubs and Missing Source Artifacts (`MQRSKGET`, `AUTHLOG`, `ATLAS_ACCOUNT_PRODUCT`)
- **Nature of Gap:** 
  - `MQRSKGET` is an external subprogram invoked by `CUSTRSK.cbl:16` for which source is absent (KU-01).
  - `AUTHLOG.cbl:10` is an audit stub; physical I/O destination is not in workspace (KU-04).
  - `ATLAS_ACCOUNT_PRODUCT` table definition exists in `db2/schema.sql`, but no online program executes queries against it (KU-15).
- **Classification:** Acceptable Known Unknowns (KU-01, KU-04, KU-15).
- **Resolution Path:** Human SME / external documentation validation during downstream phases. The fallback logic (`RISKFBK.cbl`) ensures deterministic behavior in the absence of `MQRSKGET`.
- **Blocking Status:** Non-blocking for UNDERSTAND stage exit.

### 3.3 Semantic Ambiguities in Business Policy
- **Nature of Gap:**
  - Expiry date enforcement: `EXCEPTREC.cpy:4` defines `ER-EXPIRY-DATE`, but `EXCEPT01.cbl:32` evaluates only `ER-ACTIVE = 'Y'` (KU-06 / CAR-01).
  - Product Max vs Grandfathered Exception: `LIMUTIL.cbl:44-46` caps grandfathered limit by `LC-PRODUCT-MAX` (KU-12 / CAR-02).
  - Unused response field: `AUTHRESP.cpy:7` defines `AS-RISK-MODE`, but no code populates it (KU-09 / CAR-04).
- **Classification:** Acceptable Known Unknowns / Policy Ambiguities.
- **Resolution Path:** Documented as explicit business questions for Human SME validation prior to or during the DECIDE phase.
- **Blocking Status:** Non-blocking for UNDERSTAND stage exit.

---

## 4. Final Summary & Governance Assessment

### 4.1 Quantitative Requirement Review

| Metric | Count |
|---|---|
| **Total Playbook Requirements Reviewed** | **25** |
| Discovery Playbook Requirements | 7 |
| Dependency Analysis Playbook Requirements | 10 |
| Rule Extraction Playbook Requirements | 8 |
| **Count SATISFIED** | **24** (96%) |
| **Count PARTIALLY_SATISFIED** | **1** (4%) |
| **Count MISSING** | **0** (0%) |

*(Note: Every item has been counted and verified against the framework playbook specifications.)*

### 4.2 Gaps that Block UNDERSTAND-Stage Exit
- **Count:** **0 (None)**.
- **Assessment:** There are no missing evidence requirements or unrecorded dependencies that prevent exiting the UNDERSTAND stage. All static source code, copybooks, database schemas, CICS configurations, and batch jobs have been fully analyzed and cross-referenced.

### 4.3 Gaps that are Acceptable Known Unknowns
The following 18 documented known unknowns are acceptable at UNDERSTAND exit, as they reflect genuine static-boundary limits, external interface stubs, or specification ambiguities inherent in the estate:
1. `KU-01`: `MQRSKGET` source absence and queue manager runtime behavior.
2. `KU-02`: Upstream `AUTH-REQUEST` field population prior to CICS dispatch.
3. `KU-03`: `AUTH-REQUEST` linkage population under direct CICS `ATLI` diagnostic invocation.
4. `KU-04`: Real audit sink and I/O destination for `AUTHLOG`.
5. `KU-05`: `EXCREC01` batch reconciliation logic and active flag lifecycle.
6. `KU-06`: `ER-EXPIRY-DATE` evaluation intent in `EXCEPT01` vs batch.
7. `KU-07`: Risk of `SQLCODE -811` in `LIMITPOL` if multi-row effective dates exist.
8. `KU-08`: Orphaned copybook `POLREC.cpy` consumer identification.
9. `KU-09`: Unassigned `AS-RISK-MODE` field in `AUTH-RESPONSE`.
10. `KU-10`: `LIMITREF.jcl` executing subprogram `LIMITPOL` without batch entry point.
11. `KU-11`: VSAM record-size discrepancy (57 bytes in JCL vs 58 bytes in copybook).
12. `KU-12`: Native COBOL VSAM I/O compilation/runtime behavior under CICS in `EXCEPT01`.
13. `KU-13`: Test case assertion divergence for high-risk account limit reduction.
14. `KU-14`: Operational purpose and consumers of `LAST_REFRESH_TS` in `LIMITBAT`.
15. `KU-15`: Absence of online consumers for `ATLAS_ACCOUNT_PRODUCT` table.
16. `KU-16`: Unused `AR-TRANSACTION-TYPE` request field.
17. `KU-17`: Unconditional invocation of `CUSTRSK` for grandfathered accounts.
18. `KU-18`: Downstream data source and reporting logic for `AUTHRPT`.

### 4.4 Assessment on Supplemental Prompting
- **Is supplemental prompting necessary before creating the Current-State Evidence Pack?**  
  **NO.**
- **Rationale:**  
  The native PP4Z outputs (`01-broad-analysis-raw.md`, `02-impact-analysis-raw.md`, `03-business-rules-raw.md`, and `04-known-unknowns-raw.md`) provide complete, line-level grounded evidence that satisfies 24 of 25 playbook requirements, with the single partial satisfaction (`DEP-REQ-06`) being a consequence of workspace isolation (no test runner) rather than an analysis deficiency.
  All required contract outputs—including capability definitions, entry points, component inventories, call graphs, shared data structures, batch touchpoints, rule catalogs, precedence orders, exception paths, and known unknowns—are fully documented with strict source traceability. The outputs are immediately ready for consolidation into the Current-State Evidence Pack.
