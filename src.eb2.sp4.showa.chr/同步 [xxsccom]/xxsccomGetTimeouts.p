/* SS - 090908.1 By: Bill Jiang */

/* SS - 090908.1 - RNB
[090908.1]

获得超时

如果没有维护,则返回30

[090908.1]

SS - 090908.1 - RNE */

{mfdeclre.i}
{gplabel.i}

DEFINE OUTPUT PARAMETER timeouts AS INTEGER.

DEFINE VARIABLE i1 AS INTEGER.
DEFINE VARIABLE i2 AS INTEGER.

FIND FIRST CODE_mstr
   WHERE CODE_fldname = "SoftspeedSCM.Sync_Timeouts"
   AND CODE_value = execname
   NO-LOCK NO-ERROR.
IF AVAILABLE CODE_mstr THEN DO:
   ASSIGN timeouts = INTEGER(CODE_desc) NO-ERROR.
   IF NOT ERROR-STATUS:ERROR THEN DO:
      RETURN.
   END.
END.

FIND FIRST CODE_mstr
   WHERE CODE_fldname = "SoftspeedSCM.Sync_Timeouts"
   AND CODE_value = ''
   NO-LOCK NO-ERROR.
IF AVAILABLE CODE_mstr THEN DO:
   ASSIGN timeouts = INTEGER(CODE_desc) NO-ERROR.
   IF NOT ERROR-STATUS:ERROR THEN DO:
      RETURN.
   END.
END.

timeouts = 30.

