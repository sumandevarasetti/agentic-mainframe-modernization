# Framework Playbooks

Playbooks are **vendor-neutral execution and evidence contracts** for Agentic Strangler stages.

## Native capability first

For IBM Z, the preferred approach is:

**Framework Playbook → verified PP4Z native capability → evidence adapter/evaluation**

## Current UNDERSTAND playbooks

- `discovery/`
- `dependency-analysis/`
- `rule-extraction/`
- `known-unknowns/`

## Current DECIDE playbooks

- `modernization-decision/`

## Current PLAN playbooks

- `implementation-plan/`

## Current TRANSFORM playbooks

- `controlled-transform/`

The TRANSFORM playbook authorizes one approved slice at a time, requires cleared/contained gates, captures source diffs and rollback evidence, and explicitly prohibits deployment or runtime-equivalence claims without runtime evidence.

See `integrations/ibm-bob/capability-mapping.yaml` for the IBM Bob mapping.
