# Modernization Decision Record (Governance-Reviewed): AtlasPay Dynamic Transaction Limit

**Stage:** DECIDE
**Run:** `run-002`
**Document:** `02-modernization-decision-record-reviewed` — Governance/evidence correction pass over `01-modernization-decision-record.md`
**Evaluation Scope:** AtlasPay Estate — Dynamic Transaction Limit Capability
**Decision Framework:** Agentic Strangler Framework — Modernization Decision Playbook (`framework-assets/playbooks/modernization-decision/playbook.yaml` v0.3.4)
**Evidence Baseline:** Frozen UNDERSTAND Evidence (`runs/atlaspay/understand/run-001/`)
**Human Decision Owner:** REQUIRED — NOT YET ASSIGNED
**Approval Status:** PENDING HUMAN DECISION

---

## Governance Correction Notice

This document supersedes `01-modernization-decision-record.md` for the following reasons, applied systematically in every section below:

1. **Interface correction:** The `ATLAUTH → TRNLIM01` CALL parameters have been corrected to match frozen evidence. The source record stated the second parameter was `AUTH-RESPONSE`; the frozen evidence pack establishes the actual call is `CALL 'TRNLIM01' USING AUTH-REQUEST LIMIT-CONTEXT` ([`ATLAUTH.cbl:32`](src/cobol/ATLAUTH.cbl:32)), with `LC-FINAL-LIMIT` moved into `AS-APPLIED-LIMIT` on return ([`ATLAUTH.cbl:33`](src/cobol/ATLAUTH.cbl:33)). The downstream decision fields after the CALL are `AS-DECISION` and `AS-REASON-CODE` (not "AS-AUTH-DECISION"). The `MERCHVAL` call is corrected to `CALL 'MERCHVAL' USING AUTH-REQUEST LC-MCC-LIMIT` — the bare field, not full `LIMIT-CONTEXT` ([`TRNLIM01.cbl:15`](src/cobol/TRNLIM01.cbl:15), evidence pack §3.3).
2. **Unsupported claims removed:** All LOC counts, cyclomatic-complexity scores, latency/SLA values, sub-millisecond claims, MIPS/cost claims, staffing claims, compiler/runtime guarantees, and transaction/syncpoint semantics are removed. Where relevant to a disposition they are reclassified as UNKNOWN or as proof obligations.
3. **PLAN-stage design removed:** Specific database redesigns, parameter-interface redesigns, source-code fixes, implementation sequencing, and migration steps previously embedded in disposition descriptions and in the proposed disposition section have been removed. DECIDE describes the *type* of change implied by each disposition; it does not design the solution.
4. **Target-technology names removed:** Specific product names (z/OS Connect Enterprise Edition, AWS Mainframe Modernization, Micro Focus, Java, Go, Python, gRPC, NoSQL, etc.) that do not exist in the frozen current state have been removed.
5. **Business-rule confidence preserved:** No rule is described as "proven" where the frozen evidence classifies it as `[STRONGLY INFERRED]` or `[UNRESOLVED]`. The 25 cataloged rules include 21 `[EXPLICIT]`, 4 `[STRONGLY INFERRED]` or `[UNRESOLVED]`.
6. **Business objective scoped correctly:** The sole stated objective is used throughout. No independent-reuse, cloud-migration, external-API-consumption, or infrastructure-cost objectives are assumed.
7. **EXTRACT reclassified as conditional:** EXTRACT is an option that becomes attractive if a business requirement for lifecycle isolation or independent reuse is established — but that requirement is not present in the frozen evidence.
8. **KEEP retained as legitimate baseline:** KEEP is not pre-emptively rejected. It remains a valid option.
9. **Known unknowns preserved as constraints:** None of the 18 known unknowns is silently closed. Where the source record resolved an unknown by assumption, the assumption has been reverted to an open constraint.
10. **Evidence sufficiency qualified:** The evidence supports proceeding to human decision, but it is neither complete nor unambiguous where documented conflicts and known unknowns remain open.

---

## 1. Business Objective

The single stated business objective for this decision stage is:

> **Make the Dynamic Transaction Limit capability easier and safer to evolve while preserving existing externally observable behavior unless a business change is explicitly approved.**

No additional strategic objectives (independent service reuse, external API consumption, cloud migration, infrastructure cost reduction) are assumed. If any of those objectives are later adopted by human decision-makers, the disposition evaluation may change accordingly.

---

## 2. Decision Context

This decision is based exclusively on the frozen evidence produced in UNDERSTAND (`runs/atlaspay/understand/run-001/01` through `06`). No source code modifications or ungrounded assumptions are introduced.

### 2.1 Capability Boundary and Flow Summary

The Dynamic Transaction Limit capability is an online limit resolution engine executed synchronously within the AtlasPay card authorization path.

**Entry Points:**
- Primary: CICS transaction `ATLA` dispatches [`ATLAUTH.cbl`](src/cobol/ATLAUTH.cbl) ([`cics/transactions.yaml:2-4`](cics/transactions.yaml:2)).
- Diagnostic: CICS transaction `ATLI` dispatches [`TRNLIM01.cbl`](src/cobol/TRNLIM01.cbl) directly, bypassing `ATLAUTH` ([`cics/transactions.yaml:5-8`](cics/transactions.yaml:5)). How `AUTH-REQUEST` is populated for this diagnostic path is unknown (KU-03).

