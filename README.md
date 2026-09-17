# Agentic Mainframe Modernization Framework

**Version:** 0.3.0  
**Status:** UNDERSTAND Pack  
**Companion project:** *Project Bob — Accelerating Mainframe Modernization with Agentic AI*

> **Read it in the book. Run it in the repo.**

This repository is the open companion implementation for *Project Bob*. It turns the book's modernization methodology into inspectable, reusable assets: lifecycle definitions, human approval gates, evidence models, synthetic mainframe estates, prompts, skills, agents, evaluations, and verified product integrations.

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

## v0.3.0 — UNDERSTAND Pack

This release makes the first Agentic Strangler stage operational as a portable framework package.

### Prompts

- `prompts/understanding/capability-discovery.md`
- `prompts/impact-analysis/change-impact.md`
- `prompts/business-rules/extract-business-rules.md`
- `prompts/understanding/known-unknowns.md`
- `prompts/understanding/sme-questions.md`

### Skills

- `skills/discovery/`
- `skills/dependency-analysis/`
- `skills/rule-extraction/`

### Agent

- `agents/understanding-agent/`

### AtlasPay runbook

- `examples/atlaspay/modernization/understand/`

### Evaluation

- `evals/understanding/`
- canonical synthetic truth remains isolated in `evals/atlaspay/ground-truth.yaml`

### IBM Bob grounding

- `integrations/ibm-bob/VERIFIED-CAPABILITIES.md`

IBM Bob Premium Package for Z is the primary product implementation lens, but custom Markdown prompts and YAML manifests in this repository are **portable framework artifacts unless explicitly marked as verified Bob-native syntax**.

## Two reference estates

### AtlasPay — canonical teaching + evaluation estate

`examples/atlaspay/`

Use AtlasPay when known answers and repeatable evaluation are required. Do not expose `evals/atlaspay/ground-truth.yaml` to the model before an evaluation run.

### AWS CardDemo — external benchmark estate

`benchmarks/aws-carddemo/`

Use CardDemo after the UNDERSTAND pack performs acceptably against AtlasPay. CardDemo remains upstream; this repository provides a pinned fetch/benchmark adapter rather than repackaging AWS source.

## Recommended v0.3 workflow

1. Read `integrations/ibm-bob/VERIFIED-CAPABILITIES.md`.
2. Open the AtlasPay workspace and review `examples/atlaspay/AGENTS.md`.
3. Follow `examples/atlaspay/modernization/understand/README.md`.
4. Save model outputs outside the ground-truth directory.
5. Score the run with `evals/understanding/eval-config.yaml` and `scoring-rubric.md`.
6. Refine prompts/skills only after examining missed dependencies, unsupported claims, and evidence gaps.
7. Once AtlasPay is stable, repeat against AWS CardDemo.
8. In an authorized IBM Bob environment, capture observed outputs/screenshots using only synthetic or approved content.

## IBM relationship

IBM, IBM Z, IBM Bob, CICS, Db2 and related names may be trademarks of IBM. This is an independent companion framework and does not imply IBM endorsement, sponsorship, certification, or approval.

## License

Apache License 2.0. See `LICENSE`.
