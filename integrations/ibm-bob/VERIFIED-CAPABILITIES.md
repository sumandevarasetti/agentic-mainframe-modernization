# IBM Bob Premium Package for Z — Verified Capabilities

**Verification date:** 2026-09-16  
**Framework release:** v0.3.0 UNDERSTAND Pack  
**Status:** Source-backed capability dossier

This file records only IBM Bob / Bob Premium Package for Z capabilities supported by current IBM documentation or public IBM announcements. It exists to prevent the framework from silently inventing product behavior.

## Primary sources

- IBM announcement: https://www.ibm.com/new/announcements/announcing-the-ibm-bob-premium-package-for-z
- IBM Bob for Z overview: https://bob.ibm.com/docs/ide/premium-packages/bob-for-z/bob-for-z-index
- IBM Bob for Z prerequisites: https://bob.ibm.com/docs/ide/premium-packages/bob-for-z/prerequisites
- IBM Bob blog — Bob meets the mainframe: https://bob.ibm.com/blog/bob-for-z-announcement/

## Verified UNDERSTAND-relevant capabilities

### Z Understand-backed application analysis
IBM documents Z Understand as the static-analysis foundation beneath the Premium Package for Z. It builds a queryable representation of application estates and supports deterministic analysis rather than requiring the model to infer everything from source text alone.

**Framework mapping:** UNDERSTAND

### Impact analysis
IBM lists impact analysis as a built-in Bob skill for Z and positions Z Architect mode around impact analysis, dependency assessment, business-context discovery, and modernization planning.

**Framework mapping:** UNDERSTAND → DECIDE

### Code explanation
IBM lists code explanation as a built-in skill and documents workflows for explaining legacy code from multiple stakeholder perspectives.

**Framework mapping:** UNDERSTAND

### Business-rule/documentation support
IBM documents program/application documentation workflows and states that business rules can be extracted alongside documentation and modernization work.

**Framework mapping:** UNDERSTAND → LEARN

### Data dictionary
IBM documents data-dictionary generation with JSON-based metadata storage and strongly recommends generating `DD.json` before starting Bob for Z workflows.

**Framework mapping:** UNDERSTAND

### AGENTS.md repository guidance
IBM documents repository-level `AGENTS.md` rules for standards/governance and strongly recommends generating `AGENTS.md` through `/init` as part of project setup.

**Framework mapping:** cross-cutting governance

### Supported language / middleware context
IBM's Bob for Z documentation lists COBOL, PL/I, JCL, REXX, and HLASM, with middleware support for CICS, IMS, MQ, and Db2.

**Framework mapping:** UNDERSTAND / TRANSFORM

## Verified prerequisite guidance

IBM currently documents:

- IBM Bob IDE 2.0.3 or later
- Z Open Editor 6.7.0 or later
- Zowe Explorer 3.5.1 or later
- mainframe source accessible in the workspace
- Z Understand integration configured — recommended
- `DD.json` generated — strongly recommended
- `AGENTS.md` generated with `/init` — strongly recommended

Re-check IBM documentation before relying on version numbers because product requirements may change.

## Framework portability warning

The Markdown prompts, `skill.yaml` files, and `agent.yaml` file in v0.3.0 are **portable framework artifacts**. They are not claimed to be IBM Bob-native extension syntax.

Use them as:

1. copy/paste prompt patterns;
2. architecture/specification contracts;
3. inputs for future Bob-native packaging after supported extension formats are verified.

## AtlasPay execution guidance

For an authorized Bob for Z environment:

1. open the synthetic AtlasPay workspace;
2. configure Z Understand if available;
3. generate/review `DD.json` if supported in the environment;
4. run `/init` if appropriate and reconcile generated project guidance with the repository's curated `AGENTS.md` rather than silently discarding framework rules;
5. do not expose `evals/atlaspay/ground-truth.yaml` to the model being evaluated;
6. execute the UNDERSTAND runbook;
7. save outputs under an isolated run directory;
8. score outputs against ground truth only after the run is complete.

## Screenshot / book evidence rule

When Bob screenshots or observed outputs are added:

- use only synthetic or authorized data;
- record capture date and product context;
- distinguish observed Bob output from framework interpretation;
- link the screenshot to the relevant prompt/skill/eval artifact;
- do not imply IBM endorsement.
