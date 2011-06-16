/* 创建临时表 - 更新 */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* 共享 */   
{xxssdim2s.i}

/* 选择条件 */
DEFINE INPUT PARAMETER nbr_rqm LIKE rqm_mstr.rqm_nbr.

/* 共享 */
/* ss - 090901.1 -b */
for each  tt1 :
delete tt1 .
end .
/* ss - 090901.1 -e */

FOR EACH rqm_mstr NO-LOCK
   WHERE rqm_nbr = nbr_rqm
   ,EACH rqd_det NO-LOCK
   WHERE rqd_nbr = rqm_nbr
   ,EACH tr_hist NO-LOCK
   WHERE tr_trnbr = rqd_cmtindx
   ,EACH ih_hist NO-LOCK
   WHERE ih_inv_nbr = tr_rmks
   AND ih_nbr = tr_nbr
   ,EACH idh_hist NO-LOCK
   WHERE idh_inv_nbr = ih_inv_nbr
   AND idh_nbr = ih_nbr
   AND idh_line = tr_line
   :
   CREATE tt1.
   ASSIGN
      tt1_index = rqd_part + "." + STRING(tr_trnbr)
      tt1_SoftspeedDI_VAT = INTEGER(rqd_part)
      tt1_tr_trnbr = tr_trnbr
      tt1_tr_part = tr_part
      tt1_tr_effdate = tr_effdate
      tt1_idh_qty_inv = rqd_req_qty
      tt1_idh_price = idh_price
      tt1_ih_inv_nbr = ih_inv_nbr
      tt1_ih_nbr = ih_nbr
      tt1_idh_line = idh_line
      tt1_ih_po = ih_po
      tt1_idh_custpart = idh_custpart
      tt1_qty_open = rqd_req_qty
      tt1_qty_last = rqd_req_qty
      .
END.
