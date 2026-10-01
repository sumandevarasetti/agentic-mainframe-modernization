# Agentic Mainframe Modernization Framework

**Version:** 0.3.9
**Status:** Book-reference baseline through PROVE
**Companion project:** *Project Bob — Accelerating Mainframe Modernization with Agentic AI*

> **Read it in the book. Run it in the repo.**

## Core lifecycle

**UNDERSTAND → DECIDE → PLAN → TRANSFORM → PROVE → SHIFT → LEARN**

Core rules:

1. **No Evidence, No Progression.**
2. **Agents perform work. Humans retain authority.**
3. **Agent autonomy decreases as irreversibility increases.**
4. **Native Capability First.**
5. **No deployment from TRANSFORM.**
6. **A plausible conclusion without sufficient evidence is not proof.**

## Book reference baseline

See `docs/book/book-reference-baseline.md` for canonical anchors:

- Canonical estate: AtlasPay
- Canonical capability: Dynamic Transaction Limit
- Canonical source root: `examples/atlaspay/src/`
- Canonical disposition: REFACTOR — APPROVED WITH CONDITIONS
- Validated through stage: PROVE
- Framework: Agentic Mainframe Modernization Framework

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

### TRANSFORM
- `playbooks/controlled-transform/`

TRANSFORM executes one approved PLAN slice at a time. Every source change must be traceable to the human-approved decision and plan, respect resolution/containment gates, capture a diff, and preserve rollback evidence. Runtime behavior is not considered verified unless executed in an authorized runtime.

### PROVE
- `playbooks/proof-package/`

PROVE is read-only. It classifies what the available evidence actually establishes, traces differences to authorization, exposes unsupported or unexplained changes, and keeps static verification separate from runtime verification.

v0.3.8 hardens PROVE around claim provenance, baseline-aware historical change claims, caller/callee evidence boundaries, exact COBOL record-layout evidence, known-unknown consistency, artifact integrity, evidence-proportional validation language, explicit PROVE-to-SHIFT authorization, and artifact-persistence metadata. Experiment 006 completed with one bounded corrective iteration and passed release validation with documented evidence limitations. Runtime validation remains unavailable, and v0.3.8 does not authorize SHIFT, deployment, or production change.

## IBM Bob PP4Z mapping

See:

- `docs/architecture/native-capability-first.md`
- `integrations/ibm-bob/capability-mapping.yaml`
- `integrations/ibm-bob/VERIFIED-CAPABILITIES.md`

## AtlasPay experiment progression

- UNDERSTAND: `integrations/ibm-bob/understand/atlaspay-experiment-001.md`
- DECIDE: `integrations/ibm-bob/decide/atlaspay-experiment-002.md`
- PLAN: `integrations/ibm-bob/plan/atlaspay-experiment-003.md`
- TRANSFORM: `integrations/ibm-bob/transform/atlaspay-experiment-004.md`
- PROVE: `integrations/ibm-bob/prove/atlaspay-experiment-005.md`
- PROVE hardening validation — v0.3.8, `COMPLETED_WITH_CORRECTIVE_ITERATION`: `integrations/ibm-bob/prove/atlaspay-experiment-006.md`

AtlasPay is a synthetic teaching/regression estate. AWS CardDemo remains the independent holdout.

## Published evidence runs

Frozen evidence from AtlasPay Runs 001–006 is published under `evidence/atlaspay/runs/`. Each run directory contains a README with artifact inventory, SHA-256 hashes, byte-identical confirmation, and book-citation/screenshot suitability.

## Version history

- **v0.3.9** — Book Reference Baseline & Repository Hygiene: terminology cleanup, canonical AtlasPay source-root clarification, v0.1 archive, isolated-workspace hardening, book mapping refresh, frozen evidence publication, metadata/version alignment.
- **v0.3.8** — PROVE Evidence-Precision Hardening: hardened claim provenance, baseline-aware historical change claims, caller/callee evidence boundaries, evidence-proportional validation language, PROVE-to-SHIFT separation. AtlasPay Experiment 006 completed with one bounded corrective iteration; `PASS_WITH_DOCUMENTED_EVIDENCE_LIMITATIONS`.
- **v0.3.7** — PROVE Stage Foundation.
- **v0.3.6** — TRANSFORM Stage Foundation.
- **v0.3.5** — PLAN Stage Foundation.

## IBM relationship

IBM, IBM Z, IBM Bob, CICS, Db2 and related names may be trademarks of IBM. This is an independent companion framework and does not imply IBM endorsement, sponsorship, certification, or approval.

## License

Apache License 2.0. See `LICENSE`.
