/* GUI CONVERTED from porcsubr.p (converter v1.69) Wed Aug 13 14:14:28 1997 */
/* porcsubr.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3   LAST MODIFIED: 10/31/94      BY: WUG *GN77*          */
/* REVISION: 7.3   LAST MODIFIED: 12/16/94      BY: WUG *G09J*          */
/* REVISION: 7.3   LAST MODIFIED: 02/28/95      BY: WUG *G0G2*          */
/* REVISION: 8.5   LAST MODIFIED: 10/13/95      BY: taf *J053*          */
/* REVISION: 7.3   LAST MODIFIED: 07/17/96      BY: emb *G29F*          */
/* REVISION: 8.5   LAST MODIFIED: 12/31/96 BY: *H0Q8* Julie Milligan    */
/* REVISION: 8.5   LAST MODIFIED: 08/12/97      BY: *G2P9*  Manmohan Pardesi  */

         /* REGISTER QUANTITIES PROCESSED FOR NEW REPETITIVE SUBCONTRACT */

         {mfdeclre.i}

         define shared workfile posub
            field posub_nbr as character
            field posub_line as integer
            field posub_qty as decimal
            field posub_wolot as character
            field posub_woop as integer
            field posub_gl_amt like glt_amt
            field posub_cr_acct as character
            field posub_cr_cc as character
            field posub_effdate as date
            field posub_move like mfc_logical.

         define new shared variable op_recno as recid.
         define new shared variable opgltype like opgl_type.
         define new shared variable ref like glt_ref.
         define new shared variable sf_cr_acct like dpt_lbr_acct.
         define new shared variable sf_cr_cc like dpt_lbr_cc.
         define new shared variable sf_dr_acct like dpt_lbr_acct.
         define new shared variable sf_dr_cc like dpt_lbr_cc.
         define new shared variable sf_entity like en_entity.
         define new shared variable sf_gl_amt like tr_gl_amt.

         define variable rtevar like glt_amt no-undo.
         define variable stdamt like glt_amt no-undo.
         define variable actamt like glt_amt no-undo.
         define variable trans_type as character init "SUBCNT" no-undo.
         define variable dept as character no-undo.
         define variable emp as character no-undo.
         define variable shift as character no-undo.
         define variable wr_recid as recid no-undo.
         define variable wo_recid as recid no-undo.
         define variable following_op_req_qty as decimal no-undo.
         define variable backflush_qty as decimal no-undo.
         define variable bomcode as character no-undo.
         define variable routecode as character no-undo.
         define variable oplist as character no-undo.
         define variable batchqty as decimal no-undo.
         define variable rejected like mfc_logical no-undo.
         define variable ophist_recid as recid no-undo.
         define variable lotserials_req like mfc_logical no-undo.
         define variable glx_mthd like cs_method no-undo.
         define variable glx_set like cs_set no-undo.
         define variable cur_mthd like cs_method no-undo.
         define variable cur_set like cs_set no-undo.
/*G09J*/ define variable do_zero_unissuable like mfc_logical init yes no-undo.
/*G29F*/ define variable move_ok like mfc_logical no-undo.
/*G2P9*/ define variable mess_desc as character no-undo.

/*G29F*/ {gpatrdef.i "new shared"}

         {rewrsdef.i}

         find first gl_ctrl no-lock.

         for each posub no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

            find wo_mstr where wo_lot = posub_wolot no-lock.
            find wr_route where wr_lot = posub_wolot
            and wr_op = posub_woop no-lock.

            /* DETERMINE COSTING METHOD */
            {gprun.i ""csavg01.p"" "(input wo_part, input wo_site,
            output glx_set, output glx_mthd, output cur_set, output cur_mthd)" }
/*GUI*/ if global-beam-me-up then undo, leave.


            dept = "".
            find wc_mstr where wc_wkctr = wr_wkctr
            and wc_mch = wr_mch no-lock no-error.
            if available wc_mstr then dept = wc_dept.

            /* ISSUE COMPONENTS */
            /*G09J ADDED do_zero_unissuable TO FOLLOWING CALL*/
            /*H0Q8 ADDED wr_wkctr TO FOLLOWING CALL */
            {gprun.i ""recrtcl.p""
            "(input posub_wolot, input posub_woop, input yes, input posub_qty,
              input posub_effdate, input do_zero_unissuable,
              input wr_wkctr,
              output rejected, output lotserials_req)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G2P9*  MOVED FOLLOWING CODE DOWN TO PREVENT ISSUE AND BACKFLUSH WHEN */
