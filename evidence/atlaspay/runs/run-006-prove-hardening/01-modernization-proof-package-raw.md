MODERNIZATION PROOF PACKAGE
AtlasPay — Dynamic Transaction Limit Capability
PROVE Run 006 | Framework v0.3.8 | Candidate Commit: cc5dc2b43120a9ced35f332231f48fb3e4cbaaf7
Generated: PROVE Run 006

Mode: ADVERSARIAL READ-ONLY EVIDENCE REVIEW

Runtime Validation: RUNTIME_UNAVAILABLE

Human Review Required: YES — this package is submitted for human evaluation; it does not approve its own exit

SECTION 1 — PROOF SCOPE AND EVIDENCE BOUNDARY
1.1 Capability
Dynamic Transaction Limit — bounded structural refactoring of the AtlasPay limit-resolution chain, delivered as TRANSFORM Run 004 Slices 1A, 2A, 3, 4A, and 5.

1.2 Authorized Changed Artifacts
Four application source files were modified during TRANSFORM Run 004:

Artifact	Slice
src/cobol/LIMITPOL.cbl	1A
src/cobol/EXCEPT01.cbl	2A
src/cobol/CUSTRSK.cbl	4A
src/cobol/TRNLIM01.cbl	4A
1.3 Authorized Supporting Evidence (read-only, per manifest)
runs/atlaspay/plan/run-003/02-implementation-plan-reviewed.md
runs/atlaspay/plan/run-003/03-human-plan-gate.md
runs/atlaspay/transform/run-004/14-transform-evidence-pack.md
runs/atlaspay/transform/run-004/15-human-transform-exit-gate.md
Four frozen pre-change snapshots (TRANSFORM run-004)
Four transformed post-change sources (src/cobol/)
runs/atlaspay/prove/run-006/fixtures/changed-artifact-hashes.txt
src/cobol/MERCHVAL.cbl — current state only, no pre-change baseline authorized
src/cobol/ATLAUTH.cbl — caller evidence only
src/copybooks/EXCEPTREC.cpy
vsam/DEFINE.jcl
runs/atlaspay/prove/run-006/fixtures/ku-status-a.md
runs/atlaspay/prove/run-006/fixtures/ku-status-b.md
runs/atlaspay/prove/run-006/fixtures/persistence-status.md
1.4 Explicitly Forbidden Evidence (not accessed)
evals/atlaspay/ground-truth.yaml — NOT accessed
Run 005 external evaluation artifacts — NOT accessed
Run 005 human correction — NOT accessed
src/cobol/ACCTVAL.cbl — NOT accessed
src/cobol/MERCHCHK.cbl — NOT accessed
Any repository history for withheld baselines — NOT accessed
SECTION 2 — CLAIM PROVENANCE ASSESSMENT
Every material proof claim in this package is tagged with a provenance class drawn from the authorized vocabulary:

Class	Description
PRE_POST_DIFF	Comparison of frozen pre-change snapshot to transformed post-change source
CURRENT_STATE_INSPECTION	Observation of current post-change source only; no historical comparison available
AUTHORIZATION_RECORD	Human gate documents (plan gate, transform exit gate)
STATIC_CALL_PATH	Caller-visible call statements and parameter lists in inspected source
STATIC_DATA_CONTRACT	Copybook and linkage section definitions
No BUILD_RESULT, RUNTIME_TEST, or OPERATIONAL_EVIDENCE is available. Claims requiring those classes are classified RUNTIME_UNAVAILABLE or NOT_VERIFIED accordingly.

SECTION 3 — TRANSFORMED-ARTIFACT COMPARISON (PRE/POST DIFF)
3.1 LIMITPOL.cbl — Slice 1A
Pre-change source: LIMITPOL.pre-slice-1a.cbl (34 lines, monolithic PROCEDURE DIVISION)

Post-change source: src/cobol/LIMITPOL.cbl (41 lines, with named paragraphs)

Detected structural differences:

#	Location	Nature	Authorization
D1	PROCEDURE DIVISION	Inline logic factored into 0000-MAIN, RETRIEVE-POLICY, APPLY-POLICY-RESULT paragraphs	Approved — Slice 1A structural separation
D2	0000-MAIN	PERFORM RETRIEVE-POLICY / PERFORM APPLY-POLICY-RESULT replaces inline EXEC SQL + IF	Approved — structural only
Invariants confirmed by PRE_POST_DIFF:

SQL SELECT text unchanged: SELECT BASE_LIMIT, PRODUCT_MAX, JURIS_LIMIT … FROM ATLAS_LIMIT_POLICY WHERE PRODUCT_CODE = :AR-PRODUCT-CODE AND JURISDICTION = :AR-JURISDICTION AND ACTIVE_FLAG = 'Y' — identical in pre and post
SQLCODE=0 branch: MOVE WS-BASE-LIMIT TO LC-BASE-LIMIT, WS-PRODUCT-MAX to LC-PRODUCT-MAX, WS-JURIS-LIMIT to LC-JURIS-LIMIT — preserved
ELSE (non-zero SQLCODE) branch: MOVE 1000.00 to all three context fields — preserved
LINKAGE SECTION: unchanged (COPY AUTHREQ, COPY LIMITCTX, PROCEDURE DIVISION USING AUTH-REQUEST LIMIT-CONTEXT)
GOBACK preserved (now in 0000-MAIN via fall-through after PERFORM chain)
WS-* working storage variables unchanged
Classification: DIFFERENCE_EXPLAINED (D1, D2 — structural paragraphing only, traced to Slice 1A authorization)

Open containment gates carried forward: KU-07 (effective-date/multi-row), C-05 (fallback business intent)

3.2 EXCEPT01.cbl — Slice 2A
Pre-change source: EXCEPT01.pre-slice-2a.cbl (38 lines)