**Orchestration — `ATLAUTH`:**
1. Initializes `LIMIT-CONTEXT` ([`ATLAUTH.cbl:15`](src/cobol/ATLAUTH.cbl:15)).
2. `CALL 'ACCTVAL' USING AUTH-REQUEST` — blank account-ID exits before limit calculation ([`ATLAUTH.cbl:16-21`](src/cobol/ATLAUTH.cbl:16)).
3. `CALL 'MERCHCHK' USING AUTH-REQUEST` — blank MCC exits before limit calculation ([`ATLAUTH.cbl:24-29`](src/cobol/ATLAUTH.cbl:24)).
4. **`CALL 'TRNLIM01' USING AUTH-REQUEST LIMIT-CONTEXT`** ([`ATLAUTH.cbl:32`](src/cobol/ATLAUTH.cbl:32)) — the sole interface from authorization orchestration to the limit sub-system. Both copybooks are passed; `TRNLIM01` initializes `LIMIT-CONTEXT` again at its own entry ([`TRNLIM01.cbl:10`](src/cobol/TRNLIM01.cbl:10)).
5. `MOVE LC-FINAL-LIMIT TO AS-APPLIED-LIMIT` ([`ATLAUTH.cbl:33`](src/cobol/ATLAUTH.cbl:33)) — the only field consumed from `LIMIT-CONTEXT` on return.
6. Authorization comparison: `IF AR-AMOUNT <= LC-FINAL-LIMIT` → `AS-DECISION := 'A'` / `AS-REASON-CODE := '0000'`; else `AS-DECISION := 'D'` / `AS-REASON-CODE := 'LIMT'` ([`ATLAUTH.cbl:35-41`](src/cobol/ATLAUTH.cbl:35)).
7. Audit: `PERFORM WRITE-AUDIT` → calls `AUTHLOG` ([`ATLAUTH.cbl:43-47`](src/cobol/ATLAUTH.cbl:43)). Real `AUTHLOG` I/O destination is unknown (KU-04).

**Limit sub-system — `TRNLIM01` call sequence ([`TRNLIM01.cbl:12-22`](src/cobol/TRNLIM01.cbl:12)):**

| Step | Call | Parameters (as observed) | Fields written |
|---|---|---|---|
| 1 | `CALL 'LIMITPOL' USING AUTH-REQUEST LIMIT-CONTEXT` | full context | `LC-BASE-LIMIT`, `LC-PRODUCT-MAX`, `LC-JURIS-LIMIT` (or fallback 1,000.00) |
| 2 | `CALL 'EXCEPT01' USING AUTH-REQUEST LIMIT-CONTEXT` | full context | `LC-GRANDFATHERED`, `LC-EXCEPTION-LIMIT` |
| 3 | `CALL 'TMPCTRL' USING AUTH-REQUEST LIMIT-CONTEXT` | full context | `LC-TEMP-LIMIT` (or sentinel 9,999,999.99) |
| 4 | `CALL 'MERCHVAL' USING AUTH-REQUEST LC-MCC-LIMIT` | **bare field — not full context** | `LC-MCC-LIMIT` (1,000.00 / 2,000.00 / sentinel) |
| 5 | `CALL 'CUSTRSK' USING AUTH-REQUEST LIMIT-CONTEXT` | full context | `LC-RISK-AVAILABLE`, `LC-RISK-SCORE` |
| 5a (cond.) | `CALL 'RISKFBK' USING AUTH-REQUEST LIMIT-CONTEXT` | if `LC-RISK-AVAILABLE ≠ 'Y'` | `LC-RISK-SCORE := 650` |
| 6 | `CALL 'LIMUTIL' USING AUTH-REQUEST LIMIT-CONTEXT` | full context | `LC-FINAL-LIMIT` |

**LIMUTIL 7-step resolution (confirmed in [`LIMUTIL.cbl:12-46`](src/cobol/LIMUTIL.cbl:12)):**
1. Candidate ← `LC-BASE-LIMIT`
2. If `LC-JURIS-LIMIT > 0` and lower → candidate ← `LC-JURIS-LIMIT`
3. If `LC-MCC-LIMIT > 0` and lower → candidate ← `LC-MCC-LIMIT`
4. If `LC-TEMP-LIMIT > 0` and lower → candidate ← `LC-TEMP-LIMIT`
5a. **If `LC-GRANDFATHERED = 'Y'`** → candidate ← `LC-EXCEPTION-LIMIT` (overrides steps 1–4 entirely)
5b. **Else** → if `LC-RISK-SCORE ≥ 800`: candidate × 0.80; if `LC-RISK-SCORE < 500`: candidate × 0.70; 500–799: no change
6. If candidate > `LC-PRODUCT-MAX` → candidate ← `LC-PRODUCT-MAX` (absolute ceiling; applies unconditionally, including to grandfathered results)
7. `LC-FINAL-LIMIT ← candidate`

Note: C-02 in the frozen evidence flags that applying the product-max ceiling to grandfathered exception limits may not be the intended business behavior. This is `[UNRESOLVED]`.

**Batch touchpoints:**
- `LIMREFR.jcl` → `LIMITBAT`: nightly timestamp update on `ATLAS_LIMIT_POLICY` ([`LIMITBAT.cbl:11-15`](src/cobol/LIMITBAT.cbl:11))
- `EXCRECON.jcl` → `EXCREC01` (stub): monthly VSAM reconciliation (logic absent — KU-05)
- `LIMITBKP.jcl` → IDCAMS REPRO: VSAM backup
- `AUTHRPT.jcl` → `AUTHRPT` (stub): daily reporting (data source unknown — KU-18)
- `LIMITREF.jcl` → `LIMITPOL`: anomalous — `LIMITPOL` has no batch entry point; operational status unknown (KU-10)

### 2.2 Key Architecture Characteristics

