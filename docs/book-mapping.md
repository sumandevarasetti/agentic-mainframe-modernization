# Book-to-Repository Mapping

**Repository version:** v0.3.10
**Reference tag:** v0.3.10
**Book project:** *Project Bob — Accelerating Mainframe Modernization with Agentic AI*
**Framework:** Agentic Mainframe Modernization Framework

This file maps book concepts to current logical repository paths. Book prose may cite logical paths for readability; reproduction must be pinned to the v0.3.10 reference tag. Evaluator ground truth is not listed as a reader or book asset.

---

## PART I — THE MODERNIZATION PROBLEM CHANGED

### Chapter 1 — The Bottleneck Moved

| Book concept | Repository path |
|---|---|
| Framework lifecycle overview | `docs/agentic-mainframe-modernization.md` |
| Core rules | `docs/agentic-mainframe-modernization.md` |
| Human authority model | `governance/autonomy-policy.yaml` |
| AtlasPay estate overview | `examples/atlaspay/README.md` |
| Canonical orchestration source | `examples/atlaspay/src/cobol/TRNLIM01.cbl` |
| Risk/limit calculation source | `examples/atlaspay/src/cobol/LIMUTIL.cbl` |
| Active characterization suite | `examples/atlaspay/tests/golden-master/cases.yaml` |
| Historical characterization artifact (HISTORICAL / PROVENANCE ONLY — NOT CURRENT SOURCE OF TRUTH) | `examples/atlaspay/archive/v0.1/tests/golden-master-cases.yaml` |
| Frozen Run 001 evidence | `evidence/atlaspay/runs/run-001-understand/` |
| Run 001 provenance note | `evidence/atlaspay/runs/run-001-understand/PROVENANCE-NOTE.md` |
| KU-13 human authority evidence | `evidence/atlaspay/runs/run-004-transform/00-ku13-authority-decision.md` |
| KU-13 scope clarification | `evidence/atlaspay/runs/run-004-transform/KU13-SCOPE-NOTE.md` |

### Chapter 2 — From AI Coding to Agentic Modernization

| Book concept | Repository path |
|---|---|
| Framework definition | `docs/agentic-mainframe-modernization.md` |
| Automated rewrite vs. agentic modernization comparison | `docs/agentic-mainframe-modernization.md` |
| Native Capability First design rule | `docs/architecture/native-capability-first.md` |

### Chapter 3 — The Agentic Mainframe Modernization Framework

| Book concept | Repository path |
|---|---|
| Canonical framework definition | `docs/agentic-mainframe-modernization.md` |
| Book reference baseline | `docs/book/book-reference-baseline.md` |
| Book baseline YAML | `docs/book/book-baseline.yaml` |
| Portable full lifecycle workflow | `workflows/full-agentic-modernization/` |
| Human approval gates | `governance/human-gates.yaml` |
| Autonomy policy | `governance/autonomy-policy.yaml` |
| Evidence schema | `evidence/schemas/modernization-evidence.schema.json` |

### Chapter 4 — AtlasPay: A Synthetic Estate Built to Be Challenged

| Book concept | Repository path |
|---|---|
| AtlasPay estate overview | `examples/atlaspay/README.md` |
| AtlasPay source root | `examples/atlaspay/src/` |
| AtlasPay COBOL programs | `examples/atlaspay/src/cobol/` |
| AtlasPay governance overlay | `examples/atlaspay/AGENTS.framework.md` |
| Active characterization suite | `examples/atlaspay/tests/golden-master/cases.yaml` |
| AtlasPay architecture docs | `examples/atlaspay/architecture/` |
| AtlasPay DB2 schemas | `examples/atlaspay/db2/` |
| AtlasPay VSAM definitions | `examples/atlaspay/vsam/` |
| AtlasPay MQ contracts | `examples/atlaspay/mq/` |
| AtlasPay CICS metadata | `examples/atlaspay/cics/` |
| AtlasPay JCL | `examples/atlaspay/jcl/` |
| AtlasPay intentionally incomplete docs | `examples/atlaspay/docs/` |

---

## PART II — THE LIFECYCLE

### Chapter 5 — UNDERSTAND: Recover Behavior Before You Change It