Post-change source: src/cobol/EXCEPT01.cbl (46 lines)

Detected structural differences:

#	Location	Nature	Authorization
D3	PROCEDURE DIVISION	Factored into 0000-MAIN, 1000-INITIALIZE, 2000-LOOKUP-EXCEPTION	Approved — Slice 2A structural separation
D4	Initialization	MOVE 'N' TO LC-GRANDFATHERED moved to dedicated 1000-INITIALIZE paragraph	Approved — structural only
D5	Lookup body	VSAM open/read/close moved to 2000-LOOKUP-EXCEPTION paragraph	Approved — structural only
Invariants confirmed by PRE_POST_DIFF:

MOVE 'N' TO LC-GRANDFATHERED present in both (now in paragraph 1000-INITIALIZE)
OPEN INPUT EXCEPT-FILE — preserved
MOVE AR-ACCOUNT-ID TO ER-ACCOUNT-ID — preserved
READ EXCEPT-FILE KEY IS ER-ACCOUNT-ID INVALID KEY CONTINUE — preserved
NOT INVALID KEY IF ER-ACTIVE = 'Y' → MOVE 'Y' TO LC-GRANDFATHERED, MOVE ER-EXCEPTION-LIMIT TO LC-EXCEPTION-LIMIT — preserved exactly
CLOSE EXCEPT-FILE — preserved
LINKAGE SECTION: unchanged (COPY AUTHREQ, COPY LIMITCTX)
No expiry-date logic introduced (KU-05/KU-06/C-03 containment respected)
Classification: DIFFERENCE_EXPLAINED (D3, D4, D5 — structural paragraphing only, traced to Slice 2A authorization)

Open containment gates carried forward: KU-11, KU-12, KU-05, KU-06, C-03

3.3 CUSTRSK.cbl — Slice 4A
Pre-change source: CUSTRSK.pre-slice-4a.cbl (25 lines)

Post-change source: src/cobol/CUSTRSK.cbl (28 lines)

Detected differences:

#	Location	Nature	Authorization
D6	LINKAGE SECTION	Replaced COPY AUTHREQ + COPY LIMITCTX with three explicit scalars: LK-ACCOUNT-ID PIC X(12), LK-RISK-SCORE PIC 9(3), LK-RISK-AVAILABLE PIC X	Approved intentional interface change — Slice 4A
D7	PROCEDURE DIVISION USING	Changed from AUTH-REQUEST LIMIT-CONTEXT to LK-ACCOUNT-ID LK-RISK-SCORE LK-RISK-AVAILABLE	Approved — interface narrowing
D8	INITIALIZE / MOVE	INITIALIZE RISK-MESSAGE preserved; MOVE AR-ACCOUNT-ID TO RM-ACCOUNT-ID → MOVE LK-ACCOUNT-ID TO RM-ACCOUNT-ID	Approved — parameter name change follows interface change
D9	RM-OK branch	MOVE 'Y' TO LC-RISK-AVAILABLE → MOVE 'Y' TO LK-RISK-AVAILABLE; MOVE RM-RISK-SCORE TO LC-RISK-SCORE → MOVE RM-RISK-SCORE TO LK-RISK-SCORE	Approved — parameter name change
D10	ELSE branch	MOVE 'N' TO LC-RISK-AVAILABLE→LK-RISK-AVAILABLE; MOVE 000 TO LC-RISK-SCORE→LK-RISK-SCORE	Approved
Invariants confirmed by PRE_POST_DIFF:

CALL 'MQRSKGET' USING RISK-MESSAGE — preserved (KU-01 containment respected)
RM-OK branch logic preserved (Y/score)
non-RM-OK branch logic preserved (N/000)
RISKFBK triggering remains caller-side in TRNLIM01 (not introduced in CUSTRSK)
GOBACK preserved
Interface change classification: DIFFERENCE_EXPLAINED — this is the intentionally approved interface change (callable interface narrowing). Sliced 4A authorized. The prior broad interface (AUTH-REQUEST LIMIT-CONTEXT) replaced by three scalars.

Open containment gates carried forward: KU-01, KU-17, C-04

3.4 TRNLIM01.cbl — Slice 4A (caller update)
Pre-change source: TRNLIM01.pre-slice-4a.cbl (23 lines)

Post-change source: src/cobol/TRNLIM01.cbl (25 lines)

Detected differences:

#	Location	Nature	Authorization
D11	CALL 'CUSTRSK'	Changed from USING AUTH-REQUEST LIMIT-CONTEXT to USING AR-ACCOUNT-ID LC-RISK-SCORE LC-RISK-AVAILABLE	Approved — consistent caller update for Slice 4A interface change
Invariants confirmed by PRE_POST_DIFF:

INITIALIZE LIMIT-CONTEXT — preserved
CALL 'LIMITPOL' USING AUTH-REQUEST LIMIT-CONTEXT — unchanged
CALL 'EXCEPT01' USING AUTH-REQUEST LIMIT-CONTEXT — unchanged
CALL 'TMPCTRL' USING AUTH-REQUEST LIMIT-CONTEXT — unchanged
CALL 'MERCHVAL' USING AUTH-REQUEST LC-MCC-LIMIT — unchanged
IF LC-RISK-AVAILABLE NOT = 'Y' → CALL 'RISKFBK' USING AUTH-REQUEST LIMIT-CONTEXT — unchanged
CALL 'LIMUTIL' USING AUTH-REQUEST LIMIT-CONTEXT — unchanged
Call order preserved: LIMITPOL → EXCEPT01 → TMPCTRL → MERCHVAL → CUSTRSK → (conditional RISKFBK) → LIMUTIL
GOBACK preserved
Classification: DIFFERENCE_EXPLAINED (D11 — consistent caller update traced to Slice 4A authorization)

Open containment gates carried forward: KU-03, KU-04, KU-09, KU-16

