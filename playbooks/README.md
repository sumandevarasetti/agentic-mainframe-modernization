# Framework Playbooks

Playbooks are **vendor-neutral execution and evidence contracts** for Agentic Strangler stages.

They are deliberately not called "skills" because IBM Bob Premium Package for Z uses **Skill** as a product-specific capability type.

## A playbook defines

- purpose and stage;
- required inputs;
- expected evidence outputs;
- permissions and prohibited actions;
- human validation requirements;
- evaluation criteria;
- preferred native product mappings.

## Native capability first

A playbook does not imply that the framework must implement the capability itself.

For IBM Z, the preferred approach is:

**Framework Playbook → verified PP4Z native capability → evidence adapter/evaluation**

If PP4Z already provides impact analysis, the Dependency Analysis Playbook specifies what evidence we need from that analysis; it does not create a competing impact-analysis engine.

## Current UNDERSTAND playbooks

- `discovery/`
- `dependency-analysis/`
- `rule-extraction/`

See `integrations/ibm-bob/capability-mapping.yaml` for the IBM Bob mapping.
