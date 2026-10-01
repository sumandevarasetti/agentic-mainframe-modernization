# Run 001 — UNDERSTAND Evidence

**Lifecycle stage:** UNDERSTAND
**Original local source path:** `.work/atlaspay-understand-001/runs/atlaspay/understand/run-001/`
**Framework version:** v0.3.2 (executed); published under v0.3.10

> **See also:** [PROVENANCE-NOTE.md](PROVENANCE-NOTE.md) — documents two preserved evidence defects in this run: a cross-run metadata defect in `run-metadata.yaml` and an off-by-one citation in `04-known-unknowns-raw.md`. Neither defect is repaired; both are documented for book citation transparency.

---

## Original six-artifact freeze set

The `SHA256SUMS.txt` records the six substantive analysis artifacts frozen before ground-truth exposure. `run-metadata.yaml` was **not** part of this original freeze set; it is supplementary execution context.

---

## Artifact inventory

| File | Artifact role | Source SHA-256 | Published SHA-256 | Byte-identical | Sanitization | Book citation | Screenshot |
|---|---|---|---|---|---|---|---|
| `01-broad-analysis-raw.md` | Raw broad IBM Bob analysis | `da9aab1029a125c68fe7c1dd872fd119f2c339f5f49b8b35035d8b782372d2fd` | `da9aab1029a125c68fe7c1dd872fd119f2c339f5f49b8b35035d8b782372d2fd` | YES | None | YES | YES |
| `02-impact-analysis-raw.md` | Raw IBM Bob impact analysis (PP4Z) | `cd54f49cb9ced1e53a7c3f51a624c8cdb15426e74d26484b3da96069d619a64e` | `cd54f49cb9ced1e53a7c3f51a624c8cdb15426e74d26484b3da96069d619a64e` | YES | None | YES | YES |
| `03-business-rules-raw.md` | Raw IBM Bob business-rule extraction | `9423f83a4d61a8d4b9ef2c37c843a7ee64c06b4c804ae4041efaf66bd98d424b` | `9423f83a4d61a8d4b9ef2c37c843a7ee64c06b4c804ae4041efaf66bd98d424b` | YES | None | YES | YES |
| `04-known-unknowns-raw.md` | Raw known-unknowns output | `2b63ed5b1dbfbb797aa57534b80283e0ed5b5a36fc6c4ac4a1d1d921780dcc1b` | `2b63ed5b1dbfbb797aa57534b80283e0ed5b5a36fc6c4ac4a1d1d921780dcc1b` | YES | None | YES | YES |
| `05-playbook-gap-analysis.md` | Playbook gap analysis (human + agent) | `b3707bd3b245649d8044ccc238728ca68c8dc0853f2d7f192079893b25845ce5` | `b3707bd3b245649d8044ccc238728ca68c8dc0853f2d7f192079893b25845ce5` | YES | None | YES | YES |
| `06-current-state-evidence-pack.md` | Final Current-State Evidence Pack | `fc52214dec3a1b586856bc89c54f38247c4cbf4322ee1def95a2f68f302a00bb` | `fc52214dec3a1b586856bc89c54f38247c4cbf4322ee1def95a2f68f302a00bb` | YES | None | YES | YES |
| `SHA256SUMS.txt` | Original six-artifact freeze hashes | `890fa4d2eaf090cc42a9bbfce7dc96027b69d05e292ed6822d71a30bcf07217a` | `890fa4d2eaf090cc42a9bbfce7dc96027b69d05e292ed6822d71a30bcf07217a` | YES | None | YES | NO |
| `run-metadata.yaml` | Supplementary execution context (not in original six-artifact freeze) | `6413bd726b2f3d8d6b93b05188d54ff2f853dbe98f6778dd13d10addfbc06318` | `6413bd726b2f3d8d6b93b05188d54ff2f853dbe98f6778dd13d10addfbc06318` | YES | None | YES — with caveats | NO |
| `PROVENANCE-NOTE.md` | Publication-layer provenance clarification | N/A (new file) | N/A | N/A | N/A | YES | NO |

---

## Artifact notes

**01-broad-analysis-raw.md** — Raw IBM Bob/PP4Z broad analysis. Produced before ground-truth review.

**02-impact-analysis-raw.md** — Raw IBM Bob impact analysis using native PP4Z `/impact-analysis` capability.

**03-business-rules-raw.md** — Raw business-rule extraction using native PP4Z capability.

**04-known-unknowns-raw.md** — Known unknowns recovered during UNDERSTAND using the known-unknowns playbook. Contains a preserved off-by-one citation for KU-13 (line 12 vs. line 13). See [PROVENANCE-NOTE.md](PROVENANCE-NOTE.md) §4.

**05-playbook-gap-analysis.md** — Human-validated analysis of gaps between playbook expectations and recovered evidence.

**06-current-state-evidence-pack.md** — The final Current-State Evidence Pack. Primary UNDERSTAND exit artifact. Frozen before ground-truth exposure.

**SHA256SUMS.txt** — Original SHA-256 sums recorded at freeze time for the six substantive analysis artifacts.

**run-metadata.yaml** — Supplementary execution context: product version (IBM Bob 2.1.0), Z Understand status (not configured for this run — `configured: false`), workspace isolation, ground-truth isolation, freeze status. Contains a preserved cross-run metadata defect in the `artifact_persistence` block. See [PROVENANCE-NOTE.md](PROVENANCE-NOTE.md) §3. Do not cite the `artifact_persistence` block for book purposes.

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

No sanitization was required. All six analysis artifacts are published byte-identical to originals.

---

## Terminology note

Other artifacts in this directory may contain earlier draft terminology from the model's output; this is historical and does not invalidate the evidence.