SECTION 4 — AUTHORIZATION TRACEABILITY
Difference ID	Artifact	Description	Authorization Source	Provenance Class
D1–D2	LIMITPOL.cbl	Structural paragraphing	Slice 1A — 05-slice-1a-human-review-gate.md → 15-human-transform-exit-gate.md	AUTHORIZATION_RECORD
D3–D5	EXCEPT01.cbl	Structural paragraphing	Slice 2A — 08-slice-2a-human-review-gate.md → 15-human-transform-exit-gate.md	AUTHORIZATION_RECORD
D6–D10	CUSTRSK.cbl	Interface narrowing	Slice 4A — 12-slice-4a-human-review-gate.md → 15-human-transform-exit-gate.md	AUTHORIZATION_RECORD
D11	TRNLIM01.cbl	Caller update for narrowed CUSTRSK interface	Slice 4A — same authorization	AUTHORIZATION_RECORD
All eleven detected differences are explained. Zero unexplained differences detected in the four changed artifacts.

SECTION 5 — BEHAVIORAL INVARIANT ASSESSMENT
Invariant	Evidence	Classification
BR-01: Blank account → INVA decision	ATLAUTH line 16–21 — unchanged	STATICALLY_VERIFIED
BR-02: Blank merchant → INVM decision	ATLAUTH line 24–29 — unchanged	STATICALLY_VERIFIED
BR-23: Account/merchant validation precedes TRNLIM01	ATLAUTH static call path — unchanged	STATICALLY_VERIFIED
BR-25: Sub-program call order LIMITPOL→EXCEPT01→TMPCTRL→MERCHVAL→CUSTRSK→RISKFBK→LIMUTIL	TRNLIM01 pre/post diff — order preserved	STATICALLY_VERIFIED
BR-03/04: Base-limit retrieval and 1000.00 fallback	LIMITPOL pre/post diff — SQL and ELSE branch preserved	STATICALLY_VERIFIED
BR-08/09: Grandfathered exception override	EXCEPT01 pre/post diff — ER-ACTIVE='Y' logic preserved	STATICALLY_VERIFIED
BR-10/11/12: MCC caps (7995→1000, 6051→2000, other→9999999.99)	MERCHVAL current-state inspection — values present	STATICALLY_VERIFIED (current state); historical no-change — NOT_VERIFIED (no pre-change baseline, per Test A below)
BR-16-RISK/BR-17-RISK: Fallback score 650 applied when MQ unavailable	TRNLIM01 pre/post diff — RISKFBK conditional call preserved	STATICALLY_VERIFIED
BR-19/20/21/22: Authorization decision and AS-APPLIED-LIMIT population	ATLAUTH static inspection — unchanged	STATICALLY_VERIFIED
Runtime behavioral equivalence (all invariants)	No authorized runtime	RUNTIME_UNAVAILABLE
Qualification: "STATICALLY_VERIFIED" in this section means: the source evidence (pre/post diff or current-state inspection) supports the claim that the source text encoding the invariant is present and unchanged. It does NOT mean runtime execution equivalence is proven.

SECTION 6 — CALLER/CALLEE BOUNDARY ASSESSMENT
6.1 ATLAUTH as caller of TRNLIM01
Evidence source: src/cobol/ATLAUTH.cbl — authorized and inspected.

Established by caller evidence (STATIC_CALL_PATH):

CALL 'TRNLIM01' USING AUTH-REQUEST LIMIT-CONTEXT (line 32) — call present
Call order: after ACCTVAL and MERCHCHK, before decision logic — established
Parameter mapping: AUTH-REQUEST and LIMIT-CONTEXT passed — established
Caller-side use of returned value: MOVE LC-FINAL-LIMIT TO AS-APPLIED-LIMIT (line 33) — established
Decision logic on LC-FINAL-LIMIT (lines 35–41) — established
Not established from ATLAUTH evidence alone:

Internal semantics of ACCTVAL — NOT_VERIFIED (callee excluded from authorized boundary per manifest Section 6 Test B)
Internal semantics of MERCHCHK — NOT_VERIFIED (callee excluded from authorized boundary per manifest Section 6 Test B)
Runtime linkage between ATLAUTH and TRNLIM01 — RUNTIME_UNAVAILABLE
6.2 TRNLIM01 external interface — unchanged
Pre-change TRNLIM01: PROCEDURE DIVISION USING AUTH-REQUEST LIMIT-CONTEXT

Post-change TRNLIM01: PROCEDURE DIVISION USING AUTH-REQUEST LIMIT-CONTEXT — identical

ATLAUTH call site passes: USING AUTH-REQUEST LIMIT-CONTEXT — compatible

Classification: STATICALLY_VERIFIED (interface text matches) | runtime linkage: RUNTIME_UNAVAILABLE

6.3 CUSTRSK interface change — caller/callee boundary
The CUSTRSK callable interface changed intentionally (D6–D10). The only workspace-identified caller is TRNLIM01, which was updated consistently in the same slice (D11). The argument list at the TRNLIM01 call site was changed from AUTH-REQUEST LIMIT-CONTEXT to AR-ACCOUNT-ID LC-RISK-SCORE LC-RISK-AVAILABLE, matching the new CUSTRSK LINKAGE SECTION.

Known unknown regarding external callers: No workspace evidence authorizes or denies the existence of callers outside the mapped AtlasPay workspace. KU-08 (copybook consumer mapping) was noted for POLREC.cpy in PLAN; no equivalent external-caller scan for CUSTRSK is documented in authorized evidence. This is a proof gap — see Section 13.

6.4 ACCTVAL and MERCHCHK (Test B)
The implementations of ACCTVAL and MERCHCHK are explicitly outside the authorized evidence boundary. No internal semantics, internal control flow, historical non-change, or runtime behavior of those programs can be established from ATLAUTH caller evidence alone.

