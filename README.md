# Agentic Mainframe Modernization Framework

**Version:** 0.3.1  
**Status:** PP4Z-aligned UNDERSTAND foundation  
**Companion project:** *Project Bob — Accelerating Mainframe Modernization with Agentic AI*

> **Read it in the book. Run it in the repo.**

This repository is the open companion implementation for *Project Bob*. It turns the book's modernization methodology into inspectable, reusable assets: lifecycle definitions, human approval gates, evidence models, synthetic mainframe estates, framework playbooks, supplemental prompts, evaluations, and verified product mappings.

## Core lifecycle

**Project Strangler architecture:**  
**Observe → Encapsulate → Extract → Redirect → Retire**

**Project Bob execution:**  
**UNDERSTAND → DECIDE → PLAN → TRANSFORM → PROVE → SHIFT → LEARN**

Core rules:

1. **No Evidence, No Progression.**
2. **Agents perform work. Humans retain authority.**
3. **Agent autonomy generally decreases as irreversibility increases.**
4. **Modernization is decision-first, not generation-first.**
5. **KEEP is a valid modernization decision.**
6. **Native capability first.** If the selected platform already provides a verified capability, the framework composes and evaluates it rather than rebuilding it.

## IBM Bob Premium Package for Z alignment

IBM Bob Premium Package for Z (PP4Z) is the primary IBM Z reference implementation for this project. PP4Z already provides Z-specific modes, workflows, skills, tools, Z Understand-backed analysis, repository guidance through `AGENTS.md`, data-dictionary support, impact analysis, implementation planning, explanation, documentation/business-rule extraction, refactoring, and transformation workflows.

The Agentic Strangler Framework does **not** attempt to recreate those product capabilities.

Instead, the framework defines:

- which capability should run at each modernization stage;
- what evidence it must produce;
- what uncertainty must remain explicit;
- which human decisions are required;
- how outputs are evaluated;
- how stages connect into a full modernization lifecycle.

> **IBM Bob supplies modernization capabilities. Agentic Strangler supplies modernization discipline.**

See:

- `docs/architecture/native-capability-first.md`
- `integrations/ibm-bob/capability-mapping.yaml`
- `integrations/ibm-bob/VERIFIED-CAPABILITIES.md`

## Framework playbooks, not duplicate Bob Skills

The portable framework assets previously called `skills/` are now called **playbooks**:

- `playbooks/discovery/`
- `playbooks/dependency-analysis/`
- `playbooks/rule-extraction/`

A framework playbook is a vendor-neutral execution/evidence contract. It may map to one or more native PP4Z workflows, skills, commands, and tools. It is **not** a replacement for an IBM Bob Skill and is not claimed to use Bob-native extension syntax.

Supplemental prompts remain under `prompts/`. They should be used to close evidence gaps or standardize outputs after native capabilities are used, not to replace verified PP4Z functionality.

## UNDERSTAND on IBM Bob

For the first controlled AtlasPay experiment, the native-first sequence is:

1. prepare an isolated AtlasPay workspace that does not contain evaluator ground truth;
2. configure Z Understand where available;
3. generate the data dictionary / `DD.json` using PP4Z;
4. run `/init` to generate native `AGENTS.md`;
5. merge `examples/atlaspay/AGENTS.framework.md` governance requirements into the generated instructions;
6. use PP4Z native impact-analysis, explanation, and documentation/business-rule capabilities;
7. use framework prompts only for unresolved evidence gaps;
8. freeze outputs;
9. score against `evals/atlaspay/ground-truth.yaml` outside the Bob workspace.

Detailed procedure: `integrations/ibm-bob/understand/atlaspay-experiment-001.md`.

## Reference estates

### AtlasPay — canonical teaching + evaluation estate

`examples/atlaspay/`

Use AtlasPay when known answers and repeatable evaluation are required. The evaluation ground truth must not be present in the model's experiment workspace.

### AWS CardDemo — external benchmark estate

`benchmarks/aws-carddemo/`

Use CardDemo after the framework performs acceptably against AtlasPay. CardDemo remains upstream; this repository provides a pinned benchmark adapter rather than repackaging AWS source.

## IBM relationship

IBM, IBM Z, IBM Bob, CICS, Db2 and related names may be trademarks of IBM. This is an independent companion framework and does not imply IBM endorsement, sponsorship, certification, or approval.

## License

Apache License 2.0. See `LICENSE`.
