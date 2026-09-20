# Controlled Refactor Prompt

**Framework stage:** TRANSFORM  
**Version:** 0.3.6  
**Status:** Portable supplemental prompt pattern

## Purpose

Apply one approved PLAN slice at a time without scope creep.

## Prompt

Transform only:

`{{AUTHORIZED_SLICE}}`

for:

`{{CAPABILITY}}`

Use the reviewed PLAN and human plan gate as authoritative scope.

Before changing a file:

1. identify the exact approved slice;
2. list the files the slice permits;
3. list required resolution gates and prove they are cleared;
4. list containment gates and state how the change avoids crossing them;
5. record the observed baseline behavior that must remain invariant;
6. record the source-level rollback boundary.

Then make only the minimum source change necessary for the authorized slice.

After the change:

- produce a diff summary;
- map every change to a PLAN item;
- identify any behavior difference;
- report static validation performed;
- report runtime validation as VERIFIED, NOT RUN, or UNAVAILABLE;
- preserve unresolved unknowns;
- stop before deployment.

## Rules

- One authorized slice at a time.
- No gate clearance by assumption.
- No target-scope expansion.
- No deployment.
- No production authorization.
- No runtime-equivalence claim without runtime evidence.
