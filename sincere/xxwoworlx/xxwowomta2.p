/* wowomta2.p - WORK ORDER MAINTENANCE SUBROUTINE                             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0      LAST MODIFIED: 11/12/91   BY: emb *F024*                */
/* REVISION: 7.0      LAST MODIFIED: 02/20/91   BY: emb *F216*                */
/* REVISION: 7.0      LAST MODIFIED: 08/24/92   BY: ram *F866*                */
/* REVISION: 7.3      LAST MODIFIED: 10/19/92   BY: emb *G208*                */
/* Revision: 7.3      LAST MODIFIED: 09/27/93   By: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: emb *G656*                */
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: emb *G870*                */
/* REVISION: 7.3      LAST MODIFIED: 02/15/94   BY: pxd *FL60*                */
/* REVISION: 7.2      LAST MODIFIED: 04/25/94   BY: ais *FN55*                */
/* REVISION: 7.2      LAST MODIFIED: 07/11/94   BY: ais *FO71*                */
/* REVISION: 7.2      LAST MODIFIED: 09/22/94   BY: qzl *FR72*                */
/* REVISION: 7.2      LAST MODIFIED: 01/26/95   BY: qzl *F0GG*                */
/* REVISION: 7.3      LAST MODIFIED: 02/15/95   BY: pxe *F0H7*                */
/* REVISION: 7.2      LAST MODIFIED: 12/11/95   BY: rvw *F0WM*                */
/* REVISION: 7.2      LAST MODIFIED: 03/21/96   BY: rvw *F0X4*                */
/* REVISION: 7.3      LAST MODIFIED: 06/18/96   BY: rvw *G1XY*                */
/* REVISION: 7.3      LAST MODIFIED: 10/03/96   BY: *G2GD* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 09/29/97   BY: *J1PS* Felcy D'Souza      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00   BY: *N0SX* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 11/06/00   BY: *N0TN* Jean Miller        */
/* Old ECO marker removed, but no ECO header exists *F003*                    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13  BY: Jyoti Thatte       DATE: 04/02/01 ECO: *P008*          */
/* Revision: 1.15  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N*          */
/* $Revision: 1.16 $  BY: Bhagyashri Shinde  DATE: 07/14/04 ECO: *P29X*          */
/* 100716.1  $  BY: mage chen  DATE: 07/16/10    ECO: *P45S*  */
/* 100727.1  $  BY: mage chen  DATE: 07/16/10    ECO: *P45S*  */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

         /*********************************************************/
         /* NOTES:   1. Patch FL60 sets in_level to a value       */
         /*             of 99999 when in_mstr is created or       */
         /*             when any structure or network changes are */
         /*             made that affect the low level codes.     */
         /*          2. The in_levels are recalculated when MRP   */
         /*             is run or can be resolved by running the  */
         /*             mrllup.p utility program.                 */
         /*********************************************************/

{mfdeclre.i}
{gplabel.i}

define shared workfile pkdet no-undo
   field pkpart like pk_part
   field pkop as integer
   field pkstart like pk_start
   field pkend like pk_end
   field pkqty like pk_qty
   field pkltoff like ps_lt_off.

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
define shared variable re-explode like mfc_logical no-undo.
define shared variable critical-part like wod_part no-undo.
define shared variable phantom-loop like mfc_logical no-undo.
define shared variable first-loop like mfc_logical no-undo.

define variable required like wod_qty_req.
define variable avail_qty like in_qty_avail.
define variable det_alloc like wod_qty_all.
define variable open_ref like mrp_qty.
define variable in_recno as recid.
define variable bypass-alloc like mfc_logical no-undo.

define buffer woddet for wod_det.

find wo_mstr where recid(wo_mstr) = wo_recno no-lock.

eff_date = wo_rel_date.

