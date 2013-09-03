/* 删除主文件 */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* 共享 */   
{xxssdim2s.i}

/* 选择条件 */
DEFINE INPUT PARAMETER nbr_rqm LIKE rqm_mstr.rqm_nbr.

DO TRANSACTION:
   FOR EACH rqd_det EXCLUSIVE-LOCK
      WHERE rqd_nbr = nbr_rqm
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

   find first rqm_mstr where rqm_nbr = nbr_rqm USE-INDEX rqm_nbr exclusive-lock no-error.
   if available rqm_mstr then do:
      delete rqm_mstr.
   end.
END.
