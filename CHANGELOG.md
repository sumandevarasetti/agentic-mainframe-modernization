# Changelog

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
- Strengthened `prompts/understanding/known-unknowns.md` with mandatory sweeps for performance/scale, runtime/nonfunctional behavior, external policy/regulatory evidence, build/runtime environment, production state, and human intent
- Refined UNDERSTAND evaluation guidance so source-backed extra findings are not automatically treated as false positives
- Updated AtlasPay experiment guidance to make PP4Z workspace mode reproducible without requiring Z Understand
- Declared future AtlasPay runs regression-only after ground-truth exposure; reserved AWS CardDemo as the next independent holdout
- Added the first DECIDE playbook and AtlasPay DECIDE Experiment 002 runbook
- Preserved human authority: DECIDE requires a named human decision owner before progression to PLAN

## 0.3.2 — Z Scope Clarification

- Locked the current book and repository implementation scope to IBM Z and IBM Bob Premium Package for Z
- Added `docs/architecture/scope-and-package-strategy.md`
- Clarified that IBM i and Java modernization Premium Packages are acknowledged but out of scope for current playbooks, mappings, experiments, and benchmarks
- Preserved methodology portability without implying equivalent product mappings have been implemented or tested
- Added explicit guidance not to generalize PP4Z experiment results to other Premium Packages

## 0.3.1 — PP4Z Alignment

- Adopted **Native Capability First** as a framework design rule
- Reframed portable `skills/` as vendor-neutral `playbooks/` to avoid collision with IBM Bob Skill terminology
- Added formal Agentic Strangler ↔ IBM Bob Premium Package for Z capability mapping
- Added PP4Z-native-first AtlasPay UNDERSTAND experiment procedure
- Changed AtlasPay repository guidance from a prebuilt `AGENTS.md` to an `AGENTS.framework.md` overlay intended to be merged after Bob `/init`
- Clarified that PP4Z/Z Understand performs native application analysis while the framework defines evidence, evaluation, stage progression, and human authority
- Updated the Understanding Agent to orchestrate playbooks and verified native capabilities instead of implying duplicate product skills
- Marked portable prompts as supplemental evidence/orchestration prompts rather than replacements for PP4Z workflows

## 0.3.0 — UNDERSTAND Pack

- Added IBM Bob Premium Package for Z verified-capability dossier
- Added five evidence-oriented UNDERSTAND prompt patterns
- Added Discovery, Dependency Analysis, and Rule Extraction portable specifications
- Added Understanding Agent specification
- Added AtlasPay UNDERSTAND runbook
- Added quantitative evaluation configuration and scoring rubric
- Strengthened AtlasPay evaluation-isolation and evidence rules
- Kept custom prompts/agents explicitly portable; no unverified Bob-native syntax

## 0.2.0 — Reference Estates & Benchmark Foundation

- Expanded AtlasPay into a synthetic mainframe reference estate
- Added 15 COBOL programs, copybooks, JCL, Db2, VSAM-style data, MQ and CICS artifacts
- Added AtlasPay UNDERSTAND ground truth and common metrics
- Added AWS CardDemo external benchmark adapter pinned to a specific upstream commit

## 0.1.0 — Initial starter pack

- Added canonical Agentic Strangler framework definition
- Added portable seven-stage workflow skeleton
- Added human-gates policy
- Added initial AtlasPay Chapter 3 example
