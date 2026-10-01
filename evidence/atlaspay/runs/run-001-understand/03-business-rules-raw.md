# Raw Bob Output — Business Rule Recovery

Run: atlaspay-understand-001
Stage: UNDERSTAND
Capability: PP4Z business-rule/documentation analysis
Execution mode: PP4Z workspace
Z Understand: Not configured
Manual corrections: None

---

---

# AtlasPay Dynamic Transaction Limit — Business Rule Catalog

**Stage**: UNDERSTAND — rule recovery only. No rules are simplified, redesigned, or recommended for change. Implementation behavior is reported as observed; business intent is not inferred from code alone.

**Classification key**  
`[EXPLICIT]` — Rule is directly and unambiguously expressed in source code  
`[STRONGLY INFERRED]` — Rule is clearly implied by the implementation and supported by corroborating evidence (golden-master cases, data, comments), but no business specification document states it  
`[UNRESOLVED]` — Behavior is present in the code but its intended business meaning cannot be confirmed without external evidence (SME, specification, or runtime observation)

**Evidence citation format**: `filename:line(s)`

---

## Category 1 — Pre-Limit Guards (Authorization Pre-conditions)

---

### BR-01 — Account identifier must be present

**Plain language**: An authorization request with a blank account identifier is declined before any limit calculation is attempted. The decline reason code is `ACCT`.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/ACCTVAL.cbl:11-12`](src/cobol/ACCTVAL.cbl:11), [`src/cobol/ATLAUTH.cbl:17-21`](src/cobol/ATLAUTH.cbl:17)

**Implementation evidence**:
```cobol
IF AR-ACCOUNT-ID = SPACES
   MOVE 'N' TO LK-VALID          ← ACCTVAL.cbl:11-12
```
```cobol
IF WS-ACCOUNT-VALID NOT = 'Y'
   MOVE 'D' TO AS-DECISION
   MOVE 'ACCT' TO AS-REASON-CODE
   PERFORM WRITE-AUDIT
   GOBACK                         ← ATLAUTH.cbl:17-21
```

**Conflicting evidence / ambiguity**: The validation checks only for `SPACES` — an account identifier consisting entirely of spaces fails. Whether other invalid formats (e.g., non-numeric characters, wrong length) also fail is not implemented. Validation is syntactic, not semantic.

**Missing external behavior**: The business rule governing what constitutes a valid account identifier beyond non-blank is unknown. Whether the `ATLAS_ACCOUNT_PRODUCT` table should be consulted to confirm account existence is not implemented in any in-scope program.

---

### BR-02 — Merchant Category Code must be present

**Plain language**: An authorization request with a blank Merchant Category Code is declined before any limit calculation is attempted. The decline reason code is `MCC `.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/MERCHCHK.cbl:11-12`](src/cobol/MERCHCHK.cbl:11), [`src/cobol/ATLAUTH.cbl:25-29`](src/cobol/ATLAUTH.cbl:25)

**Implementation evidence**:
```cobol
IF AR-MERCHANT-CATEGORY = SPACES
   MOVE 'N' TO LK-VALID          ← MERCHCHK.cbl:11-12
```
```cobol
IF WS-MERCHANT-VALID NOT = 'Y'
   MOVE 'D' TO AS-DECISION
   MOVE 'MCC ' TO AS-REASON-CODE ← ATLAUTH.cbl:25-29
```

**Conflicting evidence / ambiguity**: Validation is presence-only — a non-blank but unrecognized MCC passes this guard. MCC-specific behavior (caps, decline) is applied later in `MERCHVAL` during limit calculation, not here. The two guards serve different purposes: BR-02 enforces structural validity; merchant-category business rules are in BR-09 and BR-10.

**Missing external behavior**: Whether MCCs not in the `MERCHVAL` hardcoded list (i.e., not `7995` or `6051`) should be subject to further validation is not implemented.

---

## Category 2 — Base Limit

---

### BR-03 — Base transaction limit is derived from product and jurisdiction policy

**Plain language**: The starting transaction limit for an authorization is determined by looking up the account's product code and jurisdiction in a policy table. The table supplies three values: a base limit, a product maximum, and a jurisdiction limit.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/LIMITPOL.cbl:16-28`](src/cobol/LIMITPOL.cbl:16), [`db2/schema.sql:3-13`](db2/schema.sql:3), [`db2/seed-data.sql:1-6`](db2/seed-data.sql:1)

**Implementation evidence**:
```cobol
EXEC SQL
   SELECT BASE_LIMIT, PRODUCT_MAX, JURIS_LIMIT
     INTO :WS-BASE-LIMIT, :WS-PRODUCT-MAX, :WS-JURIS-LIMIT
     FROM ATLAS_LIMIT_POLICY
    WHERE PRODUCT_CODE = :AR-PRODUCT-CODE
      AND JURISDICTION = :AR-JURISDICTION
      AND ACTIVE_FLAG = 'Y'
END-EXEC                           ← LIMITPOL.cbl:16-23
```

**Corroboration**: GM-001 (GLD1/US → 5000), GM-003 (GLD1/CA → 4000 via juris cap), GM-010 (PLT1/US, product-max = 15000). All consistent with seed data: GLD1/US BASE=5000, PRODUCT_MAX=9000, JURIS=5000; PLT1/US BASE=10000, PRODUCT_MAX=15000, JURIS=10000; GLD1/CA BASE=4500, PRODUCT_MAX=8000, JURIS=4000.

