# Slice 0 Characterization Baseline

**Experiment:** AtlasPay TRANSFORM Run 004
**Capability:** Dynamic Transaction Limit
**Stage:** TRANSFORM — Slice 0 (Evidence-Establishment Only)
**Playbook:** `framework-assets/playbooks/controlled-transform/playbook.yaml` v0.3.6
**Source Modification Performed:** FALSE
**Date Produced:** 2026-09-19

---

## 1. Scope and Governance

### 1.1 Authoritative Governance Inputs

| Document | Role | Status |
|---|---|---|
| `runs/atlaspay/plan/run-003/02-implementation-plan-reviewed.md` | Reviewed implementation plan defining six slices and all gate classifications | Verified — read in full |
| `runs/atlaspay/plan/run-003/03-human-plan-gate.md` | Human plan approval gate | APPROVED WITH CONDITIONS — Suman Devarasetti, 2026-09-19 |
| `runs/atlaspay/transform/run-004/00-ku13-authority-decision.md` | KU-13 synthetic regression-baseline authority decision | APPROVED — Suman Devarasetti |
| `framework-assets/playbooks/controlled-transform/playbook.yaml` | Controlled transform governance playbook | v0.3.6 — read in full |

### 1.2 Frozen UNDERSTAND Evidence Inputs

| Document | Role | Status |
|---|---|---|
| `runs/atlaspay/understand/run-001/03-business-rules-raw.md` | 25-rule business rule catalog with source citations | Verified — read in full |
| `runs/atlaspay/understand/run-001/04-known-unknowns-raw.md` | 18-item known unknowns register | Verified — read in full |
| `runs/atlaspay/understand/run-001/06-current-state-evidence-pack.md` | Current-state evidence pack | Verified — read in full |

### 1.3 Source Artifacts Inspected (Read-Only)

| Artifact | Inspection Status |
|---|---|
| `src/cobol/LIMUTIL.cbl` | Read — 48 lines |
| `src/cobol/ATLAUTH.cbl` | Read — 48 lines |
| `src/cobol/TRNLIM01.cbl` | Read — 24 lines |
| `src/cobol/LIMITPOL.cbl` | Read — 35 lines |
| `src/cobol/EXCEPT01.cbl` | Read — 39 lines |
| `src/cobol/TMPCTRL.cbl` | Read — 16 lines |
| `src/cobol/MERCHVAL.cbl` | Read — 20 lines |
| `src/cobol/CUSTRSK.cbl` | Read — 26 lines |
| `src/cobol/RISKFBK.cbl` | Read — 14 lines |
| `tests/golden-master/cases.yaml` | Read — 106 lines, 12 cases |
| `tests/golden-master-cases.yaml` | Read — 18 lines, 3 cases |

### 1.4 Slice 0 Constraints

- **No application source code was modified.** This constraint is absolute for Slice 0.
- **No test artifacts were modified, merged, or deleted.**
- **No Slice 1 activity was initiated.**
- **No deployment activity was performed.**

---

## 2. KU-13 Authority Resolution

### 2.1 The Conflict

KU-13 arises from a direct contradiction between two test artifacts on the expected behavior of the high-risk branch in [`LIMUTIL.cbl`](src/cobol/LIMUTIL.cbl).

**OBSERVED SOURCE BEHAVIOR**

Source: [`src/cobol/LIMUTIL.cbl:33–34`](src/cobol/LIMUTIL.cbl:33)

```cobol
IF LC-RISK-SCORE >= 800
   COMPUTE WS-CANDIDATE-LIMIT = WS-CANDIDATE-LIMIT * 0.80
```

The source is unambiguous. A risk score at or above 800 causes the candidate limit to be multiplied by 0.80 — a **20% reduction**. For a GLD1/US account with base limit 5000.00 and risk score 850:

```
5000.00 × 0.80 = 4000.00
```

This behavior is confirmed by the MQ message contract (`mq/message-contracts.md:7`), which states *"higher means more restrictive in this example"*.

**CONFLICTING TEST ARTIFACT EXPECTATIONS**

| Test Artifact | Case ID | Risk Score | Expected Limit | Implied Behavior |
|---|---|---|---|---|
| `tests/golden-master/cases.yaml` (GM-007) | `GM-007` | 850 | **4000.00** | High score → 20% reduction. Consistent with LIMUTIL source. |
| `tests/golden-master-cases.yaml` | `high-risk-score-increase` | 825 | **6000.00** | High score → limit *increase* to 6000. **Contradicts** LIMUTIL source. GLD1/US base is 5000; 6000 > 5000. No arithmetic path in LIMUTIL produces 6000 from a GLD1/US 5000 base with any multiplier. This expectation is mathematically unsupported by the current source. |

The case label `high-risk-score-increase` in `tests/golden-master-cases.yaml` and the expected value of 6000.00 (which exceeds the GLD1/US base of 5000.00) indicate the file was authored under the assumption that a high risk score *increases* the limit — the opposite of the current implementation. No arithmetic path in `LIMUTIL.cbl` can produce an output of 6000.00 from a GLD1/US baseline of 5000.00.

**HUMAN REGRESSION-BASELINE DECISION**

Source: `runs/atlaspay/transform/run-004/00-ku13-authority-decision.md`

> Decision Owner: Suman Devarasetti
> Status: APPROVED
> Resolution: `risk_score >= 800 -> candidate * 0.80`

The human authority decision establishes the **current source behavior** (×0.80 reduction) as the authoritative regression expectation for the synthetic AtlasPay estate. The GM-007 case in `tests/golden-master/cases.yaml` (expected_limit: 4000.00 for risk=850, GLD1/US base 5000) is therefore the regression oracle for this behavior. The `high-risk-score-increase` case in `tests/golden-master-cases.yaml` is retained as historical evidence but is **not** the regression oracle.

**UNRESOLVED REAL-WORLD BUSINESS INTENT**

The authority decision explicitly states: *"It does not assert that the current source represents real-world regulatory, card-network, customer, or enterprise business policy."*

The business rationale for using 800 as the threshold, 0.80 as the multiplier, and for the counter-intuitive direction (higher score = more restrictive) is not documented in any workspace artifact. Whether this is correct real-world policy, a legacy design choice, or a synthetic teaching construct is **not established by this decision and remains unresolved** as a real-world business intent question.

**KU-13 resolution status:**

| Dimension | Status |
|---|---|
| Observed source behavior | CONFIRMED: `risk_score >= 800 → candidate × 0.80` (`LIMUTIL.cbl:33-34`) |
| Synthetic regression oracle | ESTABLISHED: `expected_limit = candidate × 0.80` (GM-007 is authoritative) |
| Conflicting test artifact | RETAINED AS HISTORICAL EVIDENCE: `high-risk-score-increase` in `tests/golden-master-cases.yaml` |
| Real-world business intent | UNRESOLVED — not claimed by this decision |
| Source change authorized | FALSE |
| KU-13 closed for synthetic regression | YES |

---

## 3. Conflicting Test Artifact Analysis

### 3.1 Artifact Profiles

| Property | `tests/golden-master/cases.yaml` | `tests/golden-master-cases.yaml` |
|---|---|---|
| Case count | 12 | 3 |
| Case ID format | Structured sequential IDs (`GM-001` through `GM-012`) | Free-text identifiers |
| Coverage breadth | Broad: covers base limit, grandfathered exception, jurisdiction cap, temp control, MCC caps, risk adjustments (both directions), fallback, product-max ceiling, approve/decline decision | Narrow: covers only baseline neutral, high-risk, and grandfathered |
| Account ID specificity | Uses specific synthetic account IDs (e.g. `SYN000000001`, `SYN000000003`) | Uses abbreviated account ID (`SYN0001`) for grandfathered case; none for others |
| Risk semantics consistency | Internally consistent with LIMUTIL source | Internally inconsistent: `baseline-us-gold` (725 → 5000) is consistent; `high-risk-score-increase` (825 → 6000) contradicts source |
| Internal consistency | HIGH | MIXED — two of three cases are consistent; one contradicts source |

### 3.2 Case-by-Case Cross-Reference

#### Overlapping / Comparable Cases