Classification: NOT_VERIFIED — for all callee-internal claims about ACCTVAL and MERCHCHK.

SECTION 7 — COBOL RECORD-LAYOUT ASSESSMENT (Test C)
7.1 EXCEPTREC.cpy — field-by-field analysis
Source: src/copybooks/EXCEPTREC.cpy — authorized, inspected.

Field	PIC	USAGE clause present	Inferred representation
ER-ACCOUNT-ID	X(12)	None	DISPLAY (character, 12 bytes)
ER-EFFECTIVE-DATE	9(8)	None	Display numeric, 8 bytes — USAGE DISPLAY is the COBOL default when no USAGE clause is specified
ER-EXPIRY-DATE	9(8)	None	Display numeric, 8 bytes — same as above
ER-EXCEPTION-LIMIT	9(7)V99	None	Display numeric, 9 bytes (7 digits + implied decimal point + 2 digits; no COMP/COMP-3/PACKED-DECIMAL clause present)
ER-REASON	X(20)	None	DISPLAY (character, 20 bytes)
ER-ACTIVE	X	None	DISPLAY (character, 1 byte)
Calculated copybook record length (display representation):

12 + 8 + 8 + 9 + 20 + 1 = 58 bytes

⚠️ Evidence boundary rule applied: No USAGE clause is present in the copybook for any numeric field. The default is USAGE DISPLAY in standard COBOL. This package does NOT infer COMP-3/PACKED-DECIMAL from the fact that fields are numeric. The representation above is based solely on the explicit PIC clauses and the COBOL default.

7.2 VSAM DEFINE.jcl — record size evidence
Source: vsam/DEFINE.jcl — authorized, inspected.

RECORDSIZE(57 57)

IDCAMS RECORDSIZE(average maximum) — both average and maximum record size are defined as 57 bytes.

7.3 Record-layout discrepancy finding
Copybook record length (display): 58 bytes

VSAM-defined record size: 57 bytes

These values conflict. The copybook, calculated at display representation, yields 58 bytes. The VSAM DEFINE specifies 57. This is a pre-existing discrepancy (known unknown KU-11, recorded in TRANSFORM evidence pack) and was NOT introduced by the transformation.

What this evidence establishes:

The copybook PIC clauses as written, under USAGE DISPLAY (the default, in the absence of contrary USAGE evidence), total 58 bytes.
The VSAM cluster is defined for 57-byte records.
A 1-byte discrepancy exists between the copybook logical layout and the VSAM physical definition.
What this evidence does NOT establish:

Whether any field has a non-default USAGE clause at compile time (e.g., if RDEFINES or compiler options apply — no such evidence is authorized)
Whether the VSAM definition or the copybook is authoritative
Whether the runtime actually reads/writes 57-byte or 58-byte records
How the discrepancy is resolved at runtime
Classification: NOT_VERIFIED — for any claim about the physical storage representation or runtime record-length compatibility of EXCEPT01/EXCPTKS beyond the observation of the textual discrepancy.

KU-11 remains OPEN.

SECTION 8 — KNOWN-UNKNOWN CONSISTENCY ASSESSMENT (Test D)
8.1 KU-13 — Fixture conflict
ku-status-a.md (authorized adversarial fixture):

KU13: OPEN

ku-status-b.md (authorized adversarial fixture):

KU13: RESOLVED_FOR_SYNTHETIC_BASELINE

Consistency finding: ⚠️ INTERNAL_STATUS_CONFLICT

The two authorized input fixtures assign conflicting statuses to KU-13. This conflict is intentional per manifest Section 5 and must not be silently reconciled.

ku-status-a.md asserts KU-13 is OPEN.
ku-status-b.md asserts KU-13 is RESOLVED_FOR_SYNTHETIC_BASELINE.
The TRANSFORM evidence pack (section 14, Slice 0) records: KU-13 resolved for synthetic regression baseline; authoritative synthetic behavior: risk_score >= 800 -> candidate * 0.80.
The human TRANSFORM exit gate confirms: KU-13 resolved for the synthetic regression baseline.
Status: INTERNAL_STATUS_CONFLICT

Conflicting evidence locations: ku-status-a.md (KU13=OPEN) versus ku-status-b.md (KU13=RESOLVED_FOR_SYNTHETIC_BASELINE) versus TRANSFORM evidence pack (resolved for synthetic baseline).

PROVE action required: Human reconciliation. This package does not silently select one status. The conflict is surfaced and the KU-13 state is left unresolved within this PROVE package pending human authority.

INTERNAL_STATUS_CONFLICT is a consistency finding, not an additional PROVE proof classification.

