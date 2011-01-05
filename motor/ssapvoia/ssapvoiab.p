/* $Revision: 1.6.1.8 $    BY: vend Jiang    DATE: 08/26/07   ECO: *SS - 20070826.1*  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE INPUT PARAMETER ap-vend LIKE ap_vend.
DEFINE INPUT PARAMETER ap-date LIKE ap_date.
DEFINE INPUT PARAMETER ap-user2 LIKE ap_user2.
DEFINE OUTPUT PARAMETER output-find LIKE mfc_logical.
DEFINE OUTPUT PARAMETER output-ref LIKE ap_ref.

FIND FIRST ap_mstr
   WHERE ap_domain = GLOBAL_domain
   AND ap_vend = ap-vend
   AND ap_date = ap-date
   AND (ap_type = "VO")
   AND ap_user2 = ap-user2
   NO-LOCK
   NO-ERROR
   .

output-find = (AVAILABLE ap_mstr).

IF output-find THEN DO:
   output-ref = ap_ref.
END.