| `cases.yaml` case | `golden-master-cases.yaml` case | Comparison | Status |
|---|---|---|---|
| GM-001 (GLD1/US, risk=650, expected=5000) | `baseline-us-gold` (GLD1/US, risk=725, expected=5000) | Both expect 5000 for GLD1/US with neutral risk. Risk scores differ (650 vs 725) but both are in the neutral band (500–799). Outputs agree. | CONSISTENT — different inputs, same expected output band |
| GM-007 (GLD1/US, risk=850, expected=4000) | `high-risk-score-increase` (GLD1/US, risk=825, expected=6000) | Both use GLD1/US with high risk score. Expected outputs are **directly contradictory**: 4000 vs 6000. LIMUTIL source produces 4000 for risk≥800. | **CONFLICT — KU-13 materializes here** |
| GM-002 (SYN000000001, grandfathered=true, expected=7500) | `grandfathered-exception` (SYN0001, grandfathered=true, expected=7500) | Both expect 7500 for a grandfathered account. Account IDs differ (`SYN000000001` vs `SYN0001`). Expected limits agree. | CONSISTENT — note: `SYN0001` is not a standard 12-char synthetic ID; unclear if this maps to same account |

#### Cases Unique to `tests/golden-master/cases.yaml`

The following 9 cases have no equivalent in `tests/golden-master-cases.yaml`:

| Case ID | Behavior Tested |
|---|---|
| GM-003 | Jurisdiction lower cap (GLD1/CA, juris=4000) |
| GM-004 | Temporary customer control lowers limit |
| GM-005 | MCC 7995 cap = 1000 |
| GM-006 | MCC 6051 cap = 2000 |
| GM-008 | Low risk score (<500) → ×0.70 reduction |
| GM-009 | MQ risk unavailable → fallback score 650 |
| GM-010 | Product maximum ceiling (PLT1/US, cap at 15000) |
| GM-011 | Amount above limit → declined (Decision: D) |
| GM-012 | Amount at limit → approved (Decision: A) |

#### Cases Unique to `tests/golden-master-cases.yaml`

No case in `tests/golden-master-cases.yaml` is entirely unique in subject matter — all three subjects (neutral baseline, high-risk, grandfathered) have analog cases in `tests/golden-master/cases.yaml`. The `high-risk-score-increase` case is unique only in its **conflicting expected value**, not in its subject.

### 3.3 Unsupported Expectations

> **Terminology note:** Descriptive labels attached to MCC cases in test artifacts are test-authored labels. The framework treats the source-grounded behavior as the MCC code plus its observed numeric cap unless separate business evidence establishes broader semantics.

| Artifact | Case ID | Expected Value | Assessment |
|---|---|---|---|
| `tests/golden-master-cases.yaml` | `high-risk-score-increase` | `expected_limit: 6000.00` | **UNSUPPORTED.** No arithmetic path in `LIMUTIL.cbl` produces 6000.00 from a GLD1/US base of 5000.00. The value exceeds the GLD1/US base limit. The 0.80 multiplier produces 4000. No multiplier in the current code produces a value above the pre-risk candidate. |
| `tests/golden-master-cases.yaml` | `grandfathered-exception` | `account_id: SYN0001` | **AMBIGUOUS.** The VSAM synthetic exceptions file (`vsam/synthetic-exceptions.csv`) uses full 12-character IDs (`SYN000000001`, `SYN000000777`, `SYN000000888`). `SYN0001` does not match any entry. Whether this maps to `SYN000000001` by intent or is a data error cannot be confirmed from workspace evidence alone. |

### 3.4 Coverage Gaps Relative to the 25-Rule Catalog

The following business rules have **full or partial characterization gaps** across the two existing test artifacts:

| Rule ID | Description | Coverage Status |
|---|---|---|
| BR-01 | Blank account ID → declined (ACCT) | NOT COVERED in either test artifact |
| BR-02 | Blank MCC → declined (MCC) | NOT COVERED in either test artifact |
| BR-04 | Policy fallback floor of 1000.00 | NOT COVERED in either test artifact |
| BR-07 | Temp-control applied before grandfathered exception | NOT COVERED directly (implicit in GM-004 ordering, not isolated) |
| BR-14 | Low risk (<500) → ×0.70 | Covered by GM-008 only; NOT COVERED in `golden-master-cases.yaml` |
| BR-16-RISK | MQ unavailable → fallback 650 | Covered by GM-009 only; NOT COVERED in `golden-master-cases.yaml` |
| BR-17-RISK | Risk score sourced from MQ per account | NOT COVERED by either artifact (MQRSKGET is external and absent) |
| BR-21 | Applied limit recorded unconditionally | NOT COVERED in either artifact |
| BR-22 | Audit on all paths | NOT COVERED in either artifact (AUTHLOG is stub) |
| BR-23 | Validation guards precede limit calc | NOT COVERED in either artifact |
| BR-25 | Fixed input-gathering sequence | NOT COVERED directly |

No test artifacts were deleted, modified, merged, or renamed.

---

## 4. Business Rule Characterization Inventory

The following table catalogs all 25 business rules from the frozen UNDERSTAND evidence. Source citations are from the canonical UNDERSTAND artifact `runs/atlaspay/understand/run-001/03-business-rules-raw.md`, cross-referenced to the verified source files.

### Rule: BR-01 — Account identifier must be present

| Field | Value |
|---|---|
| **Rule ID** | BR-01 |
| **Capability / Behavior** | An authorization request with a blank `AR-ACCOUNT-ID` is declined before limit calculation. Decision: `D`, Reason: `ACCT`. |
| **Source Evidence** | [`src/cobol/ATLAUTH.cbl:16-21`](src/cobol/ATLAUTH.cbl:16) — `CALL 'ACCTVAL'`; if `WS-ACCOUNT-VALID NOT = 'Y'`: MOVE 'D', MOVE 'ACCT', PERFORM WRITE-AUDIT, GOBACK |
| **Available Test Evidence** | NOT COVERED in either test artifact |
| **Expected Current Behavior** | Blank `AR-ACCOUNT-ID` → immediate GOBACK with Decision=D, Reason=ACCT |
| **Confidence Classification** | HIGH — behavior is explicit and unambiguous in source |
| **Directly Covered by Test** | NO |
| **Conflicts / Known Unknowns** | Validation is presence-only (checks for SPACES). No semantic/format validation. `ATLAS_ACCOUNT_PRODUCT` not queried. The reason code in ATLAUTH is `'ACCT'`; the UNDERSTAND artifact notes it as `'INVA'` — minor discrepancy in naming, but source shows `'ACCT'`. |
| **Regression Invariant Ready** | PARTIAL — behavior is source-explicit but no test covers it |

---

### Rule: BR-02 — Merchant Category Code must be present

| Field | Value |
|---|---|
| **Rule ID** | BR-02 |
| **Capability / Behavior** | An authorization request with a blank `AR-MERCHANT-CATEGORY` is declined before limit calculation. Decision: `D`, Reason: `MCC ` (4 chars with trailing space). |
| **Source Evidence** | [`src/cobol/ATLAUTH.cbl:24-29`](src/cobol/ATLAUTH.cbl:24) — `CALL 'MERCHCHK'`; if `WS-MERCHANT-VALID NOT = 'Y'`: MOVE 'D', MOVE 'MCC ', PERFORM WRITE-AUDIT, GOBACK |
| **Available Test Evidence** | NOT COVERED in either test artifact |
| **Expected Current Behavior** | Blank `AR-MERCHANT-CATEGORY` → immediate GOBACK with Decision=D, Reason=`MCC ` |
| **Confidence Classification** | HIGH — explicit in source |
| **Directly Covered by Test** | NO |
| **Conflicts / Known Unknowns** | Presence-only validation. Non-blank but unrecognized MCCs pass this guard and proceed to MCC cap logic. |
| **Regression Invariant Ready** | PARTIAL — behavior source-explicit but not test-covered |

---

### Rule: BR-03 — Base limit from product and jurisdiction policy

