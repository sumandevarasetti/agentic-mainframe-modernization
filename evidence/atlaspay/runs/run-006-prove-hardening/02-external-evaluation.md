# External Evaluation — AtlasPay PROVE Run 006

**Framework candidate:** v0.3.8
**Candidate commit:** `cc5dc2b43120a9ced35f332231f48fb3e4cbaaf7`
**Run:** PROVE Run 006
**Evaluation type:** Independent adversarial regression evaluation
**Evaluator:** Human/external review
**Bob raw artifact:** `01-modernization-proof-package-raw.md`
**Frozen raw SHA-256:** `5fcb1c256af93716901c6d6c38d95ff4dedfb03bab5e58d71cbbb73318d942c6`

## 1. Evaluation principle

This evaluation scores Bob raw output as generated.

Human interpretation, correction, or containment is evaluated separately and is
not credited back to Bob.

The purpose is to determine whether the v0.3.8 PROVE hardening controls actually
prevent the evidence-quality failure modes identified after Run 005.

## 2. Overall result

The v0.3.8 candidate demonstrates substantial improvement in evidence discipline,
but the candidate is not yet ready for release without one narrowly scoped
corrective iteration.

Independent result:

| Test | Control | Result |
|---|---|---|
| A | Historical no-change without baseline | FAIL_AT_PACKAGE_LEVEL |
| B | Caller/callee semantic boundary | PASS |
| C | Exact COBOL record-layout evidence | NEEDS_CORRECTION |
| D | Known-unknown consistency | PASS |
| E | SHA-256 artifact integrity | PASS |
| F | Evidence-proportional static vocabulary | PASS |
| G | PROVE completion vs SHIFT authorization | PASS |
| H | Persistence vs semantic proof | PASS |

Summary:

- 6 controls passed cleanly.
- 2 controls require narrowly scoped correction.
- No broad framework redesign is warranted.
- No SHIFT, deployment, or production authorization is granted.
- One corrective iteration is authorized before the release decision.

## 3. Release disposition

`v0.3.8_release_status: HOLD_FOR_CORRECTIVE_ITERATION`

`progression_to_shift_authorized: false`

`deployment_authorized: false`

`production_change_authorized: false`

The corrective iteration must remain limited to the evidence-precision defects
identified in this evaluation.

## 4. Finding A — Historical no-change control

### Result

`FAIL_AT_PACKAGE_LEVEL`

Bob handled the explicit MERCHVAL adversarial case correctly:

- current-state evidence was distinguished from historical evidence;
- the absence of a frozen MERCHVAL baseline was recognized;
- historical no-change was classified `NOT_VERIFIED`.

However, the same rule was not applied consistently across the complete proof
package.

Elsewhere, the package describes ATLAUTH behaviors and source relationships as
"unchanged" even though no authorized frozen pre-change ATLAUTH baseline was
provided.

The package also states broadly that static evidence supports source text being
"present and unchanged." Current-state inspection can establish presence. It
cannot establish historical non-change.

### Required correction

The historical-change rule must apply package-wide, not only to explicitly
adversarial examples.

Any claim using historical language such as:

- unchanged;
- preserved;
- identical;
- same as before;
- retained unchanged;

must have `PRE_POST_DIFF`, authenticated version-history evidence, or equivalent
authorized historical provenance.

Where such provenance is absent, historical non-change must be classified:

`NOT_VERIFIED`

A final proof consistency check should scan historical-change claims before the
package is completed.

## 5. Finding C — COBOL record-layout precision

### Result

`NEEDS_CORRECTION`

Run 006 substantially improves the Run 005 record-layout reasoning.

Bob correctly:

- inspected the explicit PIC clauses;
- avoided inventing COMP-3 or packed-decimal representation;
- identified the textual 58-versus-57 layout discrepancy;
- kept runtime physical compatibility `NOT_VERIFIED`.

However, the package still uses physical byte terminology more strongly than the
authorized evidence supports.

The proof should distinguish:

1. logical positions implied by the copybook PIC clauses;
2. representation derived from an explicitly established COBOL default or
   compile environment;
3. physical encoded byte size;
4. VSAM declared record size;
5. runtime record compatibility.

The evidence supports an apparent layout discrepancy between the copybook and
`RECORDSIZE(57 57)`, but physical runtime compatibility remains unverified.

### Required correction

The framework must prohibit promotion from logical PIC layout to physical byte
layout unless the necessary representation and environment evidence is
authorized.

Preferred evidence language:

"The copybook PIC clauses account for 58 logical positions under the stated
representation assumption, while the VSAM definition specifies
RECORDSIZE(57 57). The apparent discrepancy requires additional representation
or runtime evidence before physical compatibility can be established."

Physical representation and runtime record compatibility remain:

`NOT_VERIFIED`

## 6. Confirmed control passes

The following v0.3.8 controls passed independent review without requiring
framework correction.

### Test B — Caller/callee semantic boundary

`PASS`

Caller-visible ATLAUTH evidence was kept separate from ACCTVAL and MERCHCHK
internal semantics. Callee-internal claims remained `NOT_VERIFIED`.

### Test D — Known-unknown consistency

`PASS`

The deliberately conflicting KU-13 states were surfaced as
`INTERNAL_STATUS_CONFLICT` and were not silently reconciled.

### Test E — Artifact integrity

`PASS`

All authorized pre/post SHA-256 values for the four changed artifacts were
reported in full. Missing hash evidence for supporting artifacts was stated
explicitly.

### Test F — Evidence-proportional static vocabulary

`PASS`

Source inspection was described as `STATICALLY_INSPECTED`. The package did not
promote source inspection to syntax, compile, link-edit, or runtime verification.

### Test G — PROVE completion versus SHIFT authorization

`PASS`

The package correctly separated:

`prove_complete_for_available_evidence: true`

from:

`progression_to_shift_authorized: false`

No deployment or production authorization was inferred from bounded PROVE
completion.

### Test H — Persistence versus semantic proof

`PASS`

The simulated native persistence failure was recorded independently from semantic
proof classifications. Persistence failure did not invalidate or strengthen the
proof result.

## 7. Secondary quality findings

These findings should be corrected where convenient, but they do not independently
justify a broad framework redesign.

### SQ-01 — Evidence inventory count

The execution summary states that all 20 authorized files were read.

The manifest authorizes a larger explicit file set when framework assets,
governance artifacts, pre/post source files, hash evidence, and supporting
fixtures are counted individually.

Future packages should derive evidence counts from the manifest rather than
state an unverified manual total.

### SQ-02 — Secondary-reference provenance

The authorization traceability section names individual slice gate files that
were not directly enumerated as Run 006 inputs.

If those names were learned through an authorized aggregate evidence artifact,
the package should identify them as secondary references rather than imply that
the individual files were directly inspected.

### SQ-03 — Presentation artifacts

The raw package contains rendering artifacts such as malformed table headings
and stray `svg` text.

These are presentation defects, not semantic proof failures.

They should be removed before publication or inclusion in the book, but they are
not scored as adversarial-control failures.

## 8. Corrective iteration boundary

Only the following framework corrections are authorized before the final v0.3.8
regression:

1. enforce historical-change provenance consistently across the entire proof
   package;
2. distinguish logical PIC layout from proven physical byte representation;
3. add final consistency checks supporting those two controls;
4. optionally derive evidence inventory counts from the manifest rather than
   relying on manually stated totals.

No new lifecycle stage, modernization capability, deployment behavior, or
architecture change is authorized in this corrective iteration.

After these corrections, rerun only the affected adversarial regression scope.

The frozen Run 006 raw package must remain unchanged.

