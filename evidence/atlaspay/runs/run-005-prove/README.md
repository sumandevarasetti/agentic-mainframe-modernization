# Run 005 — PROVE Evidence

**Lifecycle stage:** PROVE  
**Original local source path:** `.work/atlaspay-understand-001/runs/atlaspay/prove/run-005/`  
**Framework version:** v0.3.7 (executed); published under v0.3.9

---

## Artifact inventory

| File | Artifact role | Source SHA-256 | Published SHA-256 | Byte-identical | Sanitization | Book citation | Screenshot |
|---|---|---|---|---|---|---|---|
| `00-prove-input-manifest.md` | PROVE input artifact manifest | `c0417963` | `c0417963` | YES | None | YES | NO |
| `01-modernization-proof-package.md` | Raw frozen Modernization Proof Package | `f8629bb6` | `f8629bb6` | YES | None | YES | YES |
| `02-human-prove-review.md` | Human PROVE review notes | `6676d550` | `6676d550` | YES | None | YES | NO |
| `03-human-prove-exit-gate.md` | Human PROVE exit gate | `87c25721` | `87c25721` | YES | None | YES | YES |

---

## Artifact notes

**00-prove-input-manifest.md** — Records input artifact hashes fed into the PROVE run, establishing traceability from TRANSFORM output to PROVE input.

**01-modernization-proof-package.md** — The frozen raw Modernization Proof Package produced by IBM Bob / framework before human review. This is the primary PROVE artifact. It was subsequently replaced by the hardened Run 006 version, but this frozen copy represents the initial PROVE attempt.

**02-human-prove-review.md** — Human reviewer notes identifying gaps and issues prior to the Run 006 hardening experiment.

**03-human-prove-exit-gate.md** — Human PROVE exit gate. Conditionally passes PROVE pending the hardening validation in Run 006.

---

## Relationship to Run 006

Run 005 represents the initial PROVE attempt. The human review in `02-human-prove-review.md` identified evidence-boundary and claim-provenance weaknesses that motivated the Run 006 adversarial hardening experiment (v0.3.8).

The initial failure in Run 006 Tests A and C was discovered because of the standards established by Run 005 human review. The corrected Run 006 proof supersedes the Run 005 proof for book citation. Run 005 is retained as the starting point of the PROVE sequence.

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
