# IBM Bob Integration

IBM Bob Premium Package for Z (PP4Z) is the primary IBM Z reference implementation for *Project Bob*.

## Design rule

> **Do not rebuild a verified PP4Z capability in the framework. Compose it.**

The Agentic Strangler layer defines lifecycle, evidence contracts, human gates, evaluation and progression criteria. PP4Z supplies Z-specific execution capabilities.

## Experiments

- UNDERSTAND: `understand/atlaspay-experiment-001.md`
- DECIDE: `decide/atlaspay-experiment-002.md`
- PLAN: `plan/atlaspay-experiment-003.md`
- TRANSFORM: `transform/atlaspay-experiment-004.md`
- PROVE: `prove/atlaspay-experiment-005.md`

TRANSFORM uses Z Code where appropriate, but source modification is authorized only per human-approved PLAN slice. PROVE is read-only and classifies exactly what static and runtime evidence establishes. Runtime validation must be reported honestly; AtlasPay workspace results must not be presented as production/zOS execution evidence.

## Rules

- Do not invent Bob syntax or capability names.
- Record verification date/version context.
- Use synthetic/authorized data.
- Separate observed Bob output from framework interpretation.
- Do not imply IBM endorsement.
- Do not generalize PP4Z experiment results to IBM i or Java Premium Packages.
- No deployment or production change is authorized by TRANSFORM.
