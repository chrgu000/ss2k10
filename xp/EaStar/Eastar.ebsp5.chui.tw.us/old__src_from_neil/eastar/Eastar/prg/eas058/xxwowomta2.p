/* wowomta2.p - WORK ORDER MAINTENANCE SUBROUTINE                       */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.0     LAST MODIFIED: 11/12/91    BY: emb *F024*          */
/* REVISION: 7.0     LAST MODIFIED: 02/20/91    BY: emb *F216*          */
/* REVISION: 7.0     LAST MODIFIED: 08/24/92    BY: ram *F866*          */
/* REVISION: 7.3     LAST MODIFIED: 10/19/92    BY: emb *G208*          */
/* Revision: 7.3        Last edit: 09/27/93             By: jcd *G247* */
/* REVISION: 7.3     LAST MODIFIED: 02/08/93    BY: emb *G656*          */
/* REVISION: 7.3     LAST MODIFIED: 03/25/93    BY: emb *G870*          */
/* REVISION: 7.3     LAST MODIFIED: 02/15/94    BY: pxd *FL60*          */
/* REVISION: 7.2     LAST MODIFIED: 04/25/94    BY: ais *FN55*          */
/* REVISION: 7.2     LAST MODIFIED: 07/11/94    BY: ais *FO71*          */
/* REVISION: 7.2     LAST MODIFIED: 09/22/94    BY: qzl *FR72*          */
/* REVISION: 7.2     LAST MODIFIED: 01/26/95    BY: qzl *F0GG*          */
/* REVISION: 7.3     LAST MODIFIED: 02/15/95    BY: pxe *F0H7*          */
/* REVISION: 7.2     LAST MODIFIED: 12/11/95    BY: rvw *F0WM*          */
/* REVISION: 7.2     LAST MODIFIED: 03/21/96    BY: rvw *F0X4*          */
/* REVISION: 7.3     LAST MODIFIED: 06/18/96    BY: rvw *G1XY*          */
/* REVISION: 7.3     LAST MODIFIED: 10/03/96    BY: *G2GD* Murli Shastri  */
/* REVISION: 8.5     LAST MODIFIED: 09/29/97    BY: *J1PS* Felcy D'Souza  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown     */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00   BY: *N0SX* Jean Miller    */
/* REVISION: 9.1      LAST MODIFIED: 11/06/00   BY: *N0TN* Jean Miller    */
/* Revision: eB.SP5.Chui    Modified: 08/14/06  By: Kaine Zhang     *ss-20060818.1* */

         /*********************************************************/
         /* NOTES:   1. Patch FL60 sets in_level to a value       */
         /*             of 99999 when in_mstr is created or      */
         /*             when any structure or network changes are */
         /*             made that affect the low level codes.     */
         /*          2. The in_levels are recalculated when MRP   */
         /*             is run or can be resolved by running the  */
         /*             mrllup.p utility program.                 */
         /*********************************************************/

         {mfdeclre.i}