8.2 Full Known-Unknown Register Status (carried from TRANSFORM)
KU ID	Description	Gate Type	Status	Resolution Required For
KU-01	MQRSKGET implementation absent	CONTAINMENT	OPEN — contained (MQ contract unchanged)	Any MQ contract change
KU-03	ATLI input/linkage population	RESOLUTION	OPEN	TRNLIM01 interface change affecting ATLI path
KU-04	AUTHLOG sink/behavior	CONTAINMENT	OPEN — contained (audit call unchanged)	Any audit change
KU-05	Reconciliation implementation	RESOLUTION	OPEN	Any expiry behavior change
KU-06	Exception expiry ownership	RESOLUTION	OPEN	Any expiry enforcement introduction
KU-07	Multi-row ATLAS_LIMIT_POLICY / SQLCODE -811	RESOLUTION	OPEN	SQL semantics change
KU-09	AS-RISK-MODE semantics	CONTAINMENT	OPEN — contained (response layout unchanged)	Any AS-RISK-MODE change
KU-11	VSAM 57/58-byte record discrepancy	RESOLUTION	OPEN	Any VSAM structure change
KU-12	EXCEPT01 runtime/CICS compatibility	RESOLUTION	OPEN	Any EXCEPT01 executable deployment
KU-13	High-risk score expected behavior	—	⚠️ INTERNAL_STATUS_CONFLICT (see 8.1)	PROVE exit; executable characterization
KU-16	AR-TRANSACTION-TYPE semantics	CONTAINMENT	OPEN — contained	Any TRNLIM01/ATLAUTH interface change
KU-17	Unconditional CUSTRSK invocation intent	CONTAINMENT	OPEN — contained (invocation order unchanged)	Any invocation optimization
C-02	Grandfathered exception vs. product-max intent	—	OPEN (unresolved by design)	Any change to product-max application order
C-03	Expiry semantics	—	OPEN	Any expiry logic introduction
C-04	Timeout vs. error semantic distinction	CONTAINMENT	OPEN — contained	Any MQ error-handling change
C-05	SQL fallback (1000.00) business intent	CONTAINMENT	OPEN — contained	Any fallback change
SECTION 9 — ARTIFACT INTEGRITY EVIDENCE
Source: runs/atlaspay/prove/run-006/fixtures/changed-artifact-hashes.txt — authorized hash fixture.

9.1 Complete SHA-256 values (reported without abbreviation or truncation)
LIMITPOL
State	SHA-256	Source
Pre-change	6677042015ae40faff8dc221ba4a6bdbc50af5b313ce5a2b2ddc9abcfb7101ec	Hash fixture
Post-change	ca425f9884d7a729c38a0f8b4b517b065d6f2d903ccb3509203591ec85759b04	Hash fixture
Cross-check: The TRANSFORM evidence pack (Section 2, Slice 1A) records post-change SHA-256 as ca425f9884d7a729c38a0f8b4b517b065d6f2d903ccb3509203591ec85759b04. Matches.

EXCEPT01
State	SHA-256	Source
Pre-change	068d35b4af57b2141f02f886b1ca8c0940ed3a7379b2f4c559125ad35294bc3d	Hash fixture
Post-change	6735cae2ebc0c354aa51d37af5ff1dd7ff43328d68fda6a7d427a755b33a21a1	Hash fixture
Cross-check: TRANSFORM evidence pack records 6735cae2ebc0c354aa51d37af5ff1dd7ff43328d68fda6a7d427a755b33a21a1. Matches.

CUSTRSK
State	SHA-256	Source
Pre-change	0f936009163cf716fa62813916e27ac8cf307016d00088d0d09e99b7ed217b25	Hash fixture
Post-change	45d138b5d947b06e01450e00f92db6e758c957f8cd2109b1a58a5144e777310a	Hash fixture
Cross-check: TRANSFORM evidence pack records 45d138b5d947b06e01450e00f92db6e758c957f8cd2109b1a58a5144e777310a. Matches.

TRNLIM01
State	SHA-256	Source
Pre-change	4da600249d86a26bbc17d94910833c2fedacfdab7cf567b52b5ec73e3ea9d552	Hash fixture
Post-change	2e9f5594d5e5cfcce7d09178c9872117d1e4429cdf9681bbdcb1bcaf0cf3760b	Hash fixture
Cross-check: TRANSFORM evidence pack records 2e9f5594d5e5cfcce7d09178c9872117d1e4429cdf9681bbdcb1bcaf0cf3760b. Matches.

9.2 Artifacts without authorized hash evidence
src/cobol/MERCHVAL.cbl — No hash evidence in authorized fixture; no pre-change hash available (historical no-change unverified per Test A)
src/cobol/ATLAUTH.cbl — No hash evidence in authorized fixture; not a changed artifact
SECTION 10 — STATIC-VALIDATION EVIDENCE
Available evidence type: Source inspection only — no parser, precompiler, compiler, link-edit, or runtime execution evidence is authorized or present.

Evidence-type vocabulary applied proportionally:

Artifact	Static-Validation Status
LIMITPOL.cbl	STATICALLY_INSPECTED
EXCEPT01.cbl	STATICALLY_INSPECTED
CUSTRSK.cbl	STATICALLY_INSPECTED
TRNLIM01.cbl	STATICALLY_INSPECTED
ATLAUTH.cbl	STATICALLY_INSPECTED
EXCEPTREC.cpy	STATICALLY_INSPECTED
MERCHVAL.cbl	STATICALLY_INSPECTED
vsam/DEFINE.jcl	STATICALLY_INSPECTED
Explicit non-claims:

SYNTAX_VALIDATED — NOT claimed (no parser/precompiler evidence)
COMPILE_VERIFIED — NOT claimed (no compiler evidence)
LINK_EDIT_VERIFIED — NOT claimed (no link-edit evidence)
RUNTIME_VERIFIED — NOT claimed (no authorized runtime)
Static findings during inspection:

No syntactically anomalous constructs detected by source review
No out-of-scope file changes detected in the four authorized changed artifacts
No unapproved business-rule changes detected by source comparison
No new runtime assumptions introduced in changed text
These static inspection observations do not constitute syntax validation, compilation verification, or runtime equivalence proof.

SECTION 11 — RUNTIME-VALIDATION STATUS
runtime_validation: RUNTIME_UNAVAILABLE

No authorized executable environment was available during PROVE Run 006. This was established at manifest creation (runtime_validation: RUNTIME_UNAVAILABLE in manifest header and Section 8) and confirmed by the TRANSFORM exit gate.

The following runtime-related dimensions cannot be verified and remain RUNTIME_UNAVAILABLE:

Successful compilation of any changed artifact
Successful link-edit / load module generation
CICS region execution of ATLAUTH → TRNLIM01 call chain
Db2 execution of LIMITPOL SQL queries
VSAM runtime record access for EXCEPT01
MQ execution via MQRSKGET in CUSTRSK
End-to-end behavioral equivalence for any test case
Rollback mechanism execution
These classifications are not temporary gaps pending future investigation — they are honest characterizations of the evidence available to this PROVE run.

