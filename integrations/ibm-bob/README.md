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

Framework assets such as playbook YAML, framework-agent YAML and Markdown prompts are **not** claimed to be Bob-native extension syntax.

Use native PP4Z capabilities when verified. Use framework assets to:

- sequence capabilities;
- state evidence requirements;
- expose uncertainty;
- normalize outputs;
- evaluate quality;
- preserve human authority.

## UNDERSTAND experiment

The first controlled IBM Bob experiment is documented at:

`understand/atlaspay-experiment-001.md`

Run 001 established a reproducible **workspace-mode baseline without Z Understand**. Z Understand remains an optional enterprise-scale analysis layer, not a prerequisite for reproducing the AtlasPay experiment.

Formal evaluation:

`../../evals/atlaspay/runs/run-001/evaluation.md`

## DECIDE experiment

The next AtlasPay continuation is:

`decide/atlaspay-experiment-002.md`

DECIDE uses the frozen UNDERSTAND evidence to compare modernization dispositions. The framework owns the decision discipline; a named human owns the final decision.

## Rules

- Do not invent Bob syntax or capability names.
- Record verification date/version context.
- Use synthetic/authorized data.
- Keep portable framework definitions outside product integration directories.
- Separate observed Bob output from framework interpretation.
- Do not imply IBM endorsement.
- Do not generalize PP4Z experiment results to IBM i or Java Premium Packages.
- Do not present workspace-mode AtlasPay results as enterprise-wide Z Understand validation.
