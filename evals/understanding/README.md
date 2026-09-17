# UNDERSTAND Evaluations

The UNDERSTAND evaluation suite measures whether an AI-assisted analysis produces **decision-grade understanding**, not merely fluent explanation.

## Metrics

1. **Dependency Recall** — how many known relevant dependencies were discovered.
2. **Business Rule Recall** — how many known rules were recovered accurately enough to identify their intent.
3. **Evidence Traceability** — proportion of substantive claims linked to valid supporting artifacts.
4. **Unsupported Claim Rate** — proportion of substantive claims that are invented, contradicted, or unsupported.
5. **Known-Unknown Detection** — recovery of material limitations/unknowns intentionally represented by the estate.
6. **Impact Analysis Completeness** — coverage across program, batch, data, middleware/external, and test/operational categories.

## Isolation

The model under test must not read `evals/atlaspay/ground-truth.yaml` before output generation. If it does, mark the run invalid.

## Baseline philosophy

Thresholds in v0.3.0 are **framework acceptance targets**, not claims about IBM Bob or any vendor product.

The first goal is to establish a reproducible baseline. Subsequent runs should record model/product/version/context so improvements can be measured rather than asserted.
