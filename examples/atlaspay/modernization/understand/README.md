# AtlasPay UNDERSTAND Runbook

**Framework release:** v0.3.1  
**Capability:** Dynamic Transaction Limit  
**Mode:** read-only evaluation / experimentation

This runbook defines the framework evidence sequence for UNDERSTAND. For IBM Bob Premium Package for Z, use the native-first procedure in:

`integrations/ibm-bob/understand/atlaspay-experiment-001.md`

## Critical evaluation rule

Do **not** expose `evals/atlaspay/ground-truth.yaml` to the model before the run is complete. For scored Bob runs, use a physically isolated AtlasPay workspace, not just a prompt instruction.

## IBM Bob / PP4Z sequence

1. prepare isolated AtlasPay workspace;
2. configure Z Understand where available;
3. generate native data-dictionary context / `DD.json`;
4. run `/init` to generate `AGENTS.md`;
5. merge `AGENTS.framework.md` governance requirements;
6. run native PP4Z impact/explanation/documentation capabilities;
7. check outputs against framework playbook evidence contracts;
8. use supplemental prompts only for identified gaps;
9. synthesize Current-State Evidence Pack;
10. freeze all outputs;
11. evaluate outside the Bob workspace.

## Framework playbooks

- `playbooks/discovery/playbook.yaml`
- `playbooks/dependency-analysis/playbook.yaml`
- `playbooks/rule-extraction/playbook.yaml`

## Supplemental prompts

- `prompts/understanding/capability-discovery.md`
- `prompts/impact-analysis/change-impact.md`
- `prompts/business-rules/extract-business-rules.md`
- `prompts/understanding/known-unknowns.md`
- `prompts/understanding/sme-questions.md`

These prompts are not the primary PP4Z implementation of discovery, impact analysis, or business-rule extraction. They exist for evidence gaps, normalization and portability.

## Current-State Evidence Pack

Use the Understanding Agent contract at `agents/understanding-agent/agent.yaml` and the evidence template in this directory.

Record which native PP4Z capabilities were used and which supplemental framework assets were required.

## Evaluation

After outputs are frozen, score against:

- `evals/atlaspay/ground-truth.yaml`
- `evals/understanding/eval-config.yaml`
- `evals/understanding/scoring-rubric.md`

The goal is decision-grade understanding with high dependency/rule recall, strong evidence traceability, low unsupported-claim rate, and useful unknown detection.
