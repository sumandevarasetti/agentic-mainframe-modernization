# Operations Notes

- Product-policy reference data is maintained by scheduled batch processing.
- Exception data is reconciled periodically.
- Authorization reporting runs separately from the online flow.
- External risk information may not always be available; the online transaction must still complete predictably.

These notes intentionally omit some implementation details used by the evaluation ground truth.