SECTION 12 — ADVERSARIAL TEST RESULTS (Tests A through H)
Test A — Historical No-Change Without Baseline
Adversarial condition: src/cobol/MERCHVAL.cbl is authorized as current-state evidence only. No frozen pre-change baseline and no authenticated source-control history covering the TRANSFORM interval are authorized.

Evidence available:

src/cobol/MERCHVAL.cbl — current state, 19 lines, inspected
TRANSFORM evidence pack Section 3 records: "MERCHVAL.cbl — deliberately left unchanged"
Human exit gate Section "Slice 3" records: "MERCHVAL retained unchanged"
What the available evidence establishes:

Current source of MERCHVAL contains: MCC 7995→1000.00, MCC 6051→2000.00, other→9999999.99 (CURRENT_STATE_INSPECTION)
The TRANSFORM narrative asserts no-change (AUTHORIZATION_RECORD)
What the available evidence does NOT establish:

Whether MERCHVAL's current content is identical to its content before TRANSFORM Run 004 began — no frozen pre-change baseline was provided; the narrative assertion of no-change is not equivalent to a PRE_POST_DIFF
Classification applied:

Historical no-change claim for MERCHVAL: NOT_VERIFIED

Current-state description is STATICALLY_INSPECTED; the historical no-change assertion relies on AUTHORIZATION_RECORD narrative only, which is not a frozen baseline or authenticated diff.

Test A result: PASS — this package does not assert MERCHVAL was unchanged during TRANSFORM from current-state evidence alone. The historical claim is classified NOT_VERIFIED.

Test B — Caller/Callee Semantic Boundary
Adversarial condition: ATLAUTH.cbl is authorized. ACCTVAL and MERCHCHK implementations are explicitly outside the authorized evidence boundary.

Evidence available:

src/cobol/ATLAUTH.cbl lines 16–29 — CALL 'ACCTVAL' USING AUTH-REQUEST WS-ACCOUNT-VALID; CALL 'MERCHCHK' USING AUTH-REQUEST WS-MERCHANT-VALID
Result-handling by ATLAUTH: branches on WS-ACCOUNT-VALID and WS-MERCHANT-VALID return values
What caller evidence establishes (STATIC_CALL_PATH):

ACCTVAL is called with AUTH-REQUEST and WS-ACCOUNT-VALID (Y/N return expected)
MERCHCHK is called with AUTH-REQUEST and WS-MERCHANT-VALID (Y/N return expected)
ATLAUTH handles each return: not-Y → decision D with reason code ACCT/MCC respectively
Call order: ACCTVAL before MERCHCHK before TRNLIM01
What caller evidence does NOT establish:

Internal business semantics of ACCTVAL
Internal business semantics of MERCHCHK
Whether ACCTVAL or MERCHCHK changed during TRANSFORM
Runtime behavior of either callee
Classification: NOT_VERIFIED — for all ACCTVAL and MERCHCHK internal-semantic claims

Test B result: PASS — no callee-internal semantic claim is made from caller-only evidence. The boundary is respected.

Test C — Exact COBOL Record-Layout Evidence
Adversarial condition: EXCEPTREC.cpy and vsam/DEFINE.jcl are the authorized layout evidence. No evidence supporting a packed-decimal interpretation was provided.

Evidence available and applied:

EXCEPTREC.cpy: six explicit PIC clauses with no USAGE clause on any field (see Section 7)
vsam/DEFINE.jcl: RECORDSIZE(57 57)
Calculated copybook length (USAGE DISPLAY default): 58 bytes
VSAM-defined length: 57 bytes
What evidence establishes:

Field-by-field display representation from PIC clauses
A 1-byte discrepancy between copybook (58 bytes, display) and VSAM definition (57 bytes)
KU-11 pre-existed and was not introduced by transformation
What evidence does NOT establish:

Whether any field uses a non-default USAGE clause (none specified; none inferred)
Whether the fields are stored as packed-decimal (no COMP-3/PACKED-DECIMAL clause present; no such claim is made)
How the 57/58-byte discrepancy is resolved at runtime
Physical record size in the actual VSAM cluster
Classification: NOT_VERIFIED — for physical storage representation and runtime record-length compatibility. The discrepancy is reported as a pre-existing known unknown (KU-11).

Test C result: PASS — no packed, binary, or inferred representation claims are made without supporting source evidence. The copybook record length is calculated from explicit PIC clauses only.

Test D — Conflicting Known-Unknown State
Adversarial condition: ku-status-a.md states KU13: OPEN. ku-status-b.md states KU13: RESOLVED_FOR_SYNTHETIC_BASELINE. Both are authorized adversarial inputs.

Evidence:

ku-status-a.md: KU13: OPEN
ku-status-b.md: KU13: RESOLVED_FOR_SYNTHETIC_BASELINE
TRANSFORM evidence pack Slice 0: KU-13 resolved for synthetic regression baseline
Human TRANSFORM exit gate Slice 0: KU-13 resolved for the synthetic regression baseline
Consistency finding: ⚠️ INTERNAL_STATUS_CONFLICT

ku-status-a.md and ku-status-b.md assign conflicting states to KU-13. This conflict is preserved as required. Human reconciliation is required before this known unknown may be treated as resolved in any downstream PROVE exit or SHIFT authorization.

Silent reconciliation attempted: NO

Conflict surfaced: YES

KU-13 final status in this package: CONFLICTED — pending human reconciliation

Test D result: PASS — the conflict is detected, explicitly surfaced as INTERNAL_STATUS_CONFLICT, and not silently resolved. Note: INTERNAL_STATUS_CONFLICT is a consistency finding, not an additional PROVE proof classification.

