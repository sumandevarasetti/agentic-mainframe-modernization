# IBM Bob Integration

IBM Bob Premium Package for Z (PP4Z) is the primary IBM Z reference implementation for *Project Bob*.

## Scope

This repository is intentionally **Z-focused** for the current book and implementation. IBM Bob Premium Packages for IBM i and Java modernization are acknowledged, but they are not implemented, benchmarked, or mapped here yet.

The methodology remains portable; the current execution evidence is PP4Z-specific.

See:

- `../../docs/architecture/scope-and-package-strategy.md`
- `../../docs/architecture/native-capability-first.md`

## Design rule

> **Do not rebuild a verified PP4Z capability in the framework. Compose it.**

The Agentic Strangler layer defines lifecycle, evidence contracts, human gates, evaluation and progression criteria. PP4Z supplies Z-specific execution capabilities.

Read these first:

- `VERIFIED-CAPABILITIES.md`
- `capability-mapping.yaml`
- `../../docs/architecture/native-capability-first.md`

## Framework vs product

Framework playbook YAML and Markdown prompts are **not** claimed to be Bob-native extension syntax.

Use native PP4Z capabilities when verified. Use framework assets to:

- sequence capabilities;
- state evidence requirements;
- expose uncertainty;
- normalize outputs;
- evaluate quality;
- preserve human authority.

## UNDERSTAND

`understand/atlaspay-experiment-001.md`

Run 001 established a reproducible PP4Z workspace-mode baseline without Z Understand.

Formal evaluation:

`../../evals/atlaspay/runs/run-001/evaluation.md`

## DECIDE

`decide/atlaspay-experiment-002.md`

DECIDE compares modernization dispositions from frozen evidence and requires a named human decision owner.

## PLAN

`plan/atlaspay-experiment-003.md`

PLAN uses the human-approved disposition and PP4Z native implementation-planning capability to build a bounded, reversible plan. The framework requires change-slice scope, unknown-resolution gates, proof obligations, rollback, and a named human plan approver.

PLAN remains read-only. No source modification is authorized until the plan itself passes the human gate.

## Rules

- Do not invent Bob syntax or capability names.
- Record verification date/version context.
- Use synthetic/authorized data.
- Keep portable framework definitions outside product integration directories.
- Separate observed Bob output from framework interpretation.
- Do not imply IBM endorsement.
- Do not generalize PP4Z experiment results to IBM i or Java Premium Packages.
- Do not present workspace-mode AtlasPay results as enterprise-wide Z Understand validation.
