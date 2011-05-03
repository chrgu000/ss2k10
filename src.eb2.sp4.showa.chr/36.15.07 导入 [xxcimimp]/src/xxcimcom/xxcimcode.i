/* SS - 081222.1 By: Bill Jiang */

/* SS - 081222.1 - B */
/*
获得当前执行文件的通用代码值
{1} code_fldname
{2} variable
{3} default
*/
/* SS - 081222.1 - E */

FIND FIRST CODE_mstr
   WHERE CODE_fldname = {1}
   AND CODE_value = execname
   NO-LOCK NO-ERROR.
IF AVAILABLE CODE_mstr THEN DO:
   {2} = CODE_cmmt.
END.
ELSE DO:
   FIND FIRST CODE_mstr
      WHERE CODE_fldname = {1}
      AND CODE_value = "*"
      NO-LOCK NO-ERROR.
   IF AVAILABLE CODE_mstr THEN DO:
      {2} = CODE_cmmt.
   END.
   ELSE DO:
      {2} = {3}.
   END.
END.
