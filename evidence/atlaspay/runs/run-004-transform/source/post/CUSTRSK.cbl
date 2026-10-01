       IDENTIFICATION DIVISION.
       PROGRAM-ID. CUSTRSK.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY RISKSCR.

       LINKAGE SECTION.
       01  LK-ACCOUNT-ID              PIC X(12).
       01  LK-RISK-SCORE              PIC 9(3).
       01  LK-RISK-AVAILABLE          PIC X.

       PROCEDURE DIVISION USING LK-ACCOUNT-ID
                                LK-RISK-SCORE
                                LK-RISK-AVAILABLE.
           INITIALIZE RISK-MESSAGE
           MOVE LK-ACCOUNT-ID TO RM-ACCOUNT-ID

           CALL 'MQRSKGET' USING RISK-MESSAGE

           IF RM-OK
              MOVE 'Y' TO LK-RISK-AVAILABLE
              MOVE RM-RISK-SCORE TO LK-RISK-SCORE
           ELSE
              MOVE 'N' TO LK-RISK-AVAILABLE
              MOVE 000 TO LK-RISK-SCORE
           END-IF
           GOBACK.
