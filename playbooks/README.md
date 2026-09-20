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

If PP4Z already provides impact analysis or implementation planning, the framework specifies the evidence contract around that native capability rather than creating a competing engine.

## Current UNDERSTAND playbooks

- `discovery/`
- `dependency-analysis/`
- `rule-extraction/`
- `known-unknowns/`

## Current DECIDE playbooks

- `modernization-decision/`

## Current PLAN playbooks

- `implementation-plan/`

The PLAN playbook converts an approved disposition into bounded, reversible change slices with evidence, rollback, unknown-resolution gates, and a human plan gate. It does not modify application source.

See `integrations/ibm-bob/capability-mapping.yaml` for the IBM Bob mapping.
