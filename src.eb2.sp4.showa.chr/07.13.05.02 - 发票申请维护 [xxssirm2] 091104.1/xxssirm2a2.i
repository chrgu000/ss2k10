/* 创建 */

CREATE tt1.
ASSIGN
   tt1_index = STRING(SoftspeedIR_VAT) + "." + STRING(tr_trnbr)
   tt1_SoftspeedIR_VAT = SoftspeedIR_VAT
   tt1_tr_trnbr = tr_trnbr
   tt1_tr_part = tr_part
   tt1_tr_effdate = tr_effdate
   tt1_sod_qty_inv = qty_partial
   tt1_sod_price = sod_price
   tt1_so_inv_nbr = so_inv_nbr
   tt1_so_nbr = so_nbr
   tt1_sod_line = sod_line
   tt1_so_po = so_po
   tt1_sod_custpart = sod_custpart
   tt1_qty_open = qty_partial
   tt1_qty_last = qty_partial
   .

amt_acc = amt_acc + qty_partial * sod_price.

/* 在发票限额容差范围内,下一个发票备注 */
IF amt_max - amt_acc <= amt_tol THEN DO:
   amt_acc = 0.
   /* 下一个发票备注 */
   {xxssirm2a1.i}
END.

