Modernization Proof Package — AtlasPay Run 005
Framework: v0.3.7
Playbook: framework-assets/playbooks/proof-package/playbook.yaml (read)
Prompt: framework-assets/prompts/verification/prove-change.md (read)
Experiment spec: framework-assets/integrations/ibm-bob/prove/atlaspay-experiment-005.md (read)
Estate: AtlasPay (synthetic)
Capability: Dynamic Transaction Limit
Prior stage: TRANSFORM Run 004
Human TRANSFORM approver: Suman Devarasetti
Proof classification vocabulary: STATICALLY_VERIFIED · RUNTIME_UNAVAILABLE · NOT_VERIFIED · DIFFERENCE_EXPLAINED · DIFFERENCE_UNEXPLAINED
Deployment authorized: false
Production change authorized: false
Bob does not approve PROVE exit.

Section 1 — Proof Scope and Evidence Boundary
1.1 Framework Inputs Read
Asset	Path	Status
Playbook	framework-assets/playbooks/proof-package/playbook.yaml	READ
Prove prompt	framework-assets/prompts/verification/prove-change.md	READ
Experiment spec	framework-assets/integrations/ibm-bob/prove/atlaspay-experiment-005.md	READ
Input manifest	runs/atlaspay/prove/run-005/00-prove-input-manifest.md	READ
1.2 PLAN Inputs Read
Document	Path	Status
Reviewed implementation plan	runs/atlaspay/plan/run-003/02-implementation-plan-reviewed.md	READ
Human plan gate	runs/atlaspay/plan/run-003/03-human-plan-gate.md	READ
1.3 TRANSFORM Inputs Read
Document	Status
runs/atlaspay/transform/run-004/01-slice-0-characterization-baseline.md	READ
runs/atlaspay/transform/run-004/04-slice-1a-authorization.md	READ
runs/atlaspay/transform/run-004/07-slice-2a-authorization.md	READ
runs/atlaspay/transform/run-004/09-slice-3-gate-resolution.md	READ
runs/atlaspay/transform/run-004/11-slice-4a-authorization.md	READ
runs/atlaspay/transform/run-004/13-slice-5-gate-resolution.md	READ
runs/atlaspay/transform/run-004/14-transform-evidence-pack.md	READ
runs/atlaspay/transform/run-004/15-human-transform-exit-gate.md	READ
1.4 Pre-Change Snapshots Read
Snapshot	Status
runs/atlaspay/transform/run-004/LIMITPOL.pre-slice-1a.cbl	READ
runs/atlaspay/transform/run-004/EXCEPT01.pre-slice-2a.cbl	READ
runs/atlaspay/transform/run-004/CUSTRSK.pre-slice-4a.cbl	READ
runs/atlaspay/transform/run-004/TRNLIM01.pre-slice-4a.cbl	READ
1.5 Authorized Supporting Evidence Read
Artifact	Status
src/cobol/LIMITPOL.cbl	READ
src/cobol/EXCEPT01.cbl	READ
src/cobol/CUSTRSK.cbl	READ
src/cobol/TRNLIM01.cbl	READ
src/cobol/MERCHVAL.cbl	READ
src/cobol/RISKFBK.cbl	READ
src/cobol/LIMUTIL.cbl	READ
src/cobol/ATLAUTH.cbl	READ
src/cobol/AUTHLOG.cbl	READ
src/copybooks/AUTHREQ.cpy	READ
src/copybooks/AUTHRESP.cpy	READ
src/copybooks/LIMITCTX.cpy	READ
src/copybooks/RISKSCR.cpy	READ
src/copybooks/EXCEPTREC.cpy	READ
cics/transactions.yaml	READ
mq/message-contracts.md	READ
mq/queues.yaml	READ
db2/schema.sql	READ
vsam/DEFINE.jcl	READ
1.6 Explicitly Forbidden Evidence — Not Accessed
evals/atlaspay/ground-truth.yaml — NOT accessed
db2/seed-data.sql — NOT within the authorized PROVE evidence boundary; NOT accessed
1.7 Evidence Boundary Statement
PROVE evaluates only what is within the frozen evidence boundary defined in runs/atlaspay/prove/run-005/00-prove-input-manifest.md. No claim in this proof package is drawn from an artifact not listed in Sections 1.1–1.5 above.

1.8 Runtime Environment Statement
AtlasPay is a synthetic analysis-grade estate. No authorized executable z/OS, CICS, Db2, VSAM, or MQ runtime is available for this experiment. All proof claims are therefore static. Runtime-related dimensions are classified RUNTIME_UNAVAILABLE throughout.

Section 2 — Transformed Artifact Inventory
Artifact	Change Type	Authorizing Document
src/cobol/LIMITPOL.cbl	Structural refactoring (paragraph extraction)	04-slice-1a-authorization.md
src/cobol/EXCEPT01.cbl	Structural refactoring (paragraph extraction)	07-slice-2a-authorization.md
src/cobol/CUSTRSK.cbl	Interface narrowing	11-slice-4a-authorization.md
src/cobol/TRNLIM01.cbl	Caller-side update matching CUSTRSK interface change	11-slice-4a-authorization.md
src/cobol/MERCHVAL.cbl	No change — intentional KEEP	09-slice-3-gate-resolution.md
No copybooks, JCL, Db2 schema, VSAM definitions, MQ artifacts, CICS transaction definitions, or test files are in the modified set.

