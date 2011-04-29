/* SS - 091014.1 By: Bill Jiang */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE OUTPUT PARAMETER SUM_lvl_apc LIKE apc_sum_lvl.

FIND FIRST apc_ctrl
   WHERE apc_domain = GLOBAL_domain
   NO-LOCK NO-ERROR.
IF AVAILABLE apc_ctrl THEN DO:
   SUM_lvl_apc = apc_sum_lvl.
   RETURN.
END.
