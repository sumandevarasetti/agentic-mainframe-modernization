       IDENTIFICATION DIVISION.
       PROGRAM-ID. RISKFBK.

       DATA DIVISION.
       LINKAGE SECTION.
       COPY AUTHREQ.
       COPY LIMITCTX.

       PROCEDURE DIVISION USING AUTH-REQUEST LIMIT-CONTEXT.
           *> Deterministic fallback when external risk is unavailable.
           MOVE 650 TO LC-RISK-SCORE
           MOVE 'N' TO LC-RISK-AVAILABLE
           GOBACK.