Section 3 — Pre/Post Comparison for Each Changed Source File
3.1 LIMITPOL.cbl
Pre-change source: runs/atlaspay/transform/run-004/LIMITPOL.pre-slice-1a.cbl

Post-change source: src/cobol/LIMITPOL.cbl

Material differences detected:

The flat PROCEDURE DIVISION body (inline SQL + inline IF/ELSE) has been extracted into two named paragraphs: RETRIEVE-POLICY and APPLY-POLICY-RESULT, called from a new 0000-MAIN paragraph via PERFORM.
The main paragraph now ends with GOBACK via 0000-MAIN; previously GOBACK terminated the single flat body directly.
Unchanged elements confirmed by direct source inspection:

IDENTIFICATION DIVISION, PROGRAM-ID. LIMITPOL: identical
DATA DIVISION / WORKING-STORAGE SECTION: identical (three WS fields, SQLCA)
LINKAGE SECTION: identical (COPY AUTHREQ, COPY LIMITCTX)
PROCEDURE DIVISION USING AUTH-REQUEST LIMIT-CONTEXT: identical header
SQL SELECT BASE_LIMIT, PRODUCT_MAX, JURIS_LIMIT INTO :WS-BASE-LIMIT, :WS-PRODUCT-MAX, :WS-JURIS-LIMIT FROM ATLAS_LIMIT_POLICY WHERE PRODUCT_CODE = :AR-PRODUCT-CODE AND JURISDICTION = :AR-JURISDICTION AND ACTIVE_FLAG = 'Y': identical columns, predicates, host variables
SQLCODE = 0 branch: identical field assignments
Fallback branch: all three fields set to 1000.00: identical
No new SQL statements introduced
Classification: DIFFERENCE_EXPLAINED

Evidence: 04-slice-1a-authorization.md explicitly authorized paragraph extraction while prohibiting SQL, predicate, interface, or fallback change. Observed differences match exactly.

3.2 EXCEPT01.cbl
Pre-change source: runs/atlaspay/transform/run-004/EXCEPT01.pre-slice-2a.cbl

Post-change source: src/cobol/EXCEPT01.cbl

Material differences detected:

The flat PROCEDURE DIVISION body has been extracted into two named paragraphs: 1000-INITIALIZE and 2000-LOOKUP-EXCEPTION, called from a new 0000-MAIN paragraph via PERFORM.
GOBACK moved to end of 0000-MAIN; previously terminated the flat body directly.
Unchanged elements confirmed by direct source inspection:

IDENTIFICATION DIVISION, PROGRAM-ID. EXCEPT01: identical
ENVIRONMENT DIVISION / FILE-CONTROL: identical — SELECT EXCEPT-FILE ASSIGN TO EXCPTKS ORGANIZATION IS INDEXED ACCESS MODE IS DYNAMIC RECORD KEY IS ER-ACCOUNT-ID FILE STATUS IS WS-FILE-STATUS
FILE SECTION FD EXCEPT-FILE. COPY EXCEPTREC.: identical
WORKING-STORAGE SECTION: identical (WS-FILE-STATUS PIC XX)
LINKAGE SECTION: identical (COPY AUTHREQ, COPY LIMITCTX)
PROCEDURE DIVISION USING AUTH-REQUEST LIMIT-CONTEXT: identical header
MOVE 'N' TO LC-GRANDFATHERED: identical (now in 1000-INITIALIZE)
OPEN INPUT EXCEPT-FILE, keyed READ EXCEPT-FILE KEY IS ER-ACCOUNT-ID, INVALID KEY CONTINUE, NOT INVALID KEY IF ER-ACTIVE = 'Y' branch, LC-GRANDFATHERED = 'Y' assignment, LC-EXCEPTION-LIMIT assignment, CLOSE EXCEPT-FILE: all identical
No ER-EFFECTIVE-DATE or ER-EXPIRY-DATE logic introduced
No EXEC CICS READ introduced
Classification: DIFFERENCE_EXPLAINED

Evidence: 07-slice-2a-authorization.md explicitly authorized paragraph extraction while prohibiting any change to file-control, keyed access, eligibility logic, or expiry semantics. Observed differences match exactly.

3.3 CUSTRSK.cbl
Pre-change source: runs/atlaspay/transform/run-004/CUSTRSK.pre-slice-4a.cbl

Post-change source: src/cobol/CUSTRSK.cbl

Material differences detected:

Interface change (intentional): LINKAGE SECTION changed from COPY AUTHREQ. COPY LIMITCTX. to three explicit scalar fields: LK-ACCOUNT-ID PIC X(12), LK-RISK-SCORE PIC 9(3), LK-RISK-AVAILABLE PIC X.
PROCEDURE DIVISION USING changed from AUTH-REQUEST LIMIT-CONTEXT to LK-ACCOUNT-ID LK-RISK-SCORE LK-RISK-AVAILABLE.
Internal field references updated: AR-ACCOUNT-ID → LK-ACCOUNT-ID; LC-RISK-AVAILABLE → LK-RISK-AVAILABLE; LC-RISK-SCORE → LK-RISK-SCORE.
Unchanged elements confirmed by direct source inspection:

PROGRAM-ID. CUSTRSK: identical
WORKING-STORAGE SECTION COPY RISKSCR.: identical
INITIALIZE RISK-MESSAGE: identical
Account ID moved to RM-ACCOUNT-ID: identical operation (source operand differs by name only, value is equivalent — account ID)
CALL 'MQRSKGET' USING RISK-MESSAGE: identical invocation
IF RM-OK branch: MOVE 'Y' TO [risk-available], MOVE RM-RISK-SCORE TO [risk-score]: identical logic
ELSE branch: MOVE 'N' TO [risk-available], MOVE 000 TO [risk-score]: identical logic
GOBACK: identical
New runtime assumption introduced: The narrowed interface means at runtime TRNLIM01 must pass three individual scalar fields by address rather than the two prior copybook structures. Whether the COBOL runtime linkage mechanism produces the same binary layout and addressing for these fields as previously is not verifiable from static source alone.

Classification: DIFFERENCE_EXPLAINED (interface change) + new_runtime_assumptions_found: true

Evidence: 11-slice-4a-authorization.md explicitly authorized this interface narrowing and identified the three permitted scalar fields. The MQ invocation, RM-OK/non-RM-OK logic, and GOBACK are preserved. The runtime linkage compatibility between the new CUSTRSK interface and the updated TRNLIM01 caller is not verifiable statically.

3.4 TRNLIM01.cbl
Pre-change source: runs/atlaspay/transform/run-004/TRNLIM01.pre-slice-4a.cbl

Post-change source: src/cobol/TRNLIM01.cbl

Material differences detected:

CALL 'CUSTRSK' USING AUTH-REQUEST LIMIT-CONTEXT changed to CALL 'CUSTRSK' USING AR-ACCOUNT-ID LC-RISK-SCORE LC-RISK-AVAILABLE.
Unchanged elements confirmed by direct source inspection:

PROGRAM-ID. TRNLIM01: identical
LINKAGE SECTION. COPY AUTHREQ. COPY LIMITCTX.: identical
PROCEDURE DIVISION USING AUTH-REQUEST LIMIT-CONTEXT: identical (external interface preserved)
INITIALIZE LIMIT-CONTEXT: identical
CALL 'LIMITPOL' USING AUTH-REQUEST LIMIT-CONTEXT: identical
CALL 'EXCEPT01' USING AUTH-REQUEST LIMIT-CONTEXT: identical
CALL 'TMPCTRL' USING AUTH-REQUEST LIMIT-CONTEXT: identical
CALL 'MERCHVAL' USING AUTH-REQUEST LC-MCC-LIMIT: identical
IF LC-RISK-AVAILABLE NOT = 'Y' CALL 'RISKFBK' USING AUTH-REQUEST LIMIT-CONTEXT END-IF: identical
CALL 'LIMUTIL' USING AUTH-REQUEST LIMIT-CONTEXT: identical
GOBACK: identical
Orchestration order (LIMITPOL → EXCEPT01 → TMPCTRL → MERCHVAL → CUSTRSK → conditional RISKFBK → LIMUTIL): identical
AR-ACCOUNT-ID, LC-RISK-SCORE, LC-RISK-AVAILABLE are all existing fields in the in-scope AUTHREQ.cpy and LIMITCTX.cpy copybooks; no new data item introduced
Classification: DIFFERENCE_EXPLAINED

Evidence: 11-slice-4a-authorization.md explicitly authorized updating the CUSTRSK call to pass the three existing scalar fields. All other call sites and the external interface are unchanged.

3.5 MERCHVAL.cbl
Pre-change source: not applicable — no change authorized or made

Post-change source: src/cobol/MERCHVAL.cbl

Source contains MCC hardcoded logic (7995 → 1000.00, 6051 → 2000.00, other → 9999999.99 sentinel) as observed in pre-transformation state. No modification was made.

Classification: No difference to classify. Intentional KEEP per 09-slice-3-gate-resolution.md.

Section 4 — Authorization Mapping for Each Material Difference
Difference	Authorized By	Authorization Type
LIMITPOL paragraph extraction	04-slice-1a-authorization.md — Suman Devarasetti	STATICALLY_VERIFIED
EXCEPT01 paragraph extraction	07-slice-2a-authorization.md — Suman Devarasetti	STATICALLY_VERIFIED
CUSTRSK interface narrowing (LINKAGE + PROCEDURE DIVISION USING)	11-slice-4a-authorization.md — Suman Devarasetti	STATICALLY_VERIFIED (interface); RUNTIME_UNAVAILABLE (runtime linkage)
TRNLIM01 CUSTRSK call-site update	11-slice-4a-authorization.md — Suman Devarasetti	STATICALLY_VERIFIED
MERCHVAL unchanged	09-slice-3-gate-resolution.md — Suman Devarasetti	No difference
No difference detected across the four changed files is unexplained.

workspace_wide_unauthorized_change_assessment: NOT_VERIFIED

PROVE has read the four authorized changed files and all authorized supporting evidence files. All differences detected within those four files are explained and authorized. Whether any file outside the four authorized changed files was altered during TRANSFORM Run 004 cannot be verified from the evidence available to this proof package. The assessment of workspace-wide scope compliance therefore remains NOT_VERIFIED. PROVE makes no claim that no unauthorized out-of-scope file was changed.

