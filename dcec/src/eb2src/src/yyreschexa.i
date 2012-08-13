/* reschexa.i - REPETITIVE SELECTIVELY EXPLODE THE REPETITIVE SCHEDULE        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.3.3.2 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* Revision: 1.2         BY: Sandeep Parab  DATE: 04/29/02  ECO: *N1HM*       */
/* Revision: 1.3         BY: Vivek Gogte    DATE: 02/17/03  ECO: *N27D*       */
/* Revision: 1.3.3.1     BY: Kirti Desai    DATE: 01/21/04  ECO: *P1KQ*       */
/* $Revision: 1.3.3.2 $  BY: Mandar Gawde   DATE: 03/24/04  ECO: *P1VL*       */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ARGUMENT PASSED ARE &where_condition AND &use_index                        */

define buffer b_next_wr_route for wr_route.
define buffer b_rpsmstr       for rps_mstr.

/* WHEN ITEM NUMBER IS LEFT BLANK IN SELECTION CRITERIA, THE FOR EACH BLOCK   */
/* WITH EXCLUSIVE LOCK CAUSE A SEQUENTIAL SEARCH ON b_rps_mstr AND WAITS FOR  */
/* UNREQUIRED RECORDS TO RELEASE. HENCE, EXCLUSIVE-LOCK IS CHANGED TO NO-LOCK */
/* ON rps_mstr AND SEARCH ON BUFFER b_rpsmstr WITH EXCLUSIVE LOCK IS          */
/* INTRODUCED INSIDE FOR EACH rps_mstr BLOCK                                  */

