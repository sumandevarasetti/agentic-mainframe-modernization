# Agentic Mainframe Modernization Framework

**Version:** 0.3.7
**Status:** Z-focused PP4Z framework through PROVE foundation
**Companion project:** *Project Bob — Accelerating Mainframe Modernization with Agentic AI*

> **Read it in the book. Run it in the repo.**

## Core lifecycle

**UNDERSTAND → DECIDE → PLAN → TRANSFORM → PROVE → SHIFT → LEARN**

Core rules:

1. **No Evidence, No Progression.**
2. **Agents perform work. Humans retain authority.**
3. **Agent autonomy decreases as irreversibility increases.**
4. **Native capability first.**
5. **No deployment from TRANSFORM.**

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

## IBM relationship

IBM, IBM Z, IBM Bob, CICS, Db2 and related names may be trademarks of IBM. This is an independent companion framework and does not imply IBM endorsement, sponsorship, certification, or approval.

## License

Apache License 2.0. See `LICENSE`.