| Field | Value |
|---|---|
| **Rule ID** | BR-03 |
| **Capability / Behavior** | Base limit, product max, and jurisdiction limit are retrieved from `ATLAS_LIMIT_POLICY` by `(PRODUCT_CODE, JURISDICTION, ACTIVE_FLAG='Y')`. |
| **Source Evidence** | [`src/cobol/LIMITPOL.cbl:16-28`](src/cobol/LIMITPOL.cbl:16) — `EXEC SQL SELECT BASE_LIMIT, PRODUCT_MAX, JURIS_LIMIT INTO ... FROM ATLAS_LIMIT_POLICY WHERE PRODUCT_CODE = :AR-PRODUCT-CODE AND JURISDICTION = :AR-JURISDICTION AND ACTIVE_FLAG = 'Y'` |
| **Available Test Evidence** | GM-001 (GLD1/US → base 5000), GM-003 (GLD1/CA → juris 4000), GM-010 (PLT1/US → max 15000) |
| **Expected Current Behavior** | GLD1/US: BASE=5000, PRODUCT_MAX=9000, JURIS=5000. PLT1/US: BASE=10000, PRODUCT_MAX=15000, JURIS=10000. GLD1/CA: BASE=4500, PRODUCT_MAX=8000, JURIS=4000. |
| **Confidence Classification** | HIGH for known seed-data rows; MEDIUM for multi-row risk (KU-07 unresolved) |
| **Directly Covered by Test** | YES — GM-001, GM-003, GM-010 |
| **Conflicts / Known Unknowns** | KU-07: `EFFECTIVE_DATE` in PK but not in WHERE clause. Multiple active rows per `(PRODUCT_CODE, JURISDICTION)` would produce SQLCODE -811 and silent fallback to BR-04. `ACTIVE_FLAG` management mechanism not visible. |
| **Regression Invariant Ready** | YES for known seed-data inputs; CONDITIONAL on runtime DB2 availability |

---

### Rule: BR-04 — Policy failure fallback to floor of 1,000.00

| Field | Value |
|---|---|
| **Rule ID** | BR-04 |
| **Capability / Behavior** | Any non-zero SQLCODE from the policy SELECT causes silent fallback: `LC-BASE-LIMIT = LC-PRODUCT-MAX = LC-JURIS-LIMIT = 1000.00`. Authorization proceeds; no error flag is set. |
| **Source Evidence** | [`src/cobol/LIMITPOL.cbl:29-33`](src/cobol/LIMITPOL.cbl:29) — `ELSE MOVE 1000.00 TO LC-BASE-LIMIT / LC-PRODUCT-MAX / LC-JURIS-LIMIT` |
| **Available Test Evidence** | NOT COVERED in either test artifact |
| **Expected Current Behavior** | Any SQLCODE ≠ 0 → all three limit fields set to 1000.00 |
| **Confidence Classification** | HIGH for the mechanical behavior; LOW for business intent (C-05: 1000.00 value undocumented) |
| **Directly Covered by Test** | NO |
| **Conflicts / Known Unknowns** | C-05: Whether 1000.00 represents an intentional conservative floor or an arbitrary default is unresolved. Silent failure — callers cannot detect fallback activation. |
| **Regression Invariant Ready** | PARTIAL — behavior explicit but not test-covered; C-05 unresolved for intent |

---

### Rule: BR-05 — Jurisdiction cap constrains base limit

| Field | Value |
|---|---|
| **Rule ID** | BR-05 |
| **Capability / Behavior** | If `LC-JURIS-LIMIT > 0` and `LC-JURIS-LIMIT < WS-CANDIDATE-LIMIT`, candidate is reduced to `LC-JURIS-LIMIT`. |
| **Source Evidence** | [`src/cobol/LIMUTIL.cbl:15-18`](src/cobol/LIMUTIL.cbl:15) — `IF LC-JURIS-LIMIT > 0 AND LC-JURIS-LIMIT < WS-CANDIDATE-LIMIT MOVE LC-JURIS-LIMIT TO WS-CANDIDATE-LIMIT` |
| **Available Test Evidence** | GM-003 (GLD1/CA: JURIS=4000 < BASE=4500 → candidate=4000) |
| **Expected Current Behavior** | Juris cap is applied when positive and lower than current candidate |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | YES — GM-003 |
| **Conflicts / Known Unknowns** | Zero juris-limit treated as "no cap." Under fallback (BR-04), juris=base=1000 so cap has no effect. |
| **Regression Invariant Ready** | YES — for GM-003 conditions |

---

### Rule: BR-06 — Customer temporary control cap

| Field | Value |
|---|---|
| **Rule ID** | BR-06 |
| **Capability / Behavior** | If `AR-TEMP-CONTROL-AMT > 0`, `LC-TEMP-LIMIT = AR-TEMP-CONTROL-AMT`; otherwise `LC-TEMP-LIMIT = 9999999.99` (sentinel = no cap). |
| **Source Evidence** | [`src/cobol/TMPCTRL.cbl:10-14`](src/cobol/TMPCTRL.cbl:10) |
| **Available Test Evidence** | GM-001 (temp_control=0 → no effect), GM-004 (temp_control=2500 → expected=2500) |
| **Expected Current Behavior** | Positive temp-control amount becomes the cap; zero/absent means no cap |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | YES — GM-001, GM-004 |
| **Conflicts / Known Unknowns** | Population mechanism of `AR-TEMP-CONTROL-AMT` is unknown (KU-02 related). Negative values would also set the sentinel — not separately validated. |
| **Regression Invariant Ready** | YES — for GM-001 and GM-004 conditions |

---

### Rule: BR-07 — Temporary cap applied before grandfathered exception

| Field | Value |
|---|---|
| **Rule ID** | BR-07 |
| **Capability / Behavior** | In LIMUTIL, temp-control cap (Step 3) is applied before the grandfathered override (Step 4). However, when grandfathered=Y, the override replaces all prior results outright — so temp-cap ordering has no observable effect on the grandfathered path. |
| **Source Evidence** | [`src/cobol/LIMUTIL.cbl:25-31`](src/cobol/LIMUTIL.cbl:25) — temp cap at lines 25-28, grandfathered override at lines 30-31 |
| **Available Test Evidence** | GM-004 (temp control case, non-grandfathered). No test combines temp-control with grandfathered. |
| **Expected Current Behavior** | Temp cap is structurally ordered before grandfathered override but is materially irrelevant on the grandfathered path |
| **Confidence Classification** | MEDIUM — ordering is observable, business rationale is inferred |
| **Directly Covered by Test** | PARTIAL — GM-004 covers temp cap; no test isolates the ordering interaction |
| **Conflicts / Known Unknowns** | None active; ordering is structural artifact |
| **Regression Invariant Ready** | PARTIAL — GM-004 covers the non-grandfathered path; the combined temp+grandfathered interaction is not tested |

---

### Rule: BR-08 — Grandfathered exception replaces all other limit calculations

| Field | Value |
|---|---|
| **Rule ID** | BR-08 |
| **Capability / Behavior** | If `LC-GRANDFATHERED = 'Y'`, `WS-CANDIDATE-LIMIT := LC-EXCEPTION-LIMIT`. This replaces the results of all Steps 1–4. Risk adjustments (Steps 5–6) are also skipped (ELSE branch). |
| **Source Evidence** | [`src/cobol/EXCEPT01.cbl:26-35`](src/cobol/EXCEPT01.cbl:26), [`src/cobol/LIMUTIL.cbl:30-31`](src/cobol/LIMUTIL.cbl:30) |
| **Available Test Evidence** | GM-002 (SYN000000001, exception=7500, expected=7500) |
| **Expected Current Behavior** | Active grandfathered account receives `LC-EXCEPTION-LIMIT` as the pre-ceiling candidate |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | YES — GM-002 |
| **Conflicts / Known Unknowns** | C-02: Exception override applied before product-max ceiling. SYN000000777 (exception=12000) with GLD1/US product-max=9000 would be capped to 9000 — no test for this. Whether grandfathered accounts should be exempt from product-max is unresolved. |
| **Regression Invariant Ready** | YES for GM-002 conditions; C-02 remains a gate for the limit-exceed scenario |

---

### Rule: BR-09 — Grandfathered requires ER-ACTIVE='Y'

| Field | Value |
|---|---|
| **Rule ID** | BR-09 |
| **Capability / Behavior** | Exception record in VSAM activates grandfathered override only if `ER-ACTIVE = 'Y'`. Records with `ER-ACTIVE = 'N'` are read but ignored. |
| **Source Evidence** | [`src/cobol/EXCEPT01.cbl:32-35`](src/cobol/EXCEPT01.cbl:32) — `IF ER-ACTIVE = 'Y' MOVE 'Y' TO LC-GRANDFATHERED` |
| **Available Test Evidence** | GM-002 (active=Y, exception applies). Seed data: SYN000000888 has active=N. No test covers the active=N case. |
| **Expected Current Behavior** | Active=N record → LC-GRANDFATHERED remains 'N'; no override applied |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | PARTIAL — active=Y path covered; active=N path NOT COVERED by any test |
| **Conflicts / Known Unknowns** | KU-05, KU-06, C-03: `ER-EXPIRY-DATE` never evaluated by EXCEPT01. Whether an expired-but-active record should be treated differently is unresolved. `EXCREC01` (reconciliation) is a stub — the mechanism that sets `ER-ACTIVE = 'N'` upon expiry is unknown. |
| **Regression Invariant Ready** | PARTIAL — active=Y path ready; active=N path and expiry behavior unresolved |