Section 5 — Behavioral Invariant Matrix
Evidence sources: src/cobol/LIMUTIL.cbl, src/cobol/ATLAUTH.cbl, src/cobol/RISKFBK.cbl, src/cobol/TRNLIM01.cbl, src/copybooks/LIMITCTX.cpy, and pre-change snapshots.

Business Rule	Invariant	Static Evidence	Classification
BR-01	Blank AR-ACCOUNT-ID → Decision D, Reason INVA	ATLAUTH.cbl:17-21 — ACCTVAL guard unchanged	STATICALLY_VERIFIED
BR-02	Blank AR-MERCHANT-CATEGORY → Decision D, Reason MCC	ATLAUTH.cbl:24-29 — MERCHCHK guard unchanged	STATICALLY_VERIFIED
BR-23	Account/merchant validation precedes TRNLIM01	ATLAUTH.cbl:16-32 — call order unchanged	STATICALLY_VERIFIED
BR-25	Sub-program invocation order fixed	TRNLIM01.cbl:12-24 — LIMITPOL→EXCEPT01→TMPCTRL→MERCHVAL→CUSTRSK→RISKFBK→LIMUTIL unchanged	STATICALLY_VERIFIED
BR-03	Base limit from LC-BASE-LIMIT	LIMUTIL.cbl:13 unchanged; LIMITPOL.cbl paragraph restructuring only	STATICALLY_VERIFIED
BR-04	1000.00 fallback when SQLCODE ≠ 0	LIMITPOL.cbl:38-40 — all three fallback MOVE statements present and identical	STATICALLY_VERIFIED
BR-05	Jurisdiction cap applied when LC-JURIS-LIMIT > 0 and lower	LIMUTIL.cbl:15-18 unchanged	STATICALLY_VERIFIED
BR-06/07	Temporary limit cap	LIMUTIL.cbl:25-28 unchanged; TMPCTRL not modified	STATICALLY_VERIFIED
BR-08/09	Grandfathered override: LC-GRANDFATHERED = 'Y' → LC-EXCEPTION-LIMIT replaces candidate	LIMUTIL.cbl:30-31 unchanged; EXCEPT01.cbl — ER-ACTIVE = 'Y' logic unchanged	STATICALLY_VERIFIED
BR-10	MCC 7995 → 1000.00	MERCHVAL.cbl:12-13 unchanged	STATICALLY_VERIFIED
BR-11	MCC 6051 → 2000.00	MERCHVAL.cbl:14-15 unchanged	STATICALLY_VERIFIED
BR-12	Other MCC → sentinel 9999999.99	MERCHVAL.cbl:10 + WHEN OTHER CONTINUE unchanged	STATICALLY_VERIFIED
BR-13	Risk score ≥ 800 → ×0.80	LIMUTIL.cbl:33-34 unchanged	STATICALLY_VERIFIED
BR-14	Risk score < 500 → ×0.70	LIMUTIL.cbl:36-37 unchanged	STATICALLY_VERIFIED
BR-15	Risk score 500–799 → no adjustment	LIMUTIL.cbl:32-39 — no branch for 500–799 by design, unchanged	STATICALLY_VERIFIED
BR-16-RISK	MQ unavailable → fallback score 650	RISKFBK.cbl:11 — MOVE 650 TO LC-RISK-SCORE unchanged	STATICALLY_VERIFIED
BR-17-RISK	Risk score from MQ per account	CUSTRSK.cbl:19-23 — MQRSKGET invocation and RM-RISK-SCORE→LK-RISK-SCORE assignment unchanged; LK-RISK-SCORE is passed as LC-RISK-SCORE from TRNLIM01.cbl:17	STATICALLY_VERIFIED
BR-18	Product maximum is absolute ceiling	LIMUTIL.cbl:42-44 — applies unconditionally after all branches including grandfathered path, unchanged	STATICALLY_VERIFIED
BR-19	AR-AMOUNT ≤ LC-FINAL-LIMIT → Decision A, Reason 0000	ATLAUTH.cbl:35-37 unchanged	STATICALLY_VERIFIED
BR-20	AR-AMOUNT > LC-FINAL-LIMIT → Decision D, Reason LIMT	ATLAUTH.cbl:38-41 unchanged	STATICALLY_VERIFIED
BR-21	AS-APPLIED-LIMIT populated on all responses	ATLAUTH.cbl:33 — MOVE LC-FINAL-LIMIT TO AS-APPLIED-LIMIT before IF, unchanged	STATICALLY_VERIFIED
BR-22	Audit on all decision paths	ATLAUTH.cbl:43 — PERFORM WRITE-AUDIT before GOBACK, and within each early-exit path; unchanged	STATICALLY_VERIFIED
BR-24	Fixed limit-resolution sequence in LIMUTIL	LIMUTIL.cbl:13-46 — 7-step sequence intact and unchanged	STATICALLY_VERIFIED
Runtime note: Static preservation of business-rule source expressions is not runtime behavioral equivalence proof. These invariants are verified at the source level only.

