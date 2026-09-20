# Agentic Mainframe Modernization Framework

**Version:** 0.3.5  
**Status:** Z-focused PP4Z framework through PLAN  
**Companion project:** *Project Bob — Accelerating Mainframe Modernization with Agentic AI*

> **Read it in the book. Run it in the repo.**

This repository is the open companion implementation for *Project Bob*. It turns the book's modernization methodology into inspectable, reusable assets: lifecycle definitions, human approval gates, evidence models, synthetic mainframe estates, framework playbooks, supplemental prompts, evaluations, and verified product mappings.

## Scope

**Project Bob is Z-focused in implementation, portable in methodology.**

The current book, reference implementation, experiments, and evidence are intentionally centered on **IBM Z** and **IBM Bob Premium Package for Z (PP4Z)**. AtlasPay remains the canonical synthetic teaching estate.

The framework core remains product-neutral where practical so future implementations can map the same lifecycle, evidence contracts, human gates, and evaluation model to other execution products.

See `docs/architecture/scope-and-package-strategy.md`.

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
6. **Native capability first.**

> **IBM Bob supplies modernization capabilities. Agentic Strangler supplies modernization discipline.**

## Current framework playbooks

### UNDERSTAND

- `playbooks/discovery/`
- `playbooks/dependency-analysis/`
- `playbooks/rule-extraction/`
- `playbooks/known-unknowns/`

### DECIDE

- `playbooks/modernization-decision/`

### PLAN

- `playbooks/implementation-plan/`

PLAN converts an approved human disposition into sequenced, reversible change slices with evidence requirements, unknown-resolution gates, rollback/abort conditions, and a second human gate. PLAN does not authorize source modification.

## IBM Bob PP4Z mapping

See:

- `docs/architecture/native-capability-first.md`
- `docs/architecture/scope-and-package-strategy.md`
- `integrations/ibm-bob/capability-mapping.yaml`
- `integrations/ibm-bob/VERIFIED-CAPABILITIES.md`

For PLAN, the framework maps to PP4Z native implementation planning where available and adds the evidence/rollback/human-approval contract around that capability.

## AtlasPay experiment progression

- UNDERSTAND: `integrations/ibm-bob/understand/atlaspay-experiment-001.md`
- DECIDE: `integrations/ibm-bob/decide/atlaspay-experiment-002.md`
- PLAN: `integrations/ibm-bob/plan/atlaspay-experiment-003.md`

Run 001 established the PP4Z workspace-mode UNDERSTAND baseline. AtlasPay is now a regression/teaching estate after answer-key exposure; AWS CardDemo remains the independent holdout.

## Reference estates

### AtlasPay

`examples/atlaspay/`

Canonical synthetic teaching and regression estate.

### AWS CardDemo

`benchmarks/aws-carddemo/`

External holdout / stress-test estate. Upstream source remains external; this repository carries a pinned adapter rather than repackaging it.

## IBM relationship

IBM, IBM Z, IBM Bob, CICS, Db2 and related names may be trademarks of IBM. This is an independent companion framework and does not imply IBM endorsement, sponsorship, certification, or approval.

## License

Apache License 2.0. See `LICENSE`.
