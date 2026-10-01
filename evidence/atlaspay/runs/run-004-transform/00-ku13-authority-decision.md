# KU-13 Test Authority Decision

**Experiment:** AtlasPay TRANSFORM Run 004
**Capability:** Dynamic Transaction Limit
**Decision Owner:** Suman Devarasetti
**Decision Type:** Synthetic regression-baseline authority
**Status:** APPROVED

## Conflict

Two characterization artifacts disagree on the expected behavior for a high-risk
account where the risk score is greater than or equal to 800.

The current AtlasPay source implementation in `LIMUTIL.cbl` applies:

Candidate = Candidate * 0.80

One characterization artifact agrees with this behavior; another contains a
conflicting expected result.

## Decision

For the AtlasPay synthetic teaching/regression estate, the authoritative
regression expectation is the behavior implemented by the current source:

**Risk score >= 800 -> Candidate * 0.80**

The conflicting expectation is retained as historical evidence but is not used
as the regression oracle for this experiment.

## Important Boundary

This decision establishes a regression baseline for the synthetic AtlasPay
estate only.

It does not assert that the current source represents real-world regulatory,
card-network, customer, or enterprise business policy.

It does not authorize changing the risk-adjustment rule.

Any intentional behavioral change requires a separate human-approved business
policy decision.

## Gate Result

```yaml
unknown: KU-13
resolution_status: RESOLVED_FOR_SYNTHETIC_REGRESSION_BASELINE
authoritative_observed_behavior: "risk_score >= 800 -> candidate * 0.80"
business_intent_claimed: false
source_change_authorized_by_this_decision: false