Section 6 — Interface Compatibility Matrix
Interface	Pre-Change	Post-Change	Status
TRNLIM01 external interface (PROCEDURE DIVISION USING AUTH-REQUEST LIMIT-CONTEXT)	AUTH-REQUEST, LIMIT-CONTEXT	AUTH-REQUEST, LIMIT-CONTEXT	STATICALLY_VERIFIED — unchanged
ATLAUTH → TRNLIM01 call (CALL 'TRNLIM01' USING AUTH-REQUEST LIMIT-CONTEXT)	AUTH-REQUEST, LIMIT-CONTEXT	AUTH-REQUEST, LIMIT-CONTEXT	STATICALLY_VERIFIED — unchanged
TRNLIM01 → CUSTRSK call site	USING AUTH-REQUEST LIMIT-CONTEXT	USING AR-ACCOUNT-ID LC-RISK-SCORE LC-RISK-AVAILABLE	DIFFERENCE_EXPLAINED — authorized by 11-slice-4a-authorization.md
CUSTRSK linkage interface	COPY AUTHREQ, COPY LIMITCTX	LK-ACCOUNT-ID PIC X(12), LK-RISK-SCORE PIC 9(3), LK-RISK-AVAILABLE PIC X	DIFFERENCE_EXPLAINED — intentional narrowing
CUSTRSK runtime linkage (address resolution)	—	—	RUNTIME_UNAVAILABLE
LIMITPOL interface (PROCEDURE DIVISION USING AUTH-REQUEST LIMIT-CONTEXT)	Unchanged	Unchanged	STATICALLY_VERIFIED
EXCEPT01 interface (PROCEDURE DIVISION USING AUTH-REQUEST LIMIT-CONTEXT)	Unchanged	Unchanged	STATICALLY_VERIFIED
ATLAUTH → AUTHLOG call (CALL 'AUTHLOG' USING AUTH-REQUEST AUTH-RESPONSE)	Unchanged	Unchanged	STATICALLY_VERIFIED
ATLI → TRNLIM01 routing	cics/transactions.yaml: ATLI maps to TRNLIM01	Same entry unchanged	STATICALLY_VERIFIED (routing); NOT_VERIFIED (input population)
CUSTRSK enterprise caller inventory: NOT_VERIFIED

The evidence boundary for this proof package is the isolated AtlasPay workspace. Whether additional callers of CUSTRSK exist outside this workspace is unknown. If any such caller was compiled against the pre-change interface, it would be broken by the interface change and not reflected in the evidence here.

ATLI KU-03: NOT_VERIFIED

How the ATLI diagnostic path populates AUTH-REQUEST and LIMIT-CONTEXT when invoking TRNLIM01 directly remains unresolved. No COMMAREA layout, channel/container layout, or wrapper logic was found in the evidence boundary.

Section 7 — Known-Unknown and Containment-Gate Status
The following known unknowns and containment gates are carried forward from TRANSFORM Run 004 as required by 15-human-transform-exit-gate.md. They remain open unless explicitly resolved by evidence within this proof package. None are resolved or downgraded below by assumption.

ID	Description	Gate Type	Status in PROVE
KU-01	MQRSKGET implementation absent — MQ call contract details unverifiable	CONTAINMENT	OPEN — not resolved; MQ invocation syntax preserved statically
KU-03	ATLI input/linkage population unknown	RESOLUTION GATE	OPEN — cics/transactions.yaml confirms routing; no evidence of AUTH-REQUEST/LIMIT-CONTEXT population for ATLI path
KU-04	AUTHLOG real I/O sink and behavior unknown	CONTAINMENT	OPEN — AUTHLOG.cbl:10 contains synthetic stub comment; audit interface unchanged
KU-05	Reconciliation implementation unknown	CONTAINMENT	OPEN — expiry ownership not established; no expiry logic introduced
KU-06	Exception-expiry ownership unknown	CONTAINMENT	OPEN — no ER-EXPIRY-DATE logic introduced
KU-07	Possible multi-row ATLAS_LIMIT_POLICY result / SQLCODE -811	CONTAINMENT	OPEN — db2/schema.sql primary key is (PRODUCT_CODE, JURISDICTION, EFFECTIVE_DATE); multiple rows per product/jurisdiction are structurally possible; predicate does not include EFFECTIVE_DATE; KU-07 is not resolved by schema inspection alone. No seed-data artifact within the PROVE evidence boundary establishes a singleton guarantee at runtime
KU-09	AS-RISK-MODE semantics unresolved	CONTAINMENT	OPEN — AUTHRESP.cpy:7 field present; no program assigns it in the reviewed source
KU-11	VSAM record-size discrepancy (57-byte DEFINE vs. 58-byte copybook layout)	CONTAINMENT	OPEN — vsam/DEFINE.jcl specifies RECORDSIZE(57 57); EXCEPTREC.cpy layout: ER-ACCOUNT-ID(12) + ER-EFFECTIVE-DATE(8) + ER-EXPIRY-DATE(8) + ER-EXCEPTION-LIMIT(9,2 — inferred 9 bytes packed or display; ambiguous) + ER-REASON(20) + ER-ACTIVE(1) = minimum 58 bytes display; discrepancy unresolved
KU-12	EXCEPT01 runtime/CICS compatibility unverified	CONTAINMENT	OPEN — no authorized runtime
KU-16	AR-TRANSACTION-TYPE semantics unresolved	CONTAINMENT	OPEN — AUTHREQ.cpy:5 field present; not consumed by any reviewed program
KU-17	Unconditional CUSTRSK invocation intent unknown	CONTAINMENT	OPEN — invocation order preserved; business intent not established
C-02	Grandfathered exception vs. product-max ceiling intent	OPEN	LIMUTIL.cbl:42-44 confirms product-max cap applies after grandfathered exception; business intent of this behavior remains unresolved
C-03	Date-based eligibility intent	CONTAINMENT	OPEN — no expiry logic introduced; C-03 containment honored
C-04	Timeout vs. error semantic distinction	CONTAINMENT	OPEN — RISKSCR.cpy defines RM-TIMEOUT (T) and RM-ERROR (E) separately; CUSTRSK collapses both into the non-RM-OK branch; distinction not resolved
C-05	1000.00 SQL fallback business intent	CONTAINMENT	OPEN — fallback value preserved exactly; business intent not established
Section 8 — Unsupported Change Assessment
Method: Each difference identified in Section 3 was compared to the authorization record for its slice. Additionally, the authorized supporting evidence files (ATLAUTH, LIMUTIL, RISKFBK, AUTHLOG, all copybooks, cics/transactions.yaml, mq/queues.yaml, mq/message-contracts.md, db2/schema.sql, vsam/DEFINE.jcl) were read directly and show no differences attributable to TRANSFORM Run 004.

