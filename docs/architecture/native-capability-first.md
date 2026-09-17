# Native Capability First

**Framework rule:** When a target product already provides a verified capability, the Agentic Strangler Framework should compose, govern, evaluate, or extend that capability rather than rebuild it.

## Why this rule exists

Agentic Mainframe Modernization is a methodology layer, not an alternative mainframe-analysis product. IBM Bob Premium Package for Z already provides purpose-built IBM Z modes, workflows, skills and tools, including Z Understand-backed analysis. Recreating those functions with generic prompts would reduce fidelity and blur the boundary between framework and product.

## Three layers

### 1. Agentic Strangler Framework

Defines:

- modernization stages;
- evidence contracts;
- human authority gates;
- decision discipline;
- evaluation metrics;
- progression criteria;
- portability across execution products.

### 2. Native execution product

For the IBM Z reference implementation, this is IBM Bob Premium Package for Z and its verified native capabilities, including Z Understand-backed analysis, Z Architect/Z Code modes, workflows, skills, tools, commands, data dictionary and repository instructions.

### 3. Supplemental framework assets

Playbooks and prompts in this repository provide:

- standardized evidence expectations;
- sequencing guidance;
- missing-evidence checks;
- cross-product portability;
- repeatable evaluation.

They should not duplicate a native product capability merely because it can also be described as a prompt.

## Selection rule

For each framework task:

1. identify a verified native product capability;
2. use it when it satisfies the task;
3. adapt its output into the framework evidence contract;
4. invoke supplemental prompts/playbooks only for evidence gaps or portability;
5. record the product capability and observed output;
6. preserve human authority at the required gate.

## Example: UNDERSTAND

Instead of implementing a separate dependency-analysis engine:

- use PP4Z/Z Understand and native impact analysis for dependency assessment;
- use PP4Z data-dictionary and documentation/explanation capabilities for semantic context;
- apply the framework Dependency Analysis Playbook to define expected evidence and evaluation;
- measure the result against AtlasPay ground truth;
- escalate unresolved meaning to human SMEs.

## Product independence

Native Capability First does not make the framework IBM-only. The methodology remains portable. Another product can implement the same playbook contract using its own native capabilities.
