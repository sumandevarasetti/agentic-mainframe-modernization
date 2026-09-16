       01  RISK-MESSAGE.
           05  RM-ACCOUNT-ID          PIC X(12).
           05  RM-RISK-SCORE          PIC 9(3).
           05  RM-STATUS              PIC X.
               88 RM-OK               VALUE 'O'.
               88 RM-TIMEOUT          VALUE 'T'.
               88 RM-ERROR            VALUE 'E'.
