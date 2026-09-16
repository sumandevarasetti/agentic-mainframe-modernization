       IDENTIFICATION DIVISION.
       PROGRAM-ID. LIMITBAT.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-ROWS-UPDATED PIC 9(7) VALUE 0.
       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
           *> Synthetic nightly policy refresh marker.
           EXEC SQL
              UPDATE ATLAS_LIMIT_POLICY
                 SET LAST_REFRESH_TS = CURRENT TIMESTAMP
               WHERE ACTIVE_FLAG = 'Y'
           END-EXEC
           MOVE SQLERRD(3) TO WS-ROWS-UPDATED
           GOBACK.
