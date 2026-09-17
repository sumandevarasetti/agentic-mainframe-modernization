# IBM Bob Premium Package for Z — Verified Capabilities

**Verification date:** 2026-09-16  
**Framework release:** v0.3.1  
**Status:** Source-backed capability dossier

This file records IBM Bob / Bob Premium Package for Z capabilities supported by current IBM documentation or public IBM announcements. Re-check the source documentation before publication or product-specific execution because capabilities and prerequisites can change.

## Primary sources

- Bob for Z overview: https://bob.ibm.com/docs/ide/premium-packages/bob-for-z/bob-for-z-index
- Bob for Z prerequisites: https://bob.ibm.com/docs/ide/premium-packages/bob-for-z/prerequisites
- IBM Bob 3.0.0 overview: https://www.ibm.com/docs/en/bobz/3.0.0?topic=overview-discover-whats-inside-bob-premium-package-z
- Commands: https://www.ibm.com/docs/en/bobz/3.0.0?topic=commands-using
- Skills: https://www.ibm.com/docs/en/bobz/3.0.0?topic=commands-using-skills
- Workflows/skills/tools/commands: https://www.ibm.com/docs/en/bobz/3.0.0?topic=z-using-workflows-skills-tools-commands
- IBM GA announcement: https://www.ibm.com/new/announcements/announcing-the-ibm-bob-premium-package-for-z
- IBM Bob blog — Bob meets the mainframe: https://bob.ibm.com/blog/bob-for-z-announcement/

## Native Capability First

PP4Z already provides Z-specific modes, workflows, skills, tools and commands. The framework should use those native capabilities when they satisfy a framework task, then adapt/evaluate their outputs against Agentic Strangler evidence contracts.

The framework must not describe a portable YAML playbook as a replacement "Bob Skill."

## Verified UNDERSTAND-relevant capabilities

### Z Understand-backed application analysis
IBM documents Z Understand as a static-analysis foundation for large mainframe estates and as a source of queryable, deterministic application metadata.

**Framework mapping:** UNDERSTAND

### Z Architect mode
IBM documents Z Architect mode for architecture/design activities including impact analysis, implementation planning, system analysis and technical documentation.

**Framework mapping:** UNDERSTAND / DECIDE / PLAN support

### Impact analysis
IBM documents `impact-analysis` as a built-in skill and `/impact-analysis` as a command for proposed changes across COBOL, PL/I, JCL, Assembler and REXX artifacts.

**Framework mapping:** primarily UNDERSTAND; its output may inform DECIDE

### Code explanation
IBM documents the `explain` skill and `/explain` command for multi-perspective source explanations.

**Framework mapping:** UNDERSTAND

### Data dictionary
IBM documents data-dictionary generation/management and local `DD.json`; prerequisites strongly recommend generating `DD.json` before Bob for Z workflows.

**Framework mapping:** UNDERSTAND semantic context

### Documentation and business-rule extraction
IBM documents program/application documentation workflows and business-rule extraction as part of its documentation/application-understanding capabilities.

**Framework mapping:** UNDERSTAND / LEARN

### AGENTS.md via /init
IBM documents `/init` as a command that analyzes the IBM Z codebase and generates `AGENTS.md`. Current prerequisites strongly recommend generating `AGENTS.md` with `/init`.

**Framework mapping:** cross-cutting repository governance/context

### Implementation planning
IBM documents `implementation-planning` as a native skill and `/implementation-planning` as a command in Z Architect mode.

**Framework mapping:** PLAN; do not rebuild as a generic framework planning engine

### Refactoring and transformation
IBM documents refactoring/service-extraction and end-to-end transformation workflows.

**Framework mapping:** TRANSFORM, with framework evidence/human gates applied around native execution

### Validation and coding standards
IBM documents validation in transformation workflows and integrations such as ZCodeScan/coding-standards capabilities.

**Framework mapping:** PROVE support; evidence sufficiency remains a framework/human decision

## Verified prerequisite guidance

Current Bob for Z prerequisites document:

- IBM Bob IDE 2.0.3 or later
- Z Open Editor 6.7.0 or later
- Zowe Explorer 3.5.1 or later
- mainframe source accessible in the workspace
- Z Understand integration configured — recommended
- `DD.json` generated — strongly recommended
- `AGENTS.md` generated with `/init` — strongly recommended

Re-check these values before relying on them.

## Portable artifact warning

Files under `playbooks/`, `agents/` and `prompts/` are framework artifacts unless explicitly marked otherwise. Their syntax is not presented as IBM Bob-native packaging.

## AtlasPay execution rule

For scored PP4Z experiments:

1. create a workspace containing AtlasPay but not evaluator ground truth;
2. configure native PP4Z/Z Understand context;
3. generate data dictionary context and run `/init`;
4. merge the framework governance overlay into generated `AGENTS.md`;
5. use native PP4Z analysis/documentation capabilities first;
6. use supplemental prompts only for evidence gaps;
7. freeze outputs before evaluation;
8. score outside the Bob workspace against the evaluator-only ground truth.