**Conflicting evidence / ambiguity**:
1. The `EFFECTIVE_DATE` column is part of the primary key (`db2/schema.sql:12`) but is not included in the WHERE clause. The query does not filter to the most recent effective date. If more than one row exists for the same `(PRODUCT_CODE, JURISDICTION)` with `ACTIVE_FLAG = 'Y'`, DB2 returns `SQLCODE -811` (cardinality violation) and no values are populated. The code then applies the fallback rule (BR-04) silently. The business intent for multi-row scenarios is unresolved.
2. The `ACTIVE_FLAG` column controls which rows are considered, but the mechanism by which `ACTIVE_FLAG` is set or cleared is not visible in any in-scope program.

**Missing external behavior**: How policy rows are maintained (loaded, activated, expired) is not visible. `POLREC.cpy` defines a `POLICY-RECORD` structure compatible with this table but has no known consumer in the workspace — suggesting an absent batch load program.

---

### BR-04 — Policy lookup failure falls back to a floor limit of 1,000.00

**Plain language**: If the policy lookup fails for any reason — including no matching row, a database error, or multiple conflicting active rows — the base limit, product maximum, and jurisdiction limit are all set to 1,000.00. The authorization then proceeds with these fallback values.

**Classification**: `[EXPLICIT]` (behavior is unambiguous in code); `[UNRESOLVED]` (business intent of the 1,000.00 value is not documented)

**Source artifact**: [`src/cobol/LIMITPOL.cbl:29-33`](src/cobol/LIMITPOL.cbl:29)

**Implementation evidence**:
```cobol
IF SQLCODE = 0
   MOVE WS-BASE-LIMIT  TO LC-BASE-LIMIT
   MOVE WS-PRODUCT-MAX TO LC-PRODUCT-MAX
   MOVE WS-JURIS-LIMIT TO LC-JURIS-LIMIT
ELSE
   MOVE 1000.00 TO LC-BASE-LIMIT
   MOVE 1000.00 TO LC-PRODUCT-MAX
   MOVE 1000.00 TO LC-JURIS-LIMIT
END-IF                             ← LIMITPOL.cbl:25-33
```

**Conflicting evidence / ambiguity**:
- The fallback is silent: no error indicator or flag is set in `LIMIT-CONTEXT` or `AUTH-RESPONSE` to indicate that the fallback was applied. The caller (`TRNLIM01`, `ATLAUTH`) cannot distinguish a successful lookup from a failed one.
- The same floor applies to all three fields — base, product-max, and juris-limit are all 1,000.00. This means the product-max ceiling also becomes 1,000.00 under fallback, which prevents BR-16 from providing any upward room.
- The 1,000.00 value is a magic number. Its origin as a business decision versus a default approximation is unknown.

**Missing external behavior**: Whether the fallback is an intentional business rule (conservative floor during outages) or a defensive programming choice made without explicit business guidance cannot be determined from the source.

---

## Category 3 — Jurisdiction Constraints

---

### BR-05 — Jurisdiction cap constrains the base limit

**Plain language**: The policy table supplies a jurisdiction-specific limit. If that jurisdiction limit is lower than the current candidate limit, the candidate is reduced to the jurisdiction limit. The jurisdiction cap is applied after the base limit is established.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/LIMUTIL.cbl:15-18`](src/cobol/LIMUTIL.cbl:15)

**Implementation evidence**:
```cobol
IF LC-JURIS-LIMIT > 0
   AND LC-JURIS-LIMIT < WS-CANDIDATE-LIMIT
   MOVE LC-JURIS-LIMIT TO WS-CANDIDATE-LIMIT
END-IF                             ← LIMUTIL.cbl:15-18
```

**Corroboration**: GM-003 — GLD1/CA: BASE=4500, JURIS=4000. JURIS (4000) < BASE (4500) → candidate becomes 4000. Expected_limit: 4000.00 ✓. Seed data: `GLD1/CA JURIS_LIMIT=4000.00` (`db2/seed-data.sql:6`).

**Conflicting evidence / ambiguity**:
- The condition `LC-JURIS-LIMIT > 0` means a zero jurisdiction limit is treated as "no cap" rather than "zero limit." Whether a zero jurisdiction limit in the policy table is a valid business state, a data entry error, or an intended sentinel value is unresolved.
- The jurisdiction limit comes from the same policy row as the base limit (BR-03). If the fallback (BR-04) is active, `LC-JURIS-LIMIT = 1000.00` and `LC-BASE-LIMIT = 1000.00`; the condition `< WS-CANDIDATE-LIMIT` is false (equal, not less), so the jurisdiction cap has no effect under fallback.

---

## Category 4 — Customer and Account-Specific Controls

---

### BR-06 — A customer may set a temporary self-imposed limit

**Plain language**: A customer can supply a temporary control amount on the authorization request. If that amount is greater than zero, it is used as a temporary limit cap. If the temporary control amount is zero or absent, no temporary cap is applied.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/TMPCTRL.cbl:10-14`](src/cobol/TMPCTRL.cbl:10)

**Implementation evidence**:
```cobol
IF AR-TEMP-CONTROL-AMT > 0
   MOVE AR-TEMP-CONTROL-AMT TO LC-TEMP-LIMIT
ELSE
   MOVE 9999999.99 TO LC-TEMP-LIMIT
END-IF                             ← TMPCTRL.cbl:10-14
```

**Corroboration**: GM-004 — `temp_control: 2500.00` → expected_limit: 2500.00 ✓. GM-001 — `temp_control: 0` → no cap effect; expected_limit 5000.00 ✓.