- **Shared mutable context:** `LIMITCTX.cpy` is shared and mutated by eight consumer programs. Both `ATLAUTH` and `TRNLIM01` initialize it. Neither initialization failure is guarded ([`ATLAUTH.cbl:15`](src/cobol/ATLAUTH.cbl:15); [`TRNLIM01.cbl:10`](src/cobol/TRNLIM01.cbl:10)).
- **Multi-resource data tier:** Online execution couples to Db2 (`LIMITPOL`), VSAM (`EXCEPT01`), and IBM MQ (`CUSTRSK` → `MQRSKGET`). The MQ wrapper source is absent (KU-01).
- **Hardcoded business constants:** MCC caps for codes 7995 and 6051 are hardcoded in `MERCHVAL.cbl`. Whether these are regulatory/contractual or intended to be policy-driven is `[UNRESOLVED]`.
- **Silent failure modes:** DB2 non-zero SQLCODE silently applies a 1,000.00 floor with no error flag to callers ([`LIMITPOL.cbl:25-33`](src/cobol/LIMITPOL.cbl:25)). VSAM open/close status is not checked in `EXCEPT01` ([`EXCEPT01.cbl:19`](src/cobol/EXCEPT01.cbl:19)).
- **Business-rule confidence mix:** 21 of 25 recovered rules are `[EXPLICIT]` (proven from source); 4 are `[STRONGLY INFERRED]` or `[UNRESOLVED]`. Six conflicts (C-01 through C-06) remain open. See §9 for full rule status.

---

## 3. Disposition Comparison

All seven dispositions defined in the framework playbook are evaluated against frozen UNDERSTAND evidence. No numeric scores are applied. Claims not supportable from frozen evidence are classified as UNKNOWN.

---

### 3.1 KEEP

**Type of change:** None. The current implementation continues without alteration.

**Business rationale:** Meets the behavioral-preservation requirement at zero transformation risk. Fails the evolution-agility objective because hardcoded MCC constraints and shared mutable state require COBOL source changes, recompilation, and CICS reload for any policy modification.

**Technical rationale (evidence-grounded):**
The sub-system is functional and deterministic across all paths observable in the workspace. Known latent risks remain active: SQLCODE -811 silent fallback risk (KU-07), VSAM record-size discrepancy (KU-11), native COBOL VSAM I/O under CICS (KU-12), `LIMITREF.jcl` anomaly (KU-10), and unexpired exception records with past-dated `ER-EXPIRY-DATE` remaining active (C-03).

**Coupling retained:** All. Shared `LIMITCTX.cpy` fan-out (8 programs). Db2, VSAM, and MQ synchronous coupling in the online path. MCC constants embedded in program logic.

**Behavioral risk:** Zero regression risk from transformation. Latent defects described above remain.

**Known unknowns constraining this option:** KU-01 (MQ wrapper), KU-06 (expiry date enforcement), KU-07 (Db2 multi-row risk), KU-12 (VSAM under CICS). These are not resolved by selecting KEEP; they remain active in production.

**Proof obligations if selected:**
- Monitor `ATLAS_LIMIT_POLICY` for duplicate effective-date rows that could trigger SQLCODE -811 (KU-07).
- Confirm VSAM cluster record size matches `EXCEPTREC.cpy` layout (KU-11).

---

### 3.2 REFACTOR

**Type of change:** Internal restructuring of COBOL program boundaries and data flows while retaining the existing runtime platform and all external interfaces. No new platforms, middleware, or services are introduced.

**Business rationale:** Addresses the evolution-agility objective most directly while preserving the existing runtime environment. Changes would be internal and bounded to the limit sub-system programs.

**Technical rationale (evidence-grounded):**
The sub-system has a clearly demarcated orchestration entry (`TRNLIM01`) and a single calculation program (`LIMUTIL`). Program sizes are small and cohesive (no LOC counts are available from frozen evidence). The shared mutable-state structure (`LIMITCTX.cpy`) and hardcoded business constants are the primary structural friction points identified in frozen evidence. The type of change implied — eliminating direct mutation of shared state, externalizing hardcoded constants into managed configuration — would reduce the change surface for future policy evolution. The specific implementation design belongs to PLAN, not DECIDE.

**Coupling:** Would reduce copybook fan-out blast radius and eliminate hardcoded business constants from program logic. Retains CICS runtime coupling, Db2, VSAM, and MQ integration points unchanged.

**Behavioral risk:** Low. Execution remains on the existing runtime. Risk is strictly bounded to changes in parameter-passing and SQL behavior, and requires characterization-suite validation. KU-13 (conflicting test files for the high-risk branch) must be resolved before validation can be declared complete.

**Transaction/syncpoint semantics:** UNKNOWN — the frozen evidence does not characterize CICS syncpoint or two-phase commit behavior for this capability.

**Operational risk:** Low — changes would use established promotion procedures for the existing platform. Specific procedures are UNKNOWN from frozen evidence.

**Known unknowns constraining this option:** KU-06 (expiry-date business intent must be resolved before any change to exception handling), KU-07 (Db2 effective-date query risk must be addressed), KU-13 (authoritative test file must be confirmed before PROVE).

**Assumptions separately stated:**
- *Unconfirmed:* Whether MCC caps are regulatory/contractual (and therefore correctly hardcoded) or intended to be policy-driven. This is a business decision required before any implementation that touches `MERCHVAL`.
- *Unconfirmed:* Whether a characterization test harness can be established given the KU-13 conflict.

**Proof obligations if selected:**
- Demonstrate behavioral equivalence across all 25 business rules, accounting for their confidence classifications (21 proven, 4 inferred/unresolved).
- Resolve KU-13 before test validation is deemed authoritative.

---