for each rps_mstr
   fields(rps_bom_code rps_due_date rps_line rps_part rps_qty_comp
          rps_qty_req rps_record rps_rel_date rps_routing rps_site)
   where {&where_condition}
   {&use_index}
   no-lock
   break by rps_part
         by rps_site
         by rps_line
         by rps_due_date
   with frame b width 132 no-attr-space no-box:

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame b:handle).

   for first b_rpsmstr
      where recid(b_rpsmstr) = recid(rps_mstr)
      exclusive-lock:
   end. /* FOR FIRST b_rpsmstr */

   /* REAPPLY CUM COMPLETED TO SCHEDULE */
   if first-of(rps_line)
   then do:

      /* REAPPLY CUM COMPLETED TO THE REPETITIVE SCHEDULE */
      {gprun.i ""rerpmtb.p""
         "(input rps_part,
           input rps_site,
           input rps_line)"}

   end. /* IF FIRST-OF(rps_line) */

   /* CONVERT DATE VARIABLE TO BE STRING OF FORMAT YYYYMMDD */
   {dateconv.i rps_due_date rpsnbr}
   rpsnbr = rpsnbr + rps_site.

   /* CANCEL MRP SUPPLY AND SCRAP - DELETE MRP WORKFILE RECORD */
   {mfmrwdel.i "rps_mstr"  rps_part rpsnbr string(rps_record) """"}
   {mfmrwdel.i "rps_scrap" rps_part rpsnbr string(rps_record) """"}

   if first-of(rps_line)
   then do:

      /* GATHER WIP QTIES AND STORE IN QAD_WKFL. */
      /* LATER ON WE REDUCE THE WIP QTY AS WE    */
      /* APPLY IT TO OPEN WO ROUTING OPS.        */
      key2 = rps_part + "/" +
             rps_site + "/" +
             rps_line + "/".

      /* INITIALIZE WIP QTIES */
      for each qad_wkfl
         where qad_key1 = "rps_mstr"
         and   qad_key2 begins key2
         exclusive-lock:
         qad_decfld[1] = 0.
      end. /* FOR EACH qad_wkfl */

      /* GATHER WIP QTIES */
      for each wo_mstr
         fields(wo_type wo_part wo_site wo_line wo_status wo_lot)
         where wo_type   = "C"
         and   wo_part   = rps_part
         and   wo_site   = rps_site
         and   wo_line   = rps_line
         and   wo_status = "r"
         no-lock,
         each wr_route
            fields(wr_qty_outque wr_qty_rejque wr_lot wr_op)
            where wr_lot = wo_lot
            no-lock:

            assign
               wip_qty    = wr_qty_outque + wr_qty_rejque
               l_qad_key2 = key2 + string(wr_op).

            for first b_next_wr_route
               fields (wr_qty_inque wr_lot wr_op)
               where b_next_wr_route.wr_lot = wr_route.wr_lot
               and   b_next_wr_route.wr_op  > wr_route.wr_op
               no-lock:
               wip_qty = wip_qty + b_next_wr_route.wr_qty_inque.
            end. /* FOR FIRST b_next_wr_route */

            for first qad_wkfl
               where qad_key1 = "rps_mstr"
               and   qad_key2 = l_qad_key2
               exclusive-lock:
            end. /* FOR EACH qad_wkfl */

            if not available qad_wkfl
            then do:

               create qad_wkfl.
               assign
                  qad_key1 = "rps_mstr"
                  qad_key2 = l_qad_key2.

               if recid(qad_wkfl) = -1
               then .

            end. /* IF NOT AVAILABLE qad_wkfl */

            qad_decfld[1] = qad_decfld[1] + wip_qty.
            release qad_wkfl.

      end. /* FOR EACH wo_mstr */

   end. /* IF FIRST-OF(rps_line) */

   /* DELETE THE SCHEDULE WORK ORDER IF THERE IS ONE */
   l_rps_record = string(rps_record).
   for first wo_mstr
      fields(wo_acct wo_bom_code wo_cc wo_due_date wo_flr_acct wo_flr_cc
             wo_flr_sub wo_line wo_lot wo_lot_rcpt wo_mvar_acct wo_mvar_cc
             wo_mvar_sub wo_mvrr_acct wo_mvrr_cc wo_mvrr_sub wo_nbr wo_ord_date
             wo_part wo_qty_comp wo_qty_ord wo_rctstat wo_rctstat_active
             wo_rel_date wo_routing wo_site wo_status wo_sub wo_svar_acct
             wo_svar_cc wo_svar_sub wo_svrr_acct wo_svrr_cc wo_svrr_sub
             wo_type wo_xvar_acct wo_xvar_cc wo_xvar_sub wo_yield_pct)
      where wo_lot    = l_rps_record
      and   wo_part   = rps_part
      and   wo_site   = rps_site
      and   wo_line   = rps_line
      and   wo_type   = "s"
      and   wo_status = "e"
      use-index wo_lot
      no-lock:
   end. /* FOR FIRST wo_mstr */

   if  available wo_mstr
   and rps_qty_req <= rps_qty_comp
   then do:

      assign
         wo_recno    = recid(wo_mstr)
         prev_status = wo_status
         prev_qty    = wo_qty_ord.

      /* DELETE WORK ORDER SUBROUTINE */
      {gprun.i ""wowomtd.p""}

   end. /* IF AVAILABLE wo_mstr ... */

   for first pt_mstr
      fields(pt_abc pt_avg_int pt_bom_code pt_cyc_int pt_desc1 pt_desc2
             pt_insp_lead pt_insp_rqd pt_joint_type pt_loc pt_mfg_lead
             pt_mrp pt_network pt_op_yield pt_ord_max pt_ord_min pt_ord_mult
             pt_ord_per pt_ord_pol pt_ord_qty pt_part pt_plan_ord pt_pm_code
             pt_prod_line pt_pur_lead pt_rctpo_active pt_rctpo_status
             pt_rctwo_active pt_rctwo_status pt_routing pt_sfty_time
             pt_timefence pt_um pt_yield_pct)
      where pt_part = rps_part
      no-lock:
   end. /* FOR FIRST pt_mstr */

   /* BUILD NEW SCHEDULE WORK ORDER IF WE NEED TO */
   if rps_qty_req > rps_qty_comp
   then do:

      assign
         bom_code = ""
         routing  = "".

      for first ptp_det
         fields(ptp_bom_code ptp_mfg_lead ptp_routing
                ptp_op_yield ptp_yld_pct)
         where ptp_part = rps_part
         and   ptp_site = rps_site
         no-lock:

         assign
            yield_pct    = ptp_yld_pct
            use_op_yield = ptp_op_yield
            mfg_lead     = ptp_mfg_lead
            routing      = if   ptp_routing > ""
                           then ptp_routing
                           else ""
            bom_code     = if   ptp_bom_code > ""
                           then ptp_bom_code
                           else "".

      end. /* FOR FIRST ptp_det */

      if not available ptp_det
      then
         assign
            yield_pct    = pt_yield_pct
            use_op_yield = pt_op_yield
            mfg_lead     = pt_mfg_lead
            routing      = if   pt_routing > ""
                           then pt_routing
                           else ""
            bom_code     = if   pt_bom_code > ""
                           then pt_bom_code
                           else "".

      if not available wo_mstr
      then do:

         repeat on error undo, retry:

            /* GET NEXT SEQUENCE NUMBER - UPDATE */
            {mfnxtsq.i wo_mstr wo_lot woc_sq01 wolot}
            release woc_ctrl.

            create wo_mstr.
            assign
               wo_lot    = wolot
               wo_part   = rps_part
               wo_nbr    = rps_part
               wo_type   = "s"
               wo_status = "e"
               wo_line   = rps_line
               wo_site   = rps_site.

            for first woc_ctrl
               fields (woc_var)
            no-lock:
               wo_var = woc_var.
            end. /* FOR FIRST woc_ctrl ... */

            if recid(wo_mstr) = -1
            then .

            /* UPDATE THE WORK ORDER ACCOUNTS */
            if available pt_mstr
            then do:

               for first in_mstr
                  fields(in_abc in_avg_int in_cur_set in_cyc_int
                         in_gl_cost_site in_gl_set in_level in_mrp in_part
                         in_qty_ord in_rctpo_active in_rctpo_status
                         in_rctwo_active in_rctwo_status in_site)
                  where in_part = wo_part
                  and   in_site = wo_site
                  no-lock:
               end. /* FOR FIRST in_mstr */

               /* ASSIGN DEFAULT RECEIPT STATUS AND ACTIVE FLAG */
               {pxrun.i &PROC    = 'assign_default_wo_rctstat'
                        &PROGRAM = 'wocmnrtn.p'
                        &HANDLE  = ph_wocmnrtn
                        &PARAM   = "(buffer in_mstr,
                                     buffer pt_mstr,
                                     output wo_rctstat,
                                     output wo_rctstat_active,
                                     output l_errorno)"}

               /* ASSIGN DEFAULT VARIANCE ACCOUNT  */
               /* SUB-ACCOUNT AND COST CENTER CODE */
               run assign_default_wo_acct (buffer wo_mstr,
                                           input  pt_prod_line).

            end. /* IF AVAILABLE pt_mstr */

            /* UPDATE REPETITIVE SCHEDULE RECORD */
            rps_record = integer(wo_lot).

            leave.
         end. /* REPEAT ON ERROR UNDO, RETRY */

      end. /* IF NOT AVAILABLE wo_mstr */

      /* CALCULATE NEEDED CHANGES TO in_mstr QUANTITY ON ORDER */

      /* THE QUANTITY PREVIOUSLY REMAINING IN in_qty_ord */
      if wo_qty_ord >= 0
      then
         qty_open = max(wo_qty_ord - max(wo_qty_comp,0),0).
      else
         qty_open = min(wo_qty_ord - min(wo_qty_comp,0),0).

      /* THE NEW QUANTITY WHICH SHOULD BE IN in_qty_ord */
      if rps_qty_req >= 0
      then
         qty_open = max(rps_qty_req - max(rps_qty_comp,0),0) - qty_open.
      else
         qty_open = min(rps_qty_req - min(rps_qty_comp,0),0) - qty_open.

      /* THE DIFFERENCE BETWEEN PREVIOUS AND NEW QUANTITY */
      /* OPEN GETS POSTED AGAINST THE in_mstr RECORD      */
      if qty_open <> 0
      then do:

         for first in_mstr
            where in_part = wo_part
            and   in_site = wo_site
            exclusive-lock:
            in_qty_ord = in_qty_ord + qty_open.
         end. /* FOR FIRST in_mstr */
         release in_mstr.

      end. /* IF qty_open <> 0 */

      wo_recno = recid(wo_mstr).
      find wo_mstr
         where recid(wo_mstr) = wo_recno
         exclusive-lock no-error.

      assign
         wo_ord_date  = today
         wo_due_date  = rps_due_date
         wo_qty_ord   = rps_qty_req
         wo_qty_comp  = rps_qty_comp
         wo_routing   = if rps_routing <> ""
                        then rps_routing
                        else routing
         wo_bom_code  = if rps_bom_code <> ""
                        then rps_bom_code
                        else bom_code
         wo_yield_pct = yield_pct
         wo_lot_rcpt  = clc_ctrl.clc_relot_rcpt
         wo_rel_date  = ?.

      /* CALCULATE DUE OR RELEASE DATE */
      {mfdate.i wo_rel_date wo_due_date mfg_lead wo_site}

      /* DETERMINE IF OPERATION YIELD IS NEEDED, AND IF SO OVERRIDE  */
      /* wo_yield_pct.                                               */
      /* IF GLOBAL SWITCH FOR OPERATIONAL YIELD IS NO, SET LOCAL     */
      /* SWITCH TO NO                                                */

      if (available mrpc_ctrl
      and mrpc_ctrl.mrpc_op_yield = no)
      or  not available mrpc_ctrl
      then
         use_op_yield = no.

      if use_op_yield
      then do:

         /* LOAD TEMP TABLE WITH THIS ITEM'S ROUTING DATA */
         run ip-load-routing-temp-table
            (input if   wo_routing <> ""
                   then wo_routing
                   else wo_part).

         /* CALL INTERNAL PROCEDURE TO CALCULATE YIELD */
         /* PASS ALL 9'S FOR OPERATION SO ALL ARE USED */

         v-op = 999999999.
         run ip-get-yield
            (input  if   wo_routing <> ""
                    then wo_routing
                    else wo_part,
             input  v-op,
             input  wo_rel_date,
             output yield_pct).

         wo_yield_pct = yield_pct.

      end.  /* IF use_op_yield */

      /* CHANGED PRE-PROCESSOR TO TERM: REPETITIVE_SCHEDULE */
      {mfmrw.i "wo_mstr" wo_part wo_nbr wo_lot """" wo_rel_date
         wo_due_date "wo_qty_ord - wo_qty_comp"
         "SUPPLYF" REPETITIVE_SCHEDULE wo_site}

      /* CHANGED PRE-PROCESSOR TO TERM: SCRAP_REQUIREMENT */
      /* MAKE THE EXPECTED SCRAP BE VISIBLE TO MRP        */
      {mfmrw.i "wo_scrap" wo_part wo_nbr wo_lot """"
         wo_rel_date wo_due_date
         "(wo_qty_ord - wo_qty_comp) * (1 - wo_yield_pct / 100)"
         "DEMAND" SCRAP_REQUIREMENT wo_site}

      /* UPDATE REPETITIVE SCHEDULE RECORD */
      assign
         rps_rel_date = wo_rel_date
         wo_recno     = recid(wo_mstr).

      /* CREATE WO ROUTING */
      /*tfq {gprun.i ""reworlc.p""} */
      /*tfq*/ {gprun.i ""yyreworlc.p""}  

      /* APPLY WIP QTIES TO WO ROUTING QTIES COMPLETED.  NOTE THAT   */
      /* THE  LARGER A WIP QTY IS AT AN OP THE MORE WE REDUCE DEMAND */
      /* FOR THE OP AND PREVIOUS OPS.                                */

      prior_open_qty = rps_qty_req - rps_qty_comp.

      for each wr_route
         where wr_lot = wo_lot
         exclusive-lock
         by wr_lot descending
         by wr_op  descending:

         assign
            wip_qty    = 0
            l_qad_key2 = key2 + string(wr_op).

         for first qad_wkfl
            where qad_key1 = "rps_mstr"
            and   qad_key2 = l_qad_key2
            exclusive-lock:
            wip_qty = qad_decfld[1].
         end. /* FOR FIRST qad_wkfl */

         assign
            qty_to_apply   = min(wip_qty,prior_open_qty)
            new_open_qty   = prior_open_qty - qty_to_apply
            wr_qty_comp    = wr_qty_ord - new_open_qty
            wip_qty        = wip_qty - qty_to_apply.

         if available qad_wkfl
         then
            qad_decfld[1] = wip_qty.

         prior_open_qty = new_open_qty.
         release qad_wkfl.

      end. /* FOR EACH wr_route */

      /* SCHEDULE WO ROUTING OPS */
      wo_recno = recid(wo_mstr).
      {gprun.i ""woworle.p""}

      /* EXPLODE ITEM TO GET COMPONENT LIST */
      assign
         site = rps_site
         comp = rps_part.

      /* IF AN ALTERNATE BOM IS BEING USED, USE THAT INSTEAD OF THE */
      /* PART FOR EXPLODE ITEM TO GET COMPONENT LIST.               */
      if rps_bom_code <> ""
      then
         comp = rps_bom_code.

      if site <> last_site
      or comp <> last_comp
      then do:
         /* COMPONENT EXPLOSION */
      /*tfq   {gprun.i ""rerpexb.p""} */
      /*tfq*/ {gprun.i ""yyrpexb.p""} 
      end. /* IF site <> last_site */

      assign
         last_site = rps_site
         last_comp = comp
         wo_recno  = recid(wo_mstr)
         pt_recno  = recid(pt_mstr).

      /* RECALCULATE COMPONENT DEMAND FOR MRP */
     /*tfq {gprun.i ""rerpexa.p""} */
     /*roger*/   {gprun.i ""yyrpexa.p""}

      release wo_mstr.

   end. /* IF rps_qty_req > rps_qty_comp */

   /* RESET SCHEDULE POINTER DATE IN QAD_WKFL RECORDS */
   /* AND RESET SCHEDULE CHANGED INDICATOR            */

   if last-of(rps_line)
   then do:

      for each qad_wkfl
         where qad_key1 = "rps_mstr"
         and   qad_key2 begins key2
         exclusive-lock:
         assign
            qad_datefld[1] = ?
            qad_charfld[1] = "y".
      end. /* FOR EACH qad_wkfl */
      release qad_wkfl.

   end. /* IF LAST-OF(rps_line) */

   /* PRINT IF NECESSARY */
   if report_yn
   then do:

      if first-of(rps_line)
      then
         display
            rps_part
            pt_desc1
            rps_site
            rps_line.

      qty_open = rps_qty_req - rps_qty_comp.

      display
         rps_rel_date
         rps_due_date
         rps_qty_req
         rps_qty_comp
         qty_open.

      if last-of(rps_line)
      then
         down 1.

      /* REPORT EXIT for paging INCLUDE FILE */
    /*tfq  {mfrpchk.i}  */
    /*tfq*/ {mfguichk.i}

   end. /* IF report_yn */

end. /* FOR EACH rps_mstr */

