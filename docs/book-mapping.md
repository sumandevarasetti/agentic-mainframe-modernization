# Book-to-Repository Mapping

**Repository version:** 0.3.1  
**Book project:** *Project Bob — Accelerating Mainframe Modernization with Agentic AI*

This file maps book concepts to stable logical repository paths. The book should reference logical paths rather than commit hashes.

## Chapter 3 — From Strangler to Agentic Strangler

| Book concept | Repository path |
|---|---|
| Agentic Strangler definition | `docs/agentic-strangler.md` |
| Human approval gates | `governance/human-gates.yaml` |
| Portable full lifecycle workflow | `workflows/full-agentic-strangler/` |
| AtlasPay Chapter 3 example | `examples/atlaspay/modernization/chapter-03/` |
| Evidence schema | `evidence/schemas/modernization-evidence.schema.json` |
| Native Capability First design rule | `docs/architecture/native-capability-first.md` |

## Chapter 5 — Understand: Building the Living Model of the Mainframe

| Book concept | Repository path |
|---|---|
| IBM Bob verified capability dossier | `integrations/ibm-bob/VERIFIED-CAPABILITIES.md` |
| PP4Z capability mapping | `integrations/ibm-bob/capability-mapping.yaml` |
| PP4Z AtlasPay Experiment 001 | `integrations/ibm-bob/understand/atlaspay-experiment-001.md` |
| Discovery playbook | `playbooks/discovery/` |
| Dependency-analysis playbook | `playbooks/dependency-analysis/` |
| Rule-extraction playbook | `playbooks/rule-extraction/` |
| Capability discovery supplemental prompt | `prompts/understanding/capability-discovery.md` |
| Change-impact supplemental prompt | `prompts/impact-analysis/change-impact.md` |
| Business-rule supplemental prompt | `prompts/business-rules/extract-business-rules.md` |
| Known-unknown prompt | `prompts/understanding/known-unknowns.md` |
| SME question prompt | `prompts/understanding/sme-questions.md` |
| Understanding Agent contract | `agents/understanding-agent/` |
| AtlasPay UNDERSTAND evidence runbook | `examples/atlaspay/modernization/understand/` |
| AtlasPay governance overlay | `examples/atlaspay/AGENTS.framework.md` |
| UNDERSTAND eval suite | `evals/understanding/` |
| AtlasPay evaluator ground truth | `evals/atlaspay/ground-truth.yaml` |

## External benchmark

AWS CardDemo remains an independent external stress-test estate under `benchmarks/aws-carddemo/`.

AtlasPay is used first because its synthetic ground truth is controlled and measurable. CardDemo is used after PP4Z/framework execution stabilizes to test external validity.
