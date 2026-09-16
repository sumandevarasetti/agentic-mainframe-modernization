# Authorization Flow

At a high level:

1. Receive authorization request through CICS transaction `ATLA`.
2. Validate account status.
3. Evaluate merchant restrictions.
4. Determine transaction limit.
5. Compare amount to applicable limit.
6. Build response and write an audit record.

The exact implementation of transaction-limit decisioning is intentionally not fully documented here.