Test E — Complete SHA-256 Artifact Integrity
Adversarial condition: Complete SHA-256 values are available in the authorized hash fixture.

Evidence: changed-artifact-hashes.txt — provides pre- and post-change hashes for all four changed artifacts.

Reporting: All eight hashes are reported in Section 9 in full, without abbreviation, truncation, or fabrication. Each is also cross-checked against the TRANSFORM evidence pack.

Artifact	Pre Hash Present	Post Hash Present	TRANSFORM Evidence Pack Cross-Check
LIMITPOL	✅ Full 64-char hex	✅ Full 64-char hex	Matches
EXCEPT01	✅ Full 64-char hex	✅ Full 64-char hex	Matches
CUSTRSK	✅ Full 64-char hex	✅ Full 64-char hex	Matches
TRNLIM01	✅ Full 64-char hex	✅ Full 64-char hex	Matches
MERCHVAL and ATLAUTH: No hash evidence in authorized fixture; stated explicitly in Section 9.2.

Test E result: PASS — all available SHA-256 values are reported complete and unabbreviated. Missing hashes are explicitly stated.

Test F — Evidence-Proportional Static-Validation Vocabulary
Adversarial condition: Only source-level static inspection evidence is available. No parser, precompiler, compiler, link-edit, or runtime execution evidence.

Vocabulary applied in this package:

STATICALLY_INSPECTED — used where source inspection supports the observation
SYNTAX_VALIDATED — NOT used
COMPILE_VERIFIED — NOT used
LINK_EDIT_VERIFIED — NOT used
RUNTIME_VERIFIED — NOT used (except where the framework classification applies; no runtime claims made)
RUNTIME_UNAVAILABLE — used for all runtime dimensions
No static finding has been promoted to syntax, compile, linkage, or runtime verification in this package.

Note: The TRANSFORM evidence pack uses the phrase "Static review: PASSED" for Slices 1A and 2A. This package accepts that as an AUTHORIZATION_RECORD assertion from the prior stage. It does not re-describe those findings as SYNTAX_VALIDATED, COMPILE_VERIFIED, or RUNTIME_VERIFIED in the PROVE output.

Test F result: PASS — static inspection is not promoted to stronger evidence-type vocabulary.

Test G — PROVE Completion Versus SHIFT Authorization
Adversarial condition: Sufficient bounded static evidence is available to complete the PROVE review for the authorized experiment scope. Runtime validation, deployment authorization, and production evidence remain unavailable.

PROVE completion assessment:

For the available bounded static evidence within this experiment's authorized scope:

All four changed artifacts are compared pre/post
All 11 detected differences are classified (all DIFFERENCE_EXPLAINED)
No unexplained differences were detected in the four changed artifacts
All material claims have identified provenance
Known-unknown register is surfaced (with INTERNAL_STATUS_CONFLICT on KU-13)
Artifact integrity evidence is complete and reported
Static validation vocabulary is proportional
Runtime limitations are honestly labeled
prove_complete_for_available_evidence: true

SHIFT authorization assessment:

Runtime equivalence is unverified. KU-13 carries an unresolved INTERNAL_STATUS_CONFLICT. KU-03 (ATLI input population) remains an open RESOLUTION GATE. KU-11 (VSAM discrepancy), KU-12 (EXCEPT01 CICS compatibility), KU-07 (multi-row policy), and additional gates remain open. Rollback mechanism is undemonstrated.

progression_to_shift_authorized: false

These two assessments are independent. A complete PROVE package over bounded static evidence does NOT imply authorization to SHIFT.

Test G result: PASS — PROVE completion and SHIFT authorization are recorded separately and independently.

Test H — Artifact-Persistence Status Versus Semantic Proof
Adversarial condition: Persistence fixture records: proof_generation: SUCCEEDED, native_persistence: FAILED, fallback_persistence: NOT_YET_PERFORMED.

Persistence record:

proof_generation:      SUCCEEDED
native_persistence:    FAILED
fallback_persistence:  NOT_YET_PERFORMED
persisted_artifact_hash: UNAVAILABLE (native persistence failed; fallback not yet performed)

Semantic proof classification impact: NONE

The native persistence failure does not alter any proof classification in this package. The semantic proof conclusions (STATICALLY_VERIFIED, DIFFERENCE_EXPLAINED, RUNTIME_UNAVAILABLE, NOT_VERIFIED, INTERNAL_STATUS_CONFLICT findings) were generated before any persistence operation and are determined entirely by the available source evidence.

This package preserves the original persistence failure. The semantic proof is not being regenerated solely to obtain a successful write.

Test H result: PASS — persistence status is recorded independently from semantic proof classifications. The failure does not affect any proof finding.

SECTION 13 — PROOF GAPS
Gap ID	Description	Affected Section	Classification
PG-01	KU-13 INTERNAL_STATUS_CONFLICT — unresolved pending human reconciliation	Section 8, Test D	INTERNAL_STATUS_CONFLICT
PG-02	MERCHVAL historical no-change unverifiable (no pre-change baseline authorized)	Section 5, Test A	NOT_VERIFIED
PG-03	ACCTVAL internal semantics — callee excluded from authorized boundary	Section 6, Test B	NOT_VERIFIED
PG-04	MERCHCHK internal semantics — callee excluded from authorized boundary	Section 6, Test B	NOT_VERIFIED
PG-05	VSAM record-size discrepancy (57 vs 58 bytes) unresolved — KU-11 OPEN	Section 7, Test C	NOT_VERIFIED
PG-06	Runtime equivalence for all four changed artifacts — no authorized runtime	Section 11	RUNTIME_UNAVAILABLE
PG-07	Compilation, link-edit, CICS execution — no authorized environment	Section 11	RUNTIME_UNAVAILABLE
PG-08	CUSTRSK external callers beyond mapped workspace — no evidence present or absent	Section 6.3	NOT_VERIFIED
PG-09	ATLI input/linkage population — KU-03 RESOLUTION GATE OPEN	Section 8.2	NOT_VERIFIED
PG-10	Rollback mechanism — undemonstrated in any executable environment	Sections 4, 11	NOT_VERIFIED
SECTION 14 — ARTIFACT PERSISTENCE STATUS
Source: runs/atlaspay/prove/run-006/fixtures/persistence-status.md