**Conflicting evidence / ambiguity**:
- The sentinel value for "no cap" is `9999999.99` — the maximum value of a `PIC 9(7)V99` field. This value is never itself the limit; it simply exceeds any realistic product-max and is therefore always filtered out by BR-16. If a product-max were ever set above 9999999.99 (impossible with the current field definition), the sentinel logic would break. This is not a practical conflict given the field sizes.
- `AR-TEMP-CONTROL-AMT` is a field in the auth request (`AUTHREQ.cpy:8`). How this value is populated by the caller — whether it comes from a customer preference store, a session input, or a default — is not visible in any workspace artifact.
- The condition is `> 0`, so a negative value would also set `LC-TEMP-LIMIT` to the sentinel. Negative temp-control values are not separately validated.

**Missing external behavior**: The business process by which a customer sets or revokes a temporary control amount is entirely outside this workspace.

---

### BR-07 — Temporary cap is applied after jurisdiction, before grandfathered exception

**Plain language**: The temporary customer control is applied as the third reduction to the candidate limit — after the base and jurisdiction caps. A grandfathered exception (if applicable) is evaluated after the temporary cap and replaces the result of all prior caps.

**Classification**: `[STRONGLY INFERRED]` (ordering is observable in code; whether this ordering reflects deliberate business policy cannot be confirmed from source alone)

**Source artifact**: [`src/cobol/LIMUTIL.cbl:25-28`](src/cobol/LIMUTIL.cbl:25), [`src/cobol/TRNLIM01.cbl:12-22`](src/cobol/TRNLIM01.cbl:12)

**Implementation evidence**:
```cobol
*Step 3: temp-control cap
IF LC-TEMP-LIMIT > 0
   AND LC-TEMP-LIMIT < WS-CANDIDATE-LIMIT
   MOVE LC-TEMP-LIMIT TO WS-CANDIDATE-LIMIT  ← LIMUTIL.cbl:25-28

*Step 4a: grandfathered override (comes after)
IF LC-GRANDFATHERED = 'Y'
   MOVE LC-EXCEPTION-LIMIT TO WS-CANDIDATE-LIMIT ← LIMUTIL.cbl:30-31
```

**Conflicting evidence / ambiguity**: Because the grandfathered override replaces the candidate outright (not caps it), the relative position of the temp-control cap before the grandfathered check has no observable effect on the final result when `LC-GRANDFATHERED = 'Y'` — the exception limit would overwrite the temp-capped candidate regardless. The ordering only matters for the non-grandfathered path.

---

## Category 5 — Exception (Grandfathered) Behavior

---

### BR-08 — A grandfathered exception replaces all other limit calculations

**Plain language**: If an account has an active grandfathered exception on record, the exception limit replaces the result of all other limit calculations — including base, jurisdiction, MCC, and temporary caps. The exception amount becomes the candidate limit for that authorization.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/EXCEPT01.cbl:25-35`](src/cobol/EXCEPT01.cbl:25), [`src/cobol/LIMUTIL.cbl:30-31`](src/cobol/LIMUTIL.cbl:30)

**Implementation evidence**:
```cobol
*EXCEPT01 — lookup:
MOVE 'N' TO LC-GRANDFATHERED        ← sets default
READ EXCEPT-FILE KEY IS ER-ACCOUNT-ID
   INVALID KEY CONTINUE
   NOT INVALID KEY
      IF ER-ACTIVE = 'Y'
         MOVE 'Y' TO LC-GRANDFATHERED
         MOVE ER-EXCEPTION-LIMIT TO LC-EXCEPTION-LIMIT
      END-IF
END-READ                            ← EXCEPT01.cbl:26-35

*LIMUTIL — application:
IF LC-GRANDFATHERED = 'Y'
   MOVE LC-EXCEPTION-LIMIT TO WS-CANDIDATE-LIMIT ← LIMUTIL.cbl:30-31
```

**Corroboration**: GM-002 — account SYN000000001, grandfathered=true, expected_limit 7500.00. Seed VSAM data: `SYN000000001, exception_limit=7500.00, active=Y` (`vsam/synthetic-exceptions.csv:2`). The exception replaces any result of base/juris/MCC/temp calculations ✓.

**Conflicting evidence / ambiguity**:
1. The grandfathered override is applied *before* the product-maximum ceiling (BR-16). If the exception limit exceeds the product maximum, the exception is silently reduced to the product maximum. For SYN000000001: exception=7500 < product-max=9000 — no conflict in the test data. But for SYN000000777: exception=12000 > GLD1/US product-max=9000 → exception would be capped to 9000. Whether this is intended business behavior (product-max is truly absolute) or an implementation gap (grandfathered accounts should be exempt from the product ceiling) cannot be determined from the workspace.
2. BR-08 also overrides risk adjustments (BR-13, BR-14). A grandfathered account with a high risk score receives the full exception limit without any risk reduction. This is a consequence of the `IF LC-GRANDFATHERED = 'Y' … ELSE` structure in `LIMUTIL.cbl:30-39`.

---

### BR-09 — A grandfathered exception requires an active flag

**Plain language**: An exception record in the VSAM file activates the grandfathered override only if its `ACTIVE` flag is set to `'Y'`. Records with `ACTIVE = 'N'` are read from the file but ignored.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/EXCEPT01.cbl:32`](src/cobol/EXCEPT01.cbl:32)

**Implementation evidence**:
```cobol
IF ER-ACTIVE = 'Y'
   MOVE 'Y' TO LC-GRANDFATHERED
   MOVE ER-EXCEPTION-LIMIT TO LC-EXCEPTION-LIMIT
END-IF                             ← EXCEPT01.cbl:32-35
```

