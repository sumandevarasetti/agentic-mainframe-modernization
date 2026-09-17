# AtlasPay UNDERSTAND Runbook

**Framework release:** v0.3.0  
**Capability:** Dynamic Transaction Limit  
**Mode:** read-only evaluation / experimentation

This runbook exercises the first Agentic Strangler stage against the synthetic AtlasPay estate.

## Critical evaluation rule

Do **not** expose `evals/atlaspay/ground-truth.yaml` to the model before the run is complete. Ground truth is an evaluator input, not model context.

## Recommended sequence

### Step 0 — Environment preparation

In an authorized IBM Bob Premium Package for Z environment, consult `integrations/ibm-bob/VERIFIED-CAPABILITIES.md` and current IBM documentation. Where available, configure Z Understand, generate/review `DD.json`, and initialize repository guidance appropriately.

The portable prompts below may be copied into Bob or another capable AI harness. They are not claimed to be Bob-native extension syntax.

### Step 1 — Capability discovery

Use:

`prompts/understanding/capability-discovery.md`

Inputs:

- Capability: `Dynamic Transaction Limit`
- Business request: `Make transaction limits dynamic using account/product context, jurisdiction, temporary controls, merchant category, exceptions, and current risk context.`

Save output as `runs/<RUN_ID>/01-capability-discovery.md`.

### Step 2 — Change impact

Use:

`prompts/impact-analysis/change-impact.md`

Proposed change:

`Extract/evolve Dynamic Transaction Limit behind a stable capability boundary while preserving unchanged behavior.`

Save as `02-change-impact.md`.

### Step 3 — Business-rule recovery

Use:

`prompts/business-rules/extract-business-rules.md`

Save as `03-business-rules.md`.

### Step 4 — Known unknowns

Use:

`prompts/understanding/known-unknowns.md`

Save as `04-known-unknowns.md`.

### Step 5 — SME questions

Use:

`prompts/understanding/sme-questions.md`

Save as `05-sme-questions.md`.

### Step 6 — Current-State Evidence Pack

Synthesize the preceding outputs using the Understanding Agent contract in `agents/understanding-agent/agent.yaml`.

Save as `06-current-state-evidence-pack.md`.

### Step 7 — Score after isolation boundary

Only after all model outputs are frozen, compare them with:

`evals/atlaspay/ground-truth.yaml`

Use:

- `evals/understanding/eval-config.yaml`
- `evals/understanding/scoring-rubric.md`

## Expected outcome

The goal is not a perfect narrative. The goal is decision-grade understanding with high dependency/rule recall, strong evidence traceability, few unsupported claims, and useful unknown detection.
