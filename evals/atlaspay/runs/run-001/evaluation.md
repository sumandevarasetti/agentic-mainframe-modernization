# AtlasPay UNDERSTAND Run 001 — Evaluation Report

**Evaluation date:** 2026-09-19  
**Run:** `atlaspay-understand-001`  
**Framework under test:** v0.3.2  
**Product:** IBM Bob 2.1.0 — Premium Package for Z  
**Execution mode:** PP4Z workspace mode  
**Z Understand:** Not configured  
**Ground truth during run:** Hidden from Bob  
**Ground-truth version used for scoring:** `v0.3.2/evals/atlaspay/ground-truth.yaml`

## Executive conclusion

Run 001 produced decision-grade UNDERSTAND evidence for the synthetic AtlasPay Dynamic Transaction Limit capability and is suitable to proceed to DECIDE.

The strongest results were dependency discovery, business-rule recovery, evidence traceability, and planted cross-artifact impact discovery. The principal weakness was broader evidence-boundary uncertainty: the run found many application-local unknowns but did not fully surface all classes of evidence that a static synthetic workspace cannot establish.

This report evaluates the frozen run only. It does not claim enterprise-wide IBM Z coverage and does not generalize workspace-mode results to Z Understand-backed analysis.

## Scoring method

The canonical synthetic answer key is intentionally coarse-grained. Recall can therefore be computed against the enumerated positive expectations. Precision is treated more cautiously: the ground truth is not an exhaustive list of every valid additional dependency or finer-grained rule, so extra source-backed findings are manually reviewed rather than automatically counted as false positives.

### Dependency denominator

Expected dependency claims:

- 13 program dependencies
  - 8 direct limit-path programs
  - 3 upstream/supporting programs
  - 2 batch-maintenance programs
- 3 expected batch/JCL dependencies
- 3 expected data dependencies
- 2 expected external MQ dependencies

Total canonical dependency claims: **21**.

Entry points are tracked separately: CICS `ATLA`, online orchestrator `ATLAUTH`, and limit orchestrator `TRNLIM01`.

### Business-rule denominator

The ground truth defines 9 canonical business-rule families. Bob may decompose one canonical family into several implementation-level rules; such decomposition is not a false positive when each finer-grained rule is source-grounded.

## Results

| Metric | Result | Notes |
|---|---:|---|
| Entry-point recall | **3/3 = 100%** | ATLA, ATLAUTH, TRNLIM01 identified |
| Dependency recall | **21/21 = 100%** | Programs, batch, data, and external MQ dependencies recovered |
| Dependency precision | **Manual review: no unsupported material dependency found** | Numeric precision is not strictly computable from a positive-only, non-exhaustive answer key |
| Business-rule recall | **9/9 = 100%** | All canonical rule families recovered |
| Business-rule precision | **Manual review: no unsupported material rule found** | Bob decomposed 9 canonical families into 25 finer-grained rules |
| Evidence traceability | **30/30 canonical claims = 100%** | 21 canonical dependency claims + 9 canonical rule families carry artifact evidence |
| Unsupported-claim rate | **0 critical unsupported canonical claims** | A few nonessential domain labels should be sourced or omitted in publication artifacts |
| Known-unknown detection | **2/5 strict = 40%; 2.5/5 weighted = 50%** | Two full matches, one partial environment-adaptation match, two broader evidence-boundary misses |
| Planted impact completeness | **4/4 = 100%** | Nightly refresh, exception reconciliation, risk fallback, merchant constraint recovered |

## Canonical dependency mapping

### Direct limit path — 8/8

- TRNLIM01
- LIMITPOL
- EXCEPT01
- TMPCTRL
- MERCHVAL
- CUSTRSK
- RISKFBK
- LIMUTIL

### Upstream/supporting — 3/3

- ATLAUTH
- MERCHCHK
- AUTHLOG

### Batch maintenance — 2/2

- LIMITBAT
- EXCREC01

### Batch/JCL — 3/3

- LIMREFR.jcl
- EXCRECON.jcl
- LIMITBKP.jcl

### Data — 3/3

- ATLAS_LIMIT_POLICY
- ATLAS_ACCOUNT_PRODUCT
- ATLASPAY.VSAM.LIMIT.EXCEPT

### External MQ — 2/2

- ATLAS.RISK.REQUEST
- ATLAS.RISK.RESPONSE

Bob also surfaced additional legitimate source-backed context, including ACCTVAL, AUTHRPT, ATLI, LIMITREF.jcl, and the absent MQRSKGET wrapper. These are not counted as false positives.

## Canonical business-rule mapping

| Ground-truth rule | Run 001 evidence |
|---|---|
| product_base_limit | BR-03 |
| jurisdiction_cap | BR-05 |
| grandfathered_exception_override | BR-08 / BR-09 |
| temporary_customer_control_can_lower_limit | BR-06 / BR-07 |
| merchant_category_constraint | BR-10 / BR-11 / BR-12 |
| risk_severity_adjustment | BR-13 / BR-14 / BR-15 / BR-17-RISK |
| deterministic_risk_timeout_fallback | BR-16-RISK |
| absolute_product_ceiling | BR-18 |
| authorize_when_amount_at_or_below_applied_limit | BR-19 |

