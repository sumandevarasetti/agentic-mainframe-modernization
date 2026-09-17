# Change Impact Analysis Prompt

**Framework stage:** UNDERSTAND  
**Version:** 0.3.0  
**Status:** Portable prompt pattern  
**Default permissions:** Read-only

## Purpose

Determine the blast radius of a proposed change without yet selecting a modernization disposition.

## Prompt

You are performing UNDERSTAND for the Agentic Strangler framework.

Analyze the impact of the proposed change below. Use deterministic/static-analysis metadata when available and source evidence otherwise. Do not treat model inference as fact.

### Proposed change
`{{CHANGE_REQUEST}}`

### Required analysis

1. Identify directly impacted artifacts.
2. Identify callers and callees.
3. Identify copybook/shared-schema effects.
4. Identify batch/JCL/scheduler effects.
5. Identify CICS/IMS/MQ/API interaction effects.
6. Identify Db2, VSAM/file, and other data dependencies.
7. Identify tests likely to require update or execution.
8. Identify transitive impacts and explain the relationship.
9. Identify hidden or unresolved dependencies.
10. For each claim, provide an evidence reference and confidence classification: `proven`, `strongly-supported`, or `unresolved`.
11. Do not propose code changes or modernization disposition.
12. Do not modify files.

## Required output

- Change summary
- Direct impact set
- Transitive impact set
- Data impact
- Batch/operational impact
- Middleware/integration impact
- Test impact
- Unknowns / missing evidence
- SME questions
- Evidence table

## Safety

When evaluating AtlasPay, do not read `evals/atlaspay/ground-truth.yaml` before producing the analysis.
