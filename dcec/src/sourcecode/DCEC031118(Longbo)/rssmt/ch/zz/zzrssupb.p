/* GUI CONVERTED from rssupb.p (converter v1.69) Sat Mar 30 01:22:14 1996 */
/* rssupb.p - Release Management Supplier Schedules                     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3    LAST MODIFIED: 11/02/93           BY: WUG *GG88*    */
/* REVISION: 7.3    LAST MODIFIED: 01/24/94           BY: WUG *GI51*    */

/* SCHEDULE UPDATE SUBROUTINE - DELETE WORK ORDER DATA SELECTED FOR FIRM */

{mfdeclre.i} /*GUI moved to top.*/
def input param firm_end_date as date.

def shared workfile work_schd like schd_det.  /*GG27 workfiles last */

/*GUI moved mfdeclre/mfdtitle.*/
def var work_qty as dec.
def var ord_chg as dec.

for each work_schd no-lock
where schd_date <= firm_end_date,
each wo_mstr exclusive where wo_lot = schd__chr01:
/*GUI*/ if global-beam-me-up then undo, leave.

   work_qty = min(wo_qty_ord, schd_discr_qty).

   ord_chg = (wo_qty_ord - work_qty) / wo_qty_ord.

   wo_qty_ord = wo_qty_ord - work_qty.

   {mfmrw.i "wo_mstr" wo_part wo_nbr wo_lot """"
   wo_rel_date wo_due_date
   wo_qty_ord "SUPPLYP" "计划加工单" wo_site}


   /* USUALLY THE FOLLOWING WONT DO ANYTHING
   BECAUSE THERE PROBABLY WONT BE ANY COMPONENTS */

   for each wr_route exclusive where wr_lot = wo_lot:
      wr_qty_ord = wr_qty_ord * ord_chg.
      if ord_chg = 0 then delete wr_route.
   end.

   for each wod_det exclusive where wod_lot = wo_lot:
/*GUI*/ if global-beam-me-up then undo, leave.

      wod_qty_req = wod_qty_req * ord_chg.

      {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

      {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
      ? wod_iss_date wod_qty_req "DEMAND" "加工单子零件" wod_site}

      {inmrp.i &part=wod_part &site=wod_site}

      if ord_chg = 0 then delete wod_det.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.


   {inmrp.i &part=wo_part &site=wo_site}

   if ord_chg = 0 then do:
      {mfmrwdel.i "wo_scrap" wo_part wo_nbr wo_lot """"}        /*FH49*/
      delete wo_mstr.
   end.
end.
/*GUI*/ if global-beam-me-up then undo, leave.