**Corroboration**: VSAM seed data shows SYN000000888 with `active=N` — this record would be read but ignored, leaving `LC-GRANDFATHERED = 'N'`.

**Conflicting evidence / ambiguity**: The `ER-EXPIRY-DATE` field is defined in [`src/copybooks/EXCEPTREC.cpy:4`](src/copybooks/EXCEPTREC.cpy:4) but is **never evaluated** by `EXCEPT01`. The implementation relies entirely on the `ER-ACTIVE` flag to determine whether an exception is current. A record with a past expiry date but `ER-ACTIVE = 'Y'` would activate the override. The process by which expiry dates result in deactivation is not visible — `EXCREC01` (the reconciliation program) is a stub. Whether date-based expiry is enforced by an external batch process or is expected to be enforced at authorization time is unresolved.

**Missing external behavior**: The real `EXCREC01` implementation is absent. The mechanism that transitions `ER-ACTIVE` from `'Y'` to `'N'` upon expiry is unknown.

---

## Category 6 — Merchant-Related Constraints

---

### BR-10 — MCC 7995 (gambling) carries a hardcoded cap of 1,000.00

**Plain language**: Transactions at merchants classified under Merchant Category Code 7995 (typically gambling) are subject to a transaction limit of 1,000.00, regardless of the account's product policy.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/MERCHVAL.cbl:12-13`](src/cobol/MERCHVAL.cbl:12)

**Implementation evidence**:
```cobol
EVALUATE AR-MERCHANT-CATEGORY
   WHEN '7995'
      MOVE 1000.00 TO LK-MCC-LIMIT ← MERCHVAL.cbl:12-13
```

**Corroboration**: GM-005 — MCC `7995`, expected_limit: 1000.00 ✓. GLD1/US base is 5000; the MCC cap reduces candidate to 1000.

**Conflicting evidence / ambiguity**: The cap is hardcoded in `MERCHVAL.cbl`. There is no lookup table or configuration that would allow it to be changed without a code change and redeployment. Whether this value is intended to be configurable (policy-driven) or deliberately hardcoded (regulatory/contractual) cannot be determined from the source.

---

### BR-11 — MCC 6051 (quasi-cash / cryptocurrency) carries a hardcoded cap of 2,000.00

**Plain language**: Transactions at merchants classified under MCC 6051 (typically quasi-cash or cryptocurrency exchange) are subject to a transaction limit of 2,000.00.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/MERCHVAL.cbl:14-15`](src/cobol/MERCHVAL.cbl:14)

**Implementation evidence**:
```cobol
WHEN '6051'
   MOVE 2000.00 TO LK-MCC-LIMIT   ← MERCHVAL.cbl:14-15
```

**Corroboration**: GM-006 — MCC `6051`, expected_limit: 2000.00 ✓.

**Conflicting evidence / ambiguity**: Same as BR-10 — hardcoded, not configurable from workspace evidence.

---

### BR-12 — All other MCCs carry no merchant-imposed cap

**Plain language**: For any Merchant Category Code other than `7995` or `6051`, no merchant-based limit reduction is applied. The MCC field is set to the maximum representable value (9,999,999.99), which effectively removes the MCC cap from the candidate-limit comparison.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/MERCHVAL.cbl:10`](src/cobol/MERCHVAL.cbl:10), [`src/cobol/MERCHVAL.cbl:16-17`](src/cobol/MERCHVAL.cbl:16)

**Implementation evidence**:
```cobol
MOVE 9999999.99 TO LK-MCC-LIMIT    ← MERCHVAL.cbl:10 (default before EVALUATE)
WHEN OTHER
   CONTINUE                         ← MERCHVAL.cbl:16-17 (default preserved)
```

**Conflicting evidence / ambiguity**: The sentinel `9999999.99` is the maximum value of `PIC 9(7)V99`. The `LIMUTIL` condition is `LC-MCC-LIMIT < WS-CANDIDATE-LIMIT` — the sentinel will never be less than a realistic candidate, so it is never applied. Whether additional MCCs should be subject to specific caps is not documented in any workspace artifact beyond these two.

---

## Category 7 — Risk-Related Adjustments

---

### BR-13 — A risk score at or above 800 reduces the candidate limit by 20%

**Plain language**: If the account's current risk score is 800 or higher, the candidate transaction limit (after all caps have been applied) is reduced by 20%.

**Classification**: `[EXPLICIT]` (implementation behavior); `[UNRESOLVED]` (business meaning of a high score — see conflict note)

**Source artifact**: [`src/cobol/LIMUTIL.cbl:33-34`](src/cobol/LIMUTIL.cbl:33)

**Implementation evidence**:
```cobol
IF LC-RISK-SCORE >= 800
   COMPUTE WS-CANDIDATE-LIMIT = WS-CANDIDATE-LIMIT * 0.80
```

**Corroboration**: GM-007 — risk_score: 850, expected_limit: 4000.00. GLD1/US base=5000, neutral risk → 5000; risk=850 ≥ 800 → 5000 × 0.80 = 4000.00 ✓.

