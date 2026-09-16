       01  AUTH-RESPONSE.
           05  AS-DECISION            PIC X.
               88 AS-APPROVED         VALUE 'A'.
               88 AS-DECLINED         VALUE 'D'.
           05  AS-REASON-CODE         PIC X(4).
           05  AS-APPLIED-LIMIT       PIC 9(7)V99.
           05  AS-RISK-MODE           PIC X.
