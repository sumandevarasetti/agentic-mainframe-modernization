# Capability Discovery Prompt

**Framework stage:** UNDERSTAND  
**Version:** 0.3.0  
**Status:** Portable prompt pattern  
**Default permissions:** Read-only

## Purpose

Discover the full technical footprint of a business capability before any modernization disposition is proposed.

## Prompt

You are performing the UNDERSTAND stage of the Agentic Strangler framework.

Analyze the requested business capability across the available workspace. Do not assume the capability is implemented in a single program or language.

For the capability named below:

1. identify the likely entry point(s);
2. identify directly and indirectly related programs;
3. identify copybooks, JCL, schedulers, transactions, database objects, VSAM/files, MQ/messages, configuration, and tests that materially participate;
4. separate direct evidence from inference;
5. cite the artifact supporting every substantive dependency claim;
6. identify runtime/external dependencies that cannot be proven from the workspace;
7. identify known unknowns and confidence gaps;
8. do not recommend modernization yet;
9. do not modify files.

### Capability

`{{CAPABILITY}}`

### Business request / context

`{{BUSINESS_REQUEST}}`

## Required output

Produce these sections:

### A. Capability definition
A concise evidence-grounded definition.

### B. Entry points
For each entry point: artifact, mechanism, evidence, confidence.

### C. Dependency inventory
Use categories: programs, copybooks, batch/JCL, CICS/IMS, data stores, MQ/events, APIs, files, tests, external/unknown.

### D. Dependency relationships
Represent as `source -> relationship -> target`, with evidence references.

### E. Known unknowns
State what cannot be determined from available evidence. Do not guess.

### F. Questions for SMEs
Only questions whose answers would materially improve decision-grade understanding.

### G. Evidence summary
List every artifact used.

## Evaluation rule

A high-quality answer discovers cross-artifact dependencies and explicitly reports missing evidence. A polished explanation that misses batch, data, middleware, or exception paths is not sufficient.

## AtlasPay evaluation safety

When evaluating AtlasPay, do **not** read `evals/atlaspay/ground-truth.yaml` or any scored expected-output file before producing the analysis.
