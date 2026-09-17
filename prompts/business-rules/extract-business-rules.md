# Business Rule Extraction Prompt

**Framework stage:** UNDERSTAND  
**Version:** 0.3.0  
**Status:** Portable prompt pattern  
**Default permissions:** Read-only

## Purpose

Recover business rules with source-level traceability instead of producing an unsourced prose summary.

## Prompt

You are performing UNDERSTAND for the Agentic Strangler framework.

Recover business rules related to:

`{{CAPABILITY}}`

Rules may be distributed across source programs, copybooks, data definitions, configuration, JCL, middleware contracts, exception files, and tests.

For every candidate rule:

1. assign a local identifier such as `BR-CAND-001`;
2. state the rule in business language;
3. cite the implementing/evidencing artifact(s);
4. identify the condition and outcome;
5. classify it as `proven`, `strongly-supported`, or `hypothesis`;
6. identify exception/override behavior;
7. identify whether batch or external state influences the rule;
8. state uncertainties explicitly;
9. do not invent regulatory or business intent not present in evidence;
10. do not modify files.

## Required output table

| Candidate ID | Business rule | Condition | Outcome | Evidence | Confidence | Exceptions / unknowns |
|---|---|---|---|---|---|---|

Then provide:

- rule interactions / precedence;
- possible contradictions;
- missing evidence;
- SME questions;
- artifacts inspected.

## Evaluation rule

Rule quality is measured by recovery accuracy **and** evidence traceability. A plausible rule without evidence is not a recovered rule.

## AtlasPay evaluation safety

Do not read `evals/atlaspay/ground-truth.yaml` before generating the candidate rule set.