Result for the four changed files:

File	Unsupported Change Detected
LIMITPOL.cbl	None detected
EXCEPT01.cbl	None detected
CUSTRSK.cbl	None detected — interface change is explicitly authorized
TRNLIM01.cbl	None detected
New runtime assumption introduced: The CUSTRSK interface change introduces a new runtime linkage assumption — that the three individual scalar fields passed by TRNLIM01 (AR-ACCOUNT-ID, LC-RISK-SCORE, LC-RISK-AVAILABLE) produce correct by-reference addressing at the new CUSTRSK LINKAGE SECTION. This was recognized and authorized in 11-slice-4a-authorization.md with the constraint that no new data items be introduced. The runtime validity of this assumption is RUNTIME_UNAVAILABLE.

workspace_wide_unauthorized_change_assessment: NOT_VERIFIED

PROVE cannot certify that no file outside the four authorized changed files was altered during TRANSFORM Run 004. This classification is carried forward unchanged from the prior stage.

Section 9 — Rollback Evidence Assessment
Source-level rollback: Four pre-change snapshots are present and were read:

LIMITPOL.pre-slice-1a.cbl — complete pre-change source available
EXCEPT01.pre-slice-2a.cbl — complete pre-change source available
CUSTRSK.pre-slice-4a.cbl — complete pre-change source available
TRNLIM01.pre-slice-4a.cbl — complete pre-change source available
Reverting each changed file to its corresponding snapshot would restore the pre-transformation source state for those four files.

Runtime rollback: RUNTIME_UNAVAILABLE — labeled rollback_runtime: NOT_VERIFIED

No authorized executable environment is available. The following runtime rollback evidence has not been established:

build/compile procedure and options
link-edit procedure
CICS load library management
Db2 plan or package rebind process
VSAM dataset restore procedure
MQ configuration restore procedure
post-rollback verification mechanism
named rollback owner and trigger authorization
Source-level reversion alone does not constitute a verified rollback procedure. This limitation was established in PLAN (02-implementation-plan-reviewed.md Section 10.1) and carried through TRANSFORM.

Section 10 — Static Validation Evidence
LIMITPOL.cbl:

SQL statement syntax: valid structure; SQLCA included; host variables reference declared WS fields; INTO list matches SELECT column list (3:3)
Paragraph structure: 0000-MAIN → PERFORM RETRIEVE-POLICY, PERFORM APPLY-POLICY-RESULT, GOBACK — valid
Pre/post diff confirms no prohibited change was introduced
EXCEPT01.cbl:

File-control syntax: SELECT/ASSIGN/ORGANIZATION/ACCESS/RECORD KEY/FILE STATUS — all present and valid structure
FD matches COPY EXCEPTREC
Paragraph structure: 0000-MAIN → PERFORM 1000-INITIALIZE, PERFORM 2000-LOOKUP-EXCEPTION, GOBACK — valid
OPEN/READ/CLOSE sequence preserved
Pre/post diff confirms no prohibited change was introduced
CUSTRSK.cbl:

Three explicit LINKAGE items: LK-ACCOUNT-ID PIC X(12), LK-RISK-SCORE PIC 9(3), LK-RISK-AVAILABLE PIC X
PROCEDURE DIVISION USING matches three declared linkage items
RISKSCR copybook in WORKING-STORAGE: present and unchanged
MQRSKGET call using RISK-MESSAGE: present and unchanged
RM-OK / non-RM-OK logic: present and unchanged
TRNLIM01.cbl:

CUSTRSK call arguments AR-ACCOUNT-ID LC-RISK-SCORE LC-RISK-AVAILABLE are all declared in the in-scope copybooks (AUTHREQ.cpy and LIMITCTX.cpy respectively)
Argument count matches CUSTRSK PROCEDURE DIVISION USING (3)
All other calls: unchanged
Orchestration order: unchanged
Formal diagnostics execution: Not performed. No diagnostic tool invocation was requested for a read-only PROVE run, and PROVE does not authorize source modification to repair findings.

