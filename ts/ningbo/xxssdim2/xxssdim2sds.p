/* 同步明细文件 - 单记录 */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* 共享 */
{xxssdim2s.i}

/* 选择条件 */
DEFINE INPUT PARAMETER nbr_rqm LIKE rqm_mstr.rqm_nbr.
DEFINE INPUT PARAMETER rec_tt1 AS RECID.

DO TRANSACTION ON STOP UNDO:
   FIND FIRST tt1 WHERE
      RECID(tt1) = rec_tt1
      EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE tt1 THEN DO:
      STOP.
      RETURN.
   END.

   FIND FIRST rqd_det
      WHERE rqd_domain = GLOBAL_domain
      AND rqd_nbr = nbr_rqm
      AND rqd_part = STRING(tt1_SoftspeedDI_VAT)
      AND rqd_cmtindx = tt1_tr_trnbr
      EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE rqd_det THEN DO:
      STOP.
      RETURN.
   END.
   ASSIGN
      rqd_req_qty = tt1_idh_qty_inv
      rqd_max_cost = tt1_qty_last
      .

   FIND FIRST usrw_wkfl
      WHERE usrw_domain = GLOBAL_domain
      AND usrw_key1 = "SoftspeedDI_History"
      AND usrw_key2 = STRING(rqd_cmtindx)
      EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE usrw_wkfl THEN DO:
      STOP.
      RETURN.
   END.
   ASSIGN
      usrw_decfld[3] = usrw_decfld[3] + rqd_req_qty - rqd_max_cost
      usrw_decfld[4] = usrw_decfld[4] - rqd_req_qty + rqd_max_cost
      .

   ASSIGN
      tt1_qty_last = tt1_idh_qty_inv
      .
END.
