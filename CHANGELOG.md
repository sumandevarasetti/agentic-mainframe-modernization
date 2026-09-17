# Changelog

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