Section 11 — Runtime Validation Status
runtime_validation: RUNTIME_UNAVAILABLE
runtime_equivalence_claimed: false
new_runtime_assumptions_found: true
runtime_assumption_description: >
  CUSTRSK interface change from two copybook structures (AUTH-REQUEST,
  LIMIT-CONTEXT) to three scalar fields (LK-ACCOUNT-ID, LK-RISK-SCORE,
  LK-RISK-AVAILABLE) introduces a new runtime linkage assumption.
  Static source inspection confirms the three scalar field names and
  PIC clauses. Whether the COBOL runtime correctly resolves by-reference
  addressing for these individual fields when called from TRNLIM01 cannot
  be verified without an authorized executable environment.
custrsk_enterprise_caller_inventory: NOT_VERIFIED
atli_ku03: NOT_VERIFIED
rollback_runtime: NOT_VERIFIED

No runtime-related claim in this proof package is classified as RUNTIME_VERIFIED. Matching source expressions between pre-change and post-change code, and matching interface declarations between caller and callee, are static observations only. They do not constitute runtime behavioral equivalence proof.

Section 12 — Unexplained Differences
Result: No unexplained differences detected within the four authorized changed files.

All material differences identified in Section 3 are classified DIFFERENCE_EXPLAINED and traced to explicit human authorizations in TRANSFORM Run 004.

Limitations of this assessment:

Only the four authorized changed files were examined for pre/post differences. Files outside that set were read for invariant and interface inspection but not subjected to a formal pre/post diff because no pre-change snapshots exist for them in the evidence boundary.
workspace_wide_unauthorized_change_assessment: NOT_VERIFIED — see Section 8.
Section 13 — Proof Gaps
The following proof gaps exist and remain open. They are not defects in the transformation. They represent dimensions of the proof that cannot be resolved from the available static evidence.

Gap ID	Dimension	Classification	Description
PG-01	Runtime behavioral equivalence — LIMITPOL	RUNTIME_UNAVAILABLE	Static diff confirms SQL, predicates, fallback, and interface are identical. Runtime execution equivalence cannot be verified.
PG-02	Runtime behavioral equivalence — EXCEPT01	RUNTIME_UNAVAILABLE	Static diff confirms file-control, keyed access, eligibility logic, and interface are identical. Runtime execution equivalence cannot be verified.
PG-03	Runtime linkage — CUSTRSK narrow interface	RUNTIME_UNAVAILABLE	Three scalar fields passed by reference at the new CUSTRSK boundary. No runtime has executed this linkage to verify correct parameter addressing.
PG-04	CUSTRSK enterprise caller inventory	NOT_VERIFIED	Unknown whether callers outside the isolated AtlasPay workspace depend on the pre-change CUSTRSK interface.
PG-05	ATLI input population (KU-03)	NOT_VERIFIED	How AUTH-REQUEST and LIMIT-CONTEXT are populated for the ATLI diagnostic path is not established by any evidence in the proof boundary.
PG-06	EXCEPT01 VSAM runtime compatibility (KU-11, KU-12)	RUNTIME_UNAVAILABLE	57-byte DEFINE vs. minimum 58-byte copybook layout discrepancy unresolved. CICS runtime compatibility unverified.
PG-07	LIMITPOL multi-row policy result (KU-07)	NOT_VERIFIED	db2/schema.sql primary key includes EFFECTIVE_DATE, allowing multiple rows per (PRODUCT_CODE, JURISDICTION) pair. The query predicate does not include EFFECTIVE_DATE. A singleton guarantee at runtime is not established by any artifact within the PROVE evidence boundary.
PG-08	MQ invocation runtime behavior (KU-01)	RUNTIME_UNAVAILABLE	MQRSKGET implementation is absent. MQ queue definitions and message contract are present in evidence, but actual MQ invocation behavior and response handling cannot be verified.
PG-09	Compilation and link-edit	RUNTIME_UNAVAILABLE	No authorized compile, link-edit, or load-module evidence exists for any of the four changed programs.
PG-10	Rollback runtime procedure	NOT_VERIFIED	Source-level snapshots exist. Runtime rollback procedure (build, link, CICS refresh, Db2 rebind, VSAM restore) is not established.
PG-11	AS-RISK-MODE field assignment (KU-09)	NOT_VERIFIED	AUTHRESP.cpy declares AS-RISK-MODE PIC X. No reviewed program assigns a value to this field. Its intended semantics and population path are unresolved.
PG-12	AUTHLOG real I/O behavior (KU-04)	NOT_VERIFIED	AUTHLOG.cbl is a synthetic stub. Real audit I/O, destination, and failure behavior are unverified.
PG-13	Workspace-wide unauthorized change detection	NOT_VERIFIED	PROVE examined only the four authorized changed files plus authorized supporting evidence. Files outside those sets were not subjected to a pre/post diff.
Section 14 — Human PROVE Gate Recommendation
14.1 Summary of What Static Evidence Supports
For the four authorized changed files within the isolated AtlasPay workspace evidence boundary, static evidence supports:

