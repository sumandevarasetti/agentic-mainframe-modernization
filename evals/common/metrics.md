# Common Understanding Metrics

These metrics are designed for UNDERSTAND-stage evaluation across synthetic and external mainframe estates.

## Dependency Recall

`correct expected dependencies found / expected dependencies`

Report separately for programs, batch jobs, data stores, transactions, and external interfaces.

## Dependency Precision

`correct dependency claims / all dependency claims`

Penalizes invented relationships.

## Business Rule Recall

`correct expected business rules recovered / expected business rules`

A rule counts only when the recovered meaning is materially correct.

## Business Rule Precision

`correct rule claims / all rule claims`

Unsupported invented rules reduce precision.

## Evidence Traceability

Percentage of substantive dependency/rule claims that cite a specific source artifact and enough context to validate the claim.

## Unsupported-Claim Rate

`unsupported substantive claims / all substantive claims`

Lower is better.

## Known-Unknown Quality

Qualitative/structured score for whether the analysis identifies missing evidence and uncertainty rather than fabricating certainty.

Suggested rubric:

- 0 — hides or invents around uncertainty
- 1 — generic caveats only
- 2 — identifies some concrete unknowns
- 3 — identifies material unknowns and explains why they matter
- 4 — identifies, prioritizes, and proposes evidence/S​​ME questions to resolve them

## Impact Analysis Completeness

Measures whether the analysis covers online code, batch, data, messaging, runtime/transaction metadata, tests, and operational dependencies relevant to the requested change.

## Evaluation principle

A fluent explanation with poor evidence traceability should not score highly.