**Conflicting evidence**:
- MQ message contract (`mq/message-contracts.md:7`) states: *"higher means more restrictive in this example"* — confirming a higher score means tighter limits. This is counter-intuitive relative to credit-bureau conventions (higher = better), but consistent with the implementation.
- **Material conflict with `tests/golden-master-cases.yaml:8-13`**: Case `high-risk-score-increase` asserts `risk_score: 825, expected_limit: 6000.00` for GLD1/US. But LIMUTIL produces 5000 × 0.80 = **4000.00**, not 6000.00. Case label "high-risk-score-increase" and expected_limit 6000 (higher than baseline 5000) suggest this file was authored under a **different assumption** — that a high risk score *increases* the limit. This directly contradicts the LIMUTIL implementation and the GM-007 case in the fuller `tests/golden-master/cases.yaml`. The two test files carry conflicting behavioral expectations for this rule. The `tests/golden-master/cases.yaml` file is more detailed and internally consistent with the implementation; `tests/golden-master-cases.yaml` appears to contain at least one erroneous expected value.

---

### BR-14 — A risk score below 500 reduces the candidate limit by 30%

**Plain language**: If the account's current risk score is below 500, the candidate transaction limit is reduced by 30%.

**Classification**: `[EXPLICIT]` (implementation); `[UNRESOLVED]` (business intent — see conflict note)

**Source artifact**: [`src/cobol/LIMUTIL.cbl:36-37`](src/cobol/LIMUTIL.cbl:36)

**Implementation evidence**:
```cobol
IF LC-RISK-SCORE < 500
   COMPUTE WS-CANDIDATE-LIMIT = WS-CANDIDATE-LIMIT * 0.70
```

**Corroboration**: GM-008 — `description: "Low synthetic risk-score branch is intentionally more restrictive in this estate"`, risk_score: 450, expected_limit: 3500.00. 5000 × 0.70 = 3500.00 ✓. The case description explicitly notes the counter-intuitive direction ("more restrictive").

**Conflicting evidence**: The GM-008 description acknowledges the direction is intentional for this synthetic estate. The `tests/golden-master-cases.yaml` file has no case for a low risk score, so no cross-file conflict exists here. The semantic question — whether low risk should mean lower or higher limits — is flagged as intentional in the GM-008 description but is still a business-intent question that cannot be resolved from code alone.

---

### BR-15 — Risk scores between 500 and 799 (inclusive) produce no risk adjustment

**Plain language**: A risk score that is at least 500 but below 800 results in no change to the candidate limit. The risk factor is neutral in this band.

**Classification**: `[EXPLICIT]` (by omission — no code applies any multiplier in this range)

**Source artifact**: [`src/cobol/LIMUTIL.cbl:32-40`](src/cobol/LIMUTIL.cbl:32) (the `ELSE` / no-action path)

**Implementation evidence**: The IF-ELSE-IF structure in LIMUTIL covers only `>= 800` (BR-13) and `< 500` (BR-14). No code acts on the range 500–799. The candidate is passed through unchanged.

**Corroboration**: GM-001 — risk_score: 650 → expected_limit: 5000.00 (no adjustment) ✓. GM-009 — fallback score 650 → expected_limit: 5000.00 ✓. `baseline-us-gold` in `tests/golden-master-cases.yaml` — risk_score: 725 → expected_limit: 5000.00 ✓.

**Conflicting evidence / ambiguity**: The boundaries are asymmetric. The lower threshold is `< 500` (strict), meaning score 500 is neutral. The upper threshold is `>= 800` (inclusive), meaning score 800 triggers a reduction. Scores of exactly 500 and exactly 800 are handled differently: 500 is neutral, 800 is reduced. Whether this boundary placement is deliberate business policy or an implementation artifact is unresolved.

---

## Category 8 — Timeout and Fallback Behavior

---

### BR-16-RISK — When risk scoring is unavailable, a deterministic fallback score of 650 is used

**Plain language**: If the external risk scoring service cannot be reached — whether due to a timeout or a communication error — a fixed fallback risk score of 650 is substituted. Authorization proceeds normally using this score. The authorization does not block or fail because risk is unavailable.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/RISKFBK.cbl:10-12`](src/cobol/RISKFBK.cbl:10), [`src/cobol/TRNLIM01.cbl:18-20`](src/cobol/TRNLIM01.cbl:18), [`mq/queues.yaml:11-13`](mq/queues.yaml:11)

**Implementation evidence**:
```cobol
*> Deterministic fallback when external risk is unavailable.
MOVE 650 TO LC-RISK-SCORE
MOVE 'N' TO LC-RISK-AVAILABLE     ← RISKFBK.cbl:10-12
```
```cobol
IF LC-RISK-AVAILABLE NOT = 'Y'
   CALL 'RISKFBK' USING AUTH-REQUEST LIMIT-CONTEXT ← TRNLIM01.cbl:18-20
```
```yaml
timeout_behavior:
  program: RISKFBK
  rule: deterministic_fallback     ← mq/queues.yaml:11-13