---

### Rule: BR-10 — MCC 7995 cap = 1,000.00

| Field | Value |
|---|---|
| **Rule ID** | BR-10 |
| **Capability / Behavior** | Merchant Category Code `7995` causes `LC-MCC-LIMIT = 1000.00`. LIMUTIL applies this cap if lower than current candidate. |
| **Source Evidence** | [`src/cobol/MERCHVAL.cbl:12-13`](src/cobol/MERCHVAL.cbl:12), [`src/cobol/LIMUTIL.cbl:20-23`](src/cobol/LIMUTIL.cbl:20) |
| **Available Test Evidence** | GM-005 (MCC=7995, expected=1000) |
| **Expected Current Behavior** | MCC 7995 → candidate capped at 1000.00 |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | YES — GM-005 |
| **Conflicts / Known Unknowns** | Value is hardcoded; not configurable without code change. Whether it is regulatory/contractual or policy-driven is unresolved (Slice 3 gate). |
| **Regression Invariant Ready** | YES |

---

### Rule: BR-11 — MCC 6051 cap = 2,000.00

| Field | Value |
|---|---|
| **Rule ID** | BR-11 |
| **Capability / Behavior** | Merchant Category Code `6051` causes `LC-MCC-LIMIT = 2000.00`. LIMUTIL applies this cap if lower than current candidate. |
| **Source Evidence** | [`src/cobol/MERCHVAL.cbl:14-15`](src/cobol/MERCHVAL.cbl:14), [`src/cobol/LIMUTIL.cbl:20-23`](src/cobol/LIMUTIL.cbl:20) |
| **Available Test Evidence** | GM-006 (MCC=6051, expected=2000) |
| **Expected Current Behavior** | MCC 6051 → candidate capped at 2000.00 |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | YES — GM-006 |
| **Conflicts / Known Unknowns** | Same as BR-10: hardcoded; governance intent unresolved. |
| **Regression Invariant Ready** | YES |

---

### Rule: BR-12 — All other MCCs carry no merchant-imposed cap

| Field | Value |
|---|---|
| **Rule ID** | BR-12 |
| **Capability / Behavior** | Any MCC other than `7995` or `6051` results in `LC-MCC-LIMIT = 9999999.99` (sentinel). This value is always ≥ any realistic candidate so the condition `LC-MCC-LIMIT < WS-CANDIDATE-LIMIT` is never satisfied — effectively no cap. |
| **Source Evidence** | [`src/cobol/MERCHVAL.cbl:10`](src/cobol/MERCHVAL.cbl:10) (default), [`src/cobol/MERCHVAL.cbl:16-17`](src/cobol/MERCHVAL.cbl:16) (WHEN OTHER: CONTINUE) |
| **Available Test Evidence** | GM-001 (MCC=5411, expected=5000), GM-007, GM-008 (both MCC=5411) |
| **Expected Current Behavior** | MCC≠7995, ≠6051 → no MCC cap applied |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | YES — GM-001, GM-007, GM-008 (all use MCC=5411) |
| **Conflicts / Known Unknowns** | None — sentinel mechanism is clear |
| **Regression Invariant Ready** | YES |

---

### Rule: BR-13 — Risk score ≥ 800 → ×0.80 (KU-13 subject)

| Field | Value |
|---|---|
| **Rule ID** | BR-13 |
| **Capability / Behavior** | `IF LC-RISK-SCORE >= 800 COMPUTE WS-CANDIDATE-LIMIT = WS-CANDIDATE-LIMIT * 0.80`. Applied only on the non-grandfathered path. |
| **Source Evidence** | [`src/cobol/LIMUTIL.cbl:33-34`](src/cobol/LIMUTIL.cbl:33) |
| **Available Test Evidence** | GM-007 (risk=850, GLD1/US, expected=4000.00 — oracle). `high-risk-score-increase` (risk=825, expected=6000 — **conflicting, not oracle**). |
| **Expected Current Behavior** | `risk_score >= 800` → candidate × 0.80. For GLD1/US (base=5000): 5000 × 0.80 = 4000.00 |
| **Confidence Classification** | HIGH for source behavior; the human authority decision resolves the test conflict |
| **Directly Covered by Test** | YES — GM-007 is the authoritative oracle |
| **Conflicts / Known Unknowns** | KU-13 resolved for synthetic regression baseline. Real-world business intent unresolved. C-06: counter-intuitive direction (higher score = tighter limit). |
| **Regression Invariant Ready** | YES — per human authority decision |

---

### Rule: BR-14 — Risk score < 500 → ×0.70

| Field | Value |
|---|---|
| **Rule ID** | BR-14 |
| **Capability / Behavior** | `IF LC-RISK-SCORE < 500 COMPUTE WS-CANDIDATE-LIMIT = WS-CANDIDATE-LIMIT * 0.70`. Applied only on non-grandfathered path. |
| **Source Evidence** | [`src/cobol/LIMUTIL.cbl:36-37`](src/cobol/LIMUTIL.cbl:36) |
| **Available Test Evidence** | GM-008 (risk=450, GLD1/US, expected=3500.00 — 5000 × 0.70 = 3500) |
| **Expected Current Behavior** | `risk_score < 500` → candidate × 0.70. For GLD1/US: 5000 × 0.70 = 3500.00 |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | YES — GM-008 |
| **Conflicts / Known Unknowns** | C-06: intentionally counter-intuitive direction acknowledged in GM-008 description. Business intent unresolved but GM-008 labels it intentional for this synthetic estate. |
| **Regression Invariant Ready** | YES |

---

### Rule: BR-15 — Risk score 500–799 → no adjustment

| Field | Value |
|---|---|
| **Rule ID** | BR-15 |
| **Capability / Behavior** | Risk scores in [500, 799] inclusive produce no candidate adjustment. The code has no branch for this range — the absence of both conditions means the candidate passes through unchanged. |
| **Source Evidence** | [`src/cobol/LIMUTIL.cbl:32-40`](src/cobol/LIMUTIL.cbl:32) — the ELSE/no-action path between the two risk branches |
| **Available Test Evidence** | GM-001 (risk=650, expected=5000), GM-009 (fallback=650, expected=5000). `baseline-us-gold` in `golden-master-cases.yaml` (risk=725, expected=5000). |
| **Expected Current Behavior** | 500 ≤ risk_score ≤ 799 → no change to candidate |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | YES — GM-001, GM-009 |
| **Conflicts / Known Unknowns** | Boundary asymmetry: score=500 → neutral; score=800 → reduced. Whether boundary placement is deliberate is unresolved. |
| **Regression Invariant Ready** | YES |

---

### Rule: BR-16-RISK — MQ unavailable → fallback score 650

| Field | Value |
|---|---|
| **Rule ID** | BR-16-RISK |
| **Capability / Behavior** | When `CUSTRSK` sets `LC-RISK-AVAILABLE = 'N'`, `TRNLIM01` calls `RISKFBK`, which sets `LC-RISK-SCORE = 650`. Authorization proceeds with this deterministic fallback. |
| **Source Evidence** | [`src/cobol/TRNLIM01.cbl:18-20`](src/cobol/TRNLIM01.cbl:18), [`src/cobol/RISKFBK.cbl:10-12`](src/cobol/RISKFBK.cbl:10) |
| **Available Test Evidence** | GM-009 (risk_available=false, fallback=650, expected=5000) |
| **Expected Current Behavior** | MQ unavailable → score 650 → falls in neutral band → no risk adjustment → same result as 650-score live call |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | YES — GM-009 |
| **Conflicts / Known Unknowns** | C-04: timeout and hard-error produce identical fallback. `AS-RISK-MODE` never populated. Fallback result is mathematically identical to a live 650-score response — whether this equivalence is intentional is unresolved. |
| **Regression Invariant Ready** | YES |

---

### Rule: BR-17-RISK — Risk score sourced from MQ per account

