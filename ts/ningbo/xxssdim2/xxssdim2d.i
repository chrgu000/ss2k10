/* 以下为版本历史 */
/* SS - 090511.1 By: Bill Jiang */

/* 显示 */

FIND FIRST pt_mstr WHERE pt_part = tt1_tr_part NO-LOCK NO-ERROR.
IF AVAILABLE pt_mstr THEN DO:
   DISP
      tt1_index @ INDEX_tt1
      pt_desc1 @ tt1_pt_desc1
      pt_desc2 @ tt1_pt_desc2

      tt1_ih_po
      tt1_idh_custpart

      tt1_ih_inv_nbr
      tt1_ih_nbr
      tt1_idh_line

      tt1_qty_open
      tt1_idh_price

      tt1_idh_qty_inv @ idh_qty_inv_tt1
      WITH FRAME match_maintenance .
END.
ELSE DO:
   DISP
      tt1_index @ INDEX_tt1
      '' @ tt1_pt_desc1
      '' @ tt1_pt_desc2

      tt1_ih_po
      tt1_idh_custpart

      tt1_ih_inv_nbr
      tt1_ih_nbr
      tt1_idh_line

      tt1_qty_open
      tt1_idh_price

      tt1_idh_qty_inv @ idh_qty_inv_tt1
      WITH FRAME match_maintenance .
END.