```

**Corroboration**: GM-009 — `risk_available: false, fallback_score: 650, expected_limit: 5000.00`. Score 650 is in the neutral band (BR-15) → no adjustment → 5000.00 ✓.

**Conflicting evidence / ambiguity**:
1. The fallback is triggered when `LC-RISK-AVAILABLE NOT = 'Y'`. `CUSTRSK` sets `LC-RISK-AVAILABLE = 'N'` for **both** timeout (`RM-TIMEOUT`) and error (`RM-ERROR`) conditions. These two conditions are behaviorally collapsed — a transient network timeout and a persistent error produce the same fallback result. Whether the business intends to treat timeouts and hard errors differently is unknown.
2. `RISKFBK` sets `LC-RISK-AVAILABLE = 'N'` again (it was already `'N'` when `RISKFBK` is called). This is redundant but not harmful. The comment on `RISKFBK.cbl:10` confirms the intent. The unused field `AS-RISK-MODE` in `AUTH-RESPONSE` (`AUTHRESP.cpy:7`) was presumably intended to signal live vs. fallback mode to downstream consumers, but is never populated.
3. Score 650 places the fallback in the neutral band. This means MQ unavailability produces **the same result** as a 650-score live response — the fallback is mathematically equivalent to receiving a neutral risk assessment. Whether this equivalence is the business intent or a coincidence of the chosen fallback value is unresolved.

---

### BR-17-RISK — The risk score is sourced per-account from an external MQ service

**Plain language**: For each authorization, the system sends the account identifier to an external risk scoring service via a message queue and receives a numerical risk score (0–999) in response.

**Classification**: `[STRONGLY INFERRED]` — the MQ call and response structure are visible, but the internal behavior of the risk service and the `MQRSKGET` wrapper are not

**Source artifact**: [`src/cobol/CUSTRSK.cbl:13-24`](src/cobol/CUSTRSK.cbl:13), [`src/copybooks/RISKSCR.cpy`](src/copybooks/RISKSCR.cpy), [`mq/queues.yaml`](mq/queues.yaml), [`mq/message-contracts.md`](mq/message-contracts.md)

**Implementation evidence**:
```cobol
INITIALIZE RISK-MESSAGE
MOVE AR-ACCOUNT-ID TO RM-ACCOUNT-ID
CALL 'MQRSKGET' USING RISK-MESSAGE  ← CUSTRSK.cbl:13-16
```
Contract: `RM-RISK-SCORE PIC 9(3)` — range 000–999 (`RISKSCR.cpy:3`)

**Missing external behavior**: `MQRSKGET` source is absent. The timeout interval, retry logic, correlation mechanism, and the semantics of the risk service output (what determines a score of 850 vs. 450) are entirely unknown from this workspace.

---

## Category 9 — Product Maximum Ceiling

---

### BR-18 — The product maximum is an absolute ceiling on the final limit

**Plain language**: After all other limit factors have been applied, the final candidate is compared against the product maximum. If the candidate exceeds the product maximum, it is reduced to the product maximum. No other rule can produce a final limit above the product maximum.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/LIMUTIL.cbl:42-44`](src/cobol/LIMUTIL.cbl:42)

**Implementation evidence**:
```cobol
IF WS-CANDIDATE-LIMIT > LC-PRODUCT-MAX
   MOVE LC-PRODUCT-MAX TO WS-CANDIDATE-LIMIT
END-IF                             ← LIMUTIL.cbl:42-44
```

**Corroboration**: GM-010 — PLT1/US, `candidate_before_cap: 20000.00, expected_limit: 15000.00`. Product-max for PLT1/US = 15000 (seed data). 20000 > 15000 → capped to 15000 ✓.

**Conflicting evidence / ambiguity**:
1. The product-maximum cap is applied **after** the grandfathered exception override (BR-08). A grandfathered exception limit that exceeds the product maximum is silently reduced to the product maximum. For the test data: SYN000000777 has exception=12000.00; for GLD1/US, product-max=9000 → the exception would be capped to 9000. Whether grandfathered accounts should be exempt from the product ceiling is an unresolved business question.
2. The product-maximum cap is also applied **after** risk adjustments (BR-13, BR-14). A risk-adjusted value that still exceeds the product maximum is capped. This means the risk multiplier and the product-max cap can interact — e.g., if a 20% risk reduction brings a candidate below the product maximum, the ceiling has no further effect.
3. Under the policy-lookup fallback (BR-04), `LC-PRODUCT-MAX = 1000.00`. This means the product-maximum ceiling itself becomes 1,000.00 during a policy lookup failure, which is the same as the base limit fallback. The ceiling provides no additional headroom during fallback.

---

## Category 10 — Authorization Decision

---

### BR-19 — A transaction amount at or below the resolved limit is approved

**Plain language**: If the transaction amount is less than or equal to the final resolved limit, the authorization decision is `'A'` (Approved) with reason code `'0000'`.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/ATLAUTH.cbl:35-37`](src/cobol/ATLAUTH.cbl:35)

**Implementation evidence**:
```cobol
IF AR-AMOUNT <= LC-FINAL-LIMIT
   MOVE 'A' TO AS-DECISION
   MOVE '0000' TO AS-REASON-CODE  ← ATLAUTH.cbl:35-37
```

**Corroboration**: GM-012 — `amount: 5000.00, expected_decision: A`. Amount equals limit (5000 = 5000) → approved ✓. The boundary condition is `<=` (inclusive).

**Conflicting evidence / ambiguity**: None. The rule is unambiguous.

---

### BR-20 — A transaction amount above the resolved limit is declined

**Plain language**: If the transaction amount exceeds the final resolved limit, the authorization decision is `'D'` (Declined) with reason code `'LIMT'`.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/ATLAUTH.cbl:38-41`](src/cobol/ATLAUTH.cbl:38)

**Implementation evidence**:
```cobol
ELSE
   MOVE 'D' TO AS-DECISION
   MOVE 'LIMT' TO AS-REASON-CODE  ← ATLAUTH.cbl:38-41
```

**Corroboration**: GM-011 — `amount: 5500.00, expected_decision: D`. 5500 > 5000 → declined ✓.

**Conflicting evidence / ambiguity**: None. The rule is unambiguous.

---

### BR-21 — The resolved limit is recorded in the authorization response regardless of decision

