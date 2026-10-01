# Run 006 — PROVE Hardening Evidence

**Lifecycle stage:** PROVE (adversarial hardening validation)  
**Original local source path:** `.work/atlaspay-understand-001/runs/atlaspay/prove/run-006/`  
**Framework version:** v0.3.8 (executed); published under v0.3.9

---

## Sequence

Run 006 is the v0.3.8 adversarial PROVE hardening experiment. It follows the complete sequence:

1. Input manifest and frozen raw proof
2. External evaluation (Tests A–H)
3. Corrective regression manifest (bounded scope)
4. Corrective regression (raw)
5. Corrective regression evaluation
6. Human v0.3.8 release gate

The initial failure in Tests A and C is preserved in this sequence. It was not rewritten into a success.

---

## Artifact inventory — main sequence

| File | Artifact role | Source SHA-256 | Published SHA-256 | Byte-identical | Sanitization | Book citation | Screenshot |
|---|---|---|---|---|---|---|---|
| `00-prove-input-manifest.md` | Run 006 input artifact manifest | `deba6f94` | `deba6f94` | YES | None | YES | NO |
| `01-modernization-proof-package-raw.md` | Initial frozen raw proof package | `5fcb1c25` | `5fcb1c25` | YES | None | YES | YES |
| `02-external-evaluation.md` | External evaluation — Test A FAIL, Test C FAIL, B/D/E/F/G/H PASS | `9ab35788` | `9ab35788` | YES | None | YES | YES |
| `03-corrective-regression-manifest.md` | Bounded corrective regression scope definition | `73860621` | `73860621` | YES | None | YES | YES |
| `04-corrective-regression-raw.md` | Corrective regression raw output | `03b5124c` | `03b5124c` | YES | None | YES | YES |
| `05-corrective-regression-evaluation.md` | Corrective regression evaluation — Tests A and C PASS | `4d319b9f` | `4d319b9f` | YES | None | YES | YES |
| `06-human-v0.3.8-release-gate.md` | Human v0.3.8 release gate — PASS_WITH_DOCUMENTED_EVIDENCE_LIMITATIONS | `43bd75fa` | `43bd75fa` | YES | None | YES | YES |

---

## Artifact inventory — fixtures

| File | Artifact role | Source SHA-256 | Published SHA-256 | Byte-identical | Sanitization | Book citation | Screenshot |
|---|---|---|---|---|---|---|---|
| `fixtures/changed-artifact-hashes.txt` | SHA-256 evidence for all four changed programs (pre/post) | `0ad097b1` | `0ad097b1` | YES | None | YES | NO |
| `fixtures/ku-status-a.md` | KU status fixture A (known-unknown status input) | `9b0bc4a3` | `9b0bc4a3` | YES | None | YES | NO |
| `fixtures/ku-status-b.md` | KU status fixture B | `919aff1f` | `919aff1f` | YES | None | YES | NO |
| `fixtures/persistence-status.md` | Artifact persistence status fixture | `841cf522` | `841cf522` | YES | None | YES | NO |

---

## Evaluation outcome

**Final release validation:** `PASS_WITH_DOCUMENTED_EVIDENCE_LIMITATIONS`

- Tests B, D, E, F, G, H: PASS on initial run
- Test A: FAIL on initial run → PASS after corrective iteration
- Test C: FAIL on initial run → PASS after corrective iteration
- Corrective iteration: one bounded iteration for package-wide historical provenance and logical-layout versus physical-byte evidence precision
- Runtime validation: **UNAVAILABLE**
- SHIFT authorization: **NOT AUTHORIZED** by this result

---

## Critical preservation note

The initial failure of Tests A and C in `02-external-evaluation.md` is book evidence for Chapter 10 ("When the AI Overclaims"). It is published exactly as it occurred. Do not interpret the corrective regression as proof that no failure happened.

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
