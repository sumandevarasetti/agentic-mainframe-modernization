# AtlasPay DECIDE Experiment 002 — Evidence-Driven Modernization Decision

**Framework:** v0.3.4  
**Estate:** AtlasPay  
**Capability:** Dynamic Transaction Limit  
**Input:** Frozen UNDERSTAND Run 001 Current-State Evidence Pack  
**Goal:** Compare modernization dispositions without prematurely planning or transforming the system.

## Status of AtlasPay as an evaluation estate

AtlasPay is no longer a clean blind benchmark after Run 001 was scored against the canonical answer key. Experiment 002 is therefore a **continuation/regression exercise**, not an independent benchmark.

Use AWS CardDemo or another held-out estate for independent validation of v0.3.4 framework refinements.

## Principle

DECIDE answers:

> Given the evidence, what modernization disposition is justified, what alternatives were rejected, and what unknowns constrain the decision?

It does **not** answer:

> How should the implementation be built?

Implementation sequencing belongs to PLAN.

## Required inputs

Use only the frozen UNDERSTAND evidence and the stated business objective:

- Current-State Evidence Pack from Run 001;
- frozen impact analysis;
- known-unknown register;
- Evidence Gap Register;
- modernization business objective.

Do not use evaluator ground truth as a decision input.

## Decision options

Evaluate all applicable options:

- KEEP
- REFACTOR
- EXPOSE
- EXTRACT
- TRANSFORM
- REPLATFORM
- RETIRE

KEEP must remain a valid outcome.

## Bob execution guidance

Preferred mode: **Z Architect**.

Native PP4Z analysis may be used as supporting evidence where it already exists. Do not rerun broad UNDERSTAND discovery unless DECIDE exposes a specific evidence gap.

The framework owns the decision discipline; Bob provides analysis inputs and structured reasoning support. A human owns the final disposition.

## Decision request

Use this request after copying the DECIDE playbook into the isolated workspace:

> Perform a DECIDE-stage modernization analysis for the AtlasPay Dynamic Transaction Limit capability.
>
> Use the frozen UNDERSTAND evidence only. Do not rediscover the application and do not create an implementation plan.
>
> Evaluate KEEP, REFACTOR, EXPOSE, EXTRACT, TRANSFORM, REPLATFORM, and RETIRE where applicable.
>
> For each option:
> - state the business/technical rationale;
> - cite the evidence supporting or weakening it;
> - identify coupling reduced or retained;
> - identify behavioral and operational risk;
> - identify known unknowns that constrain the option;
> - state what would have to be proven later;
> - distinguish evidence from assumption.
>
> Then produce a proposed disposition, rejected alternatives with reasons, decision constraints, proof obligations, unresolved questions, and the required human decision owner.
>
> Do not modify source, select a target implementation technology, or produce a PLAN-stage implementation sequence.
>
> Save the result to:
> `runs/atlaspay/decide/run-002/01-modernization-decision-record.md`

## Human gate

The agent's proposed disposition is not final.

A named human architect/decision owner must:

1. review the evidence mapping;
2. verify that unresolved unknowns were carried forward;
3. accept or reject the proposed disposition;
4. record rationale;
5. approve progression to PLAN.

## Required output

The Modernization Decision Record must contain:

1. business objective;
2. options considered;
3. evidence for and against each option;
4. proposed disposition;
5. rejected alternatives and rationale;
6. decision constraints;
7. known unknowns carried forward;
8. proof obligations;
9. human decision owner;
10. approval status.

## Exit rule

**No evidence-backed human decision, no progression to PLAN.**