**Plain language**: The final resolved limit is copied to the `AS-APPLIED-LIMIT` field of the authorization response before the approve/decline decision is evaluated. Both approved and declined authorizations carry the applied limit.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/ATLAUTH.cbl:33`](src/cobol/ATLAUTH.cbl:33)

**Implementation evidence**:
```cobol
MOVE LC-FINAL-LIMIT TO AS-APPLIED-LIMIT  ← ATLAUTH.cbl:33
```
This line appears before the `IF AR-AMOUNT <= LC-FINAL-LIMIT` block, so it executes unconditionally for all non-early-exit paths.

**Conflicting evidence / ambiguity**: `AS-APPLIED-LIMIT` is passed to `AUTHLOG` (`ATLAUTH.cbl:47`). The real `AUTHLOG` implementation is a stub — how the applied limit is used in the actual audit record is unknown. `AS-RISK-MODE` in the same response structure is never set, which may mean the response structure received by `AUTHLOG` is partially unpopulated.

---

### BR-22 — Every authorization attempt generates an audit record

**Plain language**: An audit record is written on every authorization path — including early exits due to invalid account or missing MCC, and both approved and declined limit-based decisions.

**Classification**: `[STRONGLY INFERRED]`

**Source artifact**: [`src/cobol/ATLAUTH.cbl:20`](src/cobol/ATLAUTH.cbl:20), [`src/cobol/ATLAUTH.cbl:28`](src/cobol/ATLAUTH.cbl:28), [`src/cobol/ATLAUTH.cbl:43`](src/cobol/ATLAUTH.cbl:43)

**Implementation evidence**: `PERFORM WRITE-AUDIT` is called on all three exit paths:
- After account validation failure (line 20)
- After merchant validation failure (line 28)
- After limit decision (line 43)

**Missing external behavior**: `AUTHLOG` is a stub. Whether the real audit implementation records all paths identically, differentiates by reason code, or performs additional actions (CICS writes, DB2 inserts) is unknown.

---

## Category 11 — Ordering and Precedence

---

### BR-23 — Account and merchant validation precede limit calculation

**Plain language**: Account validation and merchant validation are checked first. If either fails, the authorization is declined and no limit calculation is performed.

**Classification**: `[EXPLICIT]`

**Source artifact**: [`src/cobol/ATLAUTH.cbl:16-30`](src/cobol/ATLAUTH.cbl:16)

**Implementation evidence**: Both `ACCTVAL` (line 16) and `MERCHCHK` (line 24) are called and checked with early `GOBACK` before `TRNLIM01` is called (line 32).

---

### BR-24 — Within limit calculation, caps are applied in a fixed sequence

**Plain language**: The limit resolution algorithm in `LIMUTIL` applies caps in this fixed order:

1. Start with base limit (from policy)
2. Apply jurisdiction cap (if lower and > 0)
3. Apply MCC cap (if lower and > 0)
4. Apply temporary customer control (if lower and > 0)
5. If grandfathered — replace candidate with exception limit (all prior caps overridden)
6. If not grandfathered — apply risk adjustment (score ≥ 800: ×0.80; score < 500: ×0.70; 500–799: no change)
7. Apply product maximum ceiling (always)

**Classification**: `[EXPLICIT]` (the sequence is directly read from the code in order)

**Source artifact**: [`src/cobol/LIMUTIL.cbl:12-46`](src/cobol/LIMUTIL.cbl:12)

**Conflicting evidence / ambiguity**: The sequence is load-bearing — steps 5 and 7 are the critical ordering observations. Step 5 (grandfathered replaces prior caps) means jurisdiction, MCC, and temp caps have no effect when grandfathered is active. Step 7 (product-max applied last) means the product ceiling applies even to grandfathered exceptions. Neither ordering is documented in a business specification within the workspace.

---

### BR-25 — Input sub-programs to the limit calculation are called in a fixed sequence

**Plain language**: The six programs that populate the limit context are called in this fixed order: (1) policy lookup, (2) exception lookup, (3) temporary control, (4) MCC valuation, (5) risk scoring, (5a) risk fallback if needed, (6) final limit calculation. Each program's output is visible to all subsequent programs via the shared context structure.

**Classification**: `[EXPLICITLY OBSERVED]` (the sequence is directly read from `TRNLIM01`; whether the order is semantically intentional beyond what `LIMUTIL` requires is an inference)

**Source artifact**: [`src/cobol/TRNLIM01.cbl:12-22`](src/cobol/TRNLIM01.cbl:12)

**Conflicting evidence / ambiguity**: The MQ call (`CUSTRSK`) is step 5 — it is the last input-gathering step before the final calculation. This means the MQ call happens on every authorization regardless of whether an exception or temp-control cap would make the risk score irrelevant (e.g., when `LC-GRANDFATHERED = 'Y'`, the risk score is ignored in `LIMUTIL`, but the MQ call was already made). There is no short-circuit to skip the MQ call for grandfathered accounts. Whether this is an intentional design (always obtain a risk signal regardless of use) or an optimization gap cannot be determined from the source.

---

## Conflict and Ambiguity Register

| ID | Rule(s) | Nature | Source of Conflict |
|---|---|---|---|
| C-01 | BR-13 | `tests/golden-master-cases.yaml` expects `expected_limit: 6000.00` for risk_score=825 (GLD1/US), implying risk increases the limit. LIMUTIL produces 5000×0.80=4000. `tests/golden-master/cases.yaml` GM-007 expects 4000.00 for risk=850. The two test files are contradictory for the high-risk branch. | `tests/golden-master-cases.yaml:8-13` vs `tests/golden-master/cases.yaml:58-64` vs `LIMUTIL.cbl:33-34` |
| C-02 | BR-08, BR-18 | Grandfathered exception override is applied before product-max ceiling. An exception limit exceeding the product-max is silently reduced. Whether grandfathered accounts should be exempt from the product ceiling is unresolved. | `LIMUTIL.cbl:30-44`; `vsam/synthetic-exceptions.csv:3` (SYN000000777: exception=12000 > GLD1 product-max=9000) |
| C-03 | BR-09 | `ER-EXPIRY-DATE` is declared but never evaluated. Active-flag management depends on `EXCREC01` which is a stub. Whether date-based expiry is intended to be enforced at runtime or by batch is unresolved. | `EXCEPTREC.cpy:4`; `EXCEPT01.cbl:32`; `EXCREC01.cbl:6` |
| C-04 | BR-16-RISK, BR-17-RISK | `RM-TIMEOUT` and `RM-ERROR` produce identical fallback behavior. Business intent for differentiating timeout vs. error is unresolved. `AS-RISK-MODE` in `AUTH-RESPONSE` is unused but likely intended to signal fallback mode. | `CUSTRSK.cbl:18-24`; `AUTHRESP.cpy:7` |
| C-05 | BR-04 | Policy lookup failure silently applies 1,000.00 floor with no error propagation. Business intent of the value 1,000.00 as a fallback floor is undocumented. | `LIMITPOL.cbl:29-33` |
| C-06 | BR-13, BR-14, BR-15 | Risk score semantics run counter to standard credit-bureau convention (higher score = tighter limit). GM-008 description explicitly labels this as intentional for this estate. `tests/golden-master-cases.yaml` case label "high-risk-score-increase" and expected value suggest a different assumption was in play when that file was authored. | `mq/message-contracts.md:7`; `tests/golden-master/cases.yaml:66-68`; `tests/golden-master-cases.yaml:8-13` |

---

## Summary Table

| ID | Rule Category | Classification | Golden-Master Cases | Conflicts / Open Questions |
|---|---|---|---|---|
| BR-01 | Account validation pre-condition | EXPLICIT | — | Validates presence only; no semantic validation |
| BR-02 | Merchant validation pre-condition | EXPLICIT | — | Validates presence only |
| BR-03 | Base limit from product + jurisdiction policy | EXPLICIT | GM-001, GM-003, GM-010 | EFFECTIVE_DATE not filtered; multi-row risk (SQLCODE -811) |
| BR-04 | Policy failure floor of 1,000.00 | EXPLICIT / UNRESOLVED | — | Silent failure; 1,000.00 value undocumented |
| BR-05 | Jurisdiction cap | EXPLICIT | GM-003 | Zero-juris treated as no cap; behavior under fallback |
| BR-06 | Customer temporary control | EXPLICIT | GM-001, GM-004 | Population mechanism unknown |
| BR-07 | Temp-control ordering (before exception) | STRONGLY INFERRED | GM-004 | Ordering immaterial when grandfathered=Y |
| BR-08 | Grandfathered exception replaces all caps | EXPLICIT | GM-002 | Applied before product-max; grandfathered vs. ceiling conflict (C-02) |
| BR-09 | Grandfathered requires ER-ACTIVE='Y' | EXPLICIT | GM-002 | ER-EXPIRY-DATE ignored; EXCREC01 stub (C-03) |
| BR-10 | MCC 7995 cap = 1,000.00 | EXPLICIT | GM-005 | Hardcoded; not configurable |
| BR-11 | MCC 6051 cap = 2,000.00 | EXPLICIT | GM-006 | Hardcoded; not configurable |
| BR-12 | All other MCCs uncapped | EXPLICIT | GM-001, GM-007, GM-008 | Sentinel 9999999.99 |
| BR-13 | Risk ≥ 800 → ×0.80 | EXPLICIT / UNRESOLVED direction | GM-007 | **C-01: test file conflict**; C-06: counter-intuitive direction |
| BR-14 | Risk < 500 → ×0.70 | EXPLICIT / UNRESOLVED direction | GM-008 | C-06: direction labeled intentional in GM-008 |
| BR-15 | Risk 500–799 → no adjustment | EXPLICIT (by omission) | GM-001, GM-009 | Boundary asymmetry (500 neutral, 800 reduces) |
| BR-16-RISK | MQ unavailable → fallback score 650 | EXPLICIT | GM-009 | Timeout and error collapsed; AS-RISK-MODE unused (C-04) |
| BR-17-RISK | Risk score sourced from MQ per account | STRONGLY INFERRED | GM-007, GM-008, GM-009 | MQRSKGET absent; timeout interval unknown |
| BR-18 | Product maximum is absolute ceiling | EXPLICIT | GM-010 | Applies to grandfathered exceptions (C-02); applies under fallback |
| BR-19 | Amount ≤ limit → approve | EXPLICIT | GM-012 | Boundary is ≤ (inclusive) |
| BR-20 | Amount > limit → decline (LIMT) | EXPLICIT | GM-011 | None |
| BR-21 | Applied limit recorded unconditionally | EXPLICIT | — | AUTHLOG is stub; AS-RISK-MODE never set |
| BR-22 | Audit on all paths | STRONGLY INFERRED | — | AUTHLOG is stub; real behavior unknown |
| BR-23 | Validation guards precede limit calc | EXPLICIT | — | None |
| BR-24 | Fixed limit-resolution sequence | EXPLICIT | All GM cases | Sequence is load-bearing; undocumented in spec |
| BR-25 | Fixed input-gathering sequence | EXPLICITLY OBSERVED | — | MQ called even for grandfathered accounts |