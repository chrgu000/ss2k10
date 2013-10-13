/* SS - 080807.1 By: Bill Jiang */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE INPUT PARAMETER ref_glt LIKE glt_ref.
DEFINE INPUT-OUTPUT PARAMETER user2_glt LIKE glt_user2.

FIND FIRST glt_det WHERE glt_domain = GLOBAL_domain AND glt_ref = ref_glt NO-LOCK NO-ERROR.
IF AVAILABLE glt_det THEN DO:
   user2_glt = glt_user2.
END.