### 3.3 EXPOSE

**Type of change:** Wrapping an existing entry point (CICS `ATLA` or the `ATLAUTH → TRNLIM01` boundary) behind an external interface adapter. Internal logic is not changed. The specific middleware product or protocol used is a PLAN-stage target-technology decision.

**Business rationale:** Enables external consumers to reach the limit capability without binary COBOL coupling. Does not address evolution-agility friction (hardcoded MCC constants, shared mutable state) and therefore only partially satisfies the stated business objective.

**Technical rationale (evidence-grounded):**
`ATLAUTH` already acts as a structured entry point receiving `AUTH-REQUEST` ([`AUTHREQ.cpy:1-12`](src/copybooks/AUTHREQ.cpy:1)). The boundary between authorization orchestration and limit calculation at [`ATLAUTH.cbl:32`](src/cobol/ATLAUTH.cbl:32) is clean and candidate for an external interface. KU-02 (how `AUTH-REQUEST` fields are populated before CICS dispatch) must be characterized before any interface adapter is designed.

**Coupling:** Reduces external consumers' coupling to EBCDIC binary copybook layouts. Retains all internal coupling. Introduces a new adapter runtime dependency (type UNKNOWN until target selected in PLAN).

**Behavioral risk:** Very low for core logic. Risk is limited to data serialization and numeric-precision mapping between external representations and COBOL packed-decimal fields.

**Known unknowns constraining this option:** KU-02 (upstream `AUTH-REQUEST` population), KU-09 (`AS-RISK-MODE` unset — downstream consumers may be affected), absence of evidence for independent reuse requirement.

**Assumptions separately stated:**
- *Unconfirmed:* Whether any external consumer requires independent API-level access to limit calculation separate from the full authorization path. This is a business requirement question, not established in frozen evidence.

**Proof obligations if selected:**
- Demonstrate data-type fidelity between external numeric representations and COBOL packed-decimal fields.
- Characterize API throughput relative to online authorization volume (UNKNOWN — no volume data in frozen evidence; this becomes a proof obligation before production readiness).

---

### 3.4 EXTRACT

**Type of change:** Formal isolation of the `TRNLIM01` sub-system as a separately deployable or independently callable unit, establishing a versioned interface contract between the authorization orchestrator and the limit calculation engine. The specific extraction target, interface design, and deployment mechanism are PLAN-stage decisions.

**Business rationale:** Accelerates independent evolution of limit policy without requiring changes to authorization orchestration. This option becomes strongly motivated if a business requirement for lifecycle isolation (independent deployment cadence) or cross-channel reuse exists. No such independent business requirement is established in the frozen evidence. EXTRACT is therefore a **conditional option**: warranted if lifecycle isolation or reuse is adopted as a business objective, but not compelled by the currently stated objective alone.

**Technical rationale (evidence-grounded):**
`TRNLIM01` already exhibits high cohesion as a dedicated orchestrator ([`TRNLIM01.cbl:10-22`](src/cobol/TRNLIM01.cbl:10)). The interface at [`ATLAUTH.cbl:32`](src/cobol/ATLAUTH.cbl:32) (`CALL 'TRNLIM01' USING AUTH-REQUEST LIMIT-CONTEXT`) with only `LC-FINAL-LIMIT` consumed on return represents a candidate stable boundary. The CICS diagnostic entry `ATLI` demonstrates that `TRNLIM01` already runs independently in a non-production path ([`cics/transactions.yaml:5-8`](cics/transactions.yaml:5)), though how `AUTH-REQUEST` is populated for that path is unknown (KU-03).

**Coupling:** Would decouple authorization orchestration from limit policy evaluation. Retains `LIMITCTX.cpy` shared-state coupling within the extracted sub-system unless combined with REFACTOR. Introduces an inter-component communication boundary whose specifics are PLAN-stage decisions.

**Behavioral risk:** Low to moderate. Core limit algorithm is unchanged; risk is bounded to the boundary contract under all error conditions (Db2 unavailable, VSAM unavailable, MQ timeout).

**Known unknowns constraining this option:** KU-01 (`MQRSKGET` source absent — risk path unverifiable), KU-03 (`ATLI` second caller — any interface change must account for both callers), KU-17 (unconditional MQ invocation for grandfathered accounts — design consideration for the extracted component).

**Assumptions separately stated:**
- *Unconfirmed and required before selection:* That the organization has a business requirement for lifecycle isolation or cross-channel reuse of the Dynamic Transaction Limit engine.

**Proof obligations if selected:**
- Demonstrate interface contract robustness under all documented error conditions.
- Demonstrate both callers (`ATLAUTH` and `ATLI`) remain correctly served.

---

### 3.5 TRANSFORM

**Type of change:** Full re-implementation of the limit capability in a different runtime or language. The specific target platform and language are PLAN-stage decisions.

**Business rationale:** Could theoretically produce a more evolvable system in the long term, but the transformation cost is high, the behavioral equivalence risk is substantial, and the necessary data dependencies (Db2, VSAM, MQ) create distributed-consistency challenges that are not manageable from the current evidence base. Does not clearly outperform REFACTOR against the stated business objective.

**Technical rationale (evidence-grounded):**
The core limit algorithm is mathematically well-defined and compact ([`LIMUTIL.cbl:12-46`](src/cobol/LIMUTIL.cbl:12)). However, the capability is tightly coupled to three heterogeneous data sources with nightly batch reconciliation jobs (`EXCRECON.jcl`, `LIMITREF.jcl`, `AUTHRPT.jcl`). Moving execution off the current platform without resolving those data dependencies introduces distributed-consistency risks not present in the frozen current state. The behavior of `MQRSKGET` is entirely unverifiable (KU-01). Real `AUTHLOG` behavior is unverifiable (KU-04). These are not acceptable unknowns for a full re-implementation target.