/*N0SX*/ {gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

/*N0SX* &SCOPED-DEFINE wowomta2_p_1 "Work Order Component" */
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         define shared workfile pkdet no-undo
            field pkpart like pk_part
/*G656*/    field pkop as integer
            field pkstart like pk_start
            field pkend like pk_end
            field pkqty like pk_qty
            field pkltoff like ps_lt_off.

/*       define shared variable mfguser as character.           *G247* */

         define shared variable comp like ps_comp.
         define shared variable qty like wo_qty_ord decimals 10.
         define shared variable eff_date as date.
         define shared variable wo_recno as recid.
         define shared variable leadtime like pt_mfg_lead.
         define shared variable prev_status like wo_status.
         define shared variable prev_release like wo_rel_date.
         define shared variable prev_due like wo_due_date.
         define shared variable prev_qty like wo_qty_ord.
         define shared variable del-yn like mfc_logical.
         define shared variable deliv like wod_deliver.
         define shared variable any_issued like mfc_logical.
         define shared variable wod_recno as recid.
         define shared variable prev_site like wo_site.
         define shared variable qty_to_all like wod_qty_all.
         define shared variable gen_alloc  like wod_qty_all.
         define shared variable undo_all like mfc_logical no-undo.

         define variable required like wod_qty_req.
         define variable avail_qty like in_qty_avail.
         define variable det_alloc like wod_qty_all.
/*G208*/ define variable open_ref like mrp_qty.
/*G870*/ define shared variable re-explode like mfc_logical no-undo.
/*G1XY*/ define shared variable critical-part like wod_part no-undo.
/*G870*/ define shared variable phantom-loop like mfc_logical no-undo.
/*G870*/ define shared variable first-loop like mfc_logical no-undo.
/*G870*/ define buffer woddet for wod_det.
/*G870*/ define variable in_recno as recid.
/*F0WM*/ define variable bypass-alloc like mfc_logical no-undo.

         find wo_mstr
/*G870*/ no-lock
         where recid(wo_mstr) = wo_recno.

         eff_date = wo_rel_date.

/*F003*/ a2loop:
         for each wod_det
/*G870*/ no-lock
         where wod_lot = wo_lot:

/*FR72*/ /*******************************
/*FN55*/ .* find first pk_det where pk_user = mfguser + "WOWOMTA1" and
/*FN55*/ .*                         pk_lot  = wod_lot and
/*FN55*/ .*                         pk_part = wod_part no-error.
/*FN55*/ .* if not available pk_det then do:
/*FN55*/ .*    create pk_det.
/*FN55*/ .*    assign pk_user = mfguser + "WOWOMTA1"
/*FN55*/ .*           pk_part = wod_part
/*FN55*/ .*           pk_lot = wod_lot
/*FN55*/ .*           pk_qty = ?.
/*FN55*/ .* end.        ********************************************/

            find pt_mstr where pt_part = wod_part
            no-lock no-error.

            find ptp_det no-lock where ptp_part = wod_part
            and ptp_site = wod_site no-error.

/*G870*     find in_mstr where in_part = wod_part and in_site = wod_site
            exclusive no-error. */

/*J1PS** BEGIN DELETE */
/*J1PS*  FOLLOWING CODE IS COMMENTED OUT SINCE GPINCR.P ROUTINE IS USED */
/*       IN THE CREATION OF IN_MSTR RECORD. ALSO, IN_MSTR RECORD IS     */
/*       FOUND IN GPINCR.P ROUTINE BEFORE THE CREATION.                 */
/*J1PS** /*G870*/    find in_mstr no-lock where in_part = wod_part
 * /*G870*/    and in_site = wod_site no-error.
 *          if not available in_mstr then do:
 *             create in_mstr.
 *             assign
 *                in_part = wod_part
 *                in_site = wod_site.
 * /*FL60*/       in_level = 99999.
 *J1PS** END DELETE */

/*FL60         if available ptp_det then do:
*                 if ptp_pm_code = "D"
*                 then in_level = ptp_ll_drp.
*                 else in_level = ptp_ll_bom.
*              end.
*              else if pt_pm_code <> "D"
*                 then in_level = pt_ll_code.           FL60*/

/*J1PS** BEGIN DELETE */
/*J1PS** FOLLOWING CODE IS COMMENTED OUT SINCE PT_MSTR AND SI_MSTR VALUES */
/*       ARE PASSED TO GPINCR.P ROUTINE BELOW WHICH WILL BE USED DURING   */
/*       THE CREATION OF IN_MSTR.                                         */
/*J1PS** /*F003*/ find si_mstr where si_site = in_site no-lock no-error.
 * /*F003*/       if available si_mstr
 * /*F003*/       then assign in_gl_set = si_gl_set in_cur_set = si_cur_set.
 * /*F003*/       if available pt_mstr
 * /*F003*/       then assign in_abc = pt_abc in_avg_int = pt_avg_int
 * /*F003*/          in_cyc_int = pt_cyc_int.
 *          end.
 *J1PS** END DELETE */

/*J1PS*     BEGIN OF ADDED CODE */
/*J1PS*     gpincr.p ROUTINE IS USED TO CREATE in_mstr RECORD. */

            find si_mstr where si_site = wod_site no-lock no-error.

            {gprun.i ""gpincr.p"" "(input no,
                                    input wod_part,
                                    input wod_site,
                                    input if available si_mstr then
                                              si_gl_set
                                          else """",
                                    input if available si_mstr then
                                              si_cur_set
                                          else """",
                                    input if available pt_mstr then
                                              pt_abc
                                          else """",
                                    input if available pt_mstr then
                                              pt_avg_int
                                          else 0,
                                    input if available pt_mstr then
                                              pt_cyc_int
                                          else 0,
                                    input if available pt_mstr then
                                              pt_rctpo_status
                                          else """",
                                    input if available pt_mstr then
                                              pt_rctpo_active
                                          else no,
                                    input if available pt_mstr then
                                              pt_rctwo_status
                                          else """",
                                    input if available pt_mstr then
                                              pt_rctwo_active
                                          else no,
                                    output in_recno)" }

            find in_mstr where in_part = wod_part and
                               in_site = wod_site
                               exclusive-lock.

/*J1PS*  END OF ADDED CODE */

/*J1PS** /*G870*/    in_recno = recid(in_mstr).  */

            if index("C",prev_status) > 0
/*G870*/    and re-explode = no   /* (First time through only) */
/*G870*/    and first-loop
            then do:

/*G870*/       find in_mstr exclusive-lock where recid(in_mstr) = in_recno.
               if wod_qty_req >= 0 then
                  in_qty_req = in_qty_req + max(wod_qty_req - wod_qty_iss,0).
               else
                  in_qty_req = in_qty_req + min(wod_qty_req - wod_qty_iss,0).
            end.

/*G870*/    if phantom-loop
/*G870*/    and ((available ptp_det and not ptp_phantom)
/*G870*/    or (not available ptp_det and not pt_phantom)) then next.
/*F0X4*/    if (wo_type = "R" and wo_part = wod_part) then next.

            if wo_status = "A" or wo_status = "R" then do:
/*F216*/       find in_mstr where in_part = wod_part and in_site = wod_site
/*F216*/       exclusive-lock no-error.
/*F0WM*/   /*  DO NOT RESET ALLOCATION AMOUNT IF ROUTABLE ITEM AND WORK     */
/*F0WM*/   /*  ORDER HAS ALREADY BEEN RELEASED --  CHECK PTP_DET FIRST,     */
/*F0WM*/   /*  IF NOT FOUND, CHECK PT_MSTR TO SEE IF PART IS ROUTABLE ITEM. */
/*F0WM*/       bypass-alloc = no.
/*F0WM*/       if available ptp_det then do:
/*F0WM*/          if ptp_pm_code = "R" and index("AR",prev_status) > 0 then
/*F0WM*/          bypass-alloc = yes.
/*F0WM*/       end.
/*F0WM*/       else do:
/*F0WM*/          if available pt_mstr and pt_pm_code = "R" and
/*F0WM*/          index("AR",prev_status) > 0 then
/*F0WM*/          bypass-alloc = yes.
/*F0WM*/       end.
/*F0WM*/       if not bypass-alloc then do:
/*F0H7*/          if wod_qty_req >= 0 then do for woddet:
/*F0H7*/               find woddet exclusive-lock
/*F0H7*/                   where recid(woddet) = recid(wod_det).
/*F0H7*/               in_qty_all = in_qty_all - wod_qty_all.
/*F0H7*/               for each lad_det no-lock where lad_dataset = "wod_det"
/*F0H7*/                   and lad_nbr = wod_lot and lad_line = string(wod_op)
/*F0H7*/                   and lad_part = wod_part :
/*F0H7*/                   accumulate lad_qty_all (total).
/*F0H7*/               end.
/*F0H7*/               wod_qty_all = accum total (lad_qty_all).
/*F0H7*/               in_qty_all = in_qty_all + wod_qty_all.
/*F0H7*/          end.
/*F0WM*/       end.
               required = wod_qty_req - wod_qty_all - wod_qty_pick
                        - wod_qty_iss.
/*F0H7         if wod_qty_req >= 0
 *             then *F0H7*/ required = max(required,0).
/*F0H7         else required = min(required,0). */
               avail_qty = required.
/*G870*        if available pt_mstr then do: */
/*G870*/       if available pt_mstr then do for woddet:
/*G870*/          find woddet exclusive-lock
                              where recid(woddet) = recid(wod_det).
                  if available ptp_det then do:
                     if ptp_phantom
                     and (wo_type <> "R" or wod_part <> wo_part) then
                        avail_qty = max(in_qty_avail - in_qty_all,0).
                     if ptp_pm_code = "R" then avail_qty = 0.
/*FO71*              if ptp_iss_pol = no then                       */
/*FO71*                 assign avail_qty = 0                        */
/*FO71*                      wod_qty_iss = wod_qty_req.             */
/*FO71*/             if ptp_iss_pol = no
/*FO71*/             then do:
/*FO71*/                assign avail_qty = 0.
/*FO71*/                if wod_qty_iss = 0 and
/*FO71*/                   index("AR",wo_status) > 0
/*FO71*/                then do:
/*FO71*/                   if index("E",prev_status) <> 0
/*FO71*/                   then do:
/*FO71*/                      in_qty_req = in_qty_req - wod_qty_req.
/*FO71*/                      wod_qty_iss = wod_qty_req.
/*FO71*/                   end.
/*F0GG* /*FO71*/           else if index("F",prev_status) <> 0  */
/*F0GG*/                   else if index("FP",prev_status) <> 0
/*FO71*/                   then do:
/*FO71*/                      wod_qty_iss = wod_qty_req.
/*FO71*/                   end.
/*FO71*/                end.
/*FO71*/             end.
                  end.
                  else do:
                     if pt_phantom
                     and (wo_type <> "R" or wod_part <> wo_part) then
                        avail_qty = max(in_qty_avail - in_qty_all,0).
                     if pt_pm_code = "R" then avail_qty = 0.
/*FO71*              if pt_iss_pol = no then                        */
/*FO71*                 assign avail_qty = 0                        */
/*FO71*                      wod_qty_iss = wod_qty_req.             */
/*FO71*/             if pt_iss_pol = no
/*FO71*/             then do:
/*FO71*/                assign avail_qty = 0.
/*FO71*/                if wod_qty_iss = 0 and
/*FO71*/                   index("AR",wo_status) > 0
/*FO71*/                then do:
/*FO71*/                   if index("E",prev_status) <> 0
/*FO71*/                   then do:
/*FO71*/                      in_qty_req = in_qty_req - wod_qty_req.
/*FO71*/                      wod_qty_iss = wod_qty_req.
/*FO71*/                   end.
/*F0GG* /*FO71*/           else if index("F",prev_status) <> 0  */
/*F0GG*/                   else if index("FP",prev_status) <> 0
/*FO71*/                   then do:
/*FO71*/                      wod_qty_iss = wod_qty_req.
/*FO71*/                   end.
/*FO71*/                end.
/*FO71*/             end.
                  end.

/*G870*/          find in_mstr exclusive-lock where recid(in_mstr) = in_recno.
/*G870*/          if wod_qty_req >= 0 then
                     in_qty_all = in_qty_all + min(required,avail_qty).
/*F0H7*  /*G870*/        else in_qty_all = in_qty_all + max(required,avail_qty).
 */
               end.
/*G870*/       if wod_qty_req >= 0 then
               wod_qty_all = wod_qty_all + min(required,avail_qty).
/*F0H7* /*G870*/       else wod_qty_all = wod_qty_all + max(required,avail_qty).
 */
            end.

/*G2GD*     if wo_status = "R" then do: */
/*G2GD*     THIS EXCEPTION LOGIC HAS BEEN INCORPORATED TO PREVENT ANY ALLOCATION
            (POSITIVE OR NEGATIVE) OF COMPONENTS WITH NEGATIVE REQUIREMENTS ON
            A WORK ORDER */
/*G2GD*/    if wo_status = "R"
/*G2GD*/    and wod_qty_req >= 0
/*G2GD*/    then do:

               /* TOTAL CURRENTLY DETAIL ALLOCATED */
               det_alloc = 0.
               for each lad_det where lad_dataset = "wod_det"
/*G656*        and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/       and lad_nbr = wod_lot and lad_line = string(wod_op)
               and lad_part = wod_part no-lock:
                  det_alloc = det_alloc + lad_qty_all + lad_qty_pick.
               end.
               gen_alloc = max(wod_qty_all + wod_qty_pick - det_alloc,0).

               /* TOTAL QUANTITY REMAINING TO DETAIL ALLOCATE */
               qty_to_all = max(max(wod_qty_req - wod_qty_iss,0)
                           - det_alloc,0).
               det_alloc  = qty_to_all.

               required = qty_to_all.
/*F0H7         if wod_qty_req >= 0
               then */ required = max(required,0).
/*F0H7         else required = min(required,0). */
               avail_qty = required.
               if available pt_mstr then do:

                  /* CREATE HARD ALLOCATIONS */
                  if qty_to_all <> 0
                  and (available ptp_det
                  and ptp_pm_code <> "R" and ptp_iss_pol = yes)
                  or (not available ptp_det
                  and pt_pm_code <> "R" and pt_iss_pol = yes)
                  then do:
                     wod_recno = recid(wod_det).
                     /*ss-20060818.1*  {gprun.i ""wopkall.p""}  */
                     /*ss-20060818.1*/ {gprun.i ""xxwopkall.p""}
                     if wod_critical and qty_to_all <> 0 then do:
/*G1XY*/                critical-part = wod_part.
                        undo_all = yes.
/*F003                  undo alloc-loop, leave. */
/*F003*/                undo a2loop, leave.
                     end.
/*G870*/             find in_mstr exclusive-lock
                          where recid(in_mstr) = in_recno.
                     in_qty_all = in_qty_all
                        + max(det_alloc - qty_to_all - gen_alloc,0).
                  end.
               end.

/*G870*/       do for woddet:
/*G870*/          find woddet exclusive-lock
                       where recid(woddet) = recid(wod_det).

                  /* UPDATE QTY PICKED */
                  for each lad_det no-lock where lad_dataset = "wod_det"
/*G656*           and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/          and lad_nbr = wod_lot and lad_line = string(wod_op)
                  and lad_part = wod_part:
                     accumulate lad_qty_pick (total).
                     accumulate lad_qty_all  (total).
                  end.
                  wod_qty_pick = accum total (lad_qty_pick).

/*G870*/          find in_mstr exclusive-lock where recid(in_mstr) = in_recno.
/*F866*/          in_qty_all = in_qty_all - wod_qty_all.

                  if (available ptp_det and ptp_phantom)
                  or (not available ptp_det and pt_phantom)
                  then
                     wod_qty_all = accum total (lad_qty_all).
                  else if (available ptp_det and ptp_pm_code = "R")
                  or (not available ptp_det and pt_pm_code = "R")
                  then wod_qty_all = max(wod_qty_all,accum total (lad_qty_all)).
/*F0H7
 *                else
 *                wod_qty_all = max(wod_qty_req - wod_qty_pick
 *                            - wod_qty_iss,0).
 *F0H7*/
/*F866*/          in_qty_all = in_qty_all + wod_qty_all.
/*G870*/       end.
            end.

/*G208*/       {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

/*G208*/    if wod_qty_req >= 0
/*G208*/    then open_ref = max(wod_qty_req - max(wod_qty_iss,0),0).
/*G208*/    else open_ref = min(wod_qty_req - min(wod_qty_iss,0),0).

            if wo_status = "C" then open_ref = 0.

/*N0TN*/    /* Replaced pre-processor with Term in include */
/*G208*/    {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
            ? wod_iss_date open_ref "DEMAND" WORK_ORDER_COMPONENT wod_site}

/*FR72*/ /******************************************
/*FN55*/    find first pk_det where pk_user = mfguser + "WOWOMTA1" and
/*FN55*/                            pk_lot  = wod_lot and
/*FN55*/                            pk_part = wod_part no-error.
/*FN55*/    if available pk_det
/*FN55*/    then pk_qty = wod_qty_req - wod_qty_all - wod_qty_pick. ******/
         end.
