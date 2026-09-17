# UNDERSTAND Scoring Rubric

## 1. Dependency Recall

Score relevant expected dependencies against `evals/atlaspay/ground-truth.yaml`.

`Dependency Recall = correctly discovered expected dependencies / total expected dependencies`

Count a dependency only when the output identifies the artifact/entity and materially correct relationship.

## 2. Business Rule Recall

`Business Rule Recall = correctly recovered canonical rules / total canonical rules`

A rule may use different wording, but must preserve the core condition/outcome. Credit requires supporting evidence.

## 3. Evidence Traceability

Identify substantive factual claims about behavior/dependencies/rules.

`Evidence Traceability = claims with valid artifact evidence / substantive claims`

Evidence is invalid when the cited artifact does not support the claim.

## 4. Unsupported Claim Rate

`Unsupported Claim Rate = unsupported or contradicted substantive claims / substantive claims`

Examples:

- inventing an external service that does not exist;
- claiming a regulatory rule absent from the estate;
- asserting runtime performance from static source;
- converting a hypothesis into fact.

## 5. Known-Unknown Detection

Compare model-declared unknowns with the canonical list in ground truth.

`Known-Unknown Detection = material expected unknowns identified / expected unknowns`

Also note useful additional unknowns that are logically justified.

## 6. Impact Analysis Completeness

Score category coverage:

- program/call dependencies
- batch/JCL dependencies
- data dependencies
- middleware/external dependencies
- tests/operational dependencies

Each category receives 0, 0.5, or 1.0:

- `0` = materially absent
- `0.5` = partial
- `1.0` = decision-useful

Average the five categories.

## Overall interpretation

A strong UNDERSTAND result is not necessarily the longest response. It should discover the important cross-artifact structure, recover rules with evidence, and be explicit about uncertainty.

A fluent answer that misses batch, exception, data, or external paths should score poorly even if its prose is convincing.
