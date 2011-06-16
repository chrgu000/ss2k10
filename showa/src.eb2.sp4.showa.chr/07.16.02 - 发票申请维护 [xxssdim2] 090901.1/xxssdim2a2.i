/* 创建 */

CREATE tt1.
ASSIGN
   tt1_index = STRING(SoftspeedDI_VAT) + "." + STRING(tr_trnbr)
   tt1_SoftspeedDI_VAT = SoftspeedDI_VAT
   tt1_tr_trnbr = tr_trnbr
   tt1_tr_part = tr_part
   tt1_tr_effdate = tr_effdate
   tt1_idh_qty_inv = qty_partial
   tt1_idh_price = idh_price
   tt1_ih_inv_nbr = ih_inv_nbr
   tt1_ih_nbr = ih_nbr
   tt1_idh_line = idh_line
   tt1_ih_po = ih_po
   tt1_idh_custpart = idh_custpart
   tt1_qty_open = qty_partial
   tt1_qty_last = qty_partial
   .

amt_acc = amt_acc + qty_partial * idh_price.

/* 在发票限额容差范围内,下一个发票备注 */
IF amt_max - amt_acc <= amt_tol THEN DO:
   amt_acc = 0.
   /* 下一个发票备注 */
   {xxssdim2a1.i}
END.