/*G2P9*  REJECTED = 'Yes' */
/*G2P9**
 *          {gprun.i ""rebkflis.p""
 *          "(input posub_wolot, input posub_effdate)"}
 *
 *          /* REGISTER QTY PROCESSED FOR NONMILESTONES */
 *          {gprun.i ""rebkflnm.p""
 *          "(input posub_wolot, input posub_woop, input posub_effdate,
 *            input shift, input trans_type, input posub_qty)"}
 *G2P9*  END OF MOVE */

            /* CREATE OP_HIST RECORD */
            {gprun.i ""reophist.p""
            "(input trans_type, input wo_lot, input wr_op, input emp,
              input wr_wkctr, input wr_mch, input dept, input shift,
              input posub_effdate,
              output ophist_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


               /* POST SUBCONTRACT EXPENSE */
               wo_recid = recid(wo_mstr).
               find wo_mstr where recid(wo_mstr) = wo_recid exclusive-lock.

               wr_recid = recid(wr_route).
               find wr_route where recid(wr_route) = wr_recid exclusive-lock.

               {rewrsget.i &lot=wr_lot &op=wr_op}

               stdamt = posub_qty * wr_sub_cost.

/*J053*/       /* ROUND STDAMT PER BASE CURRENCY ROUND METHOD */
/*J053*/       {gprun.i ""gpcurrnd.p"" "(input-output stdamt,
                                         input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               actamt = posub_gl_amt.
               if glx_mthd = "AVG" then stdamt = actamt.

               wo_wip_tot = wo_wip_tot + stdamt.

               assign
               wr_sub_std = wr_sub_std + stdamt
               wr_sub_act = wr_sub_act + actamt
               wr_sub_comp = wr_sub_comp + posub_qty.

               find si_mstr where si_site = wo_site no-lock.
               sf_entity = si_entity.

               opgltype = "SUB-2000".
               sf_dr_acct = wo_acct.
               sf_dr_cc = wo_cc.
               sf_cr_acct = posub_cr_acct.
               sf_cr_cc = posub_cr_cc.
               sf_gl_amt = stdamt.

               op_recno = ophist_recid.

               {gprun.i ""sfopgl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.



               /* POST SUBCONTRACT RATE VARIANCE */
               rtevar = actamt - stdamt.
               opgltype = "SUB-2001".
               sf_dr_acct = wo_svrr_acct.
               sf_dr_cc = wo_svrr_cc.
               sf_cr_acct = posub_cr_acct.
               sf_cr_cc = posub_cr_cc.
               sf_gl_amt = rtevar.

               op_recno = ophist_recid.

               {gprun.i ""sfopgl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


               find op_hist where recid(op_hist) = op_recno exclusive-lock.

               assign
               op_po_nbr = posub_nbr
               op_qty_comp = posub_qty
               op_sub_std = stdamt
               op_sub_cost = actamt
               .
            end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*G2P9*  REJECT FLAG INDICATES NON AVAILABILITY OR ISSUE RESTRICTION OF */
/*G2P9*  COMPONENTS; WITH G2P9 NO LONGER COMPONENTS ARE BACKFLUSHED OR PARENT */
/*G2P9*  QUANTITY RECEIVED OR OPERATION MOVE TAKES PLACE. */
/*G2P9*  BEGIN ADD SECTION */
            if rejected then do:
               mess_desc = '为采购单项目: ' + STRING(posub_line) + ' 累计标志: '
                        + posub_wolot + ' 工序: ' + STRING(posub_woop).
               if lotserials_req then do:
                  {mfmsg02.i 1119 4 mess_desc} /* LOT/SERIAL NUMBER REQUIRED */
               end.
               else do:
                  /* INVALID INVENTORY FOR BACKFLUSH */
                  {mfmsg02.i 1989 4 mess_desc}
               end.
               {mfmsg.i 1988 4} /* PLEASE BACKFLUSH COMPONENTS MANUALLY */
               if not batchrun then do on endkey undo, leave :
                  pause.
               end.
               undo, next.
            end.

            /* ISSUE COMPONENTS */
            {gprun.i ""rebkflis.p""
            "(input posub_wolot, input posub_effdate)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            /* REGISTER QTY PROCESSED FOR NONMILESTONES */
            {gprun.i ""rebkflnm.p""
            "(input posub_wolot, input posub_woop, input posub_effdate,
              input shift, input trans_type, input posub_qty)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G2P9*  END ADD SECTION */

            /* REGISTER QTY PROCESSED */
            {gprun.i ""rebkfla.p""
            "(input wr_lot, input wr_op, input op_recno, input posub_qty)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            /* MOVE NEXT OPERATION IF FLAGGED ON OPERATION */
            if posub_move then do:

               find first wr_route where wr_lot = posub_wolot
               and wr_op > posub_woop no-lock no-error.

               if available wr_route then do:
                  {gprun.i ""removea.p"" "(input posub_wolot, input posub_woop,
                   input posub_effdate, input ophist_recid, input op_qty_comp)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.

/*G29F*/       /* Added section */
               /* Receive to finished goods if last operation */
               else do:

                  /* Last operation so prepare to receive finished material
                  and make certain the receipt doesn't violate any rules */
                  {gprun.i ""porcsubs.p""
                  "(input posub_wolot, input op_qty_comp, output move_ok)" }
/*GUI*/ if global-beam-me-up then undo, leave.


                  if move_ok then do:
                     {gprun.i ""receive.p""
                     "(input posub_wolot,
                       input posub_effdate,
                       input ophist_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end.
                  else do:
                     /* Cannot move to finished goods. Use MOVE transaction */
                     {mfmsg.i 1357 4}
                  end.
               end.
/*G29F**/      /* End of added section */

            end.

            release wo_mstr.
            release wr_route.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.