| Field | Value |
|---|---|
| **Rule ID** | BR-17-RISK |
| **Capability / Behavior** | `CUSTRSK` initializes a `RISK-MESSAGE`, sets `RM-ACCOUNT-ID = AR-ACCOUNT-ID`, and calls `MQRSKGET`. If `RM-OK`, the returned `RM-RISK-SCORE` is used. |
| **Source Evidence** | [`src/cobol/CUSTRSK.cbl:13-24`](src/cobol/CUSTRSK.cbl:13) |
| **Available Test Evidence** | GM-007 (risk=850, test assumes live MQ), GM-008 (risk=450). Both assert specific scores — not directly testing MQ mechanics. |
| **Expected Current Behavior** | `MQRSKGET` called unconditionally; score used if `RM-OK`; fallback triggered otherwise |
| **Confidence Classification** | MEDIUM for the call structure; LOW for the MQ internals (`MQRSKGET` absent — KU-01) |
| **Directly Covered by Test** | PARTIAL — test cases assert risk scores but do not exercise MQ runtime |
| **Conflicts / Known Unknowns** | KU-01: `MQRSKGET` source absent — timeout interval, retry count, correlation mechanism all unknown. KU-17: MQ call made unconditionally even for grandfathered accounts where risk score is subsequently ignored. |
| **Regression Invariant Ready** | PARTIAL — call structure confirmed; runtime behavior unverifiable |

---

### Rule: BR-18 — Product maximum is absolute ceiling

| Field | Value |
|---|---|
| **Rule ID** | BR-18 |
| **Capability / Behavior** | `IF WS-CANDIDATE-LIMIT > LC-PRODUCT-MAX MOVE LC-PRODUCT-MAX TO WS-CANDIDATE-LIMIT`. Applied unconditionally after all prior steps, including grandfathered override. |
| **Source Evidence** | [`src/cobol/LIMUTIL.cbl:42-44`](src/cobol/LIMUTIL.cbl:42) |
| **Available Test Evidence** | GM-010 (PLT1/US, candidate=20000, product-max=15000, expected=15000) |
| **Expected Current Behavior** | Final candidate capped at `LC-PRODUCT-MAX` regardless of prior path |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | YES — GM-010 |
| **Conflicts / Known Unknowns** | C-02: grandfathered exception limit > product-max would be silently reduced. SYN000000777 (exception=12000, product-max=9000 for GLD1/US) → capped to 9000. No test covers this. Business intent of whether grandfathered accounts should be exempt is UNRESOLVED. |
| **Regression Invariant Ready** | YES for GM-010 conditions; CONDITIONAL for grandfathered-exceeds-product-max scenario |

---

### Rule: BR-19 — Amount ≤ limit → approved

| Field | Value |
|---|---|
| **Rule ID** | BR-19 |
| **Capability / Behavior** | `IF AR-AMOUNT <= LC-FINAL-LIMIT MOVE 'A' TO AS-DECISION MOVE '0000' TO AS-REASON-CODE`. Boundary is inclusive (at-limit amounts are approved). |
| **Source Evidence** | [`src/cobol/ATLAUTH.cbl:35-37`](src/cobol/ATLAUTH.cbl:35) |
| **Available Test Evidence** | GM-012 (amount=5000, limit=5000, expected_decision=A) |
| **Expected Current Behavior** | Amount ≤ final limit → Decision=A, Reason=0000 |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | YES — GM-012 |
| **Conflicts / Known Unknowns** | None |
| **Regression Invariant Ready** | YES |

---

### Rule: BR-20 — Amount > limit → declined

| Field | Value |
|---|---|
| **Rule ID** | BR-20 |
| **Capability / Behavior** | `ELSE MOVE 'D' TO AS-DECISION MOVE 'LIMT' TO AS-REASON-CODE`. |
| **Source Evidence** | [`src/cobol/ATLAUTH.cbl:38-41`](src/cobol/ATLAUTH.cbl:38) |
| **Available Test Evidence** | GM-011 (amount=5500, limit=5000, expected_decision=D) |
| **Expected Current Behavior** | Amount > final limit → Decision=D, Reason=LIMT |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | YES — GM-011 |
| **Conflicts / Known Unknowns** | None |
| **Regression Invariant Ready** | YES |

---

### Rule: BR-21 — Applied limit recorded unconditionally

| Field | Value |
|---|---|
| **Rule ID** | BR-21 |
| **Capability / Behavior** | `MOVE LC-FINAL-LIMIT TO AS-APPLIED-LIMIT` is executed before the approve/decline branch, making `AS-APPLIED-LIMIT` present on all non-early-exit paths. |
| **Source Evidence** | [`src/cobol/ATLAUTH.cbl:33`](src/cobol/ATLAUTH.cbl:33) |
| **Available Test Evidence** | NOT COVERED directly in either artifact (GM-011/GM-012 test decision, not applied-limit field) |
| **Expected Current Behavior** | `AS-APPLIED-LIMIT = LC-FINAL-LIMIT` on all limit-evaluation paths |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | NO |
| **Conflicts / Known Unknowns** | `AS-RISK-MODE` in `AUTH-RESPONSE` never populated. `AUTHLOG` is a stub — downstream consumption of `AS-APPLIED-LIMIT` is unknown. |
| **Regression Invariant Ready** | PARTIAL — source-explicit but no isolated test |

---

### Rule: BR-22 — Audit on all paths

| Field | Value |
|---|---|
| **Rule ID** | BR-22 |
| **Capability / Behavior** | `PERFORM WRITE-AUDIT` (which calls `AUTHLOG`) is invoked on all three exit paths: account validation failure, merchant validation failure, and limit-based decision. |
| **Source Evidence** | [`src/cobol/ATLAUTH.cbl:20`](src/cobol/ATLAUTH.cbl:20), [`src/cobol/ATLAUTH.cbl:28`](src/cobol/ATLAUTH.cbl:28), [`src/cobol/ATLAUTH.cbl:43`](src/cobol/ATLAUTH.cbl:43) |
| **Available Test Evidence** | NOT COVERED in either test artifact |
| **Expected Current Behavior** | AUTHLOG called on all exit paths |
| **Confidence Classification** | HIGH for call structure; BLOCKED for actual audit behavior (AUTHLOG is a stub — KU-04) |
| **Directly Covered by Test** | NO |
| **Conflicts / Known Unknowns** | KU-04: `AUTHLOG` real behavior unknown. Cannot confirm what an audit record contains or whether it succeeds. |
| **Regression Invariant Ready** | BLOCKED by KU-04 (AUTHLOG stub) |

---

### Rule: BR-23 — Validation guards precede limit calculation

| Field | Value |
|---|---|
| **Rule ID** | BR-23 |
| **Capability / Behavior** | `ACCTVAL` is called at line 16, `MERCHCHK` at line 24. `TRNLIM01` is called at line 32 — only reached if both validations pass. Both validation failures trigger `GOBACK` before reaching `TRNLIM01`. |
| **Source Evidence** | [`src/cobol/ATLAUTH.cbl:16-32`](src/cobol/ATLAUTH.cbl:16) |
| **Available Test Evidence** | NOT COVERED in either test artifact (no test with blank account or blank MCC) |
| **Expected Current Behavior** | Validation precedes limit calculation; failed validation short-circuits and TRNLIM01 is never called |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | NO |
| **Conflicts / Known Unknowns** | None |
| **Regression Invariant Ready** | PARTIAL — source-explicit but not test-covered |

---

### Rule: BR-24 — Fixed limit-resolution sequence in LIMUTIL

| Field | Value |
|---|---|
| **Rule ID** | BR-24 |
| **Capability / Behavior** | Seven-step fixed sequence in LIMUTIL: (1) base-limit init, (2) juris cap, (3) MCC cap, (4) temp cap, (5) grandfathered override or risk adjustment, (6) product-max ceiling, (7) final-limit assignment. |
| **Source Evidence** | [`src/cobol/LIMUTIL.cbl:13-46`](src/cobol/LIMUTIL.cbl:13) |
| **Available Test Evidence** | Implicitly confirmed by all GM cases (each exercises a subset of the sequence) |
| **Expected Current Behavior** | Sequence is as coded; Steps 5 and 7 are the critical precedence interactions |
| **Confidence Classification** | HIGH |
| **Directly Covered by Test** | YES — implicitly by all limit-producing GM cases |
| **Conflicts / Known Unknowns** | C-02: product-max applies after grandfathered exception (Step 7 after Step 5). Not explicitly tested in isolation. |
| **Regression Invariant Ready** | YES — full sequence confirmed by GM cases collectively |

---

### Rule: BR-25 — Fixed input-gathering sequence in TRNLIM01

