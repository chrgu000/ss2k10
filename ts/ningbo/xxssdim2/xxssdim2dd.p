/* 删除明细文件 */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* 共享 */
{xxssdim2s.i}

/* 选择条件 */
DEFINE INPUT PARAMETER nbr_rqm LIKE rqm_mstr.rqm_nbr.
DEFINE INPUT PARAMETER part_rqd LIKE rqd_part.
DEFINE INPUT PARAMETER cmtindx_rqd LIKE rqd_cmtindx.

DO TRANSACTION:
   FOR EACH rqd_det EXCLUSIVE-LOCK
      WHERE rqd_domain = GLOBAL_domain
      AND rqd_nbr = nbr_rqm
      AND rqd_part = part_rqd
      AND rqd_cmtindx = cmtindx_rqd
      :
      FOR EACH usrw_wkfl EXCLUSIVE-LOCK
         WHERE usrw_domain = GLOBAL_domain
         AND usrw_key1 = "SoftspeedDI_History"
         AND usrw_key2 = STRING(rqd_cmtindx)
         :
         ASSIGN
            usrw_decfld[3] = usrw_decfld[3] - rqd_req_qty
            usrw_decfld[4] = usrw_decfld[4] + rqd_req_qty
            .
      END.
      DELETE rqd_det.
   END.
END.
