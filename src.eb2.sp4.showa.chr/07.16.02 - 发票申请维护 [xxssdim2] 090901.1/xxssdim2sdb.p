/* 
同步明细文件 - 批处理 
仅限于新增
*/

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* 共享 */   
{xxssdim2s.i}

/* 选择条件 */
DEFINE INPUT PARAMETER nbr_rqm LIKE rqm_mstr.rqm_nbr.

DEFINE VARIABLE LINE_rqd LIKE rqd_line.

DO TRANSACTION:
   LINE_rqd = 0.
   FOR EACH rqd_det EXCLUSIVE-LOCK
      WHERE rqd_nbr = nbr_rqm
      :
      LINE_rqd = MAX(LINE_rqd, rqd_line).
   END.

   FOR EACH tt1:
      FIND FIRST rqd_det 
         WHERE rqd_nbr = nbr_rqm
         AND rqd_part = STRING(tt1_SoftspeedDI_VAT)
         AND rqd_cmtindx = tt1_tr_trnbr
         EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE rqd_det THEN DO:
         LINE_rqd = LINE_rqd + 1.
         CREATE rqd_det.
         ASSIGN
            rqd_nbr = nbr_rqm
            rqd_line = LINE_rqd
            .
         ASSIGN
            rqd_part = STRING(tt1_SoftspeedDI_VAT)
            rqd_cmtindx = tt1_tr_trnbr
            rqd_req_qty = tt1_idh_qty_inv
            rqd_pur_cost = tt1_idh_price
            rqd_max_cost = tt1_qty_open
            .

         FOR EACH usrw_wkfl EXCLUSIVE-LOCK
            WHERE usrw_key1 = "SoftspeedDI_History"
            AND usrw_key2 = STRING(rqd_cmtindx)
            :
            ASSIGN
               usrw_decfld[3] = usrw_decfld[3] + rqd_req_qty /* - rqd_max_cost */
               usrw_decfld[4] = usrw_decfld[4] - rqd_req_qty /* + rqd_max_cost */
               .
         END.
      END.
   END. /* FOR EACH tt1: */
END.