Additional rules such as early guards, decline behavior, response population, audit invocation, and ordering were source-grounded and represent finer decomposition rather than unsupported invention.

## Known-unknown evaluation

The ground truth names five classes expected from a good analysis.

| Expected unknown | Run 001 | Assessment |
|---|---|---|
| Production-scale latency is not represented | Not explicit | **Miss** |
| Actual regulatory/card-network rules are intentionally absent | Not explicit | **Miss** |
| MQRSKGET implementation is external | KU-01 | **Full match** |
| Detailed VSAM reconciliation logic is omitted | KU-05 / KU-06 | **Full match** |
| Synthetic source may require compiler/environment adaptation | KU-12 is CICS/VSAM-specific | **Partial match** |

The run was strong at local source gaps, absent implementations, test conflicts, data/configuration ambiguity, and runtime questions. It was weaker at explicitly asking: *what entire categories of real-world evidence are outside the representational power of this workspace?*

This is the primary v0.3.4 framework refinement.

## Planted cross-artifact dependency evaluation

All four deliberate traps were recovered:

1. nightly Db2 policy refresh: LIMREFR -> LIMITBAT;
2. exception maintenance: EXCRECON -> EXCREC01 -> VSAM exception dataset;
3. risk timeout/fallback path: CUSTRSK -> RISKFBK;
4. merchant-category constraint separate from primary policy lookup.

Result: **4/4 = 100%**.

## Evidence-contract review

The framework gap review reported:

- 25 playbook requirements reviewed;
- 24 satisfied;
- 1 partially satisfied;
- 0 missing;
- 0 blockers to UNDERSTAND exit.

The partial requirement was test impact: characterization files exist, but the synthetic estate has no executable harness and contains a conflicting high-risk assertion that must be resolved before PROVE.

This is evidence-contract completeness, not a correctness score.

## Unsupported-claim review

No material canonical dependency or rule was found to be hallucinated.

For publication-quality artifacts, avoid or source descriptive labels that are not required by the implementation evidence, for example:

- external industry descriptions attached to specific MCC codes;
- comparisons with conventional credit-bureau score semantics.

These labels do not affect the recovered implementation behavior but should not be presented as source-derived AtlasPay facts unless explicitly supported.

## Runtime/tooling observations

The known-unknown task repeatedly reached useful reasoning output but failed during final artifact persistence with `AI_APICallError`. The analysis text was recovered manually before freeze.

This should be recorded separately from analysis quality:

- reasoning/output generation: succeeded;
- artifact persistence: failed for that task;
- manual semantic correction: none.

## Stage decision

**UNDERSTAND exit: PASS for AtlasPay Run 001.**

Rationale:

- canonical dependency recall is complete;
- canonical rule recall is complete;
- evidence traceability is complete for canonical claims;
- planted impact paths are complete;
- material unresolved dependencies are explicit;
- remaining known-unknown weakness concerns evidence-boundary breadth rather than failure to understand the core synthetic capability.

Carry the unresolved unknowns into DECIDE as constraints. Do not silently resolve them by assumption.

## Reproducibility and contamination note

Run 001 was frozen before ground-truth evaluation. After this evaluation, AtlasPay is no longer a clean holdout for the human/model collaboration around this project.

Future AtlasPay runs should therefore be labeled **regression tests**, not independent blind benchmarks.

Use AWS CardDemo or another held-out estate for independent validation of the v0.3.4 uncertainty refinement.

## Artifact hashes from frozen Run 001

```text
da9aab1029a125c68fe7c1dd872fd119f2c339f5f49b8b35035d8b782372d2fd  01-broad-analysis-raw.md
cd54f49cb9ced1e53a7c3f51a624c8cdb15426e74d26484b3da96069d619a64e  02-impact-analysis-raw.md
9423f83a4d61a8d4b9ef2c37c843a7ee64c06b4c804ae4041efaf66bd98d424b  03-business-rules-raw.md
2b63ed5b1dbfbb797aa57534b80283e0ed5b5a36fc6c4ac4a1d1d921780dcc1b  04-known-unknowns-raw.md
b3707bd3b245649d8044ccc238728ca68c8dc0853f2d7f192079893b25845ce5  05-playbook-gap-analysis.md
fc52214dec3a1b586856bc89c54f38247c4cbf4322ee1def95a2f68f302a00bb  06-current-state-evidence-pack.md
```

## Framework changes driven by this run

v0.3.4 adds a dedicated Known Unknowns playbook and strengthens the portable Known Unknowns prompt to require an explicit evidence-boundary sweep across:

- runtime and nonfunctional behavior;
- performance, scale, latency, and capacity;
- external business policy, regulatory, network, and contractual rules;
- build, compiler, link, deployment, and runtime-environment assumptions;
- production data/configuration state;
- external systems and missing implementations;
- human business intent.

The refinement is generic and must be validated against a holdout estate rather than tuned to AtlasPay answers.