| Field | Value |
|---|---|
| **Rule ID** | BR-25 |
| **Capability / Behavior** | Sub-programs called in fixed order: `LIMITPOL` → `EXCEPT01` → `TMPCTRL` → `MERCHVAL` → `CUSTRSK` → (conditional) `RISKFBK` → `LIMUTIL`. |
| **Source Evidence** | [`src/cobol/TRNLIM01.cbl:12-22`](src/cobol/TRNLIM01.cbl:12) |
| **Available Test Evidence** | GM-009 tests the RISKFBK conditional branch. Sequence as a whole is not isolated. |
| **Expected Current Behavior** | Six programs populate LIMIT-CONTEXT in fixed order; LIMUTIL calculates last |
| **Confidence Classification** | HIGH for the observed sequence; MEDIUM for whether ordering is load-bearing beyond LIMUTIL dependencies |
| **Directly Covered by Test** | PARTIAL — GM-009 covers RISKFBK conditional; full sequence not isolated |
| **Conflicts / Known Unknowns** | KU-17: CUSTRSK invoked unconditionally even for grandfathered accounts (MQ call is wasted work but not harmful). Whether this is intentional is unresolved. |
| **Regression Invariant Ready** | YES for the sequence; KU-17 remains a containment gate |

---

## 5. Coverage and Gap Analysis

### 5.1 Test Coverage Summary

| Rule ID | `tests/golden-master/cases.yaml` | `tests/golden-master-cases.yaml` | Overall Coverage |
|---|---|---|---|
| BR-01 | NOT COVERED | NOT COVERED | **GAP** |
| BR-02 | NOT COVERED | NOT COVERED | **GAP** |
| BR-03 | GM-001, GM-003, GM-010 | `baseline-us-gold` (partial) | COVERED |
| BR-04 | NOT COVERED | NOT COVERED | **GAP** |
| BR-05 | GM-003 | — | COVERED |
| BR-06 | GM-001, GM-004 | — | COVERED |
| BR-07 | GM-004 (partial) | — | PARTIAL |
| BR-08 | GM-002 | `grandfathered-exception` (ambiguous account ID) | COVERED (GM-002 is primary) |
| BR-09 | GM-002 (active=Y only) | `grandfathered-exception` | PARTIAL |
| BR-10 | GM-005 | — | COVERED |
| BR-11 | GM-006 | — | COVERED |
| BR-12 | GM-001, GM-007, GM-008 | `baseline-us-gold` | COVERED |
| BR-13 | GM-007 (oracle) | `high-risk-score-increase` (conflicting — not oracle) | COVERED (oracle only) |
| BR-14 | GM-008 | — | COVERED |
| BR-15 | GM-001, GM-009 | `baseline-us-gold` | COVERED |
| BR-16-RISK | GM-009 | — | COVERED |
| BR-17-RISK | GM-007, GM-008 (score assumed) | — | PARTIAL |
| BR-18 | GM-010 | — | COVERED |
| BR-19 | GM-012 | — | COVERED |
| BR-20 | GM-011 | — | COVERED |
| BR-21 | NOT COVERED | NOT COVERED | **GAP** |
| BR-22 | NOT COVERED | NOT COVERED | **GAP** (AUTHLOG stub blocks) |
| BR-23 | NOT COVERED | NOT COVERED | **GAP** |
| BR-24 | All GM cases (implicit) | — | COVERED (implicit) |
| BR-25 | GM-009 (partial) | — | PARTIAL |

### 5.2 Rules Covered by Existing Tests (Regression-Ready)

BR-03, BR-05, BR-06, BR-08, BR-10, BR-11, BR-12, BR-13 (oracle established), BR-14, BR-15, BR-16-RISK, BR-18, BR-19, BR-20, BR-24 — **15 rules**

### 5.3 Rules with Test Gaps

BR-01, BR-02, BR-04, BR-07 (partial), BR-09 (partial), BR-17-RISK (partial), BR-21, BR-22, BR-23, BR-25 (partial) — **10 rules with full or partial gaps**

### 5.4 Rules Blocked by External Evidence Limitations

BR-17-RISK (MQRSKGET absent), BR-22 (AUTHLOG stub) — **2 rules structurally blocked from runtime coverage**

---

## 6. Baseline Classification

Every characterization item is classified using the framework's five baseline classes:

**Classification Key:**
- **A. SOURCE-EXPLICIT / REGRESSION-READY** — behavior unambiguously implemented in source AND covered by at least one authoritative test
- **B. SOURCE-EXPLICIT / TEST-GAP** — behavior unambiguously in source but NOT covered by any test
- **C. HUMAN-RESOLVED FOR SYNTHETIC REGRESSION** — behavior confirmed in source, test conflict resolved by human authority decision
- **D. UNRESOLVED BUSINESS INTENT** — source behavior is observable but real-world business meaning cannot be confirmed from workspace evidence
- **E. BLOCKED BY MISSING EXTERNAL/RUNTIME EVIDENCE** — behavior depends on external system, stub, or unavailable runtime

| Rule ID | Classification | Rationale |
|---|---|---|
| BR-01 | **B. SOURCE-EXPLICIT / TEST-GAP** | Explicit in ATLAUTH:17-21; zero test coverage |
| BR-02 | **B. SOURCE-EXPLICIT / TEST-GAP** | Explicit in ATLAUTH:24-29; zero test coverage |
| BR-03 | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit in LIMITPOL:16-28; covered by GM-001, GM-003, GM-010 |
| BR-04 | **B + D (dual)** | Source-explicit (LIMITPOL:29-33); no test; 1000.00 business intent unresolved (C-05) |
| BR-05 | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit in LIMUTIL:15-18; covered by GM-003 |
| BR-06 | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit in TMPCTRL:10-14; covered by GM-001, GM-004 |
| BR-07 | **B. SOURCE-EXPLICIT / TEST-GAP** | Observable ordering in LIMUTIL:25-31; GM-004 covers temp cap but not the ordering interaction with grandfathered path |
| BR-08 | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit in EXCEPT01:26-35 + LIMUTIL:30-31; covered by GM-002 (grandfathered > product-max scenario is not covered — see C-02) |
| BR-09 | **B. SOURCE-EXPLICIT / TEST-GAP** (active=N path) | Active=Y path covered by GM-002; active=N path not covered; KU-05/06/C-03 still open on expiry |
| BR-10 | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit in MERCHVAL:12-13; covered by GM-005 |
| BR-11 | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit in MERCHVAL:14-15; covered by GM-006 |
| BR-12 | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit in MERCHVAL:10,16-17; covered by GM-001, GM-007, GM-008 |
| BR-13 | **C. HUMAN-RESOLVED FOR SYNTHETIC REGRESSION** | Source explicit (×0.80 reduction); test conflict resolved by KU-13 authority decision; GM-007 is oracle; real-world intent D |
| BR-14 | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit in LIMUTIL:36-37; covered by GM-008; direction acknowledged intentional in GM-008 description |
| BR-15 | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit by structural omission in LIMUTIL:32-40; covered by GM-001, GM-009 |
| BR-16-RISK | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit in TRNLIM01:18-20 + RISKFBK:10-12; covered by GM-009 |
| BR-17-RISK | **E. BLOCKED BY MISSING EXTERNAL/RUNTIME EVIDENCE** | MQRSKGET source absent (KU-01); runtime MQ behavior unverifiable |
| BR-18 | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit in LIMUTIL:42-44; covered by GM-010 (C-02 remains for grandfathered-exceeds-max case) |
| BR-19 | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit in ATLAUTH:35-37; covered by GM-012 |
| BR-20 | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit in ATLAUTH:38-41; covered by GM-011 |
| BR-21 | **B. SOURCE-EXPLICIT / TEST-GAP** | Explicit in ATLAUTH:33; no direct test for applied-limit field population |
| BR-22 | **E. BLOCKED BY MISSING EXTERNAL/RUNTIME EVIDENCE** | AUTHLOG is a stub (KU-04); real audit behavior unverifiable |
| BR-23 | **B. SOURCE-EXPLICIT / TEST-GAP** | Explicit in ATLAUTH:16-32; zero test coverage for validation-precedes-calc invariant |
| BR-24 | **A. SOURCE-EXPLICIT / REGRESSION-READY** | Explicit in LIMUTIL:13-46; implicitly confirmed by all GM limit-producing cases |
| BR-25 | **B. SOURCE-EXPLICIT / TEST-GAP** (full sequence) | Sequence observable in TRNLIM01:12-22; conditional RISKFBK path covered by GM-009; overall sequence not isolated; KU-17 containment |