| Book concept | Repository path |
|---|---|
| IBM Bob verified capability dossier | `integrations/ibm-bob/VERIFIED-CAPABILITIES.md` |
| PP4Z capability mapping | `integrations/ibm-bob/capability-mapping.yaml` |
| PP4Z AtlasPay Experiment 001 runbook | `integrations/ibm-bob/understand/atlaspay-experiment-001.md` |
| Isolated workspace preparation | `integrations/ibm-bob/understand/prepare-atlaspay-run.sh` |
| Discovery playbook | `playbooks/discovery/` |
| Dependency-analysis playbook | `playbooks/dependency-analysis/` |
| Rule-extraction playbook | `playbooks/rule-extraction/` |
| Known-unknowns playbook | `playbooks/known-unknowns/` |
| Capability discovery prompt | `prompts/understanding/capability-discovery.md` |
| Change-impact prompt | `prompts/impact-analysis/change-impact.md` |
| Business-rule prompt | `prompts/business-rules/extract-business-rules.md` |
| Known-unknown prompt | `prompts/understanding/known-unknowns.md` |
| SME question prompt | `prompts/understanding/sme-questions.md` |
| Understanding Agent contract | `agents/understanding-agent/` |
| Run 001 frozen evidence | `evidence/atlaspay/runs/run-001-understand/` |

### Chapter 6 — DECIDE: Modernization Is a Choice, Not a Translation

| Book concept | Repository path |
|---|---|
| DECIDE playbook | `playbooks/modernization-decision/` |
| PP4Z AtlasPay Experiment 002 runbook | `integrations/ibm-bob/decide/atlaspay-experiment-002.md` |
| Run 002 frozen evidence | `evidence/atlaspay/runs/run-002-decide/` |

### Chapter 7 — PLAN: Turn a Decision into a Reversible Sequence

| Book concept | Repository path |
|---|---|
| PLAN playbook | `playbooks/implementation-plan/` |
| PP4Z AtlasPay Experiment 003 runbook | `integrations/ibm-bob/plan/atlaspay-experiment-003.md` |
| Run 003 frozen evidence | `evidence/atlaspay/runs/run-003-plan/` |

### Chapter 8 — TRANSFORM: Change Only What Was Authorized

| Book concept | Repository path |
|---|---|
| TRANSFORM playbook | `playbooks/controlled-transform/` |
| PP4Z AtlasPay Experiment 004 runbook | `integrations/ibm-bob/transform/atlaspay-experiment-004.md` |
| Run 004 frozen evidence | `evidence/atlaspay/runs/run-004-transform/` |
| Run 004 pre-change source | `evidence/atlaspay/runs/run-004-transform/source/pre/` |
| Run 004 post-change source | `evidence/atlaspay/runs/run-004-transform/source/post/` |

### Chapter 9 — PROVE: Make the Claim No Larger Than the Evidence

| Book concept | Repository path |
|---|---|
| PROVE playbook | `playbooks/proof-package/` |
| PP4Z AtlasPay Experiment 005 runbook | `integrations/ibm-bob/prove/atlaspay-experiment-005.md` |
| Run 005 frozen evidence | `evidence/atlaspay/runs/run-005-prove/` |

### Chapter 10 — When the AI Overclaims: Hardening the Proof Layer

| Book concept | Repository path |
|---|---|
| PP4Z AtlasPay Experiment 006 runbook | `integrations/ibm-bob/prove/atlaspay-experiment-006.md` |
| Run 006 frozen evidence (full sequence) | `evidence/atlaspay/runs/run-006-prove-hardening/` |
| Run 006 initial raw proof | `evidence/atlaspay/runs/run-006-prove-hardening/01-modernization-proof-package-raw.md` |
| Run 006 external evaluation | `evidence/atlaspay/runs/run-006-prove-hardening/02-external-evaluation.md` |
| Run 006 corrective regression manifest | `evidence/atlaspay/runs/run-006-prove-hardening/03-corrective-regression-manifest.md` |
| Run 006 human release gate | `evidence/atlaspay/runs/run-006-prove-hardening/06-human-v0.3.8-release-gate.md` |

### Chapter 11 — SHIFT: Traffic Must Be Earned

