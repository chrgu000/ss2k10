/* 以下为版本历史 */                                                             
/* SS - 090927.1 By: Bill Jiang */

/* 显示 */

FIND FIRST pt_mstr WHERE pt_part = tt1_tr_part NO-LOCK NO-ERROR.
IF AVAILABLE pt_mstr THEN DO:
   DISP 
      tt1_index @ INDEX_tt1
      pt_desc1 @ tt1_pt_desc1
      pt_desc2 @ tt1_pt_desc2

      tt1_so_po
      tt1_sod_custpart

      tt1_so_inv_nbr
      tt1_so_nbr
      tt1_sod_line

      tt1_qty_open
      tt1_sod_price

      tt1_sod_qty_inv @ sod_qty_inv_tt1
      WITH FRAME match_maintenance .
END.
ELSE DO:
   DISP 
      tt1_index @ INDEX_tt1
      '' @ tt1_pt_desc1
      '' @ tt1_pt_desc2

      tt1_so_po
      tt1_sod_custpart

      tt1_so_inv_nbr
      tt1_so_nbr
      tt1_sod_line

      tt1_qty_open
      tt1_sod_price

      tt1_sod_qty_inv @ sod_qty_inv_tt1
      WITH FRAME match_maintenance .
END.