**Coupling:** Would eliminate COBOL copybook and compiler dependencies. Would retain logical data entity relationships (policy, jurisdiction, exception, risk). Would introduce new cross-platform data access patterns whose specifics are unknown until PLAN.

**Behavioral risk:** High. Numeric precision (COBOL packed-decimal arithmetic), algorithm order-of-operations, SQL query semantics, and edge-case exception handling all create re-implementation divergence risk. The high-risk branch behavioral question (KU-13/C-01) is unresolved and would propagate into the re-implementation.

**Known unknowns severely constraining this option:** KU-01, KU-04, KU-05/KU-06, KU-13. These are not minor constraints — they directly affect verifiability of any transformed implementation.

**Proof obligations if selected:**
- Execute parallel-run behavioral characterization across a statistically representative transaction population — the specific threshold and methodology are PLAN-stage decisions.
- Resolve all HIGH-severity known unknowns (KU-01, KU-04) before implementation begins.
- Establish authoritative behavioral expectations for all 4 `[STRONGLY INFERRED]`/`[UNRESOLVED]` rules.

---

### 3.6 REPLATFORM

**Type of change:** Migration of the existing COBOL programs and associated data stores to an alternative execution environment without changing program logic. The specific target environment is a PLAN-stage decision.

**Business rationale:** Does not address the stated business objective. Hardcoded MCC constants, shared mutable state, and technical debt are preserved verbatim on a new infrastructure. Infrastructure cost reduction may be a secondary motivation; it is not the stated objective for this decision.

**Technical rationale (evidence-grounded):**
The application uses standard COBOL constructs and standard SQL. Whether COBOL numeric arithmetic, file locking semantics, and CICS API behavior would be preserved identically in an alternative environment is UNKNOWN from frozen evidence (KU-12 specifically flags native COBOL VSAM I/O under CICS as unverified even in the current platform). `MQRSKGET` portability is also UNKNOWN (KU-01).

**Coupling retained:** All internal application coupling. Batch JCL, Db2 schema, VSAM cluster dependencies, and `LIMITCTX.cpy` fan-out are preserved.

**Behavioral risk:** Moderate to unknown. Platform-level differences in COBOL compiler arithmetic, VSAM file locking, and CICS emulation compatibility are not determinable from frozen evidence.

**Known unknowns constraining this option:** KU-01 (`MQRSKGET` portability), KU-10 (`LIMITREF.jcl` anomaly), KU-12 (native VSAM I/O under CICS).

**Proof obligations if selected:**
- Demonstrate execution parity across all online transactions and all batch JCL jobs — scope of effort is UNKNOWN until target environment is characterized.

---

### 3.7 RETIRE

**Type of change:** Decommissioning and removal of the capability.

**Business rationale:** None. The capability is active and mandatory.

**Technical rationale (evidence-grounded):**
`ATLAUTH.cbl:32-41` requires `TRNLIM01` to produce `LC-FINAL-LIMIT`, which is the sole basis for the approve/decline authorization decision. There is no alternative limit source in the workspace. Removing this capability would eliminate the ability to process card authorizations.

**Behavioral risk:** Catastrophic. Authorization processing would fail unconditionally.

**Proof obligations if selected:**
- Must prove an alternative production limit engine exists and is fully validated across all 25 cataloged business rules before decommissioning begins.

---

## 4. Comparative Decision Matrix

| Dimension | KEEP | REFACTOR | EXPOSE | EXTRACT | TRANSFORM | REPLATFORM | RETIRE |
|---|---|---|---|---|---|---|---|
| **Satisfies business objective** | Preserves behavior; does not improve evolvability | **Directly addresses both objectives** | Partial; adds access but not evolvability | Conditional; addresses lifecycle isolation if that objective is confirmed | High potential; high risk; blocked by unknowns | Does not address objective | Eliminates capability |
| **Coupling reduction** | None | **Reduces shared-state and hardcoded-constant coupling** | Reduces external consumer coupling only | Decouples orchestrator from calculation | Full decoupling from current platform | None; retains all application coupling | N/A |
| **Change surface** | None | Bounded to limit sub-programs; Db2 configuration type of change implied | Bounded to adapter layer | Bounded to `ATLAUTH` / `TRNLIM01` boundary | Full capability re-implementation | Full estate migration | Destructive |
| **Behavioral risk** | Zero regression | **Low; runtime unchanged; requires characterization** | Very low; logic unchanged | Low-moderate; boundary contract changes | **High; arithmetic precision, algorithm translation** | Moderate to unknown; platform differences | Catastrophic |
| **KU exposure** | KUs remain active but unchanged | KU-06, KU-07, KU-13 must be resolved | KU-02, KU-09 must be resolved | KU-01, KU-03, KU-17 must be addressed | **Critical; KU-01, KU-04, KU-05/06, KU-13 block verifiability** | KU-01, KU-10, KU-12 block parity proof | N/A |
| **Operational risk** | Zero | Low (platform unchanged) | Low to moderate (new adapter) | Moderate (new component lifecycle) | **High (new platform, distributed data)** | High (migration effort) | Catastrophic |
| **Reversibility** | N/A | High (standard load-module rollback) | High (disable route) | Moderate-high | Low (complex data migration) | Moderate-low | Irreversible once decommissioned |
| **Transaction semantics** | UNKNOWN (unchanged) | UNKNOWN (retained; not changed) | UNKNOWN (retained internally) | UNKNOWN (retained within sub-system) | **UNKNOWN and introduced new risks** | UNKNOWN (platform-dependent) | N/A |
| **Latency/performance** | UNKNOWN | UNKNOWN (platform unchanged) | UNKNOWN (adapter overhead) | UNKNOWN | UNKNOWN (cross-platform) | UNKNOWN | N/A |

