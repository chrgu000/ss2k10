/* sfacct02.p - CREATE GLTW_DET RECORDS FOR OPERATION ACCOUNTING REPORT */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.3            CREATED: 02/09/96   BY: rvw *G1MW*          */
/* REVISION: 7.3            CREATED: 08/12/05   BY: Bill Jiang *SS - 20050812*          */
/* SS - 20050812 - B */
{a6sfacrp01.i}
/* SS - 20050812 - E */
         {mfdeclre.i}

         define input parameter opgl_recid as recid.
         define input parameter op_recid as recid.

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
              /* SS - 20050812 - B */
              CREATE tta6sfacrp01.
              ASSIGN
                  tta6sfacrp01_acc = glt_acct
                  tta6sfacrp01_sub = glt_sub
                  tta6sfacrp01_ctr = glt_cc
                  tta6sfacrp01_amt = glt_amt
                  tta6sfacrp01_type = op_type
                  tta6sfacrp01_part = op_part
                  tta6sfacrp01_trnbr = op_trnbr
                  .
              /* SS - 20050812 - E */
           end.
           else do:
              find first gltr_hist where gltr_ref = opgl_gl_ref
                 and gltr_line = opgl_dr_line no-lock no-error.
              if available gltr_hist then do:
                 gltw_entity = gltr_entity.
                 /* SS - 20050812 - B */
                 CREATE tta6sfacrp01.
                 ASSIGN
                     tta6sfacrp01_acc = gltr_acc
                     tta6sfacrp01_sub = gltr_sub
                     tta6sfacrp01_ctr = gltr_ctr
                     tta6sfacrp01_amt = gltr_amt
                     tta6sfacrp01_type = op_type
                     tta6sfacrp01_part = op_part
                     tta6sfacrp01_trnbr = op_trnbr
                     .
                 /* SS - 20050812 - E */
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
                /* SS - 20050812 - B */
                CREATE tta6sfacrp01.
                ASSIGN
                    tta6sfacrp01_acc = glt_acct
                    tta6sfacrp01_sub = glt_sub
                    tta6sfacrp01_ctr = glt_cc
                    tta6sfacrp01_amt = glt_amt
                    tta6sfacrp01_type = op_type
                    tta6sfacrp01_part = op_part
                    tta6sfacrp01_trnbr = op_trnbr
                    .
                /* SS - 20050812 - E */
             end.
             else do:
                find first gltr_hist where gltr_ref = opgl_gl_ref
                   and gltr_line = opgl_cr_line no-lock no-error.
                if available gltr_hist then do:
                   gltw_entity = gltr_entity.
                   /* SS - 20050812 - B */
                   CREATE tta6sfacrp01.
                   ASSIGN
                       tta6sfacrp01_acc = gltr_acc
                       tta6sfacrp01_sub = gltr_sub
                       tta6sfacrp01_ctr = gltr_ctr
                       tta6sfacrp01_amt = gltr_amt
                       tta6sfacrp01_type = op_type
                       tta6sfacrp01_part = op_part
                       tta6sfacrp01_trnbr = op_trnbr
                       .
                   /* SS - 20050812 - E */
                end.
             end.