a2loop:
for each wod_det  where wod_det.wod_domain = global_domain and  wod_lot =
wo_lot no-lock:

   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = wod_part
   no-lock no-error.

   find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part =
   wod_part
                  and ptp_site = wod_site
   no-lock no-error.

   /* gpincr.p ROUTINE IS USED TO CREATE in_mstr RECORD. */
   find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
   wod_site no-lock no-error.

   {gprun.i ""gpincr.p""
      "(input no,
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

   find in_mstr  where in_mstr.in_domain = global_domain and  in_part =
   wod_part and
                      in_site = wod_site
   exclusive-lock.

   if index("C",prev_status) > 0
      and re-explode = no   /* (FIRST TIME THROUGH ONLY) */
      and first-loop
   then do:
      find in_mstr exclusive-lock where recid(in_mstr) = in_recno.
      if wod_qty_req >= 0 then
         in_qty_req = in_qty_req + max(wod_qty_req - wod_qty_iss,0).
      else
         in_qty_req = in_qty_req + min(wod_qty_req - wod_qty_iss,0).
   end.

   if phantom-loop
      and ((available ptp_det and not ptp_phantom)
      or (not available ptp_det and not pt_phantom)) then
      next.

   if (wo_type = "R" and wo_part = wod_part) then
      next.

   if wo_status = "A" or wo_status = "R" then do:

      find in_mstr  where in_mstr.in_domain = global_domain and  in_part =
      wod_part and in_site = wod_site
      exclusive-lock no-error.

      /*  DO NOT RESET ALLOCATION AMOUNT IF ROUTABLE ITEM AND WORK     */
      /*  ORDER HAS ALREADY BEEN RELEASED --  CHECK PTP_DET FIRST,     */
      /*  IF NOT FOUND, CHECK PT_MSTR TO SEE IF PART IS ROUTABLE ITEM. */
      bypass-alloc = no.

      if available ptp_det then do:
         if ptp_pm_code = "R" and index("AR",prev_status) > 0 then
            bypass-alloc = yes.
      end.
      else do:
         if available pt_mstr and pt_pm_code = "R" and
            index("AR",prev_status) > 0
         then
            bypass-alloc = yes.
      end.

      if not bypass-alloc then do:

         if wod_qty_req > 0
         then do for woddet:
            find woddet where recid(woddet) = recid(wod_det)exclusive-lock.
            in_qty_all = in_qty_all - wod_qty_all.
            for each lad_det  where lad_det.lad_domain = global_domain and
                     lad_dataset = "wod_det"
                 and lad_nbr = wod_lot and lad_line = string(wod_op)
                 and lad_part = wod_part
            no-lock:
               accumulate lad_qty_all (total).
            end.

            assign
               wod_qty_all = accum total (lad_qty_all)
               in_qty_all  = in_qty_all + wod_qty_all.

         end.

      end.

      assign
         required  = wod_qty_req - wod_qty_all - wod_qty_pick
                             - wod_qty_iss
         required  = max(required,0)
         avail_qty = required.

      if available pt_mstr then
      do for woddet:

         find woddet where recid(woddet) = recid(wod_det) exclusive-lock.

         if available ptp_det then do:

            if ptp_phantom and (wo_type <> "R" or wod_part <> wo_part) then
               avail_qty = max(in_qty_avail - in_qty_all,0).

            if ptp_pm_code = "R" then
               avail_qty = 0.

            if ptp_iss_pol = no then do:
               assign
                  avail_qty = 0.
               if wod_qty_iss = 0 and
                  index("AR",wo_status) > 0
               then do:

                  if index("E",prev_status) <> 0
                  then do:
                     in_qty_req = in_qty_req - wod_qty_req.
                     wod_qty_iss = wod_qty_req.
                  end.
                  else
                  if index("FP",prev_status) <> 0
                  then do:
                      wod_qty_iss = wod_qty_req.
                  end.

               end.

            end.

         end.

         else do:

            if pt_phantom and (wo_type <> "R" or wod_part <> wo_part) then
               avail_qty = max(in_qty_avail - in_qty_all,0).

            if pt_pm_code = "R" then
               avail_qty = 0.

            if pt_iss_pol = no then do:

               assign
                  avail_qty = 0.

               if wod_qty_iss = 0 and
                  index("AR",wo_status) > 0
               then do:
                  if index("E",prev_status) <> 0
                  then do:
                     in_qty_req = in_qty_req - wod_qty_req.
                     wod_qty_iss = wod_qty_req.
                  end.
                  else
                  if index("FP",prev_status) <> 0
                  then do:
                     wod_qty_iss = wod_qty_req.
                  end.
               end.

            end.

         end.

         find in_mstr exclusive-lock where recid(in_mstr) = in_recno.

         if wod_qty_req > 0
         then
            in_qty_all = in_qty_all + min(required,avail_qty).

      end.

      if wod_qty_req > 0
      then
         wod_qty_all = wod_qty_all + min(required,avail_qty).

   end.

   /* THIS EXCEPTION LOGIC IS INCORPORATED TO PREVENT ANY ALLOCATION      */
   /* (POSITIVE OR NEGATIVE) OF COMPONENTS WITH NEGATIVE REQUIREMENTS ON  */
   /*  A WORK ORDER                                                       */
   if wo_status       = "R"
      and wod_qty_req > 0
   then do:

      /* TOTAL CURRENTLY DETAIL ALLOCATED */
      det_alloc = 0.
      for each lad_det  where lad_det.lad_domain = global_domain and
               lad_dataset = "wod_det"
           and lad_nbr = wod_lot
           and lad_line = string(wod_op)
           and lad_part = wod_part
      no-lock:
         det_alloc = det_alloc + lad_qty_all + lad_qty_pick.
      end.

      gen_alloc = max(wod_qty_all + wod_qty_pick - det_alloc,0).

      /* TOTAL QUANTITY REMAINING TO DETAIL ALLOCATE */
      assign
         qty_to_all = max(max(wod_qty_req - wod_qty_iss,0) - det_alloc,0)
         det_alloc  = qty_to_all
         required = qty_to_all
         required = max(required,0)
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

/*ss - 10070727.1 - b*
            {gprun.i ""wopkall.p""}
*ss - 10070727.1 - e*/
/*ss - 10070727.1 - b*/
            {gprun.i ""xxwopkall.p""}
/*ss - 10070727.1 - e*/


            if wod_critical and qty_to_all <> 0 then do:
               critical-part = wod_part.
               undo_all = yes.
               undo a2loop, leave.
            end.

            find in_mstr exclusive-lock where recid(in_mstr) = in_recno.
            in_qty_all = in_qty_all + max(det_alloc - qty_to_all - gen_alloc,0).

         end.

      end.

      do for woddet:

         find woddet exclusive-lock where recid(woddet) = recid(wod_det).

         /* UPDATE QTY PICKED */
         for each lad_det  where lad_det.lad_domain = global_domain and
                  lad_dataset = "wod_det"
              and lad_nbr = wod_lot
            and lad_line = string(wod_op)
            and lad_part = wod_part
         no-lock:
            accumulate lad_qty_pick (total).
            accumulate lad_qty_all  (total).
         end.

         wod_qty_pick = accum total (lad_qty_pick).

         find in_mstr exclusive-lock where recid(in_mstr) = in_recno.
         in_qty_all = in_qty_all - wod_qty_all.

         if (available ptp_det and ptp_phantom)
         or (not available ptp_det and pt_phantom)
         then
            wod_qty_all = accum total (lad_qty_all).
         else
         if (available ptp_det and ptp_pm_code = "R")
         or (not available ptp_det and pt_pm_code = "R")
         then
            wod_qty_all = max(wod_qty_all,accum total (lad_qty_all)).

         in_qty_all = in_qty_all + wod_qty_all.

      end.

   end.

   {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

   if wod_qty_req >= 0 then
      open_ref = max(wod_qty_req - max(wod_qty_iss,0),0).
   else
      open_ref = min(wod_qty_req - min(wod_qty_iss,0),0).

   if wo_status = "C" then
      open_ref = 0.

   {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
      ? wod_iss_date open_ref "DEMAND" WORK_ORDER_COMPONENT wod_site}

end.
