/* SS - 090908.1 By: Bill Jiang */

/* SS - 090908.1 - RNB
[090908.1]

  <service>###Srv</service>
  <function>#####Func</function>
  <command>save</command>

  <datas>

[090908.1]

SS - 090908.1 - RNE */

{mfdeclre.i}

DEFINE VARIABLE indent AS INTEGER INITIAL 1.
DEFINE VARIABLE indent1 AS CHARACTER.

DEFINE BUFFER codemstr FOR CODE_mstr.

indent1 = FILL(' ',indent).

FOR EACH CODE_mstr NO-LOCK
   WHERE CODE_fldname = "SoftspeedSCM.XML"
   BY CODE_value
   :
   FIND FIRST codemstr
      WHERE codemstr.CODE_fldname = "SoftspeedSCM.XML." + execname
      AND codemstr.CODE_value = CODE_mstr.CODE_cmmt
      NO-LOCK NO-ERROR.
   IF AVAILABLE codemstr THEN DO:
      PUT UNFORMATTED indent1 + "<" + code_mstr.CODE_cmmt + ">".
      PUT UNFORMATTED codemstr.CODE_desc.
      PUT UNFORMATTED "</" + code_mstr.CODE_cmmt + ">" SKIP.

      NEXT.
   END.

   FIND FIRST codemstr
      WHERE ("SoftspeedSCM.XML." + execname) MATCHES codemstr.CODE_fldname
      AND codemstr.CODE_value = CODE_mstr.CODE_cmmt
      NO-LOCK NO-ERROR.
   IF AVAILABLE codemstr THEN DO:
      PUT UNFORMATTED indent1 + "<" + code_mstr.CODE_cmmt + ">".
      PUT UNFORMATTED codemstr.CODE_desc.
      PUT UNFORMATTED "</" + code_mstr.CODE_cmmt + ">" SKIP.

      NEXT.
   END.

   PUT UNFORMATTED indent1 + "<" + code_mstr.CODE_cmmt + ">".
   PUT UNFORMATTED code_mstr.CODE_desc.
   PUT UNFORMATTED "</" + code_mstr.CODE_cmmt + ">" SKIP.

   NEXT.
END.

PUT SKIP(1).
PUT UNFORMATTED indent1 + "<datas>" SKIP.

