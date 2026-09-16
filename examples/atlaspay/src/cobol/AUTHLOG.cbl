       IDENTIFICATION DIVISION.
       PROGRAM-ID. AUTHLOG.

       DATA DIVISION.
       LINKAGE SECTION.
       COPY AUTHREQ.
       COPY AUTHRESP.

       PROCEDURE DIVISION USING AUTH-REQUEST AUTH-RESPONSE.
           *> Synthetic audit sink. Real I/O intentionally omitted.
           GOBACK.
