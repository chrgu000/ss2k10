/* 创建临时表 - 更新 */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* 共享 */   
{xxssirm2s.i}

/* 选择条件 */
DEFINE INPUT PARAMETER nbr_rqm LIKE rqm_mstr.rqm_nbr.

/* 共享 */
FOR EACH tt1:
    DELETE tt1 .
END.


FOR EACH rqm_mstr NO-LOCK
   WHERE /* rqm_domain = GLOBAL_domain
   AND */ rqm_nbr = nbr_rqm
   ,EACH rqd_det NO-LOCK
   WHERE /*  rqd_domain = GLOBAL_domain
   AND */ rqd_nbr = rqm_nbr
   ,EACH tr_hist NO-LOCK
   WHERE /* tr_domain = GLOBAL_domain
   AND */ tr_trnbr = rqd_cmtindx
   ,EACH so_mstr NO-LOCK
   WHERE /* so_domain = GLOBAL_domain
   /*
   AND so_inv_nbr = tr_rmks
   */
   AND */ so_nbr = tr_nbr
   ,EACH sod_det NO-LOCK
   WHERE /* sod_domain = GLOBAL_domain
   AND */ sod_nbr = so_nbr
   AND sod_line = tr_line
   :
   CREATE tt1.
   ASSIGN
      tt1_index = rqd_part + "." + STRING(tr_trnbr)
      tt1_SoftspeedIR_VAT = INTEGER(rqd_part)
      tt1_tr_trnbr = tr_trnbr
      tt1_tr_part = tr_part
      tt1_tr_effdate = tr_effdate
      tt1_sod_qty_inv = rqd_req_qty
      tt1_sod_price = sod_price
      tt1_so_inv_nbr = so_inv_nbr
      tt1_so_nbr = so_nbr
      tt1_sod_line = sod_line
      tt1_so_po = so_po
      tt1_sod_custpart = sod_custpart
      tt1_qty_open = rqd_req_qty
      tt1_qty_last = rqd_req_qty
      .
END.
