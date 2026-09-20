# AtlasPay UNDERSTAND Experiment 001 — IBM Bob PP4Z Workspace-Mode Procedure

**Framework procedure:** v0.3.4  
**Original scored run:** framework v0.3.2  
**Estate:** AtlasPay  
**Capability:** Dynamic Transaction Limit  
**Goal:** Evaluate PP4Z-backed UNDERSTAND output against controlled AtlasPay ground truth without leaking the answer key into the Bob workspace.

## Principle

This experiment tests whether PP4Z capabilities, composed through Agentic Strangler evidence contracts, produce decision-grade understanding.

The reproducible baseline is **PP4Z workspace mode**. Z Understand may be added when independently available and authorized, but it is not required for this experiment and must not be simulated.

## 0. Prepare an isolated workspace

Do not open the repository root as the scored Bob workspace because it contains `evals/atlaspay/ground-truth.yaml`.

Create a separate workspace containing only the AtlasPay estate and the framework assets explicitly required for the run. Use `prepare-atlaspay-run.sh`.

The evaluator ground truth must remain outside Bob's accessible workspace.

## 1. Record run metadata

Record:

- run ID and date/time;
- IBM Bob version;
- PP4Z context/version if visible;
- execution mode: workspace;
- whether Z Understand is configured;
- whether `DD.json` is available;
- source commit/tag;
- confirmation that ground truth is absent.

Do not invent unavailable product/runtime metadata.

## 2. Establish native PP4Z context

In the isolated workspace:

1. run `/init` so Bob generates repository-level `AGENTS.md`;
2. review the generated instructions;
3. if an authorized Z Understand environment is available, record and use it;
4. if the installed PP4Z environment can generate `DD.json` without unavailable dependencies, record and use it;
5. otherwise record those capabilities as unavailable for the run.

Do not create synthetic `DD.json` or fake Z Understand output.

## 3. Merge the governance overlay

Merge `AGENTS.framework.md` governance/evidence rules into Bob-generated `AGENTS.md`.

Preserve useful native/application guidance. The overlay adds:

- read-only UNDERSTAND behavior;
- evidence requirements;
- fact/inference/unknown separation;
- human authority;
- evaluation-ground-truth isolation.

## 4. Run native UNDERSTAND analysis first

Use Z Architect and verified PP4Z capabilities available in the environment.

Freeze unedited outputs for:

1. broad capability/application analysis;
2. native impact analysis;
3. business-rule/documentation recovery;
4. known-unknown analysis.

If Bob reasoning completes but artifact persistence fails, record the runtime event and preserve the unedited recoverable textual output. Do not silently repair the analysis.

## 5. Apply framework playbooks as evidence contracts

Copy only the required framework playbooks into the isolated workspace:

- `playbooks/discovery/playbook.yaml`
- `playbooks/dependency-analysis/playbook.yaml`
- `playbooks/rule-extraction/playbook.yaml`
- `playbooks/known-unknowns/playbook.yaml`

Do **not** expose `evals/atlaspay/ground-truth.yaml`.

Review native output for evidence-contract gaps. Do not rerun discovery merely to make the report look complete.

## 6. Supplemental prompting

Use supplemental prompts only when a documented evidence-contract gap justifies them.

The v0.3.4 Known Unknowns prompt requires an evidence-boundary sweep across runtime/nonfunctional, performance/scale, external policy/regulatory, build/runtime environment, production state, external systems, and human business intent.

Record every supplemental prompt used and why.

## 7. Build the Current-State Evidence Pack

Synthesize frozen outputs into a decision-grade pack.

Classify material claims as:

- PROVEN;
- STRONGLY_SUPPORTED;
- UNRESOLVED.

Preserve contradictions and known unknowns. Do not select a modernization disposition.

## 8. Freeze the run

Before scoring:

- save all raw outputs;
- save the final evidence pack;
- save screenshots;
- record SHA-256 hashes for all scored artifacts **including run metadata**;
- make no semantic corrections to the frozen answer.

## 9. Evaluate outside Bob

Only after freeze, compare against:

`evals/atlaspay/ground-truth.yaml`

Use `evals/atlaspay/understand-eval.yaml`.

The original Run 001 evaluation is published at:

`evals/atlaspay/runs/run-001/evaluation.md`

## 10. Holdout rule

After a run has been compared with AtlasPay ground truth, subsequent AtlasPay runs are regression tests.

Use AWS CardDemo or another held-out estate for independent validation of framework refinements.

## Screenshot targets

Capture at least:

1. PP4Z/Z Architect capability analysis;
2. native impact analysis exposing a non-obvious dependency;
3. business-rule/documentation output with source context;
4. an uncertainty/human-validation point.

All screenshots must use synthetic AtlasPay content only.
