# AtlasPay System Overview

AtlasPay combines online CICS transaction processing with batch maintenance jobs.

The online path begins at CICS transaction `ATLA`, which invokes the authorization orchestration program. Transaction-limit decisions are delegated to a limit component that uses product policy information.

Reference technologies represented in the synthetic estate include COBOL, copybooks, CICS metadata, Db2 DDL/sample data, VSAM-style exception records, JCL, and IBM MQ-style message contracts.

Documentation is intentionally incomplete so that application-understanding workflows must inspect source and operational artifacts rather than relying on a perfect README.
