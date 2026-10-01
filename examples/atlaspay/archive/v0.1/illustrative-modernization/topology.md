# AtlasPay Synthetic Topology

```text
Digital Authorization API
          |
          v
      CICS ATLA
          |
          v
    TRNLIM01.cbl
       /      \
      v        v
LIMITPOL.cbl  CUSTRSK.cbl
    |              |
   Db2          VSAM Exceptions
    |              |
    +-------+------+
            |
       MQ Risk Score
            |
     Nightly JCL Refresh
```

All component names and relationships are fictional.
