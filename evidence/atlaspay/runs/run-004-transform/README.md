# Run 004 — TRANSFORM Evidence

**Lifecycle stage:** TRANSFORM
**Original local source path:** `.work/atlaspay-understand-001/runs/atlaspay/transform/run-004/`
**Framework version:** v0.3.6 (executed); published under v0.3.10

> **See also:** [KU13-SCOPE-NOTE.md](KU13-SCOPE-NOTE.md) — clarifies the two distinct dimensions of KU-13: regression-oracle authority (`RESOLVED_FOR_SYNTHETIC_REGRESSION_BASELINE`) vs. historical/business intent (`UNRESOLVED / NOT CLAIMED`).

---

## Artifact inventory — process documents

| File | Artifact role | Source SHA-256 | Published SHA-256 | Byte-identical | Sanitization | Book citation | Screenshot |
|---|---|---|---|---|---|---|---|
| `00-ku13-authority-decision.md` | KU-13 authority decision — characterization baseline authorization | `0f8fe52fc9cd7add4cac94e62245e753d6064b2dc80a4bb5bd721d6330bb5f90` | `0f8fe52fc9cd7add4cac94e62245e753d6064b2dc80a4bb5bd721d6330bb5f90` | YES | None | YES | YES |
| `01-slice-0-characterization-baseline.md` | Slice 0 characterization baseline (KU-13 resolution) | `25234758be44d5b555a8c5b260eb81fbb9393b11e36905811610476161dc1dc5` | `25234758be44d5b555a8c5b260eb81fbb9393b11e36905811610476161dc1dc5` | YES | None | YES | YES |
| `02-slice-0-human-review-gate.md` | Slice 0 human review gate | `c11d79229d8f3870422f8186c13173b470f0352fb7c7f7f7292b6803c76ce30f` | `c11d79229d8f3870422f8186c13173b470f0352fb7c7f7f7292b6803c76ce30f` | YES | None | YES | YES |
| `03-slice-1-gate-resolution.md` | Slice 1 gate resolution | `135368c685f878a95f70bf16a004795d2473874897f9153fa6c6741b58fa8c05` | `135368c685f878a95f70bf16a004795d2473874897f9153fa6c6741b58fa8c05` | YES | None | YES | NO |
| `04-slice-1a-authorization.md` | Slice 1A LIMITPOL authorization | `d3346dce17e26ae62d6b0d0f04ec8ae36565775f4a97f5b98984002477ea43ec` | `d3346dce17e26ae62d6b0d0f04ec8ae36565775f4a97f5b98984002477ea43ec` | YES | None | YES | NO |
| `05-slice-1a-human-review-gate.md` | Slice 1A human review gate | `81677b87d7fb28ca720750bfbbe54d97ca04884257840b4d210a8b092cf222c1` | `81677b87d7fb28ca720750bfbbe54d97ca04884257840b4d210a8b092cf222c1` | YES | None | YES | YES |
| `06-slice-2-gate-resolution.md` | Slice 2 gate resolution | `33626acc2263f6f3e10a9d09617e6b09007446f7a9ba82f80c141ae0c4100a9a` | `33626acc2263f6f3e10a9d09617e6b09007446f7a9ba82f80c141ae0c4100a9a` | YES | None | YES | NO |
| `07-slice-2a-authorization.md` | Slice 2A EXCEPT01 authorization | `b23040da389bd4fe563c0a6783be2739176e9dcc56f9c8d7eabbb9bee07c5616` | `b23040da389bd4fe563c0a6783be2739176e9dcc56f9c8d7eabbb9bee07c5616` | YES | None | YES | NO |
| `08-slice-2a-human-review-gate.md` | Slice 2A human review gate | `b3e5a13f1450057c2e9f4d2aa78cc772d0d019b6ed20eb32b7f5f38e6ba2482d` | `b3e5a13f1450057c2e9f4d2aa78cc772d0d019b6ed20eb32b7f5f38e6ba2482d` | YES | None | YES | YES |
| `09-slice-3-gate-resolution.md` | Slice 3 gate resolution (no source change) | `93c1dbbd2a40e133e634a3e482addee316f6e4cce46042c87c9e9d294bf6bb80` | `93c1dbbd2a40e133e634a3e482addee316f6e4cce46042c87c9e9d294bf6bb80` | YES | None | YES | NO |
| `10-slice-4-gate-resolution.md` | Slice 4 gate resolution | `bccef5c251736b45787456412f42254fcfa207924b3b151fedd337d83afb516a` | `bccef5c251736b45787456412f42254fcfa207924b3b151fedd337d83afb516a` | YES | None | YES | NO |
| `11-slice-4a-authorization.md` | Slice 4A CUSTRSK+TRNLIM01 authorization | `0b33bafc046026f7075a19010f3b509db207651499fbcf7ed6855043b0a2ac81` | `0b33bafc046026f7075a19010f3b509db207651499fbcf7ed6855043b0a2ac81` | YES | None | YES | NO |
| `12-slice-4a-human-review-gate.md` | Slice 4A human review gate | `ba1bc2a4027900089cbdd6a19fe022b3659d3291c5f1cbde40ab47ce68a4ac47` | `ba1bc2a4027900089cbdd6a19fe022b3659d3291c5f1cbde40ab47ce68a4ac47` | YES | None | YES | YES |
| `13-slice-5-gate-resolution.md` | Slice 5 gate resolution | `0f4e39b05178a751051c22ab897b6afec841fc33040cbdf3de3de2fb19aa6269` | `0f4e39b05178a751051c22ab897b6afec841fc33040cbdf3de3de2fb19aa6269` | YES | None | YES | NO |
| `14-transform-evidence-pack.md` | Final Traceable Change Set / Transform Evidence Pack | `c204edaa3ba22690fd3cd076eb5ebe630cf924b9d4d821ea458c2a87a27fe007` | `c204edaa3ba22690fd3cd076eb5ebe630cf924b9d4d821ea458c2a87a27fe007` | YES | None | YES | YES |
| `15-human-transform-exit-gate.md` | Human TRANSFORM exit gate | `0f8515f0bb65fe596b31f7167b2dde0a3ba22d53cad340f0fd6ae4c2e745d719` | `0f8515f0bb65fe596b31f7167b2dde0a3ba22d53cad340f0fd6ae4c2e745d719` | YES | None | YES | YES |