---

## 5. Advisory Proposed Disposition

Based strictly on the frozen evidence and the stated business objective, the evidence is sufficient to support a human decision, and the following advisory is offered.

### Advisory: REFACTOR as primary disposition; EXTRACT as a conditional future option

**Rationale grounded in evidence:**

REFACTOR most directly addresses the stated objective — evolving the capability more easily and safely — without introducing risks that exceed those already present in the current state. The two primary structural friction points identified in the frozen evidence are:
- Hardcoded MCC business constants in program logic (`MERCHVAL.cbl`) that require COBOL source changes for any policy modification
- Shared mutable context (`LIMITCTX.cpy`) passed across eight consumer programs, creating a large blast radius for any data-structure change

The type of change implied by REFACTOR — moving business constants into managed configuration and reducing shared-mutable-state coupling — addresses both friction points while keeping execution on the existing platform, which preserves the behavioral baseline and minimizes the risk surface. The implementation design for these changes belongs to PLAN, not DECIDE.

EXTRACT is not recommended as a primary disposition at this stage because the frozen evidence does not establish an independent business requirement for lifecycle isolation or cross-channel reuse. If that requirement is established by human decision-makers, EXTRACT becomes a natural complement to REFACTOR in a subsequent lifecycle stage.

**What this advisory does not claim:**
- It does not claim all 25 business rules are proven. Four are `[STRONGLY INFERRED]` or `[UNRESOLVED]`, and six behavioral conflicts (C-01 through C-06) remain open.
- It does not claim the evidence is complete or unambiguous. Eighteen known unknowns remain active.
- It does not design the REFACTOR implementation. That is a PLAN-stage obligation.
- It does not assert any SLA, latency, or performance outcome. Those are UNKNOWN from frozen evidence.
- It does not rule out KEEP. KEEP remains a legitimate option if human decision-makers determine that evolution agility is not a near-term requirement or that the risks of any transformation outweigh the benefits.

---

## 6. Conditional Future Options

The following options are not recommended as primary dispositions at this stage, but become appropriate under specified conditions:

| Option | Becomes appropriate when |
|---|---|
| **EXTRACT** | A business requirement for lifecycle isolation or cross-channel reuse of the limit engine is explicitly established; and the REFACTOR phase has reduced internal coupling to a stable interface contract |
| **EXPOSE** | An external consumer requirement for independent API-level access to limit calculation (separate from the full authorization path) is established |
| **TRANSFORM** | KU-01 (MQ wrapper source) and KU-04 (AUTHLOG) are resolved; KU-13 (authoritative test file) is confirmed; and the organization adopts a target platform — none of which are pre-selected here |
| **REPLATFORM** | Infrastructure cost reduction becomes an explicit business objective and is weighed against the zero agility gain this option provides |

---

## 7. Decision Constraints

Any downstream stage (PLAN or later) must observe the following constraints. These are not implementation decisions; they are behavioral invariants and evidence-grounded boundaries.

1. **Behavioral invariance:** The 7-step limit calculation sequence in [`LIMUTIL.cbl:12-46`](src/cobol/LIMUTIL.cbl:12) and all 25 business rules cataloged in [`03-business-rules-raw.md`](runs/atlaspay/understand/run-001/03-business-rules-raw.md) define the externally observable behavior. That behavior must be preserved unless a human-approved business policy change explicitly authorizes a difference. This applies to rules classified `[STRONGLY INFERRED]` and `[UNRESOLVED]` as well — they represent the current observable behavior, which is the baseline to preserve absent an explicit policy exception.

2. **Read-only baseline:** No source in `src/`, `jcl/`, `db2/`, `vsam/`, `mq/`, or `cics/` may be altered without a formally approved PLAN.

3. **Batch co-existence:** Any change to data structures or storage must maintain backward compatibility with nightly batch jobs (`LIMREFR.jcl`, `EXCRECON.jcl`, `LIMITBKP.jcl`, `AUTHRPT.jcl`) and the anomalous `LIMITREF.jcl`. The operational state of `LIMITREF.jcl` must be confirmed before any change touches `LIMITPOL` (KU-10).

4. **Interface stability for both callers:** Both `ATLAUTH` (production path) and `ATLI` (diagnostic path) are callers of `TRNLIM01`. Any change to the `TRNLIM01` interface must account for both (KU-03).

5. **No target-technology pre-selection:** Specific implementation languages, cloud platforms, API products, middleware products, emulators, or target runtimes must not be selected until PLAN.

6. **Unknown-resolution prerequisites:** The following known unknowns must be resolved before the changes they affect can be safely implemented (resolution belongs to PLAN or PROVE):
   - KU-01 before any change to the MQ risk path
   - KU-03 before any change to the `TRNLIM01` interface
   - KU-04 before any change to `AUTH-RESPONSE` fields or `WRITE-AUDIT` timing
   - KU-06 and KU-05 before any change to exception-record handling
   - KU-07 before any change to the Db2 policy query
   - KU-08 before any schema change to `ATLAS_LIMIT_POLICY`
   - KU-11 before any change to VSAM cluster structure
   - KU-12 before any change to `EXCEPT01` compilation or CICS options
   - KU-13 before behavioral characterization tests are declared authoritative

---

## 8. Known Unknowns Carried Forward

