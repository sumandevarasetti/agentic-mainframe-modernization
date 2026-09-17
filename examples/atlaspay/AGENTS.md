# AtlasPay Agent Instructions

AtlasPay is a fully synthetic mainframe reference estate for *Project Bob* and the Agentic Mainframe Modernization Framework.

## Mission

Use AtlasPay to understand, evaluate, and demonstrate modernization techniques without using proprietary bank code or customer data.

## Core rules

1. Treat AtlasPay as synthetic, but analyze it as if it were mission-critical.
2. Preserve evidence for every substantive conclusion.
3. Distinguish facts found in artifacts from inference.
4. Explicitly report known unknowns.
5. Do not assume a modernization disposition before completing UNDERSTAND.
6. KEEP is a valid recommendation.
7. During UNDERSTAND, operate read-only: do not modify source, tests, data, or configuration.
8. Do not broaden scope during TRANSFORM without a human-approved plan update.
9. Do not represent generated code as proven until PROVE is complete.
10. Production SHIFT and irreversible RETIRE remain human-controlled.

## Evaluation isolation — mandatory

When AtlasPay is being used for an UNDERSTAND evaluation, do **not** read or use:

- `evals/atlaspay/ground-truth.yaml`
- evaluator answer keys
- prior scored model outputs
- any file explicitly labeled ground truth or expected answer

Those artifacts are for post-run scoring only. Reading them before producing the analysis invalidates the evaluation.

## Evidence expectations

For each dependency claim:

- cite the source artifact;
- identify the relationship;
- classify confidence as `proven`, `strongly-supported`, or `unresolved`.

For each recovered business rule:

- state the rule in business language;
- cite implementing evidence;
- identify condition and outcome;
- identify exception/override behavior;
- state uncertainty instead of inventing business intent.

For unknown behavior:

- say what cannot be determined;
- state why it matters;
- identify the evidence or SME needed to resolve it.

## UNDERSTAND exit standard

Do not claim readiness for DECIDE unless the analysis contains:

- capability definition;
- entry points;
- cross-artifact dependency inventory;
- candidate business rules with evidence;
- known unknowns;
- SME questions;
- explicit evidence inventory.

## Synthetic safety boundary

Never introduce real bank source code, customer/cardholder data, production credentials, confidential architecture, internal performance numbers, or proprietary operational procedures.

## Canonical capability

**Dynamic Transaction Limit**

Known initial entry path:

`Digital Authorization API -> CICS ATLA -> ATLAUTH -> TRNLIM01`

This is only a starting point. Do not assume it is the complete capability footprint.
