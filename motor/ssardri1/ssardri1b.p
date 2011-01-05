/* $Revision: 1.6.1.8 $    BY: Bill Jiang    DATE: 08/17/07   ECO: *SS - 20070817.1*  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE INPUT PARAMETER ar-bill LIKE ar_bill.
DEFINE INPUT PARAMETER ar-date LIKE ar_date.
DEFINE INPUT PARAMETER ar-user2 LIKE ar_user2.
DEFINE OUTPUT PARAMETER output-find LIKE mfc_logical.
DEFINE OUTPUT PARAMETER output-nbr LIKE ar_nbr.

FIND FIRST ar_mstr
   WHERE ar_domain = GLOBAL_domain
   AND ar_bill = ar-bill
   AND ar_date = ar-date
   AND (ar_type = "I" OR ar_type = "M")
   AND ar_user2 = ar-user2
   NO-LOCK
   NO-ERROR
   .

output-find = (AVAILABLE ar_mstr).

IF output-find THEN DO:
   output-nbr = ar_nbr.
END.