All 18 known unknowns from [`04-known-unknowns-raw.md`](runs/atlaspay/understand/run-001/04-known-unknowns-raw.md) and the evidence pack (§9) are carried forward unchanged. None are resolved by this decision record. None are silently closed.

| ID | Uncertainty | Modernization Risk | Resolution Required Before |
|---|---|---|---|
| **KU-01** | `MQRSKGET` source absent — timeout, retry, queue manager, correlation mechanism all unknown | **HIGH** | Any change to the live risk path |
| **KU-02** | `AUTH-REQUEST` upstream population mechanism unknown | **HIGH** | Any change to the input contract |
| **KU-03** | `AUTH-REQUEST` population for `ATLI` diagnostic entry unknown | **MEDIUM** | Any change to `TRNLIM01` interface |
| **KU-04** | Real `AUTHLOG` I/O destination and behavior unknown | **HIGH** | Any change to `AUTH-RESPONSE` fields or audit timing |
| **KU-05** | Real `EXCREC01` reconciliation logic absent | **MEDIUM** | Any change to `ER-ACTIVE` lifecycle or exception handling |
| **KU-06** | `ER-EXPIRY-DATE` enforcement intent unresolved — runtime vs. batch | **MEDIUM** | Any change to exception-record evaluation logic |
| **KU-07** | Multi-row `SQLCODE -811` risk in `ATLAS_LIMIT_POLICY` | **MEDIUM** | Any change to Db2 policy query or schema |
| **KU-08** | `POLREC.cpy` consumer not found in workspace | **MEDIUM** | Any schema change to `ATLAS_LIMIT_POLICY` |
| **KU-09** | `AS-RISK-MODE` declared but never assigned | **LOW–MEDIUM** | Any change affecting downstream `AUTH-RESPONSE` consumers |
| **KU-10** | `LIMITREF.jcl` operational status unknown | **LOW** | Any change to `LIMITPOL` |
| **KU-11** | VSAM record-size discrepancy (57 vs. ≥58 bytes) | **MEDIUM** | Any change to VSAM cluster structure |
| **KU-12** | `EXCEPT01` native COBOL VSAM I/O under CICS — compilation options unverifiable | **HIGH** | Any change to `EXCEPT01` or its compilation |
| **KU-13** | Authoritative test file for high-risk branch unresolved | **MEDIUM** | Characterization test validation in PROVE |
| **KU-14** | `LAST_REFRESH_TS` operational purpose and consumers unknown | **LOW** | Before modifying or removing `LIMITBAT` |
| **KU-15** | `ATLAS_ACCOUNT_PRODUCT` has no online consumer in workspace | **MEDIUM** | Before assuming product-code resolution is correct |
| **KU-16** | `AR-TRANSACTION-TYPE` declared and inert — intent unknown | **LOW–MEDIUM** | Before removing or repurposing the field |
| **KU-17** | `CUSTRSK` called unconditionally even for grandfathered accounts | **LOW–MEDIUM** | Before short-circuiting the MQ call (business confirmation required) |
| **KU-18** | `AUTHRPT` data source and reporting logic absent | **LOW** | Before modifying authorization response data |

**Open behavioral conflicts from UNDERSTAND (all `[UNRESOLVED]`):**
- **C-01/C-06:** Conflicting test expectations and risk-score direction semantics — one test file expects 6,000.00 for high risk; source code confirms ×0.80 = 4,000.00.
- **C-02:** Whether grandfathered exception limits should be exempt from the product-maximum ceiling.
- **C-03:** Whether `ER-EXPIRY-DATE` should be enforced at authorization time or by batch.
- **C-04:** Whether MQ timeout and MQ error should produce different downstream behavior (`AS-RISK-MODE` never populated).
- **C-05:** Business intent of the 1,000.00 policy-lookup fallback floor.

---

## 9. Business Rule Status Summary

Business rules are carried forward from the frozen evidence pack at their established confidence levels. No rule is elevated from `[STRONGLY INFERRED]` or `[UNRESOLVED]` to proven by this document.

| Category | Rules | Confidence |
|---|---|---|
| Pre-limit guards (BR-01, BR-02) | 2 | `[EXPLICIT]` — High |
| Base limit and fallback (BR-03, BR-04) | 2 | BR-03: `[EXPLICIT]`; BR-04: behavior `[EXPLICIT]`, business intent `[UNRESOLVED]` |
| Jurisdiction constraint (BR-05) | 1 | `[EXPLICIT]`; zero-sentinel semantics `[UNRESOLVED]` |
| Temporary controls (BR-06, BR-07) | 2 | BR-06: `[EXPLICIT]`; BR-07: `[STRONGLY INFERRED]` |
| Grandfathered exception (BR-08, BR-09) | 2 | `[EXPLICIT]`; product-max interaction `[UNRESOLVED]` (C-02) |
| Merchant constraints (BR-10, BR-11, BR-12) | 3 | `[EXPLICIT]`; regulatory vs. policy intent `[UNRESOLVED]` |
| Risk adjustments (BR-13, BR-14, BR-15) | 3 | Behavior `[EXPLICIT]`; risk-score direction intent `[STRONGLY INFERRED]` (C-06) |
| Fallback behavior (BR-16-RISK, BR-17-RISK) | 2 | BR-16: `[EXPLICIT]`; BR-17: `[STRONGLY INFERRED]` (MQ wrapper absent) |
| Product maximum ceiling (BR-18) | 1 | `[EXPLICIT]`; grandfathered-ceiling intent `[UNRESOLVED]` (C-02) |
| Authorization decision (BR-19, BR-20, BR-21, BR-22) | 4 | BR-19–21: `[EXPLICIT]`; BR-22: `[STRONGLY INFERRED]` (AUTHLOG stub) |
| Ordering and precedence (BR-23, BR-24, BR-25) | 3 | `[EXPLICIT]` |