**Summary by class:**

| Class | Count | Rules |
|---|---|---|
| A. SOURCE-EXPLICIT / REGRESSION-READY | 14 | BR-03, BR-05, BR-06, BR-08, BR-10, BR-11, BR-12, BR-14, BR-15, BR-16-RISK, BR-18, BR-19, BR-20, BR-24 |
| B. SOURCE-EXPLICIT / TEST-GAP | 8 | BR-01, BR-02, BR-04, BR-07, BR-09, BR-21, BR-23, BR-25 |
| C. HUMAN-RESOLVED FOR SYNTHETIC REGRESSION | 1 | BR-13 |
| D. UNRESOLVED BUSINESS INTENT | 0 (embedded in BR-04, BR-13, BR-18) | — |
| E. BLOCKED BY MISSING EXTERNAL/RUNTIME EVIDENCE | 2 | BR-17-RISK, BR-22 |

*Note: BR-04 has dual B+D classification; BR-13 has C+D classification (C for synthetic baseline; D for real-world intent).*

---

## 7. Known Unknowns and Unresolved Intent

### 7.1 Resolved Known Unknowns

| ID | Resolution Status | Authority |
|---|---|---|
| KU-13 | **RESOLVED FOR SYNTHETIC REGRESSION BASELINE** | Suman Devarasetti — `00-ku13-authority-decision.md` |

### 7.2 Active Known Unknowns (Gate Status for Future Slices)

| ID | Description | Gate Type | Slice Gate | Slice 0 Impact |
|---|---|---|---|---|
| KU-01 | `MQRSKGET` source absent — timeout, retry, correlation all unknown | CONTAINMENT | Slice 4 | Blocks BR-17-RISK runtime characterization |
| KU-02 | `AUTH-REQUEST` population mechanism (AR-PRODUCT-CODE, AR-JURISDICTION, etc.) upstream unknown | CONTAINMENT | Slice 5 | Does not block Slice 0 |
| KU-03 | `AUTH-REQUEST` population for CICS `ATLI` diagnostic path unknown | RESOLUTION | Slice 5 | Does not block Slice 0 |
| KU-04 | `AUTHLOG` real destination and behavior unknown (stub) | CONTAINMENT | Slice 5 | Blocks BR-22 characterization |
| KU-05 | `EXCREC01` reconciliation logic unknown | RESOLUTION | Slice 2 | Does not block Slice 0 |
| KU-06 | `ER-EXPIRY-DATE` enforcement intent unresolved | RESOLUTION | Slice 2 | Does not block Slice 0 |
| KU-07 | Multi-row `ATLAS_LIMIT_POLICY` result / SQLCODE -811 risk | RESOLUTION | Slice 1 | Does not block Slice 0 |
| KU-08 | `POLREC.cpy` consumers outside workspace unknown | RESOLUTION | Slice 1 | Does not block Slice 0 |
| KU-09 | `AS-RISK-MODE` semantics unresolved | CONTAINMENT | Slice 5 | Does not block Slice 0 |
| KU-10 | `LIMITREF.jcl` operational intent unknown | RESOLUTION | Slice 1 | Does not block Slice 0 |
| KU-11 | VSAM record-size discrepancy (JCL=57, copybook=58 bytes) | RESOLUTION | Slice 2 | Does not block Slice 0 |
| KU-12 | `EXCEPT01` VSAM I/O compatibility under CICS unverified | RESOLUTION | Slice 2 | Does not block Slice 0 |
| KU-14 | `LAST_REFRESH_TS` purpose in LIMITBAT unknown | CONTAINMENT | Slices 1, 5 | Does not block Slice 0 |
| KU-15 | `ATLAS_ACCOUNT_PRODUCT` has no consumer in online path | CONTAINMENT | Slice 5 | Does not block Slice 0 |
| KU-16 | `AR-TRANSACTION-TYPE` behaviorally inert in workspace | CONTAINMENT | Slice 5 | Does not block Slice 0 |
| KU-17 | Unconditional `CUSTRSK` invocation even for grandfathered accounts | CONTAINMENT | Slice 4 | Does not block Slice 0 |
| KU-18 | `AUTHRPT` data source unknown | CONTAINMENT | Slices 1, 5 | Does not block Slice 0 |

### 7.3 Unresolved Conflicts Requiring Future Human Resolution

| ID | Conflict | Required Resolution |
|---|---|---|
| C-02 | Grandfathered exception applied before product-max ceiling. Whether grandfathered accounts should be exempt from the ceiling is unresolved. | Human business policy decision before any change to the exception/ceiling interaction |
| C-03 | `ER-EXPIRY-DATE` declared but never evaluated. Batch-side vs. online responsibility unresolved. | Business/operations evidence establishing expiry enforcement ownership |
| C-04 | Timeout and hard-error produce identical fallback. `AS-RISK-MODE` unused. | Business intent for differentiation; no action required if current behavior is preserved |
| C-05 | 1,000.00 fallback floor has no documented business origin. | Business confirmation of the floor value's intent |
| C-06 | Risk score semantics counter-intuitive. GM-008 labels direction intentional for this estate. | Acknowledged for synthetic estate; real-world direction would require business specification |

---

## 8. Runtime Validation Status

### 8.1 Executability Assessment

AtlasPay is an **analysis-grade synthetic estate**. The following execution prerequisites have been evaluated:

| Prerequisite | Status |
|---|---|
| Source files compile on z/OS | **NOT VERIFIED** — no evidence of compilation |
| Deployable load modules exist | **NOT VERIFIED** — no load module evidence |
| CICS region available | **NOT VERIFIED** — no runtime region evidence |
| DB2 region with `ATLAS_LIMIT_POLICY` populated | **NOT VERIFIED** — schema and seed data present but no live DB2 |
| VSAM dataset `EXCPTKS` accessible at runtime | **NOT VERIFIED** — DEFINE JCL present; dataset not verified instantiated |
| MQ queue manager / ATLAS.RISK queues available | **NOT VERIFIED** — `MQRSKGET` source absent (KU-01) |
| Characterization harness / test runner | **NOT PRESENT** — no test runner exists in this workspace |
| Rollback mechanism demonstrated | **NOT VERIFIED** — source-level only; no build/deploy/restore mechanism identified |

### 8.2 Runtime Validation Determination

**Runtime Validation: UNAVAILABLE**

No executable characterization harness is available or demonstrable in this workspace. The estate cannot be compiled, linked, deployed, or executed from the available workspace artifacts alone.

**STATIC CHARACTERIZATION BASELINE ONLY.** All characterization evidence in this document is derived from:
- Static source code inspection
- Test artifact case data
- Schema and seed data in `db2/seed-data.sql`
- VSAM configuration in `vsam/synthetic-exceptions.csv`
- MQ queue definitions in `mq/queues.yaml`
- CICS transaction routing in `cics/transactions.yaml`

**Consequent constraint (per `framework-assets/playbooks/controlled-transform/playbook.yaml`):**

> The playbook prohibits: *"claim_runtime_equivalence_without_runtime_evidence"*

Therefore: behavioral equivalence between any future refactored implementation and the current baseline **cannot** be claimed from static analysis alone. Runtime equivalence evidence requires an authorized execution environment to be established before any executable transformation slice proceeds.

---

## 9. Regression Oracle

### 9.1 Authoritative Characterization Cases

The following cases from `tests/golden-master/cases.yaml` constitute the regression oracle for Slice 0. Each is confirmed consistent with the inspected source:

