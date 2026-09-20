# AtlasPay TRANSFORM Experiment 004 — Controlled Refactor

**Framework:** v0.3.6  
**Estate:** AtlasPay  
**Capability:** Dynamic Transaction Limit  
**Approved disposition:** REFACTOR — APPROVED WITH CONDITIONS  
**Approved PLAN:** reviewed Run 003  
**Goal:** Execute one approved source-level refactoring slice at a time with explicit gate clearance, diff traceability, and no deployment.

## Important limitation

AtlasPay is a synthetic analysis-grade estate. The repository does not by itself prove that the source currently compiles, links, deploys, or executes in an authorized z/OS/CICS environment.

TRANSFORM may therefore produce **source-level changes** and static evidence in the repository, but must label runtime verification honestly:

- VERIFIED — only when executed in an authorized runtime;
- NOT RUN — when execution was intentionally not performed;
- UNAVAILABLE — when no authorized runtime is available.

No runtime-equivalence claim is permitted without runtime evidence.

## Preconditions

TRANSFORM may begin only when the isolated workspace contains:

- reviewed PLAN: `runs/atlaspay/plan/run-003/02-implementation-plan-reviewed.md`;
- human PLAN gate: `runs/atlaspay/plan/run-003/03-human-plan-gate.md`;
- `framework-assets/playbooks/controlled-transform/playbook.yaml`;
- a slice-specific authorization record.

## Native Capability First

Preferred mode: **Z Code**.

Use the verified PP4Z refactoring/transformation capability appropriate to the authorized slice where available. Do not invent a product command if the installed Bob version does not expose one.

The framework owns gate enforcement, scope, evidence, and traceability.

## Slice authorization rule

Do not authorize all six slices at once.

Each source-changing slice requires a short authorization record containing:

- slice ID and name;
- resolution gates cleared;
- containment gates still open and how they are preserved;
- allowed files;
- prohibited files;
- required invariants;
- source-level rollback boundary;
- runtime-validation status.

## First transformation activity

The first activity is **Slice 0 — Characterization Baseline & KU-13 Authority Resolution**.

Slice 0 is evidence work, not application refactoring.

Before any source-changing slice:

1. record the human decision for KU-13;
2. preserve both conflicting test artifacts as historical evidence;
3. identify the approved expected behavior for the high-risk branch;
4. establish the characterization baseline;
5. do not change production/source behavior.

## Source-changing slices

After Slice 0 is complete, authorize only the next slice whose gates are clear.

For every source-changing slice:

1. create a dedicated branch;
2. record allowed artifacts;
3. capture pre-change hashes where practical;
4. apply only that slice;
5. capture diff;
6. perform available static checks;
7. perform runtime checks only in an authorized environment;
8. record rollback boundary;
9. stop for review before the next slice.

## Output layout

Use:

`runs/atlaspay/transform/run-004/`

Suggested artifacts:

- `00-ku13-authority-decision.md`
- `01-slice-0-characterization-baseline.md`
- `02-slice-authorization.md`
- `03-source-diff.md`
- `04-transform-evidence.md`

Do not overwrite prior-stage evidence.

## Exit rule

TRANSFORM does not authorize deployment.

A completed source slice proceeds to PROVE only after:

- scope compliance is reviewed;
- required gates are cleared/contained;
- source diff is captured;
- runtime validation status is explicit;
- rollback evidence is sufficient for the environment actually used.

**No proof, no progression.**