The behavioral constraint for any downstream stage is: **preserve externally observable current behavior across all 25 rules unless a human-approved business policy change explicitly authorizes a difference.**

---

## 10. Proof Obligations (Disposition-Independent)

The following proof obligations apply regardless of which disposition is selected and must be satisfied before any modified component reaches production.

1. **Behavioral characterization:** Demonstrate equivalence across all 25 business rules including their fallback paths — policy-lookup failure (BR-04), MQ fallback score 650 (BR-16-RISK), grandfathered override (BR-08), and product-max ceiling (BR-18). Must account for the confidence classifications of all rules, not only the 21 proven ones.

2. **Test-authority resolution (KU-13):** The conflict between `tests/golden-master-cases.yaml` and `tests/golden-master/cases.yaml` on the high-risk branch must be resolved by a human governance decision before characterization tests can be declared authoritative. Source code (`LIMUTIL.cbl:33-34` ×0.80) aligns with the structured test file's 4,000.00 expectation, but this alignment is evidence, not a formal resolution.

3. **MQ fallback verification:** Demonstrate that when `LC-RISK-AVAILABLE ≠ 'Y'`, `RISKFBK` reliably produces `LC-RISK-SCORE = 650` and that authorization output is equivalent to a live 650-score response. This is `[EXPLICIT]` in source but must be verified in any modified path.

4. **Db2 policy query concurrency:** If any change touches `LIMITPOL` or `ATLAS_LIMIT_POLICY`, demonstrate that `SQLCODE -811` cannot occur in production, or that the silent fallback is the intended behavior for duplicate effective-date rows (KU-07, C-05 — business confirmation required).

5. **VSAM I/O viability:** Demonstrate that `EXCEPT01` native COBOL FILE-CONTROL executes correctly under the CICS runtime with appropriate compilation options (KU-12).

6. **Latency/performance:** Latency, SLA, and throughput values are UNKNOWN from frozen evidence. Any production-readiness criteria for these dimensions must be established as a proof obligation in PLAN through operational documentation or runtime measurement — they cannot be assumed or inherited from this record.

---

## 11. Unresolved Questions Requiring Human SME Input

The following questions materially affect any downstream stage. They are not answered here; they require human subject-matter expert confirmation.

| # | Question | Related Unknown/Conflict | Priority |
|---|---|---|---|
| 1 | Should the product-maximum ceiling apply to grandfathered exception limits, or should grandfathered accounts be exempt? | C-02 | **HIGH** — affects correctness of exception override |
| 2 | Should `ER-EXPIRY-DATE` be enforced at authorization time, or is expiry managed exclusively by the batch reconciliation process? | C-03, KU-06 | **HIGH** — expired exceptions may be granting unauthorized limits |
| 3 | What is the business intent of the 1,000.00 policy-lookup fallback floor? Is it a deliberate conservative floor during DB2 outages? | C-05, KU-07 | **HIGH** — silent failure affects customers |
| 4 | Which golden-master test file is authoritative for the high-risk branch (risk score ≥ 800)? | KU-13, C-01 | **HIGH** — blocks PROVE stage |
| 5 | Are the MCC 7995 and 6051 caps regulatory/contractual requirements (correctly hardcoded) or operational policy values intended to be configurable? | BR-10, BR-11 | **MEDIUM** — determines scope of any REFACTOR change to `MERCHVAL` |
| 6 | Should `CUSTRSK` be bypassed for accounts already identified as grandfathered? | KU-17 | **MEDIUM** — design consideration, not behavioral |
| 7 | Is `AS-RISK-MODE` in `AUTH-RESPONSE` intended to be populated, and do downstream systems read it? | C-04, KU-09 | **MEDIUM** |
| 8 | Is `LIMITREF.jcl` currently operational in production? | KU-10 | **LOW** |

---

## 12. Human Decision Gate

As mandated by the Agentic Strangler governance and the DECIDE playbook:

```yaml
Human Decision Owner: REQUIRED — NOT YET ASSIGNED
Approval Status: PENDING HUMAN DECISION
Date Assigned: PENDING
Decision Recorded: NONE
```

**Mandatory governance rule:** No progression to PLAN, no implementation planning, and no modification of application source code is permitted until a named human decision owner is assigned and explicitly records an approved disposition.

---

## 13. DECIDE Stage Exit Assessment

### Evidence sufficiency

The frozen UNDERSTAND evidence pack (`runs/atlaspay/understand/run-001/`) provides sufficient evidence for a human decision. The call chain, interfaces, data structures, 25 cataloged business rules, known unknowns, and behavioral conflicts are grounded in direct source-code evidence.

The evidence is **not complete or unambiguous** where documented known unknowns and conflicts remain open:
- 18 known unknowns are carried forward, of which KU-01, KU-04, and KU-12 are rated HIGH severity.
- 6 behavioral conflicts (C-01 through C-06) are `[UNRESOLVED]`.
- 4 of 25 business rules are `[STRONGLY INFERRED]` or `[UNRESOLVED]`.

The evidence is sufficient for a human to choose a disposition and set the scope for PLAN. It is not sufficient to begin implementation without first resolving the proof obligations and known unknowns identified above for the chosen disposition.

### Stage exit status

**DECIDE Stage Exit: BLOCKED PENDING HUMAN APPROVAL.**

**Next permitted action:** Assignment of a named Human Decision Owner to review this Modernization Decision Record and record a binding disposition at the Human Decision Gate.

**This record does not proceed to PLAN.**
