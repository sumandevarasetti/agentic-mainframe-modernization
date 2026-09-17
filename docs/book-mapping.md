# Book-to-Repository Mapping

**Repository version:** 0.3.0  
**Book project:** *Project Bob — Accelerating Mainframe Modernization with Agentic AI*

This file maps book concepts to stable logical repository paths. The book should reference these logical paths rather than commit hashes.

## Chapter 3 — From Strangler to Agentic Strangler

| Book concept | Repository path |
|---|---|
| Agentic Strangler definition | `docs/agentic-strangler.md` |
| Human approval gates | `governance/human-gates.yaml` |
| Portable full lifecycle workflow | `workflows/full-agentic-strangler/` |
| AtlasPay Chapter 3 example | `examples/atlaspay/modernization/chapter-03/` |
| Evidence schema | `evidence/schemas/modernization-evidence.schema.json` |

## Chapter 5 — Understand: Building the Living Model of the Mainframe

| Book concept | Repository path |
|---|---|
| IBM Bob verified capability dossier | `integrations/ibm-bob/VERIFIED-CAPABILITIES.md` |
| Capability discovery prompt | `prompts/understanding/capability-discovery.md` |
| Change impact prompt | `prompts/impact-analysis/change-impact.md` |
| Business-rule extraction prompt | `prompts/business-rules/extract-business-rules.md` |
| Known-unknown prompt | `prompts/understanding/known-unknowns.md` |
| SME question prompt | `prompts/understanding/sme-questions.md` |
| Discovery skill contract | `skills/discovery/` |
| Dependency-analysis skill contract | `skills/dependency-analysis/` |
| Rule-extraction skill contract | `skills/rule-extraction/` |
| Understanding Agent contract | `agents/understanding-agent/` |
| AtlasPay UNDERSTAND runbook | `examples/atlaspay/modernization/understand/` |
| UNDERSTAND eval suite | `evals/understanding/` |
| AtlasPay evaluator ground truth | `evals/atlaspay/ground-truth.yaml` |

## External benchmark

AWS CardDemo remains an independent external stress-test estate under:

`benchmarks/aws-carddemo/`

AtlasPay is used first because its synthetic ground truth is controlled and measurable. CardDemo is used after prompt/skill stabilization to test external validity.
