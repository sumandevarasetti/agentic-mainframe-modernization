# Agentic Mainframe Modernization Framework

**Version:** 0.2.0  
**Status:** Reference-estate and benchmark foundation  
**Companion project:** *Project Bob — Accelerating Mainframe Modernization with Agentic AI*

> **Read it in the book. Run it in the repo.**

This repository is the open companion implementation for *Project Bob*. It turns the book's modernization methodology into inspectable, reusable artifacts: lifecycle definitions, human approval gates, workflows, evidence models, synthetic mainframe examples, evaluations, and product-specific integrations as they are verified.

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

## Two reference estates

### AtlasPay — canonical teaching + evaluation estate

`examples/atlaspay/`

AtlasPay is a fully synthetic card authorization/mainframe estate designed specifically for the Project Bob methodology. It now includes online COBOL, copybooks, CICS metadata, batch JCL, Db2, VSAM-style exceptions, MQ contracts, characterization tests, intentionally incomplete documentation, and a separate evaluation ground truth.

Use AtlasPay when we need known answers and repeatable evaluation.

### AWS CardDemo — external benchmark estate

`benchmarks/aws-carddemo/`

CardDemo remains in its official upstream repository. This project provides a fetch/pin adapter rather than repackaging AWS source. Use CardDemo to stress-test the same framework against an independently developed public mainframe application.

## v0.2.0 highlights

- AtlasPay Mainframe Reference Estate v0.1.0
- 15 synthetic COBOL programs
- 6 copybooks
- CICS, JCL, Db2, VSAM-style and MQ artifacts
- 12 Golden Master scenarios
- AtlasPay UNDERSTAND ground truth
- common evaluation metrics
- AWS CardDemo external benchmark adapter

## Start here

1. Read `docs/agentic-strangler.md`.
2. Review `governance/human-gates.yaml`.
3. Explore `examples/atlaspay/`.
4. Inspect `evals/atlaspay/ground-truth.yaml` — but do **not** feed it to the model being evaluated.
5. Fetch the external CardDemo benchmark with `benchmarks/aws-carddemo/fetch-carddemo.sh`.
6. Next milestone: build the v0.3 UNDERSTAND prompt/skill/agent pack and run it against AtlasPay first.

## IBM Bob

IBM Bob is the primary product implementation lens for the book, but the portable framework is kept separate from product-specific syntax. Bob-specific assets will be added under `integrations/ibm-bob/` only after they are verified against current IBM documentation and authorized product access.

## IBM relationship

IBM, IBM Z, IBM Bob, CICS, Db2 and related names may be trademarks of IBM. This is an independent companion framework and does not imply IBM endorsement, sponsorship, certification, or approval.

## License

Apache License 2.0. See `LICENSE`.
