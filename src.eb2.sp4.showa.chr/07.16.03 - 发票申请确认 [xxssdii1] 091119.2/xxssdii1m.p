/* SS - 090511.1 By: Bill Jiang */

/* SS - 090511.1 - RNB
更新主文件
SS - 090511.1 - RNE */

{mfdeclre.i}
/* EXTERNALIZED LABEL INCLUDE */
{gplabel.i}
{pxmaint.i}

define INPUT PARAMETER nbr_rqm like rqm_mstr.rqm_nbr no-undo.

FIND FIRST rqd_det 
   WHERE  rqd_nbr = nbr_rqm
   AND rqd_open = NO
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE rqd_det THEN DO:
   FIND FIRST rqm_mstr
      WHERE  rqm_mstr.rqm_nbr = nbr_rqm
      EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE rqm_mstr THEN DO:
      /* 已结 */
      ASSIGN
         rqm_open = YES
         .
      RELEASE rqm_mstr.
   END.
END.