---

## Artifact inventory — source snapshots

### Pre-change source (frozen at start of each slice)

| File | Program | SHA-256 |
|---|---|---|
| `source/pre/LIMITPOL.cbl` | LIMITPOL — pre-Slice 1A | `6677042015ae40faff8dc221ba4a6bdbc50af5b313ce5a2b2ddc9abcfb7101ec` |
| `source/pre/EXCEPT01.cbl` | EXCEPT01 — pre-Slice 2A | `068d35b4af57b2141f02f886b1ca8c0940ed3a7379b2f4c559125ad35294bc3d` |
| `source/pre/CUSTRSK.cbl` | CUSTRSK — pre-Slice 4A | `0f936009163cf716fa62813916e27ac8cf307016d00088d0d09e99b7ed217b25` |
| `source/pre/TRNLIM01.cbl` | TRNLIM01 — pre-Slice 4A | `4da600249d86a26bbc17d94910833c2fedacfdab7cf567b52b5ec73e3ea9d552` |

These match the pre-change snapshots frozen in the transform run and correspond to the current `examples/atlaspay/src/cobol/` state (which was not updated post-transform in the main repository).

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

## KU-13 scope note

KU-13 has two dimensions. The regression-oracle authority was resolved (`RESOLVED_FOR_SYNTHETIC_REGRESSION_BASELINE`). The historical/business-intent dimension remains unresolved. See [KU13-SCOPE-NOTE.md](KU13-SCOPE-NOTE.md) for the full clarification.

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
