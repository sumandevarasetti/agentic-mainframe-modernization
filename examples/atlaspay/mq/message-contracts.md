# Synthetic MQ Message Contract

## Risk request

- `account_id` — 12-character synthetic account identifier
- `correlation_id` — request correlation identifier

## Risk response

- `account_id`
- `risk_score` — 000–999 synthetic severity score; higher means more restrictive in this example
- `status` — O=OK, T=timeout, E=error

If the response is unavailable, the online path must invoke deterministic fallback logic rather than block authorization indefinitely.
