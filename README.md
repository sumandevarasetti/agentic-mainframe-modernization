# Agentic Mainframe Modernization Framework

**Version:** 0.1.0  
**Status:** Initial public framework starter pack  
**Companion project:** *Project Bob — Accelerating Mainframe Modernization with Agentic AI*

> **Read it in the book. Run it in the repo.**

This repository is the open companion implementation for *Project Bob*. It turns the book's modernization methodology into inspectable, reusable artifacts: lifecycle definitions, human approval gates, workflow skeletons, evidence templates, synthetic examples, and—over time—product-specific prompts, skills, agents, and workflows.

## Core idea

The framework combines the architectural lifecycle established in *Project Strangler*:

**Observe → Encapsulate → Extract → Redirect → Retire**

with the Agentic Strangler execution loop introduced in *Project Bob*:

**UNDERSTAND → DECIDE → PLAN → TRANSFORM → PROVE → SHIFT → LEARN**

The operating rules are:

1. **No Evidence, No Progression.**
2. **Agents perform work. Humans retain authority.**
3. **Agent autonomy should generally decrease as irreversibility increases.**
4. **Modernization is decision-first, not generation-first.**
5. **KEEP is a valid modernization decision.**

## What is in v0.1.0

- [`docs/agentic-strangler.md`](docs/agentic-strangler.md) — canonical framework definition
- [`governance/human-gates.yaml`](governance/human-gates.yaml) — human authority policy
- [`workflows/full-agentic-strangler/`](workflows/full-agentic-strangler/) — portable seven-stage workflow skeleton
- [`examples/atlaspay/modernization/chapter-03/`](examples/atlaspay/modernization/chapter-03/) — synthetic end-to-end example

It also includes scaffolding for future prompts, skills, agents, evidence schemas, evaluations, and IBM Bob integrations.

## Portable methodology vs. IBM Bob implementation

The repository intentionally separates two layers.

### Layer 1 — Portable methodology

Product-neutral artifacts: Agentic Strangler lifecycle, stage contracts, decisioning, evidence, human gates, AtlasPay, and evaluations.

### Layer 2 — IBM Bob reference implementation

Product-specific assets will be added only after syntax, packaging, and behavior are verified against current IBM documentation and authorized product access.

**This starter pack does not invent IBM Bob-native syntax.**

## AtlasPay

AtlasPay is a fully synthetic card/payment-processing application used throughout *Project Bob*. No real bank source code, customer data, production architecture, or proprietary implementation detail is included.

## Start here

1. Read [`docs/agentic-strangler.md`](docs/agentic-strangler.md).
2. Review [`governance/human-gates.yaml`](governance/human-gates.yaml).
3. Inspect [`workflows/full-agentic-strangler/workflow.yaml`](workflows/full-agentic-strangler/workflow.yaml).
4. Walk through [`examples/atlaspay/modernization/chapter-03/`](examples/atlaspay/modernization/chapter-03/).
5. See [`docs/book-mapping.md`](docs/book-mapping.md).

## IBM relationship

IBM, IBM Z, IBM Bob, CICS, Db2 and related names may be trademarks of IBM.

This repository is an independent companion framework. It does **not** imply IBM endorsement, sponsorship, certification, or approval unless explicitly stated elsewhere.

## License

Apache License 2.0. See [`LICENSE`](LICENSE).
