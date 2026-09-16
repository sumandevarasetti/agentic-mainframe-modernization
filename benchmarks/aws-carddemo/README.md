# AWS CardDemo External Benchmark Adapter

AWS CardDemo is used here as an **external realism/stress-test estate**, not as the canonical Project Bob teaching application.

AtlasPay provides known, deliberately designed ground truth. CardDemo provides independent external validity against a larger public mainframe sample.

## Upstream

Repository: `aws-samples/aws-mainframe-modernization-carddemo`

Pinned baseline commit for this adapter:

`59cc6c2fd7ebd7ef7925cad552a01a4b8b6e4d5e`

The source is **not vendored into this repository** in v0.2.0. Use `fetch-carddemo.sh` to clone the official upstream and check out the pinned commit.

## Why keep it external?

- preserves clear source attribution
- avoids repackaging an AWS sample as AtlasPay
- keeps upstream licensing/NOTICE boundaries obvious
- lets us evaluate the same Agentic Strangler UNDERSTAND methodology on an independently built estate

## Intended use

1. Fetch pinned CardDemo.
2. Run the same UNDERSTAND prompt/skill/agent pack used on AtlasPay.
3. Record dependencies, rules, unknowns, and evidence.
4. Evaluate using the common metrics in `evals/common/`.
5. Do not claim product superiority from a single workload.

## License

CardDemo is maintained by AWS Samples. Review the upstream repository's LICENSE/NOTICE before redistributing or modifying upstream files. This adapter does not copy CardDemo source code.
