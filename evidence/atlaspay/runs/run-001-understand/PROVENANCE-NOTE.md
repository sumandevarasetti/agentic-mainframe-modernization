# Run 001 — Provenance Note

**Status:** Publication metadata — preserved evidence defect documentation  
**This file does NOT modify the frozen Run 001 artifacts.**

---

## 1. Original six-artifact SHA256SUMS freeze set

The `SHA256SUMS.txt` file in this directory records the original freeze set for Run 001. It contains exactly six substantive artifacts:

```
da9aab1029a125c68fe7c1dd872fd119f2c339f5f49b8b35035d8b782372d2fd  01-broad-analysis-raw.md
cd54f49cb9ced1e53a7c3f51a624c8cdb15426e74d26484b3da96069d619a64e  02-impact-analysis-raw.md
9423f83a4d61a8d4b9ef2c37c843a7ee64c06b4c804ae4041efaf66bd98d424b  03-business-rules-raw.md
2b63ed5b1dbfbb797aa57534b80283e0ed5b5a36fc6c4ac4a1d1d921780dcc1b  04-known-unknowns-raw.md
b3707bd3b245649d8044ccc238728ca68c8dc0853f2d7f192079893b25845ce5  05-playbook-gap-analysis.md
fc52214dec3a1b586856bc89c54f38247c4cbf4322ee1def95a2f68f302a00bb  06-current-state-evidence-pack.md
```

`run-metadata.yaml` was **not** included in this original six-artifact freeze set. It is preserved historical evidence and is published in this directory for transparency, but it is a separate artifact from the frozen analysis output.

---

## 2. run-metadata.yaml status

`run-metadata.yaml` is preserved exactly as found. It is **not modified**.

It records the execution environment for Run 001:

- Product: IBM Bob 2.1.0 / Premium Package for Z
- Z Understand: **not configured** (`configured: false`, `reason: server_not_available_for_this_experiment`)
- DD.json: not available
- AGENTS.md: generated via `/init`, framework overlay merged
- Ground truth: hidden from Bob, not present in workspace
- Status: `frozen_before_ground_truth`

These fields are the corroborated product/version and Z Understand status to use for book citations about Run 001.

---

## 3. Preserved evidence defect — artifact_persistence block

The `artifact_persistence` block in `run-metadata.yaml` names:

```yaml
artifact_persistence:
  file: 03-modernization-decision-record-final.md
```

That artifact (`03-modernization-decision-record-final.md`) belongs to the DECIDE stage (Run 002), not to the UNDERSTAND artifact set. It does not exist in this Run 001 directory.

This is an apparent cross-run or copy-paste metadata defect in the `run-metadata.yaml` file.

**Treatment:**

- This is a preserved evidence defect. It is documented here, not corrected.
- The frozen metadata file is not edited.
- The `artifact_persistence` block does not affect the integrity of the six-artifact UNDERSTAND freeze set, which is governed by `SHA256SUMS.txt`.
- The `artifact_persistence` block likely records an API file-write failure that occurred during the DECIDE stage, whose metadata was inadvertently included when this file was assembled.
- No inference is made about when or why the defect was introduced.

---

## 4. Preserved evidence defect — KU-13 citation in 04-known-unknowns-raw.md

In the frozen artifact `04-known-unknowns-raw.md`, the KU-13 citation references the historical characterization file with a line number pointing to **line 12** for the `6000.00` expected value. The value `6000.00` is physically on **line 13** of that file.

This is a preserved off-by-one citation defect in the raw model output.

**Treatment:**

- The frozen artifact is not repaired.
- The broader C-01 evidence citation in the same artifact correctly spans the relevant block and is unaffected.
- This off-by-one does not invalidate the KU-13 finding itself; the correct value is recoverable from the characterization file context.
- This citation defect is documented here as a known frozen evidence limitation.

---

## 5. Book citation guidance

When citing Run 001 artifacts:

- Product version and Z Understand status must be corroborated from `run-metadata.yaml` (the `product` and `environment.z_understand` blocks) and the published evaluation record — **not** from the `artifact_persistence` block.
- The six-artifact UNDERSTAND analysis set is the authoritative evidence for this run.
- `SHA256SUMS.txt` is the integrity reference for those six artifacts.
- `run-metadata.yaml` is supplementary execution context, not part of the original six-artifact freeze.

---

## 6. Integrity confirmation

| Artifact | SHA-256 (published) |
|---|---|
| `01-broad-analysis-raw.md` | `da9aab1029a125c68fe7c1dd872fd119f2c339f5f49b8b35035d8b782372d2fd` |
| `02-impact-analysis-raw.md` | `cd54f49cb9ced1e53a7c3f51a624c8cdb15426e74d26484b3da96069d619a64e` |
| `03-business-rules-raw.md` | `9423f83a4d61a8d4b9ef2c37c843a7ee64c06b4c804ae4041efaf66bd98d424b` |
| `04-known-unknowns-raw.md` | `2b63ed5b1dbfbb797aa57534b80283e0ed5b5a36fc6c4ac4a1d1d921780dcc1b` |
| `05-playbook-gap-analysis.md` | `b3707bd3b245649d8044ccc238728ca68c8dc0853f2d7f192079893b25845ce5` |
| `06-current-state-evidence-pack.md` | `fc52214dec3a1b586856bc89c54f38247c4cbf4322ee1def95a2f68f302a00bb` |
| `SHA256SUMS.txt` (self) | `890fa4d2eaf090cc42a9bbfce7dc96027b69d05e292ed6822d71a30bcf07217a` |
| `run-metadata.yaml` (separately tracked) | `6413bd726b2f3d8d6b93b05188d54ff2f853dbe98f6778dd13d10addfbc06318` |