| Case ID | Description | Key Inputs | Expected Behavior | Source Consistency |
|---|---|---|---|---|
| GM-001 | US Gold baseline, neutral risk | GLD1/US, MCC=5411, risk=650, temp=0 | Limit=5000.00 | Confirmed: base=5000, risk in neutral band, no caps applied |
| GM-002 | Grandfathered exception override | SYN000000001, GLD1/US, grandfathered=Y | Limit=7500.00 | Confirmed: EXCEPT01 sets LC-GRANDFATHERED=Y; LIMUTIL uses LC-EXCEPTION-LIMIT=7500 |
| GM-003 | Jurisdiction lower cap | GLD1/CA, MCC=5411 | Limit=4000.00 | Confirmed: JURIS_LIMIT=4000 < BASE=4500; LIMUTIL reduces candidate |
| GM-004 | Temporary customer control | GLD1/US, MCC=5411, temp=2500 | Limit=2500.00 | Confirmed: TMPCTRL sets LC-TEMP-LIMIT=2500; LIMUTIL applies cap |
| GM-005 | MCC 7995 cap | GLD1/US, MCC=7995, risk=650 | Limit=1000.00 | Confirmed: MERCHVAL sets LC-MCC-LIMIT=1000; LIMUTIL applies cap |
| GM-006 | MCC 6051 cap | GLD1/US, MCC=6051, risk=650 | Limit=2000.00 | Confirmed: MERCHVAL sets LC-MCC-LIMIT=2000; LIMUTIL applies cap |
| GM-007 | **KU-13 oracle — high risk ≥ 800** | GLD1/US, MCC=5411, risk=850 | Limit=4000.00 | **Confirmed by human authority decision**: 5000 × 0.80 = 4000 |
| GM-008 | Low risk < 500 | GLD1/US, MCC=5411, risk=450 | Limit=3500.00 | Confirmed: 5000 × 0.70 = 3500 |
| GM-009 | MQ unavailable, fallback=650 | GLD1/US, MCC=5411, risk_available=false | Limit=5000.00 | Confirmed: RISKFBK sets score=650; neutral band; no adjustment |
| GM-010 | Product maximum ceiling | PLT1/US, MCC=5411, candidate=20000 | Limit=15000.00 | Confirmed: LIMUTIL product-max cap; PLT1/US PRODUCT_MAX=15000 |
| GM-011 | Amount above limit → declined | GLD1/US, MCC=5411, amount=5500 | Decision=D | Confirmed: 5500 > 5000 → MOVE 'D', MOVE 'LIMT' |
| GM-012 | Amount at limit → approved | GLD1/US, MCC=5411, amount=5000 | Decision=A | Confirmed: 5000 ≤ 5000 → MOVE 'A', MOVE '0000' |

### 9.2 Non-Oracle Cases

| Artifact | Case ID | Status | Reason |
|---|---|---|---|
| `tests/golden-master-cases.yaml` | `high-risk-score-increase` | **NOT ORACLE** | Expected value 6000.00 contradicts LIMUTIL source and is unsupported by any arithmetic path. Retained as historical evidence per KU-13 authority decision. |
| `tests/golden-master-cases.yaml` | `baseline-us-gold` | Supplementary (consistent) | Consistent with GM-001 behavior; not contradictory but not the primary oracle |
| `tests/golden-master-cases.yaml` | `grandfathered-exception` | Supplementary (account ID ambiguous) | Expected_limit=7500 consistent with GM-002; account ID `SYN0001` does not match any known VSAM entry — ambiguous |

### 9.3 Regression Oracle Statement

**For the AtlasPay synthetic regression estate, the authoritative regression oracle is:**

> The twelve cases in `tests/golden-master/cases.yaml` (GM-001 through GM-012), confirmed consistent with source inspection, with GM-007 designated as the KU-13 authoritative case (expected_limit=4000.00 for risk_score ≥ 800, per human authority decision).

All future TRANSFORM slices must preserve every behavior captured in this oracle unless an explicitly approved human business policy decision authorizes a change.

---

## 10. Slice 0 Exit Assessment

### 10.1 KU-13 Closure

| Question | Answer |
|---|---|
| Is KU-13 closed for the synthetic regression baseline? | **YES** — Human authority decision recorded in `00-ku13-authority-decision.md`, approved by Suman Devarasetti. Oracle: `risk_score >= 800 → candidate × 0.80`. |
| Is real-world business intent established? | **NO** — The authority decision explicitly does not establish real-world policy intent. |
| Is the conflicting test case resolved? | **RETAINED AS HISTORICAL EVIDENCE** — `high-risk-score-increase` is not deleted or modified but is not the regression oracle. |

### 10.2 Characterization Oracle Sufficiency

| Question | Answer |
|---|---|
| Is the characterization oracle sufficiently defined for later source-level refactoring? | **YES — WITH CONDITIONS.** The 12-case oracle in `tests/golden-master/cases.yaml` covers 15 of the 25 business rules directly (Class A + C). The behavioral invariant sequence (BR-24, BR-25) is implicitly confirmed by all limit-producing cases. |
| What conditions apply? | (a) Runtime verification remains required before any executable slice can claim behavioral equivalence. (b) Class B rules (test gaps) are reference points for refactoring design but cannot produce runtime equivalence proof until tests exist and a runtime environment is available. (c) Class E rules (AUTHLOG, MQRSKGET) remain blocked from characterization. |

### 10.3 Unresolved Behaviors That Remain Gates

The following behaviors remain unresolved and function as **active gates** on future slices:

| Gate | Description | Blocking Which Slice |
|---|---|---|
| KU-07 | Multi-row ATLAS_LIMIT_POLICY / SQLCODE -811 risk | Slice 1 RESOLUTION GATE |
| KU-08 | POLREC.cpy consumer universe unknown | Slice 1 RESOLUTION GATE |
| KU-10 | LIMITREF.jcl operational intent | Slice 1 RESOLUTION GATE |
| KU-11 | VSAM record-size discrepancy | Slice 2 RESOLUTION GATE |
| KU-12 | EXCEPT01 CICS compilation unverified | Slice 2 RESOLUTION GATE |
| KU-05 / KU-06 / C-03 | ER-EXPIRY-DATE enforcement ownership | Slice 2 RESOLUTION GATE |
| C-02 | Grandfathered exception vs. product-max business intent | Slice 2 RESOLUTION GATE (if exception > max behavior is changed) |
| MCC business intent | Whether MCC 7995/6051 values are regulatory, contractual, or configurable | Slice 3 RESOLUTION GATE |
| KU-03 | AUTH-REQUEST population for ATLI path | Slice 5 RESOLUTION GATE |
| Runtime environment | No executable environment established | ALL executable slices (Slices 1–5) |

### 10.4 Can Slice 0 Exit?

**YES — Slice 0 can exit, subject to human review gate below.**

All Slice 0 objectives are met:
1. KU-13 conflict documented with full provenance. ✓
2. Human authority decision recorded and applied. ✓
3. Regression oracle identified (12-case GM suite). ✓
4. Characterization inventory completed for all 25 rules. ✓
5. Two test artifacts analyzed, reconciled, and neither modified. ✓
6. Baseline classification completed for all 25 rules. ✓
7. Runtime status assessed honestly (UNAVAILABLE). ✓
8. All active gates for future slices identified. ✓
9. No application source code was modified. ✓

### 10.5 Slice 1 Eligibility

**Slice 1 is NOT authorized at this time.**

Slice 1 eligibility requires:
- [ ] Human review and sign-off on this Slice 0 baseline (Section 11 — pending)
- [ ] KU-07 resolution (singleton guarantee or approved applicable-row business rule)
- [ ] KU-08 resolution (POLREC.cpy consumer confirmation)
- [ ] KU-10 resolution (LIMITREF.jcl operational status)
- [ ] C-05 confirmation (1000.00 fallback floor business intent)
- [ ] Authorized executable environment established (required before any executable transformation slice)
- [ ] Source-level rollback baseline preserved and demonstrated

None of these prerequisites are satisfied at the close of Slice 0. **Slice 1 cannot be considered next without human review sign-off on this document and resolution of its prerequisite gates.**

---

## 11. Human Review Gate

This Slice 0 baseline artifact is complete and ready for human review. No source-changing activity may proceed until a named reviewer approves this gate.

**Required Review Items:**

1. Confirm that the KU-13 authority resolution in Section 2 is correctly documented and that GM-007 is the designated regression oracle.
2. Confirm that the characterization inventory (Section 4) accurately reflects the source behavior as understood.
3. Confirm that the 12-case regression oracle (Section 9) is accepted as the baseline for all future slices.
4. Confirm that the test artifact reconciliation (Section 3) correctly identifies the oracle and non-oracle cases without misrepresenting either artifact.
5. Confirm that the runtime status (UNAVAILABLE) is an accurate representation of the current estate state.
6. Confirm or correct any classification in Section 6 that requires human judgment.
7. Determine whether any Class B (test-gap) rules require a test to be authored before Slice 1 can proceed.
8. Determine whether the Slice 1 gates (KU-07, KU-08, KU-10, C-05) can be cleared or provide direction for clearing them.

---

```yaml
Human Transform Reviewer: REQUIRED — NOT YET ASSIGNED
Slice 0 Review Status: PENDING HUMAN REVIEW
Source Modification Performed: FALSE
Runtime Validation: UNAVAILABLE
Slice 1 Authorized: FALSE
```