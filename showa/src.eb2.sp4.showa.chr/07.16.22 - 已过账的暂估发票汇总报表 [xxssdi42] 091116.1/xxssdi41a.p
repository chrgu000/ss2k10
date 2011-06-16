/* SS - 090508.1 By: Bill Jiang */

/* SS - 090508.1 - RNB
获得客户采购订单
SS - 090508.1 RNE */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* 选择条件 */
DEFINE INPUT PARAMETER inv_nbr_ih LIKE ih_inv_nbr.
DEFINE INPUT PARAMETER nbr_ih LIKE ih_nbr.
DEFINE OUTPUT PARAMETER po_ih LIKE ih_po.

FIND FIRST ih_hist 
   WHERE /* ih_domain = GLOBAL_domain
   AND */ ih_inv_nbr = inv_nbr_ih
   AND ih_nbr = nbr_ih
   NO-LOCK NO-ERROR.
IF AVAILABLE ih_hist THEN DO:
   po_ih = ih_po.
END.
ELSE DO:
   po_ih = "".
END.