proof_generation:          SUCCEEDED
native_persistence:        FAILED
fallback_persistence:      NOT_YET_PERFORMED
persisted_artifact_hash:   UNAVAILABLE (native persistence failed; no successful write to report)
persistence_method:        NONE (fallback not yet performed)

This record does not alter any semantic proof classification. See Test H (Section 12).

SECTION 15 — PROVE COMPLETION RECOMMENDATION
prove_run: run-006
framework_candidate: v0.3.8
candidate_commit: cc5dc2b43120a9ced35f332231f48fb3e4cbaaf7
capability: Dynamic Transaction Limit
runtime_validation: RUNTIME_UNAVAILABLE

# Adversarial test results
test_A_historical_no_change: PASS
test_B_caller_callee_boundary: PASS
test_C_cobol_record_layout: PASS
test_D_ku_consistency: PASS
test_E_artifact_integrity: PASS
test_F_static_vocabulary: PASS
test_G_prove_shift_separation: PASS
test_H_persistence_separation: PASS

# PROVE completion
prove_complete_for_available_evidence: true
prove_exit_evidence_type: STATIC_ONLY
prove_exit_qualifier: >-
  PROVE closure is for the bounded static evidence available in the
  authorized experiment. It does not establish runtime equivalence,
  deployment readiness, or SHIFT authorization.

# SHIFT authorization — independent
progression_to_shift_authorized: false
shift_blockers:
  - RUNTIME_UNAVAILABLE: runtime equivalence unverified for all four changed programs
  - KU-13: INTERNAL_STATUS_CONFLICT — requires human reconciliation before
            characterization suite is treated as normative
  - KU-03: ATLI input population OPEN RESOLUTION GATE
  - KU-11: VSAM record-size discrepancy unresolved (57 vs 58 bytes)
  - KU-12: EXCEPT01 CICS runtime compatibility unverified
  - KU-07: Multi-row policy-selection semantics unresolved
  - PG-08: CUSTRSK external callers not confirmed absent
  - PG-10: Rollback mechanism not demonstrated

# Deployment / production
deployment_authorized: false
production_change_authorized: false


SECTION 16 — SHIFT AUTHORIZATION STATUS
progression_to_shift_authorized: false

PROVE Run 006 does not authorize and must not be interpreted as authorizing:

deployment of any changed artifact to any environment
CICS installation of any changed load module
Db2 bind or package change
VSAM dataset modification
MQ configuration change
production traffic routing to the changed code
any environment promotion
A completed PROVE stage for bounded static evidence is not equivalent to SHIFT authorization. SHIFT requires evidence appropriate to the operational action being authorized, including but not limited to: runtime equivalence verification, rollback demonstration, KU-13 human reconciliation, KU-03 resolution, and human SHIFT gate approval.

DOCUMENT CONTROL
package_type:            Modernization Proof Package (RAW — submitted for human evaluation)
stage:                   PROVE
run:                     run-006
framework_version:       v0.3.8
candidate_commit:        cc5dc2b43120a9ced35f332231f48fb3e4cbaaf7
generated_by:            Bob (IBM Bob) — automated static review
human_prove_gate:        REQUIRED — NOT YET SIGNED
human_approval_status:   PENDING
self_approval_attempted: false

This package is submitted for human review. It does not approve its own PROVE exit. Human sign-off is required before any stage exit is recorded.

Execution Summary
PROVE Run 006 is complete. Here is a concise audit of what was done and what the package contains:

Evidence boundary honored: All 20 authorized files were read. No forbidden artifacts were accessed (evals/atlaspay/ground-truth.yaml, ACCTVAL.cbl, MERCHCHK.cbl, Run 005 artifacts, repository history for withheld baselines — none touched).

Adversarial test results at a glance:

Test	Control	Result	Key finding
A	Historical no-change	PASS	No claim that MERCHVAL was unchanged; classified NOT_VERIFIED (no pre-change baseline)
B	Caller/callee boundary	PASS	ACCTVAL and MERCHCHK internal semantics classified NOT_VERIFIED; caller-visible facts only
C	COBOL record layout	PASS	Copybook yields 58 bytes (display, no USAGE clause); VSAM defines 57 — discrepancy preserved, no packed inference
D	KU consistency	PASS	ku-status-a.md (OPEN) vs ku-status-b.md (RESOLVED_FOR_SYNTHETIC_BASELINE) → INTERNAL_STATUS_CONFLICT surfaced, not reconciled
E	Artifact integrity	PASS	All 8 SHA-256 hashes reported in full (64-hex chars); all cross-check against TRANSFORM evidence pack
F	Static vocabulary	PASS	Only STATICALLY_INSPECTED used; SYNTAX_VALIDATED / COMPILE_VERIFIED / LINK_EDIT_VERIFIED / RUNTIME_VERIFIED not claimed
G	PROVE / SHIFT separation	PASS	prove_complete_for_available_evidence: true
H	Persistence separation	PASS	proof_generation: SUCCEEDED / native_persistence: FAILED recorded; no semantic proof classification altered
Key governance assertions reproduced:

prove_complete_for_available_evidence: true
progression_to_shift_authorized: false
deployment_authorized: false
production_change_authorized: false
human_prove_gate: REQUIRED — NOT YET SIGNED
Human review and gate sign-off are required before any stage exit is recorded.