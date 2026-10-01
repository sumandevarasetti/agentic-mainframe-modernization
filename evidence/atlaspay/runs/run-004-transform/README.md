# Run 004 — TRANSFORM Evidence

**Lifecycle stage:** TRANSFORM  
**Original local source path:** `.work/atlaspay-understand-001/runs/atlaspay/transform/run-004/`  
**Framework version:** v0.3.6 (executed); published under v0.3.9

---

## Artifact inventory — process documents

| File | Artifact role | Source SHA-256 | Published SHA-256 | Byte-identical | Sanitization | Book citation | Screenshot |
|---|---|---|---|---|---|---|---|
| `00-ku13-authority-decision.md` | KU-13 authority decision — characterization baseline authorization | `0f8fe52f` | `0f8fe52f` | YES | None | YES | YES |
| `01-slice-0-characterization-baseline.md` | Slice 0 characterization baseline (KU-13 resolution) | `25234758` | `25234758` | YES | None | YES | YES |
| `02-slice-0-human-review-gate.md` | Slice 0 human review gate | `c11d7922` | `c11d7922` | YES | None | YES | YES |
| `03-slice-1-gate-resolution.md` | Slice 1 gate resolution | `13536864` | `13536864` | YES | None | YES | NO |
| `04-slice-1a-authorization.md` | Slice 1A LIMITPOL authorization | `d3346dce` | `d3346dce` | YES | None | YES | NO |
| `05-slice-1a-human-review-gate.md` | Slice 1A human review gate | `81677b87` | `81677b87` | YES | None | YES | YES |
| `06-slice-2-gate-resolution.md` | Slice 2 gate resolution | `33626acc` | `33626acc` | YES | None | YES | NO |
| `07-slice-2a-authorization.md` | Slice 2A EXCEPT01 authorization | `b23040da` | `b23040da` | YES | None | YES | NO |
| `08-slice-2a-human-review-gate.md` | Slice 2A human review gate | `b3e5a13f` | `b3e5a13f` | YES | None | YES | YES |
| `09-slice-3-gate-resolution.md` | Slice 3 gate resolution (no source change) | `93c1dbbd` | `93c1dbbd` | YES | None | YES | NO |
| `10-slice-4-gate-resolution.md` | Slice 4 gate resolution | `bccef5c2` | `bccef5c2` | YES | None | YES | NO |
| `11-slice-4a-authorization.md` | Slice 4A CUSTRSK+TRNLIM01 authorization | `0b33bafc` | `0b33bafc` | YES | None | YES | NO |
| `12-slice-4a-human-review-gate.md` | Slice 4A human review gate | `ba1bc2a4` | `ba1bc2a4` | YES | None | YES | YES |
| `13-slice-5-gate-resolution.md` | Slice 5 gate resolution | `0f4e39b0` | `0f4e39b0` | YES | None | YES | NO |
| `14-transform-evidence-pack.md` | Final Traceable Change Set / Transform Evidence Pack | `c204edaa` | `c204edaa` | YES | None | YES | YES |
| `15-human-transform-exit-gate.md` | Human TRANSFORM exit gate | `0f8515f0` | `0f8515f0` | YES | None | YES | YES |

---

## Artifact inventory — source snapshots

### Pre-change source (frozen at start of each slice)

| File | Program | SHA-256 |
|---|---|---|
| `source/pre/LIMITPOL.cbl` | LIMITPOL — pre-Slice 1A | `6677042015ae40faff8dc221ba4a6bdbc50af5b313ce5a2b2ddc9abcfb7101ec` |
| `source/pre/EXCEPT01.cbl` | EXCEPT01 — pre-Slice 2A | `068d35b4af57b2141f02f886b1ca8c0940ed3a7379b2f4c559125ad35294bc3d` |
| `source/pre/CUSTRSK.cbl` | CUSTRSK — pre-Slice 4A | `0f936009163cf716fa62813916e27ac8cf307016d00088d0d09e99b7ed217b25` |
| `source/pre/TRNLIM01.cbl` | TRNLIM01 — pre-Slice 4A | `4da600249d86a26bbc17d94910833c2fedacfdab7cf567b52b5ec73e3ea9d552` |

These match the pre-change snapshots frozen in the transform run and correspond to the current `examples/atlaspay/src/cobol/` state (which was not updated post-transform in the main repository at v0.3.9).

### Post-change source (from .work workspace after transform)

| File | Program | SHA-256 |
|---|---|---|
| `source/post/LIMITPOL.cbl` | LIMITPOL — post-Slice 1A | `ca425f9884d7a729c38a0f8b4b517b065d6f2d903ccb3509203591ec85759b04` |
| `source/post/EXCEPT01.cbl` | EXCEPT01 — post-Slice 2A | `6735cae2ebc0c354aa51d37af5ff1dd7ff43328d68fda6a7d427a755b33a21a1` |
| `source/post/CUSTRSK.cbl` | CUSTRSK — post-Slice 4A | `45d138b5d947b06e01450e00f92db6e758c957f8cd2109b1a58a5144e777310a` |
| `source/post/TRNLIM01.cbl` | TRNLIM01 — post-Slice 4A | `2e9f5594d5e5cfcce7d09178c9872117d1e4429cdf9681bbdcb1bcaf0cf3760b` |

Post-change hashes match those recorded in `14-transform-evidence-pack.md` and confirmed in `evidence/atlaspay/runs/run-006-prove-hardening/fixtures/changed-artifact-hashes.txt`.

---

## Transform summary

Four programs were modified:

- **LIMITPOL.cbl** — Slice 1A: structural refactoring (separated policy retrieval, fallback handling)
- **EXCEPT01.cbl** — Slice 2A: structural refactoring (separated initialization, exception lookup)
- **CUSTRSK.cbl** — Slice 4A: narrow interface refactoring (reduced USING clause)
- **TRNLIM01.cbl** — Slice 4A: caller update for new CUSTRSK interface

One program was reviewed with no source change:
- **MERCHVAL.cbl** — Slice 3: policy-intent review; no change authorized

Runtime equivalence: **UNVERIFIED** for all four programs.

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
