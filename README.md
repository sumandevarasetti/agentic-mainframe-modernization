# Agentic Mainframe Modernization Framework

**Version:** 0.3.4  
**Status:** Z-focused PP4Z framework with validated AtlasPay UNDERSTAND baseline and DECIDE starter  
**Companion project:** *Project Bob — Accelerating Mainframe Modernization with Agentic AI*

> **Read it in the book. Run it in the repo.**

This repository is the open companion implementation for *Project Bob*. It turns the book's modernization methodology into inspectable, reusable assets: lifecycle definitions, human approval gates, evidence models, synthetic mainframe estates, framework playbooks, supplemental prompts, evaluations, and verified product mappings.

## Scope

**Project Bob is Z-focused in implementation, portable in methodology.**

The current book, reference implementation, experiments, and evidence are intentionally centered on **IBM Z** and **IBM Bob Premium Package for Z (PP4Z)**. AtlasPay remains the canonical synthetic teaching estate.

IBM Bob also has Premium Packages for other modernization domains, including IBM i and Java modernization. Those packages are acknowledged, but they are **out of scope for the current implementation**. This repository does not currently claim IBM i- or Java-specific playbooks, mappings, experiments, or benchmark results.

The framework core remains product-neutral where practical so a future implementation could map the same lifecycle, evidence contracts, human gates, and evaluation model to other execution products without changing the methodology.

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
6. **Native capability first.** If the selected platform already provides a verified capability, the framework composes and evaluates it rather than rebuilding it.

## IBM Bob Premium Package for Z alignment

IBM Bob Premium Package for Z (PP4Z) is the primary IBM Z reference implementation for this project.

The Agentic Strangler Framework does **not** attempt to recreate PP4Z product capabilities. Instead, the framework defines:

- which capability should run at each modernization stage;
- what evidence it must produce;
- what uncertainty must remain explicit;
- which human decisions are required;
- how outputs are evaluated;
- how stages connect into a full modernization lifecycle.

> **IBM Bob supplies modernization capabilities. Agentic Strangler supplies modernization discipline.**

See:

- `docs/architecture/native-capability-first.md`
- `docs/architecture/scope-and-package-strategy.md`
- `integrations/ibm-bob/capability-mapping.yaml`
- `integrations/ibm-bob/VERIFIED-CAPABILITIES.md`

## Framework playbooks, not duplicate Bob Skills

Framework playbooks are vendor-neutral execution/evidence contracts. They are not IBM Bob Skills and are not claimed to use Bob-native extension syntax.

Current playbooks:

### UNDERSTAND

- `playbooks/discovery/`
- `playbooks/dependency-analysis/`
- `playbooks/rule-extraction/`
- `playbooks/known-unknowns/`

### DECIDE

- `playbooks/modernization-decision/`

Supplemental prompts remain under `prompts/`. They should close evidence gaps or normalize outputs after native capabilities are used, not replace verified PP4Z functionality.

## AtlasPay UNDERSTAND validation

Run 001 evaluated PP4Z in **workspace mode without Z Understand** against AtlasPay's hidden synthetic ground truth.

The formal report is:

`evals/atlaspay/runs/run-001/evaluation.md`

Key findings:

- canonical dependency recall: 21/21;
- canonical business-rule recall: 9/9;
- planted cross-artifact impact relationships: 4/4;
- canonical evidence traceability: 30/30;
- principal weakness: broader evidence-boundary known-unknown coverage.

v0.3.4 responds by adding a dedicated Known Unknowns playbook and strengthening the portable uncertainty prompt.

These results are limited to the synthetic AtlasPay workspace. They are not evidence of enterprise-wide estate coverage and should not be generalized to Z Understand-backed analysis.

Detailed procedure: `integrations/ibm-bob/understand/atlaspay-experiment-001.md`.

## DECIDE starter

AtlasPay now continues into DECIDE as a methodology/regression exercise:

`integrations/ibm-bob/decide/atlaspay-experiment-002.md`

The DECIDE stage compares **KEEP → REFACTOR → EXPOSE → EXTRACT → TRANSFORM → REPLATFORM → RETIRE** using frozen evidence, carries unresolved unknowns forward, and requires a named human decision owner.

## Reference estates

### AtlasPay — canonical teaching + regression estate

`examples/atlaspay/`

AtlasPay has known ground truth and remains the canonical teaching/reference estate. Because Run 001 has now been scored against the answer key, future AtlasPay runs are **regression tests**, not clean blind benchmarks.

### AWS CardDemo — external holdout / stress-test estate

`benchmarks/aws-carddemo/`

Use CardDemo as the next independent validation estate. CardDemo remains upstream; this repository provides a pinned benchmark adapter rather than repackaging AWS source.

## IBM relationship

IBM, IBM Z, IBM Bob, CICS, Db2 and related names may be trademarks of IBM. This is an independent companion framework and does not imply IBM endorsement, sponsorship, certification, or approval.

## License

Apache License 2.0. See `LICENSE`.
