# IBM Bob Integration

IBM Bob Premium Package for Z (PP4Z) is the primary IBM Z reference implementation for *Project Bob*.

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

It uses PP4Z-native setup and analysis first, then supplemental framework prompts only if evidence gaps remain.

## Rules

- Do not invent Bob syntax or capability names.
- Record verification date/version context.
- Use synthetic/authorized data.
- Keep portable framework definitions outside product integration directories.
- Separate observed Bob output from framework interpretation.
- Do not imply IBM endorsement.