All detected source differences are explained and traceable to explicitly authorized human-approved change authorizations.
The SQL statement, predicates, and 1000.00 fallback in LIMITPOL are structurally identical to the pre-change source.
The file-control definition, keyed lookup, and ER-ACTIVE = 'Y' eligibility condition in EXCEPT01 are structurally identical to the pre-change source. No expiry or effective-date logic was introduced.
The CUSTRSK interface change is the one explicitly authorized intentional difference; MQ invocation, RM-OK/non-RM-OK logic, and fallback triggering are structurally identical.
The TRNLIM01 external interface is unchanged. The orchestration order is unchanged. Only the CUSTRSK call arguments changed, to three existing scalar fields as authorized.
MERCHVAL.cbl was not modified, consistent with the Slice 3 KEEP decision.
All 25 catalogued behavioral invariants (BR-01 through BR-25) are structurally present in source.
14.2 What Static Evidence Does Not Support
Static evidence does not establish:

runtime behavioral equivalence for any of the four changed programs;
correct runtime linkage for the narrowed CUSTRSK interface;
compilation success;
link-edit success;
CICS execution correctness;
Db2 query runtime behavior including KU-07 multi-row risk;
VSAM runtime correctness given the KU-11 record-size discrepancy;
MQ invocation runtime correctness;
that no caller outside the workspace was broken by the CUSTRSK interface change;
that the ATLI diagnostic path functions correctly (KU-03);
that no unauthorized file outside the four changed files was modified during TRANSFORM Run 004.
14.3 Highlighted Material Risks for Human Review
The following four items are highlighted as material risks warranting explicit human attention before any progression decision. They are highlighted because they represent either an irreversible interface change that may affect callers outside the evidence boundary, or open structural concerns that directly constrain runtime safety. Highlighting these four does not resolve, downgrade, or close any other open known unknown or proof gap listed in Sections 7 and 13. All other open items — including KU-03, KU-04, KU-07, KU-09, KU-11, KU-12, KU-13, KU-16, KU-17, C-02, C-03, C-04, C-05, PG-01 through PG-13 — remain open and are not implied to be immaterial by their absence from this highlighted set.

MR-01 — CUSTRSK runtime linkage (PG-03 / new_runtime_assumptions_found)

The CUSTRSK interface change is the only behavioral-boundary change in Run 004. Whether the COBOL runtime correctly handles three individual scalar arguments where two copybook structures previously existed cannot be determined from static source. Severity: HIGH. Verification requires an authorized executable environment.

MR-02 — CUSTRSK enterprise caller inventory (PG-04 / custrsk_enterprise_caller_inventory: NOT_VERIFIED)

Only the TRNLIM01 call site was updated. If any caller outside the isolated workspace was compiled against the pre-change CUSTRSK interface and was not updated, it would fail at runtime. The scope of that risk is unknown. Severity: HIGH. Verification requires an authorized enterprise caller inventory.

MR-03 — KU-11 VSAM record-size discrepancy (PG-06)

vsam/DEFINE.jcl specifies RECORDSIZE(57 57) for EXCPTKS. The EXCEPTREC.cpy layout totals at minimum 58 bytes in display format. This discrepancy predates the transformation and was not introduced by Run 004, but it was not resolved. Any runtime VSAM operation on EXCEPT01 carries this unresolved structural risk. Severity: HIGH.

MR-04 — ATLI diagnostic path input population (PG-05 / atli_ku03: NOT_VERIFIED)

CICS transaction ATLI routes to TRNLIM01. No evidence in the proof boundary establishes how AUTH-REQUEST and LIMIT-CONTEXT are populated for a direct ATLI invocation. If ATLI is used in any operational or testing context, its correct behavior after the transformation cannot be confirmed. Severity: MEDIUM–HIGH depending on operational use of ATLI.

14.4 Proof Status Summary
proof_run: run-005
capability: Dynamic Transaction Limit
framework_version: v0.3.7
estate: AtlasPay (synthetic)
prior_stage: TRANSFORM run-004
human_transform_approver: Suman Devarasetti

proof_classification:
  differences_in_authorized_files: ALL_EXPLAINED
  behavioral_invariants_preserved_statically: true
  unsupported_changes_detected_in_authorized_files: false
  unexplained_differences_in_authorized_files: false

runtime_validation: RUNTIME_UNAVAILABLE
runtime_equivalence_claimed: false
new_runtime_assumptions_found: true
workspace_wide_unauthorized_change_assessment: NOT_VERIFIED
custrsk_enterprise_caller_inventory: NOT_VERIFIED
atli_ku03: NOT_VERIFIED
rollback_runtime: NOT_VERIFIED

open_proof_gaps: 13
highlighted_material_risks_for_human_review: 4
remaining_open_known_unknowns: KU-01, KU-03, KU-04, KU-05, KU-06, KU-07,
  KU-09, KU-11, KU-12, KU-16, KU-17, C-02, C-03, C-04, C-05

deployment_authorized: false
production_change_authorized: false
bob_approves_prove_exit: false

14.5 Bob's Recommendation to Human Reviewer
Bob has produced this proof package from the authorized evidence boundary. Bob does not approve PROVE exit.

A named human reviewer must determine whether:

The static evidence level is sufficient to authorize progression given the open runtime gaps;
The CUSTRSK interface change risk (MR-01, MR-02) is acceptable without runtime linkage verification;
The KU-11 VSAM record-size discrepancy (MR-03) must be resolved before any CICS deployment that exercises the EXCEPT01 path;
The ATLI diagnostic path (MR-04) is operationally active, and if so, whether KU-03 must be resolved before progression;
All remaining open known unknowns in Section 7 and proof gaps in Section 13 are at an acceptable state for the intended next action.
No Evidence, No Progression. No proof by plausibility.

