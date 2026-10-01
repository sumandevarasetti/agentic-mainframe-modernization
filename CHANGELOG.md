# Changelog

## 0.3.9 — Book Reference Baseline & Repository Hygiene

- No framework semantic expansion; lifecycle, evidence gates, and human authority unchanged
- Terminology cleanup: replaced legacy framework branding with "Agentic Mainframe Modernization Framework" across all current active material
- Renamed `docs/agentic-strangler.md` to `docs/agentic-mainframe-modernization.md`; updated title, rules, and links
- Renamed `workflows/full-agentic-strangler/` to `workflows/full-agentic-modernization/`; updated workflow name and README
- Canonical AtlasPay source root clarified: `examples/atlaspay/src/` is the current authoritative source
- Archived v0.1 fixtures to `examples/atlaspay/archive/v0.1/`: simplified COBOL, illustrative modernization walkthrough, older characterization file
- Created `examples/atlaspay/archive/v0.1/README.md` with provenance explanation and KU-13 story note
- Updated `examples/atlaspay/README.md`: canonical source roots explicit, neutral synthetic disclaimer, archive reference
- Updated `examples/atlaspay/AGENTS.framework.md`: current framework name and terminology; safety/evidence meaning unchanged
- Updated `governance/autonomy-policy.yaml`: rule uses canonical wording "decreases" (not "should generally decrease")
- Hardened isolated-workspace script (`integrations/ibm-bob/understand/prepare-atlaspay-run.sh`): explicit allowlist, prohibited-directory validation, no wholesale copy
- Created `docs/book/` directory with `book-reference-baseline.md` and `book-baseline.yaml`
- Rewrote `docs/book-mapping.md` to align with current 18-chapter book architecture; removed evaluator ground truth from reader assets
- Published frozen AtlasPay run evidence under `evidence/atlaspay/runs/` (Runs 001–006): byte-identical copies, SHA-256 verified, per-run READMEs
- Separate `source/pre/` and `source/post/` directories for Run 004 TRANSFORM source snapshots
- Run 006 initial Test A/C failure preserved; not rewritten into a success
- Version bumped to 0.3.9 in `VERSION`, `README.md`, `MANIFEST.json`, `docs/book/book-baseline.yaml`
- `MANIFEST.json`: updated key assets, separated `protected_evaluator_assets` field, removed evaluator ground truth from `key_assets`
- Screenshot policy and assets README updated to version-independent wording
- `integrations/ibm-bob/VERIFIED-CAPABILITIES.md`: updated metadata; capability statements carry re-check advisory
- Active repository legacy-term sweep: zero occurrences of old framework term in current book-facing material
- Synthetic AtlasPay disclaimer updated to neutral wording (no real employer name)

## 0.3.8 — PROVE Evidence-Precision Hardening

- Hardened PROVE claim provenance and evidence-boundary rules
- Added baseline requirements for historical no-change claims
- Added caller/callee semantic-boundary controls
- Added exact COBOL record-layout evidence requirements
- Added known-unknown consistency detection with `INTERNAL_STATUS_CONFLICT`
- Required complete available SHA-256 reporting for changed artifacts
- Added evidence-proportional static-validation vocabulary
- Separated PROVE completion from SHIFT authorization
- Separated artifact-persistence reliability from semantic proof
- Added AtlasPay Experiment 006 as an adversarial validation specification
- Executed AtlasPay Experiment 006; the initial full run identified failures in Test A and Test C while Tests B, D, E, F, G, and H passed
- Applied one bounded corrective iteration for package-wide historical provenance and logical-layout versus physical-byte evidence precision
- Revalidated Test A and Test C successfully against the corrected candidate
- Final release validation: `PASS_WITH_DOCUMENTED_EVIDENCE_LIMITATIONS`
- Runtime validation remains unavailable; no deployment, production change, or SHIFT progression is authorized by v0.3.8

## 0.3.7 — PROVE Stage Foundation

- Added `playbooks/proof-package/` for evidence-classified PROVE execution
- Added portable `prove-change.md` verification prompt
- Added AtlasPay PROVE Experiment 005
- Added explicit proof vocabulary: STATICALLY_VERIFIED, RUNTIME_VERIFIED,
  RUNTIME_UNAVAILABLE, NOT_VERIFIED, DIFFERENCE_EXPLAINED, and
  DIFFERENCE_UNEXPLAINED
- Required pre/post change traceability and authorization mapping
- Added unsupported-change and unexplained-difference detection
- Preserved unresolved known unknowns and containment gates through PROVE
- Made PROVE read-only: no source/test repair during evidence evaluation
- Prohibited proof by plausibility and runtime-equivalence claims without
  authorized execution evidence

## 0.3.6 — TRANSFORM Stage Foundation

- Added `playbooks/controlled-transform/` for one-slice-at-a-time source transformation
- Added controlled-refactor supplemental prompt
- Added AtlasPay TRANSFORM Experiment 004
- Enforced slice-specific source authorization and gate clearance
- Added explicit distinction between source-level transformation and runtime validation
- Required source diffs, rollback evidence, and honest runtime status
- Prohibited deployment and production authorization in TRANSFORM
- Established Slice 0 as characterization/KU-13 authority work before any source-changing slice

## 0.3.5 — PLAN Stage Foundation

- Added `playbooks/implementation-plan/` for evidence-bounded PLAN execution
- Added a portable implementation-planning prompt that keeps PLAN read-only
- Added AtlasPay PLAN Experiment 003 for the human-approved REFACTOR disposition
- Mapped PLAN to PP4Z native `implementation-planning` / `/implementation-planning`
- Required sequenced change slices, explicit out-of-scope boundaries, proof obligations, rollback, abort conditions, and known-unknown resolution gates
- Added a named Human Plan Approver gate before TRANSFORM
- Preserved the rule that no source modification is authorized during PLAN

## 0.3.4 — Run 001 Evaluation & Evidence-Boundary Refinement

- Added the formal AtlasPay UNDERSTAND Run 001 evaluation report and artifact manifest
- Recorded the PP4Z workspace-mode baseline: 21/21 canonical dependencies, 9/9 canonical rule families, 4/4 planted cross-artifact relationships, and 30/30 canonical claims with evidence traceability
- Recorded the main weakness: incomplete coverage of broad evidence-boundary known unknowns
- Added a dedicated `playbooks/known-unknowns/` evidence contract
- Added the first DECIDE playbook and AtlasPay DECIDE Experiment 002 runbook

## 0.3.2 — Z Scope Clarification

- Locked the current book and repository implementation scope to IBM Z and IBM Bob Premium Package for Z

## 0.3.1 — PP4Z Alignment

- Adopted **Native Capability First**
- Added formal Agentic Strangler ↔ IBM Bob Premium Package for Z capability mapping

## 0.3.0 — UNDERSTAND Pack

- Added UNDERSTAND prompt/playbook foundation

## 0.2.0 — Reference Estates & Benchmark Foundation

- Expanded AtlasPay synthetic reference estate and added CardDemo adapter

## 0.1.0 — Initial starter pack

- Added canonical Agentic Strangler framework definition
