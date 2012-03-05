/* sfacct02.p - CREATE GLTW_DET RECORDS FOR OPERATION ACCOUNTING REPORT */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.3            CREATED: 02/09/96   BY: rvw *G1MW*          */
/* REVISION: 7.3            CREATED: 08/24/05   BY: Bill Jiang *SS - 20050824*          */
/* SS - 20050824 - B */
{a6sfacrp0102.i}
/* SS - 20050824 - E */
         {mfdeclre.i}

         define input parameter opgl_recid as recid.
         define input parameter op_recid as recid.

         /* SS - 20050824 - B */
define input parameter acct like glt_acct.
define input parameter acct1 like glt_acct.
define input parameter cc like glt_cc.
define input parameter cc1 like glt_cc.
define input parameter proj like glt_project.
define input parameter proj1 like glt_project.
/* SS - 20050824 - E */

         find opgl_det where recid(opgl_det) = opgl_recid no-lock.
         find op_hist where recid(op_hist) = op_recid no-lock.

         /*GET NEXT UNIQUE LINE NUMBER BASED ON REF NUMBER */
         {gpnextln.i &ref=opgl_gl_ref &line=return_int}

         create gltw_wkfl.
         assign
           gltw_acct = opgl_dr_acct
           gltw_cc = opgl_dr_cc
           gltw_project = opgl_dr_proj
           gltw_ref = opgl_gl_ref
           gltw_line= return_int      /*set by gpnextln.i*/
           gltw_date = op_tran_date
           gltw_effdate = op_date
           gltw_userid = mfguser
           gltw_desc = op_wo_nbr + " " + op_wo_lot + " " + string(op_wo_op).

           recno = recid(gltw_wkfl).
           gltw_amt = opgl_gl_amt.

           find first glt_det where glt_ref = opgl_gl_ref
              and glt_line = opgl_dr_line no-lock no-error.
           if available glt_det then do:
              gltw_entity = glt_entity.
              /* SS - 20050824 - B */
              IF (
                   (opgl_dr_acct >= acct and opgl_dr_acct <= acct1)
                    or (acct1 = "")
                  )
              and (
                   (opgl_dr_cc >= cc and opgl_dr_cc <= cc1)
                    or (cc1 = "")
                   )
              and (
                   (opgl_dr_proj >= proj and opgl_dr_proj <= proj1)
                    or (proj1 = "")
                   ) THEN DO:
                  FOR FIRST tta6sfacrp0102
                      WHERE tta6sfacrp0102_part = op_part
                      AND tta6sfacrp0102_site = op_site
                      AND tta6sfacrp0102_wo_nbr = op_wo_nbr
                      AND tta6sfacrp0102_wo_lot = op_wo_lot
                      NO-LOCK:
                  END.
                  IF AVAILABLE tta6sfacrp0102 THEN DO:
                      ASSIGN 
                          tta6sfacrp0102_amt = tta6sfacrp0102_amt + glt_amt
                          .
                  END.
                  ELSE DO:
                      CREATE tta6sfacrp0102.
                      ASSIGN
                          tta6sfacrp0102_part = op_part
                          tta6sfacrp0102_site = op_site
                          tta6sfacrp0102_wo_nbr = op_wo_nbr
                          tta6sfacrp0102_wo_lot = op_wo_lot
                          .
                      ASSIGN 
                          tta6sfacrp0102_amt = tta6sfacrp0102_amt + glt_amt
                          .
                  END.
              END.
              /* SS - 20050824 - E */
           end.
           else do:
              find first gltr_hist where gltr_ref = opgl_gl_ref
                 and gltr_line = opgl_dr_line no-lock no-error.
              if available gltr_hist then do:
                 gltw_entity = gltr_entity.
                 /* SS - 20050824 - B */
                 IF (
                      (opgl_dr_acct >= acct and opgl_dr_acct <= acct1)
                       or (acct1 = "")
                     )
                 and (
                      (opgl_dr_cc >= cc and opgl_dr_cc <= cc1)
                       or (cc1 = "")
                      )
                 and (
                      (opgl_dr_proj >= proj and opgl_dr_proj <= proj1)
                       or (proj1 = "")
                      ) THEN DO:
                     FOR FIRST tta6sfacrp0102
                         WHERE tta6sfacrp0102_part = op_part
                         AND tta6sfacrp0102_site = op_site
                         AND tta6sfacrp0102_wo_nbr = op_wo_nbr
                         AND tta6sfacrp0102_wo_lot = op_wo_lot
                         NO-LOCK:
                     END.
                     IF AVAILABLE tta6sfacrp0102 THEN DO:
                         ASSIGN 
                             tta6sfacrp0102_amt = tta6sfacrp0102_amt + gltr_amt
                             .
                     END.
                     ELSE DO:
                         CREATE tta6sfacrp0102.
                         ASSIGN
                             tta6sfacrp0102_part = op_part
                             tta6sfacrp0102_site = op_site
                             tta6sfacrp0102_wo_nbr = op_wo_nbr
                             tta6sfacrp0102_wo_lot = op_wo_lot
                             .
                         ASSIGN 
                             tta6sfacrp0102_amt = tta6sfacrp0102_amt + gltr_amt
                             .
                     END.
                 END.
                 /* SS - 20050824 - E */
              end.
           end.

           /*GET NEXT UNIQUE LINE NUMBER BASED ON REF NUMBER */
           {gpnextln.i &ref=opgl_gl_ref &line=return_int}
           create gltw_wkfl.
           assign
             gltw_acct = opgl_cr_acct
             gltw_cc = opgl_cr_cc
             gltw_project = opgl_cr_proj
             gltw_ref = opgl_gl_ref
             gltw_line= return_int           /*set by gpnextln.i*/
             gltw_date = op_tran_date
             gltw_effdate = op_date
             gltw_userid = mfguser
             gltw_desc = op_wo_nbr + " " + op_wo_lot + " " + string(op_wo_op).
             recno = recid(gltw_wkfl).
             gltw_amt = - opgl_gl_amt.
             find first glt_det where glt_ref = opgl_gl_ref
                and glt_line = opgl_cr_line no-lock no-error.
             if available glt_det then do:
                gltw_entity = glt_entity.
                /* SS - 20050824 - B */
                IF (
                     (opgl_cr_acct >= acct and opgl_cr_acct <= acct1)
                      or (acct1 = "")
                    )
                and (
                     (opgl_cr_cc >= cc and opgl_cr_cc <= cc1)
                      or (cc1 = "")
                     )
                and (
                     (opgl_cr_proj >= proj and opgl_cr_proj <= proj1)
                      or (proj1 = "")
                     ) THEN DO:
                    FOR FIRST tta6sfacrp0102
                        WHERE tta6sfacrp0102_part = op_part
                        AND tta6sfacrp0102_site = op_site
                        AND tta6sfacrp0102_wo_nbr = op_wo_nbr
                        AND tta6sfacrp0102_wo_lot = op_wo_lot
                        NO-LOCK:
                    END.
                    IF AVAILABLE tta6sfacrp0102 THEN DO:
                        ASSIGN 
                            tta6sfacrp0102_amt = tta6sfacrp0102_amt + glt_amt
                            .
                    END.
                    ELSE DO:
                        CREATE tta6sfacrp0102.
                        ASSIGN
                            tta6sfacrp0102_part = op_part
                            tta6sfacrp0102_site = op_site
                            tta6sfacrp0102_wo_nbr = op_wo_nbr
                            tta6sfacrp0102_wo_lot = op_wo_lot
                            .
                        ASSIGN 
                            tta6sfacrp0102_amt = tta6sfacrp0102_amt + glt_amt
                            .
                    END.
                END.
                /* SS - 20050824 - E */
             end.
             else do:
                find first gltr_hist where gltr_ref = opgl_gl_ref
                   and gltr_line = opgl_cr_line no-lock no-error.
                if available gltr_hist then do:
                   gltw_entity = gltr_entity.
                   /* SS - 20050824 - B */
                IF (
                     (opgl_cr_acct >= acct and opgl_cr_acct <= acct1)
                      or (acct1 = "")
                    )
                and (
                     (opgl_cr_cc >= cc and opgl_cr_cc <= cc1)
                      or (cc1 = "")
                     )
                and (
                     (opgl_cr_proj >= proj and opgl_cr_proj <= proj1)
                      or (proj1 = "")
                     ) THEN DO:
                       FOR FIRST tta6sfacrp0102
                           WHERE tta6sfacrp0102_part = op_part
                           AND tta6sfacrp0102_site = op_site
                           AND tta6sfacrp0102_wo_nbr = op_wo_nbr
                           AND tta6sfacrp0102_wo_lot = op_wo_lot
                           NO-LOCK:
                       END.
                       IF AVAILABLE tta6sfacrp0102 THEN DO:
                           ASSIGN 
                               tta6sfacrp0102_amt = tta6sfacrp0102_amt + gltr_amt
                               .
                       END.
                       ELSE DO:
                           CREATE tta6sfacrp0102.
                           ASSIGN
                               tta6sfacrp0102_part = op_part
                               tta6sfacrp0102_site = op_site
                               tta6sfacrp0102_wo_nbr = op_wo_nbr
                               tta6sfacrp0102_wo_lot = op_wo_lot
                               .
                           ASSIGN 
                               tta6sfacrp0102_amt = tta6sfacrp0102_amt + gltr_amt
                               .
                       END.
                   END.
                   /* SS - 20050824 - E */
                end.
             end.

