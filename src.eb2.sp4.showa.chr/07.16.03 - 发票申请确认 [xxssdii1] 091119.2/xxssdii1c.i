/* SS - 090511.1 By: Bill Jiang */

/* SS - 090511.1 - RNB
CIM
SS - 090511.1 - RNE */

DO TRANSACTION ON STOP UNDO,LEAVE:
   DO i1 = 1 TO 2:
      INPUT FROM VALUE(infile[i1]).
      OUTPUT TO VALUE(outfile[i1]).
      {gprun.i ""soivmt.p""}
      INPUT CLOSE.
      OUTPUT CLOSE.

      /* Purchase Order */
      FOR EACH so_mstr EXCLUSIVE-LOCK
         WHERE /* so_domain = GLOBAL_domain
         AND */so_nbr = SoftspeedDI_so_pre[i1 + 2]
         :
         ASSIGN
            so_po = STRING(SoftspeedDI_inv)
            .
      END.

      for each tt2 :
        delete tt2 .
      end .
    
      INPUT FROM VALUE(SEARCH(outfile[i1])).
      REPEAT:
         CREATE tt2.
         IMPORT DELIMITER "`" tt2 NO-ERROR.
         IF RECID(tt2) = -1 THEN.
      END.
      INPUT CLOSE.

      i2 = 0.
      FOR EACH tt2:
         IF tt2_c1[1] BEGINS "错误:"  OR tt2_c1[1] BEGINS "ERROR:"  OR tt2_c1[1] BEGINS "岿粇:"  THEN DO:
            CREATE tt3.
            ASSIGN
               tt3_nbr = rqm_nbr
               tt3_part = rqd_part
               tt3_trnbr = tr_trnbr
               tt3_error = tt2_c1[1]
               .

            /* 不允许出错 */
            IF allow_errors =  "N" THEN DO:
               /* 日志文件 */
               IF INDEX("YE",audit_trail) <> 0 THEN DO:
                  IF LOG_infile[i1] <> infile[i1] THEN DO:
                     OS-COPY VALUE(infile[i1]) VALUE(LOG_infile[i1]).
                     OS-COPY VALUE(outfile[i1]) VALUE(LOG_outfile[i1]).

                     /* 删除临时文件 */
                     OS-DELETE VALUE(infile[i1]).
                     OS-DELETE VALUE(outfile[i1]).
                  END.
               END. /* IF INDEX("YE",audit_trail) <> 0 THEN DO: */
               i2 = i2 + 1.
               errcount = errcount + 1.
               STOP.
            END. /* IF allow_errors =  "N" THEN DO: */
            i2 = i2 + 1.
            errcount = errcount + 1.

            LEAVE.
         END. /* IF tt2_c1[1] BEGINS "错误:"   */
      END. /* FOR EACH tt2: */
      IF i2 = 0 THEN DO:
         recount = recount + 1.
      END.

      IF INDEX("Y",audit_trail) <> 0 THEN DO:
         IF LOG_infile[i1] <> infile[i1] THEN DO:
            OS-COPY VALUE(infile[i1]) VALUE(LOG_infile[i1]).
            OS-COPY VALUE(outfile[i1]) VALUE(LOG_outfile[i1]).

            /* 删除临时文件 */
            OS-DELETE VALUE(infile[i1]).
            OS-DELETE VALUE(outfile[i1]).
         END.
      END. /* IF INDEX("Y",audit_trail) <> 0 THEN DO: */
      ELSE DO:
         /* 删除临时文件 */
         OS-DELETE VALUE(infile[i1]).
         OS-DELETE VALUE(outfile[i1]).
      END.
   END. /* DO i1 = 1 TO 2: */

   {gprun.i ""xxssdii1d.p"" "(
      INPUT rqm_mstr.rqm_nbr,
      INPUT rqd_det.rqd_part,
      INPUT SoftspeedDI_so_pre[3],
      INPUT SoftspeedDI_inv_pre[3],
      INPUT SoftspeedDI_so_pre[4],
      INPUT SoftspeedDI_inv_pre[4]
      )"}

   IF show_email_ids = NO THEN DO:
      STOP.
   END.
END. /* DO TRANSACTION ON STOP UNDO: */
