# Run 001 — UNDERSTAND Evidence

**Lifecycle stage:** UNDERSTAND  
**Original local source path:** `.work/atlaspay-understand-001/runs/atlaspay/understand/run-001/`  
**Framework version:** v0.3.2 (executed); published under v0.3.9

---

## Artifact inventory

| File | Artifact role | Source SHA-256 | Published SHA-256 | Byte-identical | Sanitization | Book citation | Screenshot |
|---|---|---|---|---|---|---|---|
| `01-broad-analysis-raw.md` | Raw broad IBM Bob analysis | `da9aab10` | `da9aab10` | YES | None | YES | YES |
| `02-impact-analysis-raw.md` | Raw IBM Bob impact analysis (PP4Z) | `cd54f49c` | `cd54f49c` | YES | None | YES | YES |
| `03-business-rules-raw.md` | Raw IBM Bob business-rule extraction | `9423f83a` | `9423f83a` | YES | None | YES | YES |
| `04-known-unknowns-raw.md` | Raw known-unknowns output | `2b63ed5b` | `2b63ed5b` | YES | None | YES | YES |
| `05-playbook-gap-analysis.md` | Playbook gap analysis (human + agent) | `b3707bd3` | `b3707bd3` | YES | None | YES | YES |
| `06-current-state-evidence-pack.md` | Final Current-State Evidence Pack | `fc52214d` | `fc52214d` | YES | None | YES | YES |
| `SHA256SUMS.txt` | Original frozen artifact hashes | `890fa4d2` | `890fa4d2` | YES | None | YES | NO |
| `run-metadata.yaml` | Run execution metadata | `6413bd72` | `6413bd72` | YES | None | YES | NO |

---

## Artifact notes

**01-broad-analysis-raw.md** — Raw IBM Bob/PP4Z broad analysis. Produced before ground-truth review.

**02-impact-analysis-raw.md** — Raw IBM Bob impact analysis using native PP4Z `/impact-analysis` capability.

**03-business-rules-raw.md** — Raw business-rule extraction using native PP4Z capability.

**04-known-unknowns-raw.md** — Known unknowns recovered during UNDERSTAND using the known-unknowns playbook.

**05-playbook-gap-analysis.md** — Human-validated analysis of gaps between playbook expectations and recovered evidence.

**06-current-state-evidence-pack.md** — The final Current-State Evidence Pack. This is the primary UNDERSTAND exit artifact. It was frozen before ground-truth exposure.

**SHA256SUMS.txt** — Original SHA-256 sums recorded at freeze time. Used as integrity baseline.

**run-metadata.yaml** — Records run configuration, product version (IBM Bob 2.1.0), Z Understand status (not configured for this run), workspace isolation, ground-truth isolation, and freeze status.

---

## Evaluation note

This run was evaluated externally against evaluator-only ground truth after freezing. AtlasPay is no longer a blind holdout after this evaluation. Runs 002–006 are regression and continuation evidence.

---

## Security and privacy scan result

- Secrets/credentials: **None found**
- Customer/cardholder data: **None — all synthetic**
- Real employer/institution names: **None found**
- Local absolute user paths: **None found**
- Evaluator ground truth: **Absent from published artifacts**

---

## Sanitization status

No sanitization was required. All artifacts are published byte-identical to originals.

---

## Terminology note

The `run-metadata.yaml` `framework.name` field records `Agentic Mainframe Modernization Framework` (current name used even at v0.3.2 for this run). Other artifacts may contain earlier draft terminology from the model's output; this is historical and does not invalidate the evidence.
