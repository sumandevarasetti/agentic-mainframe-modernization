# Implementation Planning Prompt

**Framework stage:** PLAN  
**Version:** 0.3.5  
**Status:** Portable supplemental prompt pattern  
**Default permissions:** Read-only

## Purpose

Convert a human-approved modernization disposition into an executable plan while preserving evidence, reversibility, and human authority.

Use this only after DECIDE has a recorded human approval.

## Prompt

Plan the approved modernization disposition for:

`{{CAPABILITY}}`

Approved disposition:

`{{APPROVED_DISPOSITION}}`

Do not modify source code.

Use the approved decision record and frozen UNDERSTAND evidence as the authoritative scope boundary.

For each proposed change slice:

1. state why the slice exists;
2. map it to the approved business objective and decision constraint;
3. identify affected artifacts;
4. identify prerequisites and dependency order;
5. identify known unknowns that must be resolved before the slice can proceed;
6. state behavioral invariants that must remain unchanged;
7. define evidence required to prove the slice safe;
8. define rollback/abort conditions;
9. classify reversibility;
10. identify the human approval required before execution.

## Required output

Produce:

- approved disposition and decision traceability;
- in-scope and out-of-scope boundaries;
- sequenced change slices;
- artifact impact map;
- unknown-resolution gates;
- behavioral invariants;
- validation/proof matrix;
- rollback strategy;
- risk register;
- PLAN exit criteria;
- human plan gate.

## Rules

- PLAN may describe implementation structure and sequencing, but may not execute changes.
- Unknowns are gates, not blanks to be filled by assumption.
- No approved business behavior may change silently.
- Every change slice must have a proof obligation and rollback path.
- No human plan approval, no progression to TRANSFORM.