| Book concept | Repository path |
|---|---|
| SHIFT stage definition | `docs/agentic-mainframe-modernization.md` |
| Full lifecycle workflow | `workflows/full-agentic-modernization/stages/06-shift.yaml` |
| Human gates (SHIFT authorization) | `governance/human-gates.yaml` |

*Note: Production SHIFT has not been exercised in the reference progression. The SHIFT stage is defined but not authorized at v0.3.9.*

### Chapter 12 — LEARN: Turn Runtime Truth into Modernization Knowledge

| Book concept | Repository path |
|---|---|
| LEARN stage definition | `docs/agentic-mainframe-modernization.md` |
| Full lifecycle workflow | `workflows/full-agentic-modernization/stages/07-learn.yaml` |

*Note: LEARN has not been exercised in the reference progression at v0.3.9.*

---

## PART III — BUILDING WITH IBM BOB

### Chapter 13 — Native Capability First

| Book concept | Repository path |
|---|---|
| Native Capability First design rule | `docs/architecture/native-capability-first.md` |
| IBM Bob verified capabilities | `integrations/ibm-bob/VERIFIED-CAPABILITIES.md` |
| PP4Z capability mapping | `integrations/ibm-bob/capability-mapping.yaml` |

### Chapter 14 — Evidence Contracts, Prompts, Playbooks, and Human Gates

| Book concept | Repository path |
|---|---|
| Evidence schemas | `evidence/schemas/` |
| Evidence checklists | `evidence/checklists/` |
| Evidence templates | `evidence/templates/` |
| All UNDERSTAND playbooks | `playbooks/discovery/`, `playbooks/dependency-analysis/`, `playbooks/rule-extraction/`, `playbooks/known-unknowns/` |
| DECIDE playbook | `playbooks/modernization-decision/` |
| PLAN playbook | `playbooks/implementation-plan/` |
| TRANSFORM playbook | `playbooks/controlled-transform/` |
| PROVE playbook | `playbooks/proof-package/` |
| Human gates | `governance/human-gates.yaml` |
| Screenshot policy | `docs/screenshot-policy.md` |

### Chapter 15 — Why "NOT READY" Is Sometimes the Best Result

| Book concept | Repository path |
|---|---|
| Known-unknowns playbook | `playbooks/known-unknowns/` |
| PROVE failure modes | `docs/agentic-mainframe-modernization.md` |
| Run 006 initial failure evidence | `evidence/atlaspay/runs/run-006-prove-hardening/01-modernization-proof-package-raw.md` |
| Run 006 external evaluation | `evidence/atlaspay/runs/run-006-prove-hardening/02-external-evaluation.md` |

---

## PART IV — ENTERPRISE ADOPTION

### Chapter 16 — Governance Without Killing the Speed

| Book concept | Repository path |
|---|---|
| Autonomy policy | `governance/autonomy-policy.yaml` |
| Human gates | `governance/human-gates.yaml` |
| Framework lifecycle | `workflows/full-agentic-modernization/` |

### Chapter 17 — Scaling from One Slice to a Modernization Program

| Book concept | Repository path |
|---|---|
| Full lifecycle workflow | `workflows/full-agentic-modernization/` |
| AtlasPay experiment progression | `integrations/ibm-bob/` |
| Evidence runs index | `evidence/atlaspay/runs/README.md` |

### Chapter 18 — The Future of Mainframe Modernization

| Book concept | Repository path |
|---|---|
| Framework definition | `docs/agentic-mainframe-modernization.md` |
| Book reference baseline | `docs/book/book-reference-baseline.md` |

---

## External benchmark

AWS CardDemo remains an independent external stress-test estate under `benchmarks/aws-carddemo/`. It is used after PP4Z/framework execution stabilizes to test external validity.

---

## Screenshot and citation guidance

- All book citations must be pinned to tag `v0.3.9`.
- Evaluator ground truth (`evals/atlaspay/ground-truth.yaml`) is excluded from all reader/book citations.
- Historical archive material under `examples/atlaspay/archive/v0.1/` is not suitable for book-facing screenshots.
- Evidence under `evidence/atlaspay/runs/` is suitable for citation per the README in each run directory.
- See `docs/screenshot-policy.md` for screenshot requirements.
